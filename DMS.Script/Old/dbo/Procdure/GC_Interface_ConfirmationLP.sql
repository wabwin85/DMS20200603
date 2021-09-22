DROP PROCEDURE [dbo].[GC_Interface_ConfirmationLP]
GO


/*
���������ӿڴ���
*/
CREATE PROCEDURE [dbo].[GC_Interface_ConfirmationLP]
   @BatchNbr       NVARCHAR (30),
   @ClientID       NVARCHAR (50),
   @RtnVal         NVARCHAR (20) OUTPUT,
   @RtnMsg         NVARCHAR (MAX) OUTPUT
AS
   SET  NOCOUNT ON
   DECLARE @SysUserId   UNIQUEIDENTIFIER
   DECLARE @ErrCnt   INT
   DECLARE @DeleteCnt   INT

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'

      --RAISERROR ('Job id 1 expects the default level of 10.', 16, 1)
      --���������ӿ���ÿ���ṩ���������Ķ���������жϷ����ӿ��������Ƿ����Ѵ��ڵĶ����Ų��滻
      --�Ƿ���Ҫ����SAP�����ţ��ٴθ��µĶ�������SAP�������Ƿ��ı䣿
      --����Flag��ʶ�ж��Ƿ���Ҫ����
      --modified@20110708 ���нӿ����ݶ���Ҫ����
      DELETE FROM PurchaseOrderConfirmation
       WHERE POC_BatchNbr = @BatchNbr

      --���ӿڱ��е����ݲ��뵽������¼���У�ֻ��ҪFlag��ʶΪ��Ҫ���µļ�¼
      INSERT INTO PurchaseOrderConfirmation (POC_ID,                      --ID
                                             POC_OrderNo,                --������
                                             POC_ArticleNumber,         --��Ʒ�ͺ�
                                             POC_OrderNum,              --��������
                                             POC_Price,                 --��Ʒ����
                                             POC_Amount,                --���С��
                                             POC_LineNbr,                 --�к�
                                             POC_FileName,
                                             POC_ImportDate,
                                             POC_Dealer_SapCode,
                                             POC_ClientID,
                                             POC_BatchNbr)
         SELECT NEWID (),
                ICO_OrderNo,                                            --�������
                ICO_ArticleNumber,                                      --��Ʒ�ͺ�
                ICO_OrderNum,                                           --��������
                ICO_UnitPrice,                                          --��Ʒ����
                CONVERT (
                   DECIMAL (18, 6),
                   isnull (ICO_OrderNum, 0) * isnull (ICO_UnitPrice, 0)), --���С��
                ICO_LineNbr,                                              --�к�
                ISNULL (ICO_FileName, ''),
                ICO_ImportDate,                                         --����ʱ��
                ICO_Dealer_SapCode,
                ICO_ClientID,
                ICO_BatchNbr
           FROM InterfaceConfirmation(nolock)
          WHERE ICO_BatchNbr = @BatchNbr

      --��δ���µ������ķ������ݵĴ�����Ϣ����Ʒ�ߡ���Ʒ�������Ȩ������ʼ��
      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription = NULL,
             POC_Authorized = 0,
             POC_BUM_ID = NULL,
             POC_PCT_ID = NULL
       WHERE POC_POD_ID IS NULL AND POC_BatchNbr = @BatchNbr

      --����������
      UPDATE PurchaseOrderConfirmation
         SET POC_POH_ID = POH_ID, POC_HandleDate = getdate ()
        FROM PurchaseOrderHeader(nolock)
       WHERE     POH_OrderNo = POC_OrderNo
             AND POC_POH_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --��龭����
      UPDATE PurchaseOrderConfirmation
         SET POC_DMA_ID = DMA_ID, POC_HandleDate = getdate ()
        FROM DealerMaster(nolock)
       WHERE     DMA_SAP_Code = POC_Dealer_SapCode
             AND POC_DMA_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --����Ʒ�ͺ�
      UPDATE PurchaseOrderConfirmation
         SET POC_CFN_ID = CFN_ID, POC_HandleDate = getdate ()
        FROM CFN(nolock)
       WHERE     CFN_CustomerFaceNbr = POC_ArticleNumber
             AND POC_CFN_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --����Ʒ�ߺͲ�Ʒ���ࣨ��������һ��һ��д����Ϊ���ܲ�Ʒ�ߺͷ��෢���˱����
      UPDATE A
         SET POC_BUM_ID = CFN_ProductLine_BUM_ID,
             POC_PCT_ID = ccf.ClassificationId,
             POC_HandleDate = getdate ()
        FROM PurchaseOrderConfirmation A
        inner join CFN(nolock) on CFN.CFN_ID = A.POC_CFN_ID
        inner join CfnClassification ccf on ccf.CfnCustomerFaceNbr=cfn.CFN_CustomerFaceNbr 
        and ccf.ClassificationId in (select ProducPctId from GC_FN_GetDealerAuthProductSub(a.POC_DMA_ID))
       WHERE     
              POC_CFN_ID IS NOT NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --����Ʒ��������Ȩ(���������̲���Ҫ�����Ȩ)
      UPDATE PurchaseOrderConfirmation
         SET POC_Authorized = 1, POC_HandleDate = getdate () --DBO.GC_Fn_CFN_CheckDealerAuth (POC_DMA_ID, POC_CFN_ID)
       WHERE     POC_DMA_ID IS NOT NULL
             AND POC_CFN_ID IS NOT NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --���´�����Ϣ
      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription = N'�����̲�����'
       WHERE     POC_DMA_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription =
                (CASE
                    WHEN POC_ProblemDescription IS NULL
                    THEN
                       N'��Ʒ�ͺŲ�����'
                    ELSE
                       POC_ProblemDescription + N',��Ʒ�ͺŲ�����'
                 END)
       WHERE     POC_CFN_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription =
                (CASE
                    WHEN POC_ProblemDescription IS NULL
                    THEN
                       N'��Ʒ��δ����'
                    ELSE
                       POC_ProblemDescription + N',��Ʒ��δ����'
                 END)
       WHERE     POC_CFN_ID IS NOT NULL
             AND POC_BUM_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription =
                (CASE
                    WHEN POC_ProblemDescription IS NULL
                    THEN
                       N'��������������'
                    ELSE
                       POC_ProblemDescription + N',��������������'
                 END)
       WHERE     POC_POH_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --      UPDATE PurchaseOrderConfirmation
      --      SET    POC_ProblemDescription =
      --                (CASE
      --                    WHEN POC_ProblemDescription IS NULL THEN N'δ����Ȩ'
      --                    ELSE POC_ProblemDescription + N',δ����Ȩ'
      --                 END)
      --      WHERE      POC_Authorized = 0
      --             AND POC_POD_ID IS NULL
      --             AND POC_BatchNbr = @BatchNbr

      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription =
                (CASE
                    WHEN POC_ProblemDescription IS NULL
                    THEN
                       N'������������Ϊ��'
                    ELSE
                       POC_ProblemDescription + N',������������Ϊ��'
                 END)
       WHERE     POC_OrderNum IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription =
                (CASE
                    WHEN POC_ProblemDescription IS NULL
                    THEN
                       N'������������С��0'
                    ELSE
                       POC_ProblemDescription + N',������������С��0'
                 END)
       WHERE     POC_OrderNum IS NOT NULL
             AND POC_OrderNum < 0
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --���ڻ��ֶ�����ƽ̨ȷ�ϵ�ʱ�����ȫ��ȷ��ͨ���������ܾ��������޸�  Add By Song Weiming on 2018-09-10
      DECLARE @CPRO_Num int
      
      SELECT @CPRO_Num = count(*) FROM PurchaseOrderHeader 
           where POH_OrderNo in (select POC_OrderNo from PurchaseOrderConfirmation where POC_BatchNbr=@BatchNbr) 
             and POH_CreateType='Manual'
             and POH_OrderType = 'CRPO'
           
      IF (@CPRO_Num > 0)
        BEGIN
      
          
          
          Declare @confirmZero int
          Declare @ConfirmNumEqual int
          
          SELECT @ConfirmNumEqual = count (*) 
            FROM (SELECT POC_OrderNo, POC_CFN_ID, POC_OrderNum
                    FROM PurchaseOrderConfirmation POC, PurchaseOrderHeader H
                   WHERE POC_BatchNbr = @BatchNbr
                    AND POC.POC_OrderNo = H.POH_OrderNo
                    AND POH_CreateType='Manual'
                    AND POH_OrderType = 'CRPO'
                   ) tab1
                 FULL JOIN
                 (SELECT H.POH_OrderNo, D.POD_CFN_ID, D.POD_RequiredQty
                    FROM PurchaseOrderHeader H, PurchaseOrderDetail D
                   WHERE     H.POH_ID = D.POD_POH_ID
                         AND H.POH_OrderNo IN
                                (SELECT max (POC_OrderNo)
                                   FROM PurchaseOrderConfirmation
                                  WHERE POC_BatchNbr = @BatchNbr)
                         AND H.POH_CreateType = 'Manual'
                         AND H.POH_OrderStatus not in ('Rejected','Revoked')
                         AND POH_OrderType = 'CRPO'
                         ) tab2
                    ON (    tab1.POC_OrderNo = tab2.POH_OrderNo
                        AND tab1.POC_CFN_ID = tab2.POD_CFN_ID
                        AND tab1.POC_OrderNum = tab2.POD_RequiredQty)
           WHERE isnull (tab1.POC_OrderNum, 0) <> isnull (tab2.POD_RequiredQty, -1)
          
          
          select @confirmZero = sum(POC_OrderNum) 
            from PurchaseOrderConfirmation
           where POC_BatchNbr=@BatchNbr

          IF ( @ConfirmNumEqual > 0 and @confirmZero >0)
            BEGIN
              --����
              UPDATE PurchaseOrderConfirmation
                   SET POC_ProblemDescription =
                          (CASE
                              WHEN POC_ProblemDescription IS NULL
                              THEN
                                 N'�����޸Ļ��ֶ���'
                              ELSE
                                 POC_ProblemDescription + N',�����޸Ļ��ֶ���'
                           END)
                     WHERE  POC_BatchNbr = @BatchNbr
                       AND POC_OrderNo in (
                    SELECT distinct isnull(POC_OrderNo,POH_OrderNo)
                    FROM (SELECT POC_OrderNo, POC_CFN_ID, POC_OrderNum
                            FROM PurchaseOrderConfirmation POC, PurchaseOrderHeader H
                           WHERE POC_BatchNbr = @BatchNbr
                            AND POC.POC_OrderNo = H.POH_OrderNo
                            AND POH_CreateType='Manual'
                            AND POH_OrderType = 'CRPO'
                           ) tab1
                         FULL JOIN
                         (SELECT H.POH_OrderNo, D.POD_CFN_ID, D.POD_RequiredQty
                            FROM PurchaseOrderHeader H, PurchaseOrderDetail D
                           WHERE     H.POH_ID = D.POD_POH_ID
                                 AND H.POH_OrderNo IN
                                        (SELECT max (POC_OrderNo)
                                           FROM PurchaseOrderConfirmation
                                          WHERE POC_BatchNbr = @BatchNbr)
                                 AND H.POH_CreateType = 'Manual'
                                 AND H.POH_OrderStatus  not in ('Rejected','Revoked')) tab2
                            ON (    tab1.POC_OrderNo = tab2.POH_OrderNo
                                AND tab1.POC_CFN_ID = tab2.POD_CFN_ID
                                AND tab1.POC_OrderNum = tab2.POD_RequiredQty)
                   WHERE isnull (tab1.POC_OrderNum, 0) <> isnull (tab2.POD_RequiredQty, -1)
                   )
                   
               
            END
            
            
            
          END
      
      --UPDATE PurchaseOrderConfirmation
      --   SET POC_ProblemDescription =
      --          (CASE
      --              WHEN POC_ProblemDescription IS NULL
      --              THEN
      --                 N'��ͬ�۸����ͬ��Ʒ���ܳ�����ͬһ�Ŷ�����'
      --              ELSE
      --                   POC_ProblemDescription
      --                 + N'��ͬ�۸����ͬ��Ʒ���ܳ�����ͬһ�Ŷ�����'
      --           END)
      -- WHERE     POC_POD_ID IS NULL
      --       AND POC_BatchNbr = @BatchNbr
      --       AND EXISTS
      --              (SELECT 1
      --                 FROM (SELECT POC_POH_ID, POC_CFN_ID
      --                         FROM (SELECT DISTINCT
      --                                      POC_POH_ID, POC_CFN_ID, POC_Price
      --                                 FROM PurchaseOrderConfirmation
      --                                WHERE     POC_POD_ID IS NULL
      --                                      AND POC_BatchNbr = @BatchNbr) AS Detail
      --                       GROUP BY POC_POH_ID, POC_CFN_ID
      --                       HAVING count (*) > 1) AS errTab
      --                WHERE     errTab.POC_POH_ID =
      --                             PurchaseOrderConfirmation.POC_POH_ID
      --                      AND errTab.POC_CFN_ID =
      --                             PurchaseOrderConfirmation.POC_CFN_ID)

      SELECT @ErrCnt = count (*)
      FROM PurchaseOrderConfirmation(nolock)
      WHERE POC_BatchNbr = @BatchNbr AND POC_ProblemDescription IS NOT NULL

      IF (@ErrCnt = 0)
         BEGIN
            --�������µĶ�����ϸ���뵽��ʱ��
            CREATE TABLE #TMP_ORDER
            (
               ConfirmationId   UNIQUEIDENTIFIER,
               HeaderId         UNIQUEIDENTIFIER,
               DetailId         UNIQUEIDENTIFIER,
               CfnId            UNIQUEIDENTIFIER,
               Price            DECIMAL (18, 6),
               RequiredQty      DECIMAL (18, 6),
               Amount           DECIMAL (18, 6),
               Tax              DECIMAL (18, 6),
               ReceiptQty       DECIMAL (18, 6),
               SapOrderNo       NVARCHAR (50),
               SapCreateDate    DATETIME,
               Flag             NVARCHAR (20),                 --����Ϊ0�ľ��Ǳ�ʾҪɾ����
               UOM              NVARCHAR (100)
            )

            --������ϸ���Ƿ����ԭʼ������������DetailId
            INSERT INTO #TMP_ORDER (ConfirmationId,
                                    HeaderId,                         --��������ID
                                    DetailId,                         --������ϸID
                                    CfnId,                              --��ƷID
                                    Price,                              --��Ʒ����
                                    RequiredQty,                        --��������
                                    Amount,                             --���С��
                                    Tax,
                                    ReceiptQty,
                                    UOM)
               SELECT CONVERT (UNIQUEIDENTIFIER,
                               MAX (CONVERT (NVARCHAR (100), POC_ID))),
                      POC_POH_ID,                                     --��������ID
                      NEWID (),                                       --������ϸID
                      POC_CFN_ID,                                       --��ƷID
                      POC_Price,                                        --��Ʒ����
                      SUM (ISNULL (POC_OrderNum, 0)),                   --��������
                      SUM (ISNULL (POC_Amount, 0)),                     --���С��
                      0,                                         --����������˰��̶�Ϊ0
                      0,                                                --�ջ�����
                      (SELECT cfn_property3
                         FROM cfn(nolock)
                        WHERE cfn.cfn_id =
                                 PurchaseOrderConfirmation.POC_CFN_ID)
                         AS UOM
                 FROM PurchaseOrderConfirmation(nolock)
                WHERE     POC_ProblemDescription IS NULL
                      AND POC_POD_ID IS NULL
                      AND POC_BatchNbr = @BatchNbr
               GROUP BY POC_POH_ID, POC_CFN_ID, POC_Price

            --����flag
            UPDATE #TMP_ORDER
               SET Flag = 'X'
             WHERE RequiredQty <= 0

            --���ݶ�����ͷ����ϸ����ʷ��
            INSERT INTO PurchaseOrderHeaderHistory (POH_ID,
                                                    POH_OrderNo,
                                                    POH_ProductLine_BUM_ID,
                                                    POH_DMA_ID,
                                                    POH_VendorID,
                                                    POH_TerritoryCode,
                                                    POH_RDD,
                                                    POH_ContactPerson,
                                                    POH_Contact,
                                                    POH_ContactMobile,
                                                    POH_Consignee,
                                                    POH_ShipToAddress,
                                                    POH_ConsigneePhone,
                                                    POH_Remark,
                                                    POH_InvoiceComment,
                                                    POH_CreateType,
                                                    POH_CreateUser,
                                                    POH_CreateDate,
                                                    POH_UpdateUser,
                                                    POH_UpdateDate,
                                                    POH_SubmitUser,
                                                    POH_SubmitDate,
                                                    POH_LastBrowseUser,
                                                    POH_LastBrowseDate,
                                                    POH_OrderStatus,
                                                    POH_LatestAuditDate,
                                                    POH_IsLocked,
                                                    POH_SAP_OrderNo,
                                                    POH_SAP_ConfirmDate,
                                                    POH_Version,
                                                    POH_VersionDate,
                                                    POH_OrderType,
                                                    POH_VirtualDC,
                                                    POH_SpecialPriceID,
                                                    POH_WHM_ID,
                                                    POH_POH_ID)
               SELECT POH_ID,
                      POH_OrderNo,
                      POH_ProductLine_BUM_ID,
                      POH_DMA_ID,
                      POH_VendorID,
                      POH_TerritoryCode,
                      POH_RDD,
                      POH_ContactPerson,
                      POH_Contact,
                      POH_ContactMobile,
                      POH_Consignee,
                      POH_ShipToAddress,
                      POH_ConsigneePhone,
                      POH_Remark,
                      POH_InvoiceComment,
                      POH_CreateType,
                      POH_CreateUser,
                      POH_CreateDate,
                      POH_UpdateUser,
                      POH_UpdateDate,
                      POH_SubmitUser,
                      POH_SubmitDate,
                      POH_LastBrowseUser,
                      POH_LastBrowseDate,
                      POH_OrderStatus,
                      POH_LatestAuditDate,
                      POH_IsLocked,
                      POH_SAP_OrderNo,
                      POH_SAP_ConfirmDate,
                      POH_LastVersion + 1,
                      GETDATE (),
                      POH_OrderType,
                      POH_VirtualDC,
                      POH_SpecialPriceID,
                      POH_WHM_ID,
                      POH_POH_ID
                 FROM PurchaseOrderHeader(nolock)
                WHERE POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)

            INSERT INTO PurchaseOrderDetailHistory (POD_ID,
                                                    POD_POH_ID,
                                                    POD_CFN_ID,
                                                    POD_CFN_Price,
                                                    POD_UOM,
                                                    POD_RequiredQty,
                                                    POD_Amount,
                                                    POD_Tax,
                                                    POD_ReceiptQty,
                                                    POD_Status,
                                                    POD_Version,
                                                    POD_VersionDate,
                                                    POD_LotNumber)
               SELECT D.POD_ID,
                      D.POD_POH_ID,
                      D.POD_CFN_ID,
                      D.POD_CFN_Price,
                      D.POD_UOM,
                      D.POD_RequiredQty,
                      D.POD_Amount,
                      D.POD_Tax,
                      D.POD_ReceiptQty,
                      D.POD_Status,
                      H.POH_LastVersion + 1,
                      GETDATE (),
                      POD_LotNumber
                 FROM PurchaseOrderDetail AS D(nolock)
                      INNER JOIN PurchaseOrderHeader AS H(nolock)
                         ON H.POH_ID = D.POD_POH_ID
                WHERE H.POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)

            --�����������Ժ����жϣ��Ƿ�ÿһ���Ķ�����ϸ��������Ϊ0��
            --�����Ϊ0������˵���״̬��Ҫ�޸�Ϊ"����"��������Ҫ���´˶�������ϸ�����������̿���ѡ���ƶ���������������

            --���¶�����ͷ����ϸ
            --�����Ѵ���ԭʼ��������ϸ��
            UPDATE PurchaseOrderDetail
               SET POD_CFN_Price = TMP.Price,
                   POD_UOM = TMP.UOM,
                   POD_RequiredQty = TMP.RequiredQty,
                   POD_Amount = TMP.Amount,
                   POD_Tax = TMP.Tax
              FROM #TMP_ORDER AS TMP
             WHERE     TMP.HeaderId = PurchaseOrderDetail.POD_POH_ID
                   AND TMP.CfnId = PurchaseOrderDetail.POD_CFN_ID
                   AND TMP.Price = PurchaseOrderDetail.POD_CFN_Price
                   AND EXISTS
                          (SELECT 1
                             FROM PurchaseOrderDetail AS D(nolock)
                            WHERE     D.POD_POH_ID = TMP.HeaderId
                                  AND D.POD_CFN_ID = TMP.CfnId)
                   AND TMP.HeaderId IN (SELECT DISTINCT HeaderId
                                          FROM #TMP_ORDER
                                         WHERE Flag IS NULL)

            --���벻����ԭʼ��������ϸ��
            INSERT INTO PurchaseOrderDetail (POD_ID,
                                             POD_POH_ID,
                                             POD_CFN_ID,
                                             POD_CFN_Price,
                                             POD_UOM,
                                             POD_RequiredQty,
                                             POD_Amount,
                                             POD_Tax,
                                             POD_ReceiptQty)
               SELECT DetailId,
                      HeaderId,
                      CfnId,
                      Price,
                      UOM,
                      RequiredQty,
                      Amount,
                      Tax,
                      ReceiptQty
                 FROM #TMP_ORDER AS TMP
                WHERE     NOT EXISTS
                                 (SELECT 1
                                    FROM PurchaseOrderDetail AS D(nolock)
                                   WHERE     D.POD_POH_ID = TMP.HeaderId
                                         AND D.POD_CFN_ID = TMP.CfnId
                                         AND D.POD_CFN_Price = TMP.Price)
                      AND TMP.HeaderId IN (SELECT DISTINCT HeaderId
                                             FROM #TMP_ORDER
                                            WHERE Flag IS NULL)

            --ɾ���������ڽӿ��е�ԭʼ������ϸ��
            DELETE FROM PurchaseOrderDetail
             WHERE     NOT EXISTS
                              (SELECT 1
                                 FROM #TMP_ORDER AS TMP
                                WHERE     TMP.HeaderId =
                                             PurchaseOrderDetail.POD_POH_ID
                                      AND TMP.CfnId =
                                             PurchaseOrderDetail.POD_CFN_ID
                                      AND PurchaseOrderDetail.POD_CFN_Price = TMP.Price)
                   AND PurchaseOrderDetail.POD_POH_ID IN
                          (SELECT DISTINCT HeaderId
                             FROM #TMP_ORDER
                            WHERE Flag IS NULL)


            --���¹���������ϸ�����ֶ�
            UPDATE #TMP_ORDER
               SET DetailId = D.POD_ID, ReceiptQty = D.POD_ReceiptQty
              FROM PurchaseOrderDetail AS D(nolock)
             WHERE     D.POD_CFN_ID = #TMP_ORDER.CfnId
                   AND D.POD_POH_ID = #TMP_ORDER.HeaderId
                   AND EXISTS
                          (SELECT 1
                             FROM #TMP_ORDER AS TMP
                            WHERE     TMP.HeaderId = D.POD_POH_ID
                                  AND TMP.CfnId = D.POD_CFN_ID)
                   AND D.POD_POH_ID IN (SELECT DISTINCT HeaderId
                                          FROM #TMP_ORDER
                                         WHERE Flag IS NULL)

            --��Щ����ȡ����������Ҫɾ��Flag��Ϊ�յ�����,Ҫ����һ��֮������ԭ����Ҫ��֤#TMP_ORDER.DetailId����ֵ
            DELETE FROM PurchaseOrderDetail
             WHERE     EXISTS
                          (SELECT 1
                             FROM #TMP_ORDER AS TMP
                            WHERE     TMP.HeaderId =
                                         PurchaseOrderDetail.POD_POH_ID
                                  AND TMP.CfnId =
                                         PurchaseOrderDetail.POD_CFN_ID
                                  AND TMP.Flag IS NOT NULL)
                   AND PurchaseOrderDetail.POD_POH_ID IN
                          (SELECT DISTINCT HeaderId
                             FROM #TMP_ORDER
                            WHERE Flag IS NULL)

            --���¶�����ͷ�����Ϣ
            --����ԭʼ״̬Ϊ�����ɽӿڵĶ���״̬Ϊ�ѽ���SAP
            UPDATE PurchaseOrderHeader
               SET POH_OrderStatus = 'Confirmed'
             WHERE POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)

            --AND POH_OrderStatus = 'Uploaded'  --?�Ƿ�Ҫ�޶���Uploaded״̬�ļ�¼�Ÿ���

            --���¶�����Ϣ,������ȡ���Ķ���
            UPDATE PurchaseOrderHeader
               SET POH_SAP_OrderNo = TMP.SapOrderNo,
                   POH_SAP_ConfirmDate = TMP.SapCreateDate,
                   POH_OrderStatus =
                      (CASE
                          WHEN     POH_OrderStatus = 'Confirmed'
                               AND TMP.RequiredQty <= TMP.ReceiptQty
                          THEN
                             'Completed'
                          WHEN     POH_OrderStatus = 'Confirmed'
                               AND TMP.RequiredQty > TMP.ReceiptQty
                               AND TMP.ReceiptQty > 0
                          THEN
                             'Delivering'
                          WHEN     POH_OrderStatus = 'Completed'
                               AND TMP.RequiredQty > TMP.ReceiptQty
                               AND TMP.ReceiptQty > 0
                          THEN
                             'Delivering'
                          WHEN     POH_OrderStatus = 'Completed'
                               AND TMP.RequiredQty > TMP.ReceiptQty
                               AND TMP.ReceiptQty = 0
                          THEN
                             'Confirmed'
                          WHEN     POH_OrderStatus = 'Delivering'
                               AND TMP.RequiredQty <= TMP.ReceiptQty
                          THEN
                             'Completed'
                          WHEN     POH_OrderStatus = 'Delivering'
                               AND TMP.RequiredQty > TMP.ReceiptQty
                               AND TMP.ReceiptQty = 0
                          THEN
                             'Confirmed'
                          ELSE
                             POH_OrderStatus
                       END),
                   POH_LastVersion = POH_LastVersion + 1
              FROM (SELECT HeaderId,
                           MAX (SapOrderNo) AS SapOrderNo,
                           MAX (SapCreateDate) AS SapCreateDate,
                           SUM (RequiredQty) AS RequiredQty,
                           SUM (ReceiptQty) AS ReceiptQty
                      FROM #TMP_ORDER
                     WHERE Flag IS NULL
                    GROUP BY HeaderId) AS TMP
             WHERE     TMP.HeaderId = PurchaseOrderHeader.POH_ID
                   AND EXISTS
                          (SELECT 1
                             FROM PurchaseOrderHeader AS H(nolock)
                            WHERE H.POH_ID = TMP.HeaderId)

            --������ȡ���Ķ�������������ϸ�ı�־��Ϊɾ������ö���ȡ��
            --Updated by Yangshaowei,����ö���Ϊȡ��������״̬��Ϊ��Rejected �Ѿܾ��������ǡ�����ɡ�
            UPDATE PurchaseOrderHeader
               SET POH_SAP_OrderNo = TMP.SapOrderNo,
                   POH_SAP_ConfirmDate = TMP.SapCreateDate,
                   --POH_OrderStatus = 'Completed',
                   POH_OrderStatus = 'Revoked',
                   POH_LastVersion = POH_LastVersion + 1
              FROM (SELECT HeaderId,
                           MAX (SapOrderNo) AS SapOrderNo,
                           MAX (SapCreateDate) AS SapCreateDate,
                           SUM (RequiredQty) AS RequiredQty,
                           SUM (ReceiptQty) AS ReceiptQty
                      FROM #TMP_ORDER
                     WHERE HeaderId NOT IN (SELECT DISTINCT HeaderId
                                              FROM #TMP_ORDER
                                             WHERE Flag IS NULL)
                    GROUP BY HeaderId) AS TMP
             WHERE     TMP.HeaderId = PurchaseOrderHeader.POH_ID
                   AND EXISTS
                          (SELECT 1
                             FROM PurchaseOrderHeader AS H(nolock)
                            WHERE H.POH_ID = TMP.HeaderId)

            --���¶��������ӿڹ���������ϸ������
            UPDATE PurchaseOrderConfirmation
               SET POC_POD_ID = TMP.DetailId
              FROM #TMP_ORDER AS TMP
             WHERE     TMP.ConfirmationId = PurchaseOrderConfirmation.POC_ID
                   AND EXISTS
                          (SELECT 1
                             FROM PurchaseOrderConfirmation AS C(nolock)
                            WHERE C.POC_ID = TMP.ConfirmationId)

            --�����з�����Ϣ�Ķ������ż��ʼ��������
            INSERT INTO MailMessageProcess (MMP_ID,
                                            MMP_Code,
                                            MMP_ProcessId,
                                            MMP_Status,
                                            MMP_CreateDate)
               SELECT NEWID (),
                      'EMAIL_ORDER_CONFIRM',
                      T.HeaderId,
                      'Waiting',
                      GETDATE ()
                 FROM (SELECT DISTINCT HeaderId FROM #TMP_ORDER) AS T

            --      INSERT INTO ShortMessageProcess (SMP_ID,
            --                                       SMP_Code,
            --                                       SMP_ProcessId,
            --                                       SMP_Status,
            --                                       SMP_CreateDate)
            --         SELECT NEWID (),
            --                'SMS_ORDER_CONFIRMED',
            --                T.HeaderId,
            --                'Waiting',
            --                GETDATE ()
            --         FROM   (SELECT DISTINCT HeaderId FROM #TMP_ORDER) AS T

            --�����з�����Ϣ�Ķ�����־,������ȡ���Ķ���
            INSERT INTO PurchaseOrderLog (POL_ID,
                                          POL_POH_ID,
                                          POL_OperUser,
                                          POL_OperDate,
                                          POL_OperType,
                                          POL_OperNote)
               SELECT NEWID (),
                      T.HeaderId,
                      @SysUserId,
                      GETDATE (),
                      'Confirm',
                      '����ƽ̨�ӿ�ȷ�϶���'
                 FROM (SELECT HeaderId
                         FROM #TMP_ORDER
                        WHERE Flag IS NULL
                        GROUP BY HeaderId ) AS T

            --����ȡ���Ķ�������־
            INSERT INTO PurchaseOrderLog (POL_ID,
                                          POL_POH_ID,
                                          POL_OperUser,
                                          POL_OperDate,
                                          POL_OperType,
                                          POL_OperNote)
               SELECT NEWID (),
                      T.HeaderId,
                      @SysUserId,
                      GETDATE (),
                      'Confirm',
                      '����ƽ̨�ӿڳ�������'
                 FROM (SELECT HeaderId
                         FROM #TMP_ORDER
                        WHERE HeaderId NOT IN (SELECT DISTINCT HeaderId
                                                 FROM #TMP_ORDER
                                                WHERE Flag IS NULL)
                        GROUP BY HeaderId) AS T
         /*
         --����������Ϣ���ı䶩��״̬Ϊ����ɵĶ������ż��ʼ��������
         INSERT INTO ShortMessageProcess (SMP_ID,SMP_Code,SMP_ProcessId,SMP_Status)
         SELECT NEWID(),'EMAIL_ORDER_COMPLETED',T.HeaderId,'Waiting'
         FROM (SELECT POH_ID AS HeaderId FROM PurchaseOrderHeader
         WHERE POH_OrderStatus = 'Completed'
         AND POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)) AS T
         */

         END

      COMMIT TRAN

      --��¼�ɹ���־
      --EXEC dbo.GC_Interface_Log 'Confirmation', 'Success', ''

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


