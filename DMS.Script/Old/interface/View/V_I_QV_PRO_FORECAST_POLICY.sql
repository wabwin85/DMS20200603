DROP VIEW [interface].[V_I_QV_PRO_FORECAST_POLICY]
GO



CREATE VIEW [interface].[V_I_QV_PRO_FORECAST_POLICY]
AS
SELECT A.PolicyId
	,B.PolicyName
	,dm.DMA_SAP_Code AS SAPID
	,A.BU
	,A.largessAmount Amount
	,A.CREATETIME DateStamp
FROM Promotion.PRO_FORECAST_POLICY A
	,Promotion.PRO_POLICY B
	,dbo.DealerMaster DM
WHERE largessAmount <> 0 AND A.POLICYID = B.POLICYID AND a.DEALERID = dm.DMA_ID




GO


