SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO


CREATE FUNCTION [dbo].[FN_Contract_IsPassTraining]
(
    @DealerId UNIQUEIDENTIFIER,
    @DealerType NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @isPassTraining BIT = 1;
    DECLARE @ExpireDays INT = -180;

    IF @DealerType IN ( 'LP', 'T1' )
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM interface.T_I_MDM_DealerTraining a
            WHERE a.DealerId = @DealerId
                  AND CONVERT(NVARCHAR(10), TestDate, 120) >= DATEADD(DD, @ExpireDays, GETDATE())
                  AND a.TestStatus = '已通过'
                  AND TestType = 'Quality'
        )
        BEGIN

            SET @isPassTraining = 0;
        END;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM interface.T_I_MDM_DealerTraining a
        WHERE a.DealerId = @DealerId
              AND CONVERT(NVARCHAR(10), TestDate, 120) >= DATEADD(DD, @ExpireDays, GETDATE())
              AND a.TestStatus = '已通过'
              AND a.TestType = 'Compliance'
    )
    BEGIN
        SET @isPassTraining = 0;
    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM interface.T_I_MDM_DealerTraining a
        WHERE a.DealerId = @DealerId
              AND CONVERT(NVARCHAR(10), TestDate, 120) >= DATEADD(DD, @ExpireDays, GETDATE())
              AND a.TestStatus = '已通过'
              AND a.TestType = 'Survey'
    )
    BEGIN
        SET @isPassTraining = 0;
    END;

    RETURN @isPassTraining;
END;

GO