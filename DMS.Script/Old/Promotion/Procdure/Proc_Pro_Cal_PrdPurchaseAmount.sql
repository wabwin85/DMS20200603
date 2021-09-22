DROP PROCEDURE [Promotion].[Proc_Pro_Cal_PrdPurchaseAmount]
GO




/**********************************************
	功能：计算指定产品的商业采购量
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_PrdPurchaseAmount]
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
	DECLARE @ifCalPurchaseAR NVARCHAR(5);
	
	DECLARE @IsPrePrice NVARCHAR(5);
	DECLARE @PrePriceValue DECIMAL(10,4);
	DECLARE @DeputeType NVARCHAR(50);
	
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
		@CalType = A.CalType,				--ByDealer\ByHospital
		@ifCalPurchaseAR=A.ifCalPurchaseAR,
		@IsPrePrice=isnull(A.IsPrePrice,''),
		@PrePriceValue=A.PrePriceValue,
		@DeputeType=isnull(b.FactType,'')
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

	--创建可能的约束表(产品)
	DECLARE @ProductPolicyFactorId INT
	
	SELECT @ProductPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION a,Promotion.PRO_POLICY_FACTOR B WHERE A.PolicyFactorId = @PolicyFactorId
	AND a.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 1
	
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
	
	DECLARE @updateColumn NVARCHAR(20)
	SELECT @updateColumn = ColumnName FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@runPeriod) 
	
	--(市场属性，红海、蓝海采购)	PRO_POLICY_FACTOR_CONDITION
	DECLARE @T1MT NVARCHAR(10)
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId=@PolicyFactorId AND ConditionId = 8) 
	BEGIN
		DECLARE @ConditionValue NVARCHAR(2000)
		DECLARE @OperTag NVARCHAR(50)
		SELECT @ConditionValue=ConditionValue,@OperTag=OperTag FROM Promotion.PRO_POLICY_FACTOR_CONDITION  WHERE PolicyFactorId=@PolicyFactorId AND ConditionId = 8
		IF (@ConditionValue='红海' AND @OperTag='包含') OR (@ConditionValue='蓝海' AND @OperTag='不包含')
		BEGIN
			SET @T1MT='0';
		END
		IF (@ConditionValue='红海' AND @OperTag='不包含') OR (@ConditionValue='蓝海' AND @OperTag='包含')
		BEGIN
			SET @T1MT='1';
		END
	END
	
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
	
	--******************更新实际值START(指定产品、非套装)*******************************************************************
	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2)
	BEGIN
		IF @ProductPolicyFactorId IS NOT NULL
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@ProductPolicyFactorId)
		
		-- 一级/LP
		SET @SQL = N'INSERT INTO #TMP_SALES(Dealer,PurchaseAmount) 
			SELECT b.DMA_ID, 
			CASE WHEN '''+@IsPrePrice+'''=''Y'' THEN (SUM(A.SellingAmount)/(ISNULL('+ isnull(CONVERT(Nvarchar(50), @PrePriceValue),'null')+',1))) ELSE  SUM(A.SellingAmount) END
			FROM INTERFACE.T_I_QV_BSCPurchase a INNER JOIN DealerMaster b ON a.SAPID=b.DMA_SAP_Code 
			left join PurchaseOrderHeader c on a.PONumber=c.POH_OrderNo and c.POH_CreateType=''Manual''
			WHERE c.POH_OrderType<>''PRO'' AND c.POH_OrderType<>''CRPO''  AND a.transactionDate >='''+@BeginDate+''' AND a.transactionDate < '''+@EndDate+'''  AND a.transactionDate >='''+@FactBeginDate+''' AND a.transactionDate < '''+@FactEndDate+''''
			+' AND a.UPN IN (SELECT UPN FROM #TMP_UPN) '
		
		IF ISNULL(@T1MT,'')<>''
		BEGIN
			SET @SQL=@SQL+ ' AND a.MarketType='''+@T1MT+'''  GROUP BY DMA_ID'
		END
		ELSE
		BEGIN
			SET @SQL=@SQL+ ' GROUP BY DMA_ID'
		END
		PRINT @SQL
		EXEC(@SQL)
		
		--二级
	 	SET @SQL = N'INSERT INTO #TMP_SALES(Dealer,PurchaseAmount) 
		SELECT a.DealerID, 
		CASE WHEN '''+@IsPrePrice+'''=''Y'' THEN (SUM(A.SellingAmount)/(ISNULL('+ isnull(CONVERT(Nvarchar(50), @PrePriceValue),'null')+',1))) ELSE  SUM(A.SellingAmount) END 
		FROM interface.T_I_QV_LPSales_Promotion a
		WHERE  a.TransactionDate >='''+@BeginDate+''' AND a.TransactionDate < '''+@EndDate+''' And a.TransactionDate >='''+@FactBeginDate+''' AND a.TransactionDate < '''+@FactEndDate+''' '
		+' AND a.UPN IN (SELECT UPN FROM #TMP_UPN) '
		+' AND a.ID NOT IN (SELECT ID FROM Promotion.V_I_QV_LPSales_PRO_CRPO) '
		
		IF ISNULL(@T1MT,'')<>''
		BEGIN
			SET @SQL=@SQL+ ' AND a.MarketType='''+@T1MT+'''  GROUP BY DealerID'
		END
		ELSE
		BEGIN
			SET @SQL=@SQL+ ' GROUP BY DealerID'
		END
		
		PRINT @SQL
		EXEC(@SQL)
			
		SET @SQL = N'UPDATE A SET '+@updateColumn+' = B.PurchaseAmount 
				FROM '+@TableName+' A,#TMP_SALES B 
				WHERE A.DealerId = B.Dealer '
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	--******************更新实际值END(指定产品、非套装)*******************************************************************
	
	
	--******************更新实际值START(套装)*******************************************************************
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
			
			-- 一级/LP
			SET @SQL = N'INSERT INTO #TMP_SALES_TMP(Dealer,PurchaseAmount) 
				SELECT b.DMA_ID, 
				CASE WHEN '''+@IsPrePrice+'''=''Y'' THEN (SUM(A.SellingAmount)/(ISNULL('+ isnull(CONVERT(Nvarchar(50), @PrePriceValue),'null')+',1))) ELSE SUM(A.SellingAmount) END
				
				FROM INTERFACE.T_I_QV_BSCPurchase a INNER JOIN DealerMaster b ON a.SAPID=b.DMA_SAP_Code 
				left join PurchaseOrderHeader c on a.PONumber=c.POH_OrderNo and c.POH_CreateType=''Manual''
				WHERE c.POH_OrderType<>''PRO'' AND c.POH_OrderType<>''CRPO''  AND a.transactionDate >='''+@BeginDate+''' AND a.transactionDate < '''+@EndDate+'''  AND a.transactionDate >='''+@FactBeginDate+''' AND a.transactionDate < '''+@FactEndDate+''''
				+' AND a.UPN IN (SELECT UPN FROM #TMP_UPN) '
			
			IF ISNULL(@T1MT,'')<>''
			BEGIN
				SET @SQL=@SQL+ ' AND a.MarketType='''+@T1MT+'''  GROUP BY DMA_ID'
			END
			ELSE
			BEGIN
				SET @SQL=@SQL+ ' GROUP BY DMA_ID'
			END
			PRINT @SQL
			EXEC(@SQL)
			
			--二级
		 	SET @SQL = N'INSERT INTO #TMP_SALES_TMP(Dealer,PurchaseAmount) 
			SELECT a.DealerID, 
			CASE WHEN '''+@IsPrePrice+'''=''Y'' THEN (SUM(A.SellingAmount)/(ISNULL('+ isnull(CONVERT(Nvarchar(50), @PrePriceValue),'null')+',1))) ELSE  SUM(A.SellingAmount) END
			FROM interface.T_I_QV_LPSales_Promotion a
			WHERE  a.TransactionDate >='''+@BeginDate+''' AND a.TransactionDate < '''+@EndDate+''' And a.TransactionDate >='''+@FactBeginDate+''' AND a.TransactionDate < '''+@FactEndDate+''' '
			+' AND a.UPN IN (SELECT UPN FROM #TMP_UPN) '
			+' AND a.ID NOT IN (SELECT ID FROM Promotion.V_I_QV_LPSales_PRO_CRPO) '
			
			IF ISNULL(@T1MT,'')<>''
			BEGIN
				SET @SQL=@SQL+ ' AND a.MarketType='''+@T1MT+'''  GROUP BY DealerID'
			END
			ELSE
			BEGIN
				SET @SQL=@SQL+ ' GROUP BY DealerID'
			END
			
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
	--******************更新实际值END(套装)*******************************************************************
	
	
END

GO


