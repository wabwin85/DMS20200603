
DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_PrdPurchaseAmount]
GO

CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_PrdPurchaseAmount](
	@PolicyFactorId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @ProductPolicyFactorId INT;
	
	--ȡ��ָ����Ʒ������ID
	SELECT @ProductPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION A,Promotion.PRO_POLICY_FACTOR B 
	WHERE A.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 1 AND A.PolicyFactorId = @PolicyFactorId

	SET @SQL = CASE WHEN @ProductPolicyFactorId IS NULL THEN 'ָ����Ʒ' 
		ELSE '��Ʒ['+CONVERT(NVARCHAR,@ProductPolicyFactorId)+']' END +'����ҵ�ɹ����'
	 
	RETURN @SQL
END


GO


