
DROP PROCEDURE [dbo].[Lafite_Cache_ChildOrganizationUnits] 
GO


CREATE PROCEDURE [dbo].[Lafite_Cache_ChildOrganizationUnits] 
	@UnitID varchar(36)
AS
BEGIN

SET NOCOUNT ON;
--declare @UnitID varchar(36)
--select @unitid='7da8fe4a-403b-4d92-964e-fb9512052a9d';

WITH OrganizationUnits(AttributeId, AttributeName, AttributeType,AttributeLevel, ParentID,RootID) AS 
(
    SELECT
		LA.[Id] AS AttributeId,
		LA.[ATTRIBUTE_NAME] AS AttributeName,
		LA.[ATTRIBUTE_TYPE] AS AttributeType,
		LA.[ATTRIBUTE_LEVEL] AS AttributeLevel,
		LA.[Id] AS ParentId,
		@UnitID AS RootId
		FROM Lafite_ATTRIBUTE LA
		where LA.DELETE_FLAG=0 and LA.[ATTRIBUTE_TYPE]<>'Role' and LA.[ID]=@UnitID
    UNION ALL
   SELECT
		LA.[Id] AS AttributeId,
		LA.[ATTRIBUTE_NAME] AS AttributeName,
		LA.[ATTRIBUTE_TYPE] AS AttributeType,
		LA.[ATTRIBUTE_LEVEL] AS AttributeLevel,
		OU.AttributeId AS ParentId,
		@UnitID RootId
		FROM Lafite_ATTRIBUTE LA , OrganizationUnits OU
		where LA.[ATTRIBUTE_TYPE]<>'Role' and LA.DELETE_FLAG=0 and exists( select 1 from Lafite_ATTRIBUTE_RELATION R1 
		 where R1.ATTRIBUTE1_ID = OU.AttributeId and R1.ATTRIBUTE2_ID = LA.Id )
)

insert into [Cache_OrganizationUnits]
SELECT newid() GID,  OU.RootID, OU.ParentID, OU.AttributeId, OU.AttributeType, OU.AttributeName,OU.AttributeLevel
FROM OrganizationUnits OU 
ORDER BY OU.AttributeLevel
END



GO


