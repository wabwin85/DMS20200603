DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Rule_Sub_Point] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Rule_Sub_Point] 
	@RuleId Int,	--����ID
	@SQL_WHERE NVARCHAR(MAX)
AS
BEGIN  
	DECLARE @SQL NVARCHAR(MAX);
	
	DECLARE @runPeriod NVARCHAR(20); --��ǰ������ڼ�
	DECLARE @LastPeriod NVARCHAR(20); --���ڼ�����ڼ�
	DECLARE @TableName NVARCHAR(50); --��ǰ�����
	
	DECLARE @JudgeColName NVARCHAR(100); --��ǰ�ж������ֶ�
	DECLARE @AdjustJudgeColName NVARCHAR(200); --������ĵ�ǰ�ж������ֶ�
	DECLARE @LargessColName NVARCHAR(20); --��ǰ�������������ֶ�
	DECLARE @FinalLargessColName NVARCHAR(20); --������ǰ�������������ֶ�
	DECLARE @LeftColName NVARCHAR(20); --��ǰʣ�������ֶ�
	DECLARE @LastLargessColName NVARCHAR(20); --�����е����ڴ������������ֶ�
	DECLARE @LastLeftColName NVARCHAR(20); --�����е�����ʣ�������ֶ�
	DECLARE @Last_LargessColName NVARCHAR(20); --�����еı��ڴ������������ֶ�
	DECLARE @Last_LeftColName NVARCHAR(20); --�����еı���ʣ�������ֶ�
	DECLARE @PointsColName NVARCHAR(20); --�����ֶ�
	DECLARE @RatioColName NVARCHAR(20); --�Ӽ����ֶ�
	DECLARE @FinalPointsColName NVARCHAR(20); --����������ֶ�
	DECLARE @ValidDateColName NVARCHAR(20); --��Ч���ֶ�
	
	DECLARE @ValidDate DATETIME; --��Ч��
	
	DECLARE @RuleIdColName NVARCHAR(20); --��ǰ���õ�RULEID
	
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
	
	IF @CalModule='��ʽ'
	BEGIN
		SELECT @TableName=TempTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END
	ELSE
	BEGIN
		SELECT @TableName=PreTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END
	
	--�����Ԥ�㣬������ȫ����գ������һ��CURSOR�����Ĺ���
	IF @CalModule='Ԥ��'
	BEGIN
		SET @SQL_WHERE=''
	END
		
	--�õ���ǰ������ڼ�
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
	
	--�õ���ǰ�ж������ֶ�(PRO_POLICY_RULE.JudgePolicyFactorId)
	SELECT @JudgeColName = ColumnName FROM PROMOTION.func_Pro_Utility_getColumnName(@PolicyFactorId,@runPeriod) WHERE isCondition = 'Y'
	
	SET @LargessColName = 'Largess' + @runPeriod			--������Ʒ��
	SET @FinalLargessColName = 'FinalLargess' + @runPeriod	--��������Ʒ��
	SET @LeftColName = 'Left' + @runPeriod					--��������
	SET @RuleIdColName = 'RuleId' + @runPeriod				--����ID
	SET @PointsColName = 'Points' + @runPeriod				--���ڻ�����
	SET @RatioColName = 'Ratio' + @runPeriod				--�Ӽ���
	SET @FinalPointsColName = 'FinalPoints' + @runPeriod	--������������	
	SET @ValidDateColName = 'ValidDate' + @runPeriod --��Ч��
	
	--���������Ҫ���ǡ��ۼ����ڻ��֡�
	IF @ifMinusLastGift = 'Y'
	BEGIN
		SET @LastLargessColName = 'LastPoints' + @runPeriod --�����еġ��ۼ�������Ʒ���ֶΣ����ǻ������ߣ����ֶηŻ��֣�
		SET @Last_LargessColName = 'FinalPoints' + @LastPeriod --�����еġ����ڻ��֡��ֶΣ�ȡ������������ֶΣ�
		
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@LastLargessColName+' = '+@LastLargessColName +'+'+@Last_LargessColName 
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
			
		PRINT @SQL
		EXEC(@SQL)
	END
	
	--�����������㣬Ŀǰֻ֧��һ����λ�ļ��㣨A-E�����ָ�ֻ꣬��ΪA����ֵ��
	SET @IncrementColumn = ''
	IF @ifIncrement = 'Y'
	BEGIN
		--�����ָ����ƷҽԺֲ����12����Ҫȡ��ָ����ƷҽԺֲ��������15��Aָ����
		IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyFactorId = @PolicyFactorId AND FactId = 12)
		BEGIN
			SELECT @IncrementPolicyFactorId = PolicyFactorId 
			FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 15
			
			SELECT @IncrementColumn = ColumnName 
			FROM PROMOTION.func_Pro_Utility_getColumnName(@IncrementPolicyFactorId,@runPeriod) WHERE SOURCECOLUMN = 'Ŀ��1'
		END
		--�����ָ����Ʒ��ҵ�ɹ����13����Ҫȡ��ָ����Ʒ��ҵ�ɹ��������14��Aָ����
		IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyFactorId = @PolicyFactorId AND FactId = 13)
		BEGIN
			SELECT @IncrementPolicyFactorId = PolicyFactorId 
			FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 14
			
			SELECT @IncrementColumn = ColumnName 
			FROM PROMOTION.func_Pro_Utility_getColumnName(@IncrementPolicyFactorId,@runPeriod) WHERE SOURCECOLUMN = 'Ŀ��1'
		END
	END
	
	IF @PolicySubStyle = '���ٷֱȻ���'
	BEGIN
		SET @JudgeColName=@JudgeColName+'* 1.1700'+' * CONVERT(DECIMAL(14,4),'+CONVERT(NVARCHAR,@MJRatio)+')'
		PRINT @JudgeColName;
	END
	
	--���������Ҫ���ǡ��ۼ����ڻ��֡���Ҫ�����ж����ص�ƴ��SQL
	IF @ifMinusLastGift = 'Y'
	BEGIN
		SET @AdjustJudgeColName = '('+ @JudgeColName 
			+ CASE @ifMinusLastGift WHEN 'Y' THEN '-'+ @LastLargessColName ELSE '' END 	--�ۼ����ڻ���
			+ CASE @IncrementColumn WHEN '' THEN '' ELSE '-'+@IncrementColumn END + ')'	--��������
	END
	ELSE
	BEGIN
		SET @AdjustJudgeColName = '('+ @JudgeColName + CASE @IncrementColumn WHEN '' THEN '' ELSE '-'+@IncrementColumn END + ')'
	END
	
	IF @PolicySubStyle = '�����͹̶�����'
	BEGIN
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@PointsColName+' = '+ 'Round('+ @AdjustJudgeColName + '/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,@JudgeValue) + ')*CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,@PointsValue)+'),4)' 
			+ ',' + @RuleIdColName + '=' + CONVERT(NVARCHAR,@RuleId)
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @PolicySubStyle = '���ٷֱȻ���'
	BEGIN
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@PointsColName+' = '+ 'Round('+ @AdjustJudgeColName + ' * CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,@GiftValue)+'),4)' 
			+ ',' + @RuleIdColName + '=' + CONVERT(NVARCHAR,@RuleId)
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
	
		PRINT @SQL
		EXEC(@SQL)
	END
	
	--�������С��0���͵���0
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+@PointsColName+' = 0'
		+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE +' AND ' + @PointsColName +' < 0'
	
	PRINT @SQL
	EXEC(@SQL)
	
--����Ӽ���START*************************************************************************************************************
	CREATE TABLE #TMP_RATIO
	(
		DEALERID UNIQUEIDENTIFIER,
		RATIO DECIMAL(18,4)
	)
	
	SET @SQL = 'INSERT INTO #TMP_RATIO(DEALERID,RATIO) SELECT DISTINCT DEALERID,1 FROM '+@TableName
	PRINT @SQL
	EXEC(@SQL)
	
	--ʹ�ñ�����ֱ�����õĶ�����һ����RATIO
	UPDATE A SET RATIO = B.Ratio
	FROM #TMP_RATIO A,Promotion.PRO_POLICY_POINTRATIO B
	WHERE B.PolicyId = @PolicyId AND A.DEALERID = B.DealerId AND B.AccountMonth = @runPeriod
	
	--ʹ�ñ�����ֱ�����õ�ƽ̨RATIO���µ���������
	UPDATE A SET RATIO = B.Ratio
	FROM #TMP_RATIO A,Promotion.PRO_POLICY_POINTRATIO B,DealerMaster C
	WHERE B.PolicyId = @PolicyId AND A.DEALERID = C.DMA_ID AND C.DMA_Parent_DMA_ID = B.DealerId
	AND B.AccountMonth = @runPeriod
	AND A.RATIO = 1
	
	--ʹ��ͳһ���õ�ƽ̨��һ���Ӽ��� 
	UPDATE A SET RATIO = B.Ratio
	FROM #TMP_RATIO A,Promotion.Pro_BU_PointRatio B
	WHERE B.BU = @BU AND A.DEALERID = B.PlatFormId
	AND A.RATIO = 1 
	
	UPDATE A SET RATIO = B.Ratio
	FROM #TMP_RATIO A,Promotion.Pro_BU_PointRatio B,DealerMaster C
	WHERE B.BU = @BU AND A.DEALERID = C.DMA_ID AND C.DMA_Parent_DMA_ID = B.PlatFormId
	AND A.RATIO = 1 
	
	--���¼Ӽ����ֶ�
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
	
--����Ӽ���END*************************************************************************************************************

	
--��Ч��START*************************************************************************************************************
	--�˴���ָһ��������Ч��
	SELECT @ValidDate = Promotion.func_Pro_Utility_getPointValidDate(B.Period,B.CalPeriod,B.PointValidDateType,B.PointValidDateDuration,B.PointValidDateAbsolute)
	FROM Promotion.Pro_Policy B WHERE POLICYID = @PolicyId
	
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+@ValidDateColName+' = '''+CONVERT(NVARCHAR(10),@ValidDate,121)+''''
		+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE 
	PRINT @SQL
	EXEC(@SQL)
--��Ч��END*************************************************************************************************************


--********************�жϷⶥ(���ֵķⶥ���������㱾�����ۼƻ�ȡ������START*********************************************************
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
--********************�жϷⶥ�������㱾�����ۼƻ�ȡ������END*********************************************************

--********************��󣬵�����˻����ֶ�Ĭ�ϵ��ڻ����ֶ�************************************************************	
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+ @FinalPointsColName + ' = '+ @PointsColName
		+' WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
		
	PRINT @SQL
	EXEC(@SQL)
		
END  

GO


