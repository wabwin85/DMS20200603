DROP Procedure [dbo].[GC_ConsignmentApplyOrder_CheckSubmit]
GO

CREATE Procedure [dbo].[GC_ConsignmentApplyOrder_CheckSubmit]
  @CAH_ID uniqueidentifier,    
	@DealerId uniqueidentifier,
	@ProductLineId uniqueidentifier,
	@CMID uniqueidentifier,
  @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT,
	@RtnRegMsg NVARCHAR(1000) OUTPUT
AS
    DECLARE @ErrorCount INTEGER
	
	CREATE TABLE #TMP_CHECK(
		CfnId uniqueidentifier,
		ArticleNumber NVARCHAR(30),
		CfnQty decimal(18,6),
		CfnAmount decimal(18,6),
		ErrorDesc NVARCHAR(50),
		IsReg bit--,
		--PRIMARY KEY (CfnId)
	)
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = '1'
	SET @RtnRegMsg = '2'
	
	IF EXISTS (SELECT 1 FROM ConsignmentApplyDetails WHERE CAD_CAH_ID = @CAH_ID)
		BEGIN
			INSERT INTO #TMP_CHECK
			SELECT C.CFN_ID,C.CFN_CustomerFaceNbr,D.CAD_Qty,D.CAD_Amount,NULL,NULL 
			FROM ConsignmentApplyDetails AS D
			INNER JOIN CFN AS C ON C.CFN_ID = D.CAD_CFN_ID
			WHERE D.CAD_CAH_ID = @CAH_ID
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
			--����Ƿ��ڼ��۹�����
			UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + '��Ʒ���ڼ����ڹ�����'
			WHERE ErrorDesc IS NULL AND dbo.GC_Fn_CFN_ConsignmentAuth(@DealerId,@ProductLineId,CfnId,@CMID)= 0
			--ƴ�Ӵ�����Ϣ
			SET @RtnMsg = (SELECT ErrorDesc + ',' FROM #TMP_CHECK WHERE ErrorDesc IS NOT NULL ORDER BY ArticleNumber FOR XML PATH(''))
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
				SET @RtnMsg = '' 
				SET @RtnRegMsg = (SELECT ArticleNumber + ',' FROM #TMP_CHECK WHERE ErrorDesc IS NULL AND IsReg = 0 ORDER BY ArticleNumber FOR XML PATH(''))
			END
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
   --��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	SET @RtnRegMsg = @vError
    return -1
    
END CATCH

GO


