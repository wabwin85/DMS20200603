DROP PROCEDURE [dbo].[Lafite_Roles_GetAllRoles]
GO



CREATE PROCEDURE [dbo].[Lafite_Roles_GetAllRoles] (
    @ApplicationName           nvarchar(256))
AS
BEGIN
    DECLARE @ApplicationId varchar(32)
    SELECT  @ApplicationId = NULL
    SELECT  @ApplicationId = Id FROM Lafite_Application WHERE @ApplicationName = Application_Code
    IF (@ApplicationId IS NULL)
        RETURN
    SELECT ATTRIBUTE_NAME
    FROM   dbo.Lafite_ATTRIBUTE WHERE App_Id = @ApplicationId and ATTRIBUTE_TYPE ='Role' and Delete_Flag='0'
    ORDER BY ATTRIBUTE_NAME
END

GO


