DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_PrdSalesRate]
GO



/**********************************************
 ����:����PolicyFactorId,��PolicyFactorId��FactorId�϶���ָ����ƷҽԺֲ������(7)
 ���ߣ�Grapecity
 ������ʱ�䣺 2015-08-28
 ���¼�¼˵����
 1.���� 2015-08-28
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
	
	--ȡ��ָ����Ʒ������ID
	SELECT @ProductPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION A,Promotion.PRO_POLICY_FACTOR B 
	WHERE A.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 1 AND A.PolicyFactorId = @PolicyFactorId
	
	--ȡ��ָ��ҽԺ������ID
	SELECT @HospitalPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION A,Promotion.PRO_POLICY_FACTOR B 
	WHERE A.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 2 AND A.PolicyFactorId = @PolicyFactorId
	
	IF EXISTS (SELECT 1 FROM Promotion.Pro_Hospital_PrdSalesTaget WHERE PolicyFactorId = @PolicyFactorId)
		SET @HasAppendix = 'Y'
	ELSE 
		SET @HasAppendix = 'N'
	
	SET @SQL = CASE WHEN @ProductPolicyFactorId IS NULL THEN 'ָ����Ʒ' ELSE '��Ʒ[���'+CONVERT(NVARCHAR,@ProductPolicyFactorId)+']' END +'��'
		+ CASE @HasAppendix WHEN 'Y' THEN '[�μ�:��¼1]ҽԺ' ELSE 
				CASE WHEN @HospitalPolicyFactorId IS NULL THEN 'ָ��ҽԺ' ELSE 'ҽԺ[���'+CONVERT(NVARCHAR,@HospitalPolicyFactorId)+']' END END 
		+ '��ֲ������'
			
	RETURN @SQL
END



GO


