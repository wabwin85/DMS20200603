DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Rule_Sub_Largess] 
GO


/**********************************************
	功能：计算规则(赠品)
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Rule_Sub_Largess] 
	@RuleId Int,	--规则ID
	@SQL_WHERE NVARCHAR(MAX)
AS
BEGIN  
	DECLARE @SQL NVARCHAR(MAX);
	
	DECLARE @runPeriod NVARCHAR(20); --当前计算的期间
	DECLARE @LastPeriod NVARCHAR(20); --上期计算的期间
	DECLARE @TableName NVARCHAR(50); --当前计算表
	
	DECLARE @JudgeColName NVARCHAR(20); --当前判断因素字段
	DECLARE @AdjustJudgeColName NVARCHAR(200); --调整后的当前判断因素字段
	DECLARE @LargessColName NVARCHAR(20); --当前促销返利因素字段
	DECLARE @FinalLargessColName NVARCHAR(20); --调整后当前促销返利因素字段
	DECLARE @LeftColName NVARCHAR(20); --当前剩余因素字段
	DECLARE @LastLargessColName NVARCHAR(20); --本期中的上期促销返利因素字段(赠品)
	DECLARE @LastPointsColName NVARCHAR(20); --本期中的上期促销返利因素字段(积分)
	DECLARE @LastLeftColName NVARCHAR(20); --本期中的上期剩余因素字段
	DECLARE @Last_LargessColName NVARCHAR(20); --上期中的本期促销返利因素字段(赠品)
	DECLARE @Last_PointsColName NVARCHAR(20); --上期中的本期促销返利因素字段(积分)
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
	DECLARE @PointsType	NVARCHAR(50);
	DECLARE @PointsValue DECIMAL(18,4);
	DECLARE @ifIncrement NVARCHAR(5);
	DECLARE @IncrementPolicyFactorId INT;
	DECLARE @IncrementColumn NVARCHAR(20);	
	DECLARE @PolicyStyle NVARCHAR(50);
	DECLARE @PolicySubStyle NVARCHAR(50);
	DECLARE @BU NVARCHAR(50);
	DECLARE @GiftPolicyFactorId INT;
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
		@CarryType = CASE ISNULL(C.CarryType,'') WHEN '' THEN 'Floor' ELSE C.CarryType END,
		@ifMinusLastGift = CASE ISNULL(C.ifMinusLastGift,'') WHEN '' THEN 'N' ELSE C.ifMinusLastGift END,
		@ifIncrement = CASE ISNULL(C.ifIncrement,'') WHEN '' THEN 'N' ELSE C.ifIncrement END,
		@PolicyStyle = C.PolicyStyle,
		@PolicySubStyle = C.PolicySubStyle,
		@PointsType = A.PointsType,
		@PointsValue = A.PointsValue,
		@MJRatio = ISNULL(MJRatio,1)
	FROM PROMOTION.PRO_POLICY_RULE A,Promotion.PRO_POLICY_FACTOR B,
	Promotion.PRO_POLICY C,Promotion.PRO_FACTOR D
	WHERE A.PolicyId = C.PolicyId AND A.JudgePolicyFactorId = B.PolicyFactorId AND B.FactId = D.FactId
	AND A.RuleId = @RuleId
	
	SELECT 	
		@GiftType = A.GiftType,
		@GiftPolicyFactorId = GiftPolicyFactorId
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
	SET @FinalPointsColName = 'FinalPoints' + @runPeriod	--待调整积分数
	SET @RatioColName = 'Ratio' + @runPeriod		--加价率	
	SET @ValidDateColName = 'ValidDate' + @runPeriod --有效期
	
	--如果该政策要考虑“加上上期余量”
	IF @ifAddLastLeft = 'Y'
	BEGIN
		SET @LastLeftColName = 'LastLeft' + @runPeriod	--本期中的“上期余量”字段
		SET @Last_LeftColName = 'Left' + @LastPeriod	--上期中的“本期余量”字段
		
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@LastLeftColName+' = '+@LastLeftColName +'+'+@Last_LeftColName 
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
			
		PRINT @SQL
		EXEC(@SQL)	
	END
	
	--如果该政策要考虑“扣减上期赠品”，复制上期赠品到本期
	IF @ifMinusLastGift = 'Y' AND @PolicySubStyle <> '促销赠品转积分'
	BEGIN
		SET @LastLargessColName = 'LastLargess' + @runPeriod --本期中的“扣减上期赠品”字段
		SET @Last_LargessColName = 'FinalLargess' + @LastPeriod --上期中的“本期赠品”字段（取调整审批后的字段）
		
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@LastLargessColName+' = '+@LastLargessColName +'+'+@Last_LargessColName 
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
			
		PRINT @SQL
		EXEC(@SQL)
	END
	
	--如果该政策要考虑“扣减上期积分”，复制上期积分到本期
	IF @ifMinusLastGift = 'Y' AND @PolicySubStyle = '促销赠品转积分'
	BEGIN
		SET @LastPointsColName = 'LastPoints' + @runPeriod --本期中的“扣减上期积分”字段
		SET @Last_PointsColName = 'FinalPoints' + @LastPeriod --上期中的“本期积分”字段（取调整审批后的字段）
		
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@LastPointsColName+' = '+@LastPointsColName +'+'+@Last_PointsColName 
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
			
		PRINT @SQL
		EXEC(@SQL)
	END
	
	--对于增量计算，目前只支持一个档位的计算（A-E的五个指标，只认为A列有值）
	SET @IncrementColumn = ''
	IF @ifIncrement = 'Y'
	BEGIN
		--如果是指定医院植入量，就要取到指定医院植入量达标的A指标列
		IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyFactorId = @PolicyFactorId AND FactId = 8)
		BEGIN
			SELECT @IncrementPolicyFactorId = PolicyFactorId 
			FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 7
			SELECT @IncrementColumn = ColumnName 
			FROM PROMOTION.func_Pro_Utility_getColumnName(@IncrementPolicyFactorId,@runPeriod) WHERE SOURCECOLUMN = '目标1'
		END
		--如果是指定医院植入量，就要取到指定医院植入量达标的A指标列
		IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyFactorId = @PolicyFactorId AND FactId = 9)
		BEGIN
			SELECT @IncrementPolicyFactorId = PolicyFactorId 
			FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 6
			SELECT @IncrementColumn = ColumnName 
			FROM PROMOTION.func_Pro_Utility_getColumnName(@IncrementPolicyFactorId,@runPeriod) WHERE SOURCECOLUMN = '目标1'
		END
	END
		
	--如果该政策要考虑“加上上期余量”或者“扣减上期赠品”，要调整判断因素的拼接SQL
	IF @ifAddLastLeft = 'Y' OR @ifMinusLastGift = 'Y'
	BEGIN
		SET @AdjustJudgeColName = '('+ @JudgeColName + CASE @ifAddLastLeft WHEN 'Y' THEN '+' + @LastLeftColName ELSE '' END 
			+ CASE ISNULL(@LastLargessColName,'') WHEN '' THEN '' ELSE '-'+ @LastLargessColName END 
			+ CASE @IncrementColumn WHEN '' THEN '' ELSE '-'+@IncrementColumn END + ')'
	END
	ELSE
	BEGIN
		SET @AdjustJudgeColName = '('+ @JudgeColName + CASE @IncrementColumn WHEN '' THEN '' ELSE '-'+@IncrementColumn END + ')'
	END
		
		PRINT '@AdjustJudgeColName='+ISNULL(@AdjustJudgeColName,'')
		
	--被除数@GiftValue(无论赠品买X送Y，或者是满X送Y后转积分，都要除以GiftValue)
	SET @DivValue = @GiftValue

	SET @SQL = 'UPDATE '+@TableName+' SET '
		+@LargessColName+' = '+
			CASE @CarryType WHEN 'Floor' THEN 'FLOOR('+ @AdjustJudgeColName + '/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@JudgeValue))+'))'
								+' * CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@DivValue))+')'
							WHEN 'Ceiling' THEN 'CEILING('+ @AdjustJudgeColName + '/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@JudgeValue))+'))'
								+' * CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@DivValue))+')' 
							WHEN 'Round' THEN 'Round('+ @AdjustJudgeColName + '/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@JudgeValue))+'),0)'
								+' * CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@DivValue))+')' 
							WHEN 'KeepValue' THEN 'Round(CONVERT(DECIMAL(18,4),'+ @AdjustJudgeColName + ')/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@JudgeValue))+'),4)'
								+' * CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@DivValue))+')' END
		+ CASE @CarryType WHEN 'Floor' THEN  ',' + @LeftColName +' = ' + @AdjustJudgeColName + '%' + CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@JudgeValue)) ELSE '' END --只有向下取整才有余量
		+ ',' + @RuleIdColName + '=' + CONVERT(NVARCHAR,@RuleId)
		+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
	
	PRINT @SQL
	EXEC(@SQL)
	
	--如果赠品小于0，就等于0
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+@LargessColName+' = 0'
		+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE +' AND ' + @LargessColName +' < 0'
	
	PRINT @SQL
	EXEC(@SQL)
		
--********************判断封顶(赠品数量的封顶），并计算本政策累计获取赠品数START*********************************************************
	IF @TopType = 'Policy'
	BEGIN
		SET @SQL = 'UPDATE '+@TableName+' SET '
			--累计赠品数在关账时计算 +'LargessTotal = CASE WHEN LargessTotal+'+@LargessColName+'>'+@TopValue+' THEN '+@TopValue+' ELSE LargessTotal+'+@LargessColName+' END,'
			+@LargessColName+' = CASE WHEN LargessTotal+'+@LargessColName+'>'+@TopValue+' THEN '+@TopValue+'-LargessTotal ELSE '+@LargessColName+' END'
			+ ' WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
	
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'Dealer'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			--累计赠品数在关账时计算 +'LargessTotal = CASE WHEN LargessTotal+'+@LargessColName+'>B.TopValue THEN B.TopValue ELSE LargessTotal+'+@LargessColName+' END,'
			+@LargessColName+' = CASE WHEN LargessTotal+'+@LargessColName+'>B.TopValue THEN B.TopValue-LargessTotal ELSE '+@LargessColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			+' AND A.DealerId = B.DealerId'
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'Hospital'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			--累计赠品数在关账时计算 +'LargessTotal = CASE WHEN LargessTotal+'+@LargessColName+'>B.TopValue THEN B.TopValue ELSE LargessTotal+'+@LargessColName+' END,'
			+@LargessColName+' = CASE WHEN LargessTotal+'+@LargessColName+'>B.TopValue THEN B.TopValue-LargessTotal ELSE '+@LargessColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			+' AND A.DealerId = B.DealerId AND A.HospitalId = B.HospitalId'
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'DealerPeriod'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			--累计赠品数在关账时计算 +'LargessTotal = LargessTotal + CASE WHEN '+@LargessColName+'>B.TopValue THEN B.TopValue ELSE '+@LargessColName+' END,'
			+@LargessColName+' = CASE WHEN '+@LargessColName+'>B.TopValue THEN B.TopValue ELSE '+@LargessColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId)+ @SQL_WHERE
			+' AND A.DealerId = B.DealerId AND B.Period='''+@runPeriod+''''
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'HospitalPeriod'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			--累计赠品数在关账时计算 +'LargessTotal = LargessTotal + CASE WHEN '+@LargessColName+'>B.TopValue THEN B.TopValue ELSE '+@LargessColName+' END,'
			+@LargessColName+' = CASE WHEN '+@LargessColName+'>B.TopValue THEN B.TopValue ELSE '+@LargessColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			+' AND A.DealerId = B.DealerId AND A.HospitalId = B.HospitalId AND B.Period='''+@runPeriod+''''
		
		PRINT @SQL
		EXEC(@SQL)
	END
--********************判断封顶，并计算本政策累计获取赠品数END*********************************************************


--********************如果是赠品转积分(赠品数量*固定每单位积分；赠品数量*最新采购价；赠品数量*(最新采购价-标准价格)）****
	IF @PolicySubStyle = '促销赠品转积分'
	BEGIN 
		IF @PointsType = '采购价'
		BEGIN
			CREATE TABLE #DEALER_PRICE
			(
				DMA_ID UNIQUEIDENTIFIER,
				PRICE DECIMAL(14,2)
			)
			CREATE TABLE #TMP_UPN
			(
				UPN NVARCHAR(100)
			)
			--将赠品包含的UPN展开
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
			
			--取得政策涉及的经销商，在当前赠品UPN范围内，最大的采购价
			SET @SQL = N'INSERT INTO #DEALER_PRICE(DMA_ID,PRICE) 
				SELECT CFNP_GROUP_ID,CFNP_PRICE FROM 
				(
					SELECT CFNP_GROUP_ID,CFNP_PRICE,
					ROW_NUMBER() OVER(PARTITION BY CFNP_GROUP_ID ORDER BY CFNP_PRICE DESC) RN 
					FROM CFNPrice A WHERE CFNP_PriceType = ''Dealer'' 
					AND A.CFNP_CFN_ID IN (SELECT Y.CFN_ID FROM #TMP_UPN X,CFN Y WHERE X.UPN = Y.CFN_CustomerFaceNbr)
					AND A.CFNP_GROUP_ID IN (SELECT DEALERID FROM '+@TableName+')
				) T WHERE RN = 1'
			PRINT @SQL
			EXEC(@SQL)
			
			--原公式是(本期基数数量×最新采购价×买减折价率-上期积分)/买赠X*送Y
			--换算为系统公式：本期赠品数×最新采购价×买减折价率 - 上期积分/买赠X*送Y
			SET @SQL = 'UPDATE A SET '
			+ @PointsColName +' = ROUND(CONVERT(DECIMAL(14,4),'+ @LargessColName +') * CONVERT(DECIMAL(14,4),B.PRICE) * CONVERT(DECIMAL(14,4),'+CONVERT(NVARCHAR,@MJRatio)+')'
				+ ' - CONVERT(DECIMAL(14,4),' + ISNULL(@LastPointsColName,'0') + ')/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@JudgeValue))+') * '
				+'CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@DivValue))+'),4)'
			+ ' FROM '+@TableName+' A,#DEALER_PRICE B '
			+ ' WHERE 1=1 AND A.DEALERID = B.DMA_ID' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
		
			PRINT @SQL
			EXEC(@SQL)
			
			--如果积分小于0，就等于0
			SET @SQL = 'UPDATE '+@TableName+' SET '
				+@PointsColName+' = 0'
				+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE +' AND ' + @PointsColName +' < 0'
			
			PRINT @SQL
			EXEC(@SQL)
		END
		ELSE IF	@PointsType = '固定积分'
		BEGIN
			
			SET @SQL = 'UPDATE '+@TableName+' SET '
			+ @PointsColName +' = ROUND('+ @LargessColName +' * '+CONVERT(NVARCHAR,@PointsValue)+' * CONVERT(DECIMAL(14,4),'+CONVERT(NVARCHAR,@MJRatio)+')'
				+' - ' + ISNULL(@LastPointsColName,'0') + '/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@JudgeValue))+') * '
				+'CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@DivValue))+'),0)'
			+ ' WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			
			PRINT @SQL
			EXEC(@SQL)
		END
		ELSE IF	@PointsType = '经销商固定积分'
		BEGIN
			SET @SQL = 'UPDATE A SET '
			+ @PointsColName +' = ROUND('+ @LargessColName +' * B.POINTS,0) '
			+ ' FROM '+@TableName+' A,Promotion.Pro_Dealer_Std_Point B '
			+ ' WHERE 1=1 AND A.DEALERID = B.DEALERID AND B.POLICYID = '+ CONVERT(NVARCHAR,@PolicyId) 
			+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			
			PRINT @SQL
			EXEC(@SQL)
		END
		
		
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
			
			--更新积分字段（计算加价率之后）
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
			SELECT @ValidDate = Promotion.func_Pro_Utility_getPointValidDate(B.Period,B.CalPeriod,B.PointValidDateType,B.PointValidDateDuration,B.PointValidDateAbsolute)
			FROM Promotion.Pro_Policy B WHERE POLICYID = @PolicyId
			
			SET @SQL = 'UPDATE '+@TableName+' SET '
				+@ValidDateColName+' = '''+CONVERT(NVARCHAR(10),@ValidDate,121)+''''
				+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE 
			PRINT @SQL
			EXEC(@SQL)
		--有效期END*************************************************************************************************************
	END
	
--********************最后，调整审核赠品字段默认等于赠品字段************************************************************	
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+ @FinalLargessColName + ' = '+ @LargessColName +','
		+ @FinalPointsColName + ' = '+ @PointsColName
		+' WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
		
	PRINT @SQL
	EXEC(@SQL)
		
END  

GO


