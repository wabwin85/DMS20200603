DROP PROCEDURE [Promotion].[Proc_Pro_CreateTable] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_CreateTable] 
	@PolicyId Int		--���߱��
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
	
--STEP1:ͨ��PolicyId�����߱�����ز���
	SELECT @Period = A.Period,										--����/�¶�
		@StartPeriod = A.StartDate,
		@EndPeriod = A.EndDate,
		@CalType = A.CalType,										--ByDealer;ByHospital
		@ifConvert = CASE ISNULL(A.ifConvert,'') WHEN '' THEN 'N' ELSE A.ifConvert END,	--�Ƿ�ת�ɻ���
		@ifMinusLastGift = CASE ISNULL(A.ifMinusLastGift,'') WHEN '' THEN 'N' ELSE A.ifMinusLastGift END, --�Ƿ�۳�������Ʒ
		@ifAddLastLeft = CASE ISNULL(A.ifAddLastLeft,'') WHEN '' THEN 'N' ELSE A.ifAddLastLeft END,	--�Ƿ������������
		@IsPrePrice = CASE ISNULL(A.IsPrePrice,'') WHEN '' THEN 'N' ELSE A.IsPrePrice END, --�Ƿ���ǰ�ü۸�
		@YTDOption = CASE ISNULL(A.YTDOption,'') WHEN '' THEN 'N' ELSE A.YTDOption END, --�Ƿ���YTD��ɲ���ʷ���ڽ���
		@ReportTableName = ReportTableName
	FROM PROMOTION.PRO_POLICY A WHERE PolicyId = @PolicyId
		
	--***************************����Ѿ����ڶ�̬����ô�͵��������ֶε�SP***********************************************	
	IF ISNULL(@ReportTableName,'') <>''
	BEGIN
		EXEC PROMOTION.Proc_Pro_AlterTable @PolicyId
		RETURN
	END
	--*********************************************************************************************************************	
	
--STEP2:ȡ�����ߵĿ�ʼ�ͽ����ڼ�
	SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartPeriod)
	SET @EndPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@EndPeriod)
	
--STEP3:ǰ��Ĺ̶���
	--�����̴���
	SET @SQL = @SQL + 'DealerId UNIQUEIDENTIFIER,DealerName NVARCHAR(50),'
	--ҽԺ����
	SET @SQL = @SQL + CASE @CalType WHEN 'ByHospital' THEN 'HospitalId NVARCHAR(50),HospitalName NVARCHAR(50),' ELSE '' END
	--�ۼ���Ʒ������������֣�
	SET @SQL = @SQL + 'LargessTotal DECIMAL(18,4) DEFAULT 0,'
	SET @SQL = @SQL + 'PointsTotal DECIMAL(18,4) DEFAULT 0,'
	
	--�Ƿ���YTD��ɲ���ʷ���ڽ���ʱ����Ҫ���ֶδ����ʷ�ݿ۵���Ʒ�������
	SET @SQL = @SQL + CASE WHEN @YTDOption <> 'N' THEN 'ReserveValue DECIMAL(18,4) DEFAULT 0,' ELSE '' END 
	
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
		
		--�Ƿ���YTD��ɲ���ʷ���ڽ���
		SET @SQL = @SQL + CASE WHEN @YTDOption <> 'N' THEN 'YTDAch'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0,' ELSE '' END 
		--�Ƿ���YTD��ɲ���ʷ���ڽ��������ֶδ�ŵ�ǰ���ڱ�����������
		SET @SQL = @SQL + CASE WHEN @YTDOption <> 'N' THEN 'AdjVal'+@StartPeriod+' DECIMAL(14,4) DEFAULT 0,' ELSE '' END 
		
		--ÿ�ڼ�̶��ֶ�
		SET @SQL = @SQL + 'RuleId'+@StartPeriod+' INT DEFAULT 0,' --���ϵĹ���ID
		
		--�Ƿ���ǰ�ü۸�(�������Ҫ�ˣ�ǰ�ü۸��Ѿ���RV������INTERFACE������ˣ�
		--SET @SQL = @SQL + CASE @IsPrePrice WHEN 'Y' THEN 'PrePrice'+@StartPeriod+' NVARCHAR(5),' ELSE '' END
		
		--�Ƿ������������
		SET @SQL = @SQL + CASE @ifAddLastLeft WHEN 'Y' THEN 'LastLeft'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' ELSE '' END 
		--�Ƿ�ۼ�������Ʒ/����
		SET @SQL = @SQL + CASE @ifMinusLastGift WHEN 'Y' THEN 'LastLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' ELSE '' END 
		SET @SQL = @SQL + CASE @ifMinusLastGift WHEN 'Y' THEN 'LastPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' ELSE '' END 
		
		SET @SQL = @SQL + 'Largess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --��Ʒ����
		SET @SQL = @SQL + 'FinalLargess'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --��˵�������Ʒ����
		SET @SQL = @SQL + 'Points'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --��������
		SET @SQL = @SQL + 'Ratio'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --�Ӽ���
		SET @SQL = @SQL + 'FinalPoints'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --��˵������������
		SET @SQL = @SQL + 'ValidDate'+@StartPeriod+' DATETIME,' --������Ч��
		SET @SQL = @SQL + 'Left'+@StartPeriod+' DECIMAL(18,4) DEFAULT 0,' --ʣ���������
		
		SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@StartPeriod)
	END
	
--STEP3:����Ĺ̶���
	--����

--STEP4:����������CREATE���
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
		
		--������ʽ��ı��ݱ�
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


