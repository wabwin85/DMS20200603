DROP PROCEDURE [dbo].[GC_PurchaseOrderBSC_BeforeSubmitSpecial]
GO

/*
订单提交前检查
*/
CREATE PROCEDURE [dbo].[GC_PurchaseOrderBSC_BeforeSubmitSpecial]
   @PohId                UNIQUEIDENTIFIER,
   @DealerId             UNIQUEIDENTIFIER,
   @SpecialPriceId       UNIQUEIDENTIFIER,
   @RtnVal               NVARCHAR (20) OUTPUT,
   @RtnMsg               NVARCHAR (1000) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER

   CREATE TABLE #TMP_CHECK
   (
      CfnId           UNIQUEIDENTIFIER,
      ArticleNumber   NVARCHAR (30),
      CfnQty          DECIMAL (18, 6),
      CfnPrice        DECIMAL (18, 6),
      CfnAmount       DECIMAL (18, 6),
      ErrorDesc       NVARCHAR (50),
      IsReg           BIT,
      PRIMARY KEY (CfnId)
   )

   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''

      IF EXISTS
            (SELECT 1
               FROM PurchaseOrderDetail
              WHERE POD_POH_ID = @PohId)
         BEGIN
            INSERT INTO #TMP_CHECK
               SELECT C.CFN_ID,
                      C.CFN_CustomerFaceNbr,
                      D.POD_RequiredQty,
                      D.POD_CFN_Price,
                      D.POD_Amount,
                      NULL,
                      NULL
                 FROM PurchaseOrderDetail AS D
                      INNER JOIN CFN AS C ON C.CFN_ID = D.POD_CFN_ID
                WHERE D.POD_POH_ID = @PohId
               ORDER BY C.CFN_CustomerFaceNbr

            --校验特殊价格产品是否可以下定（两个条件：1、特殊价格政策是否包含此产品；2、此产品是否可以下定）
            UPDATE #TMP_CHECK
               SET ErrorDesc =
                        ArticleNumber
                      + '此产品不可下定或特殊价格政策不包含此产品'
             WHERE     ErrorDesc IS NULL
                   AND CfnId NOT IN
                          (SELECT CFN.CFN_ID
                             FROM (SELECT Detail.SPD_CFN_ID,
                                          Detail.SPD_Price,
                                          Detail.SPD_AvailableQty
                                     FROM SpecialPriceMaster Master,
                                          SpecialPriceDetail Detail
                                    WHERE     Master.SPM_ID =
                                                 Detail.SPD_SPM_ID
                                          AND Master.SPM_ID = @SpecialPriceId
                                          AND Master.SPM_DMA_ID = @DealerId
                                          AND Detail.SPD_AvailableQty > 0) AS SPD
                                  INNER JOIN CFN
                                     ON (SPD.SPD_CFN_ID = CFN.CFN_ID)
                            WHERE CFN_Property4 = '1')

            --检查订购数量和金额是否大于0
            UPDATE #TMP_CHECK
               SET ErrorDesc =
                      ArticleNumber + '订购数量与金额必须大于0'
             WHERE ErrorDesc IS NULL AND (CfnQty <= 0 OR CfnAmount <= 0)

            --检验特殊价格产品的可用数量是否足够
            UPDATE TMP
               SET ErrorDesc =
                      ArticleNumber + '此产品可订购数量不足'
              FROM (SELECT CFN.CFN_ID,
                           SPD.SPD_Price AS Price,
                           SPD.SPD_AvailableQty AS Avaiable
                      FROM (SELECT Detail.SPD_CFN_ID,
                                   Detail.SPD_Price,
                                   Detail.SPD_AvailableQty
                              FROM SpecialPriceMaster Master,
                                   SpecialPriceDetail Detail
                             WHERE     Master.SPM_ID = Detail.SPD_SPM_ID
                                   AND Master.SPM_ID = @SpecialPriceId
                                   AND Master.SPM_DMA_ID = @DealerId
                                   AND Detail.SPD_AvailableQty > 0) AS SPD
                           INNER JOIN CFN ON (SPD.SPD_CFN_ID = CFN.CFN_ID)
                     WHERE CFN_Property4 = '1') AS TAB
                   INNER JOIN #TMP_CHECK AS TMP ON (TAB.CFN_ID = TMP.CfnId)
             WHERE TMP.ErrorDesc IS NULL AND TAB.Avaiable < TMP.CfnQty

            --检验特殊价格产品的金额是否正确
            UPDATE TMP
               SET ErrorDesc =
                        ArticleNumber
                      + '此产品价格与规则中包含的产品价格不一致'
              FROM (SELECT CFN.CFN_ID,
                           SPD.SPD_Price AS Price,
                           SPD.SPD_AvailableQty AS Avaiable
                      FROM (SELECT Detail.SPD_CFN_ID,
                                   Detail.SPD_Price,
                                   Detail.SPD_AvailableQty
                              FROM SpecialPriceMaster Master,
                                   SpecialPriceDetail Detail
                             WHERE     Master.SPM_ID = Detail.SPD_SPM_ID
                                   AND Master.SPM_ID = @SpecialPriceId
                                   AND Master.SPM_DMA_ID = @DealerId
                                   AND Detail.SPD_AvailableQty > 0) AS SPD
                           INNER JOIN CFN ON (SPD.SPD_CFN_ID = CFN.CFN_ID)
                     WHERE CFN_Property4 = '1') AS TAB
                   INNER JOIN #TMP_CHECK AS TMP ON (TAB.CFN_ID = TMP.CfnId)
             WHERE TMP.ErrorDesc IS NULL AND TAB.Price <> TMP.CfnPrice

            --拼接错误信息
            SET @RtnMsg =
                   ISNULL ( (SELECT ErrorDesc + '$$'
                               FROM #TMP_CHECK
                              WHERE ErrorDesc IS NOT NULL
                             ORDER BY ArticleNumber
                             FOR XML PATH ( '' )),
                           '')
         END
      ELSE
         SET @RtnMsg = '请添加产品'

      IF LEN (@RtnMsg) > 0
         SET @RtnVal = 'Error'
      ELSE
         IF EXISTS
               (SELECT 1
                  FROM #TMP_CHECK
                 WHERE ErrorDesc IS NULL AND IsReg = 0)
            BEGIN
               --拼接警告信息
               SET @RtnVal = 'Warn'
               SET @RtnMsg =
                        (SELECT ArticleNumber + '$$'
                           FROM #TMP_CHECK
                          WHERE ErrorDesc IS NULL AND IsReg = 0
                         ORDER BY ArticleNumber
                         FOR XML PATH ( '' ))
                      + '产品尚未完成注册，仅供教学、展示之用，不得进行销售。'
            END

      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @RtnVal = 'Failure'
      RETURN -1
   END CATCH
GO


