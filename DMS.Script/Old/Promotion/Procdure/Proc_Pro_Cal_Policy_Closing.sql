DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Closing] 
GO


/**********************************************
	功能：单个促销政策关账
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
	2.修改 2015-12-01 增加了套装的逻辑
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Closing] 
	@PolicyId INT
AS
BEGIN TRY
	DECLARE @Period NVARCHAR(10);
	DECLARE @StartDate NVARCHAR(10);
	DECLARE @CurrentPeriod NVARCHAR(10);
	DECLARE @BU NVARCHAR(20);
	DECLARE @SUBBU NVARCHAR(20);
	DECLARE @runPeriod NVARCHAR(10);
	DECLARE @CalModule NVARCHAR(10);
	DECLARE @CalStatus NVARCHAR(10);
	DECLARE @ifConvert NVARCHAR(10);
	DECLARE @TMPTable NVARCHAR(50);
	DECLARE @PolicyStyle NVARCHAR(50);
	DECLARE @UseRangePolicyFactorId INT;
	DECLARE @ifCalRebateAR NVARCHAR(50);
	DECLARE @ValidDateColumn NVARCHAR(50);
	DECLARE @RatioColumn NVARCHAR(50);
	DECLARE @ValidDate2 DATETIME; --平台积分有效期，从政策表中单独取得
	DECLARE @PointUseRange NVARCHAR(50);	--平台积分使用范围：BU,PRODUCT
	DECLARE @BUUseRange NVARCHAR(200);	--平台到BU的积分使用范围
	
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @SUM_STRING NVARCHAR(MAX);
	DECLARE @MSG NVARCHAR(100);
	
	SELECT 
		@Period = Period,
		@StartDate = StartDate,
		@CurrentPeriod = CurrentPeriod, --此时的值其实是上个期间
		@CalModule = CalModule,
		@CalStatus = CalStatus,
		@ifConvert = ifConvert,
		@BU = BU,
		@SUBBU = ISNULL(SUBBU,''),
		@PolicyStyle = PolicyStyle,
		@ifCalRebateAR = CASE WHEN ifCalRebateAR='N' THEN 'Point' ELSE 'Money' END,
		@ValidDate2 = Promotion.func_Pro_Utility_getPointValidDate(Period,CalPeriod,PointValidDateType2,PointValidDateDuration2,PointValidDateAbsolute2),
		@PointUseRange = ISNULL(PointUseRange,'')
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
	
	--正式计算表
	SET @TMPTable = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	
	IF NOT (@CalModule = '正式' AND @CalStatus = '成功')
	BEGIN
		INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,'正式','关账失败',@runPeriod,GETDATE(),GETDATE(),'非[正式]+[成功]，无法关账!'
		PRINT 'PolicyId='+CONVERT(NVARCHAR,@PolicyId)+',非[正式]+[成功]，无法关账!'
		
		RETURN
	END
	
--开始事务	
	BEGIN TRAN
	--***********将政策表中的CurrentPeriod、CalStatus、更新；******************************************************************
	UPDATE Promotion.PRO_POLICY SET 
		CurrentPeriod = @runPeriod,
		CalStatus = '已关账',
		StartTime = GETDATE(),
		EndTime = GETDATE()
	WHERE PolicyId = @PolicyId
	
	--****************************************备份历史*************************************************************************
	EXEC Promotion.Proc_Pro_MoveData_MoveHis @PolicyId
	
	--******************************更新计算表中的累计赠品字段(也可能是积分)*************************************************
	SET @SQL = 'UPDATE '+@TMPTable+' SET LargessTotal = LargessTotal +' + 'FinalLargess' + @runPeriod +','
		+'PointsTotal = PointsTotal +' + 'FinalPoints' + @runPeriod 
	PRINT @SQL
	EXEC(@SQL)
	
	CREATE TABLE #TMP_Largess
	(
		ParentDealerId UNIQUEIDENTIFIER,
		DealerId UNIQUEIDENTIFIER,
		Largess DECIMAL(18,4),
		ValidDate Datetime,
		Ratio DECIMAL(18,4)
	)
	
	CREATE TABLE #TMP_Largess_Parent
	(
		ParentDealerId UNIQUEIDENTIFIER,
		Largess DECIMAL(18,4),
		ValidDate Datetime
	)
	
	--UPN临时表
	CREATE TABLE #TMP_UPN
	(
		UPN NVARCHAR (50)
	)
	
	--现有赠品池BY到UPN/DEALERID
	CREATE TABLE #TMP_DLID_UPN
	(
		DLID INT,
		DEALERID UNIQUEIDENTIFIER,
		UPN NVARCHAR (50)
	)
	
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
		
	DECLARE @GiftPolicyFactorId INT --政策中的赠品的产品范围设置	
	DECLARE @isBundle NVARCHAR(10) --是否是套装的赠品
	DECLARE @ICOUNT_UPN INT	
	DECLARE @Dlid INT
	DECLARE @DEALERID UNIQUEIDENTIFIER
	DECLARE @INSERTDATE NVARCHAR(19)
		
	IF @PolicyStyle = '赠品'
	BEGIN 
		--******************************累计到经销商可使用赠品表******************************************************************
		SET @SUM_STRING = 'SUM(FinalLargess' + @runPeriod + ')'
		
		SET @SQL = 'INSERT INTO #TMP_Largess(ParentDealerId,DealerId,Largess) SELECT B.DMA_Parent_DMA_ID ParentDealerId,A.DealerId,'
			+ @SUM_STRING +' Largess '
			+' FROM '+@TMPTable+' A,dbo.DealerMaster B WHERE A.DealerId = B.DMA_ID '
			+'GROUP BY B.DMA_Parent_DMA_ID,A.DealerId HAVING '+@SUM_STRING+' <> 0'
		PRINT @SQL
		EXEC(@SQL)
		
		--合计到平台或一级的数额
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)	--平台
		SELECT ParentDealerId,SUM(Largess) Largess 
		FROM #TMP_Largess A
		WHERE EXISTS (SELECT 1 FROM DealerMaster B WHERE A.DealerId = B.DMA_ID AND B.DMA_DealerType='T2')
		GROUP BY ParentDealerId
		
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)	--一级
		SELECT DealerId,SUM(Largess) Largess 
		FROM #TMP_Largess A
		WHERE NOT EXISTS (SELECT 1 FROM DealerMaster B WHERE A.DealerId = B.DMA_ID AND B.DMA_DealerType='T2')
		GROUP BY DealerId
				
		SELECT @GiftPolicyFactorId = GiftPolicyFactorId
		FROM Promotion.PRO_POLICY_LARGESS a WHERE a.PolicyId = @PolicyId
		
		IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @GiftPolicyFactorId AND ConditionId = 2)
		BEGIN
			SET @isBundle = 'Y'
		END
		ELSE
		BEGIN
			SET @isBundle = 'N'
		END
		
		--将现有赠品池展开到经销商ID、UPN
		/*
		DECLARE @iCURSOR1 CURSOR;
		SET @iCURSOR1 = CURSOR FOR SELECT Dlid,DEALERID FROM Promotion.PRO_DEALER_LARGESS WHERE GiftType = 'FreeGoods'
		OPEN @iCURSOR1 	
		FETCH NEXT FROM @iCURSOR1 INTO @Dlid,@DEALERID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) 
				SELECT @Dlid,@DEALERID,UPN FROM Promotion.func_Pro_Utility_getLargessUPN(@Dlid)
			FETCH NEXT FROM @iCURSOR1 INTO @Dlid,@DEALERID
		END	
		CLOSE @iCURSOR1
		DEALLOCATE @iCURSOR1
		*/
		
		--******************非积分（产品，非套装）START*****************************************************************************
		IF @ifConvert IN('N','CA') AND @isBundle = 'N' --普通产品类赠品
		BEGIN
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
			SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --当前政策的UPN总数
			
			--找到已存在的赠品池
			/* 
			--20161030 begin huakaichun 将累加赠品池修改成不累加
			INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
			SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
			FROM #TMP_DLID_UPN A 
			LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.DEALERID = B.ParentDealerId AND A.UPN = B.UPN
			GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			
			--end huakaichun 将累加赠品池修改成不累加
			*/
			--处理如果找到两个符合的赠品池，只能累加1个。
			INSERT INTO #TMP_FOUND(DLID,DEALERID)
			SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
			
			UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0),
				ModifyDate = GETDATE()
			FROM Promotion.PRO_DEALER_LARGESS A,#TMP_Largess_Parent B,#TMP_FOUND C
			WHERE A.DEALERID = B.ParentDealerId AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
			
			SELECT @INSERTDATE = CONVERT(NVARCHAR(19),GETDATE(),121)
			
			INSERT INTO Promotion.PRO_DEALER_LARGESS(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,
				OrderAmount,OtherAmount,CreateTime,ModifyDate)
			SELECT ParentDealerId,'FreeGoods',@BU,@UseRangePolicyFactorId,Largess,0,0,@INSERTDATE,@INSERTDATE
			FROM #TMP_Largess_Parent A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.ParentDealerId)
			
			INSERT INTO Promotion.PRO_DEALER_LARGESS_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
			SELECT A.DLid,B.ConditionId,B.OperTag,B.ConditionValue 
			FROM Promotion.PRO_DEALER_LARGESS A,Promotion.PRO_POLICY_FACTOR_CONDITION B,#TMP_Largess_Parent C
			WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE
			AND A.DEALERID = C.ParentDealerId AND B.PolicyFactorId = @GiftPolicyFactorId
			AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
			
			INSERT INTO promotion.PRO_DEALER_LARGESS_LOG 
				(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
			SELECT b.DLid,'政策奖励', @PolicyId,a.DealerId,@runPeriod,a.Largess,getdate()
			,[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.DealerId,@runPeriod)
			FROM #TMP_Largess A,promotion.PRO_DEALER_LARGESS B
			WHERE A.ParentDealerId = B.DEALERID AND isnull(B.UseRangePolicyFactorId,0) = isnull(@UseRangePolicyFactorId,0)
			AND CONVERT(NVARCHAR(19),B.CreateTime,121) = @INSERTDATE
			
			INSERT INTO promotion.PRO_DEALER_LARGESS_LOG 
				(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
			SELECT b.DLid,'政策奖励', @PolicyId,a.DealerId,@runPeriod,a.Largess,getdate(),[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.DealerId,@runPeriod)
			FROM #TMP_Largess A,#TMP_FOUND B
			WHERE A.ParentDealerId = B.DEALERID 
			
		END
		--******************非积分（产品，非套装）END*****************************************************************************
				
		--******************非积分（套装）START*****************************************************************************
		IF @ifConvert IN('N','CA') AND @isBundle = 'Y' --套装赠品
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
				
				--套装下的某类产品拆分到UPN
				INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_ConditionValue2UPN(@HierType,@HierId)
				
				--SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --当前套装下的某类产品的UPN总数
				
				--找到已存在的赠品池
				/* 
				--20161030 begin huakaichun 将累加赠品池修改成不累加
					
				INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
				SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
				FROM #TMP_DLID_UPN A 
				LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.DEALERID = B.ParentDealerId AND A.UPN = B.UPN
				GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			
				
				--处理如果找到两个符合的赠品池，只能累加1个。
				INSERT INTO #TMP_FOUND(DLID,DEALERID)
				SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
				
				--增加赠品池时，要乘以套装中该类产品的数量
				UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0) * @Qty,
					ModifyDate = GETDATE()
				FROM Promotion.PRO_DEALER_LARGESS A,#TMP_Largess_Parent B,#TMP_FOUND C
				WHERE A.DEALERID = B.ParentDealerId AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
				--end huakaichun 将累加赠品池修改成不累加
				*/
				SELECT @INSERTDATE = CONVERT(NVARCHAR(19),GETDATE(),121)
				
				--经销商此类产品首次进入赠品池
				INSERT INTO Promotion.PRO_DEALER_LARGESS(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,
				OrderAmount,OtherAmount,CreateTime,ModifyDate,Remark1)
				SELECT ParentDealerId,'FreeGoods',@BU,@UseRangePolicyFactorId,
					Largess * @Qty,	--要乘以套装中该类产品的数量
					0,0,@INSERTDATE,@INSERTDATE,@IROWNUMBER
				FROM #TMP_Largess_Parent A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.ParentDealerId)
				
				INSERT INTO Promotion.PRO_DEALER_LARGESS_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
				SELECT A.DLid,CASE @HierType WHEN 'UPN' THEN 1 WHEN 'HIER' THEN 3 ELSE NULL END ConditionId,'包含' OperTag,@HierId ConditionValue 
				FROM Promotion.PRO_DEALER_LARGESS A,#TMP_Largess_Parent C
				WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE AND A.Remark1 = CONVERT(NVARCHAR,@IROWNUMBER)
				AND A.DEALERID = C.ParentDealerId 
				AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
				
				--Amount要乘以套装中该类产品的数量
				INSERT INTO promotion.PRO_DEALER_LARGESS_LOG 
				(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
				SELECT b.DLid,'政策奖励', @PolicyId,a.DealerId,@runPeriod,a.Largess * @Qty,getdate(),[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.DealerId,@runPeriod)
				FROM #TMP_Largess A,promotion.PRO_DEALER_LARGESS B
				WHERE A.ParentDealerId = B.DEALERID AND ISNULL(B.UseRangePolicyFactorId,0) = ISNULL(@UseRangePolicyFactorId,0)
				AND CONVERT(NVARCHAR(19),B.CreateTime,121) = @INSERTDATE AND B.Remark1 = CONVERT(NVARCHAR,@IROWNUMBER)
				
				INSERT INTO promotion.PRO_DEALER_LARGESS_LOG 
				(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
				SELECT b.DLid,'政策奖励', @PolicyId,a.DealerId,@runPeriod,a.Largess * @Qty,getdate(),[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.DealerId,@runPeriod)
				FROM #TMP_Largess A,#TMP_FOUND B
				WHERE A.ParentDealerId = B.DEALERID 
				
				SET @IROWNUMBER = @IROWNUMBER + 1
				FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
			END	
			CLOSE @iCURSOR_Bundle
			DEALLOCATE @iCURSOR_Bundle
		END
		--******************非积分（套装）END*****************************************************************************
	END
	
	IF @PolicyStyle = '积分'
	BEGIN
		SET @SUM_STRING = 'SUM(FinalPoints' + @runPeriod + ')'
		SET  @ValidDateColumn = 'ValidDate'+@runPeriod	--计算表中的积分有效期字段，适用于一、二级经销商
		SET  @RatioColumn = 'Ratio'+@runPeriod	--计算表中的加价率
			
		SET @SQL = 'INSERT INTO #TMP_Largess(ParentDealerId,DealerId,ValidDate,Ratio,Largess) '
			+'SELECT B.DMA_Parent_DMA_ID ParentDealerId,A.DealerId,'+@ValidDateColumn+','+@RatioColumn+','
			+ @SUM_STRING +' Largess '
			+' FROM '+@TMPTable+' A,dbo.DealerMaster B WHERE A.DealerId = B.DMA_ID '
			+'GROUP BY B.DMA_Parent_DMA_ID,A.DealerId,'+@ValidDateColumn+','+@RatioColumn +' HAVING '+@SUM_STRING+' <> 0'
		PRINT @SQL
		EXEC(@SQL)
		
		--合计到平台
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,ValidDate,Largess)	--平台(除以加价率),并且使用政策表上单独设置的平台积分有效期设置
		SELECT ParentDealerId,
			@ValidDate2,
			Round(SUM(Largess/CASE ISNULL(Ratio,0) WHEN 0 THEN 1 ELSE Ratio END),0) Largess
		FROM #TMP_Largess A
		WHERE EXISTS (SELECT 1 FROM DealerMaster B WHERE A.DealerId = B.DMA_ID AND B.DMA_DealerType = 'T2')
		GROUP BY ParentDealerId,ValidDate
		
		--如果政策中设置平台的积分使用范围是产品，说明平台与一二级范围一致，则将平台数据放到#TMP_Largess一并处理
		IF @PointUseRange <>'BU'
		BEGIN
			INSERT INTO #TMP_Largess(DealerId,ValidDate,Largess)
			SELECT ParentDealerId,ValidDate,Largess FROM #TMP_Largess_Parent
		END
				
		--将现有积分池展开到经销商ID、UPN（相同积分类型Money或Point)
		/*
		DECLARE @iCURSOR201604 CURSOR;
		SET @iCURSOR201604 = CURSOR FOR SELECT Dlid,DEALERID FROM Promotion.PRO_DEALER_POINT WHERE PointType = @ifCalRebateAR
		OPEN @iCURSOR201604 	
		FETCH NEXT FROM @iCURSOR201604 INTO @Dlid,@DEALERID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) 
				SELECT @Dlid,@DEALERID,UPN FROM Promotion.func_Pro_Utility_getPointUPN(@Dlid)
			FETCH NEXT FROM @iCURSOR201604 INTO @Dlid,@DEALERID
		END	
		CLOSE @iCURSOR201604
		DEALLOCATE @iCURSOR201604
		*/
		
		--处理一二级经销商的积分(可能包含平台数据，如果平台积分使用范围与一二级一致的话）start**********************************
		--将当前政策拆分到UPN
		INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@UseRangePolicyFactorId)
		SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --当前政策的UPN总数
		
		--找到已存在的赠品池
		/* 
		--20161030 begin huakaichun 将累加赠品池修改成不累加
		INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
		SELECT A.DLID,A.DealerId,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
		FROM #TMP_DLID_UPN A 
		LEFT JOIN (SELECT * FROM #TMP_Largess X,#TMP_UPN Y) B ON A.DealerId = B.DealerId AND A.UPN = B.UPN
		GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
		--end huakaichun 将累加赠品池修改成不累加
		*/
		
		
		--处理如果找到两个符合的赠品池，只能累加1个。
		INSERT INTO #TMP_FOUND(DLID,DEALERID)
		SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
		
		SELECT @INSERTDATE = CONVERT(NVARCHAR(19),GETDATE(),121)
		
		--没有找到相同产品范围的经销商积分记录
		INSERT INTO Promotion.PRO_DEALER_POINT(DEALERID,PointType,BU,CreateTime,ModifyDate,Remark1)
		SELECT DISTINCT DealerId,CASE WHEN EXISTS(SELECT 1 FROM DealerMaster WHERE DMA_ID=DealerId AND DMA_DealerType='LP') THEN 'Point' ELSE @ifCalRebateAR END,@BU,@INSERTDATE,@INSERTDATE,@PolicyId
		FROM #TMP_Largess A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DealerId)
		
		--INSERT产品使用范围表
		INSERT INTO Promotion.PRO_DEALER_POINT_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
		SELECT DISTINCT A.DLid,B.ConditionId,B.OperTag,B.ConditionValue 
		FROM Promotion.PRO_DEALER_POINT A,Promotion.PRO_POLICY_FACTOR_CONDITION B,#TMP_Largess C
		WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		AND A.DEALERID = C.DEALERID AND B.PolicyFactorId = isnull(@UseRangePolicyFactorId,0)
		AND NOT EXISTS (SELECT * FROM Promotion.PRO_DEALER_POINT_DETAIL WHERE DLid = A.DLid)
		
		--将上述本次补的积分主表记录放入临时表
		INSERT INTO #TMP_FOUND(DLID,DEALERID)
		SELECT DLID,DEALERID FROM Promotion.PRO_DEALER_POINT A 
		WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		
		--找到相同的有效期记录并增加积分
		UPDATE D SET PointAmount = PointAmount + ISNULL(B.Largess,0),
			ModifyDate = GETDATE()
		FROM Promotion.PRO_DEALER_POINT A,#TMP_Largess B,#TMP_FOUND C,Promotion.PRO_DEALER_POINT_SUB D
		WHERE A.DEALERID = B.DEALERID AND A.DLID = D.DLID AND A.DLID = C.DLID 
		AND B.VALIDDATE = D.ValidDate 
		
		--相同产品范围的，但没有相同有效期的就新增。
		INSERT INTO Promotion.PRO_DEALER_POINT_SUB(DLid,ValidDate,PointAmount,OrderAmount,OtherAmount,
			CreateTime,ModifyDate,Status)
		SELECT B.DLID,A.VALIDDATE,A.Largess,0,0,
			GETDATE(),GETDATE(),1 FROM #TMP_Largess A,#TMP_FOUND B
		WHERE A.DEALERID = B.DEALERID 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_DEALER_POINT_SUB WHERE DLID = B.DLID AND VALIDDATE = A.VALIDDATE)
		
		INSERT INTO promotion.PRO_DEALER_POINT_LOG 
			(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
		SELECT b.DLid,'政策奖励', @PolicyId,a.DealerId,@runPeriod,a.Largess,getdate(),[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.DealerId,@runPeriod)
		FROM #TMP_Largess A,promotion.PRO_DEALER_POINT B,#TMP_FOUND C
		WHERE A.DEALERID = B.DEALERID AND B.DLID = C.DLID
		AND CONVERT(NVARCHAR(19),B.CreateTime,121) = @INSERTDATE AND B.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		
		--处理一二级经销商的积分(可能包含平台数据，如果平台积分使用范围与一二级一致的话）end**********************************
		
		--处理平台的积分（由于平台单独设置了使用范围，因此不会包含在上述一二级进积分池的逻辑中.START****************************
		IF @PointUseRange = 'BU'
		BEGIN
			DELETE FROM #TMP_UPN
			DELETE FROM #TMP_FOUND_TMP
			DELETE FROM #TMP_FOUND
			
			--将当前政策的BU拆分到UPN
			INSERT INTO #TMP_UPN(UPN) select distinct CFN_CustomerFaceNbr
			from CFN a inner join V_DivisionProductLineRelation b on a.CFN_ProductLine_BUM_ID=b.ProductLineID
			where b.IsEmerging='0' and b.DivisionName = @BU
			
			SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --当前政策的UPN总数
			
			--找到已存在的赠品池
			/* 
			--20161030 begin huakaichun 将累加赠品池修改成不累加
			INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
			SELECT A.DLID,A.DealerId,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
			FROM #TMP_DLID_UPN A 
			LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.ParentDealerId = B.DealerId AND A.UPN = B.UPN
			GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			--end huakaichun 将累加赠品池修改成不累加
			*/
			
			--处理如果找到两个符合的赠品池，只能累加1个。
			INSERT INTO #TMP_FOUND(DLID,DEALERID)
			SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
			
			SELECT @INSERTDATE = CONVERT(NVARCHAR(19),GETDATE(),121)
			
			--没有找到相同产品范围的经销商积分记录
			INSERT INTO Promotion.PRO_DEALER_POINT(DEALERID,PointType,BU,CreateTime,ModifyDate,Remark1)
			SELECT DISTINCT ParentDealerId,CASE WHEN EXISTS(SELECT 1 FROM DealerMaster WHERE DMA_ID=ParentDealerId AND DMA_DealerType='LP') THEN 'Point' ELSE @ifCalRebateAR END,@BU,@INSERTDATE,@INSERTDATE,@PolicyId
			FROM #TMP_Largess_Parent A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.ParentDealerId)
			
			--INSERT产品使用范围表
			SELECT @BUUseRange = 
				STUFF(REPLACE(REPLACE((
					SELECT HIER FROM (
						select distinct 'LEVEL1,'+a.CFN_Level1Code HIER
						from CFN a inner join V_DivisionProductLineRelation b on a.CFN_ProductLine_BUM_ID=b.ProductLineID
						where b.IsEmerging='0' and b.DivisionName = @BU) T
					FOR XML AUTO), '<T HIER="','|'), '"/>', ''), 1, 1, '')
		
			INSERT INTO Promotion.PRO_DEALER_POINT_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
			SELECT DISTINCT A.DLid,3,'包含',@BUUseRange
			FROM Promotion.PRO_DEALER_POINT A,#TMP_Largess_Parent C
			WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
			AND A.DEALERID = C.ParentDealerId 
			AND NOT EXISTS (SELECT * FROM Promotion.PRO_DEALER_POINT_DETAIL WHERE DLid = A.DLid)
			
			--将上述本次补的积分主表记录放入临时表
			INSERT INTO #TMP_FOUND(DLID,DEALERID)
			SELECT DLID,DEALERID FROM Promotion.PRO_DEALER_POINT A,#TMP_Largess_Parent B
			WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
			AND A.DEALERID = B.ParentDealerId
			AND NOT EXISTS (SELECT 1 FROM #TMP_FOUND WHERE DEALERID = B.ParentDealerId)
			
			--找到相同的有效期记录并增加积分
			UPDATE D SET PointAmount = PointAmount + ISNULL(B.Largess,0),
				ModifyDate = GETDATE()
			FROM Promotion.PRO_DEALER_POINT A,#TMP_Largess_Parent B,#TMP_FOUND C,Promotion.PRO_DEALER_POINT_SUB D
			WHERE A.DEALERID = B.ParentDealerId AND A.DLID = D.DLID AND A.DLID = C.DLID 
			AND B.VALIDDATE = D.ValidDate
			
			--相同产品范围的，但没有相同有效期的就新增。
			INSERT INTO Promotion.PRO_DEALER_POINT_SUB(DLid,ValidDate,PointAmount,OrderAmount,OtherAmount,
				CreateTime,ModifyDate,Status)
			SELECT B.DLID,A.VALIDDATE,A.Largess,0,0,
				GETDATE(),GETDATE(),1 FROM #TMP_Largess_Parent A,#TMP_FOUND B
			WHERE A.ParentDealerId = B.DEALERID 
			AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_DEALER_POINT_SUB WHERE DLID = B.DLID AND VALIDDATE = A.VALIDDATE)
			
			INSERT INTO promotion.PRO_DEALER_POINT_LOG 
				(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
			SELECT b.DLid,'政策奖励', @PolicyId,a.ParentDealerId,@runPeriod,a.Largess,getdate(),[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.ParentDealerId,@runPeriod)
			FROM #TMP_Largess_Parent A,promotion.PRO_DEALER_POINT B,#TMP_FOUND C
			WHERE A.ParentDealerId = B.DEALERID AND B.DLID = C.DLID
			AND CONVERT(NVARCHAR(19),B.CreateTime,121) = @INSERTDATE AND B.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		END
		--处理平台的积分（由于平台单独设置了使用范围，因此不会包含在上述一二级进积分池的逻辑中.END****************************
	END
	
	--******************************移动到正式表*******************************************************************************
	EXEC Promotion.Proc_Pro_MoveData @PolicyId,'TMP','REP'
	
	--******************************清空计算表********************************************************************************
	SET @SQL = 'DELETE FROM '+@TMPTable
	PRINT @SQL
	EXEC(@SQL)
	
	SET @MSG = '【'+@runPeriod+'】关账已成功！'
	INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
	SELECT @PolicyId,'正式','关账成功',@runPeriod,GETDATE(),GETDATE(),@MSG
	
	PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Closing Success!' 
	
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
    
    PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Closing Failed!' 
    
    INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,'关账','失败',@runPeriod,GETDATE(),GETDATE(),@vError
        
END CATCH

GO


