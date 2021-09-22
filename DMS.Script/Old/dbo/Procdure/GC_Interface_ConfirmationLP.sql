DROP PROCEDURE [dbo].[GC_Interface_ConfirmationLP]
GO


/*
订单反馈接口处理
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
      --订单反馈接口中每次提供的是完整的订单，因此判断反馈接口数据中是否有已存在的订单号并替换
      --是否需要关联SAP订单号，再次更新的订单它的SAP订单号是否会改变？
      --根据Flag标识判断是否需要更新
      --modified@20110708 所有接口数据都需要导入
      DELETE FROM PurchaseOrderConfirmation
       WHERE POC_BatchNbr = @BatchNbr

      --将接口表中的数据插入到反馈记录表中，只需要Flag标识为需要更新的记录
      INSERT INTO PurchaseOrderConfirmation (POC_ID,                      --ID
                                             POC_OrderNo,                --订单号
                                             POC_ArticleNumber,         --产品型号
                                             POC_OrderNum,              --订购数量
                                             POC_Price,                 --产品单价
                                             POC_Amount,                --金额小计
                                             POC_LineNbr,                 --行号
                                             POC_FileName,
                                             POC_ImportDate,
                                             POC_Dealer_SapCode,
                                             POC_ClientID,
                                             POC_BatchNbr)
         SELECT NEWID (),
                ICO_OrderNo,                                            --订单编号
                ICO_ArticleNumber,                                      --产品型号
                ICO_OrderNum,                                           --订购数量
                ICO_UnitPrice,                                          --产品单价
                CONVERT (
                   DECIMAL (18, 6),
                   isnull (ICO_OrderNum, 0) * isnull (ICO_UnitPrice, 0)), --金额小计
                ICO_LineNbr,                                              --行号
                ISNULL (ICO_FileName, ''),
                ICO_ImportDate,                                         --导入时间
                ICO_Dealer_SapCode,
                ICO_ClientID,
                ICO_BatchNbr
           FROM InterfaceConfirmation(nolock)
          WHERE ICO_BatchNbr = @BatchNbr

      --将未更新到订单的反馈数据的错误信息、产品线、产品分类和授权等做初始化
      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription = NULL,
             POC_Authorized = 0,
             POC_BUM_ID = NULL,
             POC_PCT_ID = NULL
       WHERE POC_POD_ID IS NULL AND POC_BatchNbr = @BatchNbr

      --检查关联订单
      UPDATE PurchaseOrderConfirmation
         SET POC_POH_ID = POH_ID, POC_HandleDate = getdate ()
        FROM PurchaseOrderHeader(nolock)
       WHERE     POH_OrderNo = POC_OrderNo
             AND POC_POH_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --检查经销商
      UPDATE PurchaseOrderConfirmation
         SET POC_DMA_ID = DMA_ID, POC_HandleDate = getdate ()
        FROM DealerMaster(nolock)
       WHERE     DMA_SAP_Code = POC_Dealer_SapCode
             AND POC_DMA_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --检查产品型号
      UPDATE PurchaseOrderConfirmation
         SET POC_CFN_ID = CFN_ID, POC_HandleDate = getdate ()
        FROM CFN(nolock)
       WHERE     CFN_CustomerFaceNbr = POC_ArticleNumber
             AND POC_CFN_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --检查产品线和产品分类（不能与上一步一起写，因为可能产品线和分类发生了变更）
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

      --检查产品经销商授权(二级经销商不需要检查授权)
      UPDATE PurchaseOrderConfirmation
         SET POC_Authorized = 1, POC_HandleDate = getdate () --DBO.GC_Fn_CFN_CheckDealerAuth (POC_DMA_ID, POC_CFN_ID)
       WHERE     POC_DMA_ID IS NOT NULL
             AND POC_CFN_ID IS NOT NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --更新错误信息
      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription = N'经销商不存在'
       WHERE     POC_DMA_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription =
                (CASE
                    WHEN POC_ProblemDescription IS NULL
                    THEN
                       N'产品型号不存在'
                    ELSE
                       POC_ProblemDescription + N',产品型号不存在'
                 END)
       WHERE     POC_CFN_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription =
                (CASE
                    WHEN POC_ProblemDescription IS NULL
                    THEN
                       N'产品线未关联'
                    ELSE
                       POC_ProblemDescription + N',产品线未关联'
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
                       N'关联订单不存在'
                    ELSE
                       POC_ProblemDescription + N',关联订单不存在'
                 END)
       WHERE     POC_POH_ID IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --      UPDATE PurchaseOrderConfirmation
      --      SET    POC_ProblemDescription =
      --                (CASE
      --                    WHEN POC_ProblemDescription IS NULL THEN N'未做授权'
      --                    ELSE POC_ProblemDescription + N',未做授权'
      --                 END)
      --      WHERE      POC_Authorized = 0
      --             AND POC_POD_ID IS NULL
      --             AND POC_BatchNbr = @BatchNbr

      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription =
                (CASE
                    WHEN POC_ProblemDescription IS NULL
                    THEN
                       N'订购数量不能为空'
                    ELSE
                       POC_ProblemDescription + N',订购数量不能为空'
                 END)
       WHERE     POC_OrderNum IS NULL
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      UPDATE PurchaseOrderConfirmation
         SET POC_ProblemDescription =
                (CASE
                    WHEN POC_ProblemDescription IS NULL
                    THEN
                       N'订购数量不能小于0'
                    ELSE
                       POC_ProblemDescription + N',订购数量不能小于0'
                 END)
       WHERE     POC_OrderNum IS NOT NULL
             AND POC_OrderNum < 0
             AND POC_POD_ID IS NULL
             AND POC_BatchNbr = @BatchNbr

      --对于积分订单，平台确认的时候必须全部确认通过或审批拒绝，不能修改  Add By Song Weiming on 2018-09-10
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
              --报错
              UPDATE PurchaseOrderConfirmation
                   SET POC_ProblemDescription =
                          (CASE
                              WHEN POC_ProblemDescription IS NULL
                              THEN
                                 N'不能修改积分订单'
                              ELSE
                                 POC_ProblemDescription + N',不能修改积分订单'
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
      --                 N'不同价格的相同产品不能出现在同一张订单中'
      --              ELSE
      --                   POC_ProblemDescription
      --                 + N'不同价格的相同产品不能出现在同一张订单中'
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
            --将待更新的订单明细插入到临时表
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
               Flag             NVARCHAR (20),                 --数量为0的就是表示要删除的
               UOM              NVARCHAR (100)
            )

            --不论明细行是否存在原始订单，先生成DetailId
            INSERT INTO #TMP_ORDER (ConfirmationId,
                                    HeaderId,                         --订单主表ID
                                    DetailId,                         --订单明细ID
                                    CfnId,                              --产品ID
                                    Price,                              --产品单价
                                    RequiredQty,                        --订购数量
                                    Amount,                             --金额小计
                                    Tax,
                                    ReceiptQty,
                                    UOM)
               SELECT CONVERT (UNIQUEIDENTIFIER,
                               MAX (CONVERT (NVARCHAR (100), POC_ID))),
                      POC_POH_ID,                                     --订单主表ID
                      NEWID (),                                       --订单明细ID
                      POC_CFN_ID,                                       --产品ID
                      POC_Price,                                        --产品单价
                      SUM (ISNULL (POC_OrderNum, 0)),                   --订购数量
                      SUM (ISNULL (POC_Amount, 0)),                     --金额小计
                      0,                                         --二级经销商税金固定为0
                      0,                                                --收货数量
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

            --更新flag
            UPDATE #TMP_ORDER
               SET Flag = 'X'
             WHERE RequiredQty <= 0

            --备份订单表头和明细到历史表
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

            --备份完数据以后，先判断，是否每一条的订单明细的数量都为0，
            --如果都为0，代表此单据状态需要修改为"撤销"，而不需要更新此订单的明细数量，经销商可以选择复制订单进行重新新增

            --更新订单表头和明细
            --更新已存在原始订单的明细行
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

            --插入不存在原始订单的明细行
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

            --删除不存在于接口中的原始订单明细行
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


            --更新关联订单明细主键字段
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

            --那些不是取消订单的需要删除Flag不为空的数据,要在上一步之后做，原因是要保证#TMP_ORDER.DetailId都有值
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

            --更新订单表头相关信息
            --更新原始状态为已生成接口的订单状态为已进入SAP
            UPDATE PurchaseOrderHeader
               SET POH_OrderStatus = 'Confirmed'
             WHERE POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)

            --AND POH_OrderStatus = 'Uploaded'  --?是否要限定是Uploaded状态的记录才更新

            --更新订单信息,不包含取消的订单
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

            --更新已取消的订单，若所有明细的标志都为删除，则该订单取消
            --Updated by Yangshaowei,如果该订单为取消，则将其状态置为“Rejected 已拒绝”，而非“已完成”
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

            --更新订单反馈接口关联订单明细行主键
            UPDATE PurchaseOrderConfirmation
               SET POC_POD_ID = TMP.DetailId
              FROM #TMP_ORDER AS TMP
             WHERE     TMP.ConfirmationId = PurchaseOrderConfirmation.POC_ID
                   AND EXISTS
                          (SELECT 1
                             FROM PurchaseOrderConfirmation AS C(nolock)
                            WHERE C.POC_ID = TMP.ConfirmationId)

            --处理有反馈信息的订单短信及邮件到处理表
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

            --处理有反馈信息的订单日志,不包含取消的订单
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
                      '物流平台接口确认订单'
                 FROM (SELECT HeaderId
                         FROM #TMP_ORDER
                        WHERE Flag IS NULL
                        GROUP BY HeaderId ) AS T

            --处理取消的订单的日志
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
                      '物流平台接口撤销订单'
                 FROM (SELECT HeaderId
                         FROM #TMP_ORDER
                        WHERE HeaderId NOT IN (SELECT DISTINCT HeaderId
                                                 FROM #TMP_ORDER
                                                WHERE Flag IS NULL)
                        GROUP BY HeaderId) AS T
         /*
         --处理因反馈信息而改变订单状态为已完成的订单短信及邮件到处理表
         INSERT INTO ShortMessageProcess (SMP_ID,SMP_Code,SMP_ProcessId,SMP_Status)
         SELECT NEWID(),'EMAIL_ORDER_COMPLETED',T.HeaderId,'Waiting'
         FROM (SELECT POH_ID AS HeaderId FROM PurchaseOrderHeader
         WHERE POH_OrderStatus = 'Completed'
         AND POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)) AS T
         */

         END

      COMMIT TRAN

      --记录成功日志
      --EXEC dbo.GC_Interface_Log 'Confirmation', 'Success', ''

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
      --EXEC dbo.GC_Interface_Log 'Confirmation', 'Failure', @vError

      RETURN -1
   END CATCH

GO


