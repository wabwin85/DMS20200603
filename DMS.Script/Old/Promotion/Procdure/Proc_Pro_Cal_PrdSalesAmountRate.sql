DROP PROCEDURE [Promotion].[Proc_Pro_Cal_PrdSalesAmountRate]
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_PrdSalesAmountRate]
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
	
	DECLARE @ColumnName NVARCHAR(100);
	DECLARE @SourceColumn NVARCHAR(100);
	
	DECLARE @FactBeginDate NVARCHAR(10)
	DECLARE @FactEndDate NVARCHAR(10)
	
	PRINT 'Proc_Pro_Cal_PrdSalesAmountRate'
	SELECT
		@FactId = B.FactId,
		@PolicyId = A.PolicyId,
		@Period = A.Period,					--����\�¶�
		@CurrentPeriod = A.CurrentPeriod,	--��ǰ�Ѽ����ڼ�
		@StartDate = A.StartDate,
		@OverDate=A.EndDate,
		@CalModule = A.CalModule,			--��ʽ\Ԥ��
		@CalType = A.CalType				--ByDealer\ByHospital
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

	--******************����5��Ŀ��ֵSTART*******************************************************************	
	SET @SQL = ''	
	--ѭ����ǰ�����漰�ֶ�
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT ColumnName,SourceColumn FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@runPeriod) 
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @ColumnName,@SourceColumn
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = 'UPDATE A SET '+@ColumnName+'=B.TargetValue FROM '+@TableName+' A,'
			+'(SELECT TargetLevel,DealerId,'+CASE @CalType WHEN 'ByDealer' THEN '' ELSE 'HospitalId,' END+'SUM(TargetValue) TargetValue'
			+' FROM Promotion.Pro_Hospital_PrdSalesTaget '
			+'WHERE PolicyFactorId = '+CONVERT(NVARCHAR,@PolicyFactorId)+' AND Period ='''+@runPeriod+''' '
			+'GROUP BY TargetLevel,DealerId'+CASE @CalType WHEN 'ByDealer' THEN '' ELSE ',HospitalId' END+') B '
			+'WHERE A.DealerId = b.DealerId '
			+CASE @CalType WHEN 'ByDealer' THEN '' ELSE ' AND A.HospitalId = B.HospitalId' END
			+' AND B.TargetLevel = '''+@SourceColumn+''''
		
		PRINT @SQL
		EXEC(@SQL)
		FETCH NEXT FROM @iCURSOR INTO @ColumnName,@SourceColumn
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	
	--******************����5��Ŀ��ֵEND*******************************************************************
	
	
	--�������ܵ�Լ����(ҽԺ)
	CREATE TABLE #TMP_HOSPITAL
	(
		OperTag NVARCHAR(10),
		HospitalId NVARCHAR (50)
	)
	
	DECLARE @HospitalPolicyFactorId INT
	
	SELECT @HospitalPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION a,Promotion.PRO_POLICY_FACTOR B WHERE A.PolicyFactorId = @PolicyFactorId
	AND a.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 2
	 
	IF @HospitalPolicyFactorId IS NOT NULL
		INSERT INTO #TMP_HOSPITAL(OperTag,HospitalId)
		SELECT OperTag,HospitalId FROM Promotion.func_Pro_CalFactor_Hospital(@HospitalPolicyFactorId)
		
	DECLARE @iCOUNT_INCLUDE_HOSPITAL INT;
	DECLARE @iCOUNT_EXCLUDE_HOSPITAL INT;
	SELECT @iCOUNT_INCLUDE_HOSPITAL = COUNT(*) FROM #TMP_HOSPITAL WHERE OperTag = 'INCLUDE'
	SELECT @iCOUNT_EXCLUDE_HOSPITAL = COUNT(*) FROM #TMP_HOSPITAL WHERE OperTag = 'EXCLUDE'	
	 
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
		WHERE SourceColumn = 'ʵ��ֵ'
			
	--������ʱ��
	CREATE TABLE #TMP_SALES
	(
		Dealer UNIQUEIDENTIFIER,
		HospitalId NVARCHAR(50),
		SalesAmount Decimal(18,4) default 0
	)
	
	CREATE TABLE #TMP_SALES_TMP
	(
		Dealer UNIQUEIDENTIFIER,
		HospitalId NVARCHAR(50),
		SalesAmount Decimal(18,4) default 0
	)
	
	CREATE TABLE #TMP_UPN
	(
		UPN NVARCHAR(100)
	)
	--******************����ʵ��ֵSTART(ָ����Ʒ������װ)*******************************************************************
	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2)
	BEGIN
		--�������ܵ�Լ����(��Ʒ)
		IF @ProductPolicyFactorId IS NOT NULL
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@ProductPolicyFactorId)
	
		--ȡ��ָ����Ʒ��ҽԺֲ����
		IF @CalType = 'ByDealer' --�����ǰ������ByDealer����ô������Ӧ�û��й������������ء�ҽԺ��������Ʒ��
		BEGIN
			SET @SQL = N'INSERT INTO #TMP_SALES(Dealer,SalesAmount) 
				SELECT B.DMA_ID,SUM(A.PurchaseAmount) FROM interface.RV_HospSalesQty A,DealerMaster B
				WHERE A.SAPID = B.DMA_SAP_CODE AND TransactionDate >='''+@BeginDate+''' AND TransactionDate < '''+@EndDate+'''  AND TransactionDate >='''+@FactBeginDate+''' AND TransactionDate < '''+@FactEndDate+''' '
				+CASE WHEN @iCOUNT_INCLUDE_HOSPITAL > 0 THEN ' AND A.DMScode IN (SELECT HospitalId FROM #TMP_HOSPITAL WHERE OperTag = ''INCLUDE'')' ELSE '' END
				+CASE WHEN @iCOUNT_EXCLUDE_HOSPITAL > 0 THEN ' AND A.DMScode NOT IN (SELECT HospitalId FROM #TMP_HOSPITAL WHERE OperTag = ''EXCLUDE'')' ELSE '' END
				+' AND A.UPN IN (SELECT UPN FROM #TMP_UPN) GROUP BY B.DMA_ID'
				PRINT @SQL
				EXEC(@SQL)
		END
		ELSE	--�����ǰ������ByHospital����ôֱ�Ӱ��ռ�����е�ҽԺ���и���ʵ��ֵ��Ӧ���С���Ʒ������
		BEGIN 
			SET @SQL = N'INSERT INTO #TMP_SALES(Dealer,HospitalId,SalesAmount) 
				SELECT B.DMA_ID,DMScode,SUM(A.PurchaseAmount) PurchaseAmount FROM interface.RV_HospSalesQty A,DealerMaster B
				WHERE A.SAPID = B.DMA_SAP_CODE AND TransactionDate >='''+@BeginDate+''' AND TransactionDate < '''+@EndDate+''' 
				AND TransactionDate >='''+@FactBeginDate+''' AND TransactionDate < '''+@FactEndDate+''' 
				AND A.DMScode IN (SELECT HospitalId FROM '+@TableName+')
				AND A.UPN IN (SELECT UPN FROM #TMP_UPN)
				GROUP BY B.DMA_ID,A.DMScode'
				PRINT @SQL
				EXEC(@SQL)
		END
		 
		SET @SQL = N'UPDATE A SET '+@updateColumn+' = B.SalesAmount 
				FROM '+@TableName+' A,#TMP_SALES B 
				WHERE A.DealerId = B.Dealer '+ CASE @CalType WHEN 'ByDealer' THEN '' ELSE ' AND A.HospitalId = B.HospitalId' END
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	--******************����ʵ��ֵEND(ָ����Ʒ������װ)*******************************************************************
	
	--******************����ʵ��ֵSTART(��װ)*********************************************************
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
			
			--ȡ��ָ����Ʒ��ҽԺֲ����
			IF @CalType = 'ByDealer' --�����ǰ������ByDealer����ô������Ӧ�û��й������������ء�ҽԺ��������Ʒ��
			BEGIN
				SET @SQL = N'INSERT INTO #TMP_SALES_TMP(Dealer,SalesAmount) 
					SELECT B.DMA_ID,SUM(A.PurchaseAmount)    
					FROM interface.RV_HospSalesQty A ,DealerMaster B
					WHERE A.SAPID = B.DMA_SAP_CODE AND  TransactionDate >='''+@BeginDate+''' AND TransactionDate < '''+@EndDate+'''  AND TransactionDate >='''+@FactBeginDate+''' AND TransactionDate < '''+@FactEndDate+''' '
					+CASE WHEN @iCOUNT_INCLUDE_HOSPITAL > 0 THEN ' AND A.DMScode IN (SELECT HospitalId FROM #TMP_HOSPITAL WHERE OperTag = ''INCLUDE'')' ELSE '' END
					+CASE WHEN @iCOUNT_EXCLUDE_HOSPITAL > 0 THEN ' AND A.DMScode NOT IN (SELECT HospitalId FROM #TMP_HOSPITAL WHERE OperTag = ''EXCLUDE'')' ELSE '' END
					+' AND A.UPN IN (SELECT UPN FROM #TMP_UPN) GROUP BY B.DMA_ID'
					PRINT @SQL
					EXEC(@SQL)
			END
			ELSE	--�����ǰ������ByHospital����ôֱ�Ӱ��ռ�����е�ҽԺ���и���ʵ��ֵ��Ӧ���С���Ʒ������
			BEGIN 
				SET @SQL = N'INSERT INTO #TMP_SALES_TMP(Dealer,HospitalId,SalesAmount) 
					SELECT  B.DMA_ID,DMScode,SUM(A.PurchaseAmount)  
					FROM interface.RV_HospSalesQty A,DealerMaster B
					WHERE A.SAPID = B.DMA_SAP_CODE AND TransactionDate >='''+@BeginDate+''' AND TransactionDate < '''+@EndDate+''' 
					AND TransactionDate >='''+@FactBeginDate+''' AND TransactionDate < '''+@FactEndDate+''' 
					AND A.DMScode IN (SELECT HospitalId FROM '+@TableName+')
					AND A.UPN IN (SELECT UPN FROM #TMP_UPN)
					GROUP BY B.DMA_ID,A.DMScode'
					PRINT @SQL
					EXEC(@SQL)
			END
			
			IF @FIRSTTIME = 'Y'	--��һ��ʱ��ֻҪ�����㶼����
			BEGIN
				IF @CalType = 'ByDealer'
				BEGIN
					INSERT INTO #TMP_SALES(Dealer,SalesAmount)
					SELECT Dealer,SalesAmount FROM #TMP_SALES_TMP WHERE SalesAmount > 0 
				END
				ELSE
				BEGIN
					INSERT INTO #TMP_SALES(Dealer,HospitalId,SalesAmount)
					SELECT Dealer,HospitalId,SalesAmount FROM #TMP_SALES_TMP WHERE SalesAmount > 0 
				END
			END
			ELSE	--����С����ֵ��ɾ�������ڵľ�����
			BEGIN
				IF @CalType = 'ByDealer'
				BEGIN
					UPDATE A SET SalesAmount = B.SalesAmount
					FROM #TMP_SALES A,#TMP_SALES_TMP B WHERE A.Dealer = B.Dealer AND A.SalesAmount > B.SalesAmount
					
					DELETE A
					FROM #TMP_SALES A WHERE NOT EXISTS (SELECT 1 FROM #TMP_SALES_TMP WHERE Dealer = A.Dealer AND SalesAmount >0)
				END
				ELSE
				BEGIN
					UPDATE A SET SalesAmount = B.SalesAmount
					FROM #TMP_SALES A,#TMP_SALES_TMP B WHERE A.Dealer = B.Dealer AND A.HospitalId = B.HospitalId AND A.SalesAmount > B.SalesAmount
					
					DELETE A
					FROM #TMP_SALES A WHERE NOT EXISTS (SELECT 1 FROM #TMP_SALES_TMP WHERE Dealer = A.Dealer AND A.HospitalId = B.HospitalId AND SalesAmount >0)
				END
			END
			
			SET @FIRSTTIME = 'N'
				
			FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
		END	
		CLOSE @iCURSOR_Bundle
		DEALLOCATE @iCURSOR_Bundle
		
		--����ʵ��ֵ
		SET @SQL = N'UPDATE A SET '+@updateColumn+' = B.SalesAmount 
				FROM '+@TableName+' A,#TMP_SALES B 
				WHERE A.DealerId = B.Dealer '+ CASE @CalType WHEN 'ByDealer' THEN '' ELSE ' AND A.HospitalId = B.HospitalId' END
		
		PRINT @SQL
		EXEC(@SQL)
		
	END
	--******************����ʵ��ֵEND(��װ)*********************************************************
	
END

GO


