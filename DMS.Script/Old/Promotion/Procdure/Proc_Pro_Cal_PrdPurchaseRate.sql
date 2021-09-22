DROP PROCEDURE [Promotion].[Proc_Pro_Cal_PrdPurchaseRate]
GO




/**********************************************
	功能：计算指定产品的商业采购达成
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_PrdPurchaseRate]
	@PolicyFactorId Int	--政策因素编号
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @runPeriod NVARCHAR(20); --当前计算的期间
	DECLARE @TableName NVARCHAR(50); --当前计算表
	
	DECLARE @FactId INT;
	DECLARE @PolicyId INT;
	DECLARE @Period NVARCHAR(5);
	DECLARE @CurrentPeriod NVARCHAR(10);
	DECLARE @StartDate NVARCHAR(10);
	DECLARE @OverDate NVARCHAR(10);
	DECLARE @CalModule NVARCHAR(20);
	DECLARE @CalType NVARCHAR(20);
	
	DECLARE @ColumnName NVARCHAR(100);
	DECLARE @SourceColumn NVARCHAR(100);
	
	DECLARE @FactBeginDate NVARCHAR(10)
	DECLARE @FactEndDate NVARCHAR(10)
	
	
	SELECT
		@FactId = B.FactId,
		@PolicyId = A.PolicyId,
		@Period = A.Period,					--季度\月度
		@CurrentPeriod = A.CurrentPeriod,	--当前已计算期间
		@StartDate = A.StartDate,
		@OverDate=A.EndDate,
		@CalModule = A.CalModule,			--正式\预算
		@CalType = A.CalType				--ByDealer\ByHospital
	FROM Promotion.PRO_POLICY a,Promotion.PRO_POLICY_FACTOR b
	WHERE a.PolicyId = b.PolicyId AND b.PolicyFactorId = @PolicyFactorId
	
	
	SET @FactBeginDate=Promotion.func_Pro_Utility_getPeriod_StartDate(@StartDate)
	SET @FactEndDate=Promotion.func_Pro_Utility_getPeriod_EndDate(@OverDate)
	
	--得到当前计算的表名
	IF @CalModule = '正式'
		SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	ELSE
		SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'CAL')
	
	--得到当前计算的期间
	IF ISNULL(@CurrentPeriod,'') = ''
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	ELSE
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)

	--******************更新5个目标值START*******************************************************************	
	SET @SQL = ''	
	--循环当前因素涉及字段
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT ColumnName,SourceColumn FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@runPeriod) 
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @ColumnName,@SourceColumn
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = 'UPDATE A SET '+@ColumnName+'=B.TargetValue FROM '+@TableName+' A,'
			+'(SELECT TargetLevel,DealerId,'+'SUM(TargetValue) TargetValue'
			+' FROM Promotion.Pro_Dealer_PrdPurchase_Taget '
			+'WHERE PolicyFactorId = '+CONVERT(NVARCHAR,@PolicyFactorId)+' AND Period ='''+@runPeriod+''' '
			+'GROUP BY TargetLevel,DealerId) B '
			+'WHERE A.DealerId = b.DealerId '
			+' AND B.TargetLevel = '''+@SourceColumn+''''
		
		--PRINT @SQL
		EXEC(@SQL)
		FETCH NEXT FROM @iCURSOR INTO @ColumnName,@SourceColumn
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	--******************更新5个目标值END*******************************************************************
		
	DECLARE @BeginDate NVARCHAR(10)
	DECLARE @EndDate NVARCHAR(10)
	IF @CalModule = '正式'
	BEGIN
		SET @BeginDate = Promotion.func_Pro_Utility_getPeriod_StartDate(@runPeriod)
		SET @EndDate = Promotion.func_Pro_Utility_getPeriod_EndDate(@runPeriod)
	END
	ELSE
	BEGIN
		--如果是预算，从预算日志表中取得起止日期
		SELECT @BeginDate = STARTDATE,@EndDate = ENDDATE 
		FROM Promotion.Pro_Forecast_Log 
		WHERE STATUS = 'Running'
	END
	
	DECLARE @ProductPolicyFactorId INT
	
	SELECT @ProductPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION a,Promotion.PRO_POLICY_FACTOR B WHERE A.PolicyFactorId = @PolicyFactorId
	AND a.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 1
	
	DECLARE @updateColumn NVARCHAR(20)
		SELECT @updateColumn = ColumnName FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@runPeriod) 
			WHERE SourceColumn = '实际值'
			
	--创建临时表
	CREATE TABLE #TMP_SALES
	(
		Dealer UNIQUEIDENTIFIER,
		PurchaseAmount Decimal(18,4) default 0
	)
	
	CREATE TABLE #TMP_SALES_TMP
	(
		Dealer UNIQUEIDENTIFIER,
		PurchaseAmount Decimal(18,4) default 0
	)
	
	CREATE TABLE #TMP_UPN
	(
		UPN NVARCHAR(100)
	)
	
	--******************更新实际值START(指定产品、非套装)*********************************************************
	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2)
	BEGIN
		--创建可能的约束表(产品)	
		IF @ProductPolicyFactorId IS NOT NULL
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@ProductPolicyFactorId)
		
		--取得指定产品的医院植入量
		IF @CalType = 'ByDealer' --如果当前政策是ByDealer，那么本因素应该会有关联的条件因素“医院”、“产品”
		BEGIN
			-- LP/T1
			SET @SQL = N'INSERT INTO #TMP_SALES(Dealer,PurchaseAmount) 
				SELECT b.DMA_ID,SUM(A.QTY) FROM interface.T_I_QV_BSCPurchase A inner join DealerMaster b on a.SAPID=b.DMA_SAP_Code  
				left join PurchaseOrderHeader c on a.PONumber=c.POH_OrderNo and c.POH_CreateType=''Manual''
				WHERE  c.POH_OrderType<>''PRO'' AND c.POH_OrderType<>''CRPO''  
				AND transactionDate >='''+@BeginDate+''' AND transactionDate < '''+@EndDate+''' 
				AND transactionDate >='''+@FactBeginDate+''' AND transactionDate < '''+@FactEndDate+''' 
				AND A.UPN IN (SELECT UPN FROM #TMP_UPN)
				GROUP BY b.DMA_ID'
				PRINT @SQL
				EXEC(@SQL)
			--T2	
			SET @SQL = N'INSERT INTO #TMP_SALES(Dealer,PurchaseAmount) 
				SELECT a.DealerID,SUM(A.QTY) FROM interface.T_I_QV_LPSales_Promotion A 
				WHERE  transactionDate >='''+@BeginDate+''' AND transactionDate < '''+@EndDate+''' 
				and transactionDate >='''+@FactBeginDate+''' AND transactionDate < '''+@FactEndDate+''' 
				AND A.UPN IN (SELECT UPN FROM #TMP_UPN)  
				AND a.ID NOT IN (SELECT ID FROM Promotion.V_I_QV_LPSales_PRO_CRPO)  
				GROUP BY a.DealerID'
				PRINT @SQL
				EXEC(@SQL)
		END
		
		--更新实际值 
		SET @SQL = N'UPDATE A SET '+@updateColumn+' = B.PurchaseAmount 
				FROM '+@TableName+' A,#TMP_SALES B 
				WHERE A.DealerId = B.Dealer '
		
		PRINT @SQL
		EXEC(@SQL)
	END
	--******************更新实际值END(指定产品、非套装)**********************************************
	
	
	--******************更新实际值START(套装)*********************************************************
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2)
	BEGIN
		DECLARE @BundleId INT --认为只有1个套装
		SELECT TOP 1 @BundleId = CONVERT(INT,REPLACE(ConditionValue,'|','')) FROM Promotion.PRO_POLICY_FACTOR_CONDITION 
		WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2
		
		DECLARE @HierType NVARCHAR(50)
		DECLARE @HierId NVARCHAR(MAX)
		DECLARE @Qty INT
		DECLARE @FIRSTTIME NVARCHAR(10)
		
		DELETE FROM #TMP_SALES
		
		SET @FIRSTTIME = 'Y'
		
		DECLARE @iCURSOR_Bundle CURSOR;
		SET @iCURSOR_Bundle = CURSOR FOR SELECT a.HierType,a.HierId,a.Qty FROM Promotion.Pro_Bundle_Setting_Detail a WHERE BundleId = @BundleId 
		OPEN @iCURSOR_Bundle 	
		FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM #TMP_UPN
			DELETE FROM #TMP_SALES_TMP
			
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_ConditionValue2UPN(@HierType,@HierId)
			
			-- LP/T1
			SET @SQL = N'INSERT INTO #TMP_SALES_TMP(Dealer,PurchaseAmount) 
				SELECT b.DMA_ID,FLOOR(CONVERT(DECIMAL(18,4),SUM(A.QTY))/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,@Qty)+')) 
				FROM interface.T_I_QV_BSCPurchase A inner join DealerMaster b on a.SAPID=b.DMA_SAP_Code  
				left join PurchaseOrderHeader c on a.PONumber=c.POH_OrderNo and c.POH_CreateType=''Manual''
				WHERE  c.POH_OrderType<>''PRO'' AND c.POH_OrderType<>''CRPO''  
				AND transactionDate >='''+@BeginDate+''' AND transactionDate < '''+@EndDate+''' 
				AND transactionDate >='''+@FactBeginDate+''' AND transactionDate < '''+@FactEndDate+''' 
				AND A.UPN IN (SELECT UPN FROM #TMP_UPN)
				GROUP BY b.DMA_ID'
				PRINT @SQL
				EXEC(@SQL)
			--T2	
			SET @SQL = N'INSERT INTO #TMP_SALES_TMP(Dealer,PurchaseAmount) 
				SELECT a.DealerID,FLOOR(CONVERT(DECIMAL(18,4),SUM(A.QTY))/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,@Qty)+')) 
				FROM interface.T_I_QV_LPSales_Promotion A 
				WHERE  transactionDate >='''+@BeginDate+''' AND transactionDate < '''+@EndDate+''' 
				and transactionDate >='''+@FactBeginDate+''' AND transactionDate < '''+@FactEndDate+''' 
				AND A.UPN IN (SELECT UPN FROM #TMP_UPN)  
				AND a.ID NOT IN (SELECT ID FROM Promotion.V_I_QV_LPSales_PRO_CRPO)  
				GROUP BY a.DealerID'
				PRINT @SQL
				EXEC(@SQL)
				
				IF @FIRSTTIME = 'Y'	--第一次时，只要不是零都放入
				BEGIN
					INSERT INTO #TMP_SALES(Dealer,PurchaseAmount)
					SELECT Dealer,PurchaseAmount FROM #TMP_SALES_TMP WHERE PurchaseAmount > 0 
				END
				ELSE	--更新小的数值，删除不存在的经销商
				BEGIN
					UPDATE A SET PurchaseAmount = B.PurchaseAmount
					FROM #TMP_SALES A,#TMP_SALES_TMP B WHERE A.Dealer = B.Dealer AND A.PurchaseAmount > B.PurchaseAmount
					
					DELETE A
					FROM #TMP_SALES A WHERE NOT EXISTS (SELECT 1 FROM #TMP_SALES_TMP WHERE Dealer = A.Dealer AND PurchaseAmount >0)
				END
				
				SET @FIRSTTIME = 'N'
				
			FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
		END	
		CLOSE @iCURSOR_Bundle
		DEALLOCATE @iCURSOR_Bundle
		
		--更新实际值
		SET @SQL = N'UPDATE A SET '+@updateColumn+' = B.PurchaseAmount 
				FROM '+@TableName+' A,#TMP_SALES B 
				WHERE A.DealerId = B.Dealer '
		
		PRINT @SQL
		EXEC(@SQL)
		
	END
	--******************更新实际值END(套装)*********************************************************
	
END

GO


