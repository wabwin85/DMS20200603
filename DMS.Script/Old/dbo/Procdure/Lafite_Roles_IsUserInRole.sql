DROP PROCEDURE [dbo].[Lafite_Roles_IsUserInRole]
GO



CREATE PROCEDURE [dbo].[Lafite_Roles_IsUserInRole]
    @ApplicationName  nvarchar(256),
    @LoginId         nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId varchar(36)
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = Id FROM Lafite_Application WHERE @ApplicationName = Application_Code
    IF (@ApplicationId IS NULL)
        RETURN(2)
    DECLARE @UserId uniqueidentifier
    SELECT  @UserId = NULL
    DECLARE @RoleId uniqueidentifier
    SELECT  @RoleId = NULL

    SELECT  @UserId = Id
    FROM    dbo.Lafite_Identity
    WHERE   LOWERED_IDENTITY_CODE = LOWER(@LoginId) AND App_Id = @ApplicationId and Delete_Flag ='0'

    IF (@UserId IS NULL)
        RETURN(2)

    SELECT  @RoleId = Id
    FROM   dbo.Lafite_ATTRIBUTE
    WHERE  ATTRIBUTE_TYPE ='Role' and ATTRIBUTE_NAME= @RoleName AND App_Id = @ApplicationId and Delete_Flag = '0'

    IF (@RoleId IS NULL)
        RETURN(3)

    IF (EXISTS( SELECT Id FROM dbo.Lafite_IDENTITY_MAP 
				WHERE MAP_TYPE='Role' and IDENTITY_ID = @UserId AND MAP_ID = @RoleId))
        RETURN(1)
    ELSE
        RETURN(0)
END

GO


