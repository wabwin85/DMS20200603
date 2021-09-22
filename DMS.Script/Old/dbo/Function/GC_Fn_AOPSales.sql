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
	
	/*����Ƿ����������û�*/
	SELECT @UserType = Identity_Type FROM Lafite_IDENTITY WHERE Id = CONVERT(VARCHAR(36),@UserId)
	
	IF @UserType IS NULL OR @UserType = 'Dealer' GOTO RetVal
		
	/*ȡ�õ�ǰ�û�������֯����*/
	SELECT @OrgId = MAP_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization' AND IDENTITY_ID = CONVERT(VARCHAR(36),@UserId)
	
	IF @@ROWCOUNT = 0 GOTO RetVal
			
	/*�жϿ�����������*/
	IF @SubjectType IN ('SaleMGR','Sale')
		BEGIN
			/*��������Ϊ�ˣ���ȡ�øÿ���������������֯����*/
			SELECT @SubjectOrgId = MAP_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization' AND IDENTITY_ID = CONVERT(VARCHAR(36),@SubjectId)
			
			IF @@ROWCOUNT = 0 GOTO RetVal
		END
	ELSE
		SET @SubjectOrgId = CONVERT(VARCHAR(36),@SubjectId)
	/*�ж���֯�����Ƿ�������¼���ϵ*/	
	SELECT @Ret = COUNT(*) FROM dbo.Cache_OrganizationUnits WHERE RootID = @OrgId AND AttributeID = @SubjectOrgId

	RetVal:
		RETURN @Ret
END


GO


