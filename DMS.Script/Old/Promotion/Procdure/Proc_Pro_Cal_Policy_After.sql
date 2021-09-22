DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_After] 
GO


/**********************************************
	功能：单个促销政策计算过程之后的特殊处理
	在此存储过程中，可以针对政策再嵌套各个SP.
	例如：
		1.对于特定经销商在某期间开始不结算，就可以UPDATE该政策的计算表将数据清零。
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
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
	DECLARE @CurrValColumn NVARCHAR(100)	--当前帐期奖励字段，积分'Points'+帐期；赠品'Largess'+帐期
	DECLARE @CurrValFinalColumn NVARCHAR(100)	--当前帐期奖励字段，积分'FinalPoints'+帐期；赠品'FinalLargess'+帐期
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
	
	IF @CalModule='正式'
	BEGIN
		SELECT @TableName=TempTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END
	ELSE
	BEGIN
		SELECT @TableName=PreTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END 
	
	--@CurrentPeriod当前计算帐期
	SELECT 
		@RunPeriod = PROMOTION.func_Pro_Utility_getPeriod(Period,CASE ISNULL(CURRENTPERIOD,'') WHEN '' THEN 'CURRENT' ELSE 'NEXT' END,
			CASE ISNULL(CURRENTPERIOD,'') WHEN '' THEN STARTDATE ELSE CURRENTPERIOD END)
	FROM Promotion.PRO_POLICY A WHERE A.PolicyId = @PolicyId
	
	--1.如果政策选项中有YTD选项（YTD满足就补历史奖励）
	IF @YTDOption <> 'N'
	BEGIN
		SET @YTDAchColumn = 'YTDAch'+@RunPeriod
		SET @AdjValColumn = 'AdjVal'+@RunPeriod 
		
		IF @PolicyStyle = '赠品'
		BEGIN
			SET @CurrValColumn = 'Largess'+@RunPeriod
			SET @CurrValFinalColumn = 'FinalLargess'+@RunPeriod
		END
		
		IF @PolicyStyle = '积分'
		BEGIN
			SET @CurrValColumn = 'Points'+@RunPeriod
			SET @CurrValFinalColumn = 'FinalPoints'+@RunPeriod
		END
		
		--1.1将YTDach<1,赠品或积分移到RESERVEVLAUE
		--1.1.1只判断YTD，YTD满足就奖励，否则即使当前帐期满足也不奖励(将YTDach<1的移掉)
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
		
		--1.1.2--当前帐期满足进行奖励，若YTD满足补历史奖励(将YTDach<1 AND 当前帐期不达标 的移掉)
		IF @YTDOption = 'YTDRTN'	
		BEGIN
			--认为政策中只有1个指定产品达标类的因素
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
		
		--2.2 将YTDach>=1 的RESERVEVLAUE加到当帐期的赠品或积分,并记录当前帐期的AdjVal字段
		SET @SQL = 'UPDATE '+@TableName+' SET '+@CurrValColumn+'='+@CurrValColumn+'+ ReserveValue,' 
			+ @CurrValFinalColumn +'='+@CurrValFinalColumn+'+ReserveValue,'
			+ @AdjValColumn +'='+@AdjValColumn+'+ReserveValue'
				+ ' WHERE '+@YTDAchColumn+' >= 1'
			PRINT @SQL
			EXEC(@SQL)
		
		--20160920 当使用了历史累计的未发赠品或积分时,要将RESERVEVLAUE清零
		SET @SQL = 'UPDATE '+@TableName+' SET ReserveValue = 0 WHERE '+@YTDAchColumn+' >= 1'
			PRINT @SQL
			EXEC(@SQL)	
	
	END
	

 	RETURN 
END  

GO


