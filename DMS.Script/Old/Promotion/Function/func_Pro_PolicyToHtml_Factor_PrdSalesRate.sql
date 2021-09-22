DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_PrdSalesRate]
GO



/**********************************************
 功能:传入PolicyFactorId,此PolicyFactorId的FactorId肯定是指定产品医院植入达标率(7)
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_PrdSalesRate](
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
	
	IF EXISTS (SELECT 1 FROM Promotion.Pro_Hospital_PrdSalesTaget WHERE PolicyFactorId = @PolicyFactorId)
		SET @HasAppendix = 'Y'
	ELSE 
		SET @HasAppendix = 'N'
	
	SET @SQL = CASE WHEN @ProductPolicyFactorId IS NULL THEN '指定产品' ELSE '产品[编号'+CONVERT(NVARCHAR,@ProductPolicyFactorId)+']' END +'的'
		+ CASE @HasAppendix WHEN 'Y' THEN '[参见:附录1]医院' ELSE 
				CASE WHEN @HospitalPolicyFactorId IS NULL THEN '指定医院' ELSE '医院[编号'+CONVERT(NVARCHAR,@HospitalPolicyFactorId)+']' END END 
		+ '的植入达标率'
			
	RETURN @SQL
END



GO


