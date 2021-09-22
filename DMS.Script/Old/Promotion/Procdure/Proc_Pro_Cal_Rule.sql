DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Rule] 

GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Rule] 
	@PolicyId Int	--政策ID
AS
BEGIN  
	DECLARE @RuleId INT;
	DECLARE @RuleFactorId INT; 
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @CalModule NVARCHAR(20);
	DECLARE @Period NVARCHAR(5);
	DECLARE @CurrentPeriod NVARCHAR(10);
	DECLARE @StartDate NVARCHAR(10);
	DECLARE @ifAddLastLeft NVARCHAR(5);
	
	DECLARE @LeftColName NVARCHAR(20);			--本期余量
	DECLARE @LastLeftColName NVARCHAR(20);		--本期中的“上期余量”字段
	DECLARE @runPeriod NVARCHAR(20); 			--当前计算的期间
	DECLARE @TableName NVARCHAR(50); --当前计算表
	DECLARE @RuleIdColName NVARCHAR(20); --当前期间的RULEID
	
	SELECT 
		@CalModule = CalModule,
		@Period = Period,
		@CurrentPeriod = CurrentPeriod,
		@StartDate = StartDate,
		@ifAddLastLeft = CASE ISNULL(ifAddLastLeft,'') WHEN '' THEN 'N' ELSE ifAddLastLeft END
	FROM Promotion.PRO_POLICY
	WHERE PolicyId = @PolicyId
	
	--得到当前计算的期间
	IF ISNULL(@CurrentPeriod,'') = ''
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate) 
	END
	ELSE
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
	END
	
	--得到当前计算的表名
	IF @CalModule = '正式'
		SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	ELSE
		SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'CAL')
		
	--循环当前可计算规则
	DECLARE @iCURSOR_Rule CURSOR;
	IF @CalModule = '正式'
	BEGIN
		SET @iCURSOR_Rule = CURSOR FOR SELECT RuleId FROM PROMOTION.PRO_POLICY_RULE WHERE PolicyId = @PolicyId
	END
	ELSE	--如果是预算，按照条件优先次序排序
	BEGIN
		SET @iCURSOR_Rule = CURSOR FOR SELECT DISTINCT RuleId FROM (
			SELECT A.*,ROW_NUMBER() OVER(PARTITION BY A.PolicyId ORDER BY B.AbsoluteValue1 ASC,B.RelativeValue1 ASC) RN 
			FROM PROMOTION.PRO_POLICY_RULE A 
			LEFT JOIN PROMOTION.PRO_POLICY_RULE_FACTOR B ON A.RuleId = B.RuleId
			WHERE A.PolicyId = @PolicyId) T
	END	
	OPEN @iCURSOR_Rule 	
	FETCH NEXT FROM @iCURSOR_Rule INTO @RuleId
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = ''
		
		--循环该规则下所有的条件进行拼接
		DECLARE @iCURSOR_Logic CURSOR;
		SET @iCURSOR_Logic = CURSOR FOR SELECT RuleFactorId FROM PROMOTION.PRO_POLICY_RULE_FACTOR WHERE RuleId = @RuleId
		OPEN @iCURSOR_Logic 	
		FETCH NEXT FROM @iCURSOR_Logic INTO @RuleFactorId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @SQL = @SQL + Promotion.func_Pro_Cal_getRuleFactorReal(@RuleFactorId)
			
			FETCH NEXT FROM @iCURSOR_Logic INTO @RuleFactorId
		END	
		CLOSE @iCURSOR_Logic
		DEALLOCATE @iCURSOR_Logic
		
		--计算促销结果
		print '计算促销结果'
		print @SQL;
		EXEC PROMOTION.Proc_Pro_Cal_Rule_Sub @RuleId,@SQL
		
		FETCH NEXT FROM @iCURSOR_Rule INTO @RuleId
	END	
	CLOSE @iCURSOR_Rule
	DEALLOCATE @iCURSOR_Rule
	
	--如果政策有“加上上期余量”，如果没有符合的规则（RULEID=0），要把本期的“上期余量”字段赋值到“本期余量”以便后期符合规则时计入植入量
	SET @LeftColName = 'Left' + @runPeriod			--本期余量
	SET @LastLeftColName = 'LastLeft' + @runPeriod	--本期中的“上期余量”字段
	SET @RuleIdColName = 'RuleId' + @runPeriod				--规则ID
	
	IF @ifAddLastLeft = 'Y'
	BEGIN
		SET @SQL = 'UPDATE '+ @TableName + ' SET ' + @LeftColName + '='+@LastLeftColName 
			+' WHERE ' + @RuleIdColName +'=0'
		
		PRINT @SQL
		EXEC(@SQL)	
	END
	
END  

GO


