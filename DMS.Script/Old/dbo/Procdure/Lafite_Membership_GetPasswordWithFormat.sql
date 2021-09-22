DROP PROCEDURE [dbo].[Lafite_Membership_GetPasswordWithFormat]
GO




CREATE PROCEDURE [dbo].[Lafite_Membership_GetPasswordWithFormat]
    @ApplicationName                nvarchar(256),
    @LoginId                       nvarchar(256),
    @UpdateLastLoginActivityDate    bit,
    @CurrentTimeUtc                 datetime
AS
BEGIN
    DECLARE @IsLockedOut                        bit
    DECLARE @UserId                             varchar(36)
    DECLARE @Password                           nvarchar(128)
    DECLARE @PasswordSalt                       nvarchar(128)
    DECLARE @PasswordFormat                     int
    DECLARE @FailedPasswordAttemptCount         int
    DECLARE @FailedPasswordAnswerAttemptCount   int
    DECLARE @IsApproved                         bit
    DECLARE @LastActivityDate                   datetime
    DECLARE @LastLoginDate                      datetime

    SELECT  @UserId          = NULL

    SELECT  @UserId = u.Id, @IsLockedOut = m.IsLockedOut, @Password=Password, @PasswordFormat=PasswordFormat,
            @PasswordSalt=PasswordSalt, @FailedPasswordAttemptCount=FailedPasswordAttemptCount,
		    @FailedPasswordAnswerAttemptCount=FailedPasswordAnswerAttemptCount, @IsApproved=IsApproved,
            @LastActivityDate = LastActivityDate, @LastLoginDate = LastLoginDate
    FROM    dbo.Lafite_Application a, dbo.Lafite_IDENTITY u, dbo.Lafite_Membership m
    WHERE   LOWER(@ApplicationName) = a.APPLICATION_CODE AND
            u.App_Id = a.Id    AND u.Id = m.UserId AND u.Delete_Flag = '0' AND
            LOWER(@LoginId) = u.LOWERED_IDENTITY_CODE

    IF (@UserId IS NULL)
        RETURN 1

    IF (@IsLockedOut = 1)
        RETURN 99

    SELECT   @Password , @PasswordFormat 'PasswordFormat', @PasswordSalt, @FailedPasswordAttemptCount 'FailedAttemptCount',
             @FailedPasswordAnswerAttemptCount, @IsApproved 'IsApproved', @LastLoginDate, @LastActivityDate

    IF (@UpdateLastLoginActivityDate = 1 AND @IsApproved = 1)
    BEGIN
        UPDATE  dbo.Lafite_Membership
        SET     LastLoginDate = @CurrentTimeUtc
        WHERE   UserId = @UserId

        UPDATE  dbo.Lafite_IDENTITY
        SET     LastActivityDate = @CurrentTimeUtc
        WHERE   @UserId = Id
    END


    RETURN 0
END



GO


