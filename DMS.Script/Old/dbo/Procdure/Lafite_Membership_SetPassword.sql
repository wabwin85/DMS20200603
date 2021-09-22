DROP PROCEDURE [dbo].[Lafite_Membership_SetPassword]
GO





CREATE PROCEDURE [dbo].[Lafite_Membership_SetPassword]
    @ApplicationName  nvarchar(256),
    @LoginId         nvarchar(256),
    @NewPassword      nvarchar(128),
    @PasswordSalt     nvarchar(128),
    @CurrentTimeUtc   datetime,
    @PasswordFormat   int = 0
AS
BEGIN
    DECLARE @UserId varchar(36)
    SELECT  @UserId = NULL
    SELECT  @UserId = u.Id
    FROM    dbo.Lafite_IDENTITY u, dbo.Lafite_Application a, dbo.Lafite_Membership m
    WHERE   LOWERED_IDENTITY_CODE = LOWER(@LoginId) AND
            u.App_Id = a.Id  AND
            @ApplicationName = a.APPLICATION_CODE AND
            u.Id = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)


--    IF ( EXISTS ( SELECT 1 FROM dbo.Lafite_Membership
--                  WHERE  LastPassword=@NewPassword and @UserId = UserId ) )
--    BEGIN
--         RETURN(8)
--	END     

    UPDATE dbo.Lafite_Membership
    SET LastPassword=[Password], [Password] = @NewPassword, PasswordFormat = @PasswordFormat, PasswordSalt = @PasswordSalt,
        LastPasswordChangedDate = @CurrentTimeUtc
    WHERE @UserId = UserId
    RETURN(0)
END




GO


