DROP PROCEDURE [Promotion].[Proc_Pro_CreateTable] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_CreateTable] 
	@PolicyId Int		--政策编号
AS
BEGIN
	DECLARE @Period NVARCHAR(5);
	DECLARE @StartPeriod NVARCHAR(6);
	DECLARE @EndPeriod NVARCHAR(6);
	DECLARE @CalType NVARCHAR(20);
	DECLARE @ifConvert NVARCHAR(5);
	DECLARE @ifMinusLastGift NVARCHAR(5);
	DECLARE @ifAddLastLeft NVARCHAR(5);
	DECLARE @IsPrePrice NVARCHAR(5);
	DECLARE @YTDOption NVARCHAR(5);
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @SQL_CREATETABLE NVARCHAR(MAX);
	
	DECLARE @PolicyFactorId INT;
	DECLARE @ColumnName NVARCHAR(100);
	DECLARE @ColumnType NVARCHAR(100);
	DECLARE @DefaultValue NVARCHAR(100);
	DECLARE @iTableName NVARCHAR(100);
	DECLARE @ReportTableName NVARCHAR(100);
	
	SET @SQL = ''
	
--STEP1:通过PolicyId从政策表获得相关参数
	SELECT @Period = A.Period,										--季度/月度
		@StartPeriod = A.StartDate,
		@EndPeriod = A.EndDate,
		@CalType = A.CalType,										--ByDealer;ByHospital
		@ifConvert = CASE ISNULL(A.ifConvert,'') WHEN '' THEN 'N' ELSE A.ifConvert END,	--是否转成积分
		@ifMinusLastGift = CASE ISNULL(A.ifMinusLastGift,'') WHEN '' THEN 'N' ELSE A.ifMinusLastGift END, --是否扣除上期赠品
		@ifAddLastLeft = CASE ISNULL(A.ifAddLastLeft,'') WHEN '' THEN 'N' ELSE A.ifAddLastLeft END,	--是否加上上期余量
		@IsPrePrice = CASE ISNULL(A.IsPrePrice,'') WHEN '' THEN 'N' ELSE A.IsPrePrice END, --是否有前置价格
		@YTDOption = CASE ISNULL(A.YTDOption,'') WHEN '' THEN 'N' ELSE A.YTDOption END, --是否考虑YTD达成补历史帐期奖励
		@ReportTableName = ReportTableName
	FROM PROMOTION.PRO_POLICY A WHERE PolicyId = @PolicyId
		
	--***************************如果已经存在动态表，那么就调用增加字段的SP***********************************************	
	IF ISNULL(@ReportTableName,'') <>''
	BEGIN
		EXEC PROMOTION.Proc_Pro_AlterTable @PolicyId
		RETURN
	END
	--*********************************************************************************************************************	
	
--STEP2:取得政策的开始和结束期间
	SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartPeriod)
	SET @EndPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@EndPeriod)
	
--STEP3:前面的固定列
	--经销商代码
	SET @SQL = @SQL + 'DealerId UNIQUEIDENTIFIER,DealerName NVARCHAR(50),'
	--医院代码
	SET @SQL = @SQL + CASE @CalType WHEN 'ByHospital' THEN 'HospitalId NVARCHAR(50),HospitalName NVARCHAR(50),' ELSE '' END
	--累计赠品数（数量或积分）
	SET @SQL = @SQL + 'LargessTotal DECIMAL(18,4) DEFAULT 0,'
	SET @SQL = @SQL + 'PointsTotal DECIMAL(18,4) DEFAULT 0,'
	
	--是否考虑YTD达成补历史帐期奖励时，需要有字段存放历史暂扣的赠品数或积分
	SET @SQL = @SQL + CASE WHEN @YTDOption <> 'N' THEN 'ReserveValue DECIMAL(18,4) DEFAULT 0,' ELSE '' END 
	
--STEP4:与期间有关的因素字段	
	WHILE @StartPeriod <= @EndPeriod
	BEGIN
		--使用政策涉及的条件因素做循环
		DECLARE @iCURSOR CURSOR;
		SET @iCURSOR = CURSOR FOR SELECT A.PolicyFactorId FROM PROMOTION.PRO_POLICY_FACTOR A,PROMOTION.PRO_FACTOR B
			WHERE A.FactId = B.FactId AND B.FactType = '条件因素' AND A.PolicyId = @PolicyId ORDER BY B.SortNo 
		OPEN @iCURSOR 	
		FETCH NEXT FROM @iCURSOR INTO @PolicyFactorId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--循环当前因素涉及的字段
			DECLARE @iCURSOR_COLUMN CURSOR;
			SET @iCURSOR_COLUMN = CURSOR FOR SELECT ColumnName,ColumnType,DefaultValue 
					FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@StartPeriod)
			OPEN @iCURSOR_COLUMN 	
			FETCH NEXT FROM @iCURSOR_COLUMN INTO @ColumnName,@ColumnType,@DefaultValue
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @SQL = @SQL + @ColumnName + ' ' + @ColumnType 
				SET @SQL = @SQL + CASE @DefaultValue WHEN '' THEN '' ELSE ' DEFAULT '+@DefaultValue END
				SET @SQL = @SQL + ','
				FETCH NEXT FROM @iCURSOR_COLUMN INTO @ColumnName,@ColumnType,@DefaultValue
			END	
			CLOSE @iCURSOR_COLUMN
			DEALLOCATE @iCURSOR_COLUMN
			
			FETCH NEXT FROM @iCURSOR INTO @PolicyFactorId
		END	
		CLOSE @iCURSOR
		DEALLOCATE @iCURSOR
		
		--是否考虑YTD达成补历史帐期奖励
		SET @SQL = @SQL + CASE WHEN @YTDOption <> 'N' THEN 'YTDAch'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0,' ELSE '' END 
		--是否考虑YTD达成补历史帐期奖励，此字段存放当前帐期被调整的数字
		SET @SQL = @SQL + CASE WHEN @YTDOption <> 'N' THEN 'AdjVal'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0,' ELSE '' END 
		
		--每期间固定字段
		SET @SQL = @SQL + 'RuleId'+@StartPeriod+' INT DEFAULT 0,' --符合的规则ID
		
		--是否有前置价格(这个不需要了，前置价格已经在RV给出的INTERFACE中算过了）
		--SET @SQL = @SQL + CASE @IsPrePrice WHEN 'Y' THEN 'PrePrice'+@StartPeriod+' NVARCHAR(5),' ELSE '' END
		
		--是否加上上期余量
		SET @SQL = @SQL + CASE @ifAddLastLeft WHEN 'Y' THEN 'LastLeft'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' ELSE '' END 
		--是否扣减上期赠品/积分
		SET @SQL = @SQL + CASE @ifMinusLastGift WHEN 'Y' THEN 'LastLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' ELSE '' END 
		SET @SQL = @SQL + CASE @ifMinusLastGift WHEN 'Y' THEN 'LastPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' ELSE '' END 
		
		SET @SQL = @SQL + 'Largess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --赠品数额
		SET @SQL = @SQL + 'FinalLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --审核调整后赠品数额
		SET @SQL = @SQL + 'Points'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --积分数额
		SET @SQL = @SQL + 'Ratio'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --加价率
		SET @SQL = @SQL + 'FinalPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --审核调整后积分数额
		SET @SQL = @SQL + 'ValidDate'+@StartPeriod+' DATETIME,' --积分有效期
		SET @SQL = @SQL + 'Left'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --剩余计算数量
		
		SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@StartPeriod)
	END
	
--STEP3:后面的固定列
	--暂无

--STEP4:生成完整的CREATE语句
		--print @SQL
		SET @iTableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'REP')
		SET @SQL_CREATETABLE = 'CREATE TABLE '+@iTableName+'('+LEFT(@SQL,LEN(@SQL)-1)+')'
		EXEC (@SQL_CREATETABLE)
		UPDATE PROMOTION.PRO_POLICY SET ReportTableName = @iTableName WHERE PolicyId = @PolicyId
		
		SET @iTableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
		SET @SQL_CREATETABLE = 'CREATE TABLE '+@iTableName+'('+LEFT(@SQL,LEN(@SQL)-1)+')'
		EXEC (@SQL_CREATETABLE)
		UPDATE PROMOTION.PRO_POLICY SET TempTableName = @iTableName WHERE PolicyId = @PolicyId
		
		SET @iTableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'CAL')
		SET @SQL_CREATETABLE = 'CREATE TABLE '+@iTableName+'('+LEFT(@SQL,LEN(@SQL)-1)+')'
		EXEC (@SQL_CREATETABLE)
		UPDATE PROMOTION.PRO_POLICY SET PreTableName = @iTableName WHERE PolicyId = @PolicyId
		
		--政策正式表的备份表
		SET @SQL = 'ID INT,BackupTime DATETIME,'+ @SQL
		SET @SQL = '('+LEFT(@SQL,LEN(@SQL)-1)+')'
		SET @iTableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'REP') + '_HIS'
		SET @SQL_CREATETABLE = 'CREATE TABLE '+@iTableName+@SQL
		EXEC (@SQL_CREATETABLE)
		--print @SQL_CREATETABLE
	 	
/*test print
SET @SQL = '('+LEFT(@SQL,LEN(@SQL)-1)+')'
		
		SET @iTableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'REP')
		SET @SQL_CREATETABLE = 'CREATE TABLE '+@iTableName+@SQL
		
		PRINT @SQL_CREATETABLE 
*/

END

GO


