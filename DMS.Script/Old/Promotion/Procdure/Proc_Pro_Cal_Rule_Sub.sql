DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Rule_Sub]
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Rule_Sub] 
	@RuleId Int,	--规则ID
	@SQL_WHERE NVARCHAR(MAX)
AS
BEGIN  
	DECLARE @PolicyStyle NVARCHAR(50);
	DECLARE @PolicySubStyle NVARCHAR(50);
	
	SELECT 
		@PolicyStyle = C.PolicyStyle,
		@PolicySubStyle = C.PolicySubStyle
	FROM PROMOTION.PRO_POLICY_RULE A,Promotion.PRO_POLICY_FACTOR B,
	Promotion.PRO_POLICY C,Promotion.PRO_FACTOR D
	WHERE A.PolicyId = C.PolicyId AND A.JudgePolicyFactorId = B.PolicyFactorId AND B.FactId = D.FactId
	AND A.RuleId = @RuleId
	
	IF @PolicySubStyle IN ('促销赠品','促销赠品转积分')
	BEGIN
		EXEC PROMOTION.Proc_Pro_Cal_Rule_Sub_Largess @RuleId,@SQL_WHERE
	END
	
	IF @PolicySubStyle IN ('满额送固定积分','金额百分比积分')
	BEGIN
		EXEC PROMOTION.Proc_Pro_Cal_Rule_Sub_Point @RuleId,@SQL_WHERE
	END
		
END  

GO


