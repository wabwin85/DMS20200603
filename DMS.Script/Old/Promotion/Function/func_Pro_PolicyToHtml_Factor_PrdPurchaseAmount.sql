
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
	
	--取得指定产品的因素ID
	SELECT @ProductPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION A,Promotion.PRO_POLICY_FACTOR B 
	WHERE A.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 1 AND A.PolicyFactorId = @PolicyFactorId

	SET @SQL = CASE WHEN @ProductPolicyFactorId IS NULL THEN '指定产品' 
		ELSE '产品['+CONVERT(NVARCHAR,@ProductPolicyFactorId)+']' END +'的商业采购金额'
	 
	RETURN @SQL
END


GO


