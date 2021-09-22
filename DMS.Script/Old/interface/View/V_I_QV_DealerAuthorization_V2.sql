DROP VIEW [interface].[V_I_QV_DealerAuthorization_V2]

GO


CREATE VIEW [interface].[V_I_QV_DealerAuthorization_V2]
AS
--select top 10 * from interface.V_I_QV_DealerAuthorization

SELECT DISTINCT
DP.DivisionName AS Division
,DP.DivisionCode AS DivisionId
,B.DMA_ChineseName AS DealerName
,B.DMA_SAP_Code AS  SAPID
,B.DMA_DealerType AS DealerType
,C.DMA_SAP_Code AS ParentSAPID
--,CASE	WHEN C.DMA_SAP_Code ='369307' THEN '方承' 	
--		WHEN C.DMA_SAP_Code ='342859' THEN '国科恒泰'  	
--		WHEN C.DMA_SAP_Code ='442091' THEN '方承（新兴市场）'  
--		WHEN C.DMA_SAP_Code ='442090' THEN '国科恒泰（新兴市场）'  	
--		WHEN C.DMA_SAP_Code ='467438' THEN '国药控股河南'  	
--		WHEN C.DMA_SAP_Code ='480579' THEN '上海秉程'  
--		ELSE 'Boston' End  AS ParentName
,c.DMA_ChineseName as ParentDealerName
,E.HOS_HospitalName AS Hospital
,E.HOS_Key_Account AS DMSCode
--,E.HOS_Province AS Province
--,F.TER_ID AS ProvinceID
--,E.HOS_City AS City
--,G.TER_ID AS CityID
,case  when D.HLA_StartDate is null then a.DAT_StartDate else  D.HLA_StartDate END AS StartDate
,case  when D.HLA_EndDate is null then a.DAT_EndDate else D.HLA_EndDate  END AS StopDate
,A.DAT_Type AS AuthType
,CC_Code AS SubBUCode
,CC_NameCN AS SubBUName
,CA.CA_Code AS CaCode
,CA.CA_NameCN AS CaName


FROM DealerAuthorizationTable A 
INNER JOIN V_DivisionProductLineRelation DP ON DP.IsEmerging='0' AND A.DAT_ProductLine_BUM_ID=DP.ProductLineID
INNER JOIN DealerMaster B ON A.DAT_DMA_ID=B.DMA_ID
INNER JOIN DealerMaster C ON B.DMA_Parent_DMA_ID=C.DMA_ID
INNER JOIN HospitalList D ON A.DAT_ID=D.HLA_DAT_ID
INNER JOIN Hospital E ON E.HOS_ID=D.HLA_HOS_ID
inner join V_AllHospitalMarketProperty mt ON MT.Hos_Id=D.HLA_HOS_ID AND MT.ProductLineID=A.DAT_ProductLine_BUM_ID
INNER JOIN (SELECT DISTINCT CC_ID,cc_code,CC_NameCN,CA_Code,CA_NameCN,CA_ID,CC_ProductLineID,CC_RV4 FROM V_ProductClassificationStructure) CA 
			ON CA.CA_ID=A.DAT_PMA_ID AND CC_RV4=CONVERT(NVARCHAR,MT.MarketProperty) and CA.CC_RV4 IN('1','0') 

--LEFT JOIN Territory F ON F.TER_Description =E.HOS_Province
--LEFT JOIN Territory G ON G.TER_Description=E.HOS_City

WHERE (A.DAT_EndDate IS NOT NULL OR A.DAT_StartDate IS NOT NULL)
AND EXISTS(SELECT 1 FROM DealerContractMaster DM WHERE DM.DCM_DMA_ID=A.DAT_DMA_ID AND DCM_CC_ID=CA.CC_ID)
AND ((B.DMA_DealerType='LP' AND CA.CC_NameCN LIKE '%平台%' and ca.CA_NameCN like '%LP%') 
		OR(B.DMA_DealerType<>'LP'AND CA.CC_NameCN NOT LIKE '%平台%' and ca.CA_NameCN not like '%LP%' ) )
AND LEN(B.DMA_SAP_Code)<10
AND ISNULL(C.DMA_Taxpayer,'')<>'直销医院'


UNION
SELECT DISTINCT
DP.DivisionName AS Division
,DP.DivisionCode AS DivisionId
,B.DMA_ChineseName AS DealerName
,B.DMA_SAP_Code AS  SAPID
,B.DMA_DealerType AS DealerType
,C.DMA_SAP_Code AS ParentSAPID
--,CASE	WHEN C.DMA_SAP_Code ='369307' THEN '方承' 	
--		WHEN C.DMA_SAP_Code ='342859' THEN '国科恒泰'  	
--		WHEN C.DMA_SAP_Code ='442091' THEN '方承（新兴市场）'  
--		WHEN C.DMA_SAP_Code ='442090' THEN '国科恒泰（新兴市场）'  	
--		WHEN C.DMA_SAP_Code ='467438' THEN '国药控股河南'  	
--		WHEN C.DMA_SAP_Code ='480579' THEN '上海秉程'  
--		ELSE 'Boston' End  AS ParentName
,c.DMA_ChineseName as ParentDealerName
,E.HOS_HospitalName AS Hospital
,E.HOS_Key_Account AS DMSCode
--,E.HOS_Province AS Province
--,F.TER_ID AS ProvinceID
--,E.HOS_City AS City
--,G.TER_ID AS CityID
,case  when D.HLA_StartDate is null then a.DAT_StartDate else  D.HLA_StartDate END AS StartDate
,case  when D.HLA_EndDate is null then a.DAT_EndDate else D.HLA_EndDate  END AS StopDate
,A.DAT_Type AS AuthType
,CC_Code AS SubBUCode
,CC_NameCN AS SubBUName
,CA.CA_Code AS CaCode
,CA.CA_NameCN AS CaName


FROM DealerAuthorizationTable A 
INNER JOIN V_DivisionProductLineRelation DP ON DP.IsEmerging='0' AND A.DAT_ProductLine_BUM_ID=DP.ProductLineID
INNER JOIN DealerMaster B ON A.DAT_DMA_ID=B.DMA_ID
INNER JOIN DealerMaster C ON B.DMA_Parent_DMA_ID=C.DMA_ID
INNER JOIN HospitalList D ON A.DAT_ID=D.HLA_DAT_ID
INNER JOIN Hospital E ON E.HOS_ID=D.HLA_HOS_ID
INNER JOIN (SELECT DISTINCT CC_ID,cc_code,CC_NameCN,CA_Code,CA_NameCN,CA_ID,CC_ProductLineID,CC_RV4 FROM V_ProductClassificationStructure) CA 
			ON CA.CA_ID=A.DAT_PMA_ID  and CA.CC_RV4 ='2'

--LEFT JOIN Territory F ON F.TER_Description =E.HOS_Province
--LEFT JOIN Territory G ON G.TER_Description=E.HOS_City

WHERE (A.DAT_EndDate IS NOT NULL OR A.DAT_StartDate IS NOT NULL)
AND EXISTS(SELECT 1 FROM DealerContractMaster DM WHERE DM.DCM_DMA_ID=A.DAT_DMA_ID AND DCM_CC_ID=CA.CC_ID)
AND ((B.DMA_DealerType='LP' AND CA.CC_NameCN LIKE '%平台%' and ca.CA_NameCN like '%LP%') 
		OR(B.DMA_DealerType<>'LP'AND CA.CC_NameCN NOT LIKE '%平台%' and ca.CA_NameCN not like '%LP%' ) )
AND LEN(B.DMA_SAP_Code)<10
AND ISNULL(C.DMA_Taxpayer,'')<>'直销医院'

GO


