DROP FUNCTION [dbo].[GC_Fn_AOPSales]
GO


CREATE FUNCTION [dbo].[GC_Fn_AOPSales]
(
	@UserId UNIQUEIDENTIFIER,
	@SubjectId UNIQUEIDENTIFIER,
	@SubjectType NVARCHAR(50)
)
RETURNS INTEGER
AS

BEGIN
	DECLARE @Ret INTEGER
	DECLARE @UserType VARCHAR(20)
	DECLARE @OrgId VARCHAR(36)
	DECLARE @SubjectOrgId VARCHAR(36)
	SET @Ret = 0
	
	/*检查是否是美敦力用户*/
	SELECT @UserType = Identity_Type FROM Lafite_IDENTITY WHERE Id = CONVERT(VARCHAR(36),@UserId)
	
	IF @UserType IS NULL OR @UserType = 'Dealer' GOTO RetVal
		
	/*取得当前用户所属组织机构*/
	SELECT @OrgId = MAP_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization' AND IDENTITY_ID = CONVERT(VARCHAR(36),@UserId)
	
	IF @@ROWCOUNT = 0 GOTO RetVal
			
	/*判断考核主体类型*/
	IF @SubjectType IN ('SaleMGR','Sale')
		BEGIN
			/*考核主体为人，则取得该考核主体所属的组织机构*/
			SELECT @SubjectOrgId = MAP_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization' AND IDENTITY_ID = CONVERT(VARCHAR(36),@SubjectId)
			
			IF @@ROWCOUNT = 0 GOTO RetVal
		END
	ELSE
		SET @SubjectOrgId = CONVERT(VARCHAR(36),@SubjectId)
	/*判断组织机构是否存在上下级关系*/	
	SELECT @Ret = COUNT(*) FROM dbo.Cache_OrganizationUnits WHERE RootID = @OrgId AND AttributeID = @SubjectOrgId

	RetVal:
		RETURN @Ret
END


GO


