DROP VIEW [dbo].[V_ProductClassificationStructure] 
GO

CREATE VIEW [dbo].[V_ProductClassificationStructure] 
AS
SELECT a.CC_Year AS Year,
A.CC_ID,A.CC_Division,DP.DivisionName AS CC_DivisionName,DP.ProductLineID 
CC_ProductLineID,DP.ProductLineName CC_ProductLineName,A.CC_Code,A.CC_NameCN,A.CC_NameEN,A.CC_DistinguishRB,A.CC_RV1,A.CC_RV2,A.CC_RV3,A.CC_RV4,
--A.CC_StartDate ,A.CC_EndDate,
B.CA_ID,B.CA_Code,B.CA_NameCN,	B.CA_NameEN,B.CA_RV1,	B.CA_RV2,	B.CA_RV3,	B.CA_RV4,
--B.CA_StartDate,B.CA_EndDate,
C.CQ_ID,C.CQ_Code,C.CQ_NameCN,C.CQ_NameEN,CQ_RV1,CQ_RV2,CQ_RV3,CQ_RV4,
--C.CQ_StartDate,C.CQ_EndDate,
CASE  WHEN GETDATE() between ISNULL(A.CC_StartDate,'1990-01-01') and ISNULL(A.CC_EndDate,'2099-12-31')
		THEN  
			CASE  WHEN GETDATE() between ISNULL(B.CA_StartDate,'1990-01-01') and ISNULL(B.CA_EndDate,'2099-12-31')
			THEN
				CASE  WHEN	GETDATE() between ISNULL(C.CQ_StartDate,'1990-01-01') and ISNULL(C.CQ_EndDate,'2099-12-31')
				THEN 1
				ELSE 0 END
			ELSE
				0 END
		ELSE 0 END ActiveFlag,
CASE WHEN ISNULL(A.CC_StartDate,'1990-01-01')<ISNULL(B.CA_StartDate,'1990-01-01') 
		THEN CASE WHEN ISNULL(B.CA_StartDate,'1990-01-01') <ISNULL(C.CQ_StartDate,'1990-01-01')
					THEN ISNULL(C.CQ_StartDate,'1990-01-01')
					ELSE ISNULL(B.CA_StartDate,'1990-01-01') END
					
		ELSE CASE WHEN ISNULL(A.CC_StartDate,'1990-01-01') <ISNULL(C.CQ_StartDate,'1990-01-01')
					THEN ISNULL(C.CQ_StartDate,'1990-01-01')
					ELSE ISNULL(A.CC_StartDate,'1990-01-01')  END
	END AS StartDate,
CASE WHEN ISNULL(A.CC_EndDate,'2099-12-31')>ISNULL(B.CA_EndDate,'2099-12-31') 
		THEN CASE WHEN ISNULL(B.CA_EndDate,'2099-12-31') >ISNULL(C.CQ_EndDate,'2099-12-31')
					THEN ISNULL(C.CQ_EndDate,'2099-12-31')
					ELSE ISNULL(B.CA_EndDate,'2099-12-31') END
					
		ELSE CASE WHEN ISNULL(A.CC_EndDate,'2099-12-31') >ISNULL(C.CQ_EndDate,'2099-12-31')
					THEN ISNULL(C.CQ_EndDate,'2099-12-31')
					ELSE ISNULL(A.CC_EndDate,'2099-12-31')  END
	END AS EndDate

FROM interface.ClassificationContract A(nolock)
INNER JOIN V_DivisionProductLineRelation DP(nolock) ON DP.DivisionCode=A.CC_Division AND DP.IsEmerging='0'
LEFT JOIN interface.ClassificationAuthorization B(nolock) ON A.CC_Code=B.CA_ParentCode 
LEFT JOIN interface.ClassificationQuota C(nolock) ON C.CQ_ParentCode=B.CA_Code
GO


