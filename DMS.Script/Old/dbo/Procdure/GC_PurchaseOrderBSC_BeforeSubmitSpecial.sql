DROP PROCEDURE [dbo].[GC_PurchaseOrderBSC_BeforeSubmitSpecial]
GO

/*
�����ύǰ���
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

            --У������۸��Ʒ�Ƿ�����¶�������������1������۸������Ƿ�����˲�Ʒ��2���˲�Ʒ�Ƿ�����¶���
            UPDATE #TMP_CHECK
               SET ErrorDesc =
                        ArticleNumber
                      + '�˲�Ʒ�����¶�������۸����߲������˲�Ʒ'
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

            --��鶩�������ͽ���Ƿ����0
            UPDATE #TMP_CHECK
               SET ErrorDesc =
                      ArticleNumber + '������������������0'
             WHERE ErrorDesc IS NULL AND (CfnQty <= 0 OR CfnAmount <= 0)

            --��������۸��Ʒ�Ŀ��������Ƿ��㹻
            UPDATE TMP
               SET ErrorDesc =
                      ArticleNumber + '�˲�Ʒ�ɶ�����������'
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

            --��������۸��Ʒ�Ľ���Ƿ���ȷ
            UPDATE TMP
               SET ErrorDesc =
                        ArticleNumber
                      + '�˲�Ʒ�۸�������а����Ĳ�Ʒ�۸�һ��'
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

            --ƴ�Ӵ�����Ϣ
            SET @RtnMsg =
                   ISNULL ( (SELECT ErrorDesc + '$$'
                               FROM #TMP_CHECK
                              WHERE ErrorDesc IS NOT NULL
                             ORDER BY ArticleNumber
                             FOR XML PATH ( '' )),
                           '')
         END
      ELSE
         SET @RtnMsg = '����Ӳ�Ʒ'

      IF LEN (@RtnMsg) > 0
         SET @RtnVal = 'Error'
      ELSE
         IF EXISTS
               (SELECT 1
                  FROM #TMP_CHECK
                 WHERE ErrorDesc IS NULL AND IsReg = 0)
            BEGIN
               --ƴ�Ӿ�����Ϣ
               SET @RtnVal = 'Warn'
               SET @RtnMsg =
                        (SELECT ArticleNumber + '$$'
                           FROM #TMP_CHECK
                          WHERE ErrorDesc IS NULL AND IsReg = 0
                         ORDER BY ArticleNumber
                         FOR XML PATH ( '' ))
                      + '��Ʒ��δ���ע�ᣬ������ѧ��չʾ֮�ã����ý������ۡ�'
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


