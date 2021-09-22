DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Forecast_Closing] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Forecast_Closing] 
	@PolicyId INT,
	@CREATETIME DATETIME
AS
BEGIN TRY
	DECLARE @Period NVARCHAR(10);
	DECLARE @StartDate NVARCHAR(10);
	DECLARE @CurrentPeriod NVARCHAR(10);
	DECLARE @BU NVARCHAR(20);
	DECLARE @SUBBU NVARCHAR(20);
	DECLARE @runPeriod NVARCHAR(10);
	DECLARE @CalModule NVARCHAR(10);
	DECLARE @ifConvert NVARCHAR(10);
	DECLARE @TMPTable NVARCHAR(50);
	DECLARE @PolicyStyle NVARCHAR(50);
	DECLARE @UseRangePolicyFactorId INT;
	
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @SUM_STRING NVARCHAR(MAX);
	DECLARE @MSG NVARCHAR(100);
	
	SELECT 
		@Period = Period,
		@StartDate = StartDate,
		@CurrentPeriod = CurrentPeriod, --此时的值其实是上个期间
		@CalModule = CalModule,
		@ifConvert = ifConvert,
		@BU = BU,
		@SUBBU = ISNULL(SUBBU,''),
		@PolicyStyle = PolicyStyle
	FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId
	
	SELECT @UseRangePolicyFactorId = UseRangePolicyFactorId 
	FROM Promotion.PRO_POLICY_LARGESS WHERE PolicyId = @PolicyId 
	
	--得到当前计算的期间
	IF ISNULL(@CurrentPeriod,'') = ''
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	END
	ELSE
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
	END
	
	--预算计算表
	IF @CalModule = '正式'
		SET @TMPTable = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	ELSE
		SET @TMPTable = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,'CAL')
		
--开始事务	
	BEGIN TRAN
	
	CREATE TABLE #TMP_Largess
	(
		ParentDealerId UNIQUEIDENTIFIER,
		DealerId UNIQUEIDENTIFIER,
		Largess DECIMAL(18,4)
	)
	
	CREATE TABLE #TMP_Largess_Parent
	(
		ParentDealerId UNIQUEIDENTIFIER,
		Largess DECIMAL(18,4),
		ValidDate Datetime
	)
	
	--政策中的赠品的产品范围设置
	DECLARE @GiftPolicyFactorId INT
			
	--UPN临时表
	CREATE TABLE #TMP_UPN
	(
		UPN NVARCHAR (50)
	)
	
	DECLARE @ICOUNT_UPN INT
	
	--现有赠品池BY到UPN/DEALERID
	CREATE TABLE #TMP_DLID_UPN
	(
		DLID INT,
		DEALERID UNIQUEIDENTIFIER,
		UPN NVARCHAR (50)
	)
		
	DECLARE @Dlid INT
	DECLARE @DEALERID UNIQUEIDENTIFIER
	DECLARE @INSERTDATE NVARCHAR(19)
	
	CREATE TABLE #TMP_FOUND_TMP
	(
		DLID INT,
		DEALERID UNIQUEIDENTIFIER
	)
	
	CREATE TABLE #TMP_FOUND
	(
		DLID INT,
		DEALERID UNIQUEIDENTIFIER
	)
			
			
	IF @PolicyStyle = '赠品'
	BEGIN
		--******************************累计到经销商可使用赠品表******************************************************************
		SET @SUM_STRING = 'SUM(FinalLargess' + @runPeriod + ')'
		
		SET @SQL = 'INSERT INTO #TMP_Largess(ParentDealerId,DealerId,Largess) SELECT B.DMA_Parent_DMA_ID ParentDealerId,A.DealerId,'
			+ @SUM_STRING +' Largess '
			+' FROM '+@TMPTable+' A,dbo.DealerMaster B WHERE A.DealerId = B.DMA_ID '
			+'GROUP BY B.DMA_Parent_DMA_ID,A.DealerId ' --HAVING '+@SUM_STRING+' <> 0'
		PRINT @SQL
		EXEC(@SQL)
		
		--合计到平台或一级的数额
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)
		SELECT ParentDealerId,SUM(Largess) Largess FROM #TMP_Largess WHERE ParentDealerId IS NOT NULL GROUP BY ParentDealerId
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)
		SELECT DealerId,SUM(Largess) Largess FROM #TMP_Largess WHERE ParentDealerId IS NULL GROUP BY DealerId
		
		SELECT @GiftPolicyFactorId = GiftPolicyFactorId
		FROM Promotion.PRO_POLICY_LARGESS a WHERE a.PolicyId = @PolicyId
		
		--是否是套装的赠品
		DECLARE @isBundle NVARCHAR(10)
		IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @GiftPolicyFactorId AND ConditionId = 2)
		BEGIN
			SET @isBundle = 'Y'
		END
		ELSE
		BEGIN
			SET @isBundle = 'N'
		END
		
		--******************非积分（产品，非套装）START*****************************************************************************
		IF @ifConvert = 'N' AND @isBundle = 'N' --普通产品类赠品
		BEGIN
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
			SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --当前政策的UPN总数
			
			INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) SELECT A.Dlid,A.DEALERID,B.UPN 
			FROM Promotion.PRO_FORECAST A,Promotion.PRO_FORECAST_UPN B
				WHERE GiftType = 'FreeGoods' AND CreateTime = @CREATETIME AND A.Dlid = B.Dlid
			
			--找到已存在的预算
			INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
			SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
			FROM #TMP_DLID_UPN A 
			LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.DEALERID = B.ParentDealerId AND A.UPN = B.UPN
			GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			
			--处理如果找到两个符合的赠品池，只能累加1个。
			INSERT INTO #TMP_FOUND(DLID,DEALERID)
			SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
			
			UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0)
			FROM Promotion.PRO_FORECAST A,#TMP_Largess_Parent B,#TMP_FOUND C
			WHERE A.DEALERID = B.ParentDealerId AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
					
			INSERT INTO Promotion.PRO_FORECAST(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,CreateTime,Remark1)
			SELECT ParentDealerId,'FreeGoods',@BU,@UseRangePolicyFactorId,Largess,@CREATETIME,@PolicyId
			FROM #TMP_Largess_Parent A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.ParentDealerId)
			
			INSERT INTO Promotion.PRO_FORECAST_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
			SELECT A.DLid,B.ConditionId,B.OperTag,B.ConditionValue 
			FROM Promotion.PRO_FORECAST A,Promotion.PRO_POLICY_FACTOR_CONDITION B,#TMP_Largess_Parent C
			WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
			AND A.DEALERID = C.ParentDealerId AND B.PolicyFactorId = @GiftPolicyFactorId
			AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
			
			INSERT INTO Promotion.PRO_FORECAST_UPN(DLid,UPN)
			SELECT A.DLid,D.UPN
			FROM Promotion.PRO_FORECAST A,#TMP_Largess_Parent C,#TMP_UPN D
			WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
			AND A.DEALERID = C.ParentDealerId 
			AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
						
			--1.汇总到经销商****************************************************************
			DELETE FROM #TMP_DLID_UPN
			DELETE FROM #TMP_FOUND_TMP
			DELETE FROM #TMP_FOUND
			
			INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) SELECT A.Dlid,DEALERID,B.UPN 
			FROM Promotion.PRO_FORECAST_DEALER A,Promotion.PRO_FORECAST_DEALER_UPN B
				WHERE GiftType = 'FreeGoods' AND CreateTime = @CREATETIME AND A.Dlid = B.Dlid
				
			--找到已存在的预算
			INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
			SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
			FROM #TMP_DLID_UPN A 
			LEFT JOIN (SELECT * FROM #TMP_Largess X,#TMP_UPN Y) B ON A.DEALERID = B.DEALERID AND A.UPN = B.UPN
			GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			
			--处理如果找到两个符合的赠品池，只能累加1个。
			INSERT INTO #TMP_FOUND(DLID,DEALERID)
			SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
			
			UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0)
			FROM Promotion.PRO_FORECAST_DEALER A,#TMP_Largess B,#TMP_FOUND C
			WHERE A.DEALERID = B.DEALERID AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
					
			INSERT INTO Promotion.PRO_FORECAST_DEALER(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,CreateTime,Remark1)
			SELECT DEALERID,'FreeGoods',@BU,@UseRangePolicyFactorId,Largess,@CREATETIME,@PolicyId
			FROM #TMP_Largess A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
			
			INSERT INTO Promotion.PRO_FORECAST_DEALER_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
			SELECT A.DLid,B.ConditionId,B.OperTag,B.ConditionValue 
			FROM Promotion.PRO_FORECAST_DEALER A,Promotion.PRO_POLICY_FACTOR_CONDITION B,#TMP_Largess C
			WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
			AND A.DEALERID = C.DEALERID AND B.PolicyFactorId = @GiftPolicyFactorId
			AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
			
			INSERT INTO Promotion.PRO_FORECAST_DEALER_UPN(DLid,UPN)
			SELECT A.DLid,D.UPN
			FROM Promotion.PRO_FORECAST_DEALER A,#TMP_Largess C,#TMP_UPN D
			WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
			AND A.DEALERID = C.DEALERID 
			AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
			
			--3.汇总到政策****************************************************************
			INSERT INTO Promotion.PRO_FORECAST_POLICY(PolicyId,LPID,DEALERID,GiftType,BU,SubBU,LargessAmount,CreateTime)
			SELECT @PolicyId,ParentDealerId,DealerId,'FreeGoods',@BU,@SUBBU,Largess,@CREATETIME FROM #TMP_Largess
			
			INSERT INTO Promotion.PRO_FORECAST_POLICY_DETAIL(PolicyId,ConditionId,OperTag,ConditionValue)
			SELECT @PolicyId,B.ConditionId,B.OperTag,B.ConditionValue FROM Promotion.PRO_POLICY_FACTOR_CONDITION B
			WHERE B.PolicyFactorId = @GiftPolicyFactorId
			AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_FORECAST_POLICY_DETAIL WHERE PolicyId = @PolicyId)
			
			DELETE FROM Promotion.PRO_FORECAST_POLICY_UPN WHERE POLICYID = @PolicyId
			
			INSERT INTO Promotion.PRO_FORECAST_POLICY_UPN(POLICYID,UPN) SELECT @PolicyId,UPN FROM #TMP_UPN
		END
		--******************非积分（产品，非套装）END***********************************************************************
		
		--******************非积分（套装）START*****************************************************************************
		IF @ifConvert = 'N' AND @isBundle = 'Y' --套装赠品
		BEGIN
			DECLARE @BundleId INT --认为只有1个套装
			SELECT TOP 1 @BundleId = CONVERT(INT,REPLACE(ConditionValue,'|','')) FROM Promotion.PRO_POLICY_FACTOR_CONDITION 
			WHERE PolicyFactorId = @GiftPolicyFactorId AND ConditionId = 2
			
			DECLARE @HierType NVARCHAR(50)
			DECLARE @HierId NVARCHAR(MAX)
			DECLARE @Qty INT
			DECLARE @IROWNUMBER INT --定位流水号
			SET @IROWNUMBER = 1
			
			DECLARE @iCURSOR_Bundle CURSOR;
			SET @iCURSOR_Bundle = CURSOR FOR SELECT a.HierType,a.HierId,a.Qty FROM Promotion.Pro_Bundle_Setting_Detail a WHERE BundleId = @BundleId 
			OPEN @iCURSOR_Bundle 	
			FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
			WHILE @@FETCH_STATUS = 0
			BEGIN
				DELETE FROM #TMP_UPN
				DELETE FROM #TMP_FOUND_TMP
				DELETE FROM #TMP_FOUND
				
				DELETE FROM #TMP_DLID_UPN
			
				INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) SELECT A.Dlid,A.DEALERID,B.UPN FROM Promotion.PRO_FORECAST A,Promotion.PRO_FORECAST_UPN B
					WHERE GiftType = 'FreeGoods' AND CreateTime = @CREATETIME AND A.Dlid = B.Dlid
				
				--套装下的某类产品拆分到UPN
				INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_ConditionValue2UPN(@HierType,@HierId)
				
				SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --当前套装下的某类产品的UPN总数
				
				--找到已存在的赠品池
				INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
				SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
				FROM #TMP_DLID_UPN A 
				LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.DEALERID = B.ParentDealerId AND A.UPN = B.UPN
				GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
				
				--处理如果找到两个符合的赠品池，只能累加1个。
				INSERT INTO #TMP_FOUND(DLID,DEALERID)
				SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
				
				--增加赠品池时，要乘以套装中该类产品的数量
				UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0) * @Qty
				FROM Promotion.PRO_FORECAST A,#TMP_Largess_Parent B,#TMP_FOUND C
				WHERE A.DEALERID = B.ParentDealerId AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
				
				--经销商此类产品首次进入赠品池
				INSERT INTO Promotion.PRO_FORECAST(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,CreateTime,Remark1)
				SELECT ParentDealerId,'FreeGoods',@BU,@UseRangePolicyFactorId,
					Largess * @Qty,	--要乘以套装中该类产品的数量
					@CREATETIME,@IROWNUMBER
				FROM #TMP_Largess_Parent A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.ParentDealerId)
				
				INSERT INTO Promotion.PRO_FORECAST_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
				SELECT A.DLid,CASE @HierType WHEN 'UPN' THEN 1 WHEN 'HIER' THEN 3 ELSE NULL END ConditionId,'包含' OperTag,@HierId ConditionValue 
				FROM Promotion.PRO_FORECAST A,#TMP_Largess_Parent C
				WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@IROWNUMBER)
				AND A.DEALERID = C.ParentDealerId 
				AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
							
				INSERT INTO Promotion.PRO_FORECAST_UPN(DLid,UPN)
				SELECT A.DLid,D.UPN
				FROM Promotion.PRO_FORECAST A,#TMP_Largess_Parent C,#TMP_UPN D
				WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@IROWNUMBER)
				AND A.DEALERID = C.ParentDealerId 
				AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
				
				DELETE FROM #TMP_DLID_UPN
				DELETE FROM #TMP_FOUND_TMP
				DELETE FROM #TMP_FOUND
				
				INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) SELECT A.Dlid,DEALERID,B.UPN FROM Promotion.PRO_FORECAST_DEALER A,Promotion.PRO_FORECAST_DEALER_UPN B
				WHERE GiftType = 'FreeGoods' AND CreateTime = @CREATETIME AND A.Dlid = B.Dlid
				
				--找到已存在的预算
				INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
				SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
				FROM #TMP_DLID_UPN A 
				LEFT JOIN (SELECT * FROM #TMP_Largess X,#TMP_UPN Y) B ON A.DEALERID = B.DEALERID AND A.UPN = B.UPN
				GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
				
				--处理如果找到两个符合的赠品池，只能累加1个。
				INSERT INTO #TMP_FOUND(DLID,DEALERID)
				SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
				
				--增加赠品池时，要乘以套装中该类产品的数量
				UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0) * @Qty
				FROM Promotion.PRO_FORECAST_DEALER A,#TMP_Largess B,#TMP_FOUND C
				WHERE A.DEALERID = B.DEALERID AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
				
				--经销商此类产品首次进入赠品池
				INSERT INTO Promotion.PRO_FORECAST_DEALER(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,CreateTime,Remark1)
				SELECT DealerId,'FreeGoods',@BU,@UseRangePolicyFactorId,
					Largess * @Qty,	--要乘以套装中该类产品的数量
					@CREATETIME,@IROWNUMBER
				FROM #TMP_Largess A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
				
				INSERT INTO Promotion.PRO_FORECAST_DEALER_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
				SELECT A.DLid,CASE @HierType WHEN 'UPN' THEN 1 WHEN 'HIER' THEN 3 ELSE NULL END ConditionId,'包含' OperTag,@HierId ConditionValue 
				FROM Promotion.PRO_FORECAST_DEALER A,#TMP_Largess C
				WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@IROWNUMBER)
				AND A.DEALERID = C.DEALERID 
				AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
							
				INSERT INTO Promotion.PRO_FORECAST_DEALER_UPN(DLid,UPN)
				SELECT A.DLid,D.UPN
				FROM Promotion.PRO_FORECAST_DEALER A,#TMP_Largess C,#TMP_UPN D
				WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@IROWNUMBER)
				AND A.DEALERID = C.DEALERID 
				AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
				
				SET @IROWNUMBER = @IROWNUMBER + 1
				FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
			END	
			CLOSE @iCURSOR_Bundle
			DEALLOCATE @iCURSOR_Bundle
			
			INSERT INTO Promotion.PRO_FORECAST_POLICY(PolicyId,LPID,DEALERID,GiftType,BU,SubBU,LargessAmount,CreateTime)
			SELECT @PolicyId,ParentDealerId,DealerId,'FreeGoods',@BU,@SUBBU,Largess,@CREATETIME FROM #TMP_Largess
			
			INSERT INTO Promotion.PRO_FORECAST_POLICY_DETAIL(PolicyId,ConditionId,OperTag,ConditionValue)
			SELECT @PolicyId,B.ConditionId,B.OperTag,B.ConditionValue FROM Promotion.PRO_POLICY_FACTOR_CONDITION B
			WHERE B.PolicyFactorId = @GiftPolicyFactorId
			AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_FORECAST_POLICY_DETAIL WHERE PolicyId = @PolicyId)
		END
		--******************非积分（套装）END*****************************************************************************
	END
	
	IF @PolicyStyle = '积分'
	BEGIN
		--******************************累计到经销商可使用赠品表******************************************************************
		SET @SUM_STRING = 'SUM(FinalPoints' + @runPeriod + ')'
		
		SET @SQL = 'INSERT INTO #TMP_Largess(ParentDealerId,DealerId,Largess) SELECT B.DMA_Parent_DMA_ID ParentDealerId,A.DealerId,'
			+ @SUM_STRING +' Largess '
			+' FROM '+@TMPTable+' A,dbo.DealerMaster B WHERE A.DealerId = B.DMA_ID '
			+'GROUP BY B.DMA_Parent_DMA_ID,A.DealerId ' --HAVING '+@SUM_STRING+' <> 0'
		PRINT @SQL
		EXEC(@SQL)
		
		--合计到平台或一级的数额
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)
		SELECT ParentDealerId,SUM(Largess) Largess FROM #TMP_Largess WHERE ParentDealerId IS NOT NULL GROUP BY ParentDealerId
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)
		SELECT DealerId,SUM(Largess) Largess FROM #TMP_Largess WHERE ParentDealerId IS NULL GROUP BY DealerId
		
		SELECT @GiftPolicyFactorId = UseRangePolicyFactorId
		FROM Promotion.PRO_POLICY_LARGESS a WHERE a.PolicyId = @PolicyId
				
		INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
		SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --当前政策的UPN总数
			
		INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) SELECT A.Dlid,A.DEALERID,B.UPN 
		FROM Promotion.PRO_FORECAST A,Promotion.PRO_FORECAST_UPN B
			WHERE GiftType = 'Points' AND CreateTime = @CREATETIME AND A.Dlid = B.Dlid
			
		--找到已存在的预算
		INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
		SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
		FROM #TMP_DLID_UPN A 
		LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.DEALERID = B.ParentDealerId AND A.UPN = B.UPN
		GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			
		--处理如果找到两个符合的赠品池，只能累加1个。
		INSERT INTO #TMP_FOUND(DLID,DEALERID)
		SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
			
		UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0)
		FROM Promotion.PRO_FORECAST A,#TMP_Largess_Parent B,#TMP_FOUND C
		WHERE A.DEALERID = B.ParentDealerId AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
					
		INSERT INTO Promotion.PRO_FORECAST(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,CreateTime,Remark1)
		SELECT ParentDealerId,'Points',@BU,@UseRangePolicyFactorId,Largess,@CREATETIME,@PolicyId
		FROM #TMP_Largess_Parent A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.ParentDealerId)
			
		INSERT INTO Promotion.PRO_FORECAST_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
		SELECT A.DLid,B.ConditionId,B.OperTag,B.ConditionValue 
		FROM Promotion.PRO_FORECAST A,Promotion.PRO_POLICY_FACTOR_CONDITION B,#TMP_Largess_Parent C
		WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		AND A.DEALERID = C.ParentDealerId AND B.PolicyFactorId = @GiftPolicyFactorId
		AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
			
		INSERT INTO Promotion.PRO_FORECAST_UPN(DLid,UPN)
		SELECT A.DLid,D.UPN
		FROM Promotion.PRO_FORECAST A,#TMP_Largess_Parent C,#TMP_UPN D
		WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		AND A.DEALERID = C.ParentDealerId 
		AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
						
		--1.汇总到经销商****************************************************************
		DELETE FROM #TMP_DLID_UPN
		DELETE FROM #TMP_FOUND_TMP
		DELETE FROM #TMP_FOUND
			
		INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) SELECT A.Dlid,DEALERID,B.UPN 
		FROM Promotion.PRO_FORECAST_DEALER A,Promotion.PRO_FORECAST_DEALER_UPN B
			WHERE GiftType = 'Points' AND CreateTime = @CREATETIME AND A.Dlid = B.Dlid
				
		--找到已存在的预算
		INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
		SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
		FROM #TMP_DLID_UPN A 
		LEFT JOIN (SELECT * FROM #TMP_Largess X,#TMP_UPN Y) B ON A.DEALERID = B.DEALERID AND A.UPN = B.UPN
		GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
		
		--处理如果找到两个符合的赠品池，只能累加1个。
		INSERT INTO #TMP_FOUND(DLID,DEALERID)
		SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
			
		UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0)
		FROM Promotion.PRO_FORECAST_DEALER A,#TMP_Largess B,#TMP_FOUND C
		WHERE A.DEALERID = B.DEALERID AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
					
		INSERT INTO Promotion.PRO_FORECAST_DEALER(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,CreateTime,Remark1)
		SELECT DEALERID,'Points',@BU,@UseRangePolicyFactorId,Largess,@CREATETIME,@PolicyId
		FROM #TMP_Largess A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
		
		INSERT INTO Promotion.PRO_FORECAST_DEALER_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
		SELECT A.DLid,B.ConditionId,B.OperTag,B.ConditionValue 
		FROM Promotion.PRO_FORECAST_DEALER A,Promotion.PRO_POLICY_FACTOR_CONDITION B,#TMP_Largess C
		WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		AND A.DEALERID = C.DEALERID AND B.PolicyFactorId = @GiftPolicyFactorId
		AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
			
		INSERT INTO Promotion.PRO_FORECAST_DEALER_UPN(DLid,UPN)
		SELECT A.DLid,D.UPN
		FROM Promotion.PRO_FORECAST_DEALER A,#TMP_Largess C,#TMP_UPN D
		WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = CONVERT(NVARCHAR(19),@CREATETIME,121) AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		AND A.DEALERID = C.DEALERID 
		AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
			
		--3.汇总到政策****************************************************************
		INSERT INTO Promotion.PRO_FORECAST_POLICY(PolicyId,LPID,DEALERID,GiftType,BU,SubBU,LargessAmount,CreateTime)
		SELECT @PolicyId,ParentDealerId,DealerId,'Points',@BU,@SUBBU,Largess,@CREATETIME FROM #TMP_Largess
		
		INSERT INTO Promotion.PRO_FORECAST_POLICY_DETAIL(PolicyId,ConditionId,OperTag,ConditionValue)
		SELECT @PolicyId,B.ConditionId,B.OperTag,B.ConditionValue FROM Promotion.PRO_POLICY_FACTOR_CONDITION B
		WHERE B.PolicyFactorId = @GiftPolicyFactorId
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_FORECAST_POLICY_DETAIL WHERE PolicyId = @PolicyId)
		
		DELETE FROM Promotion.PRO_FORECAST_POLICY_UPN WHERE POLICYID = @PolicyId
		
		INSERT INTO Promotion.PRO_FORECAST_POLICY_UPN(POLICYID,UPN) SELECT @PolicyId,UPN FROM #TMP_UPN 
	END
	
	
	SET @MSG = '【'+@runPeriod+'】预算计算已成功！'
	INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
	SELECT @PolicyId,'预算','成功',@runPeriod,GETDATE(),GETDATE(),@MSG
	
	PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Forecast Success!' 
	
	COMMIT TRAN
END TRY
BEGIN CATCH
	DECLARE @error_number INT
    DECLARE @error_serverity INT
    DECLARE @error_state INT
    DECLARE @error_message NVARCHAR(256)
    DECLARE @error_line INT
    DECLARE @error_procedure NVARCHAR(256)
    DECLARE @vError NVARCHAR(1000)
    
    ROLLBACK TRAN
    
    SET @error_number = ERROR_NUMBER()
    SET @error_serverity = ERROR_SEVERITY()
    SET @error_state = ERROR_STATE()
    SET @error_message = ERROR_MESSAGE()
    SET @error_line = ERROR_LINE()
    SET @error_procedure = ERROR_PROCEDURE()
    SET @vError = ISNULL(@error_procedure, '') + '第'
        + CONVERT(NVARCHAR(10), ISNULL(@error_line, '')) + '行出错[错误号：'
        + CONVERT(NVARCHAR(10), ISNULL(@error_number, '')) + ']，'
        + ISNULL(@error_message, '')
    
    PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Forecast Failed!' 
    
    INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,'预算','失败',@runPeriod,GETDATE(),GETDATE(),@vError
        
END CATCH

GO


