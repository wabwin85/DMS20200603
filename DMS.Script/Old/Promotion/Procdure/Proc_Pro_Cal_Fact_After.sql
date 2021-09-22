DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Fact_After] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Fact_After] 
	@PolicyId INT
AS
BEGIN  
	DECLARE @PolicyFactorId INT
	DECLARE @Period NVARCHAR(50)
	DECLARE @CurrentPeriod NVARCHAR(50)
	DECLARE @StartDate NVARCHAR(50)
	DECLARE @CalModule NVARCHAR(50)
	DECLARE @TableName NVARCHAR(100)
	DECLARE @StartPeriod NVARCHAR(50)
	DECLARE @RunPeriod NVARCHAR(50)
	DECLARE @ColumnName NVARCHAR(100)
	DECLARE @SourceColumn NVARCHAR(100)
	DECLARE @SQL NVARCHAR(MAX)	
	DECLARE @SQL_FENZI NVARCHAR(MAX)	
	DECLARE @SQL_FENMU NVARCHAR(MAX)
	DECLARE @YTDAchColumn NVARCHAR(100)
	
	SET @SQL  = ''
	SET @SQL_FENZI = ''
	SET @SQL_FENMU = ''
	
	SELECT  
		@Period = Period,
		@CurrentPeriod = CurrentPeriod,
		@StartDate = StartDate,
		@CalModule = CalModule 
	FROM Promotion.PRO_POLICY 
	WHERE PolicyId = @PolicyId
	
	IF @CalModule='正式'
	BEGIN
		SELECT @TableName=TempTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END
	ELSE
	BEGIN
		SELECT @TableName=PreTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END 
	
	--@StartPeriod政策的开始帐期，@CurrentPeriod当前计算帐期
	SELECT @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(Period,'CURRENT',STARTDATE),
		@RunPeriod = PROMOTION.func_Pro_Utility_getPeriod(Period,CASE ISNULL(CURRENTPERIOD,'') WHEN '' THEN 'CURRENT' ELSE 'NEXT' END,
			CASE ISNULL(CURRENTPERIOD,'') WHEN '' THEN STARTDATE ELSE CURRENTPERIOD END)
	FROM Promotion.PRO_POLICY A WHERE A.PolicyId = @PolicyId
	
	--1.如果政策选项中有YTD选项（YTD满足就补历史奖励），就要计算YTD的计算列
	IF EXISTS (SELECT * FROM Promotion.Pro_Policy WHERE PolicyId = @PolicyId AND ISNULL(YTDOption,'N') <> 'N')
	BEGIN	
		--认为政策中只有1个指定产品达标类的因素
		SELECT @PolicyFactorId = PolicyFactorId FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId IN (6,7,14,15)
		
		SET @YTDAchColumn = 'YTDAch'+@RunPeriod 
		
		WHILE @StartPeriod <= @RunPeriod
		BEGIN
			DECLARE @iCURSOR_YTDOption CURSOR;
			SET @iCURSOR_YTDOption = CURSOR FOR SELECT ColumnName,SourceColumn 
				FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@StartPeriod)
				WHERE SourceColumn IN ('目标1','实际值')
			OPEN @iCURSOR_YTDOption 	
			FETCH NEXT FROM @iCURSOR_YTDOption INTO @ColumnName,@SourceColumn
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @SourceColumn = '实际值'
				BEGIN
					SET @SQL_FENZI += CASE @SQL_FENZI WHEN '' THEN '' ELSE '+' END + @ColumnName
				END
				IF @SourceColumn = '目标1'
				BEGIN
					SET @SQL_FENMU += CASE @SQL_FENMU WHEN '' THEN '' ELSE '+' END + @ColumnName
				END
				FETCH NEXT FROM @iCURSOR_YTDOption INTO @ColumnName,@SourceColumn
			END	
			CLOSE @iCURSOR_YTDOption
			DEALLOCATE @iCURSOR_YTDOption 
			
			SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@StartPeriod)
		END
		
		SET @SQL = 'UPDATE '+@TableName+' SET '+@YTDAchColumn+'='+'CASE '+@SQL_FENMU+' WHEN 0 THEN 0 ELSE ('+@SQL_FENZI+')/('+@SQL_FENMU+') END'		
		PRINT @SQL
		EXEC (@SQL)
	END
	
 	RETURN  
END  

GO


