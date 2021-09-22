DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_SummaryProduct]
GO

/**********************************************
 ����:����PolicyId,UserId ��ȡ���ò�Ʒ)
 ���ߣ�Grapecity
 ������ʱ�䣺 2017-11-15
 ���¼�¼˵����
 1.���� 2017-11-15
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_SummaryProduct](
	@PolicyId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	
	SET @iReturn = ''
	SELECT @iReturn=[Promotion].[func_Pro_PolicyToHtml_Factor_Product](D.PolicyFactorId, null)
	FROM Promotion.PRO_POLICY_RULE A
	INNER JOIN Promotion.PRO_POLICY_FACTOR B ON A.PolicyId=B.PolicyId AND A.JudgePolicyFactorId=B.PolicyFactorId
	INNER JOIN Promotion.PRO_POLICY_FACTOR_RELATION C ON C.PolicyFactorId=B.PolicyFactorId
	INNER JOIN Promotion.PRO_POLICY_FACTOR D ON D.PolicyId=b.PolicyId AND D.PolicyFactorId=C.ConditionPolicyFactorId AND D.FactId=1
	WHERE A.PolicyId=@PolicyId

	IF ISNULL(@iReturn,'')=''
	BEGIN
		SELECT @iReturn=[Promotion].[func_Pro_PolicyToHtml_Factor_Product](A.PolicyFactorId, null) FROM Promotion.PRO_POLICY_FACTOR A WHERE A.PolicyId=@PolicyId AND A.FactId=1
	END
	
	RETURN @iReturn
END