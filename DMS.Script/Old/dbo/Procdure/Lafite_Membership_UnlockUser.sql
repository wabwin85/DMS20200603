
DROP PROCEDURE [dbo].[Lafite_Membership_UnlockUser]
GO


CREATE PROCEDURE [dbo].[Lafite_Membership_UnlockUser]
    @ApplicationName                         nvarchar(256),
    @LoginId                                nvarchar(256)
AS
BEGIN
    DECLARE @UserId varchar(36)
    SELECT  @UserId = NULL
    SELECT  @UserId = u.Id
    FROM    dbo.Lafite_Identity u, dbo.Lafite_Application a, dbo.Lafite_Membership m
    WHERE   LOWERED_IDENTITY_CODE = LOWER(@LoginId) AND
            u.App_Id = a.Id  AND u.Delete_Flag = '0' AND
            LOWER(@ApplicationName) = a.APPLICATION_CODE AND
            u.Id = m.UserId

    IF ( @UserId IS NULL )
        RETURN 1

    UPDATE dbo.Lafite_Membership
    SET IsLockedOut = 0,
        FailedPasswordAttemptCount = 0,
        FailedPasswordAttemptWindowStart = CONVERT( datetime, '17540101', 112 ),
        FailedPasswordAnswerAttemptCount = 0,
        FailedPasswordAnswerAttemptWindowStart = CONVERT( datetime, '17540101', 112 ),
        LastLockoutDate = CONVERT( datetime, '17540101', 112 )
    WHERE @UserId = UserId

    RETURN 0
END

GO


