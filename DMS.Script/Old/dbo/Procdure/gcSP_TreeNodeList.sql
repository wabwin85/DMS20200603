DROP PROCEDURE [dbo].[gcSP_TreeNodeList] 
GO

CREATE PROCEDURE [dbo].[gcSP_TreeNodeList] 
AS
BEGIN

delete from tmpPartTreeLevel
delete from PartTreeLevel

INSERT PartTreeLevel(L1ID,L1Name,LastLevelID,ProductLine_BUM_ID)
SELECT PCT_ID, PCT_Name,PCT_ID,PCT_ProductLine_BUM_ID FROM PartsClassification where PCT_ParentClassification_PCT_ID is null

INSERT tmpPartTreeLevel(L1ID, L1Name,L2ID, L2Name,LastLevelID,ProductLine_BUM_ID)
select L1ID, L1Name, PCT_ID, PCT_Name,PCT_ID,ProductLine_BUM_ID from PartTreeLevel 
INNER JOIN PartsClassification ON PartTreeLevel.L1ID = PartsClassification.PCT_ParentClassification_PCT_ID

--DELETE FROM PartTreeLevel
INSERT PartTreeLevel SELECT * FROM tmpPartTreeLevel
DELETE FROM tmpPartTreeLevel
INSERT tmpPartTreeLevel(L1ID, L1Name,L2ID, L2Name, L3ID, L3Name,LastLevelID,ProductLine_BUM_ID)
select L1ID, L1Name, L2ID, L2Name, PCT_ID, PCT_Name,PCT_ID,ProductLine_BUM_ID from PartTreeLevel 
INNER JOIN PartsClassification ON PartTreeLevel.L2ID = PartsClassification.PCT_ParentClassification_PCT_ID

--DELETE FROM PartTreeLevel
INSERT PartTreeLevel SELECT * FROM tmpPartTreeLevel
DELETE FROM tmpPartTreeLevel
INSERT tmpPartTreeLevel(L1ID, L1Name,L2ID, L2Name, L3ID, L3Name, L4ID, L4Name,LastLevelID,ProductLine_BUM_ID)
select L1ID, L1Name, L2ID, L2Name, L3ID, L3Name, PCT_ID, PCT_Name,PCT_ID,ProductLine_BUM_ID from PartTreeLevel 
INNER JOIN PartsClassification ON PartTreeLevel.L3ID = PartsClassification.PCT_ParentClassification_PCT_ID

--DELETE FROM PartTreeLevel
INSERT PartTreeLevel SELECT * FROM tmpPartTreeLevel
DELETE FROM tmpPartTreeLevel
INSERT tmpPartTreeLevel(L1ID, L1Name,L2ID, L2Name, L3ID, L3Name, L4ID, L4Name, L5ID, L5Name,LastLevelID,ProductLine_BUM_ID)
select L1ID, L1Name, L2ID, L2Name, L3ID, L3Name, L4ID, L4Name, PCT_ID, PCT_Name,PCT_ID,ProductLine_BUM_ID from PartTreeLevel 
INNER JOIN PartsClassification ON PartTreeLevel.L4ID = PartsClassification.PCT_ParentClassification_PCT_ID

--DELETE FROM PartTreeLevel
INSERT PartTreeLevel SELECT * FROM tmpPartTreeLevel
DELETE FROM tmpPartTreeLevel
INSERT tmpPartTreeLevel(L1ID, L1Name,L2ID, L2Name, L3ID, L3Name, L4ID, L4Name, L5ID, L5Name, L6ID, L6Name,LastLevelID,ProductLine_BUM_ID)
select L1ID, L1Name, L2ID, L2Name, L3ID, L3Name, L4ID, L4Name, L5ID, L5Name, PCT_ID, PCT_Name,PCT_ID,ProductLine_BUM_ID from PartTreeLevel 
INNER JOIN PartsClassification ON PartTreeLevel.L5ID = PartsClassification.PCT_ParentClassification_PCT_ID

--DELETE FROM PartTreeLevel
INSERT PartTreeLevel SELECT * FROM tmpPartTreeLevel
DELETE FROM tmpPartTreeLevel
INSERT tmpPartTreeLevel(L1ID, L1Name,L2ID, L2Name, L3ID, L3Name, L4ID, L4Name, L5ID, L5Name, L6ID, L6Name, L7ID, L7Name,LastLevelID,ProductLine_BUM_ID)
select L1ID, L1Name, L2ID, L2Name, L3ID, L3Name, L4ID, L4Name, L5ID, L5Name, L6ID, L6Name, PCT_ID, PCT_Name,PCT_ID,ProductLine_BUM_ID from PartTreeLevel 
INNER JOIN PartsClassification ON PartTreeLevel.L6ID = PartsClassification.PCT_ParentClassification_PCT_ID

INSERT PartTreeLevel SELECT * FROM tmpPartTreeLevel
DELETE FROM tmpPartTreeLevel
INSERT tmpPartTreeLevel(L1ID, L1Name,L2ID, L2Name, L3ID, L3Name, L4ID, L4Name, L5ID, L5Name, L6ID, L6Name, L7ID, L7Name, L8ID, L8Name, LastLevelID,ProductLine_BUM_ID)
select L1ID, L1Name, L2ID, L2Name, L3ID, L3Name, L4ID, L4Name, L5ID, L5Name, L6ID, L6Name, L7ID, L7Name, PCT_ID, PCT_Name,PCT_ID,ProductLine_BUM_ID from PartTreeLevel 
INNER JOIN PartsClassification ON PartTreeLevel.L7ID = PartsClassification.PCT_ParentClassification_PCT_ID

select * from PartTreeLevel
END
GO


