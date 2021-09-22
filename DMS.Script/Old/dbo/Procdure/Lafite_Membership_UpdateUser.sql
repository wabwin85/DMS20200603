DROP PROCEDURE [dbo].[Lafite_Membership_UpdateUser]
GO

create PROCEDURE [dbo].[Lafite_Membership_UpdateUser]
    @ApplicationName      nvarchar(256),
    @UserName             nvarchar(256),
    @Email                nvarchar(256),
    @Comment              ntext,
    @IsApproved           bit,
    @LastLoginDate        datetime,
    @LastActivityDate     datetime,
    @UniqueEmail          int,
    @CurrentTimeUtc       datetime
AS
BEGIN
    DECLARE @UserId varchar(36)
    DECLARE @ApplicationId varchar(36)
    SELECT  @UserId = NULL
    SELECT  @UserId = u.Id, @ApplicationId = a.Id
    FROM    dbo.Lafite_Identity u, dbo.Lafite_Application a, dbo.Lafite_Membership m
    WHERE   LOWERED_IDENTITY_CODE = LOWER(@UserName) AND
            u.App_Id = a.Id  AND
            LOWER(@ApplicationName) = a.Application_Code AND
            u.Id = m.UserId

    IF (@UserId IS NULL)
        RETURN(1)

    IF (@UniqueEmail = 1)
    BEGIN
        IF (EXISTS (SELECT * FROM  dbo.Lafite_Membership m WITH (UPDLOCK, HOLDLOCK)
                    WHERE m.App_Id = @ApplicationId  AND @UserId <> m.UserId AND m.LoweredEmail = LOWER(@Email)))
        BEGIN
            RETURN(7)
        END
    END

    DECLARE @TranStarted   bit
    SET @TranStarted = 0

    IF( @@TRANCOUNT = 0 )
    BEGIN
	    BEGIN TRANSACTION
	    SET @TranStarted = 1
    END
    ELSE
	SET @TranStarted = 0

    UPDATE dbo.Lafite_Identity WITH (ROWLOCK)
    SET
         LastActivityDate = @LastActivityDate
    WHERE
       @UserId = Id

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    UPDATE dbo.Lafite_Membership WITH (ROWLOCK)
    SET
         Email            = @Email,
         LoweredEmail     = LOWER(@Email),
         Comment          = @Comment,
         IsApproved       = @IsApproved,
         LastLoginDate    = @LastLoginDate
    WHERE
       @UserId = UserId

    IF( @@ERROR <> 0 )
        GOTO Cleanup

    IF( @TranStarted = 1 )
    BEGIN
	SET @TranStarted = 0
	COMMIT TRANSACTION
    END

    RETURN 0

Cleanup:

    IF( @TranStarted = 1 )
    BEGIN
        SET @TranStarted = 0
    	ROLLBACK TRANSACTION
    END

    RETURN -1
END
GO


