DROP VIEW  [interface].[V_I_QV_Policy_Factor]
GO

CREATE VIEW  [interface].[V_I_QV_Policy_Factor]
AS
SELECT A.PolicyId,B.PolicyNo,a.PolicyFactorId,a.FactId,c.FactName,a.FactDesc,CASE D.GiftType WHEN 'FreeGoods' THEN N'赠品' when 'AbsolutePoint' then N'赠品转积分' end GiftType,PointsValue  FROM Promotion.PRO_POLICY_FACTOR A
INNER JOIN Promotion.PRO_POLICY b ON A.PolicyId=B.PolicyId
INNER JOIN Promotion.PRO_FACTOR  c on c.FactId=a.FactId
LEFT JOIN Promotion.PRO_POLICY_LARGESS  D ON D.PolicyId=A.PolicyId AND D.GiftPolicyFactorId=A.PolicyFactorId

GO


