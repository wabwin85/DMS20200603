DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_PrdSalesAmount]
GO

CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_PrdSalesAmount](
	@PolicyFactorId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @ProductPolicyFactorId INT;
	DECLARE @HospitalPolicyFactorId INT;
	DECLARE @HasAppendix NVARCHAR(1);
	
	--取得指定产品的因素ID
	SELECT @ProductPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION A,Promotion.PRO_POLICY_FACTOR B 
	WHERE A.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 1 AND A.PolicyFactorId = @PolicyFactorId
	
	--取得指定医院的因素ID
	SELECT @HospitalPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION A,Promotion.PRO_POLICY_FACTOR B 
	WHERE A.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 2 AND A.PolicyFactorId = @PolicyFactorId
	
	--本因素有附录1表，或者本政策是ByHospital且有附录1表
	IF EXISTS (SELECT 1 FROM Promotion.Pro_Hospital_PrdSalesTaget WHERE PolicyFactorId = @PolicyFactorId)
		OR EXISTS (SELECT * FROM Promotion.PRO_POLICY A,Promotion.PRO_POLICY_FACTOR B
			WHERE A.PolicyId = B.PolicyId AND B.PolicyFactorId = @PolicyFactorId
			AND A.CalType = 'ByHospital' AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR C,Pro_Hospital_PrdSalesTaget D
				WHERE C.PolicyFactorId = D.PolicyFactorId AND C.PolicyId = A.PolicyId))
		SET @HasAppendix = 'Y'
	ELSE 
		SET @HasAppendix = 'N'
	
	SET @SQL = CASE WHEN @ProductPolicyFactorId IS NULL THEN '指定产品' ELSE '产品[编号'+CONVERT(NVARCHAR,@ProductPolicyFactorId)+']' END +'的'
		+ CASE @HasAppendix WHEN 'Y' THEN '[参见:附录1]医院' ELSE 
				CASE WHEN @HospitalPolicyFactorId IS NULL THEN '指定医院' ELSE '医院[编号'+CONVERT(NVARCHAR,@HospitalPolicyFactorId)+']' END END + '的'
		+ '植入金额'
			
	RETURN @SQL
END


GO


