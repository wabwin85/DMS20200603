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
		@CurrentPeriod = CurrentPeriod, --��ʱ��ֵ��ʵ���ϸ��ڼ�
		@CalModule = CalModule,
		@ifConvert = ifConvert,
		@BU = BU,
		@SUBBU = ISNULL(SUBBU,''),
		@PolicyStyle = PolicyStyle
	FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId
	
	SELECT @UseRangePolicyFactorId = UseRangePolicyFactorId 
	FROM Promotion.PRO_POLICY_LARGESS WHERE PolicyId = @PolicyId 
	
	--�õ���ǰ������ڼ�
	IF ISNULL(@CurrentPeriod,'') = ''
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	END
	ELSE
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
	END
	
	--Ԥ������
	IF @CalModule = '��ʽ'
		SET @TMPTable = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	ELSE
		SET @TMPTable = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,'CAL')
		
--��ʼ����	
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
	
	--�����е���Ʒ�Ĳ�Ʒ��Χ����
	DECLARE @GiftPolicyFactorId INT
			
	--UPN��ʱ��
	CREATE TABLE #TMP_UPN
	(
		UPN NVARCHAR (50)
	)
	
	DECLARE @ICOUNT_UPN INT
	
	--������Ʒ��BY��UPN/DEALERID
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
			
			
	IF @PolicyStyle = '��Ʒ'
	BEGIN
		--******************************�ۼƵ������̿�ʹ����Ʒ��******************************************************************
		SET @SUM_STRING = 'SUM(FinalLargess' + @runPeriod + ')'
		
		SET @SQL = 'INSERT INTO #TMP_Largess(ParentDealerId,DealerId,Largess) SELECT B.DMA_Parent_DMA_ID ParentDealerId,A.DealerId,'
			+ @SUM_STRING +' Largess '
			+' FROM '+@TMPTable+' A,dbo.DealerMaster B WHERE A.DealerId = B.DMA_ID '
			+'GROUP BY B.DMA_Parent_DMA_ID,A.DealerId ' --HAVING '+@SUM_STRING+' <> 0'
		PRINT @SQL
		EXEC(@SQL)
		
		--�ϼƵ�ƽ̨��һ��������
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)
		SELECT ParentDealerId,SUM(Largess) Largess FROM #TMP_Largess WHERE ParentDealerId IS NOT NULL GROUP BY ParentDealerId
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)
		SELECT DealerId,SUM(Largess) Largess FROM #TMP_Largess WHERE ParentDealerId IS NULL GROUP BY DealerId
		
		SELECT @GiftPolicyFactorId = GiftPolicyFactorId
		FROM Promotion.PRO_POLICY_LARGESS a WHERE a.PolicyId = @PolicyId
		
		--�Ƿ�����װ����Ʒ
		DECLARE @isBundle NVARCHAR(10)
		IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @GiftPolicyFactorId AND ConditionId = 2)
		BEGIN
			SET @isBundle = 'Y'
		END
		ELSE
		BEGIN
			SET @isBundle = 'N'
		END
		
		--******************�ǻ��֣���Ʒ������װ��START*****************************************************************************
		IF @ifConvert = 'N' AND @isBundle = 'N' --��ͨ��Ʒ����Ʒ
		BEGIN
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
			SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --��ǰ���ߵ�UPN����
			
			INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) SELECT A.Dlid,A.DEALERID,B.UPN 
			FROM Promotion.PRO_FORECAST A,Promotion.PRO_FORECAST_UPN B
				WHERE GiftType = 'FreeGoods' AND CreateTime = @CREATETIME AND A.Dlid = B.Dlid
			
			--�ҵ��Ѵ��ڵ�Ԥ��
			INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
			SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
			FROM #TMP_DLID_UPN A 
			LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.DEALERID = B.ParentDealerId AND A.UPN = B.UPN
			GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			
			--��������ҵ��������ϵ���Ʒ�أ�ֻ���ۼ�1����
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
						
			--1.���ܵ�������****************************************************************
			DELETE FROM #TMP_DLID_UPN
			DELETE FROM #TMP_FOUND_TMP
			DELETE FROM #TMP_FOUND
			
			INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) SELECT A.Dlid,DEALERID,B.UPN 
			FROM Promotion.PRO_FORECAST_DEALER A,Promotion.PRO_FORECAST_DEALER_UPN B
				WHERE GiftType = 'FreeGoods' AND CreateTime = @CREATETIME AND A.Dlid = B.Dlid
				
			--�ҵ��Ѵ��ڵ�Ԥ��
			INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
			SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
			FROM #TMP_DLID_UPN A 
			LEFT JOIN (SELECT * FROM #TMP_Largess X,#TMP_UPN Y) B ON A.DEALERID = B.DEALERID AND A.UPN = B.UPN
			GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			
			--��������ҵ��������ϵ���Ʒ�أ�ֻ���ۼ�1����
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
			
			--3.���ܵ�����****************************************************************
			INSERT INTO Promotion.PRO_FORECAST_POLICY(PolicyId,LPID,DEALERID,GiftType,BU,SubBU,LargessAmount,CreateTime)
			SELECT @PolicyId,ParentDealerId,DealerId,'FreeGoods',@BU,@SUBBU,Largess,@CREATETIME FROM #TMP_Largess
			
			INSERT INTO Promotion.PRO_FORECAST_POLICY_DETAIL(PolicyId,ConditionId,OperTag,ConditionValue)
			SELECT @PolicyId,B.ConditionId,B.OperTag,B.ConditionValue FROM Promotion.PRO_POLICY_FACTOR_CONDITION B
			WHERE B.PolicyFactorId = @GiftPolicyFactorId
			AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_FORECAST_POLICY_DETAIL WHERE PolicyId = @PolicyId)
			
			DELETE FROM Promotion.PRO_FORECAST_POLICY_UPN WHERE POLICYID = @PolicyId
			
			INSERT INTO Promotion.PRO_FORECAST_POLICY_UPN(POLICYID,UPN) SELECT @PolicyId,UPN FROM #TMP_UPN
		END
		--******************�ǻ��֣���Ʒ������װ��END***********************************************************************
		
		--******************�ǻ��֣���װ��START*****************************************************************************
		IF @ifConvert = 'N' AND @isBundle = 'Y' --��װ��Ʒ
		BEGIN
			DECLARE @BundleId INT --��Ϊֻ��1����װ
			SELECT TOP 1 @BundleId = CONVERT(INT,REPLACE(ConditionValue,'|','')) FROM Promotion.PRO_POLICY_FACTOR_CONDITION 
			WHERE PolicyFactorId = @GiftPolicyFactorId AND ConditionId = 2
			
			DECLARE @HierType NVARCHAR(50)
			DECLARE @HierId NVARCHAR(MAX)
			DECLARE @Qty INT
			DECLARE @IROWNUMBER INT --��λ��ˮ��
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
				
				--��װ�µ�ĳ���Ʒ��ֵ�UPN
				INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_ConditionValue2UPN(@HierType,@HierId)
				
				SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --��ǰ��װ�µ�ĳ���Ʒ��UPN����
				
				--�ҵ��Ѵ��ڵ���Ʒ��
				INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
				SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
				FROM #TMP_DLID_UPN A 
				LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.DEALERID = B.ParentDealerId AND A.UPN = B.UPN
				GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
				
				--��������ҵ��������ϵ���Ʒ�أ�ֻ���ۼ�1����
				INSERT INTO #TMP_FOUND(DLID,DEALERID)
				SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
				
				--������Ʒ��ʱ��Ҫ������װ�и����Ʒ������
				UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0) * @Qty
				FROM Promotion.PRO_FORECAST A,#TMP_Largess_Parent B,#TMP_FOUND C
				WHERE A.DEALERID = B.ParentDealerId AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
				
				--�����̴����Ʒ�״ν�����Ʒ��
				INSERT INTO Promotion.PRO_FORECAST(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,CreateTime,Remark1)
				SELECT ParentDealerId,'FreeGoods',@BU,@UseRangePolicyFactorId,
					Largess * @Qty,	--Ҫ������װ�и����Ʒ������
					@CREATETIME,@IROWNUMBER
				FROM #TMP_Largess_Parent A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.ParentDealerId)
				
				INSERT INTO Promotion.PRO_FORECAST_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
				SELECT A.DLid,CASE @HierType WHEN 'UPN' THEN 1 WHEN 'HIER' THEN 3 ELSE NULL END ConditionId,'����' OperTag,@HierId ConditionValue 
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
				
				--�ҵ��Ѵ��ڵ�Ԥ��
				INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
				SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
				FROM #TMP_DLID_UPN A 
				LEFT JOIN (SELECT * FROM #TMP_Largess X,#TMP_UPN Y) B ON A.DEALERID = B.DEALERID AND A.UPN = B.UPN
				GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
				
				--��������ҵ��������ϵ���Ʒ�أ�ֻ���ۼ�1����
				INSERT INTO #TMP_FOUND(DLID,DEALERID)
				SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
				
				--������Ʒ��ʱ��Ҫ������װ�и����Ʒ������
				UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0) * @Qty
				FROM Promotion.PRO_FORECAST_DEALER A,#TMP_Largess B,#TMP_FOUND C
				WHERE A.DEALERID = B.DEALERID AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
				
				--�����̴����Ʒ�״ν�����Ʒ��
				INSERT INTO Promotion.PRO_FORECAST_DEALER(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,CreateTime,Remark1)
				SELECT DealerId,'FreeGoods',@BU,@UseRangePolicyFactorId,
					Largess * @Qty,	--Ҫ������װ�и����Ʒ������
					@CREATETIME,@IROWNUMBER
				FROM #TMP_Largess A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
				
				INSERT INTO Promotion.PRO_FORECAST_DEALER_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
				SELECT A.DLid,CASE @HierType WHEN 'UPN' THEN 1 WHEN 'HIER' THEN 3 ELSE NULL END ConditionId,'����' OperTag,@HierId ConditionValue 
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
		--******************�ǻ��֣���װ��END*****************************************************************************
	END
	
	IF @PolicyStyle = '����'
	BEGIN
		--******************************�ۼƵ������̿�ʹ����Ʒ��******************************************************************
		SET @SUM_STRING = 'SUM(FinalPoints' + @runPeriod + ')'
		
		SET @SQL = 'INSERT INTO #TMP_Largess(ParentDealerId,DealerId,Largess) SELECT B.DMA_Parent_DMA_ID ParentDealerId,A.DealerId,'
			+ @SUM_STRING +' Largess '
			+' FROM '+@TMPTable+' A,dbo.DealerMaster B WHERE A.DealerId = B.DMA_ID '
			+'GROUP BY B.DMA_Parent_DMA_ID,A.DealerId ' --HAVING '+@SUM_STRING+' <> 0'
		PRINT @SQL
		EXEC(@SQL)
		
		--�ϼƵ�ƽ̨��һ��������
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)
		SELECT ParentDealerId,SUM(Largess) Largess FROM #TMP_Largess WHERE ParentDealerId IS NOT NULL GROUP BY ParentDealerId
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)
		SELECT DealerId,SUM(Largess) Largess FROM #TMP_Largess WHERE ParentDealerId IS NULL GROUP BY DealerId
		
		SELECT @GiftPolicyFactorId = UseRangePolicyFactorId
		FROM Promotion.PRO_POLICY_LARGESS a WHERE a.PolicyId = @PolicyId
				
		INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
		SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --��ǰ���ߵ�UPN����
			
		INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) SELECT A.Dlid,A.DEALERID,B.UPN 
		FROM Promotion.PRO_FORECAST A,Promotion.PRO_FORECAST_UPN B
			WHERE GiftType = 'Points' AND CreateTime = @CREATETIME AND A.Dlid = B.Dlid
			
		--�ҵ��Ѵ��ڵ�Ԥ��
		INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
		SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
		FROM #TMP_DLID_UPN A 
		LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.DEALERID = B.ParentDealerId AND A.UPN = B.UPN
		GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			
		--��������ҵ��������ϵ���Ʒ�أ�ֻ���ۼ�1����
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
						
		--1.���ܵ�������****************************************************************
		DELETE FROM #TMP_DLID_UPN
		DELETE FROM #TMP_FOUND_TMP
		DELETE FROM #TMP_FOUND
			
		INSERT INTO #TMP_DLID_UPN(DLID,DEALERID,UPN) SELECT A.Dlid,DEALERID,B.UPN 
		FROM Promotion.PRO_FORECAST_DEALER A,Promotion.PRO_FORECAST_DEALER_UPN B
			WHERE GiftType = 'Points' AND CreateTime = @CREATETIME AND A.Dlid = B.Dlid
				
		--�ҵ��Ѵ��ڵ�Ԥ��
		INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
		SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
		FROM #TMP_DLID_UPN A 
		LEFT JOIN (SELECT * FROM #TMP_Largess X,#TMP_UPN Y) B ON A.DEALERID = B.DEALERID AND A.UPN = B.UPN
		GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
		
		--��������ҵ��������ϵ���Ʒ�أ�ֻ���ۼ�1����
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
			
		--3.���ܵ�����****************************************************************
		INSERT INTO Promotion.PRO_FORECAST_POLICY(PolicyId,LPID,DEALERID,GiftType,BU,SubBU,LargessAmount,CreateTime)
		SELECT @PolicyId,ParentDealerId,DealerId,'Points',@BU,@SUBBU,Largess,@CREATETIME FROM #TMP_Largess
		
		INSERT INTO Promotion.PRO_FORECAST_POLICY_DETAIL(PolicyId,ConditionId,OperTag,ConditionValue)
		SELECT @PolicyId,B.ConditionId,B.OperTag,B.ConditionValue FROM Promotion.PRO_POLICY_FACTOR_CONDITION B
		WHERE B.PolicyFactorId = @GiftPolicyFactorId
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_FORECAST_POLICY_DETAIL WHERE PolicyId = @PolicyId)
		
		DELETE FROM Promotion.PRO_FORECAST_POLICY_UPN WHERE POLICYID = @PolicyId
		
		INSERT INTO Promotion.PRO_FORECAST_POLICY_UPN(POLICYID,UPN) SELECT @PolicyId,UPN FROM #TMP_UPN 
	END
	
	
	SET @MSG = '��'+@runPeriod+'��Ԥ������ѳɹ���'
	INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
	SELECT @PolicyId,'Ԥ��','�ɹ�',@runPeriod,GETDATE(),GETDATE(),@MSG
	
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
    SET @vError = ISNULL(@error_procedure, '') + '��'
        + CONVERT(NVARCHAR(10), ISNULL(@error_line, '')) + '�г���[����ţ�'
        + CONVERT(NVARCHAR(10), ISNULL(@error_number, '')) + ']��'
        + ISNULL(@error_message, '')
    
    PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Forecast Failed!' 
    
    INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,'Ԥ��','ʧ��',@runPeriod,GETDATE(),GETDATE(),@vError
        
END CATCH

GO


