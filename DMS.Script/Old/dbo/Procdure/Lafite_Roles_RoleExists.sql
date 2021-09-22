DROP PROCEDURE [dbo].[Lafite_Roles_RoleExists]
GO



CREATE PROCEDURE [dbo].[Lafite_Roles_RoleExists]
    @ApplicationName  nvarchar(256),
    @RoleName         nvarchar(256)
AS
BEGIN
    DECLARE @ApplicationId varchar(36)
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = Id FROM Lafite_Application 
		WHERE Application_Code = @ApplicationName
    IF (@ApplicationId IS NULL)
        RETURN(0)
    IF (EXISTS (SELECT ATTRIBUTE_NAME FROM dbo.Lafite_ATTRIBUTE 
			WHERE ATTRIBUTE_TYPE='Role' and @RoleName = ATTRIBUTE_NAME AND App_Id = @ApplicationId AND Delete_Flag='0'))
        RETURN(1)
    ELSE
        RETURN(0)
END

GO


