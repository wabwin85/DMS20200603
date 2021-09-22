DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Rule_Condition]
GO



/**********************************************
 功能:传入RuleId，返回规则条件描述的HTML
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Rule_Condition](
	@RuleId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	
	DECLARE @JudgePolicyFactor NVARCHAR(50)
	DECLARE @LogicType NVARCHAR(50)
	DECLARE @LogicSymbol NVARCHAR(50)
	DECLARE @AbsoluteValue1 NVARCHAR(50)
	DECLARE @AbsoluteValue2 NVARCHAR(50)
	DECLARE @RelativeValue1 NVARCHAR(50)
	DECLARE @RelativeValue2 NVARCHAR(50)
	DECLARE @OtherPolicyFactorId INT
	DECLARE @OtherPolicyFactorIdRatio DECIMAL(10,4)
	DECLARE @OtherPolicyFactor NVARCHAR(50)
	
	SET @iReturn = ''
	
	DECLARE @iCURSOR_Rule CURSOR;
	SET @iCURSOR_Rule = CURSOR FOR SELECT C.FactName+'[编号'+CONVERT(NVARCHAR,A.PolicyFactorId)+']' JudgePolicyFactor,
			a.LogicType,a.LogicSymbol,
			CASE C.ValueType WHEN 'RATIO' THEN CONVERT(NVARCHAR,CONVERT(INT,a.AbsoluteValue1*100))+'%' WHEN 'QUANTITY' THEN CONVERT(NVARCHAR,CONVERT(INT,a.AbsoluteValue1)) WHEN 'MONEY' THEN CONVERT(NVARCHAR,CONVERT(DECIMAL(18,2),a.AbsoluteValue1)) ELSE CONVERT(NVARCHAR,a.AbsoluteValue1) END ,
			CASE C.ValueType WHEN 'RATIO' THEN CONVERT(NVARCHAR,CONVERT(INT,a.AbsoluteValue2*100))+'%' WHEN 'QUANTITY' THEN CONVERT(NVARCHAR,CONVERT(INT,a.AbsoluteValue2)) WHEN 'MONEY' THEN CONVERT(NVARCHAR,CONVERT(DECIMAL(18,2),a.AbsoluteValue2)) ELSE CONVERT(NVARCHAR,a.AbsoluteValue2) END ,
			a.RelativeValue1,a.RelativeValue2,
			a.OtherPolicyFactorId,a.OtherPolicyFactorIdRatio
		FROM Promotion.PRO_POLICY_RULE_FACTOR A,Promotion.PRO_POLICY_FACTOR B,PROMOTION.PRO_FACTOR C WHERE RuleId = @RuleId
		AND A.PolicyFactorId = B.PolicyFactorId AND B.FactId = C.FactId
	OPEN @iCURSOR_Rule 	
	FETCH NEXT FROM @iCURSOR_Rule INTO @JudgePolicyFactor,@LogicType,@LogicSymbol,@AbsoluteValue1,@AbsoluteValue2,
								@RelativeValue1,@RelativeValue2,@OtherPolicyFactorId,@OtherPolicyFactorIdRatio
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @iReturn <> ''
			SET @iReturn +='</P>'
		
		SET @iReturn +='*'
		
		IF @LogicType = 'AbsoluteValue'
			SET @iReturn += Promotion.func_Pro_Utility_getCompareString(@JudgePolicyFactor,@LogicSymbol,@AbsoluteValue1,@AbsoluteValue2)
		
		IF @LogicType = 'RelativeValue'
			SET @iReturn += Promotion.func_Pro_Utility_getCompareString(@JudgePolicyFactor,@LogicSymbol,@RelativeValue1,@RelativeValue2)
		
		IF @LogicType = 'OtherFactor'
		BEGIN
			SELECT @OtherPolicyFactor = C.FactName+'[编号'+CONVERT(NVARCHAR,B.PolicyFactorId)+']'
			FROM Promotion.PRO_POLICY_FACTOR B,PROMOTION.PRO_FACTOR C WHERE b.PolicyFactorId = @OtherPolicyFactorId
			AND B.FactId = C.FactId
			
			SET @iReturn += @JudgePolicyFactor +@LogicSymbol + @OtherPolicyFactor 
				+ CASE ISNULL(@OtherPolicyFactorIdRatio,1) WHEN 1 THEN '' ELSE '*'+CONVERT(NVARCHAR,@OtherPolicyFactorIdRatio) END
			
		END	
		
		FETCH NEXT FROM @iCURSOR_Rule INTO @JudgePolicyFactor,@LogicType,@LogicSymbol,@AbsoluteValue1,@AbsoluteValue2,
								@RelativeValue1,@RelativeValue2,@OtherPolicyFactorId,@OtherPolicyFactorIdRatio
	END	
	CLOSE @iCURSOR_Rule
	DEALLOCATE @iCURSOR_Rule
	
	IF @iReturn = ''
		SET @iReturn = '无'
	
	RETURN @iReturn
END



GO


