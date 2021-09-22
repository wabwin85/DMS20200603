SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [Workflow].[Proc_DealerReturn_ExecutiveFormBusiness]
	@InstanceId uniqueidentifier,
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS

	--创建退回订单
	DECLARE @SubCompanyId NVARCHAR(50)
	DECLARE @BrandId NVARCHAR(50)
	DECLARE @ProductLineId NVARCHAR(50)

	DECLARE @IAHApplyType NVARCHAR(100)
	DECLARE @ReturnNo NVARCHAR(30)
	DECLARE @ApproveDate NVARCHAR(50)
	DECLARE @ReturnValue NVARCHAR(100)
	SELECT @IAHApplyType=IAH_ApplyType ,@ReturnNo = IAH_Inv_Adj_Nbr,
	@SubCompanyId=SubCompanyId,@BrandId=BrandId FROM InventoryAdjustHeader WHERE IAH_ID = @InstanceId
	
	IF(ISNULL(@SubCompanyId,'')='' OR ISNULL(@BrandId,'')='')
      SELECT @SubCompanyId=SubCompanyId,@BrandId=BrandId FROM  dbo.View_ProductLine WHERE Id=@ProductLineId

	SELECT * FROM dbo.InventoryAdjustHeader
	SET @ApproveDate = CONVERT(NVARCHAR(50),GETDATE(),120)
	
	IF (@IAHApplyType='7' OR @IAHApplyType='Consignment')
	BEGIN
		EXEC Consignment.Proc_CreateOrder 'KA','ConsignReturn',@SubCompanyId,@BrandId,@ReturnNo,'1',NULL,NULL
	END


GO

