DROP VIEW [interface].[V_I_EW_Product]
GO


CREATE VIEW [interface].[V_I_EW_Product]

AS

SELECT ROW_NUMBER() OVER (
		ORDER BY t1.CFN_CustomerFaceNbr
		) AS [ID]
	,t1.CFN_CustomerFaceNbr AS [UPN]
	,ltrim(rtrim(replace(replace(replace(t1.CFN_ChineseName, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''))) AS [ChineseDesc]
	,t1.CFN_Property5 AS [SFDA]
	,isnull(t2.PMA_ConvertFactor, 0) AS [Sheet]
	,t1.CFN_Description AS [Description]
	,(
		SELECT REV1
		FROM Lafite_ATTRIBUTE
		WHERE id IN (
				SELECT parentid
				FROM Cache_OrganizationUnits
				WHERE AttributeID IN (
						SELECT parentid
						FROM Cache_OrganizationUnits
						WHERE AttributeID = t1.CFN_ProductLine_BUM_ID
						)
				)
			AND ATTRIBUTE_TYPE = 'BU'
		) AS DivisionID
	,CASE 
		WHEN CFN_Property6 = '1'
			THEN 'CRM'
		ELSE 'BSC'
		END AS level0Code
	,CASE 
		WHEN CFN_Property6 = '1'
			THEN 'CRM'
		ELSE 'BSC'
		END AS level0
	,t1.CFN_Level1Code AS Level1code
	,t1.CFN_Level1Desc AS Level1
	,t1.CFN_Level2Code AS Level2code
	,t1.CFN_Level2Desc AS Level2
	,t1.CFN_Level3Code AS Level3code
	,t1.CFN_Level3Desc AS Level3
	,t1.CFN_Level4Code AS Level4code
	,t1.CFN_Level4Desc AS Level4
	,t1.CFN_Level5Code AS Level5code
	,t1.CFN_Level5Desc AS Level5
	,NULL AS Tag
	,NULL AS Plant
	,NULL AS sourceType
	,1 AS ST
	,t3.MMPP
	,t3.DChain
	,CFN_Property3 AS UOM
	,CFN_Property1 AS ShortUPN
	,t1.CFN_Property7 AS GTINCode
	,ltrim(rtrim(replace(replace(replace(replace(t1.CFN_Property8, CHAR(32), ''), CHAR(9), ''), CHAR(10), ''), CHAR(13), ''))) AS SalesStatus
FROM cfn t1
INNER JOIN product t2 ON (t1.CFN_ID = t2.PMA_CFN_ID)
INNER JOIN interface.T_I_QV_CFN t3 ON (t1.CFN_CustomerFaceNbr = t3.UPN)



GO


