DROP Procedure [dbo].[GC_PurchaseOrder_CheckSubmitNew]
GO

/*
订单提交前检查
*/
CREATE Procedure [dbo].[GC_PurchaseOrder_CheckSubmitNew]
    @PohId uniqueidentifier,
	@DealerId uniqueidentifier,
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(MAX) OUTPUT,
	@RtnRegMsg NVARCHAR(MAX) OUTPUT
AS
    DECLARE @ErrorCount INTEGER
	
	CREATE TABLE #TMP_CHECK(
		CfnId uniqueidentifier,
		ArticleNumber NVARCHAR(200),
		CfnQty decimal(18,6),
		CfnAmount decimal(18,6),
		ErrorDesc NVARCHAR(400),
		IsReg bit,
		PRIMARY KEY (CfnId)
	)
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @RtnRegMsg = ''
	IF EXISTS (SELECT 1 FROM PurchaseOrderDetail WHERE POD_POH_ID = @PohId)
		BEGIN
			INSERT INTO #TMP_CHECK
			SELECT C.CFN_ID,C.CFN_CustomerFaceNbr,D.POD_RequiredQty,D.POD_Amount,NULL,NULL 
			FROM PurchaseOrderDetail AS D
			INNER JOIN CFN AS C ON C.CFN_ID = D.POD_CFN_ID
			WHERE D.POD_POH_ID = @PohId
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
			
			--拼接错误信息
			DECLARE MsgCursor CURSOR FOR
				SELECT ErrorDesc FROM #TMP_CHECK WHERE ErrorDesc IS NOT NULL ORDER BY ArticleNumber
			DECLARE @Msg NVARCHAR(400)
			
			OPEN MsgCursor
			FETCH NEXT FROM MsgCursor INTO @Msg
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @RtnMsg = @RtnMsg + @Msg + '<BR/>'
					FETCH NEXT FROM MsgCursor INTO @Msg
				END
			CLOSE MsgCursor
			DEALLOCATE MsgCursor			
		END
	ELSE
		SET @RtnMsg = '请添加产品'
		
	IF LEN(@RtnMsg) > 0
		SET @RtnVal = 'Error'
	ELSE 
		IF EXISTS (SELECT 1 FROM #TMP_CHECK WHERE ErrorDesc IS NULL AND IsReg = 0)
			BEGIN
				--拼接警告信息
				DECLARE RegMsgCursor CURSOR FOR
					SELECT ArticleNumber FROM #TMP_CHECK WHERE ErrorDesc IS NULL AND IsReg = 0 ORDER BY ArticleNumber
				DECLARE @RegMsg NVARCHAR(400)
				
				OPEN RegMsgCursor
				FETCH NEXT FROM RegMsgCursor INTO @RegMsg
				WHILE @@FETCH_STATUS = 0
					BEGIN
						SET @RtnRegMsg = @RtnRegMsg + @RegMsg + ','
						FETCH NEXT FROM RegMsgCursor INTO @RegMsg
					END
				CLOSE RegMsgCursor
				DEALLOCATE RegMsgCursor			

				SET @RtnVal = 'Warn' 
				SET @RtnRegMsg = SUBSTRING(@RtnRegMsg,1,LEN(@RtnRegMsg) - 1) + '产品尚未完成注册，仅供教学、展示之用，不得进行销售。'
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


