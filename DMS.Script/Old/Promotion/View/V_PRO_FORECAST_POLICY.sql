DROP VIEW [Promotion].[V_PRO_FORECAST_POLICY]
GO


CREATE VIEW [Promotion].[V_PRO_FORECAST_POLICY]
AS 
SELECT A.PolicyId,B.PolicyName,a.DealerId,A.BU,A.largessAmount Amount,A.CREATETIME DateStamp 
FROM Promotion.PRO_FORECAST_POLICY A,Promotion.PRO_POLICY B WHERE largessAmount <>0
AND A.POLICYID = B.POLICYID
GO


