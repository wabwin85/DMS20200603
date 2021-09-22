DROP  Procedure [dbo].[GC_Check_ArticleNumber]
GO


/*
PTά����Ӳ�Ʒʱ�������Ƿ����̡���Ʒ�ߡ������������Ͳ�Ʒ�ͺ��ж��Ƿ��ǺϷ��Ĳ�Ʒ
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
	--���ArticleNumber�Ƿ�������ѡ��Ĳ�Ʒ��
	SELECT @CfnId = CFN_ID FROM CFN WHERE CFN_CustomerFaceNbr =  @ArticleNumber AND CFN_ProductLine_BUM_ID = @ProductLineId
	IF @@ROWCOUNT = 0
		SET @RtnMsg = @ArticleNumber + '������'
	ELSE
		BEGIN
			--�����Ȩ
			IF @IsDealer = 1 AND dbo.GC_Fn_CFN_CheckDealerAuth(@DealerId,@CfnId) = 0
				SET @RtnMsg = @ArticleNumber + '��Ȩδͨ��'
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


