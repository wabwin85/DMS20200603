DROP PROCEDURE [interface].[P_I_EW_ReturnApplicationApproval]	
GO

CREATE PROCEDURE [interface].[P_I_EW_ReturnApplicationApproval]	
	@ReturnNo NVARCHAR(30),
	@ApprovalStatus NVARCHAR(30),
    @ApproveUser NVARCHAR(50),
    @ApproveDate NVARCHAR(50),
    @ApproveNote NVARCHAR(1000),
    @NoteId  NVARCHAR(50),
    @ReturnValue NVARCHAR(100) OUTPUT
AS
DECLARE @idoc int
	DECLARE @SysUserId uniqueidentifier
	DECLARE @SystemHoldWarehouse uniqueidentifier
	DECLARE @DealerId uniqueidentifier
	DECLARE @OrderId uniqueidentifier
	DECLARE @DealerType nvarchar(5)
	DECLARE @BatchNbr NVARCHAR(30)
	DECLARE @OrderType NVARCHAR(50)
SET NOCOUNT ON
BEGIN TRY
	SET @BatchNbr = ''
	EXEC dbo.GC_GetNextAutoNumberForInt 'SYS','P_I_EW_ReturnApplicationApproval',@BatchNbr OUTPUT
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
BEGIN TRAN
	--判断单据状态是否已经被修改
	IF EXISTS(SELECT 1 FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr =@ReturnNo AND IAH_Reason IN ('Return','Transfer','Exchange') AND (IAH_Status = 'Submitted' or  IAH_Status='InWorkflow'))
	 BEGIN
	
	  SELECT @OrderId = IAH_ID,@DealerId = IAH_DMA_ID,@OrderType = IAH_Reason FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr = @ReturnNo AND IAH_Reason IN ('Return','Transfer','Exchange') AND (IAH_Status = 'Submitted' or IAH_Status='InWorkflow')
	 END
	ELSE 
	 BEGIN
	 
		RAISERROR ('退货单号不存在或单据已被处理',16,1);
	 END
	--经销商在途库主键
	SELECT @SystemHoldWarehouse = WHM_ID FROM Warehouse WHERE WHM_DMA_ID = @DealerId AND WHM_Type = 'SystemHold'
	--获得经销商类型
	SELECT @DealerType = DMA_DealerType FROM DealerMaster WHERE DMA_ID = @DealerId
	
	--如果审批状态是审批通过或审批拒绝改变单据状态
	--IF(@ApprovalStatus='Accept' or @ApprovalStatus='Reject')
	 -- BEGIN
	   UPDATE InventoryAdjustHeader 
        SET IAH_Status =CASE WHEN @ApprovalStatus='Accept' and IAH_Reason<>'Transfer' THEN 'EWFApprove' ELSE @ApprovalStatus END
	   WHERE IAH_ID = @OrderId
	 -- END
	--记录单据日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),CASE WHEN @ApprovalStatus='Accept' THEN 'Approve' WHEN @ApprovalStatus='InWorkflow' THEN 'Approve' ELSE @ApprovalStatus END,'审批人:'+@ApproveUser+'在'+CONVERT(varchar(100), @ApproveDate, 20)+'时审批了该订单。'+isnull(@ApproveNote,'')+@NoteId)

	--将退货单批次明细插入临时表（更新退货数量默认0，0即表示取消退货）
	SELECT IAL.IAL_ID,IAL.IAL_LOT_ID,IAL.IAL_WHM_ID,IAL.IAL_LotNumber,IAD.IAD_PMA_ID,
	Lot.LOT_LTM_ID,IAL.IAL_LotQty,WHM.WHM_Code,WHM.WHM_Name,Product.PMA_UPN, 0 AS IAL_LotQtyNew,
	IAD.IAD_ID,IAL.IAL_UnitPrice
	INTO #TMP_DETAIL
  	FROM InventoryAdjustHeader IAH
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_IAH_ID = IAH.IAH_ID 
	INNER JOIN InventoryAdjustLot IAL ON IAL.IAL_IAD_ID = IAD.IAD_ID
	INNER JOIN Lot ON Lot.LOT_ID = IAL.IAL_LOT_ID
	INNER JOIN Warehouse WHM ON WHM.WHM_ID = IAL.IAL_WHM_ID
	INNER JOIN Product ON Product.PMA_ID = IAD.IAD_PMA_ID
	WHERE IAH.IAH_ID = @OrderId


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
	primary key (ITL_ID)
	)
	
	/*退货额度明细临时表*/
	CREATE TABLE #TMP_DealerReturnPosition(
		[DRP_ID] [uniqueidentifier] NOT NULL,
		[DRP_DMA_ID] [uniqueidentifier] NOT NULL,
		[DRP_BUM_ID] [uniqueidentifier] NOT NULL,
		[DRP_Year] [nvarchar](4) NOT NULL,
		[DRP_Quarter] [nvarchar](2) NOT NULL,
		[DRP_DetailAmount] [decimal](18, 6) NOT NULL,
		[DRP_IsInit] [bit] NOT NULL,
		[DRP_ReturnId] [uniqueidentifier] NULL,
		[DRP_ReturnNo] [nvarchar](200) NULL,
		[DRP_ReturnLotId] [uniqueidentifier] NULL,
		[DRP_Sku] [nvarchar](200) NULL,
		[DRP_LotNumber] [nvarchar](200) NULL,
		[DRP_QrCode] [nvarchar](200) NULL,
		[DRP_ReturnQty] [decimal](18, 6) NULL,
		[DRP_Price] [decimal](18, 6) NULL,
		[DRP_Type] [nvarchar](50) NOT NULL,
		[DRP_Desc] [nvarchar](2000) NULL,
		[DRP_REV1] [nvarchar](2000) NULL,
		[DRP_REV2] [nvarchar](2000) NULL,
		[DRP_REV3] [nvarchar](2000) NULL,
		[DRP_CreateDate] [datetime] NOT NULL,
		[DRP_CreateUser] [uniqueidentifier] NOT NULL,
		[DRP_CreateUserName] [nvarchar](200) NOT NULL,
		[DRP_IsActived] [bit] NOT NULL
	)

    PRINT @DealerType
	--库存操作，仅当经销商类型T1，或者LP退货审批未通过时执行 LIJIE EDIT 
	IF (@DealerType = 'T1' OR @DealerType = 'LP') AND @ApprovalStatus ='Reject'
		BEGIN
		 PRINT '1'
			--IAL_LotQty从中间库移出，IAL_LotQty-IAL_LotQtyNew得到要移回原仓库的数量
			--Inventory表
			INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
			SELECT -A.QTY,NEWID(),@SystemHoldWarehouse,A.IAD_PMA_ID
			FROM 
			(SELECT IAD_PMA_ID,SUM(IAL_LotQty) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAD_PMA_ID) AS A
			
			INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
			SELECT A.QTY,NEWID(),A.IAL_WHM_ID,A.IAD_PMA_ID
			FROM 
			(SELECT IAL_WHM_ID,IAD_PMA_ID,SUM(IAL_LotQty - IAL_LotQtyNew) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAL_WHM_ID,IAD_PMA_ID) AS A		

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

			--Lot表
			INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
			SELECT NEWID(),A.LOT_LTM_ID,@SystemHoldWarehouse,A.IAD_PMA_ID,A.IAL_LotNumber,-A.QTY
			FROM 
			(SELECT IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber,SUM(IAL_LotQty) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber) AS A

			INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
			SELECT NEWID(),A.LOT_LTM_ID,A.IAL_WHM_ID,A.IAD_PMA_ID,A.IAL_LotNumber,A.QTY
			FROM 
			(SELECT IAL_WHM_ID,IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber,SUM(IAL_LotQty - IAL_LotQtyNew) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAL_WHM_ID,IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber) AS A

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

			--Edited By Song Yuqi On 2015-12-01 For 短期寄售
			--Inventory操作日志，移出中间库
			INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
			SELECT -IAL_LotQty,NEWID(),IAL_ID,'库存调整：退货',@SystemHoldWarehouse,IAD_PMA_ID,0,
			CASE WHEN @OrderType = 'Transfer' THEN '库存调整类型：Transfer。从中间库移出。' ELSE '库存调整类型：Return。从中间库移出。' END
			FROM #TMP_DETAIL
			
			INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
			SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

			--Lot操作日志，移出中间库
			INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
			SELECT -D.IAL_LotQty,NEWID(),D.LOT_LTM_ID,D.IAL_LotNumber,ITR.ITR_ID
			FROM #TMP_DETAIL D
			INNER JOIN #tmp_invtrans ITR ON ITR.ITR_ReferenceID = D.IAL_ID

			INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
			SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot

			--清空日志数据
			DELETE FROM #tmp_invtrans
			DELETE FROM #tmp_invtranslot

			--Edited By Song Yuqi On 2015-12-01 For 短期寄售
			--Inventory操作日志，移回原仓库
			INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
			SELECT IAL_LotQty - IAL_LotQtyNew,NEWID(),IAL_ID,
			CASE WHEN @OrderType = 'Transfer' THEN '库存调整：转移给其他经销商' ELSE '库存调整：退货' END,
			IAL_WHM_ID,IAD_PMA_ID,0,
			CASE WHEN @OrderType = 'Transfer' THEN '库存调整类型：Transfer。移回原仓库。' ELSE '库存调整类型：Return。移回原仓库。' END 
			FROM #TMP_DETAIL

			INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
			SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

			--Lot操作日志，移回原仓库
			INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
			SELECT D.IAL_LotQty - D.IAL_LotQtyNew,NEWID(),D.LOT_LTM_ID,D.IAL_LotNumber,ITR.ITR_ID
			FROM #TMP_DETAIL D
			INNER JOIN #tmp_invtrans ITR ON ITR.ITR_ReferenceID = D.IAL_ID

			INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
			SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot		


			--如果【退货类型】：“合同约定条款内的”
			--需要将有差异的退货金额退回到退货额度池中
			--获取差异数 > 0的数据
			INSERT INTO #TMP_DealerReturnPosition 
				([DRP_ID]
			   ,[DRP_DMA_ID]
			   ,[DRP_BUM_ID]
			   ,[DRP_Year]
			   ,[DRP_Quarter]
			   ,[DRP_DetailAmount]
			   ,[DRP_IsInit]
			   ,[DRP_ReturnId]
			   ,[DRP_ReturnNo]
			   ,[DRP_ReturnLotId]
			   ,[DRP_Sku]
			   ,[DRP_LotNumber]
			   ,[DRP_QrCode]
			   ,[DRP_ReturnQty]
			   ,[DRP_Price]
			   ,[DRP_Type]
			   ,[DRP_Desc]
			   ,[DRP_REV1]
			   ,[DRP_REV2]
			   ,[DRP_REV3]
			   ,[DRP_CreateDate]
			   ,[DRP_CreateUser]
			   ,[DRP_CreateUserName]
			   ,[DRP_IsActived])
			SELECT NEWID(),
				@DealerId,
				C.IAH_ProductLine_BUM_ID,
				YEAR(GETDATE()),
				DATEPART(QUARTER,GETDATE()),
				ISNULL(IAL_LotQty,0) * A.IAL_UnitPrice,
				0,
				@OrderId,
				IAH_Inv_Adj_Nbr,
				A.IAL_ID,
				A.PMA_UPN,
				CASE WHEN CHARINDEX('@@',IAL_LotNumber) > 0 THEN substring(IAL_LotNumber,1,CHARINDEX('@@',IAL_LotNumber)-1) ELSE IAL_LotNumber END,
				CASE WHEN CHARINDEX('@@',IAL_LotNumber) > 0 THEN substring(IAL_LotNumber,CHARINDEX('@@',IAL_LotNumber)+2,LEN(IAL_LotNumber)-CHARINDEX('@@',IAL_LotNumber)) ELSE 'NoQR' END,
				ISNULL(IAL_LotQty,0),
				A.IAL_UnitPrice,
				'退货退回',
				'退货退回增加',
				C.IAH_UserDescription,
				@BatchNbr,
				null,
				GETDATE(),
				@SysUserId,
				'系统',
				ISNULL((SELECT TOP 1 DRP_IsActived FROM DealerReturnPosition WHERE DRP_ReturnLotId = A.IAL_ID),0)
				FROM #TMP_DETAIL A
			INNER JOIN InventoryAdjustDetail B ON A.IAD_ID = B.IAD_ID
			INNER JOIN InventoryAdjustHeader C ON C.IAH_ID = B.IAD_IAH_ID
			WHERE ISNULL(IAL_LotQty,0) > 0
			AND C.IAH_ApplyType = '4'
			AND C.IAH_Reason IN ('Return','Exchange')

			INSERT INTO DealerReturnPosition
					([DRP_ID]
					,[DRP_DMA_ID]
					,[DRP_BUM_ID]
					,[DRP_Year]
					,[DRP_Quarter]
					,[DRP_DetailAmount]
					,[DRP_IsInit]
					,[DRP_ReturnId]
					,[DRP_ReturnNo]
					,[DRP_ReturnLotId]
					,[DRP_Sku]
					,[DRP_LotNumber]
					,[DRP_QrCode]
					,[DRP_ReturnQty]
					,[DRP_Price]
					,[DRP_Type]
					,[DRP_Desc]
					,[DRP_REV1]
					,[DRP_REV2]
					,[DRP_REV3]
					,[DRP_CreateDate]
					,[DRP_CreateUser]
					,[DRP_CreateUserName]
					,[DRP_IsActived])
			SELECT [DRP_ID]
					,[DRP_DMA_ID]
					,[DRP_BUM_ID]
					,[DRP_Year]
					,[DRP_Quarter]
					,[DRP_DetailAmount]
					,[DRP_IsInit]
					,[DRP_ReturnId]
					,[DRP_ReturnNo]
					,[DRP_ReturnLotId]
					,[DRP_Sku]
					,[DRP_LotNumber]
					,[DRP_QrCode]
					,[DRP_ReturnQty]
					,[DRP_Price]
					,[DRP_Type]
					,[DRP_Desc]
					,[DRP_REV1]
					,[DRP_REV2]
					,[DRP_REV3]
					,[DRP_CreateDate]
					,[DRP_CreateUser]
					,[DRP_CreateUserName] 
					,[DRP_IsActived]
				FROM #TMP_DealerReturnPosition		

		END

	--如果是LP或T1的寄售转移申请单，且审批通过，需要从在途库扣减库存
	IF (@DealerType = 'LP' OR @DealerType='T1' ) AND @OrderType='Transfer' AND @ApprovalStatus = 'Accept'
		BEGIN

			--IAL_LotQty从中间库移出。
			--Inventory表
			INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
			SELECT -A.QTY,NEWID(),@SystemHoldWarehouse,A.IAD_PMA_ID
			FROM 
			(SELECT IAD_PMA_ID,SUM(IAL_LotQty) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAD_PMA_ID) AS A
			
	

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

			--Lot表
			INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
			SELECT NEWID(),A.LOT_LTM_ID,@SystemHoldWarehouse,A.IAD_PMA_ID,A.IAL_LotNumber,-A.QTY
			FROM 
			(SELECT IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber,SUM(IAL_LotQty) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber) AS A



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

			--Edited By Song Yuqi On 2015-12-01 For 短期寄售
			--Inventory操作日志，移出中间库
			INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
			SELECT -IAL_LotQty,NEWID(),IAL_ID,
			CASE WHEN @OrderType = 'Transfer' THEN '库存调整：转移给其他经销商' ELSE '库存调整：退货' END,
			@SystemHoldWarehouse,IAD_PMA_ID,0,
			CASE WHEN @OrderType = 'Transfer' THEN '库存调整类型：Transfer。从中间库移出。' ELSE '库存调整类型：Return。从中间库移出。' END 
			FROM #TMP_DETAIL

			INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
			SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

			--Lot操作日志，移出中间库
			INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
			SELECT -(D.IAL_LotQty),NEWID(),D.LOT_LTM_ID,D.IAL_LotNumber,ITR.ITR_ID
			FROM #TMP_DETAIL D
			INNER JOIN #tmp_invtrans ITR ON ITR.ITR_ReferenceID = D.IAL_ID

			INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
			SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot

			--清空日志数据
			DELETE FROM #tmp_invtrans
			DELETE FROM #tmp_invtranslot

		
		END
--如果@NoteId等于13要发送邮件个经销商，暂时未做		
    --IF(@NoteId='13')
    --   BEGIN
    --     '发送邮件'
    --   END		
	
		
	SET @ReturnValue = '1'		        	

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
	SET @ReturnValue = ERROR_MESSAGE()	

    return -1
    
END CATCH
GO


