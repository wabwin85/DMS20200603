DROP FUNCTION [dbo].[GC_FilterByDealer] 
GO




-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GC_FilterByDealer] 
(
   @UserId UNIQUEIDENTIFIER,
   @DealerId UNIQUEIDENTIFIER,
   @BUM_ID UNIQUEIDENTIFIER
)
RETURNS bit
AS
BEGIN
DECLARE @result bit
DECLARE @UserType VARCHAR(20)
DECLARE @current_DealerId uniqueidentifier
SELECT @UserType = Identity_Type , @current_DealerId = Corp_ID
   FROM dbo.Lafite_IDENTITY WHERE Id = CONVERT(VARCHAR(36),@UserId)

SET @result = 0

IF(@UserType IS NULL OR @DealerId IS NULL OR @BUM_ID IS null )
BEGIN
	SET @result = 0
	GOTO Cleanup
	
END

IF(@UserType='Dealer' AND @current_DealerId = @DealerId)
BEGIN
	SET @result = 1
	GOTO Cleanup
END

--@UserType='User' 


IF( EXISTS
   ( 
          SELECT 1 FROM Cache_OrganizationUnits OU, Lafite_IDENTITY_MAP IM , Cache_SalesOfDealer SD
          WHERE OU.AttributeId = IM.MAP_ID AND IM.MAP_TYPE='Organization' AND convert(varchar(36),SD.SalesID) = IM.IDENTITY_ID
                  AND SD.DealerID = @DealerId AND SD.BUM_ID = @BUM_ID
                  AND OU.AttributeId<>OU.RootId
                  AND OU.RootID IN (select MAP_ID from Lafite_IDENTITY_MAP OM where OM.MAP_TYPE='Organization'  AND OM.IDENTITY_ID = @UserId)
    )
OR
    EXISTS
   ( 
          SELECT 1 from Cache_SalesOfDealer SD 
          WHERE SD.SalesID = @UserId
                 AND SD.DealerID = @DealerId AND SD.BUM_ID = @BUM_ID
   )
)
BEGIN
	SET @result = 1
	GOTO Cleanup	
END

	RETURN 0
	
Cleanup: 
	RETURN @result;
END




GO


