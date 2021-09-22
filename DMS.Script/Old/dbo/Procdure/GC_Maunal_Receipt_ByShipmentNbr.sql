DROP Procedure [dbo].[GC_Maunal_Receipt_ByShipmentNbr]
GO

/*
因数量太大，导致前台收货失败，通过此程序进行后台批量收货
根据需要手工执行
*/
CREATE Procedure [dbo].[GC_Maunal_Receipt_ByShipmentNbr]
    @ShipmentNbr NVARCHAR(30),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(MAX) OUTPUT
AS
	DECLARE @SysUserId uniqueidentifier
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'

	--将当前状态是Waiting状态的收货单添加到临时表待处理
	SELECT PH.PRH_ID INTO #TMP_DATA 
     FROM POReceiptHeader PH
	INNER JOIN DealerMaster D ON D.DMA_ID = PH.PRH_Dealer_DMA_ID
	WHERE PRH_Type = 'PurchaseOrder' 
    AND PRH_Status = 'Waiting'	  
    AND PH.PRH_SAPShipmentID=@ShipmentNbr
  

	IF (SELECT COUNT(*) FROM #TMP_DATA )>0
	  BEGIN
	--更新收货单的状态Complete
	UPDATE POReceiptHeader SET PRH_Status = 'Complete'
	FROM #TMP_DATA T 
  WHERE POReceiptHeader.PRH_ID = T.PRH_ID

	--记录单据操作日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),PRH_ID,@SysUserId,GETDATE(),'Confirm','系统后台完成收货确认'
	FROM #TMP_DATA

	--完成收货操作，库存增加
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
	ITL_LotNumber        nvarchar(50)         collate Chinese_PRC_CI_AS
	primary key (ITL_ID)
	)	
	
	--LotMaster表，新增批次信息
	INSERT INTO LotMaster (LTM_ID, LTM_LotNumber, LTM_ExpiredDate, LTM_Product_PMA_ID, LTM_CreatedDate, LTM_Type )
	SELECT NEWID(), 
         T.LOTNUMBER, 
         T.EXPIREDDATE,
         T.PMAID, 
         GETDATE() , 
        (SELECT max(DOM.DOM) FROM dbo.LotMasterDOM AS DOM 
          				   where DOM.PMA_ID = T.PMAID 
          				   and DOM.LOT = CASE WHEN charindex('@@',T.LOTNUMBER) > 0 
											                  THEN substring(T.LOTNUMBER,1,charindex('@@',T.LOTNUMBER)-1) 
											                  ELSE T.LOTNUMBER
											                  END)
    FROM (
        SELECT DISTINCT PD.PRL_LotNumber AS LOTNUMBER,PD.PRL_ExpiredDate AS EXPIREDDATE,PL.POR_SAP_PMA_ID PMAID
  	      FROM POReceiptLot PD
  	           INNER JOIN POReceipt PL ON PL.POR_ID = PD.PRL_POR_ID
  	           INNER JOIN #TMP_DATA T ON T.PRH_ID = PL.POR_PRH_ID
  	     WHERE NOT EXISTS (SELECT 1 FROM LotMaster
  	                        WHERE LotMaster.LTM_LotNumber = PD.PRL_LotNumber
  	                          AND LotMaster.LTM_Product_PMA_ID = PL.POR_SAP_PMA_ID)
       ) AS T

	--Inventory表，新增仓库中没有的物料，更新仓库中存在的物料数量
	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
	SELECT T.QTY,NEWID(),T.WHMID,T.PMAID 
    FROM
	      (SELECT SUM(PL.POR_ReceiptQty) AS QTY,PH.PRH_WHM_ID AS WHMID,PL.POR_SAP_PMA_ID AS PMAID
	         FROM POReceipt PL
	           INNER JOIN POReceiptHeader PH ON PH.PRH_ID = PL.POR_PRH_ID
	           INNER JOIN #TMP_DATA T ON T.PRH_ID = PH.PRH_ID
	        GROUP BY PH.PRH_WHM_ID,PL.POR_SAP_PMA_ID) as T
	
	UPDATE Inventory 
     SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)+Convert(decimal(18,6),TMP.INV_OnHandQuantity)
	  FROM #tmp_inventory AS TMP
	 WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
	   AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

	INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
	SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID
	  FROM #tmp_inventory AS TMP	
	 WHERE NOT EXISTS (SELECT 1 FROM Inventory INV WHERE INV.INV_WHM_ID = TMP.INV_WHM_ID AND INV.INV_PMA_ID = TMP.INV_PMA_ID)	

	--Lot表，新增批次库存
	INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
	SELECT NEWID(),LTMID,WHMID,PMAID,LOTNUMBER,QTY 
    FROM (
        	SELECT LM.LTM_ID AS LTMID,PH.PRH_WHM_ID AS WHMID,PL.POR_SAP_PMA_ID AS PMAID,PD.PRL_LotNumber AS LOTNUMBER,SUM(PD.PRL_ReceiptQty) AS QTY
        	  FROM POReceiptLot PD
        	    INNER JOIN POReceipt PL ON PL.POR_ID = PD.PRL_POR_ID
        	    INNER JOIN POReceiptHeader PH ON PH.PRH_ID = PL.POR_PRH_ID
        	    INNER JOIN LotMaster LM ON LM.LTM_LotNumber = PD.PRL_LotNumber AND LM.LTM_Product_PMA_ID = PL.POR_SAP_PMA_ID
        	    INNER JOIN #TMP_DATA T ON T.PRH_ID = PH.PRH_ID
        	 GROUP BY LM.LTM_ID,PH.PRH_WHM_ID,PL.POR_SAP_PMA_ID,PD.PRL_LotNumber) AS T

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

	INSERT INTO Lot(LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
	SELECT LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID 
	  FROM #tmp_lot AS TMP
	 WHERE NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)
	
	--Inventory操作日志
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT PL.POR_ReceiptQty,NEWID(),PL.POR_ID,'采购入库',PH.PRH_WHM_ID,PL.POR_SAP_PMA_ID,ISNULL(PL.POR_UnitPrice,0),'接收'+PH.PRH_PONumber+'的第'+CONVERT(NVARCHAR(50),PL.POR_LineNbr)+'行'
  	FROM POReceipt PL
	    INNER JOIN POReceiptHeader PH ON PH.PRH_ID = PL.POR_PRH_ID
	    INNER JOIN #TMP_DATA T ON T.PRH_ID = PH.PRH_ID

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
	SELECT PD.PRL_ReceiptQty, NEWID(), LM.LTM_ID, LM.LTM_LotNumber, itr.ITR_ID
	  FROM POReceiptLot PD
	    INNER JOIN POReceipt PL ON PL.POR_ID = PD.PRL_POR_ID
	    INNER JOIN LotMaster LM ON LM.LTM_LotNumber = PD.PRL_LotNumber AND LM.LTM_Product_PMA_ID = PL.POR_SAP_PMA_ID
	    INNER JOIN #tmp_invtrans itr on itr.ITR_ReferenceID = PL.POR_ID
	    INNER JOIN #TMP_DATA T ON T.PRH_ID = PL.POR_PRH_ID
	
	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber 
    FROM #tmp_invtranslot
   END

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


