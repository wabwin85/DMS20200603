DROP VIEW [interface].[zz_1]
GO

CREATE VIEW [interface].[zz_1]
AS
--sapid = 2693 monthbak 表
SELECT DISTINCT
DP.DivisionName AS Division
,DP.DivisionCode AS DivisionId
,B.DMA_ChineseName AS DealerName
,B.DMA_SAP_Code AS  SAPID
,B.DMA_DealerType AS DealerType
,C.DMA_SAP_Code AS ParentSAPID
,c.DMA_ChineseName as ParentDealerName
,E.HOS_HospitalName AS Hospital
,E.HOS_Key_Account AS DMSCode 
,D.HLA_StartDate AS StartDate
,D.HLA_EndDate AS StopDate
,null AS AuthType
,CC_Code AS SubBUCode
,CC_NameCN AS SubBUName
,CA.CA_Code AS CaCode
,CA.CA_NameCN AS CaName


FROM interface.DealerAuthorizationTable_MonthlyBackup A 
INNER JOIN V_DivisionProductLineRelation DP ON DP.IsEmerging='0' AND A.DAT_ProductLine_BUM_ID=DP.ProductLineID
INNER JOIN DealerMaster B ON A.DAT_DMA_ID=B.DMA_ID
INNER JOIN DealerMaster C ON B.DMA_Parent_DMA_ID=C.DMA_ID
INNER JOIN HospitalList D ON A.DAT_ID=D.HLA_DAT_ID
INNER JOIN Hospital E ON E.HOS_ID=D.HLA_HOS_ID
inner join V_AllHospitalMarketProperty mt ON MT.Hos_Id=D.HLA_HOS_ID AND MT.ProductLineID=A.DAT_ProductLine_BUM_ID
INNER JOIN (SELECT DISTINCT CC_ID,cc_code,CC_NameCN,CA_Code,CA_NameCN,CA_ID,CC_ProductLineID,CC_RV4 FROM V_ProductClassificationStructure) CA 
			ON CA.CA_ID=A.DAT_PMA_ID AND CC_RV4=CONVERT(NVARCHAR,MT.MarketProperty) and CA.CC_RV4 IN('1','0') 
WHERE a.DAT_BAK_DATE=20170301
AND EXISTS(SELECT 1 FROM DealerContractMaster DM WHERE DM.DCM_DMA_ID=A.DAT_DMA_ID AND DCM_CC_ID=CA.CC_ID)
AND ((B.DMA_DealerType='LP' AND CA.CC_NameCN LIKE '%平台%' and ca.CA_NameCN like '%LP%') 
		OR(B.DMA_DealerType<>'LP'AND CA.CC_NameCN NOT LIKE '%平台%' and ca.CA_NameCN not like '%LP%' ) )
AND LEN(B.DMA_SAP_Code)<10


UNION
SELECT DISTINCT
DP.DivisionName AS Division
,DP.DivisionCode AS DivisionId
,B.DMA_ChineseName AS DealerName
,B.DMA_SAP_Code AS  SAPID
,B.DMA_DealerType AS DealerType
,C.DMA_SAP_Code AS ParentSAPID
,c.DMA_ChineseName as ParentDealerName
,E.HOS_HospitalName AS Hospital
,E.HOS_Key_Account AS DMSCode
,D.HLA_StartDate AS StartDate
,D.HLA_EndDate AS StopDate
,null AS AuthType
,CC_Code AS SubBUCode
,CC_NameCN AS SubBUName
,CA.CA_Code AS CaCode
,CA.CA_NameCN AS CaName


FROM interface.DealerAuthorizationTable_MonthlyBackup A 
INNER JOIN V_DivisionProductLineRelation DP ON DP.IsEmerging='0' AND A.DAT_ProductLine_BUM_ID=DP.ProductLineID
INNER JOIN DealerMaster B ON A.DAT_DMA_ID=B.DMA_ID
INNER JOIN DealerMaster C ON B.DMA_Parent_DMA_ID=C.DMA_ID
INNER JOIN HospitalList D ON A.DAT_ID=D.HLA_DAT_ID
INNER JOIN Hospital E ON E.HOS_ID=D.HLA_HOS_ID
INNER JOIN (SELECT DISTINCT CC_ID,cc_code,CC_NameCN,CA_Code,CA_NameCN,CA_ID,CC_ProductLineID,CC_RV4 FROM V_ProductClassificationStructure) CA 
			ON CA.CA_ID=A.DAT_PMA_ID  and CA.CC_RV4 ='2'
WHERE  a.DAT_BAK_DATE=20170301
AND EXISTS(SELECT 1 FROM DealerContractMaster DM WHERE DM.DCM_DMA_ID=A.DAT_DMA_ID AND DCM_CC_ID=CA.CC_ID)
AND ((B.DMA_DealerType='LP' AND CA.CC_NameCN LIKE '%平台%' and ca.CA_NameCN like '%LP%') 
		OR(B.DMA_DealerType<>'LP'AND CA.CC_NameCN NOT LIKE '%平台%' and ca.CA_NameCN not like '%LP%' ) )
AND LEN(B.DMA_SAP_Code)<10


GO


