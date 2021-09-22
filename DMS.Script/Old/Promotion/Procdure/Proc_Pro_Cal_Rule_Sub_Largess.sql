DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Rule_Sub_Largess] 
GO


/**********************************************
	���ܣ��������(��Ʒ)
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Rule_Sub_Largess] 
	@RuleId Int,	--����ID
	@SQL_WHERE NVARCHAR(MAX)
AS
BEGIN  
	DECLARE @SQL NVARCHAR(MAX);
	
	DECLARE @runPeriod NVARCHAR(20); --��ǰ������ڼ�
	DECLARE @LastPeriod NVARCHAR(20); --���ڼ�����ڼ�
	DECLARE @TableName NVARCHAR(50); --��ǰ�����
	
	DECLARE @JudgeColName NVARCHAR(20); --��ǰ�ж������ֶ�
	DECLARE @AdjustJudgeColName NVARCHAR(200); --������ĵ�ǰ�ж������ֶ�
	DECLARE @LargessColName NVARCHAR(20); --��ǰ�������������ֶ�
	DECLARE @FinalLargessColName NVARCHAR(20); --������ǰ�������������ֶ�
	DECLARE @LeftColName NVARCHAR(20); --��ǰʣ�������ֶ�
	DECLARE @LastLargessColName NVARCHAR(20); --�����е����ڴ������������ֶ�(��Ʒ)
	DECLARE @LastPointsColName NVARCHAR(20); --�����е����ڴ������������ֶ�(����)
	DECLARE @LastLeftColName NVARCHAR(20); --�����е�����ʣ�������ֶ�
	DECLARE @Last_LargessColName NVARCHAR(20); --�����еı��ڴ������������ֶ�(��Ʒ)
	DECLARE @Last_PointsColName NVARCHAR(20); --�����еı��ڴ������������ֶ�(����)
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
	SET @FinalPointsColName = 'FinalPoints' + @runPeriod	--������������
	SET @RatioColName = 'Ratio' + @runPeriod		--�Ӽ���	
	SET @ValidDateColName = 'ValidDate' + @runPeriod --��Ч��
	
	--���������Ҫ���ǡ���������������
	IF @ifAddLastLeft = 'Y'
	BEGIN
		SET @LastLeftColName = 'LastLeft' + @runPeriod	--�����еġ������������ֶ�
		SET @Last_LeftColName = 'Left' + @LastPeriod	--�����еġ������������ֶ�
		
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@LastLeftColName+' = '+@LastLeftColName +'+'+@Last_LeftColName 
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
			
		PRINT @SQL
		EXEC(@SQL)	
	END
	
	--���������Ҫ���ǡ��ۼ�������Ʒ��������������Ʒ������
	IF @ifMinusLastGift = 'Y' AND @PolicySubStyle <> '������Ʒת����'
	BEGIN
		SET @LastLargessColName = 'LastLargess' + @runPeriod --�����еġ��ۼ�������Ʒ���ֶ�
		SET @Last_LargessColName = 'FinalLargess' + @LastPeriod --�����еġ�������Ʒ���ֶΣ�ȡ������������ֶΣ�
		
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@LastLargessColName+' = '+@LastLargessColName +'+'+@Last_LargessColName 
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
			
		PRINT @SQL
		EXEC(@SQL)
	END
	
	--���������Ҫ���ǡ��ۼ����ڻ��֡����������ڻ��ֵ�����
	IF @ifMinusLastGift = 'Y' AND @PolicySubStyle = '������Ʒת����'
	BEGIN
		SET @LastPointsColName = 'LastPoints' + @runPeriod --�����еġ��ۼ����ڻ��֡��ֶ�
		SET @Last_PointsColName = 'FinalPoints' + @LastPeriod --�����еġ����ڻ��֡��ֶΣ�ȡ������������ֶΣ�
		
		SET @SQL = 'UPDATE '+@TableName+' SET '
			+@LastPointsColName+' = '+@LastPointsColName +'+'+@Last_PointsColName 
			+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
			
		PRINT @SQL
		EXEC(@SQL)
	END
	
	--�����������㣬Ŀǰֻ֧��һ����λ�ļ��㣨A-E�����ָ�ֻ꣬��ΪA����ֵ��
	SET @IncrementColumn = ''
	IF @ifIncrement = 'Y'
	BEGIN
		--�����ָ��ҽԺֲ��������Ҫȡ��ָ��ҽԺֲ��������Aָ����
		IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyFactorId = @PolicyFactorId AND FactId = 8)
		BEGIN
			SELECT @IncrementPolicyFactorId = PolicyFactorId 
			FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 7
			SELECT @IncrementColumn = ColumnName 
			FROM PROMOTION.func_Pro_Utility_getColumnName(@IncrementPolicyFactorId,@runPeriod) WHERE SOURCECOLUMN = 'Ŀ��1'
		END
		--�����ָ��ҽԺֲ��������Ҫȡ��ָ��ҽԺֲ��������Aָ����
		IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyFactorId = @PolicyFactorId AND FactId = 9)
		BEGIN
			SELECT @IncrementPolicyFactorId = PolicyFactorId 
			FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId = @PolicyId AND FactId = 6
			SELECT @IncrementColumn = ColumnName 
			FROM PROMOTION.func_Pro_Utility_getColumnName(@IncrementPolicyFactorId,@runPeriod) WHERE SOURCECOLUMN = 'Ŀ��1'
		END
	END
		
	--���������Ҫ���ǡ������������������ߡ��ۼ�������Ʒ����Ҫ�����ж����ص�ƴ��SQL
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
		
	--������@GiftValue(������Ʒ��X��Y����������X��Y��ת���֣���Ҫ����GiftValue)
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
		+ CASE @CarryType WHEN 'Floor' THEN  ',' + @LeftColName +' = ' + @AdjustJudgeColName + '%' + CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@JudgeValue)) ELSE '' END --ֻ������ȡ����������
		+ ',' + @RuleIdColName + '=' + CONVERT(NVARCHAR,@RuleId)
		+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=0 ' + @SQL_WHERE
	
	PRINT @SQL
	EXEC(@SQL)
	
	--�����ƷС��0���͵���0
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+@LargessColName+' = 0'
		+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE +' AND ' + @LargessColName +' < 0'
	
	PRINT @SQL
	EXEC(@SQL)
		
--********************�жϷⶥ(��Ʒ�����ķⶥ���������㱾�����ۼƻ�ȡ��Ʒ��START*********************************************************
	IF @TopType = 'Policy'
	BEGIN
		SET @SQL = 'UPDATE '+@TableName+' SET '
			--�ۼ���Ʒ���ڹ���ʱ���� +'LargessTotal = CASE WHEN LargessTotal+'+@LargessColName+'>'+@TopValue+' THEN '+@TopValue+' ELSE LargessTotal+'+@LargessColName+' END,'
			+@LargessColName+' = CASE WHEN LargessTotal+'+@LargessColName+'>'+@TopValue+' THEN '+@TopValue+'-LargessTotal ELSE '+@LargessColName+' END'
			+ ' WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
	
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'Dealer'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			--�ۼ���Ʒ���ڹ���ʱ���� +'LargessTotal = CASE WHEN LargessTotal+'+@LargessColName+'>B.TopValue THEN B.TopValue ELSE LargessTotal+'+@LargessColName+' END,'
			+@LargessColName+' = CASE WHEN LargessTotal+'+@LargessColName+'>B.TopValue THEN B.TopValue-LargessTotal ELSE '+@LargessColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			+' AND A.DealerId = B.DealerId'
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'Hospital'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			--�ۼ���Ʒ���ڹ���ʱ���� +'LargessTotal = CASE WHEN LargessTotal+'+@LargessColName+'>B.TopValue THEN B.TopValue ELSE LargessTotal+'+@LargessColName+' END,'
			+@LargessColName+' = CASE WHEN LargessTotal+'+@LargessColName+'>B.TopValue THEN B.TopValue-LargessTotal ELSE '+@LargessColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			+' AND A.DealerId = B.DealerId AND A.HospitalId = B.HospitalId'
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'DealerPeriod'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			--�ۼ���Ʒ���ڹ���ʱ���� +'LargessTotal = LargessTotal + CASE WHEN '+@LargessColName+'>B.TopValue THEN B.TopValue ELSE '+@LargessColName+' END,'
			+@LargessColName+' = CASE WHEN '+@LargessColName+'>B.TopValue THEN B.TopValue ELSE '+@LargessColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId)+ @SQL_WHERE
			+' AND A.DealerId = B.DealerId AND B.Period='''+@runPeriod+''''
		
		PRINT @SQL
		EXEC(@SQL)
	END
	
	IF @TopType = 'HospitalPeriod'
	BEGIN
		SET @SQL = 'UPDATE A SET '
			--�ۼ���Ʒ���ڹ���ʱ���� +'LargessTotal = LargessTotal + CASE WHEN '+@LargessColName+'>B.TopValue THEN B.TopValue ELSE '+@LargessColName+' END,'
			+@LargessColName+' = CASE WHEN '+@LargessColName+'>B.TopValue THEN B.TopValue ELSE '+@LargessColName+' END'
			+ ' FROM '+@TableName+' A,PROMOTION.PRO_POLICY_TOPVALUE B WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			+' AND A.DealerId = B.DealerId AND A.HospitalId = B.HospitalId AND B.Period='''+@runPeriod+''''
		
		PRINT @SQL
		EXEC(@SQL)
	END
--********************�жϷⶥ�������㱾�����ۼƻ�ȡ��Ʒ��END*********************************************************


--********************�������Ʒת����(��Ʒ����*�̶�ÿ��λ���֣���Ʒ����*���²ɹ��ۣ���Ʒ����*(���²ɹ���-��׼�۸�)��****
	IF @PolicySubStyle = '������Ʒת����'
	BEGIN 
		IF @PointsType = '�ɹ���'
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
			--����Ʒ������UPNչ��
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
			
			--ȡ�������漰�ľ����̣��ڵ�ǰ��ƷUPN��Χ�ڣ����Ĳɹ���
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
			
			--ԭ��ʽ��(���ڻ������������²ɹ��ۡ�����ۼ���-���ڻ���)/����X*��Y
			--����Ϊϵͳ��ʽ��������Ʒ�������²ɹ��ۡ�����ۼ��� - ���ڻ���/����X*��Y
			SET @SQL = 'UPDATE A SET '
			+ @PointsColName +' = ROUND(CONVERT(DECIMAL(14,4),'+ @LargessColName +') * CONVERT(DECIMAL(14,4),B.PRICE) * CONVERT(DECIMAL(14,4),'+CONVERT(NVARCHAR,@MJRatio)+')'
				+ ' - CONVERT(DECIMAL(14,4),' + ISNULL(@LastPointsColName,'0') + ')/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@JudgeValue))+') * '
				+'CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@DivValue))+'),4)'
			+ ' FROM '+@TableName+' A,#DEALER_PRICE B '
			+ ' WHERE 1=1 AND A.DEALERID = B.DMA_ID' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
		
			PRINT @SQL
			EXEC(@SQL)
			
			--�������С��0���͵���0
			SET @SQL = 'UPDATE '+@TableName+' SET '
				+@PointsColName+' = 0'
				+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE +' AND ' + @PointsColName +' < 0'
			
			PRINT @SQL
			EXEC(@SQL)
		END
		ELSE IF	@PointsType = '�̶�����'
		BEGIN
			
			SET @SQL = 'UPDATE '+@TableName+' SET '
			+ @PointsColName +' = ROUND('+ @LargessColName +' * '+CONVERT(NVARCHAR,@PointsValue)+' * CONVERT(DECIMAL(14,4),'+CONVERT(NVARCHAR,@MJRatio)+')'
				+' - ' + ISNULL(@LastPointsColName,'0') + '/CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@JudgeValue))+') * '
				+'CONVERT(DECIMAL(18,4),'+CONVERT(NVARCHAR,CONVERT(DECIMAL(18,4),@DivValue))+'),0)'
			+ ' WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			
			PRINT @SQL
			EXEC(@SQL)
		END
		ELSE IF	@PointsType = '�����̶̹�����'
		BEGIN
			SET @SQL = 'UPDATE A SET '
			+ @PointsColName +' = ROUND('+ @LargessColName +' * B.POINTS,0) '
			+ ' FROM '+@TableName+' A,Promotion.Pro_Dealer_Std_Point B '
			+ ' WHERE 1=1 AND A.DEALERID = B.DEALERID AND B.POLICYID = '+ CONVERT(NVARCHAR,@PolicyId) 
			+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
			
			PRINT @SQL
			EXEC(@SQL)
		END
		
		
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
			
			--���»����ֶΣ�����Ӽ���֮��
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
			SELECT @ValidDate = Promotion.func_Pro_Utility_getPointValidDate(B.Period,B.CalPeriod,B.PointValidDateType,B.PointValidDateDuration,B.PointValidDateAbsolute)
			FROM Promotion.Pro_Policy B WHERE POLICYID = @PolicyId
			
			SET @SQL = 'UPDATE '+@TableName+' SET '
				+@ValidDateColName+' = '''+CONVERT(NVARCHAR(10),@ValidDate,121)+''''
				+ ' WHERE 1=1 '+ ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE 
			PRINT @SQL
			EXEC(@SQL)
		--��Ч��END*************************************************************************************************************
	END
	
--********************��󣬵��������Ʒ�ֶ�Ĭ�ϵ�����Ʒ�ֶ�************************************************************	
	SET @SQL = 'UPDATE '+@TableName+' SET '
		+ @FinalLargessColName + ' = '+ @LargessColName +','
		+ @FinalPointsColName + ' = '+ @PointsColName
		+' WHERE 1=1 ' + ' AND ISNULL('+@RuleIdColName+',0)=' + CONVERT(NVARCHAR,@RuleId) + @SQL_WHERE
		
	PRINT @SQL
	EXEC(@SQL)
		
END  

GO


