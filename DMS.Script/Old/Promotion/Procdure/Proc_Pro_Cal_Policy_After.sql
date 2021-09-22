DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_After] 
GO


/**********************************************
	���ܣ������������߼������֮������⴦��
	�ڴ˴洢�����У��������������Ƕ�׸���SP.
	���磺
		1.�����ض���������ĳ�ڼ俪ʼ�����㣬�Ϳ���UPDATE�����ߵļ�����������㡣
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_After] 
	@PolicyId INT
AS
BEGIN  
	DECLARE @Period NVARCHAR(50)
	DECLARE @CurrentPeriod NVARCHAR(50)
	DECLARE @StartDate NVARCHAR(50)
	DECLARE @CalModule NVARCHAR(50)
	DECLARE @PolicyStyle NVARCHAR(50)
	DECLARE @PolicySubStyle NVARCHAR(50)
	DECLARE @TableName NVARCHAR(100)
	DECLARE @RunPeriod NVARCHAR(50)
	DECLARE @PolicyFactorId INT
	DECLARE @RULEFACTORID INT	
	DECLARE @SQL NVARCHAR(MAX)	
	DECLARE @YTDOption NVARCHAR(50)
	DECLARE @CurrValColumn NVARCHAR(100)	--��ǰ���ڽ����ֶΣ�����'Points'+���ڣ���Ʒ'Largess'+����
	DECLARE @CurrValFinalColumn NVARCHAR(100)	--��ǰ���ڽ����ֶΣ�����'FinalPoints'+���ڣ���Ʒ'FinalLargess'+����
	DECLARE @YTDAchColumn NVARCHAR(100)
	DECLARE @AdjValColumn NVARCHAR(100) 
	
	SELECT  
		@Period = Period,
		@CurrentPeriod = CurrentPeriod,
		@StartDate = StartDate,
		@CalModule = CalModule,
		@PolicyStyle = PolicyStyle,
		@PolicySubStyle = PolicySubStyle,
		@YTDOption = ISNULL(YTDOption,'N')
	FROM Promotion.PRO_POLICY 
	WHERE PolicyId = @PolicyId
	
	IF @CalModule='��ʽ'
	BEGIN
		SELECT @TableName=TempTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END
	ELSE
	BEGIN
		SELECT @TableName=PreTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END 
	
	--@CurrentPeriod��ǰ��������
	SELECT 
		@RunPeriod = PROMOTION.func_Pro_Utility_getPeriod(Period,CASE ISNULL(CURRENTPERIOD,'') WHEN '' THEN 'CURRENT' ELSE 'NEXT' END,
			CASE ISNULL(CURRENTPERIOD,'') WHEN '' THEN STARTDATE ELSE CURRENTPERIOD END)
	FROM Promotion.PRO_POLICY A WHERE A.PolicyId = @PolicyId
	
	--1.�������ѡ������YTDѡ�YTD����Ͳ���ʷ������
	IF @YTDOption <> 'N'
	BEGIN
		SET @YTDAchColumn = 'YTDAch'+@RunPeriod
		SET @AdjValColumn = 'AdjVal'+@RunPeriod 
		
		IF @PolicyStyle = '��Ʒ'
		BEGIN
			SET @CurrValColumn = 'Largess'+@RunPeriod
			SET @CurrValFinalColumn = 'FinalLargess'+@RunPeriod
		END
		
		IF @PolicyStyle = '����'
		BEGIN
			SET @CurrValColumn = 'Points'+@RunPeriod
			SET @CurrValFinalColumn = 'FinalPoints'+@RunPeriod
		END
		
		--1.1��YTDach<1,��Ʒ������Ƶ�RESERVEVLAUE
		--1.1.1ֻ�ж�YTD��YTD����ͽ���������ʹ��ǰ��������Ҳ������(��YTDach<1���Ƶ�)
		IF @YTDOption = 'YTD'	
		BEGIN
			SET @SQL = 'UPDATE '+@TableName+' SET ReserveValue = ReserveValue+' + @CurrValColumn + ',' 
				+@AdjValColumn+'='+@AdjValColumn+'-'+@CurrValColumn+ ' WHERE '+@YTDAchColumn+' < 1'
			PRINT @SQL
			EXEC(@SQL)
			
			SET @SQL = 'UPDATE '+@TableName+' SET '+@CurrValColumn+'=0,'+@CurrValFinalColumn+'=0 WHERE '+@YTDAchColumn+' < 1'
			PRINT @SQL
			EXEC(@SQL)
		END
		
		--1.1.2--��ǰ����������н�������YTD���㲹��ʷ����(��YTDach<1 AND ��ǰ���ڲ���� ���Ƶ�)
		IF @YTDOption = 'YTDRTN'	
		BEGIN
			--��Ϊ������ֻ��1��ָ����Ʒ����������
			SELECT @PolicyFactorId = PolicyFactorId FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId IN (6,7,14,15)
			
			SELECT @RULEFACTORID = A.RULEFACTORID FROM PROMOTION.PRO_POLICY_RULE_FACTOR A,PROMOTION.PRO_POLICY_RULE B
			WHERE A.RULEID = B.RULEID AND B.POLICYID = @PolicyId AND A.POLICYFACTORID = @PolicyFactorId
			
			SET @SQL = 'UPDATE '+@TableName+' SET ReserveValue = ReserveValue+' + @CurrValColumn +','
				+ @AdjValColumn+'='+@AdjValColumn+'-'+@CurrValColumn
				+ ' WHERE '+@YTDAchColumn+' < 1 AND NOT (1=1 '+Promotion.func_Pro_Cal_getRuleFactor(@RULEFACTORID)+')'
			PRINT @SQL
			EXEC(@SQL)
						
			SET @SQL = 'UPDATE '+@TableName+' SET '+@CurrValColumn+'=0,'+@CurrValFinalColumn+'=0 WHERE '
				+@YTDAchColumn+' < 1 AND NOT (1=1 '+Promotion.func_Pro_Cal_getRuleFactor(@RULEFACTORID)+')'
			PRINT @SQL
			EXEC(@SQL)
			
		END
		
		--2.2 ��YTDach>=1 ��RESERVEVLAUE�ӵ������ڵ���Ʒ�����,����¼��ǰ���ڵ�AdjVal�ֶ�
		SET @SQL = 'UPDATE '+@TableName+' SET '+@CurrValColumn+'='+@CurrValColumn+'+ ReserveValue,' 
			+ @CurrValFinalColumn +'='+@CurrValFinalColumn+'+ReserveValue,'
			+ @AdjValColumn +'='+@AdjValColumn+'+ReserveValue'
				+ ' WHERE '+@YTDAchColumn+' >= 1'
			PRINT @SQL
			EXEC(@SQL)
		
		--20160920 ��ʹ������ʷ�ۼƵ�δ����Ʒ�����ʱ,Ҫ��RESERVEVLAUE����
		SET @SQL = 'UPDATE '+@TableName+' SET ReserveValue = 0 WHERE '+@YTDAchColumn+' >= 1'
			PRINT @SQL
			EXEC(@SQL)	
	
	END
	

 	RETURN 
END  

GO


