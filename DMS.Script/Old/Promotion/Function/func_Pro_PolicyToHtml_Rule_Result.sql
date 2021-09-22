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
		@JudgePolicyFactor = C.FactName+'[���'+CONVERT(NVARCHAR,A.JudgePolicyFactorId)+']',
		@JudgeValue = CONVERT(NVARCHAR,CONVERT(INT,A.JudgeValue)),
		@GiftValue = CONVERT(NVARCHAR,A.GiftValue),
		@ifConvert = ISNULL(F.ifConvert,'N'),
		@ifIncrement = CASE ISNULL(F.ifIncrement,'N') WHEN 'Y' THEN '�������ֵ�' ELSE '' END,
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
		@GiftPolicyFactor = e.FactName+'[���'+CONVERT(NVARCHAR,A.GiftPolicyFactorId)+']',
		--@PointsValue = CONVERT(NVARCHAR,CONVERT(INT,A.PointsValue)),
		@UseRangePolicyFactorId = A.UseRangePolicyFactorId
	FROM Promotion.PRO_POLICY_LARGESS A
	LEFT JOIN Promotion.PRO_POLICY_FACTOR D ON  A.GiftPolicyFactorId = D.PolicyFactorId
	LEFT JOIN Promotion.PRO_FACTOR E ON D.FactId = E.FactId
	WHERE A.PolicyId = @PolicyId
	
	IF @PolicyStyle = '��Ʒ'
	BEGIN
		SELECT @iIsSameFactor = COUNT(*) FROM Promotion.PRO_POLICY_FACTOR_RELATION 
			WHERE PolicyFactorId = @JudgePolicyFactorId AND ConditionPolicyFactorId = @GiftPolicyFactorId
		
		SET @iReturn = @ifIncrement + @JudgePolicyFactor+' �� '+@JudgeValue +'�� �� '
			+CASE WHEN isnull(@iIsSameFactor,0) > 0 THEN '' ELSE @GiftPolicyFactor+' ' END + CONVERT(NVARCHAR,CONVERT(DECIMAL(10,0),@GiftValue)) +'��'
			
	END
	
	IF @PolicyStyle = '����'
	BEGIN
		IF @PolicySubStyle = '�����͹̶�����'
		BEGIN
			SET @iReturn = @ifIncrement + @JudgePolicyFactor+' �� '+@JudgeValue +'�� �� '
			+ @PointsValue +'����' + '(���ֿ�����'+CASE @UseRangePolicyFactorId WHEN -100 THEN 'ȫ����Ʒ'
					WHEN -10 THEN @BU+'�Ĳ�Ʒ' WHEN -1 THEN @SubBu+'�Ĳ�Ʒ' 
					ELSE Promotion.func_Pro_PolicyToHtml_Factor_Product(@UseRangePolicyFactorId, null)+'�Ĳ�Ʒ' END +')'
		END
		
		IF @PolicySubStyle = '���ٷֱȻ���'
		BEGIN
			SET @iReturn = @ifIncrement + @JudgePolicyFactor+'��'+CONVERT(NVARCHAR,CONVERT(DECIMAL(10,4),CONVERT(DECIMAL(10,6),@GiftValue)*100))+'%'
			+ '��Ϊ����' + '(���ֿ�����'+CASE @UseRangePolicyFactorId WHEN -100 THEN 'ȫ����Ʒ'
					WHEN -10 THEN @BU+'�Ĳ�Ʒ' WHEN -1 THEN @SubBu+'�Ĳ�Ʒ' 
					ELSE Promotion.func_Pro_PolicyToHtml_Factor_Product(@UseRangePolicyFactorId, null)+'�Ĳ�Ʒ' END +')'
		END
		
		IF @PolicySubStyle = '������Ʒת����'
		BEGIN
			SET @iReturn = @ifIncrement + @JudgePolicyFactor+' �� '+@JudgeValue +'�� �� '
			+CASE WHEN isnull(@iIsSameFactor,0) > 0 THEN '' ELSE @GiftPolicyFactor+' ' END + CONVERT(NVARCHAR,CONVERT(DECIMAL(10,0),@GiftValue)) +'��'
			+CASE @PolicySubStyle WHEN '������Ʒת����' THEN ' ��ת�ɻ���'
				+ CASE @PointsType WHEN '�̶�����' THEN '(ÿ��Ʒ'+CONVERT(NVARCHAR,CONVERT(DECIMAL(10,0),@PointsValue))+'����)' 
					WHEN '�����̶̹�����' THEN '(���վ������Ͳ�ͬ���֣��μ�:��¼5)'
					ELSE '(������Ʒ���²ɹ���ת����)' END 
				+ '(���ֿ�����'+CASE @UseRangePolicyFactorId WHEN -100 THEN 'ȫ����Ʒ'
					WHEN -10 THEN @BU+'�Ĳ�Ʒ' WHEN -1 THEN @SubBu+'�Ĳ�Ʒ' 
					ELSE Promotion.func_Pro_PolicyToHtml_Factor_Product(@UseRangePolicyFactorId, null)+'�Ĳ�Ʒ' END +')' ELSE '' END
		END		
	END
	
	IF @PolicyStyle = '��ʱ����'
	BEGIN
		IF @PolicySubStyle = '��������Ʒ'
		BEGIN
			SELECT @iIsSameFactor = COUNT(*) FROM Promotion.PRO_POLICY_FACTOR_RELATION 
				WHERE PolicyFactorId = @JudgePolicyFactorId AND ConditionPolicyFactorId = @GiftPolicyFactorId
			
			SET @iReturn = @ifIncrement + @JudgePolicyFactor+' �� '+@JudgeValue +'�� �� '
				+CASE WHEN isnull(@iIsSameFactor,0) > 0 THEN '' ELSE @GiftPolicyFactor+' ' END + CONVERT(NVARCHAR,CONVERT(DECIMAL(10,0),@GiftValue)) +'��'
		END
		
		IF @PolicySubStyle = '�������'
		BEGIN
			SET @iReturn = @GiftPolicyFactor + ' �۸� * '+CONVERT(NVARCHAR,CONVERT(DECIMAL(10,4),CONVERT(DECIMAL(10,6),@GiftValue)*100))+'%'
		END	
	END
	
	RETURN @iReturn
END


GO


