DROP PROCEDURE [Promotion].[Proc_Pro_Export_Policy] 
GO



/**********************************************
	���ܣ���������������
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Export_Policy]  
	@PolicyId Int ,--����ID
	@CalModule  NVARCHAR(10) --TMP/CAL/REP
AS
BEGIN
	DECLARE @Period NVARCHAR(5);
	DECLARE @CalType NVARCHAR(20);
	DECLARE @StartPeriod NVARCHAR(6);
	DECLARE @EndPeriod NVARCHAR(6);
	DECLARE @ifConvert NVARCHAR(5);
	DECLARE @ifAddLastLeft NVARCHAR(5);
	DECLARE @ifMinusLastGift NVARCHAR(5);
	
	DECLARE @TableName NVARCHAR(50); --��ǰ�����
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @PolicyFactorId INT; 
	DECLARE @ColumnName NVARCHAR(100);
	DECLARE @ColumnDesc NVARCHAR(500);

	
	--ͨ��PolicyId�����߱�����ز���
	SELECT @Period = A.Period,
		@StartPeriod = A.StartDate,
		@EndPeriod = A.EndDate,
		@CalType = A.CalType,
		@ifConvert = ISNULL(A.ifConvert,''),
		@ifAddLastLeft = ISNULL(A.ifAddLastLeft,''),
		@ifMinusLastGift = ISNULL(A.ifMinusLastGift,'')
	FROM PROMOTION.PRO_POLICY A WHERE PolicyId = @PolicyId
	
	--ȡ�����ߵĿ�ʼ�ͽ����ڼ�
	SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartPeriod)
	SET @EndPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@EndPeriod)
	
	--�õ���ǰ����ı���
	SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,@CalModule)

	--�����̴���
	SET @SQL = ' SELECT DealerId AS [������ID] , DealerName AS [����������]'
	--ҽԺ����
	SET @SQL = @SQL + CASE @CalType WHEN 'ByHospital' THEN ',HospitalId AS [ҽԺCode] ,HospitalName AS [ҽԺ����]' ELSE '' END
	
	SET @SQL = @SQL + ',LargessTotal AS [�ۼ�'+CASE @ifConvert WHEN 'Y' THEN '����' ELSE '��Ʒ' END+']'
	
	WHILE @StartPeriod <= @EndPeriod
	BEGIN
		DECLARE @iCURSOR CURSOR;
		SET @iCURSOR = CURSOR FOR SELECT A.PolicyFactorId FROM PROMOTION.PRO_POLICY_FACTOR A,PROMOTION.PRO_FACTOR B
				WHERE A.FactId = B.FactId AND B.FactType = '��������' AND A.PolicyId = @PolicyId ORDER BY B.SortNo 
		OPEN @iCURSOR 	
		FETCH NEXT FROM @iCURSOR INTO @PolicyFactorId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @iCURSOR_COLUMN CURSOR;
			SET @iCURSOR_COLUMN = CURSOR FOR SELECT ColumnName, ColumnDesc FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@StartPeriod)
			OPEN @iCURSOR_COLUMN 	
			FETCH NEXT FROM @iCURSOR_COLUMN INTO @ColumnName,@ColumnDesc
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @SQL += (','+ @ColumnName +' AS ['+@ColumnDesc+']')
				FETCH NEXT FROM @iCURSOR_COLUMN INTO @ColumnName,@ColumnDesc
			END	
			CLOSE @iCURSOR_COLUMN
			DEALLOCATE @iCURSOR_COLUMN
		
			FETCH NEXT FROM @iCURSOR INTO @PolicyFactorId
		END	
		CLOSE @iCURSOR
		DEALLOCATE @iCURSOR
		
		--�Ƿ������������
		SET @SQL = @SQL + CASE @ifAddLastLeft WHEN 'Y' THEN ',LastLeft'+@StartPeriod+' AS [����ʣ���������$'+@StartPeriod+']' ELSE '' END 
		--�Ƿ�ۼ�������Ʒ
		SET @SQL = @SQL + CASE @ifMinusLastGift WHEN 'Y' THEN ',LastLargess'+@StartPeriod+' AS [���ڴ�����Ʒ����$'+@StartPeriod+']' ELSE '' END 
		
		SET @SQL = @SQL + ',Largess'+@StartPeriod +' AS [��Ʒ��$'+@StartPeriod+']'  --��Ʒ����
		SET @SQL = @SQL + ',FinalLargess'+@StartPeriod+' AS [��������Ʒ��$'+@StartPeriod+']' --��������Ʒ����
		SET @SQL = @SQL + CASE @ifConvert WHEN 'Y' THEN ',Points'+@StartPeriod +' AS [������$'+@StartPeriod+']' ELSE '' END --��������
		SET @SQL = @SQL + CASE @ifConvert WHEN 'Y' THEN ',FinalPoints'+@StartPeriod +' AS [�����������$'+@StartPeriod+']' ELSE '' END --�������������
		
		SET @SQL = @SQL + CASE @ifAddLastLeft WHEN 'Y' THEN ',Left'+@StartPeriod+' AS [ʣ���������$'+@StartPeriod+']' ELSE '' END --ʣ���������
		
		SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@StartPeriod)
	END
	
	SET @SQL=@SQL+' FROM '+@TableName
	
	PRINT @SQL;
	EXEC (@SQL)
END



GO


