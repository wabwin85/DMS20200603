DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Rule_Sub_Point] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Rule_Sub_Point] 
	@RuleId Int,	--规则ID
	@SQL_WHERE NVARCHAR(MAX)
AS
BEGIN  
	DECLARE @SQL NVARCHAR(MAX);
	
	DECLARE @runPeriod NVARCHAR(20); --当前计算的期间
	DECLARE @LastPeriod NVARCHAR(20); --上期计算的期间
	DECLARE @TableName NVARCHAR(50); --当前计算表
	
	DECLARE @JudgeColName NVARCHAR(100); --当前判断因素字段
	DECLARE @AdjustJudgeColName NVARCHAR(200); --调整后的当前判断因素字段
	DECLARE @LargessColName NVARCHAR(20); --当前促销返利因素字段
	DECLARE @FinalLargessColName NVARCHAR(20); --调整后当前促销返利因素字段
	DECLARE @LeftColName NVARCHAR(20); --当前剩余因素字段
	DECLARE @LastLargessColName NVARCHAR(20); --本期中的上期促销返利因素字段
	DECLARE @LastLeftColName NVARCHAR(20); --本期中的上期剩余因素字段
	DECLARE @Last_LargessColName NVARCHAR(20); --上期中的本期促销返利因素字段
	DECLARE @Last_LeftColName NVARCHAR(20); --上期中的本期剩余因素字段
	DECLARE @PointsColName NVARCHAR(20); --积分字段
	DECLARE @RatioColName NVARCHAR(20); --加价率字段
	DECLARE @FinalPointsColName NVARCHAR(20); --调整后积分字段
	DECLARE @ValidDateColName NVARCHAR(20); --有效期字段
	
	DECLARE @ValidDate DATETIME; --有效期
	
	DECLARE @RuleIdColName NVARCHAR(20); --当前适用的RULEID
	
	DECLARE @PolicyFactorId INT;
	DECLARE @PolicyId INT;
	DECLARE @TopType NVARCHAR(20);
	DECLARE @TopValue NVARCHAR(20);
	DECLARE @Period NVARCHAR(5);
	DECLARE @CurrentPeriod NVARCHAR(10);
	DECLARE @StartDate NVARCHAR(10);
	DECLARE @CalModule NVARCHAR(20);
	DECLARE @FactId INT;
	DECLARE @JudgeValue DECIMAL(18,4);
	DECLARE @GiftType NVARCHAR(20);
	DECLARE @GiftValue DECIMAL(18,4);
	DECLARE @ifConvert NVARCHAR(5);
	DECLARE @ifAddLastLeft NVARCHAR(5);
	DECLARE @CarryType NVARCHAR(20);	
	DECLARE @ifMinusLastGift NVARCHAR(5);
	DECLARE @DivValue DECIMAL(18,4);
	DECLARE @PointsValue DECIMAL(18,4);
	DECLARE @ifIncrement NVARCHAR(5);
	DECLARE @IncrementPolicyFactorId INT;
	DECLARE @IncrementColumn NVARCHAR(20);	
	DECLARE @PolicyStyle NVARCHAR(50);
	DECLARE @PolicySubStyle NVARCHAR(50);
	DECLARE @BU NVARCHAR(50);
	DECLARE @MJRatio DECIMAL(14,4);
	
	SELECT 
		@BU  = C.BU,
		@PolicyFactorId = B.PolicyFactorId,
		@PolicyId = C.PolicyId,
		@TopType = ISNULL(C.TopType,''),
		@TopValue = CONVERT(NVARCHAR(20),ISNULL(TopValue,0)),
		@Period = C.Period,
		@CurrentPeriod = C.CurrentPeriod,
		@StartDate = C.StartDate,
		@CalModule = C.CalModule,
		@FactId = D.FactId,
		@JudgeValue = A.JudgeValue,
		@GiftValue = ISNULL(A.GiftValue,1),
		@ifConvert = CASE ISNULL(C.ifConvert,'') WHEN '' THEN 'N' ELSE C.ifConvert END,
		@ifAddLastLeft = CASE ISNULL(C.ifAddLastLeft,'') WHEN '' THEN 'N' ELSE C.ifAddLastLeft END,
		@CarryType = CASE ISNULL(@CarryType,'') WHEN '' THEN 'Floor' ELSE C.CarryType END,
		@ifMinusLastGift = CASE ISNULL(C.ifMinusLastGift,'') WHEN '' THEN 'N' ELSE C.ifMinusLastGift END,
		@ifIncrement = CASE ISNULL(C.ifIncrement,'') WHEN '' THEN 'N' ELSE C.ifIncrement END,
		@PolicyStyle = C.PolicyStyle,
		@PolicySubStyle = C.PolicySubStyle,
		@PointsValue = A.PointsValue,
		@MJRatio = ISNULL(c.MJRatio,1)
	FROM PROMOTION.PRO_POLICY_RULE A,Promotion.PRO_POLICY_FACTOR B,
	Promotion.PRO_POLICY C,Promotion.PRO_FACTOR D
	WHERE A.PolicyId = C.PolicyId AND A.JudgePolicyFactorId = B.PolicyFactorId AND B.FactId = D.FactId
	AND A.RuleId = @RuleId
	
	SELECT 	@GiftType = A.GiftType
	FROM PROMOTION.PRO_POLICY_LARGESS A WHERE PolicyId = @PolicyId
	
	IF @CalModule='正式'
	BEGIN
		SELECT @TableName=TempTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END
	ELSE
	BEGIN
		SELECT @TableName=PreTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END
	
	--如果是预算，将条件全部清空，满足第一个CURSOR进来的规则
	IF @CalModule='预算'
	BEGIN
		SET @SQL_WHERE=''
	END
		
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
	
	--得到当前判断因素字段(PRO_POLICY_RULE.JudgePolicyFactorId)
	SELECT @JudgeColName = ColumnName FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@runPeriod) WHERE isCondition = 'Y'
	
	SET @LargessColName = 'Largess' + @runPeriod			--本期赠品数
	SET @FinalLargessColName = 'FinalLargess' + @runPeriod	--待调整赠品数
	SET @LeftColName = 'Left' + @runPeriod					--本期余量
	SET @RuleIdColName = 'RuleId' + @runPeriod				--规则ID
	SET @PointsColName = 'Points' + @runPeriod				--本期积分数
	SET @RatioColName = 'Ratio' + @runPeriod				--加价率
	SET @FinalPointsColName = 'FinalPoints' + @runPeriod	--待调整积分数	
	SET @ValidDateColName = 'ValidDate' + @runPeriod --有效期
	
	--如果该政策要考虑“扣减上期积分”
	IF @ifMinusLastGift = 'Y'
	BEGIN
		SET @LastLargessColName = 'LastPoints' + @runPeriod --本期中的“扣减上期赠品”字段（若是积分政策，此字段放积分）
		SET @Last_LargessColName = 'FinalPoints' + @LastPeriod --上期中的“本期积分”字段（取调整审批后的字段）
		
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@LastLargessColName+' = '+@LastLargessColName +'+'+@Last_LargessColName 
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
			
		PRINT @SQL
		EXEC(@SQL)
	END
	
	--对于增量计算，目前只支持一个档位的计算（A-E的五个指标，只认为A列有值）
	SET @IncrementColumn = ''
	IF @ifIncrement = 'Y'
	BEGIN
		--如果是指定产品医院植入金额12，就要取到指定产品医院植入金额达标率15的A指标列
		IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyFactorId = @PolicyFactorId AND FactId = 12)
		BEGIN
			SELECT @IncrementPolicyFactorId = PolicyFactorId 
			FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 15
			
			SELECT @IncrementColumn = ColumnName 
			FROM PROMOTION.func_Pro_Utility_getColumnName(@IncrementPolicyFactorId,@runPeriod) WHERE SOURCECOLUMN = '目标1'
		END
		--如果是指定产品商业采购金额13，就要取到指定产品商业采购金额达标率14的A指标列
		IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyFactorId = @PolicyFactorId AND FactId = 13)
		BEGIN
			SELECT @IncrementPolicyFactorId = PolicyFactorId 
			FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 14
			
			SELECT @IncrementColumn = ColumnName 
			FROM PROMOTION.func_Pro_Utility_getColumnName(@IncrementPolicyFactorId,@runPeriod) WHERE SOURCECOLUMN = '目标1'
		END
	END
	
	IF @PolicySubStyle = '金额百分比积分'
	BEGIN
		SET @JudgeColName=@JudgeColName+'* 1.1700'+' * CONVERT(DECIMAL(14,4),'+CONVERT(NVARCHAR,@MJRatio)+')'
		PRINT @JudgeColName;
	END
	
	--如果该政策要考虑“扣减上期积分”，要调整判断因素的拼接SQL
	IF @ifMinusLastGift = 'Y'
	BEGIN
		SET @AdjustJudgeColName = '('+ @JudgeColName 
			+ CASE @ifMinusLastGift WHEN 'Y' THEN '-'+ @LastLargessColName ELSE '' END 	--扣减上期积分
			+ CASE @IncrementColumn WHEN '' THEN '' ELSE '-'+@IncrementColumn END + ')'	--增量计算
	END
	ELSE
	BEGIN
		SET @AdjustJudgeColName = '('+ @JudgeColName + CASE @IncrementColumn WHEN '' THEN '' ELSE '-'+@IncrementColumn END + ')'
	END
	
	IF @PolicySubStyle = '满额送固定积分'
	BEGIN
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@PointsColName+' = '+ 'Round('+ @AdjustJudgeColName + '/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,@JudgeValue) + ')*CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,@PointsValue)+'),4)' 
			+ ',' + @RuleIdColName + '=' + CONVERT(NVARCHAR,@RuleId)
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @PolicySubStyle = '金额百分比积分'
	BEGIN
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@PointsColName+' = '+ 'Round('+ @AdjustJudgeColName + ' * CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,@GiftValue)+'),4)' 
			+ ',' + @RuleIdColName + '=' + CONVERT(NVARCHAR,@RuleId)
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
	
		PRINT @SQL
		EXEC(@SQL)
	END
	
	--如果积分小于0，就等于0
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+@PointsColName+' = 0'
		+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE +' AND ' + @PointsColName +' < 0'
	
	PRINT @SQL
	EXEC(@SQL)
	
--计算加价率START*************************************************************************************************************
	CREATE TABLE #TMP_RATIO
	(
		DEALERID UNIQUEIDENTIFIER,
		RATIO DECIMAL(18,4)
	)
	
	SET @SQL = 'INSERT INTO #TMP_RATIO(DEALERID,RATIO) SELECT DISTINCT DEALERID,1 FROM '+@TableName
	PRINT @SQL
	EXEC(@SQL)
	
	--使用本政策直接设置的二级或一级的RATIO
	UPDATE A SET RATIO = B.Ratio
	FROM #TMP_RATIO A,Promotion.PRO_POLICY_POINTRATIO B
	WHERE B.PolicyId = @PolicyId AND A.DEALERID = B.DealerId AND B.AccountMonth = @runPeriod
	
	--使用本政策直接设置的平台RATIO更新到二级上面
	UPDATE A SET RATIO = B.Ratio
	FROM #TMP_RATIO A,Promotion.PRO_POLICY_POINTRATIO B,DealerMaster C
	WHERE B.PolicyId = @PolicyId AND A.DEALERID = C.DMA_ID AND C.DMA_Parent_DMA_ID = B.DealerId
	AND B.AccountMonth = @runPeriod
	AND A.RATIO = 1
	
	--使用统一设置的平台或一级加价率 
	UPDATE A SET RATIO = B.Ratio
	FROM #TMP_RATIO A,Promotion.Pro_BU_PointRatio B
	WHERE B.BU = @BU AND A.DEALERID = B.PlatFormId
	AND A.RATIO = 1 
	
	UPDATE A SET RATIO = B.Ratio
	FROM #TMP_RATIO A,Promotion.Pro_BU_PointRatio B,DealerMaster C
	WHERE B.BU = @BU AND A.DEALERID = C.DMA_ID AND C.DMA_Parent_DMA_ID = B.PlatFormId
	AND A.RATIO = 1 
	
	--更新加价率字段
	SET @SQL = 'UPDATE B SET ' +@RatioColName + ' = A.RATIO'
		+ ' FROM #TMP_RATIO A,'+@TableName+' B WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
		+ ' AND A.DEALERID = B.DEALERID'
	PRINT @SQL
	EXEC(@SQL)
	
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+@RatioColName+' = 1'
		+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE +' AND ISNULL('+@RatioColName+',0)=0'
	PRINT @SQL
	EXEC(@SQL)
	
--计算加价率END*************************************************************************************************************

	
--有效期START*************************************************************************************************************
	--此处是指一二级的有效期
	SELECT @ValidDate = Promotion.func_Pro_Utility_getPointValidDate(B.Period,B.CalPeriod,B.PointValidDateType,B.PointValidDateDuration,B.PointValidDateAbsolute)
	FROM Promotion.Pro_Policy B WHERE POLICYID = @PolicyId
	
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+@ValidDateColName+' = '''+CONVERT(NVARCHAR(10),@ValidDate,121)+''''
		+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE 
	PRINT @SQL
	EXEC(@SQL)
--有效期END*************************************************************************************************************


--********************判断封顶(积分的封顶），并计算本政策累计获取积分数START*********************************************************
	IF @TopType = 'Policy'
	BEGIN
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@PointsColName+' = CASE WHEN PointsTotal+'+@PointsColName+'>'+@TopValue+' THEN '+@TopValue+'-PointsTotal ELSE '+@PointsColName+' END'
			+ ' WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
	
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'Dealer'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			+@PointsColName+' = CASE WHEN PointsTotal+'+@PointsColName+'>B.TopValue THEN B.TopValue-PointsTotal ELSE '+@PointsColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			+' AND A.DealerId = B.DealerId'
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'Hospital'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			+@PointsColName+' = CASE WHEN PointsTotal+'+@PointsColName+'>B.TopValue THEN B.TopValue-PointsTotal ELSE '+@PointsColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			+' AND A.DealerId = B.DealerId AND A.HospitalId = B.HospitalId'
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'DealerPeriod'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			+@PointsColName+' = CASE WHEN '+@PointsColName+'>B.TopValue THEN B.TopValue ELSE '+@PointsColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId)+ @SQL_WHERE
			+' AND A.DealerId = B.DealerId AND B.Period='''+@runPeriod+''''
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'HospitalPeriod'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			+@PointsColName+' = CASE WHEN '+@PointsColName+'>B.TopValue THEN B.TopValue ELSE '+@PointsColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			+' AND A.DealerId = B.DealerId AND A.HospitalId = B.HospitalId AND B.Period='''+@runPeriod+''''
		
		PRINT @SQL
		EXEC(@SQL)
	END
--********************判断封顶，并计算本政策累计获取积分数END*********************************************************

--********************最后，调整审核积分字段默认等于积分字段************************************************************	
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+ @FinalPointsColName + ' = '+ @PointsColName
		+' WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
		
	PRINT @SQL
	EXEC(@SQL)
		
END  

GO


