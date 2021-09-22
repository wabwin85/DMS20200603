DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_PrdPurchaseRate]
GO



/**********************************************
 ����:����PolicyFactorId,��PolicyFactorId��FactorId�϶���ָ����Ʒ��ҵ�ɹ������(6)
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-08-28
 ���¼�¼˵����
 1.���� 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_PrdPurchaseRate](
	@PolicyFactorId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @ProductPolicyFactorId INT;
	DECLARE @HasAppendix NVARCHAR(1);
	
	--ȡ��ָ����Ʒ������ID
	SELECT @ProductPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION A,Promotion.PRO_POLICY_FACTOR B 
	WHERE A.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 1 AND A.PolicyFactorId = @PolicyFactorId

	IF EXISTS (SELECT 1 FROM Promotion.Pro_Dealer_PrdPurchase_Taget WHERE PolicyFactorId = @PolicyFactorId)
		SET @HasAppendix = 'Y'
	ELSE 
		SET @HasAppendix = 'N'
			
	SET @SQL = CASE WHEN @ProductPolicyFactorId IS NULL THEN 'ָ����Ʒ' ELSE '��Ʒ[���'+CONVERT(NVARCHAR,@ProductPolicyFactorId)+']' END +'��'
		+ CASE @HasAppendix WHEN 'Y' THEN '[�μ�:��¼3]������' ELSE 'ָ��������' END 
		+'����ҵ�ɹ������'
	 
	RETURN @SQL
END



GO


