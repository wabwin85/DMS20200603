DROP FUNCTION [Contract].[Func_GetRoleRight]
GO


CREATE FUNCTION [Contract].[Func_GetRoleRight]
(
	@UserId        UNIQUEIDENTIFIER,
	@RightName     NVARCHAR(100)
)
RETURNS NVARCHAR(100)
AS
BEGIN
	DECLARE @returnValue NVARCHAR(100)
	
	IF EXISTS (
	       SELECT 1
	       FROM   [Contract].ContractRoleRight
	       WHERE  RoleName IN (SELECT B.ATTRIBUTE_NAME
	                           FROM   Lafite_IDENTITY_MAP A,
	                                  Lafite_ATTRIBUTe B
	                           WHERE  A.MAP_ID = B.Id
	                                  AND A.MAP_TYPE = 'Role'
	                                  AND B.ATTRIBUTE_TYPE = 'Role'
	                                  AND A.IDENTITY_ID = @UserId)
	              AND RightName = @RightName
	              AND RoleRight = '1'
	   )
	BEGIN
	    SET @returnValue = 'True';
	END
	ELSE
	BEGIN
	    SET @returnValue = 'False';
	END
	
	RETURN ISNULL(@returnValue, '')
END
GO


