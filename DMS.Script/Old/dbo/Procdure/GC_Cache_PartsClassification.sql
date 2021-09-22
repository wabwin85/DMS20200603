DROP PROCEDURE [dbo].[GC_Cache_PartsClassification] 
GO


--生成产品自定义分组缓存，向上递归得到所有父节点
CREATE PROCEDURE [dbo].[GC_Cache_PartsClassification] 

AS
BEGIN

	SET NOCOUNT ON;

	--清除缓存表
	EXEC('TRUNCATE TABLE Cache_PartsClassificationRec');

--递归获得父节点
WITH PCT_Hierarchy (Leaf_ID, PCT_ID, PCT_ProductLine_BUM_ID, PCT_ParentClassification_PCT_ID) AS
        (SELECT PCT_ID as Leaf_ID,                
                PCT_ID,
                PCT_ProductLine_BUM_ID,
                PCT_ParentClassification_PCT_ID
           FROM PartsClassification
           --WHERE PCT_ID = '6d5ed913-7fd0-432b-8f4a-2e9c7190ca3f'
         UNION ALL
         SELECT PCT_Hierarchy.Leaf_ID,
                PartsClassification.PCT_ID,
                PartsClassification.PCT_ProductLine_BUM_ID,
                PartsClassification.PCT_ParentClassification_PCT_ID
           FROM    PartsClassification
                INNER JOIN
                   PCT_Hierarchy
                ON PartsClassification.PCT_ID =
                      PCT_Hierarchy.PCT_ParentClassification_PCT_ID)
INSERT INTO Cache_PartsClassificationRec(PCT_ID, PCT_ProductLine_BUM_ID, PCT_ParentClassification_PCT_ID)                       
SELECT Leaf_ID, PCT_ProductLine_BUM_ID, PCT_ID  FROM PCT_Hierarchy
  
END



GO


