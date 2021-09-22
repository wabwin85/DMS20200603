DROP PROCEDURE [Promotion].[Proc_Pro_Export_Policy] 
GO



/**********************************************
	功能：促销计算结果导出
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Export_Policy]  
	@PolicyId Int ,--政策ID
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
	
	DECLARE @TableName NVARCHAR(50); --当前计算表
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @PolicyFactorId INT; 
	DECLARE @ColumnName NVARCHAR(100);
	DECLARE @ColumnDesc NVARCHAR(500);

	
	--通过PolicyId从政策表获得相关参数
	SELECT @Period = A.Period,
		@StartPeriod = A.StartDate,
		@EndPeriod = A.EndDate,
		@CalType = A.CalType,
		@ifConvert = ISNULL(A.ifConvert,''),
		@ifAddLastLeft = ISNULL(A.ifAddLastLeft,''),
		@ifMinusLastGift = ISNULL(A.ifMinusLastGift,'')
	FROM PROMOTION.PRO_POLICY A WHERE PolicyId = @PolicyId
	
	--取得政策的开始和结束期间
	SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartPeriod)
	SET @EndPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@EndPeriod)
	
	--得到当前计算的表名
	SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,@CalModule)

	--经销商代码
	SET @SQL = ' SELECT DealerId AS [经销商ID] , DealerName AS [经销商名称]'
	--医院代码
	SET @SQL = @SQL + CASE @CalType WHEN 'ByHospital' THEN ',HospitalId AS [医院Code] ,HospitalName AS [医院名称]' ELSE '' END
	
	SET @SQL = @SQL + ',LargessTotal AS [累计'+CASE @ifConvert WHEN 'Y' THEN '积分' ELSE '赠品' END+']'
	
	WHILE @StartPeriod <= @EndPeriod
	BEGIN
		DECLARE @iCURSOR CURSOR;
		SET @iCURSOR = CURSOR FOR SELECT A.PolicyFactorId FROM PROMOTION.PRO_POLICY_FACTOR A,PROMOTION.PRO_FACTOR B
				WHERE A.FactId = B.FactId AND B.FactType = '条件因素' AND A.PolicyId = @PolicyId ORDER BY B.SortNo 
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
		
		--是否加上上期余量
		SET @SQL = @SQL + CASE @ifAddLastLeft WHEN 'Y' THEN ',LastLeft'+@StartPeriod+' AS [上期剩余计算数量$'+@StartPeriod+']' ELSE '' END 
		--是否扣减上期赠品
		SET @SQL = @SQL + CASE @ifMinusLastGift WHEN 'Y' THEN ',LastLargess'+@StartPeriod+' AS [上期待扣赠品数量$'+@StartPeriod+']' ELSE '' END 
		
		SET @SQL = @SQL + ',Largess'+@StartPeriod +' AS [赠品数$'+@StartPeriod+']'  --赠品数额
		SET @SQL = @SQL + ',FinalLargess'+@StartPeriod+' AS [调整后赠品数$'+@StartPeriod+']' --调整后赠品数额
		SET @SQL = @SQL + CASE @ifConvert WHEN 'Y' THEN ',Points'+@StartPeriod +' AS [积分数$'+@StartPeriod+']' ELSE '' END --积分数额
		SET @SQL = @SQL + CASE @ifConvert WHEN 'Y' THEN ',FinalPoints'+@StartPeriod +' AS [调整后积分数$'+@StartPeriod+']' ELSE '' END --调整后积分数额
		
		SET @SQL = @SQL + CASE @ifAddLastLeft WHEN 'Y' THEN ',Left'+@StartPeriod+' AS [剩余计算数量$'+@StartPeriod+']' ELSE '' END --剩余计算数量
		
		SET @StartPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@StartPeriod)
	END
	
	SET @SQL=@SQL+' FROM '+@TableName
	
	PRINT @SQL;
	EXEC (@SQL)
END



GO


