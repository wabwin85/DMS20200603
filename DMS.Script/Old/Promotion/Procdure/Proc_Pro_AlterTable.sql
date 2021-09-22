DROP PROCEDURE [Promotion].[Proc_Pro_AlterTable] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_AlterTable] 
	@PolicyId Int		--政策编号
AS
BEGIN
	DECLARE @Period NVARCHAR(5);
	DECLARE @StartPeriod NVARCHAR(6);
	DECLARE @EndPeriod NVARCHAR(6);
	DECLARE @CalType NVARCHAR(20);
	DECLARE @CalPeriod NVARCHAR(20);
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
	DECLARE @TempTableName NVARCHAR(100);
	DECLARE @PreTableName NVARCHAR(100);	
	DECLARE @HistoryReportTableName NVARCHAR(100);
	
	SET @SQL = ''
	
--STEP1:通过PolicyId从政策表获得相关参数
	SELECT @Period = A.Period,										--季度/月度
		@StartPeriod = A.StartDate,
		@EndPeriod = A.EndDate,
		@CalType = A.CalType,										--ByDealer;ByHospital
		@CalPeriod = CalPeriod,
		@ifConvert = CASE ISNULL(A.ifConvert,'') WHEN '' THEN 'N' ELSE A.ifConvert END,	--是否转成积分
		@ifMinusLastGift = CASE ISNULL(A.ifMinusLastGift,'') WHEN '' THEN 'N' ELSE A.ifMinusLastGift END, --是否扣除上期赠品
		@ifAddLastLeft = CASE ISNULL(A.ifAddLastLeft,'') WHEN '' THEN 'N' ELSE A.ifAddLastLeft END,	--是否加上上期余量
		@IsPrePrice = CASE ISNULL(A.IsPrePrice,'') WHEN '' THEN 'N' ELSE A.IsPrePrice END, --是否有前置价格
		@YTDOption = CASE ISNULL(A.YTDOption,'') WHEN '' THEN 'N' ELSE A.YTDOption END, --是否考虑YTD达成补历史帐期奖励
		@ReportTableName = ReportTableName,
		@TempTableName = TempTableName,
		@PreTableName = PreTableName,
		@HistoryReportTableName = ReportTableName + '_HIS'
	FROM PROMOTION.PRO_POLICY A WHERE PolicyId = @PolicyId
	
--STEP2:取得政策的开始和结束期间
	SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartPeriod)
	SET @EndPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@EndPeriod)
	
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
				BEGIN TRY
					SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD '+@ColumnName+' '+@ColumnType + CASE @DefaultValue WHEN '' THEN '' ELSE ' DEFAULT '+@DefaultValue END
					EXEC(@SQL)	
					SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD '+@ColumnName+' '+@ColumnType + CASE @DefaultValue WHEN '' THEN '' ELSE ' DEFAULT '+@DefaultValue END
					EXEC(@SQL)	
					SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD '+@ColumnName+' '+@ColumnType + CASE @DefaultValue WHEN '' THEN '' ELSE ' DEFAULT '+@DefaultValue END
					EXEC(@SQL)	
					SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD '+@ColumnName+' '+@ColumnType + CASE @DefaultValue WHEN '' THEN '' ELSE ' DEFAULT '+@DefaultValue END
					EXEC(@SQL)	
					
					IF @DefaultValue <> '' AND (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
					BEGIN
						SET @SQL = 'UPDATE '+@ReportTableName+' SET '+@ColumnName+' ='''+@DefaultValue+''''
						EXEC(@SQL)
						SET @SQL = 'UPDATE '+@TempTableName+' SET '+@ColumnName+' ='''+@DefaultValue+''''
						EXEC(@SQL)
						SET @SQL = 'UPDATE '+@PreTableName+' SET '+@ColumnName+' ='''+@DefaultValue+''''
						EXEC(@SQL)
						SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET '+@ColumnName+' ='''+@DefaultValue+''''
						EXEC(@SQL)
					END
				END TRY
				BEGIN CATCH
					PRINT 'ERROR'
				END CATCH	
				
				FETCH NEXT FROM @iCURSOR_COLUMN INTO @ColumnName,@ColumnType,@DefaultValue
			END	
			CLOSE @iCURSOR_COLUMN
			DEALLOCATE @iCURSOR_COLUMN
			
			FETCH NEXT FROM @iCURSOR INTO @PolicyFactorId
		END	
		CLOSE @iCURSOR
		DEALLOCATE @iCURSOR
		
		--每期间固定字段
		BEGIN TRY	--符合的规则ID
			SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD RuleId'+@StartPeriod+' INT DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD RuleId'+@StartPeriod+' INT DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD RuleId'+@StartPeriod+' INT DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD RuleId'+@StartPeriod+' INT DEFAULT 0'
			EXEC(@SQL)	
			
			IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
			BEGIN
				SET @SQL = 'UPDATE '+@ReportTableName+' SET RuleId'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@TempTableName+' SET RuleId'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@PreTableName+' SET RuleId'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET RuleId'+@StartPeriod+' = 0'
				EXEC(@SQL)
			END
		END TRY
		BEGIN CATCH
			PRINT 'ERROR'
		END CATCH	
		
		--是否有前置价格(这个不需要了，前置价格已经在RV给出的INTERFACE中算过了）
		--SET @SQL = @SQL + CASE @IsPrePrice WHEN 'Y' THEN 'PrePrice'+@StartPeriod+' NVARCHAR(5),' ELSE '' END
		
		--是否考虑YTD达成补历史帐期奖励
		IF  @YTDOption <> 'N'
		BEGIN 
			BEGIN TRY	
				SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD YTDAch'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD YTDAch'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD YTDAch'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD YTDAch'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0'
				EXEC(@SQL)	
				
				IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
				BEGIN
					SET @SQL = 'UPDATE '+@ReportTableName+' SET YTDAch'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@TempTableName+' SET YTDAch'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@PreTableName+' SET YTDAch'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET YTDAch'+@StartPeriod+' = 0'
					EXEC(@SQL)
				END
			END TRY
			BEGIN CATCH
				PRINT 'ERROR'
			END CATCH	
		END
		
		--是否考虑YTD达成补历史帐期奖励,此字段存放当前帐期被调整的数字
		IF  @YTDOption <> 'N'
		BEGIN 
			BEGIN TRY	
				SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD AdjVal'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD AdjVal'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD AdjVal'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD AdjVal'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0'
				EXEC(@SQL)	
				
				IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
				BEGIN
					SET @SQL = 'UPDATE '+@ReportTableName+' SET AdjVal'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@TempTableName+' SET AdjVal'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@PreTableName+' SET AdjVal'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET AdjVal'+@StartPeriod+' = 0'
					EXEC(@SQL)
				END
			END TRY
			BEGIN CATCH
				PRINT 'ERROR'
			END CATCH	
		END
		
		
		--是否加上上期余量
		IF  @ifAddLastLeft = 'Y'
		BEGIN 
			BEGIN TRY	
				SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD LastLeft'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD LastLeft'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD LastLeft'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD LastLeft'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				
				IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
				BEGIN
					SET @SQL = 'UPDATE '+@ReportTableName+' SET LastLeft'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@TempTableName+' SET LastLeft'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@PreTableName+' SET LastLeft'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET LastLeft'+@StartPeriod+' = 0'
					EXEC(@SQL)
				END
			END TRY
			BEGIN CATCH
				PRINT 'ERROR'
			END CATCH	
		END
		
		--是否扣减上期赠品(赠品)
		IF  @ifMinusLastGift = 'Y'
		BEGIN 
			BEGIN TRY	
				SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD LastLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD LastLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD LastLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD LastLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				
				IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
				BEGIN
					SET @SQL = 'UPDATE '+@ReportTableName+' SET LastLargess'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@TempTableName+' SET LastLargess'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@PreTableName+' SET LastLargess'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET LastLargess'+@StartPeriod+' = 0'
					EXEC(@SQL)
				END
			END TRY
			BEGIN CATCH
				PRINT 'ERROR'
			END CATCH	
		END
		
		--是否扣减上期赠品(积分)
		IF  @ifMinusLastGift = 'Y'
		BEGIN 
			BEGIN TRY	
				SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD LastPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD LastPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD LastPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD LastPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
				EXEC(@SQL)	
				
				IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
				BEGIN
					SET @SQL = 'UPDATE '+@ReportTableName+' SET LastPoints'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@TempTableName+' SET LastPoints'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@PreTableName+' SET LastPoints'+@StartPeriod+' = 0'
					EXEC(@SQL)
					SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET LastPoints'+@StartPeriod+' = 0'
					EXEC(@SQL)
				END
			END TRY
			BEGIN CATCH
				PRINT 'ERROR'
			END CATCH	
		END
		
		--赠品数额
		BEGIN TRY	
			SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD Largess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD Largess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD Largess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD Largess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			
			IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
			BEGIN
				SET @SQL = 'UPDATE '+@ReportTableName+' SET Largess'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@TempTableName+' SET Largess'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@PreTableName+' SET Largess'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET Largess'+@StartPeriod+' = 0'
				EXEC(@SQL)
			END
		END TRY
		BEGIN CATCH
			PRINT 'ERROR'
		END CATCH	
		
		--审核调整后赠品数额
		BEGIN TRY	
			SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD FinalLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD FinalLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD FinalLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD FinalLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			
			IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
			BEGIN
				SET @SQL = 'UPDATE '+@ReportTableName+' SET FinalLargess'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@TempTableName+' SET FinalLargess'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@PreTableName+' SET FinalLargess'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET FinalLargess'+@StartPeriod+' = 0'
				EXEC(@SQL)
			END
		END TRY
		BEGIN CATCH
			PRINT 'ERROR'
		END CATCH	
		
		--积分数额
		BEGIN TRY	
			SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD Points'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD Points'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD Points'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD Points'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			
			IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
			BEGIN
				SET @SQL = 'UPDATE '+@ReportTableName+' SET Points'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@TempTableName+' SET Points'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@PreTableName+' SET Points'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET Points'+@StartPeriod+' = 0'
				EXEC(@SQL)
			END
		END TRY
		BEGIN CATCH
			PRINT 'ERROR'
		END CATCH	
		
		--加价率
		BEGIN TRY	
			SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD Ratio'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD Ratio'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD Ratio'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD Ratio'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			
			IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
			BEGIN
				SET @SQL = 'UPDATE '+@ReportTableName+' SET Ratio'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@TempTableName+' SET Ratio'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@PreTableName+' SET Ratio'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET Ratio'+@StartPeriod+' = 0'
				EXEC(@SQL)
			END
		END TRY
		BEGIN CATCH
			PRINT 'ERROR'
		END CATCH			
		
		--审核调整后积分数额
		BEGIN TRY	
			SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD FinalPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD FinalPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD FinalPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD FinalPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			
			IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
			BEGIN
				SET @SQL = 'UPDATE '+@ReportTableName+' SET FinalPoints'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@TempTableName+' SET FinalPoints'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@PreTableName+' SET FinalPoints'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET FinalPoints'+@StartPeriod+' = 0'
				EXEC(@SQL)
			END
		END TRY
		BEGIN CATCH
			PRINT 'ERROR'
		END CATCH	
		
		--积分有效期
		BEGIN TRY	
			SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD ValidDate'+@StartPeriod+' DATETIME'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD ValidDate'+@StartPeriod+' DATETIME'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD ValidDate'+@StartPeriod+' DATETIME'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD ValidDate'+@StartPeriod+' DATETIME'
			EXEC(@SQL)	
			
		END TRY
		BEGIN CATCH
			PRINT 'ERROR'
		END CATCH	
		
		--剩余计算数量
		BEGIN TRY	
			SET @SQL = 'ALTER TABLE '+@ReportTableName+' ADD Left'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@TempTableName+' ADD Left'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@PreTableName+' ADD Left'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			SET @SQL = 'ALTER TABLE '+@HistoryReportTableName+' ADD Left'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0'
			EXEC(@SQL)	
			
			IF (ISNULL(@CalPeriod,'') = '' OR @StartPeriod > @CalPeriod)
			BEGIN
				SET @SQL = 'UPDATE '+@ReportTableName+' SET Left'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@TempTableName+' SET Left'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@PreTableName+' SET Left'+@StartPeriod+' = 0'
				EXEC(@SQL)
				SET @SQL = 'UPDATE '+@HistoryReportTableName+' SET Left'+@StartPeriod+' = 0'
				EXEC(@SQL)
			END
		END TRY
		BEGIN CATCH
			PRINT 'ERROR'
		END CATCH	
		
		SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@StartPeriod)
	END
	
END

GO


