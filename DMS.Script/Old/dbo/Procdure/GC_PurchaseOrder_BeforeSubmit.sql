DROP Procedure [dbo].[GC_PurchaseOrder_BeforeSubmit]
GO

/*
�����ύǰ���
*/
CREATE Procedure [dbo].[GC_PurchaseOrder_BeforeSubmit]
    @PohId uniqueidentifier,
	@DealerId uniqueidentifier,
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
AS
    DECLARE @ErrorCount INTEGER
	
	CREATE TABLE #TMP_CHECK(
		CfnId uniqueidentifier,
		ArticleNumber NVARCHAR(30),
		CfnQty decimal(18,6),
		CfnAmount decimal(18,6),
		ErrorDesc NVARCHAR(50),
		IsReg bit,
		PRIMARY KEY (CfnId)
	)
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	IF EXISTS (SELECT 1 FROM PurchaseOrderDetail WHERE POD_POH_ID = @PohId)
		BEGIN
			INSERT INTO #TMP_CHECK
			SELECT C.CFN_ID,C.CFN_CustomerFaceNbr,D.POD_RequiredQty,D.POD_Amount,NULL,NULL 
			FROM PurchaseOrderDetail AS D
			INNER JOIN CFN AS C ON C.CFN_ID = D.POD_CFN_ID
			WHERE D.POD_POH_ID = @PohId
			ORDER BY C.CFN_CustomerFaceNbr
			--����Ʒ��Ȩ
			UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + '��Ȩδͨ��'
			WHERE ErrorDesc IS NULL AND dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,CfnId) = 0
			--����Ƿ�ɶ���
			UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + '���ɶ���'
			WHERE ErrorDesc IS NULL AND dbo.GC_Fn_CFN_CheckDealerCanOrder(@DealerId,CfnId) = 0
			--��鶩�������ͽ���Ƿ����0
			UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + '������������������0'
			WHERE ErrorDesc IS NULL AND (CfnQty <= 0 OR CfnAmount <=0)
			--����Ƿ������Чע��֤��Ϣ
			UPDATE #TMP_CHECK SET IsReg = dbo.GC_Fn_CFN_CheckRegistration(ArticleNumber)
			WHERE ErrorDesc IS NULL
			--���ǹ����Ʒ��һ�ŵ������Ƿ���ڶ����Ʒ��
			declare @cntBUM int;
			select @cntBUM = COUNT(*) FROM (SELECT DISTINCT CFN_ProductLine_BUM_ID from #TMP_CHECK,CFN
			where CfnId = CFN_ID
			and EXISTS(SELECT 1 FROM PartsClassification WHERE PCT_ProductLine_BUM_ID = cfn.CFN_ProductLine_BUM_ID AND PCT_ParentClassification_PCT_ID IS NULL)) TAB
			IF(@cntBUM > 1)
			BEGIN
				UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + 'һ�Ŷ����в�����ͬʱ���ֶ����Ʒ�ߵĲ�Ʒ'
				WHERE ErrorDesc IS NULL
			END
			--ƴ�Ӵ�����Ϣ
			SET @RtnMsg = ISNULL((SELECT ErrorDesc + '$$' FROM #TMP_CHECK WHERE ErrorDesc IS NOT NULL ORDER BY ArticleNumber FOR XML PATH('')),'')
		END
	ELSE
		SET @RtnMsg = '����Ӳ�Ʒ'
		
	IF LEN(@RtnMsg) > 0
		SET @RtnVal = 'Error'
	ELSE 
		IF EXISTS (SELECT 1 FROM #TMP_CHECK WHERE ErrorDesc IS NULL AND IsReg = 0)
			BEGIN
				--ƴ�Ӿ�����Ϣ
				SET @RtnVal = 'Warn' 
				SET @RtnMsg = (SELECT ArticleNumber + '$$' FROM #TMP_CHECK WHERE ErrorDesc IS NULL AND IsReg = 0 ORDER BY ArticleNumber FOR XML PATH('')) + '��Ʒ��δ���ע�ᣬ������ѧ��չʾ֮�ã����ý������ۡ�'
			END
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    return -1
    
END CATCH
GO


