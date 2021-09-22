DROP PROCEDURE [Promotion].[Proc_Pro_GetPolicy4EWorkFlowPoint]
GO


/**********************************************
	���ܣ����ݽ����ѯ�������EWORKFLOW�����ļ�(����)
	���ߣ�GrapeCity
	������ʱ�䣺	2016-03-07
	���¼�¼˵����
	1.���� 2016-03-07
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_GetPolicy4EWorkFlowPoint]
	@BU NVARCHAR(50),
	@Period NVARCHAR(10),
	@AccountMonth NVARCHAR(10)
AS
BEGIN	
	CREATE TABLE #RESULT_MAIN
	(
		BU NVARCHAR(50),
		AccountMonth NVARCHAR(10),
		LPSAPCode NVARCHAR(50),
		LPId UNIQUEIDENTIFIER,
		LPName NVARCHAR(100),
		LargessDesc NVARCHAR(max),	--����ʹ�÷�Χ
		PointType NVARCHAR(50), --Point���ֲ�����ɲ��㷵��;Money���(������㷵��)��
		PointValidDate DATETIME,	--������Ч�ڣ�ƽ̨��һ����
		Amount DECIMAL(14,2)
	)	
	
	CREATE TABLE #RESULT_DETAIL
	(
		BU NVARCHAR(50),
		AccountMonth NVARCHAR(10),
		PolicyId INT,
		PolicyNo NVARCHAR(20),
		PolicyName NVARCHAR(200),
		LargessDesc NVARCHAR(max),
		LPSAPCode NVARCHAR(50),
		LPId UNIQUEIDENTIFIER,
		LPName NVARCHAR(100),
		DealerSAPCode NVARCHAR(50),
		DealerId UNIQUEIDENTIFIER,
		DealerName NVARCHAR(100),
		HospitalId NVARCHAR(50),
		HospitalName NVARCHAR(50),
		PointType NVARCHAR(50), --Point���ֲ�����ɲ��㷵��;Money���(������㷵��)��
		Ratio DECIMAL(14,4),
		PointValidDate DATETIME,	--������Ч��
		Amount DECIMAL(14,2)
	)
	
	SELECT A.PolicyId,A.BU,A.PERIOD,
	a.CalPeriod AccountMonth
	INTO #PRO_POLICY
	FROM Promotion.PRO_POLICY a 
	WHERE Status = '��Ч' 
	AND PolicyStyle = '����'
	AND a.CalPeriod IS NOT NULL --��ǰ�ѽ������ڲ�Ϊ��
	AND EXISTS (SELECT * FROM Promotion.pro_cal_log WHERE PolicyId = A.PolicyId AND Calmodule = '��ʽ' AND CalStatus = '�ɹ�'
	 AND CalPeriod = a.CalPeriod) --��������ʽ����ɹ�
	AND NOT EXISTS (SELECT * FROM Promotion.T_Pro_Flow F,Promotion.T_Pro_Flow_Detail FD
		WHERE F.FlowId = FD.FlowId AND f.STATUS IN ('������','����ͨ��') AND FD.PolicyId = a.PolicyId
		AND a.CalPeriod = F.AccountMonth) --���������������ύ������������ɵĸ����ڼ�¼
	
	SELECT * INTO #TMP_PRO_POLICY FROM #PRO_POLICY 
	WHERE (@BU IS NULL OR @BU = BU)
	AND (@Period IS NULL OR @Period = Period)
	AND (@AccountMonth IS NULL OR @AccountMonth = AccountMonth)
		
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @PolicyId INT;
	DECLARE @CalPeriod NVARCHAR(20);
	DECLARE @CalType NVARCHAR(20);
	DECLARE @TempTableName NVARCHAR(50);
	DECLARE @ifCalPurchaseAR NVARCHAR(50);	--������㷵����������ɲ��㷵��
	DECLARE @ValidDate DATETIME;	--������Ч��
	
	--��ʱ����#RESULT_DETAIL���ܰ���һ���Ͷ���
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT B.PolicyId,B.CalPeriod,B.CalType,B.TempTableName,ISNULL(B.ifCalPurchaseAR,''),
		Promotion.func_Pro_Utility_getPointValidDate(B.Period,B.CalPeriod,B.PointValidDateType,B.PointValidDateDuration,B.PointValidDateAbsolute) ValidDate
		FROM #TMP_PRO_POLICY A,Promotion.Pro_Policy B WHERE A.PolicyId = B.PolicyId
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @PolicyId,@CalPeriod,@CalType,@TempTableName,@ifCalPurchaseAR,@ValidDate
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SQL = 'INSERT INTO #RESULT_DETAIL(PolicyId,DealerId,HospitalId,Amount,PointType,PointValidDate,Ratio) '
			+'SELECT '+CONVERT(NVARCHAR,@PolicyId)+',DealerId,'+CASE @CalType WHEN 'ByDealer' THEN 'NULL' ELSE 'HospitalId' END+','
			+'Points' + @CalPeriod +','''+@ifCalPurchaseAR+''','''+CONVERT(NVARCHAR(10),@ValidDate,121)+''''+','+'Ratio'+@CalPeriod +' FROM '+@TempTableName
		BEGIN TRY
			EXEC(@SQL)	
		END TRY
		BEGIN CATCH
			PRINT 'ERROR AT '+CONVERT(NVARCHAR,@PolicyId)
		END CATCH		
		
		FETCH NEXT FROM @iCURSOR INTO @PolicyId,@CalPeriod,@CalType,@TempTableName,@ifCalPurchaseAR,@ValidDate
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR

	--����������Ϣ
	UPDATE A SET BU = @BU,AccountMonth = @AccountMonth,
		PolicyNo = B.PolicyNo,PolicyName = B.PolicyName
	FROM #RESULT_DETAIL A,Promotion.Pro_Policy B 
	WHERE A.PolicyId = B.PolicyId
	
	--���¾�������Ϣ
	UPDATE A SET DealerName = B.DMA_ChineseName,DealerSAPCode=b.DMA_SAP_Code,LPId = B.DMA_Parent_DMA_ID
	FROM #RESULT_DETAIL A,dbo.DealerMaster B WHERE A.DealerId = B.DMA_ID
		
	--����ƽ̨��Ϣ
	UPDATE A SET LPName = B.DMA_ChineseName,LPSAPCode=b.DMA_SAP_Code
	FROM #RESULT_DETAIL A,dbo.DealerMaster B WHERE A.LPId = B.DMA_ID
	
	--����ҽԺ��Ϣ
	UPDATE A SET HospitalName = B.HOS_HospitalName
	FROM #RESULT_DETAIL A,dbo.Hospital B WHERE A.HospitalId = B.HOS_Key_Account
	
	--������Ʒ����(�˴��ǻ���ʹ�÷�Χ)
	UPDATE A SET LargessDesc = Promotion.func_Pro_PolicyToHtml_Factor_Product(B.UseRangePolicyFactorId,null)
	FROM #RESULT_DETAIL A,Promotion.PRO_POLICY_LARGESS B
	WHERE A.PolicyId = B.PolicyId
	
	--ƽ̨ 
	INSERT INTO #RESULT_MAIN(BU,AccountMonth,LPId,LPSAPCode,LPName,LargessDesc,Amount,PointType,PointValidDate)
	SELECT A.BU,AccountMonth,LPId,LPSAPCode,LPName,
	CASE B.PointUseRange WHEN 'BU' THEN B.BU ELSE A.LargessDesc END,	--��ƽ̨ʹ�÷�Χ��ByBU���ṩ��������BU����������������̷�Χһ��
	SUM(Amount/CASE ISNULL(Ratio,0) WHEN 0 THEN 1 ELSE RATIO END),	--��ƽ̨����Ҫ���ԼӼ���
	A.PointType,
	Promotion.func_Pro_Utility_getPointValidDate(B.Period,B.CalPeriod,B.PointValidDateType2,B.PointValidDateDuration2,B.PointValidDateAbsolute2) --ƽ̨������Ч��
	FROM #RESULT_DETAIL A,Promotion.Pro_Policy B 
	WHERE A.PolicyId = B.PolicyId
	AND EXISTS(SELECT 1 FROM DealerMaster B WHERE A.DealerId=B.DMA_ID AND B.DMA_DealerType='T2')
	GROUP BY A.BU,A.AccountMonth,A.LPId,A.LPSAPCode,A.LPName,
	CASE B.PointUseRange WHEN 'BU' THEN B.BU ELSE A.LargessDesc END,
	PointType,
	Promotion.func_Pro_Utility_getPointValidDate(B.Period,B.CalPeriod,B.PointValidDateType2,B.PointValidDateDuration2,B.PointValidDateAbsolute2)
	HAVING SUM(Amount/CASE ISNULL(Ratio,0) WHEN 0 THEN 1 ELSE RATIO END) <> 0 
	
	--һ�������̣�����ʹ�÷�Χ�������Ч�ڣ������һ�£�
	INSERT INTO #RESULT_MAIN(BU,AccountMonth,LPId,LPSAPCode,LPName,LargessDesc,Amount,PointType,PointValidDate)
	SELECT BU,AccountMonth,A.DealerId,a.DealerSAPCode,A.DealerName,LargessDesc,SUM(Amount),PointType,PointValidDate 
	FROM #RESULT_DETAIL A
	WHERE NOT EXISTS(SELECT 1 FROM DealerMaster B WHERE A.DealerId=B.DMA_ID AND B.DMA_DealerType='T2')
	GROUP BY BU,AccountMonth,DealerId,DealerSAPCode,DealerName,LargessDesc,PointType,PointValidDate
	HAVING SUM(Amount) <> 0 
	
	UPDATE #RESULT_MAIN SET PointType='Point' WHERE PointType='N'
	UPDATE #RESULT_MAIN SET PointType='Money' WHERE PointType='Y'
	UPDATE #RESULT_DETAIL SET PointType='Point' WHERE PointType='N'
	UPDATE #RESULT_DETAIL SET PointType='Money' WHERE PointType='Y'
	
	SELECT * FROM #RESULT_MAIN WHERE Amount <> 0
	
	SELECT B.POLICYNAME,A.*,A.Amount as AdjustAmount 
	FROM #RESULT_DETAIL A,PROMOTION.PRO_POLICY B WHERE A.POLICYID = B.POLICYID --AND Amount <> 0
	
END
