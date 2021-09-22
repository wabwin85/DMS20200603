DROP PROCEDURE [dbo].[Lafite_Membership_GetUserByName]
GO



CREATE PROCEDURE [dbo].[Lafite_Membership_GetUserByName]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    DECLARE @UserId uniqueidentifier

    IF (@UpdateLastActivity = 1)
    BEGIN
        SELECT TOP 1 m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, @CurrentTimeUtc, m.LastPasswordChangedDate,
                u.Id, m.IsLockedOut,m.LastLockoutDate
        FROM    dbo.Lafite_Application a, dbo.Lafite_IDENTITY u, dbo.Lafite_Membership m
        WHERE    LOWER(@ApplicationName) = a.Application_Code AND
                u.App_Id = a.Id    AND u.Delete_Flag = '0' AND
                LOWER(@UserName) = u.LOWERED_IDENTITY_CODE AND u.Id = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1

        UPDATE   dbo.Lafite_IDENTITY
        SET      LastActivityDate = @CurrentTimeUtc
        WHERE    @UserId = Id
    END
    ELSE
    BEGIN
        SELECT TOP 1 m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
                m.CreateDate, m.LastLoginDate, u.LastActivityDate, m.LastPasswordChangedDate,
                u.Id, m.IsLockedOut,m.LastLockoutDate
        FROM    dbo.Lafite_Application a, dbo.Lafite_IDENTITY u, dbo.Lafite_Membership m
        WHERE    LOWER(@ApplicationName) = a.Application_Code AND
                u.App_Id = a.Id    AND u.Delete_Flag = '0' AND
                LOWER(@UserName) = u.LOWERED_IDENTITY_CODE AND u.Id = m.UserId

        IF (@@ROWCOUNT = 0) -- Username not found
            RETURN -1
    END

    RETURN 0
END


GO


