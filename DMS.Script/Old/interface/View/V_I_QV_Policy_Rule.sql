
DROP VIEW  [interface].[V_I_QV_Policy_Rule]
GO



CREATE VIEW  [interface].[V_I_QV_Policy_Rule]
AS
SELECT A.PolicyId,A.RuleId,a.RuleDesc,JudgePolicyFactorId,C.FactName,B.FactDesc,JudgeValue,GiftValue ,CASE D.GiftType WHEN 'FreeGoods' THEN N'ÂòÔù' ELSE N'Âò¼õ' END RuleType
FROM Promotion.PRO_POLICY_RULE A
INNER JOIN Promotion.PRO_POLICY_FACTOR B ON A.PolicyId=B.PolicyId AND A.JudgePolicyFactorId=B.PolicyFactorId
INNER JOIN Promotion.PRO_FACTOR C ON C.FactId=B.FactId
INNER JOIN Promotion.PRO_POLICY_LARGESS D ON D.PolicyId=B.PolicyId


GO


