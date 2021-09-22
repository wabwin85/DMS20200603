DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Before_1] 
GO


/**********************************************
	���ܣ�������Ҫ�۳������ߵ���Ʒ
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Before_1] 
	@PolicyId_Main INT,
	@PolicyId_Other INT
AS
BEGIN  
	DECLARE @SQL NVARCHAR(MAX);
	
	DECLARE @CalModule NVARCHAR(20);
	DECLARE @Period NVARCHAR(5);
	DECLARE @CurrentPeriod NVARCHAR(10);
	DECLARE @StartDate NVARCHAR(10);
	
	DECLARE @runPeriod NVARCHAR(20); 			--��ǰ������ڼ�
	DECLARE @LastPeriod NVARCHAR(20); 			--�ϸ��ڼ�
	DECLARE @TableName_Main NVARCHAR(50); --��ǰ����������ߣ�
	DECLARE @TableName_Other NVARCHAR(50); --��ǰ����������ߣ�
	DECLARE @LastLargessColName NVARCHAR(20); --�����е����ڴ������������ֶ�
	DECLARE @Last_LargessColName NVARCHAR(20); --�����еı��ڴ������������ֶ�
		
	SELECT 
		@CalModule = CalModule,
		@Period = Period,
		@CurrentPeriod = CurrentPeriod,
		@StartDate = StartDate
	FROM Promotion.PRO_POLICY
	WHERE PolicyId = @PolicyId_Main
	
	--����ǵ�һ�μ���ͷ���
	IF ISNULL(@CurrentPeriod,'') = ''
		RETURN
	
	--�õ���ǰ������ڼ�
	IF ISNULL(@CurrentPeriod,'') = ''
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate) 
		SET @LastPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	END
	ELSE
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
		SET @LastPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@CurrentPeriod)
	END
	
	--�õ���ǰ����ı���(������)
	IF @CalModule = '��ʽ'
		SET @TableName_Main = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId_Main,'TMP')
	ELSE
		SET @TableName_Main = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId_Main,'CAL')

	--(������)����
	SET @TableName_Other = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId_Other,'REP')
	
	SET @LastLargessColName = 'LastLargess' + @runPeriod --�����еġ��ۼ�������Ʒ���ֶ�
	SET @Last_LargessColName = 'FinalLargess' + @LastPeriod --�����еġ�������Ʒ���ֶΣ�ȡ������������ֶΣ�
		
	SET @SQL = 'UPDATE A SET '+@LastLargessColName +'=A.'+@LastLargessColName+'+B.'+@Last_LargessColName
		+' FROM '+@TableName_Main+' A,'+@TableName_Other+' B WHERE A.DealerId = B.DealerId'
		
	PRINT @SQL
	
	BEGIN TRY
	EXEC(@SQL)
	END TRY
	BEGIN CATCH
	PRINT 'Proc_Pro_Cal_Policy_Before_1:SQL ERROR BUT CATCHED'
	END CATCH		 
	
 	RETURN
END  

GO


