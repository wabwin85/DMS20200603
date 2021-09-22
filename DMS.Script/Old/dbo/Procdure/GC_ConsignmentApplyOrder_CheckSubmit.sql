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
			--检查产品授权
			UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + '授权未通过'
			WHERE ErrorDesc IS NULL AND dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,CfnId) = 0
			--检查是否可订购
			UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + '不可订购'
			WHERE ErrorDesc IS NULL AND dbo.GC_Fn_CFN_CheckDealerCanOrder(@DealerId,CfnId) = 0
			
			--检查订购数量和金额是否大于0
			UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + '订购数量与金额必须大于0'
			WHERE ErrorDesc IS NULL AND (CfnQty <= 0 OR CfnAmount <=0)
			--检查是否存在有效注册证信息
			UPDATE #TMP_CHECK SET IsReg = dbo.GC_Fn_CFN_CheckRegistration(ArticleNumber)
			WHERE ErrorDesc IS NULL
			--检查是否在寄售规则内
			UPDATE #TMP_CHECK SET ErrorDesc = ArticleNumber + '产品不在寄售期规则内'
			WHERE ErrorDesc IS NULL AND dbo.GC_Fn_CFN_ConsignmentAuth(@DealerId,@ProductLineId,CfnId,@CMID)= 0
			--拼接错误信息
			SET @RtnMsg = (SELECT ErrorDesc + ',' FROM #TMP_CHECK WHERE ErrorDesc IS NOT NULL ORDER BY ArticleNumber FOR XML PATH(''))
		END
	ELSE
		SET @RtnMsg = '请添加产品'
		
	IF LEN(@RtnMsg) > 0
		SET @RtnVal = 'Error'
	ELSE 
		IF EXISTS (SELECT 1 FROM #TMP_CHECK WHERE ErrorDesc IS NULL AND IsReg = 0)
			BEGIN
				--拼接警告信息
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
	SET @RtnRegMsg = @vError
    return -1
    
END CATCH

GO


