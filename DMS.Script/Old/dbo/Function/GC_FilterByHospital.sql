DROP FUNCTION [dbo].[GC_FilterByHospital] 
GO






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GC_FilterByHospital] 
(
   @UserId UNIQUEIDENTIFIER,
   @DealerId UNIQUEIDENTIFIER,
   @HospitalId UNIQUEIDENTIFIER,
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

IF(@UserType IS NULL OR @HospitalId IS NULL OR @BUM_ID IS NULL )
BEGIN
	SET @result = 0
	GOTO Cleanup
END


IF(@UserType='Dealer' )
BEGIN
	IF( @current_DealerId IS NULL OR @DealerId IS NULL)
	BEGIN
		SET @result = 0
		GOTO Cleanup
	END
	
	IF(@current_DealerId = @DealerId) 
	BEGIN	
		SET @result = 1
		GOTO Cleanup
	END
END
ELSE
BEGIN	
  SET @result = 1
  GOTO Cleanup	
END

--IF(@UserType='Dealer' 
--AND EXISTS( SELECT * FROM  dbo.DealerAuthorizationTable A,
--  dbo.HospitalList B WHERE a.DAT_ID = B.HLA_DAT_ID AND b.HLA_HOS_ID= @HospitalId 
--  AND a.DAT_DMA_ID = @current_DealerId) )
--BEGIN
--	SET @result = 1
--	GOTO Cleanup
--END

--@UserType='User' 


--IF( EXISTS
--   ( 
--          SELECT 1 FROM Cache_OrganizationUnits OU, Lafite_IDENTITY_MAP IM , dbo.SalesRepHospital SD
--          WHERE OU.AttributeId = IM.MAP_ID AND IM.MAP_TYPE='Organization' AND convert(varchar(36),SD.SRH_USR_UserID) = IM.IDENTITY_ID
--                  AND SD.SRN_HOS_ID = @HospitalId AND SD.BUM_ID = @BUM_ID
--                  AND OU.AttributeId<>OU.RootId
--                  AND OU.RootID IN (select MAP_ID from Lafite_IDENTITY_MAP OM where OM.MAP_TYPE='Organization'  AND OM.IDENTITY_ID = @UserId)
--    )
--OR
--    EXISTS
--   ( 
--          SELECT 1 from dbo.SalesRepHospital SD 
--          WHERE SD.SRH_USR_UserID = @UserId
--                 AND SD.SRN_HOS_ID = @HospitalId AND SD.BUM_ID = @BUM_ID
--   )
--)
--BEGIN
--	SET @result = 1
--	GOTO Cleanup	
--END

	RETURN 0
	
Cleanup: 
	RETURN @result;
END






GO


