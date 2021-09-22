DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Before_1] 
GO


/**********************************************
	功能：主政策要扣除副政策的赠品
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
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
	
	DECLARE @runPeriod NVARCHAR(20); 			--当前计算的期间
	DECLARE @LastPeriod NVARCHAR(20); 			--上个期间
	DECLARE @TableName_Main NVARCHAR(50); --当前计算表（主政策）
	DECLARE @TableName_Other NVARCHAR(50); --当前计算表（副政策）
	DECLARE @LastLargessColName NVARCHAR(20); --本期中的上期促销返利因素字段
	DECLARE @Last_LargessColName NVARCHAR(20); --上期中的本期促销返利因素字段
		
	SELECT 
		@CalModule = CalModule,
		@Period = Period,
		@CurrentPeriod = CurrentPeriod,
		@StartDate = StartDate
	FROM Promotion.PRO_POLICY
	WHERE PolicyId = @PolicyId_Main
	
	--如果是第一次计算就返回
	IF ISNULL(@CurrentPeriod,'') = ''
		RETURN
	
	--得到当前计算的期间
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
	
	--得到当前计算的表名(主政策)
	IF @CalModule = '正式'
		SET @TableName_Main = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId_Main,'TMP')
	ELSE
		SET @TableName_Main = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId_Main,'CAL')

	--(副政策)表名
	SET @TableName_Other = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId_Other,'REP')
	
	SET @LastLargessColName = 'LastLargess' + @runPeriod --本期中的“扣减上期赠品”字段
	SET @Last_LargessColName = 'FinalLargess' + @LastPeriod --上期中的“本期赠品”字段（取调整审批后的字段）
		
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


