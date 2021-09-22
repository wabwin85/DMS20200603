SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
/*
因数量太大，导致前台收货失败，通过此程序进行后台批量收货
仅对于T1、T2使用
*/
ALTER PROCEDURE [dbo].[GC_Maunal_Receipt_ByShipmentNbr]
   @ShipmentNbr       NVARCHAR (30),
   @WhmId             UNIQUEIDENTIFIER,
   @UserId            UNIQUEIDENTIFIER,
   @RtnVal            NVARCHAR (20) OUTPUT,
   @RtnMsg            NVARCHAR (MAX) OUTPUT
AS
DECLARE @SysUserId   UNIQUEIDENTIFIER
SET  NOCOUNT ON

BEGIN TRY
   BEGIN TRAN
   SET @RtnVal = 'Success'
   SET @RtnMsg = ''
   SET @SysUserId = '00000000-0000-0000-0000-000000000000'

   --将当前状态是Waiting状态的收货单添加到临时表待处理
   SELECT PH.PRH_ID
     INTO #TMP_DATA
     FROM POReceiptHeader PH (NOLOCK)
          INNER JOIN DealerMaster D (NOLOCK)
             ON D.DMA_ID = PH.PRH_Dealer_DMA_ID
    WHERE     PRH_Type IN ('PurchaseOrder','Rent','Complain','Retail')
          AND PRH_Status = 'Waiting'
          AND PH.PRH_SAPShipmentID = @ShipmentNbr


   IF (SELECT COUNT (*)
       FROM #TMP_DATA) > 0
      BEGIN
         --更新收货单的状态Complete
         UPDATE POReceiptHeader
            SET PRH_Status = 'Complete', PRH_ReceiptDate = isnull(PRH_ReceiptDate,getdate()), PRH_Receipt_USR_UserID= isnull(PRH_Receipt_USR_UserID, @UserId),
	        PRH_WHM_ID=@WhmId
           FROM #TMP_DATA T
          WHERE POReceiptHeader.PRH_ID = T.PRH_ID

         --记录单据操作日志
         INSERT INTO PurchaseOrderLog (POL_ID,
                                       POL_POH_ID,
                                       POL_OperUser,
                                       POL_OperDate,
                                       POL_OperType,
                                       POL_OperNote)
            SELECT NEWID (),
                   PRH_ID,
                   @UserId,
                   GETDATE (),
                   'Confirm',
                   '收货确认'
              FROM #TMP_DATA

         --完成收货操作，库存增加
         /*库存临时表*/
         CREATE TABLE #tmp_inventory
         (
            INV_ID               UNIQUEIDENTIFIER,
            INV_WHM_ID           UNIQUEIDENTIFIER,
            INV_PMA_ID           UNIQUEIDENTIFIER,
            INV_OnHandQuantity   FLOAT PRIMARY KEY (INV_ID)
         )

         /*库存明细Lot临时表*/
         CREATE TABLE #tmp_lot
         (
            LOT_ID          UNIQUEIDENTIFIER,
            LOT_LTM_ID      UNIQUEIDENTIFIER,
            LOT_WHM_ID      UNIQUEIDENTIFIER,
            LOT_PMA_ID      UNIQUEIDENTIFIER,
            LOT_INV_ID      UNIQUEIDENTIFIER,
            LOT_OnHandQty   FLOAT,
            LOT_LotNumber   NVARCHAR (50) COLLATE Chinese_PRC_CI_AS,
            PRIMARY KEY (LOT_ID)
         )

         /*库存日志临时表*/
         CREATE TABLE #tmp_invtrans
         (
            ITR_Quantity           FLOAT,
            ITR_ID                 UNIQUEIDENTIFIER,
            ITR_ReferenceID        UNIQUEIDENTIFIER,
            ITR_Type               NVARCHAR (50) COLLATE Chinese_PRC_CI_AS,
            ITR_WHM_ID             UNIQUEIDENTIFIER,
            ITR_PMA_ID             UNIQUEIDENTIFIER,
            ITR_UnitPrice          FLOAT,
            ITR_TransDescription   NVARCHAR (200) COLLATE Chinese_PRC_CI_AS,
            PRIMARY KEY (ITR_ID)
         )

         /*库存明细Lot日志临时表*/
         CREATE TABLE #tmp_invtranslot
         (
            ITL_Quantity    FLOAT,
            ITL_ID          UNIQUEIDENTIFIER,
            ITL_ITR_ID      UNIQUEIDENTIFIER,
            ITL_LTM_ID      UNIQUEIDENTIFIER,
            ITL_LotNumber   NVARCHAR (50)
                               COLLATE Chinese_PRC_CI_AS
                               PRIMARY KEY (ITL_ID)
         )

		 CREATE TABLE #tmp_warehouse
         (
            WHM_ID          UNIQUEIDENTIFIER,
            WHM_DMA_ID      UNIQUEIDENTIFIER,
            PRIMARY KEY (WHM_ID)
         )

		 INSERT INTO #tmp_warehouse
		 select WHM_ID,WHM_DMA_ID FROM Warehouse(nolock) where WHM_Type='SystemHold'

         --LotMaster表，新增批次信息
         INSERT INTO LotMaster(LTM_ID,
                                LTM_LotNumber,
                                LTM_ExpiredDate,
                                LTM_Product_PMA_ID,
                                LTM_CreatedDate,
                                LTM_Type, 
								LTM_LOT,
								LTM_QRCode)
            SELECT NEWID (),
                   T.LOTNUMBER,
                   T.EXPIREDDATE,
                   T.PMAID,
                   GETDATE (),
                   (SELECT max (DOM.DOM)
                      FROM dbo.LotMasterDOM AS DOM (NOLOCK)
                     WHERE     DOM.PMA_ID = T.PMAID
                           AND DOM.LOT =
                                  CASE
                                     WHEN charindex ('@@', T.LOTNUMBER) > 0
                                     THEN
                                        substring (
                                           T.LOTNUMBER,
                                           1,
                                           charindex ('@@', T.LOTNUMBER) - 1)
                                     ELSE
                                        T.LOTNUMBER
                                  END),
					CASE WHEN CHARINDEX('@@',T.LOTNUMBER) > 0 THEN substring(T.LOTNUMBER,1,CHARINDEX('@@',T.LOTNUMBER)-1) ELSE T.LOTNUMBER END AS LTM_Lot,
		            CASE WHEN CHARINDEX('@@',T.LOTNUMBER) > 0 THEN substring(T.LOTNUMBER,CHARINDEX('@@',T.LOTNUMBER)+2,LEN(T.LOTNUMBER)-CHARINDEX('@@',T.LOTNUMBER)) ELSE 'NoQR' END AS LTM_QrCode
              FROM (SELECT DISTINCT
                           PD.PRL_LotNumber AS LOTNUMBER,
                           PD.PRL_ExpiredDate AS EXPIREDDATE,
                           PL.POR_SAP_PMA_ID PMAID
                      FROM POReceiptLot PD (NOLOCK)
                           INNER JOIN POReceipt PL (NOLOCK)
                              ON PL.POR_ID = PD.PRL_POR_ID
                           INNER JOIN #TMP_DATA T ON T.PRH_ID = PL.POR_PRH_ID
                     WHERE NOT EXISTS
                              (SELECT 1
                                 FROM LotMaster (NOLOCK)
                                WHERE     LotMaster.LTM_LotNumber =
                                             PD.PRL_LotNumber
                                      AND LotMaster.LTM_Product_PMA_ID =
                                             PL.POR_SAP_PMA_ID)) AS T
		
         --Inventory表，新增仓库中没有的物料，更新仓库中存在的物料数量
         INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                     INV_ID,
                                     INV_WHM_ID,
                                     INV_PMA_ID)
            SELECT T.QTY,
                   NEWID (),
                   T.WHMID,
                   T.PMAID
              FROM (SELECT SUM (PL.POR_ReceiptQty) AS QTY,
                           PH.PRH_WHM_ID AS WHMID,
                           PL.POR_SAP_PMA_ID AS PMAID
                      FROM POReceipt PL (NOLOCK)
                           INNER JOIN POReceiptHeader PH (NOLOCK)
                              ON PH.PRH_ID = PL.POR_PRH_ID
                           INNER JOIN #TMP_DATA T ON T.PRH_ID = PH.PRH_ID
                    GROUP BY PH.PRH_WHM_ID, PL.POR_SAP_PMA_ID) AS T

         --如果是二级则写入上级的库存信息
         INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                     INV_ID,
                                     INV_WHM_ID,
                                     INV_PMA_ID)
        SELECT distinct -T.QTY,
                   T.INV_ID,
                   T.WHM_ID,
                   T.PMAID
              FROM (SELECT SUM (PL.POR_ReceiptQty) AS QTY,
                            WHM_ID ,
                           PL.POR_SAP_PMA_ID AS PMAID,
                           PH.PRH_Vendor_DMA_ID,
						   Inv.INV_ID
                      FROM POReceipt PL (NOLOCK)
                           INNER JOIN POReceiptHeader PH (NOLOCK) ON PH.PRH_ID = PL.POR_PRH_ID
                           INNER JOIN #TMP_DATA T ON T.PRH_ID = PH.PRH_ID
						   INNER JOIN #tmp_warehouse wh on wh.WHM_DMA_ID = PRH_Vendor_DMA_ID    
						   INNER JOIN Inventory Inv(nolock) on (Inv.INV_WHM_ID=wh.WHM_ID and Inv.INV_PMA_ID = PL.POR_SAP_PMA_ID )             
                    GROUP BY WHM_ID, PL.POR_SAP_PMA_ID,PRH_Vendor_DMA_ID,Inv.INV_ID) AS T
         
         
         UPDATE Inventory
            SET Inventory.INV_OnHandQuantity =
                     CONVERT (DECIMAL (18, 2), Inventory.INV_OnHandQuantity)
                   + CONVERT (DECIMAL (18, 2), TMP.INV_OnHandQuantity)
           FROM #tmp_inventory AS TMP
          WHERE     Inventory.INV_WHM_ID = TMP.INV_WHM_ID
                AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

         INSERT INTO Inventory (INV_OnHandQuantity,
                                INV_ID,
                                INV_WHM_ID,
                                INV_PMA_ID)
            SELECT INV_OnHandQuantity,
                   INV_ID,
                   INV_WHM_ID,
                   INV_PMA_ID
              FROM #tmp_inventory AS TMP
             WHERE NOT EXISTS
                      (SELECT 1
                         FROM Inventory INV (NOLOCK)
                        WHERE     INV.INV_WHM_ID = TMP.INV_WHM_ID
                              AND INV.INV_PMA_ID = TMP.INV_PMA_ID)

         --Lot表，新增批次库存
         INSERT INTO #tmp_lot (LOT_ID,
                               LOT_LTM_ID,
                               LOT_WHM_ID,
                               LOT_PMA_ID,
                               LOT_LotNumber,
                               LOT_OnHandQty)
            SELECT NEWID (),
                   LTMID,
                   WHMID,
                   PMAID,
                   LOTNUMBER,
                   QTY
              FROM (SELECT LM.LTM_ID AS LTMID,
                           PH.PRH_WHM_ID AS WHMID,
                           PL.POR_SAP_PMA_ID AS PMAID,
                           PD.PRL_LotNumber AS LOTNUMBER,
                           SUM (PD.PRL_ReceiptQty) AS QTY
                      FROM POReceiptLot PD (NOLOCK)
                           INNER JOIN POReceipt PL (NOLOCK)
                              ON PL.POR_ID = PD.PRL_POR_ID
                           INNER JOIN POReceiptHeader PH (NOLOCK)
                              ON PH.PRH_ID = PL.POR_PRH_ID
                           INNER JOIN LotMaster LM (NOLOCK)
                              ON     LM.LTM_LotNumber = PD.PRL_LotNumber
                                 AND LM.LTM_Product_PMA_ID =
                                        PL.POR_SAP_PMA_ID
                           INNER JOIN #TMP_DATA T ON T.PRH_ID = PH.PRH_ID
                    GROUP BY LM.LTM_ID,
                             PH.PRH_WHM_ID,
                             PL.POR_SAP_PMA_ID,
                             PD.PRL_LotNumber) AS T
         
          --如果是二级则写入上级的在途库库存Lot信息
          INSERT INTO #tmp_lot (LOT_ID,
                               LOT_INV_ID,
                               LOT_LTM_ID,
                               LOT_WHM_ID,
                               LOT_PMA_ID,
                               LOT_LotNumber,
                               LOT_OnHandQty)
             SELECT LOTID,
                   INVID,
                   LTMID,
                   WHMID,
                   PMAID,
                   LOTNUMBER,
                   -QTY
              FROM (SELECT LT.Lot_ID AS LOTID,
                           LM.LTM_ID AS LTMID,
                           PH.PRH_WHM_ID AS WHMID,
                           PL.POR_SAP_PMA_ID AS PMAID,
                           PD.PRL_LotNumber AS LOTNUMBER,
                           Inv.INV_ID AS INVID,
                           SUM (PD.PRL_ReceiptQty) AS QTY
                      FROM POReceiptLot PD (NOLOCK)
                           INNER JOIN POReceipt PL (NOLOCK) ON PL.POR_ID = PD.PRL_POR_ID
                           INNER JOIN POReceiptHeader PH (NOLOCK) ON PH.PRH_ID = PL.POR_PRH_ID
                           INNER JOIN LotMaster LM (NOLOCK) ON (LM.LTM_LotNumber = PD.PRL_LotNumber AND LM.LTM_Product_PMA_ID = PL.POR_SAP_PMA_ID)
                           INNER JOIN #TMP_DATA T ON (T.PRH_ID = PH.PRH_ID)
                           INNER JOIN #tmp_warehouse AS WH ON (WH.WHM_DMA_ID = PH.PRH_Vendor_DMA_ID)
                           INNER JOIN Inventory Inv(nolock) ON (Inv.INV_WHM_ID = WH.WHM_ID and inv.INV_PMA_ID = PL.POR_SAP_PMA_ID)
                           INNER JOIN Lot LT(nolock) ON (LT.Lot_Inv_ID = Inv.Inv_ID and LT.Lot_LTM_ID = LM.LTM_ID )
                    GROUP BY LT.Lot_ID,
                             Inv.INV_ID,
                             LM.LTM_ID,
                             PH.PRH_WHM_ID,
                             PL.POR_SAP_PMA_ID,
                             PD.PRL_LotNumber) AS T
          

         --更新关联库存主键
         UPDATE #tmp_lot
            SET LOT_INV_ID = INV.INV_ID
           FROM Inventory INV
          WHERE     INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
                AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID
                AND LOT_INV_ID is null

         --更新批次表，存在的更新，不存在的新增
         UPDATE Lot
            SET Lot.LOT_OnHandQty =
                     CONVERT (DECIMAL (18, 2), Lot.LOT_OnHandQty)
                   + CONVERT (DECIMAL (18, 2), TMP.LOT_OnHandQty)
				,Lot.LOT_CreateDate=GETDATE()
           FROM #tmp_lot AS TMP
          WHERE     Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

         INSERT INTO Lot (LOT_ID,
                          LOT_LTM_ID,
                          LOT_OnHandQty,
                          LOT_INV_ID
						  ,LOT_WHM_ID,LOT_CFN_ID,LOT_LTM_ExpiredDate,LOT_LTM_Lot,LOT_LTM_QRCode,LOT_LTM_DOM,LOT_CreateDate
						  )
            SELECT LOT_ID,
                   LOT_LTM_ID,
                   CONVERT (DECIMAL (18, 2), LOT_OnHandQty),
                   LOT_INV_ID
				   ,TMP.LOT_WHM_ID,PT.PMA_CFN_ID,LM.LTM_ExpiredDate,LM.LTM_Lot,LM.LTM_QRCode,LM.LTM_Type,GETDATE()
              FROM #tmp_lot AS TMP
			  INNER JOIN LotMaster LM ON LM.LTM_ID=LOT_LTM_ID
			  LEFT JOIN Product PT ON TMP.LOT_PMA_ID=PT.PMA_ID
             WHERE NOT EXISTS
                      (SELECT 1
                         FROM Lot (NOLOCK)
                        WHERE     Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                              AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)

         
         
         --Inventory操作日志(收货)，加库存
         INSERT INTO #tmp_invtrans (ITR_Quantity,
                                    ITR_ID,
                                    ITR_ReferenceID,
                                    ITR_Type,
                                    ITR_WHM_ID,
                                    ITR_PMA_ID,
                                    ITR_UnitPrice,
                                    ITR_TransDescription)
            SELECT PL.POR_ReceiptQty,
                   NEWID (),
                   PL.POR_ID,
                   (select value1 from Lafite_DICT where DICT_TYPE='CONST_Receipt_Type' and dict_key=PH.Prh_type ) ,
                   PH.PRH_WHM_ID,
                   PL.POR_SAP_PMA_ID,
                   ISNULL (PL.POR_UnitPrice, 0),
                     '接收'
                   + PH.PRH_PONumber
                   + '的第'
                   + CONVERT (NVARCHAR (50), PL.POR_LineNbr)
                   + '行'
              FROM POReceipt PL (NOLOCK)
                   INNER JOIN POReceiptHeader PH (NOLOCK)
                      ON PH.PRH_ID = PL.POR_PRH_ID
                   INNER JOIN #TMP_DATA T ON T.PRH_ID = PH.PRH_ID
                   
         --写入正式表        
         INSERT INTO InventoryTransaction (ITR_Quantity,
                                           ITR_ID,
                                           ITR_ReferenceID,
                                           ITR_Type,
                                           ITR_WHM_ID,
                                           ITR_PMA_ID,
                                           ITR_UnitPrice,
                                           ITR_TransDescription,
                                           ITR_TransactionDate)
            SELECT ITR_Quantity,
                   ITR_ID,
                   ITR_ReferenceID,
                   ITR_Type,
                   ITR_WHM_ID,
                   ITR_PMA_ID,
                   ITR_UnitPrice,
                   ITR_TransDescription,
                   GETDATE ()
              FROM #tmp_invtrans

         --Lot操作日志（收货），加库存
         INSERT INTO #tmp_invtranslot (ITL_Quantity,
                                       ITL_ID,
                                       ITL_LTM_ID,
                                       ITL_LotNumber,
                                       ITL_ITR_ID)
            SELECT PD.PRL_ReceiptQty,
                   NEWID (),
                   LM.LTM_ID,
                   LM.LTM_LotNumber,
                   itr.ITR_ID
              FROM POReceiptLot PD (NOLOCK)
                   INNER JOIN POReceipt PL (NOLOCK)
                      ON PL.POR_ID = PD.PRL_POR_ID
                   INNER JOIN LotMaster LM (NOLOCK)
                      ON     LM.LTM_LotNumber = PD.PRL_LotNumber
                         AND LM.LTM_Product_PMA_ID = PL.POR_SAP_PMA_ID
                   INNER JOIN #tmp_invtrans itr
                      ON itr.ITR_ReferenceID = PL.POR_ID
                   INNER JOIN #TMP_DATA T ON T.PRH_ID = PL.POR_PRH_ID
         
         --写入正式表
         INSERT INTO InventoryTransactionLot (ITL_Quantity,
                                              ITL_ID,
                                              ITL_ITR_ID,
                                              ITL_LTM_ID,
                                              ITL_LotNumber)
            SELECT ITL_Quantity,
                   ITL_ID,
                   ITL_ITR_ID,
                   ITL_LTM_ID,
                   ITL_LotNumber
              FROM #tmp_invtranslot
         
         --清空数据
         Delete from #tmp_invtrans      
		 
         --Inventory操作日志(发货)，减库存
         INSERT INTO #tmp_invtrans (ITR_Quantity,
                                    ITR_ID,
                                    ITR_ReferenceID,
                                    ITR_Type,
                                    ITR_WHM_ID,
                                    ITR_PMA_ID,
                                    ITR_UnitPrice,
                                    ITR_TransDescription)
          SELECT -PL.POR_ReceiptQty,
                   NEWID (),
                   PL.POR_ID,
                   ( select value1 from Lafite_DICT where DICT_TYPE='CONST_Receipt_Type' and dict_key=PH.Prh_type ) ,
                   WH.WHM_ID,
                   PL.POR_SAP_PMA_ID,
                   ISNULL (PL.POR_UnitPrice, 0),
                     '接收'
                   + PH.PRH_PONumber
                   + '的第'
                   + CONVERT (NVARCHAR (50), PL.POR_LineNbr)
                   + '行'
              FROM POReceipt PL (NOLOCK)
                   INNER JOIN POReceiptHeader PH (NOLOCK)
                      ON PH.PRH_ID = PL.POR_PRH_ID
                   INNER JOIN #TMP_DATA T ON T.PRH_ID = PH.PRH_ID 
                   INNER JOIN #tmp_warehouse AS WH ON (WH.WHM_DMA_ID = PH.PRH_Vendor_DMA_ID)		   
         
         --写入正式表
         INSERT INTO InventoryTransaction (ITR_Quantity,
                                           ITR_ID,
                                           ITR_ReferenceID,
                                           ITR_Type,
                                           ITR_WHM_ID,
                                           ITR_PMA_ID,
                                           ITR_UnitPrice,
                                           ITR_TransDescription,
                                           ITR_TransactionDate)
            SELECT ITR_Quantity,
                   ITR_ID,
                   ITR_ReferenceID,
                   ITR_Type,
                   ITR_WHM_ID,
                   ITR_PMA_ID,
                   ITR_UnitPrice,
                   ITR_TransDescription,
                   GETDATE ()
              FROM #tmp_invtrans
         
         --清空数据
         Delete from #tmp_invtranslot
		 
		     --Lot操作日志(发货)，减库存
         INSERT INTO #tmp_invtranslot (ITL_Quantity,
                                       ITL_ID,
                                       ITL_LTM_ID,
                                       ITL_LotNumber,
                                       ITL_ITR_ID)
            SELECT -PD.PRL_ReceiptQty,
                   NEWID (),
                   LM.LTM_ID,
                   LM.LTM_LotNumber,
                   itr.ITR_ID
              FROM POReceiptLot PD (NOLOCK)
                   INNER JOIN POReceipt PL (NOLOCK)
                      ON PL.POR_ID = PD.PRL_POR_ID
                   INNER JOIN LotMaster LM (NOLOCK)
                      ON     LM.LTM_LotNumber = PD.PRL_LotNumber
                         AND LM.LTM_Product_PMA_ID = PL.POR_SAP_PMA_ID
                   INNER JOIN #tmp_invtrans itr
                      ON itr.ITR_ReferenceID = PL.POR_ID
                   INNER JOIN #TMP_DATA T ON T.PRH_ID = PL.POR_PRH_ID
         
         --写入正式表
         INSERT INTO InventoryTransactionLot (ITL_Quantity,
                                              ITL_ID,
                                              ITL_ITR_ID,
                                              ITL_LTM_ID,
                                              ITL_LotNumber)
            SELECT ITL_Quantity,
                   ITL_ID,
                   ITL_ITR_ID,
                   ITL_LTM_ID,
                   ITL_LotNumber
              FROM #tmp_invtranslot
	     		 
		 --如果是借货单的话，还需要更新借货出库单状态
		 --写入操作日志
		 INSERT INTO PurchaseOrderLog (POL_ID,
                                       POL_POH_ID,
                                       POL_OperUser,
                                       POL_OperDate,
                                       POL_OperType,
                                       POL_OperNote)
            SELECT NEWID (),
                   TRN_ID,
                   @UserId,
                   GETDATE (),
                   'Confirm',
                   '收货确认'
             from POReceiptHeader H,#TMP_DATA AS PD, Transfer T
		    where H.PRH_ID = PD.PRH_ID and H.PRH_SAPShipmentID=T.TRN_TransferNumber
		      and T.TRN_Status='OntheWay'

		 update T set T.TRN_Status='Complete'
		   from POReceiptHeader H,#TMP_DATA AS PD, Transfer T
		  where H.PRH_ID = PD.PRH_ID and H.PRH_SAPShipmentID=T.TRN_TransferNumber
		    and T.TRN_Status='OntheWay'
		  
		  
      END

   COMMIT TRAN

   SET  NOCOUNT OFF
   RETURN 1
END TRY
BEGIN CATCH
   SET  NOCOUNT OFF
   ROLLBACK TRAN
   SET @RtnVal = 'Failure'

   --记录错误日志开始
   DECLARE @error_line   INT
   DECLARE @error_number   INT
   DECLARE @error_message   NVARCHAR (256)
   DECLARE @vError   NVARCHAR (1000)
   SET @error_line = ERROR_LINE ()
   SET @error_number = ERROR_NUMBER ()
   SET @error_message = ERROR_MESSAGE ()
   SET @vError =
            '行'
          + CONVERT (NVARCHAR (10), @error_line)
          + '出错[错误号'
          + CONVERT (NVARCHAR (10), @error_number)
          + '],'
          + @error_message
   SET @RtnMsg = @vError
   RETURN -1
END CATCH
GO

