SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO


ALTER FUNCTION [dbo].[FN_Contract_IsPassTraining]
(
    @ContractId UNIQUEIDENTIFIER,
    @DealerId UNIQUEIDENTIFIER,
    @DealerType NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @isPassTraining BIT = 1;
    DECLARE @ExpireDays INT = -180;
    DECLARE @DepId INT;
    DECLARE @BrandName NVARCHAR(100);
    /*
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
	*/
    SELECT TOP 1
           @DepId = DepId
    FROM
    (
        SELECT DepId
        FROM Contract.AppointmentMain
        WHERE ContractId = @ContractId
        UNION
        SELECT DepId
        FROM Contract.RenewalMain
        WHERE ContractId = @ContractId
    ) AS T_Contract;

    SELECT TOP 1
           @BrandName = BrandName
    FROM dbo.V_ProductClassificationStructure
        INNER JOIN dbo.View_ProductLine
            ON V_ProductClassificationStructure.CC_ProductLineID = View_ProductLine.Id
    WHERE V_ProductClassificationStructure.CC_Division = @DepId;

    IF @BrandName = '波科'
    BEGIN
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
    END;

    RETURN @isPassTraining;
END;

GO