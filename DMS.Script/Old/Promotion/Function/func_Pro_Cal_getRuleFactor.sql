DROP FUNCTION [Promotion].[func_Pro_Cal_getRuleFactor]
GO

CREATE FUNCTION [Promotion].[func_Pro_Cal_getRuleFactor](
	@RuleFactorId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX)
	
	DECLARE @runPeriod NVARCHAR(20); --当前计算的期间
	DECLARE @ColName NVARCHAR(20); --当前计算字段
	DECLARE @OtherColName NVARCHAR(20); --对比字段名
	
	DECLARE @LogicType NVARCHAR(20);
	DECLARE @LogicSymbol NVARCHAR(20);
	DECLARE @AbsoluteValue1 NVARCHAR(50);
	DECLARE @AbsoluteValue2 NVARCHAR(50);
	DECLARE @RelativeValue1 NVARCHAR(50);
	DECLARE @RelativeValue2 NVARCHAR(50);
	DECLARE @OtherPolicyFactorId INT;
	DECLARE @OtherPolicyFactorIdRatio DECIMAL(10,4);
	DECLARE @FactId INT;
	DECLARE @PolicyFactorId INT;
	DECLARE @PolicyId INT;
	DECLARE @Period NVARCHAR(5);
	DECLARE @CurrentPeriod NVARCHAR(10);
	DECLARE @StartDate NVARCHAR(10);
	DECLARE @CalModule NVARCHAR(20);
	DECLARE @RelativeColumnName1 NVARCHAR(50);
	DECLARE @RelativeColumnName2 NVARCHAR(50);
	
	SET @iReturn = ''
	
	SELECT 
		@LogicType = A.LogicType,
		@LogicSymbol = A.LogicSymbol,
		@AbsoluteValue1 = CONVERT(NVARCHAR,A.AbsoluteValue1),
		@AbsoluteValue2 = CONVERT(NVARCHAR,A.AbsoluteValue2),
		@RelativeValue1 = A.RelativeValue1,
		@RelativeValue2 = A.RelativeValue2,
		@OtherPolicyFactorId = A.OtherPolicyFactorId,
		@OtherPolicyFactorIdRatio = A.OtherPolicyFactorIdRatio,
		@FactId = B.FactId,
		@PolicyFactorId = B.PolicyFactorId,
		@PolicyId = C.PolicyId,
		@Period = C.Period,
		@CurrentPeriod = C.CurrentPeriod,
		@StartDate = C.StartDate,
		@CalModule = C.CalModule
	FROM PROMOTION.PRO_POLICY_RULE_FACTOR A,PROMOTION.PRO_POLICY_FACTOR B,PROMOTION.PRO_POLICY C
	WHERE A.RuleFactorId = @RuleFactorId AND A.PolicyFactorId = B.PolicyFactorId AND B.PolicyId = C.PolicyId
	
	IF ISNULL(@CurrentPeriod,'') = ''
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	ELSE
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
		
	SELECT @ColName = ColumnName FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@runPeriod) WHERE isCondition = 'Y'
	
	--(1)判断绝对值
	IF @LogicType = 'AbsoluteValue'
	BEGIN
		IF @LogicSymbol = '=' 	SET @iReturn = @ColName + '=' + @AbsoluteValue1
		IF @LogicSymbol = '>' 	SET @iReturn = @ColName + '>' + @AbsoluteValue1
		IF @LogicSymbol = '>=' 	SET @iReturn = @ColName + '>=' + @AbsoluteValue1
		IF @LogicSymbol = '<' 	SET @iReturn = @ColName + '<' + @AbsoluteValue1
		IF @LogicSymbol = '<=' 	SET @iReturn = @ColName + '<=' + @AbsoluteValue1
		IF @LogicSymbol = '>= AND <' 	SET @iReturn = @ColName + '>=' + @AbsoluteValue1 +' AND ' + @ColName + '<' + @AbsoluteValue2
		IF @LogicSymbol = '>= AND <=' 	SET @iReturn = @ColName + '>=' + @AbsoluteValue1 +' AND ' + @ColName + '<=' + @AbsoluteValue2
		IF @LogicSymbol = '> AND <' 	SET @iReturn = @ColName + '>' + @AbsoluteValue1 +' AND ' + @ColName + '<' + @AbsoluteValue2
		IF @LogicSymbol = '> AND <=' 	SET @iReturn = @ColName + '>' + @AbsoluteValue1 +' AND ' + @ColName + '<=' + @AbsoluteValue2
		
	END
	
	--(2)判断相对值
	IF @LogicType = 'RelativeValue'
	BEGIN
		IF @FactId in (6,7,14,15) --指定产品采购/植入类的达标
		BEGIN
			SELECT @RelativeColumnName1 = ColumnName FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@runPeriod) 
				WHERE SourceColumn = @RelativeValue1
			SELECT @RelativeColumnName2 = ColumnName FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@runPeriod) 
				WHERE SourceColumn = @RelativeValue2
				
			IF @LogicSymbol = '=' 	SET @iReturn = @ColName + '=' + @RelativeColumnName1
			IF @LogicSymbol = '>' 	SET @iReturn = @ColName + '>' + @RelativeColumnName1
			IF @LogicSymbol = '>=' 	SET @iReturn = @ColName + '>=' + @RelativeColumnName1
			IF @LogicSymbol = '<' 	SET @iReturn = @ColName + '<' + @RelativeColumnName1
			IF @LogicSymbol = '<=' 	SET @iReturn = @ColName + '<=' + @RelativeColumnName1
			IF @LogicSymbol = '>= AND <' 	SET @iReturn = @ColName + '>=' + @RelativeColumnName1 +' AND ' + @ColName + '<' + @RelativeColumnName2
			IF @LogicSymbol = '>= AND <=' 	SET @iReturn = @ColName + '>=' + @RelativeColumnName1 +' AND ' + @ColName + '<=' + @RelativeColumnName2
			IF @LogicSymbol = '> AND <' 	SET @iReturn = @ColName + '>' + @RelativeColumnName1 +' AND ' + @ColName + '<' + @RelativeColumnName2
			IF @LogicSymbol = '> AND <=' 	SET @iReturn = @ColName + '>' + @RelativeColumnName1 +' AND ' + @ColName + '<=' + @RelativeColumnName2
			
			--20151105 哪怕没有导入过指标，也计算
			--SET @iReturn += ' AND ' + ISNULL(@RelativeColumnName1,'0') + '+' + ISNULL(@RelativeColumnName2,'0') + ' >0 '
		END
	END
	
	--(3)判断其他因素
	IF @LogicType = 'OtherFactor'
	BEGIN
		SELECT @OtherColName = ColumnName FROM PROMOTION.func_Pro_Utility_getColumnName(@OtherPolicyFactorId,@runPeriod) WHERE isCondition = 'Y'
		--如果有系数
		IF ISNULL(@OtherPolicyFactorIdRatio,1) <> 1
		SET @OtherColName = @OtherColName + '*'+ CONVERT(NVARCHAR,@OtherPolicyFactorIdRatio)
		
		IF @LogicSymbol = '=' 	SET @iReturn = @ColName + '=' + @OtherColName
		IF @LogicSymbol = '>' 	SET @iReturn = @ColName + '>' + @OtherColName
		IF @LogicSymbol = '>=' 	SET @iReturn = @ColName + '>=' + @OtherColName
		IF @LogicSymbol = '<' 	SET @iReturn = @ColName + '<' + @OtherColName
		IF @LogicSymbol = '<=' 	SET @iReturn = @ColName + '<=' + @OtherColName
		
	END
	 
	SET @iReturn = ' AND ' + @iReturn
	
	RETURN @iReturn
	
	
END


GO


