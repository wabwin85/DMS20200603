DROP PROCEDURE [Promotion].[Proc_Pro_AlterTable] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_AlterTable] 
	@PolicyId Int		--���߱��
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
	
--STEP1:ͨ��PolicyId�����߱�����ز���
	SELECT @Period = A.Period,										--����/�¶�
		@StartPeriod = A.StartDate,
		@EndPeriod = A.EndDate,
		@CalType = A.CalType,										--ByDealer;ByHospital
		@CalPeriod = CalPeriod,
		@ifConvert = CASE ISNULL(A.ifConvert,'') WHEN '' THEN 'N' ELSE A.ifConvert END,	--�Ƿ�ת�ɻ���
		@ifMinusLastGift = CASE ISNULL(A.ifMinusLastGift,'') WHEN '' THEN 'N' ELSE A.ifMinusLastGift END, --�Ƿ�۳�������Ʒ
		@ifAddLastLeft = CASE ISNULL(A.ifAddLastLeft,'') WHEN '' THEN 'N' ELSE A.ifAddLastLeft END,	--�Ƿ������������
		@IsPrePrice = CASE ISNULL(A.IsPrePrice,'') WHEN '' THEN 'N' ELSE A.IsPrePrice END, --�Ƿ���ǰ�ü۸�
		@YTDOption = CASE ISNULL(A.YTDOption,'') WHEN '' THEN 'N' ELSE A.YTDOption END, --�Ƿ���YTD��ɲ���ʷ���ڽ���
		@ReportTableName = ReportTableName,
		@TempTableName = TempTableName,
		@PreTableName = PreTableName,
		@HistoryReportTableName = ReportTableName + '_HIS'
	FROM PROMOTION.PRO_POLICY A WHERE PolicyId = @PolicyId
	
--STEP2:ȡ�����ߵĿ�ʼ�ͽ����ڼ�
	SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartPeriod)
	SET @EndPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@EndPeriod)
	
--STEP4:���ڼ��йص������ֶ�	
	WHILE @StartPeriod <= @EndPeriod
	BEGIN
		--ʹ�������漰������������ѭ��
		DECLARE @iCURSOR CURSOR;
		SET @iCURSOR = CURSOR FOR SELECT A.PolicyFactorId FROM PROMOTION.PRO_POLICY_FACTOR A,PROMOTION.PRO_FACTOR B
			WHERE A.FactId = B.FactId AND B.FactType = '��������' AND A.PolicyId = @PolicyId ORDER BY B.SortNo 
		OPEN @iCURSOR 	
		FETCH NEXT FROM @iCURSOR INTO @PolicyFactorId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--ѭ����ǰ�����漰���ֶ�
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
		
		--ÿ�ڼ�̶��ֶ�
		BEGIN TRY	--���ϵĹ���ID
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
		
		--�Ƿ���ǰ�ü۸�(�������Ҫ�ˣ�ǰ�ü۸��Ѿ���RV������INTERFACE������ˣ�
		--SET @SQL = @SQL + CASE @IsPrePrice WHEN 'Y' THEN 'PrePrice'+@StartPeriod+' NVARCHAR(5),' ELSE '' END
		
		--�Ƿ���YTD��ɲ���ʷ���ڽ���
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
		
		--�Ƿ���YTD��ɲ���ʷ���ڽ���,���ֶδ�ŵ�ǰ���ڱ�����������
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
		
		
		--�Ƿ������������
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
		
		--�Ƿ�ۼ�������Ʒ(��Ʒ)
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
		
		--�Ƿ�ۼ�������Ʒ(����)
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
		
		--��Ʒ����
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
		
		--��˵�������Ʒ����
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
		
		--��������
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
		
		--�Ӽ���
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
		
		--��˵������������
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
		
		--������Ч��
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
		
		--ʣ���������
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


