DROP PROCEDURE [dbo].[GC_POReceipt_CancelReceive]
GO

/*
ȡ����������������桢�����������������޸��ջ���״̬��д��־
*/
CREATE PROCEDURE [dbo].[GC_POReceipt_CancelReceive]
   @PRHId        UNIQUEIDENTIFIER,
   @UserId       UNIQUEIDENTIFIER,
   @RtnVal       NVARCHAR (20) OUTPUT,
   @RtnMsg       NVARCHAR (1000) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER
   DECLARE @OrderNo   NVARCHAR (30)
   DECLARE @RowCnt   INTEGER
   DECLARE @RowCntPending   INTEGER
   DECLARE @OldPohId   UNIQUEIDENTIFIER
   
   DECLARE @SysHoldWarehouseId  UNIQUEIDENTIFIER
   DECLARE @DefaultWarehouseId  UNIQUEIDENTIFIER

   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''

      /*������ʱ��*/
      CREATE TABLE #tmp_inventory
      (
         INV_ID         UNIQUEIDENTIFIER,
         INV_WHM_ID     UNIQUEIDENTIFIER,
         INV_PMA_ID     UNIQUEIDENTIFIER,
         INV_OnHandQuantity FLOAT PRIMARY KEY (INV_ID)
      )
      /*�����ϸLot��ʱ��*/
      CREATE TABLE #tmp_lot
      (
         LOT_ID         UNIQUEIDENTIFIER,
         LOT_LTM_ID     UNIQUEIDENTIFIER,
         LOT_WHM_ID     UNIQUEIDENTIFIER,
         LOT_PMA_ID     UNIQUEIDENTIFIER,
         LOT_INV_ID     UNIQUEIDENTIFIER,
         LOT_OnHandQty  FLOAT,
         LOT_LotNumber  NVARCHAR (50) COLLATE Chinese_PRC_CI_AS,
         PRIMARY KEY (LOT_ID)
      )
      
      /*����Ƕ��������̣����ȡ��Ӧƽ̨����;���ȱʡ�ֿ⣻�����һ������������Ҫ���¿����Ϣ*/
      IF (Exists(select 1 from DealerMaster t1, POReceiptHeader t2 where t1.DMA_ID=t2.PRH_Dealer_DMA_ID and t2.PRH_ID=@PRHId and t1.DMA_DealerType = 'T2'))
      BEGIN
        --��ȡƽ̨����;�⣬����ж�����ȡ����һ�������û���򱨴�        
        select @SysHoldWarehouseId = Convert(UNIQUEIDENTIFIER,max(Convert(nvarchar(50),WH.WHM_ID)))  from POReceiptHeader PRH, DealerMaster DM, Warehouse WH
         where PRH.PRH_ID=@PRHId and PRH.PRH_Vendor_DMA_ID=DM.DMA_ID 
           and WH.WHM_DMA_ID=DM.DMA_ID and DM.DMA_DealerType='LP'
           and WH.WHM_Type='SystemHold'
           
        --��ȡƽ̨��ȱʡ�⣬����ж�����ȡ����һ�������û���򱨴�
        --����POReceiptHeader���е�shiptype���жϣ�ȡ���Ŀ�����ݻص��ĸ��ֿ�
        select @DefaultWarehouseId = case When PRH.PRH_ShipType = 'Normal' then (select  Convert(UNIQUEIDENTIFIER,max(Convert(nvarchar(50),WH.WHM_ID))) from warehouse AS WH where WH.WHM_DMA_ID=DM.DMA_ID and WH.WHM_Type='DefaultWH' AND WH.WHM_ActiveFlag = 1)
                             else (select  Convert(UNIQUEIDENTIFIER,max(Convert(nvarchar(50),WH.WHM_ID))) from warehouse AS WH where WH.WHM_DMA_ID=DM.DMA_ID and WH.WHM_Type='Borrow' AND WH.WHM_ActiveFlag = 1) end
        from POReceiptHeader PRH, DealerMaster DM
         where PRH.PRH_ID=@PRHId and PRH.PRH_Vendor_DMA_ID=DM.DMA_ID 
           and DM.DMA_DealerType='LP'
        
        IF (@DefaultWarehouseId IS NULL OR @SysHoldWarehouseId IS NULL)
        BEGIN
          RAISERROR ('Can not find warehouse for LP',10,1)
        END
        
        PRINT '11111'
        --Inventory��(��ƽ̨����;���пۼ����)
        INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                    INV_ID,
                                    INV_WHM_ID,
                                    INV_PMA_ID)
        SELECT -sum(POL.PRL_ReceiptQty),newid(),@SysHoldWarehouseId,PD.PMA_ID
          FROM POReceiptHeader t1, DealerMaster t2, dealermaster t3,POReceipt POR , POReceiptLot POL,product PD,cfn
         WHERE     t1.PRH_Dealer_DMA_ID = t2.DMA_ID
               AND t1.PRH_Vendor_DMA_ID = t3.DMA_ID
               AND POR.POR_ID=POL.PRL_POR_ID
               and POR.POR_SAP_PMA_ID=PD.PMA_ID
               and PD.PMA_CFN_ID=cfn.cfn_ID
               and POR.POR_PRH_ID=t1.PRH_ID
               AND t1.PRH_Type IN ('PurchaseOrder')
               AND t1.PRH_ID=@PRHId
               AND t1.PRH_Status = 'Waiting'
               group by PD.PMA_ID 
        
        PRINT '22222'
        --Inventory��(�ڹ��ƺ�̩��ȱʡ�������ӿ��)
        INSERT INTO #tmp_inventory (INV_OnHandQuantity,
                                  INV_ID,
                                  INV_WHM_ID,
                                  INV_PMA_ID)
        SELECT sum(POL.PRL_ReceiptQty),newid(),@DefaultWarehouseId,PD.PMA_ID
          FROM POReceiptHeader t1, DealerMaster t2, dealermaster t3,POReceipt POR , POReceiptLot POL,product PD,cfn
         WHERE     t1.PRH_Dealer_DMA_ID = t2.DMA_ID
               AND t1.PRH_Vendor_DMA_ID = t3.DMA_ID
               AND POR.POR_ID=POL.PRL_POR_ID
               and POR.POR_SAP_PMA_ID=PD.PMA_ID
               and PD.PMA_CFN_ID=cfn.cfn_ID
               and POR.POR_PRH_ID=t1.PRH_ID
               AND t1.PRH_Type IN ('PurchaseOrder')
               AND t1.PRH_ID=@PRHId
               AND t1.PRH_Status = 'Waiting'
               group by PD.PMA_ID 
           
        PRINT '33333'   
        --���¿������ڵĸ��£������ڵ�����
        UPDATE Inventory
        SET    Inventory.INV_OnHandQuantity = CONVERT (DECIMAL (18, 6), Inventory.INV_OnHandQuantity) + CONVERT (DECIMAL (18, 6), TMP.INV_OnHandQuantity)
        FROM   #tmp_inventory AS TMP
        WHERE      Inventory.INV_WHM_ID = TMP.INV_WHM_ID
               AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID
        
        PRINT '44444'
        INSERT INTO Inventory (INV_OnHandQuantity,
                             INV_ID,
                             INV_WHM_ID,
                             INV_PMA_ID)
         SELECT INV_OnHandQuantity,
                INV_ID,
                INV_WHM_ID,
                INV_PMA_ID
         FROM   #tmp_inventory AS TMP
         WHERE  NOT EXISTS
                   (SELECT 1
                    FROM   Inventory INV
                    WHERE      INV.INV_WHM_ID = TMP.INV_WHM_ID
                           AND INV.INV_PMA_ID = TMP.INV_PMA_ID)
                           
                           
        PRINT '55555'
        --Lot��(��LP����;�ֿ��пۼ����)
        INSERT INTO #tmp_lot (LOT_ID,
                            LOT_LTM_ID,
                            LOT_WHM_ID,
                            LOT_PMA_ID,
                            LOT_LotNumber,
                            LOT_OnHandQty)
        SELECT  newid(),LM.LTM_ID,@SysHoldWarehouseId,PD.PMA_ID,POL.PRL_LotNumber,-sum(POL.PRL_ReceiptQty)
          FROM POReceiptHeader t1, DealerMaster t2, dealermaster t3,POReceipt POR , POReceiptLot POL,product PD,cfn,Lotmaster LM
         WHERE     t1.PRH_Dealer_DMA_ID = t2.DMA_ID
               AND t1.PRH_Vendor_DMA_ID = t3.DMA_ID
               AND POR.POR_ID=POL.PRL_POR_ID
               and POR.POR_SAP_PMA_ID=PD.PMA_ID
               and PD.PMA_CFN_ID=cfn.cfn_ID
               and POR.POR_PRH_ID=t1.PRH_ID
               AND LM.LTM_Product_PMA_ID = PD.PMA_ID
               and LM.LTM_LotNumber = POL.PRL_LotNumber
               AND t1.PRH_Type IN ('PurchaseOrder')
               AND t1.PRH_ID=@PRHId
               AND t1.PRH_Status = 'Waiting'
               group by PD.PMA_ID,LM.LTM_ID, POL.PRL_LotNumber
        
        PRINT '66666'       
        --Lot��(��LP��ȱʡ�ֿ������ӿ��)
        INSERT INTO #tmp_lot (LOT_ID,
                            LOT_LTM_ID,
                            LOT_WHM_ID,
                            LOT_PMA_ID,
                            LOT_LotNumber,
                            LOT_OnHandQty)
        SELECT  newid(),LM.LTM_ID,@DefaultWarehouseId,PD.PMA_ID,POL.PRL_LotNumber,sum(POL.PRL_ReceiptQty)
          FROM POReceiptHeader t1, DealerMaster t2, dealermaster t3,POReceipt POR , POReceiptLot POL,product PD,cfn,Lotmaster LM
         WHERE     t1.PRH_Dealer_DMA_ID = t2.DMA_ID
               AND t1.PRH_Vendor_DMA_ID = t3.DMA_ID
               AND POR.POR_ID=POL.PRL_POR_ID
               and POR.POR_SAP_PMA_ID=PD.PMA_ID
               and PD.PMA_CFN_ID=cfn.cfn_ID
               and POR.POR_PRH_ID=t1.PRH_ID
               AND LM.LTM_Product_PMA_ID = PD.PMA_ID
               and LM.LTM_LotNumber = POL.PRL_LotNumber
               AND t1.PRH_Type IN ('PurchaseOrder')
               AND t1.PRH_ID=@PRHId
               AND t1.PRH_Status = 'Waiting'
               group by PD.PMA_ID,LM.LTM_ID, POL.PRL_LotNumber         
               
        PRINT '77777'
        --���¹����������
        UPDATE #tmp_lot
        SET    LOT_INV_ID = INV.INV_ID
        FROM   Inventory INV
        WHERE      INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
               AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

        PRINT '88888'
        --�������α����ڵĸ��£������ڵ�����
        UPDATE Lot
        SET    Lot.LOT_OnHandQty = CONVERT (DECIMAL (18, 6), Lot.LOT_OnHandQty) + CONVERT (DECIMAL (18, 6), TMP.LOT_OnHandQty)
        FROM   #tmp_lot AS TMP
        WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
               AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

        INSERT INTO Lot (LOT_ID,
                         LOT_LTM_ID,
                         LOT_OnHandQty,
                         LOT_INV_ID)
           SELECT LOT_ID,
                  LOT_LTM_ID,
                  LOT_OnHandQty,
                  LOT_INV_ID
           FROM   #tmp_lot AS TMP
           WHERE  NOT EXISTS
                     (SELECT 1
                      FROM   Lot
                      WHERE      Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
                             AND Lot.LOT_INV_ID = TMP.LOT_INV_ID) 
                             
        --��¼��������־
        --Inventory��
        SELECT inv.INV_OnHandQuantity AS ITR_Quantity,
               NEWID () AS ITR_ID,
               '00000000-0000-0000-0000-000000000000' AS ITR_ReferenceID,
               'LP�������⳷��' AS ITR_Type,
               inv.INV_WHM_ID AS ITR_WHM_ID,
               inv.INV_PMA_ID AS ITR_PMA_ID,
               0 AS ITR_UnitPrice,
               (SELECT isnull (PRH_PONumber, '') + '(' + isnull (PRH_SAPShipmentID, '') + ')'
                  FROM POReceiptHeader
                 WHERE PRH_ID = @PRHId) AS ITR_TransDescription
        INTO   #tmp_invtrans
        FROM   #tmp_inventory AS inv

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
           FROM   #tmp_invtrans 
           
        
        --��¼��������־
        --Lot��
        SELECT lot.LOT_OnHandQty AS ITL_Quantity,
               newid () AS ITL_ID,
               itr.ITR_ID AS ITL_ITR_ID,
               lot.LOT_LTM_ID AS ITL_LTM_ID,
               lot.LOT_LotNumber AS ITL_LotNumber
        INTO   #tmp_invtranslot
        FROM   #tmp_lot AS lot
               INNER JOIN #tmp_invtrans AS itr
                  ON     itr.ITR_PMA_ID = lot.LOT_PMA_ID
                     AND itr.ITR_WHM_ID = lot.LOT_WHM_ID

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
           FROM   #tmp_invtranslot        
      END
      
      --���¶�Ӧ����������
      --������������Ĳ�Ʒ��ϸ��������
      CREATE TABLE #TMP_ORDER
      (
         PohId          UNIQUEIDENTIFIER,
         PodId          UNIQUEIDENTIFIER,
         ReceiptQty     DECIMAL (18, 6),
         PRIMARY KEY (PohId, PodId)
      )      
      
      --����ǽ��Ӷ����������Ž��и��£��ǽ��Ӷ��������ͺŽ��и���
      INSERT INTO #TMP_ORDER (PohId, PodId, ReceiptQty)
         SELECT POH.POH_ID, POD.POD_ID, SUM (Lot.PRL_ReceiptQty )
         FROM   POReceiptHeader AS H
                INNER JOIN POReceipt AS L ON H.PRH_ID = L.POR_PRH_ID
                INNER JOIN POReceiptLot AS Lot ON L.POR_ID = Lot.PRL_POR_ID
                INNER JOIN PurchaseOrderHeader AS POH ON POH.POH_OrderNo = H.PRH_PurchaseOrderNbr
                INNER JOIN PurchaseOrderDetail AS POD ON (POD.POD_POH_ID = POH.POH_ID and POD.POD_LotNumber=Lot.PRL_LotNumber )
                INNER JOIN Product AS P
                   ON     P.PMA_ID = L.POR_SAP_PMA_ID
                      AND P.PMA_CFN_ID = POD.POD_CFN_ID
                INNER JOIN CFN AS C ON C.CFN_ID = P.PMA_CFN_ID
         Where POH.POH_OrderType in ('Transfer')
           AND C.CFN_ProductLine_BUM_ID NOT IN ('97a4e135-74c7-4802-af23-9d6d00fcb2cc') --������CRM
           AND H.PRH_ID=@PRHId
         GROUP BY POH.POH_ID, POD.POD_ID
         
      INSERT INTO #TMP_ORDER (PohId, PodId, ReceiptQty)
         SELECT POH.POH_ID, POD.POD_ID, SUM (L.POR_ReceiptQty)
         FROM   POReceiptHeader AS H
                INNER JOIN POReceipt AS L ON H.PRH_ID = L.POR_PRH_ID
                INNER JOIN PurchaseOrderHeader AS POH ON POH.POH_OrderNo = H.PRH_PurchaseOrderNbr
                INNER JOIN PurchaseOrderDetail AS POD ON POD.POD_POH_ID = POH.POH_ID
                INNER JOIN Product AS P
                   ON     P.PMA_ID = L.POR_SAP_PMA_ID
                      AND P.PMA_CFN_ID = POD.POD_CFN_ID
                INNER JOIN CFN AS C ON C.CFN_ID = P.PMA_CFN_ID
         Where POH.POH_OrderType not in ('Transfer')
           AND C.CFN_ProductLine_BUM_ID NOT IN ('97a4e135-74c7-4802-af23-9d6d00fcb2cc') --������CRM
           AND H.PRH_ID=@PRHId
         GROUP BY POH.POH_ID, POD.POD_ID
      
      --CRM��Ʒ����6λ�̱�Ž��и���
      --����ǽ��Ӷ�������ʹ�ö̱�ţ���Ϊ��ͬ��UPN�����ſ϶��ǲ�ͬ�ģ�
      INSERT INTO #TMP_ORDER (PohId, PodId, ReceiptQty)
         SELECT POH.POH_ID, POD.POD_ID, SUM (Lot.PRL_ReceiptQty)
         FROM   POReceiptHeader AS H
                INNER JOIN POReceipt AS L ON H.PRH_ID = L.POR_PRH_ID
                INNER JOIN POReceiptLot AS Lot ON L.POR_ID = Lot.PRL_POR_ID
                INNER JOIN PurchaseOrderHeader AS POH ON POH.POH_OrderNo = H.PRH_PurchaseOrderNbr
                INNER JOIN PurchaseOrderDetail AS POD ON (POD.POD_POH_ID = POH.POH_ID and POD.POD_LotNumber=Lot.PRL_LotNumber)
                INNER JOIN Product AS P
                   ON     P.PMA_ID = L.POR_SAP_PMA_ID
                      AND P.PMA_CFN_ID = POD.POD_CFN_ID
                INNER JOIN CFN AS C ON C.CFN_ID = P.PMA_CFN_ID
         Where POH.POH_OrderType in ('Transfer')
           AND C.CFN_ProductLine_BUM_ID IN ('97a4e135-74c7-4802-af23-9d6d00fcb2cc') --����CRM
           AND H.PRH_ID=@PRHId
         GROUP BY POH.POH_ID, POD.POD_ID
         
         
      --�ǽ��Ӷ�����ʹ�ö̱��   
      INSERT INTO #TMP_ORDER (PohId, PodId, ReceiptQty)
         SELECT POH.POH_ID, POD.POD_ID, SUM (L.POR_ReceiptQty)
         FROM   POReceiptHeader AS H
                INNER JOIN POReceipt AS L ON H.PRH_ID = L.POR_PRH_ID
                INNER JOIN PurchaseOrderHeader AS POH ON POH.POH_OrderNo = H.PRH_PurchaseOrderNbr
                INNER JOIN PurchaseOrderDetail AS POD ON POD.POD_POH_ID = POH.POH_ID
                INNER JOIN Product AS P ON P.PMA_ID = L.POR_SAP_PMA_ID --AND P.PMA_CFN_ID = POD.POD_CFN_ID
                INNER JOIN CFN AS C1 ON C1.CFN_ID = P.PMA_CFN_ID
                INNER JOIN CFN AS C2 ON (C2.CFN_ID = POD.POD_CFN_ID and substring(C1.CFN_CustomerFaceNbr,1,6) = substring(C2.CFN_CustomerFaceNbr,1,6))
         Where POH.POH_OrderType not in ('Transfer')
           AND C1.CFN_ProductLine_BUM_ID IN ('97a4e135-74c7-4802-af23-9d6d00fcb2cc') --����CRM
           AND C2.CFN_ProductLine_BUM_ID IN ('97a4e135-74c7-4802-af23-9d6d00fcb2cc') --����CRM
           AND H.PRH_ID=@PRHId
         GROUP BY POH.POH_ID, POD.POD_ID      
      
      
      --���¶�����ϸ������
      UPDATE PurchaseOrderDetail
      SET    POD_ReceiptQty = POD_ReceiptQty - TMP.ReceiptQty
      FROM   #TMP_ORDER AS TMP
      WHERE      TMP.PohId = PurchaseOrderDetail.POD_POH_ID
             AND TMP.PodId = PurchaseOrderDetail.POD_ID
             AND EXISTS
                    (SELECT 1
                     FROM   PurchaseOrderDetail AS D
                     WHERE  D.POD_ID = TMP.PodId)
  
      
      --���µ���״̬
      --���¶�����ͷ״̬
      UPDATE PurchaseOrderHeader
      SET    POH_OrderStatus = 'Delivering'
      WHERE  POH_ID IN (SELECT DISTINCT PohId FROM #TMP_ORDER)
      --AND POH_OrderStatus = 'Confirmed'

      UPDATE PurchaseOrderHeader
      SET    POH_OrderStatus = 'Confirmed'
      WHERE      POH_ID IN (SELECT DISTINCT PohId FROM #TMP_ORDER)
             AND POH_OrderStatus = 'Delivering'
             AND NOT EXISTS
                    (SELECT 1
                     FROM   PurchaseOrderDetail
                     WHERE      PurchaseOrderDetail.POD_POH_ID = PurchaseOrderHeader.POH_ID
                            AND POD_ReceiptQty>0)
      
      --��¼��־ 
      --��¼��־��
      INSERT INTO PurchaseOrderLog (POL_ID,
                                    POL_POH_ID,
                                    POL_OperUser,
                                    POL_OperDate,
                                    POL_OperType,
                                    POL_OperNote)
         SELECT newid () AS POL_ID,
                @PRHId AS POL_POH_ID,
                @UserId AS POL_OperUser,
                getdate () AS POL_OperDate,
                N'Cancel' AS POL_OperType,
                N'����Ҫ��ȡ���ջ���' AS POL_OperNote
         
      --�����ջ���״̬
      update POReceiptHeader set PRH_Status='Cancelled' where PRH_ID=@PRHId
      
      
      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @RtnVal = 'Failure'

      --��¼������־��ʼ
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError =
               '��'
             + CONVERT (NVARCHAR (10), @error_line)
             + '����[�����'
             + CONVERT (NVARCHAR (10), @error_number)
             + '],'
             + @error_message
      SET @RtnMsg = @vError
      --EXEC dbo.GC_Interface_Log 'Confirmation', 'Failure', @vError

      RETURN -1
   END CATCH
GO


