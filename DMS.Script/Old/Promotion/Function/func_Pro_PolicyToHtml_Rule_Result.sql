DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Rule_Result]
GO

CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Rule_Result](
	@RuleId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX);
	
	DECLARE @PolicyId INT;
	DECLARE @JudgePolicyFactorId INT;
	DECLARE @JudgePolicyFactor NVARCHAR(50);
	DECLARE @JudgeValue NVARCHAR(50);
	DECLARE @GiftPolicyFactorId INT;
	DECLARE @GiftPolicyFactor NVARCHAR(50);
	DECLARE @GiftValue NVARCHAR(50);
	DECLARE @GiftType NVARCHAR(50);
	DECLARE @PointsType NVARCHAR(50);
	DECLARE @PointsValue NVARCHAR(50);
	DECLARE @ifConvert NVARCHAR(5);
	DECLARE @ifIncrement NVARCHAR(5);
	DECLARE @UseRangePolicyFactorId INT;
	DECLARE @BU NVARCHAR(50);
	DECLARE @SubBu NVARCHAR(50);
	DECLARE @PolicyStyle NVARCHAR(100);
	DECLARE @PolicySubStyle NVARCHAR(100);	
	DECLARE @iIsSameFactor INT;
	
	SET @iReturn = ''
	
	SELECT  
		@PolicyId = F.PolicyId,
		@JudgePolicyFactorId = A.JudgePolicyFactorId,
		@JudgePolicyFactor = C.FactName+'[编号'+CONVERT(NVARCHAR,A.JudgePolicyFactorId)+']',
		@JudgeValue = CONVERT(NVARCHAR,CONVERT(INT,A.JudgeValue)),
		@GiftValue = CONVERT(NVARCHAR,A.GiftValue),
		@ifConvert = ISNULL(F.ifConvert,'N'),
		@ifIncrement = CASE ISNULL(F.ifIncrement,'N') WHEN 'Y' THEN '超出部分的' ELSE '' END,
		@BU = F.BU,
		@SubBu = F.BU + CASE ISNULl(F.SUBBU,'') WHEN '' THEN '' ELSE '-'+ISNULl(F.SUBBU,'') END,
		@PointsValue = CONVERT(NVARCHAR,CONVERT(INT,A.PointsValue)),
		@PointsType = A.PointsType,
		@PolicyStyle = F.PolicyStyle,
		@PolicySubStyle = F.PolicySubStyle
	FROM Promotion.PRO_POLICY_RULE A 
	LEFT JOIN Promotion.PRO_POLICY_FACTOR B ON A.JudgePolicyFactorId = B.PolicyFactorId
	LEFT JOIN Promotion.PRO_FACTOR C ON B.FactId = C.FactId
	INNER JOIN Promotion.PRO_POLICY F ON A.PolicyId = F.PolicyId
	WHERE A.RuleId = @RuleId
	
	SELECT 
		@GiftType = A.GiftType,
		@GiftPolicyFactorId = A.GiftPolicyFactorId,
		@GiftPolicyFactor = e.FactName+'[编号'+CONVERT(NVARCHAR,A.GiftPolicyFactorId)+']',
		--@PointsValue = CONVERT(NVARCHAR,CONVERT(INT,A.PointsValue)),
		@UseRangePolicyFactorId = A.UseRangePolicyFactorId
	FROM Promotion.PRO_POLICY_LARGESS A
	LEFT JOIN Promotion.PRO_POLICY_FACTOR D ON  A.GiftPolicyFactorId = D.PolicyFactorId
	LEFT JOIN Promotion.PRO_FACTOR E ON D.FactId = E.FactId
	WHERE A.PolicyId = @PolicyId
	
	IF @PolicyStyle = '赠品'
	BEGIN
		SELECT @iIsSameFactor = COUNT(*) FROM Promotion.PRO_POLICY_FACTOR_RELATION 
			WHERE PolicyFactorId = @JudgePolicyFactorId AND ConditionPolicyFactorId = @GiftPolicyFactorId
		
		SET @iReturn = @ifIncrement + @JudgePolicyFactor+' 满 '+@JudgeValue +'件 送 '
			+CASE WHEN isnull(@iIsSameFactor,0) > 0 THEN '' ELSE @GiftPolicyFactor+' ' END + CONVERT(NVARCHAR,CONVERT(DECIMAL(10,0),@GiftValue)) +'件'
			
	END
	
	IF @PolicyStyle = '积分'
	BEGIN
		IF @PolicySubStyle = '满额送固定积分'
		BEGIN
			SET @iReturn = @ifIncrement + @JudgePolicyFactor+' 满 '+@JudgeValue +'件 送 '
			+ @PointsValue +'积分' + '(积分可用于'+CASE @UseRangePolicyFactorId WHEN -100 THEN '全部产品'
					WHEN -10 THEN @BU+'的产品' WHEN -1 THEN @SubBu+'的产品' 
					ELSE Promotion.func_Pro_PolicyToHtml_Factor_Product(@UseRangePolicyFactorId, null)+'的产品' END +')'
		END
		
		IF @PolicySubStyle = '金额百分比积分'
		BEGIN
			SET @iReturn = @ifIncrement + @JudgePolicyFactor+'的'+CONVERT(NVARCHAR,CONVERT(DECIMAL(10,4),CONVERT(DECIMAL(10,6),@GiftValue)*100))+'%'
			+ '作为积分' + '(积分可用于'+CASE @UseRangePolicyFactorId WHEN -100 THEN '全部产品'
					WHEN -10 THEN @BU+'的产品' WHEN -1 THEN @SubBu+'的产品' 
					ELSE Promotion.func_Pro_PolicyToHtml_Factor_Product(@UseRangePolicyFactorId, null)+'的产品' END +')'
		END
		
		IF @PolicySubStyle = '促销赠品转积分'
		BEGIN
			SET @iReturn = @ifIncrement + @JudgePolicyFactor+' 满 '+@JudgeValue +'件 送 '
			+CASE WHEN isnull(@iIsSameFactor,0) > 0 THEN '' ELSE @GiftPolicyFactor+' ' END + CONVERT(NVARCHAR,CONVERT(DECIMAL(10,0),@GiftValue)) +'件'
			+CASE @PolicySubStyle WHEN '促销赠品转积分' THEN ' 后转成积分'
				+ CASE @PointsType WHEN '固定积分' THEN '(每赠品'+CONVERT(NVARCHAR,CONVERT(DECIMAL(10,0),@PointsValue))+'积分)' 
					WHEN '经销商固定积分' THEN '(按照经销商送不同积分，参见:附录5)'
					ELSE '(按照赠品最新采购价转积分)' END 
				+ '(积分可用于'+CASE @UseRangePolicyFactorId WHEN -100 THEN '全部产品'
					WHEN -10 THEN @BU+'的产品' WHEN -1 THEN @SubBu+'的产品' 
					ELSE Promotion.func_Pro_PolicyToHtml_Factor_Product(@UseRangePolicyFactorId, null)+'的产品' END +')' ELSE '' END
		END		
	END
	
	IF @PolicyStyle = '即时买赠'
	BEGIN
		IF @PolicySubStyle = '满额送赠品'
		BEGIN
			SELECT @iIsSameFactor = COUNT(*) FROM Promotion.PRO_POLICY_FACTOR_RELATION 
				WHERE PolicyFactorId = @JudgePolicyFactorId AND ConditionPolicyFactorId = @GiftPolicyFactorId
			
			SET @iReturn = @ifIncrement + @JudgePolicyFactor+' 满 '+@JudgeValue +'件 送 '
				+CASE WHEN isnull(@iIsSameFactor,0) > 0 THEN '' ELSE @GiftPolicyFactor+' ' END + CONVERT(NVARCHAR,CONVERT(DECIMAL(10,0),@GiftValue)) +'件'
		END
		
		IF @PolicySubStyle = '满额打折'
		BEGIN
			SET @iReturn = @GiftPolicyFactor + ' 价格 * '+CONVERT(NVARCHAR,CONVERT(DECIMAL(10,4),CONVERT(DECIMAL(10,6),@GiftValue)*100))+'%'
		END	
	END
	
	RETURN @iReturn
END


GO


