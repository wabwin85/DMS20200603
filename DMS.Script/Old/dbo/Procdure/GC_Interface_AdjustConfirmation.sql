DROP Procedure [dbo].[GC_Interface_AdjustConfirmation]
GO

/*
平台退货确认数据处理
*/
CREATE Procedure [dbo].[GC_Interface_AdjustConfirmation]
	@BatchNbr NVARCHAR(30),
	@ClientID NVARCHAR(50),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(MAX) OUTPUT
AS
	DECLARE @SysUserId uniqueidentifier
	DECLARE @SystemHoldWarehouse uniqueidentifier
	DECLARE @DealerId uniqueidentifier
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	--经销商主键
	SELECT @DealerId = CLT_Corp_Id FROM Client WHERE CLT_ID = @ClientID
	--在途库主键
	SELECT @SystemHoldWarehouse = WHM_ID FROM Warehouse WHERE WHM_DMA_ID = @DealerId AND WHM_Type = 'SystemHold'
	
	--从接口表中插入数据（根据退货单号查询LP自己的退货单据）
	INSERT INTO AdjustConfirmation (AC_ID,AC_AdjustNo,AC_ConfirmDate,AC_IsConfirm,AC_Remark,AC_LineNbr,AC_FileName,
		AC_IAH_ID,AC_ProblemDescription,AC_HandleDate,AC_ImportDate,AC_ClientID,AC_BatchNbr)
	SELECT IAC_ID,IAC_AdjustNo,IAC_ConfirmDate,IAC_IsConfirm,IAC_Remark,IAC_LineNbr,IAC_FileName,IAH_ID,
		CASE WHEN IAH_ID IS NULL THEN '退货单未关联'
			WHEN IAH_ID IS NOT NULL AND IAH_Status <> 'Accept' THEN '退货单状态无效'
			ELSE NULL END,GETDATE(),GETDATE(),IAC_ClientID,IAC_BatchNbr
	FROM InterfaceAdjustConfirmation I
    LEFT OUTER JOIN InventoryAdjustHeader IAH ON IAH.IAH_Inv_Adj_Nbr = I.IAC_AdjustNo AND IAH.IAH_Reason = 'Return' AND IAH.IAH_DMA_ID = @DealerId
	WHERE IAC_BatchNbr = @BatchNbr

	--AC_ProblemDescription为空的数据，即需要完成退货的单据
	--更新退货单的状态Cancelled和Complete
	UPDATE InventoryAdjustHeader SET IAH_Status = (CASE WHEN AC_IsConfirm = 1 THEN 'Complete' ELSE 'Cancelled' END)
	FROM AdjustConfirmation AC WHERE AC_ProblemDescription IS NULL 
	AND InventoryAdjustHeader.IAH_ID = AC.AC_IAH_ID
	AND AC_BatchNbr = @BatchNbr

	--记录单据操作日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),AC_IAH_ID,@SysUserId,GETDATE(),(CASE WHEN AC_IsConfirm = 1 THEN 'Confirm' ELSE 'Cancel' END),NULL
	FROM AdjustConfirmation WHERE AC_ProblemDescription IS NULL AND AC_BatchNbr = @BatchNbr

	--AC_IsConfirm=1完成退货操作，库存从中间库中移出
	--AC_IsConfirm=0取消退货操作，库存从中间库中移出，移回原仓库
	/*库存临时表*/
	create table #tmp_inventory(
	INV_ID uniqueidentifier,
	INV_WHM_ID uniqueidentifier,
	INV_PMA_ID uniqueidentifier,
	INV_OnHandQuantity float
	primary key (INV_ID)
	)

	/*库存明细Lot临时表*/
	create table #tmp_lot(
	LOT_ID uniqueidentifier,
	LOT_LTM_ID uniqueidentifier,
	LOT_WHM_ID uniqueidentifier,
	LOT_PMA_ID uniqueidentifier,
	LOT_INV_ID uniqueidentifier,
	LOT_OnHandQty float,
	LOT_LotNumber nvarchar(50),
	primary key (LOT_ID)
	)

	/*库存日志临时表*/
	create table #tmp_invtrans(
	ITR_Quantity         float,
	ITR_ID               uniqueidentifier,
	ITR_ReferenceID      uniqueidentifier,
	ITR_Type             nvarchar(50)         collate Chinese_PRC_CI_AS,
	ITR_WHM_ID           uniqueidentifier,
	ITR_PMA_ID           uniqueidentifier,
	ITR_UnitPrice        float,
	ITR_TransDescription nvarchar(200)        collate Chinese_PRC_CI_AS,
	primary key (ITR_ID)
	)
	/*库存明细Lot日志临时表*/
	create table #tmp_invtranslot(
	ITL_Quantity         float,
	ITL_ID               uniqueidentifier,
	ITL_ITR_ID           uniqueidentifier,
	ITL_LTM_ID           uniqueidentifier,
	ITL_LotNumber        nvarchar(50)         collate Chinese_PRC_CI_AS,
	ITL_ReferenceID      uniqueidentifier,
	primary key (ITL_ID)
	)	

	--如果以后速度慢，可以将退货单表头、行和批次信息都先存入临时表
	--Inventory表，移出中间库,库存扣减
	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
	SELECT -A.QTY,NEWID(),@SystemHoldWarehouse,A.PMA_ID
	FROM 
	(
	SELECT IAD.IAD_PMA_ID AS PMA_ID, SUM(IAL.IAL_LotQty) AS QTY
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	WHERE IAH.IAH_ID IN (SELECT AC_IAH_ID FROM AdjustConfirmation AC
	WHERE AC_ProblemDescription IS NULL AND AC_BatchNbr = @BatchNbr)
	GROUP BY IAD.IAD_PMA_ID
	) AS A
	
	--Inventory表，AC_IsConfirm=0取消退货操作，移回原仓库，库存增加
	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
	SELECT A.QTY,NEWID(),A.WHM_ID,A.PMA_ID
	FROM 
	(
	SELECT IAD.IAD_PMA_ID AS PMA_ID,IAL.IAL_WHM_ID AS WHM_ID, SUM(IAL.IAL_LotQty) AS QTY
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	WHERE IAH.IAH_ID IN (SELECT AC_IAH_ID FROM AdjustConfirmation AC
	WHERE AC_ProblemDescription IS NULL AND AC_IsConfirm = 0 AND AC_BatchNbr = @BatchNbr)
	GROUP BY IAD.IAD_PMA_ID,IAL.IAL_WHM_ID
	) AS A
	
	--更新库存表，存在的更新，不存在的新增
	UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)+Convert(decimal(18,6),TMP.INV_OnHandQuantity)
	FROM #tmp_inventory AS TMP
	WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
	AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

	INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
	SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID
	FROM #tmp_inventory AS TMP	
	WHERE NOT EXISTS (SELECT 1 FROM Inventory INV WHERE INV.INV_WHM_ID = TMP.INV_WHM_ID
	AND INV.INV_PMA_ID = TMP.INV_PMA_ID)	

	--Lot表，移出中间库,库存扣减
	INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
	SELECT NEWID(),A.LOT_LTM_ID,@SystemHoldWarehouse,A.PMA_ID,A.LOT_LotNumber,-A.QTY
	FROM 
	(
	SELECT IAD.IAD_PMA_ID AS PMA_ID, Lot.LOT_LTM_ID, IAL.IAL_LotNumber AS LOT_LotNumber, SUM(IAL.IAL_LotQty) AS QTY
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Lot ON Lot.LOT_ID = IAL.IAL_LOT_ID
	WHERE IAH.IAH_ID IN (SELECT AC_IAH_ID FROM AdjustConfirmation AC
	WHERE AC_ProblemDescription IS NULL AND AC_BatchNbr = @BatchNbr)
	GROUP BY IAD.IAD_PMA_ID, Lot.LOT_LTM_ID, IAL.IAL_LotNumber
	) AS A
	
	--Lot表，AC_IsConfirm=0取消退货操作，移回原仓库，库存增加
	INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
	SELECT NEWID(),A.LOT_LTM_ID,A.WHM_ID,A.PMA_ID,A.LOT_LotNumber,A.QTY
	FROM 
	(
	SELECT IAD.IAD_PMA_ID AS PMA_ID, IAL.IAL_WHM_ID AS WHM_ID, Lot.LOT_LTM_ID, IAL.IAL_LotNumber AS LOT_LotNumber, SUM(IAL.IAL_LotQty) AS QTY
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Lot ON Lot.LOT_ID = IAL.IAL_LOT_ID
	WHERE IAH.IAH_ID IN (SELECT AC_IAH_ID FROM AdjustConfirmation AC
	WHERE AC_ProblemDescription IS NULL AND AC_IsConfirm = 0 AND AC_BatchNbr = @BatchNbr)
	GROUP BY IAD.IAD_PMA_ID, IAL.IAL_WHM_ID, Lot.LOT_LTM_ID, IAL.IAL_LotNumber
	) AS A
	
	--更新关联库存主键
	UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
	FROM Inventory INV 
	WHERE INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
	AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

	--更新批次表，存在的更新，不存在的新增
	UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,6),Lot.LOT_OnHandQty)+Convert(decimal(18,6),TMP.LOT_OnHandQty)
	FROM #tmp_lot AS TMP
	WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

	INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
	SELECT LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID 
	FROM #tmp_lot AS TMP
	WHERE NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)
	
	--Inventory操作日志，移出中间库
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT -IAL.IAL_LotQty,NEWID(),IAL.IAL_ID,'库存调整：退货',@SystemHoldWarehouse,IAD.IAD_PMA_ID,0,'库存调整类型：Return。从中间库移出。'
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	WHERE IAH.IAH_ID IN (SELECT AC_IAH_ID FROM AdjustConfirmation AC
	WHERE AC_ProblemDescription IS NULL AND AC_BatchNbr = @BatchNbr)

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志，移出中间库
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ReferenceID)
	SELECT -IAL.IAL_LotQty,NEWID(),Lot.LOT_LTM_ID,IAL.IAL_LotNumber,IAL.IAL_ID
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Lot ON Lot.LOT_ID = IAL.IAL_LOT_ID
	WHERE IAH.IAH_ID IN (SELECT AC_IAH_ID FROM AdjustConfirmation AC
	WHERE AC_ProblemDescription IS NULL AND AC_BatchNbr = @BatchNbr)

	UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
	FROM #tmp_invtrans a 
	WHERE a.ITR_ReferenceID = #tmp_invtranslot.ITL_ReferenceID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot

	--清空日志数据
	DELETE FROM #tmp_invtrans
	DELETE FROM #tmp_invtranslot

	--Inventory操作日志，移回原仓库
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT IAL.IAL_LotQty,NEWID(),IAL.IAL_ID,'库存调整：退货',IAL.IAL_WHM_ID,IAD.IAD_PMA_ID,0,'库存调整类型：Return。移回原仓库。'
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	WHERE IAH.IAH_ID IN (SELECT AC_IAH_ID FROM AdjustConfirmation AC
	WHERE AC_ProblemDescription IS NULL AND AC_IsConfirm = 0 AND AC_BatchNbr = @BatchNbr)

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志，移回原仓库
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ReferenceID)
	SELECT IAL.IAL_LotQty,NEWID(),Lot.LOT_LTM_ID,IAL.IAL_LotNumber,IAL.IAL_ID
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Lot ON Lot.LOT_ID = IAL.IAL_LOT_ID
	WHERE IAH.IAH_ID IN (SELECT AC_IAH_ID FROM AdjustConfirmation AC
	WHERE AC_ProblemDescription IS NULL AND AC_IsConfirm = 0 AND AC_BatchNbr = @BatchNbr)

	UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
	FROM #tmp_invtrans a 
	WHERE a.ITR_ReferenceID = #tmp_invtranslot.ITL_ReferenceID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
	
	--记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH
GO


