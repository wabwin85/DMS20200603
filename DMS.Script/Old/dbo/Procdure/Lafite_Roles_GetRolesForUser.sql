DROP PROCEDURE [dbo].[Lafite_Roles_GetRolesForUser]
GO



CREATE PROCEDURE [dbo].[Lafite_Roles_GetRolesForUser]
    @ApplicationName  nvarchar(256),
    @LoginId         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId varchar(36)
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = Id FROM Lafite_Application WHERE @ApplicationName = Application_Code
    IF (@ApplicationId IS NULL)
        RETURN(1)
    DECLARE @UserId varchar(36)
    SELECT  @UserId = NULL

    SELECT  @UserId = Id
    FROM    dbo.Lafite_IDENTITY
    WHERE   Delete_Flag = '0' AND LOWERED_IDENTITY_CODE = LOWER(@LoginId) AND App_Id = @ApplicationId 

    IF (@UserId IS NULL)
        RETURN(1)

    SELECT r.ATTRIBUTE_NAME
    FROM   dbo.Lafite_ATTRIBUTE r, dbo.Lafite_IDENTITY_MAP ur
    WHERE  r.ATTRIBUTE_TYPE ='Role' and r.Id = ur.MAP_ID AND r.App_Id = @ApplicationId AND ur.IDENTITY_ID = @UserId and r.Delete_Flag='0'
    ORDER BY r.ATTRIBUTE_NAME
    RETURN (0)
END

GO


