DROP PROCEDURE [Promotion].[Proc_Pro_Cal_PrdPurchaseAmount]
GO




/**********************************************
	���ܣ�����ָ����Ʒ����ҵ�ɹ���
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_PrdPurchaseAmount]
	@PolicyFactorId Int	--�������ر��
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @runPeriod NVARCHAR(20); --��ǰ������ڼ�
	DECLARE @TableName NVARCHAR(50); --��ǰ�����
	
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
		@Period = A.Period,					--����\�¶�
		@CurrentPeriod = A.CurrentPeriod,	--��ǰ�Ѽ����ڼ�
		@StartDate = A.StartDate,
		@OverDate=A.EndDate,
		@CalModule = A.CalModule,			--��ʽ\Ԥ��
		@CalType = A.CalType,				--ByDealer\ByHospital
		@ifCalPurchaseAR=A.ifCalPurchaseAR,
		@IsPrePrice=isnull(A.IsPrePrice,''),
		@PrePriceValue=A.PrePriceValue,
		@DeputeType=isnull(b.FactType,'')
	FROM Promotion.PRO_POLICY a,Promotion.PRO_POLICY_FACTOR b
	WHERE a.PolicyId = b.PolicyId AND b.PolicyFactorId = @PolicyFactorId
	
	SET @FactBeginDate=Promotion.func_Pro_Utility_getPeriod_StartDate(@StartDate)
	SET @FactEndDate=Promotion.func_Pro_Utility_getPeriod_EndDate(@OverDate)
	
	--�õ���ǰ����ı���
	IF @CalModule = '��ʽ'
		SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	ELSE
		SET @TableName = PROMOTION.func_Pro_Utility_getPolicyTableName(@PolicyId,'CAL')
	
	--�õ���ǰ������ڼ�
	IF ISNULL(@CurrentPeriod,'') = ''
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	ELSE
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)

	--�������ܵ�Լ����(��Ʒ)
	DECLARE @ProductPolicyFactorId INT
	
	SELECT @ProductPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION a,Promotion.PRO_POLICY_FACTOR B WHERE A.PolicyFactorId = @PolicyFactorId
	AND a.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 1
	
	DECLARE @BeginDate NVARCHAR(10)
	DECLARE @EndDate NVARCHAR(10)
	IF @CalModule = '��ʽ'
	BEGIN
		SET @BeginDate = Promotion.func_Pro_Utility_getPeriod_StartDate(@runPeriod)
		SET @EndDate = Promotion.func_Pro_Utility_getPeriod_EndDate(@runPeriod)
	END
	ELSE
	BEGIN
		--�����Ԥ�㣬��Ԥ����־����ȡ����ֹ����
		SELECT @BeginDate = STARTDATE,@EndDate = ENDDATE 
		FROM Promotion.Pro_Forecast_Log 
		WHERE STATUS = 'Running'
	END
	
	DECLARE @updateColumn NVARCHAR(20)
	SELECT @updateColumn = ColumnName FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@runPeriod) 
	
	--(�г����ԣ��캣�������ɹ�)	PRO_POLICY_FACTOR_CONDITION
	DECLARE @T1MT NVARCHAR(10)
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId=@PolicyFactorId AND ConditionId = 8) 
	BEGIN
		DECLARE @ConditionValue NVARCHAR(2000)
		DECLARE @OperTag NVARCHAR(50)
		SELECT @ConditionValue=ConditionValue,@OperTag=OperTag FROM Promotion.PRO_POLICY_FACTOR_CONDITION  WHERE PolicyFactorId=@PolicyFactorId AND ConditionId = 8
		IF (@ConditionValue='�캣' AND @OperTag='����') OR (@ConditionValue='����' AND @OperTag='������')
		BEGIN
			SET @T1MT='0';
		END
		IF (@ConditionValue='�캣' AND @OperTag='������') OR (@ConditionValue='����' AND @OperTag='����')
		BEGIN
			SET @T1MT='1';
		END
	END
	
	--������ʱ��
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
	
	--******************����ʵ��ֵSTART(ָ����Ʒ������װ)*******************************************************************
	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2)
	BEGIN
		IF @ProductPolicyFactorId IS NOT NULL
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@ProductPolicyFactorId)
		
		-- һ��/LP
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
		
		--����
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
	
	--******************����ʵ��ֵEND(ָ����Ʒ������װ)*******************************************************************
	
	
	--******************����ʵ��ֵSTART(��װ)*******************************************************************
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2)
	BEGIN
		DECLARE @BundleId INT --��Ϊֻ��1����װ
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
			
			-- һ��/LP
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
			
			--����
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
								 
				
			IF @FIRSTTIME = 'Y'	--��һ��ʱ��ֻҪ�����㶼����
			BEGIN
				INSERT INTO #TMP_SALES(Dealer,PurchaseAmount)
				SELECT Dealer,PurchaseAmount FROM #TMP_SALES_TMP WHERE PurchaseAmount > 0 
			END
			ELSE	--����С����ֵ��ɾ�������ڵľ�����
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
			
		--����ʵ��ֵ
		SET @SQL = N'UPDATE A SET '+@updateColumn+' = B.PurchaseAmount 
				FROM '+@TableName+' A,#TMP_SALES B 
				WHERE A.DealerId = B.Dealer '
		
		PRINT @SQL
		EXEC(@SQL)
	END
	--******************����ʵ��ֵEND(��װ)*******************************************************************
	
	
END

GO


