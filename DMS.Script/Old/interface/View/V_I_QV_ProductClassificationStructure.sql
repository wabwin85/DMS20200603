DROP VIEW [interface].[V_I_QV_ProductClassificationStructure]
GO








CREATE VIEW [interface].[V_I_QV_ProductClassificationStructure]
AS
--SELECT
--A.CC_ID,A.CC_Division,DP.DivisionName AS CC_DivisionName,DP.ProductLineID CC_ProductLineID,DP.ProductLineName CC_ProductLineName,A.CC_Code,A.CC_NameCN,A.CC_NameEN,A.CC_DistinguishRB,A.CC_RV1,A.CC_RV2,A.CC_RV3,A.CC_RV4,
--B.CA_ID,B.CA_Code,B.CA_NameCN,	B.CA_NameEN,B.CA_RV1,	B.CA_RV2,	B.CA_RV3,	B.CA_RV4,
--C.CQ_ID,C.CQ_Code,C.CQ_NameCN,C.CQ_NameEN,CQ_RV1,CQ_RV2,CQ_RV3,CQ_RV4,
--D.CP_ID,D.CP_Year Year,D.CP_Price,D.CP_Rebate,D.CP_RV1,D.CP_RV2,D.CP_RV3,D.CP_RV4
--FROM interface.ClassificationContractMain A
--INNER JOIN V_DivisionProductLineRelationMain DP ON DP.DivisionCode=A.CC_Division AND DP.IsEmerging='0'
--LEFT JOIN interface.ClassificationAuthorizationMain B ON A.CC_Code=B.CA_ParentCode
--LEFT JOIN interface.ClassificationQuotaMain C ON C.CQ_ParentCode=B.CA_Code
--LEFT JOIN interface.ClassificationQuotaPriceMain D ON D.CP_CQ_Code=C.CQ_Code

--SELECT
--A.CC_ID,A.CC_Division,DP.DivisionName AS CC_DivisionName,DP.ProductLineID CC_ProductLineID,DP.ProductLineName CC_ProductLineName,A.CC_Code,A.CC_NameCN,A.CC_NameEN,A.CC_DistinguishRB,A.CC_RV1,A.CC_RV2,A.CC_RV3,A.CC_RV4,
--B.CA_ID,B.CA_Code,B.CA_NameCN,	B.CA_NameEN,B.CA_RV1,	B.CA_RV2,	B.CA_RV3,	B.CA_RV4,
--C.CQ_ID,C.CQ_Code,C.CQ_NameCN,C.CQ_NameEN,CQ_RV1,CQ_RV2,CQ_RV3,CQ_RV4,
--D.CP_ID,D.CP_Year Year,D.CP_Price,D.CP_Rebate,D.CP_RV1,D.CP_RV2,D.CP_RV3,D.CP_RV4
--FROM interface.ClassificationContractMain A
--INNER JOIN V_DivisionProductLineRelation DP ON DP.DivisionCode=A.CC_Division AND DP.IsEmerging='0'
--LEFT JOIN interface.ClassificationAuthorizationMain B ON A.CC_Code=B.CA_ParentCode
--LEFT JOIN interface.ClassificationQuotaMain C ON C.CQ_ParentCode=B.CA_Code
--LEFT JOIN interface.ClassificationQuotaPriceMain D ON D.CP_CQ_Code=C.CQ_Code

select * from V_ProductClassificationStructure



GO


