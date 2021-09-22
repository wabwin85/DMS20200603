DROP PROCEDURE [dbo].[Lafite_GetChildUsers] 
GO

CREATE PROCEDURE [dbo].[Lafite_GetChildUsers] 
	@UserID varchar(36)
AS
BEGIN

SET NOCOUNT ON;

WITH OrganizationUnits(AttributeId, AttributeName, AttributeType,AttributeLevel,UserID) AS 
(
    SELECT
		LA.[Id] AS AttributeId,
		LA.[ATTRIBUTE_NAME] AS AttributeName,
		LA.[ATTRIBUTE_TYPE] AS AttributeType,
		LA.[ATTRIBUTE_LEVEL] AS AttributeLevel,
		@UserID UserID
		FROM Lafite_ATTRIBUTE LA
		where LA.DELETE_FLAG=0 
		AND exists(SELECT 1 from Lafite_IDENTITY_MAP IM where LA.ID = IM.MAP_ID and IM.MAP_TYPE='Organization'  
		AND IM.IDENTITY_ID=@UserID)
    UNION ALL
   SELECT
		LA.[Id] AS AttributeId,
		LA.[ATTRIBUTE_NAME] AS AttributeName,
		LA.[ATTRIBUTE_TYPE] AS AttributeType,
		LA.[ATTRIBUTE_LEVEL] AS AttributeLevel,
		@UserID UserID
		FROM Lafite_ATTRIBUTE LA , OrganizationUnits OU
		where LA.DELETE_FLAG=0 and exists( select 1 from Lafite_ATTRIBUTE_RELATION R1 
		 where R1.ATTRIBUTE1_ID =OU.AttributeId
		 and R1.ATTRIBUTE2_ID = LA.Id )
)

SELECT IM.IDENTITY_ID ChildUserId, OU.AttributeType, OU.AttributeName, OU.UserID
FROM OrganizationUnits OU, Lafite_IDENTITY_MAP IM 
where OU.AttributeId = IM.MAP_ID and IM.MAP_TYPE='Organization' 


END

GO


