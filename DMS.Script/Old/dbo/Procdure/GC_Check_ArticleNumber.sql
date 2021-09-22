DROP  Procedure [dbo].[GC_Check_ArticleNumber]
GO


/*
PT维修添加产品时，根据是否经销商、产品线、经销商主键和产品型号判断是否是合法的产品
*/
CREATE Procedure [dbo].[GC_Check_ArticleNumber]
	@DealerId uniqueidentifier,
	@ProductLineId uniqueidentifier,
	@ArticleNumber nvarchar(200),
	@IsDealer bit,
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
AS
    DECLARE @ErrorCount INTEGER
	DECLARE @CfnId UNIQUEIDENTIFIER

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	--检查ArticleNumber是否属于所选择的产品线
	SELECT @CfnId = CFN_ID FROM CFN WHERE CFN_CustomerFaceNbr =  @ArticleNumber AND CFN_ProductLine_BUM_ID = @ProductLineId
	IF @@ROWCOUNT = 0
		SET @RtnMsg = @ArticleNumber + '不存在'
	ELSE
		BEGIN
			--检查授权
			IF @IsDealer = 1 AND dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,@CfnId) = 0
				SET @RtnMsg = @ArticleNumber + '授权未通过'
		END
	IF LEN(@RtnMsg) > 0
		SET @RtnVal = 'Error'

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


