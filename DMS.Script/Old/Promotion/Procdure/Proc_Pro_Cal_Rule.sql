DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Rule] 

GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Rule] 
	@PolicyId Int	--����ID
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
	
	DECLARE @LeftColName NVARCHAR(20);			--��������
	DECLARE @LastLeftColName NVARCHAR(20);		--�����еġ������������ֶ�
	DECLARE @runPeriod NVARCHAR(20); 			--��ǰ������ڼ�
	DECLARE @TableName NVARCHAR(50); --��ǰ�����
	DECLARE @RuleIdColName NVARCHAR(20); --��ǰ�ڼ��RULEID
	
	SELECT 
		@CalModule = CalModule,
		@Period = Period,
		@CurrentPeriod = CurrentPeriod,
		@StartDate = StartDate,
		@ifAddLastLeft = CASE ISNULL(ifAddLastLeft,'') WHEN '' THEN 'N' ELSE ifAddLastLeft END
	FROM Promotion.PRO_POLICY
	WHERE PolicyId = @PolicyId
	
	--�õ���ǰ������ڼ�
	IF ISNULL(@CurrentPeriod,'') = ''
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate) 
	END
	ELSE
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
	END
	
	--�õ���ǰ����ı���
	IF @CalModule = '��ʽ'
		SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	ELSE
		SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'CAL')
		
	--ѭ����ǰ�ɼ������
	DECLARE @iCURSOR_Rule CURSOR;
	IF @CalModule = '��ʽ'
	BEGIN
		SET @iCURSOR_Rule = CURSOR FOR SELECT RuleId FROM PROMOTION.PRO_POLICY_RULE WHERE PolicyId = @PolicyId
	END
	ELSE	--�����Ԥ�㣬�����������ȴ�������
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
		
		--ѭ���ù��������е���������ƴ��
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
		
		--����������
		print '����������'
		print @SQL;
		EXEC PROMOTION.Proc_Pro_Cal_Rule_Sub @RuleId,@SQL
		
		FETCH NEXT FROM @iCURSOR_Rule INTO @RuleId
	END	
	CLOSE @iCURSOR_Rule
	DEALLOCATE @iCURSOR_Rule
	
	--��������С��������������������û�з��ϵĹ���RULEID=0����Ҫ�ѱ��ڵġ������������ֶθ�ֵ���������������Ա���ڷ��Ϲ���ʱ����ֲ����
	SET @LeftColName = 'Left' + @runPeriod			--��������
	SET @LastLeftColName = 'LastLeft' + @runPeriod	--�����еġ������������ֶ�
	SET @RuleIdColName = 'RuleId' + @runPeriod				--����ID
	
	IF @ifAddLastLeft = 'Y'
	BEGIN
		SET @SQL = 'UPDATE '+ @TableName + ' SET ' + @LeftColName + '='+@LastLeftColName 
			+' WHERE ' + @RuleIdColName +'=0'
		
		PRINT @SQL
		EXEC(@SQL)	
	END
	
END  

GO


