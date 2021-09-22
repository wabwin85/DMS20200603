DROP FUNCTION [dbo].[GC_Fn_GetDistrictByUserId]
GO


CREATE FUNCTION [dbo].[GC_Fn_GetDistrictByUserId]
(
	@UserId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(50)
AS

BEGIN
	DECLARE @Ret NVARCHAR(50)
	DECLARE @OrgId UNIQUEIDENTIFIER
	DECLARE @OrgType NVARCHAR(50)
	SET @Ret = ''
	
	--得到TSR机构ID
	SELECT @OrgId = MAP_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization' AND IDENTITY_ID = CONVERT(VARCHAR(36),@UserId)
	
	IF @@ROWCOUNT = 0 GOTO RetVal
	
	while exists 
	(SELECT 1 FROM Lafite_ATTRIBUTE_RELATION a,Lafite_ATTRIBUTE b 
		WHERE a.RELATION_TYPE = 'Organization' AND a.ATTRIBUTE2_ID = @OrgId AND a.ATTRIBUTE1_ID = b.Id and b.ATTRIBUTE_TYPE != 'Root')
	begin
		SELECT @OrgId = b.Id, @Ret = b.ATTRIBUTE_NAME, @OrgType = b.ATTRIBUTE_TYPE 
		FROM Lafite_ATTRIBUTE_RELATION a,Lafite_ATTRIBUTE b 
		WHERE a.RELATION_TYPE = 'Organization' AND a.ATTRIBUTE2_ID = @OrgId AND a.ATTRIBUTE1_ID = b.Id
		
		IF @OrgType = 'District' GOTO RetVal
	end 
	
	RetVal:
		IF @OrgType != 'District'
			SET @Ret = ''
		RETURN @Ret
END


GO


