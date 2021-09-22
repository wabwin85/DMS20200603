DROP FUNCTION [DP].[Func_GetUserRoleRight]
GO


CREATE FUNCTION [DP].[Func_GetUserRoleRight]
(
	@UserId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
	DECLARE @Rtn INT;
	
	SET @Rtn = 0;
	
	IF EXISTS (
	       SELECT 1
	       FROM   Lafite_IDENTITY
	       WHERE  IDENTITY_TYPE = 'User'
	              AND Id = @UserId
	   )
	BEGIN
	    IF EXISTS (
	           --�鿴ȫ��
	           SELECT 1
	           FROM   Lafite_IDENTITY_MAP T1,
	                  Lafite_ATTRIBUTE T2,
	                  DP.RoleRight T3
	           WHERE  T1.MAP_ID = T2.Id
	                  AND T2.ATTRIBUTE_NAME = T3.RoleName
	                  AND T1.MAP_TYPE = 'Role'
	                  AND T2.ATTRIBUTE_TYPE = 'Role'
	                  AND T1.IDENTITY_ID = @UserId
	                  AND T3.RightId = 1
	       )
	    BEGIN
	        SET @Rtn = 1;
	    END
	    ELSE
	    IF EXISTS (
	           --�鿴��BU
	           SELECT 1
	           FROM   Lafite_IDENTITY_MAP T1,
	                  Lafite_ATTRIBUTE T2,
	                  DP.RoleRight T3
	           WHERE  T1.MAP_ID = T2.Id
	                  AND T2.ATTRIBUTE_NAME = T3.RoleName
	                  AND T1.MAP_TYPE = 'Role'
	                  AND T2.ATTRIBUTE_TYPE = 'Role'
	                  AND T1.IDENTITY_ID = @UserId
	                  AND T3.RightId = 2
	       )
	    BEGIN
	        SET @Rtn = 2;
	    END
	    ELSE
	    IF EXISTS (
	           --���۲鿴����������
	           SELECT 1
	           FROM   Lafite_IDENTITY_MAP T1,
	                  Lafite_ATTRIBUTE T2,
	                  DP.RoleRight T3
	           WHERE  T1.MAP_ID = T2.Id
	                  AND T2.ATTRIBUTE_NAME = T3.RoleName
	                  AND T1.MAP_TYPE = 'Role'
	                  AND T2.ATTRIBUTE_TYPE = 'Role'
	                  AND T1.IDENTITY_ID = @UserId
	                  AND T3.RightId = 3
	       )
	    BEGIN
	        SET @Rtn = 3;
	    END
	END
	ELSE
	BEGIN
	    IF EXISTS (
	           --ƽ̨�鿴����������
	           SELECT 1
	           FROM   Lafite_IDENTITY_MAP T1,
	                  Lafite_ATTRIBUTE T2,
	                  DP.RoleRight T3
	           WHERE  T1.MAP_ID = T2.Id
	                  AND T2.ATTRIBUTE_NAME = T3.RoleName
	                  AND T1.MAP_TYPE = 'Role'
	                  AND T2.ATTRIBUTE_TYPE = 'Role'
	                  AND T1.IDENTITY_ID = @UserId
	                  AND T3.RightId = 4
	       )
	    BEGIN
	        SET @Rtn = 4;
	    END
	    ELSE
	    IF EXISTS (
	           --�����̲鿴�Լ�
	           SELECT 1
	           FROM   Lafite_IDENTITY_MAP T1,
	                  Lafite_ATTRIBUTE T2,
	                  DP.RoleRight T3
	           WHERE  T1.MAP_ID = T2.Id
	                  AND T2.ATTRIBUTE_NAME = T3.RoleName
	                  AND T1.MAP_TYPE = 'Role'
	                  AND T2.ATTRIBUTE_TYPE = 'Role'
	                  AND T1.IDENTITY_ID = @UserId
	                  AND T3.RightId = 5
	       )
	    BEGIN
	        SET @Rtn = 5;
	    END
	END
	
	RETURN @Rtn
END
GO


