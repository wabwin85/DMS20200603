DROP PROCEDURE [dbo].[Lafite_Membership_GetUserByUserId]
GO




CREATE PROCEDURE [dbo].[Lafite_Membership_GetUserByUserId]
    @UserId               varchar(36),
    @CurrentTimeUtc       datetime,
    @UpdateLastActivity   bit = 0
AS
BEGIN
    IF ( @UpdateLastActivity = 1 )
    BEGIN
        UPDATE   dbo.Lafite_IDENTITY
        SET      LastActivityDate = @CurrentTimeUtc
        FROM     dbo.Lafite_IDENTITY
        WHERE    @UserId = Id

        IF ( @@ROWCOUNT = 0 ) -- User ID not found
            RETURN -1
    END

    SELECT  m.Email, m.PasswordQuestion, m.Comment, m.IsApproved,
            m.CreateDate, m.LastLoginDate, u.LastActivityDate,
            m.LastPasswordChangedDate, u.Identity_Code UserName, m.IsLockedOut,
            m.LastLockoutDate
    FROM    dbo.Lafite_IDENTITY u, dbo.Lafite_Membership m
    WHERE   @UserId = u.Id AND u.Id = m.UserId AND u.Delete_Flag = '0' 

    IF ( @@ROWCOUNT = 0 ) -- User ID not found
       RETURN -1

    RETURN 0
END



GO


