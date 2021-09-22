DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_Closing] 
GO


/**********************************************
	���ܣ������������߹���
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
	2.�޸� 2015-12-01 ��������װ���߼�
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
	DECLARE @ValidDate2 DATETIME; --ƽ̨������Ч�ڣ������߱��е���ȡ��
	DECLARE @PointUseRange NVARCHAR(50);	--ƽ̨����ʹ�÷�Χ��BU,PRODUCT
	DECLARE @BUUseRange NVARCHAR(200);	--ƽ̨��BU�Ļ���ʹ�÷�Χ
	
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @SUM_STRING NVARCHAR(MAX);
	DECLARE @MSG NVARCHAR(100);
	
	SELECT 
		@Period = Period,
		@StartDate = StartDate,
		@CurrentPeriod = CurrentPeriod, --��ʱ��ֵ��ʵ���ϸ��ڼ�
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
	
	--�õ���ǰ������ڼ�
	IF ISNULL(@CurrentPeriod,'') = ''
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	END
	ELSE
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
	END
	
	--��ʽ�����
	SET @TMPTable = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,'TMP')
	
	IF NOT (@CalModule = '��ʽ' AND @CalStatus = '�ɹ�')
	BEGIN
		INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,'��ʽ','����ʧ��',@runPeriod,GETDATE(),GETDATE(),'��[��ʽ]+[�ɹ�]���޷�����!'
		PRINT 'PolicyId='+CONVERT(NVARCHAR,@PolicyId)+',��[��ʽ]+[�ɹ�]���޷�����!'
		
		RETURN
	END
	
--��ʼ����	
	BEGIN TRAN
	--***********�����߱��е�CurrentPeriod��CalStatus�����£�******************************************************************
	UPDATE Promotion.PRO_POLICY SET 
		CurrentPeriod = @runPeriod,
		CalStatus = '�ѹ���',
		StartTime = GETDATE(),
		EndTime = GETDATE()
	WHERE PolicyId = @PolicyId
	
	--****************************************������ʷ*************************************************************************
	EXEC Promotion.Proc_Pro_MoveData_MoveHis @PolicyId
	
	--******************************���¼�����е��ۼ���Ʒ�ֶ�(Ҳ�����ǻ���)*************************************************
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
	
	--UPN��ʱ��
	CREATE TABLE #TMP_UPN
	(
		UPN NVARCHAR (50)
	)
	
	--������Ʒ��BY��UPN/DEALERID
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
		
	DECLARE @GiftPolicyFactorId INT --�����е���Ʒ�Ĳ�Ʒ��Χ����	
	DECLARE @isBundle NVARCHAR(10) --�Ƿ�����װ����Ʒ
	DECLARE @ICOUNT_UPN INT	
	DECLARE @Dlid INT
	DECLARE @DEALERID UNIQUEIDENTIFIER
	DECLARE @INSERTDATE NVARCHAR(19)
		
	IF @PolicyStyle = '��Ʒ'
	BEGIN 
		--******************************�ۼƵ������̿�ʹ����Ʒ��******************************************************************
		SET @SUM_STRING = 'SUM(FinalLargess' + @runPeriod + ')'
		
		SET @SQL = 'INSERT INTO #TMP_Largess(ParentDealerId,DealerId,Largess) SELECT B.DMA_Parent_DMA_ID ParentDealerId,A.DealerId,'
			+ @SUM_STRING +' Largess '
			+' FROM '+@TMPTable+' A,dbo.DealerMaster B WHERE A.DealerId = B.DMA_ID '
			+'GROUP BY B.DMA_Parent_DMA_ID,A.DealerId HAVING '+@SUM_STRING+' <> 0'
		PRINT @SQL
		EXEC(@SQL)
		
		--�ϼƵ�ƽ̨��һ��������
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)	--ƽ̨
		SELECT ParentDealerId,SUM(Largess) Largess 
		FROM #TMP_Largess A
		WHERE EXISTS (SELECT 1 FROM DealerMaster B WHERE A.DealerId = B.DMA_ID AND B.DMA_DealerType='T2')
		GROUP BY ParentDealerId
		
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,Largess)	--һ��
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
		
		--��������Ʒ��չ����������ID��UPN
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
		
		--******************�ǻ��֣���Ʒ������װ��START*****************************************************************************
		IF @ifConvert IN('N','CA') AND @isBundle = 'N' --��ͨ��Ʒ����Ʒ
		BEGIN
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
			SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --��ǰ���ߵ�UPN����
			
			--�ҵ��Ѵ��ڵ���Ʒ��
			/* 
			--20161030 begin huakaichun ���ۼ���Ʒ���޸ĳɲ��ۼ�
			INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
			SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
			FROM #TMP_DLID_UPN A 
			LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.DEALERID = B.ParentDealerId AND A.UPN = B.UPN
			GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			
			--end huakaichun ���ۼ���Ʒ���޸ĳɲ��ۼ�
			*/
			--��������ҵ��������ϵ���Ʒ�أ�ֻ���ۼ�1����
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
			SELECT b.DLid,'���߽���', @PolicyId,a.DealerId,@runPeriod,a.Largess,getdate()
			,[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.DealerId,@runPeriod)
			FROM #TMP_Largess A,promotion.PRO_DEALER_LARGESS B
			WHERE A.ParentDealerId = B.DEALERID AND isnull(B.UseRangePolicyFactorId,0) = isnull(@UseRangePolicyFactorId,0)
			AND CONVERT(NVARCHAR(19),B.CreateTime,121) = @INSERTDATE
			
			INSERT INTO promotion.PRO_DEALER_LARGESS_LOG 
				(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
			SELECT b.DLid,'���߽���', @PolicyId,a.DealerId,@runPeriod,a.Largess,getdate(),[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.DealerId,@runPeriod)
			FROM #TMP_Largess A,#TMP_FOUND B
			WHERE A.ParentDealerId = B.DEALERID 
			
		END
		--******************�ǻ��֣���Ʒ������װ��END*****************************************************************************
				
		--******************�ǻ��֣���װ��START*****************************************************************************
		IF @ifConvert IN('N','CA') AND @isBundle = 'Y' --��װ��Ʒ
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
				
				--��װ�µ�ĳ���Ʒ��ֵ�UPN
				INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_ConditionValue2UPN(@HierType,@HierId)
				
				--SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --��ǰ��װ�µ�ĳ���Ʒ��UPN����
				
				--�ҵ��Ѵ��ڵ���Ʒ��
				/* 
				--20161030 begin huakaichun ���ۼ���Ʒ���޸ĳɲ��ۼ�
					
				INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
				SELECT A.DLID,A.DEALERID,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
				FROM #TMP_DLID_UPN A 
				LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.DEALERID = B.ParentDealerId AND A.UPN = B.UPN
				GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			
				
				--��������ҵ��������ϵ���Ʒ�أ�ֻ���ۼ�1����
				INSERT INTO #TMP_FOUND(DLID,DEALERID)
				SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
				
				--������Ʒ��ʱ��Ҫ������װ�и����Ʒ������
				UPDATE A SET LargessAmount = LargessAmount + ISNULL(B.Largess,0) * @Qty,
					ModifyDate = GETDATE()
				FROM Promotion.PRO_DEALER_LARGESS A,#TMP_Largess_Parent B,#TMP_FOUND C
				WHERE A.DEALERID = B.ParentDealerId AND A.DLID = C.DLID AND A.DEALERID = C.DEALERID
				--end huakaichun ���ۼ���Ʒ���޸ĳɲ��ۼ�
				*/
				SELECT @INSERTDATE = CONVERT(NVARCHAR(19),GETDATE(),121)
				
				--�����̴����Ʒ�״ν�����Ʒ��
				INSERT INTO Promotion.PRO_DEALER_LARGESS(DEALERID,GiftType,BU,UseRangePolicyFactorId,LargessAmount,
				OrderAmount,OtherAmount,CreateTime,ModifyDate,Remark1)
				SELECT ParentDealerId,'FreeGoods',@BU,@UseRangePolicyFactorId,
					Largess * @Qty,	--Ҫ������װ�и����Ʒ������
					0,0,@INSERTDATE,@INSERTDATE,@IROWNUMBER
				FROM #TMP_Largess_Parent A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.ParentDealerId)
				
				INSERT INTO Promotion.PRO_DEALER_LARGESS_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
				SELECT A.DLid,CASE @HierType WHEN 'UPN' THEN 1 WHEN 'HIER' THEN 3 ELSE NULL END ConditionId,'����' OperTag,@HierId ConditionValue 
				FROM Promotion.PRO_DEALER_LARGESS A,#TMP_Largess_Parent C
				WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE AND A.Remark1 = CONVERT(NVARCHAR,@IROWNUMBER)
				AND A.DEALERID = C.ParentDealerId 
				AND NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DEALERID)
				
				--AmountҪ������װ�и����Ʒ������
				INSERT INTO promotion.PRO_DEALER_LARGESS_LOG 
				(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
				SELECT b.DLid,'���߽���', @PolicyId,a.DealerId,@runPeriod,a.Largess * @Qty,getdate(),[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.DealerId,@runPeriod)
				FROM #TMP_Largess A,promotion.PRO_DEALER_LARGESS B
				WHERE A.ParentDealerId = B.DEALERID AND ISNULL(B.UseRangePolicyFactorId,0) = ISNULL(@UseRangePolicyFactorId,0)
				AND CONVERT(NVARCHAR(19),B.CreateTime,121) = @INSERTDATE AND B.Remark1 = CONVERT(NVARCHAR,@IROWNUMBER)
				
				INSERT INTO promotion.PRO_DEALER_LARGESS_LOG 
				(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
				SELECT b.DLid,'���߽���', @PolicyId,a.DealerId,@runPeriod,a.Largess * @Qty,getdate(),[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.DealerId,@runPeriod)
				FROM #TMP_Largess A,#TMP_FOUND B
				WHERE A.ParentDealerId = B.DEALERID 
				
				SET @IROWNUMBER = @IROWNUMBER + 1
				FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
			END	
			CLOSE @iCURSOR_Bundle
			DEALLOCATE @iCURSOR_Bundle
		END
		--******************�ǻ��֣���װ��END*****************************************************************************
	END
	
	IF @PolicyStyle = '����'
	BEGIN
		SET @SUM_STRING = 'SUM(FinalPoints' + @runPeriod + ')'
		SET  @ValidDateColumn = 'ValidDate'+@runPeriod	--������еĻ�����Ч���ֶΣ�������һ������������
		SET  @RatioColumn = 'Ratio'+@runPeriod	--������еļӼ���
			
		SET @SQL = 'INSERT INTO #TMP_Largess(ParentDealerId,DealerId,ValidDate,Ratio,Largess) '
			+'SELECT B.DMA_Parent_DMA_ID ParentDealerId,A.DealerId,'+@ValidDateColumn+','+@RatioColumn+','
			+ @SUM_STRING +' Largess '
			+' FROM '+@TMPTable+' A,dbo.DealerMaster B WHERE A.DealerId = B.DMA_ID '
			+'GROUP BY B.DMA_Parent_DMA_ID,A.DealerId,'+@ValidDateColumn+','+@RatioColumn +' HAVING '+@SUM_STRING+' <> 0'
		PRINT @SQL
		EXEC(@SQL)
		
		--�ϼƵ�ƽ̨
		INSERT INTO #TMP_Largess_Parent(ParentDealerId,ValidDate,Largess)	--ƽ̨(���ԼӼ���),����ʹ�����߱��ϵ������õ�ƽ̨������Ч������
		SELECT ParentDealerId,
			@ValidDate2,
			Round(SUM(Largess/CASE ISNULL(Ratio,0) WHEN 0 THEN 1 ELSE Ratio END),0) Largess
		FROM #TMP_Largess A
		WHERE EXISTS (SELECT 1 FROM DealerMaster B WHERE A.DealerId = B.DMA_ID AND B.DMA_DealerType = 'T2')
		GROUP BY ParentDealerId,ValidDate
		
		--�������������ƽ̨�Ļ���ʹ�÷�Χ�ǲ�Ʒ��˵��ƽ̨��һ������Χһ�£���ƽ̨���ݷŵ�#TMP_Largessһ������
		IF @PointUseRange <>'BU'
		BEGIN
			INSERT INTO #TMP_Largess(DealerId,ValidDate,Largess)
			SELECT ParentDealerId,ValidDate,Largess FROM #TMP_Largess_Parent
		END
				
		--�����л��ֳ�չ����������ID��UPN����ͬ��������Money��Point)
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
		
		--����һ���������̵Ļ���(���ܰ���ƽ̨���ݣ����ƽ̨����ʹ�÷�Χ��һ����һ�µĻ���start**********************************
		--����ǰ���߲�ֵ�UPN
		INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@UseRangePolicyFactorId)
		SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --��ǰ���ߵ�UPN����
		
		--�ҵ��Ѵ��ڵ���Ʒ��
		/* 
		--20161030 begin huakaichun ���ۼ���Ʒ���޸ĳɲ��ۼ�
		INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
		SELECT A.DLID,A.DealerId,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
		FROM #TMP_DLID_UPN A 
		LEFT JOIN (SELECT * FROM #TMP_Largess X,#TMP_UPN Y) B ON A.DealerId = B.DealerId AND A.UPN = B.UPN
		GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
		--end huakaichun ���ۼ���Ʒ���޸ĳɲ��ۼ�
		*/
		
		
		--��������ҵ��������ϵ���Ʒ�أ�ֻ���ۼ�1����
		INSERT INTO #TMP_FOUND(DLID,DEALERID)
		SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
		
		SELECT @INSERTDATE = CONVERT(NVARCHAR(19),GETDATE(),121)
		
		--û���ҵ���ͬ��Ʒ��Χ�ľ����̻��ּ�¼
		INSERT INTO Promotion.PRO_DEALER_POINT(DEALERID,PointType,BU,CreateTime,ModifyDate,Remark1)
		SELECT DISTINCT DealerId,CASE WHEN EXISTS(SELECT 1 FROM DealerMaster WHERE DMA_ID=DealerId AND DMA_DealerType='LP') THEN 'Point' ELSE @ifCalRebateAR END,@BU,@INSERTDATE,@INSERTDATE,@PolicyId
		FROM #TMP_Largess A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.DealerId)
		
		--INSERT��Ʒʹ�÷�Χ��
		INSERT INTO Promotion.PRO_DEALER_POINT_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
		SELECT DISTINCT A.DLid,B.ConditionId,B.OperTag,B.ConditionValue 
		FROM Promotion.PRO_DEALER_POINT A,Promotion.PRO_POLICY_FACTOR_CONDITION B,#TMP_Largess C
		WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		AND A.DEALERID = C.DEALERID AND B.PolicyFactorId = isnull(@UseRangePolicyFactorId,0)
		AND NOT EXISTS (SELECT * FROM Promotion.PRO_DEALER_POINT_DETAIL WHERE DLid = A.DLid)
		
		--���������β��Ļ��������¼������ʱ��
		INSERT INTO #TMP_FOUND(DLID,DEALERID)
		SELECT DLID,DEALERID FROM Promotion.PRO_DEALER_POINT A 
		WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		
		--�ҵ���ͬ����Ч�ڼ�¼�����ӻ���
		UPDATE D SET PointAmount = PointAmount + ISNULL(B.Largess,0),
			ModifyDate = GETDATE()
		FROM Promotion.PRO_DEALER_POINT A,#TMP_Largess B,#TMP_FOUND C,Promotion.PRO_DEALER_POINT_SUB D
		WHERE A.DEALERID = B.DEALERID AND A.DLID = D.DLID AND A.DLID = C.DLID 
		AND B.VALIDDATE = D.ValidDate 
		
		--��ͬ��Ʒ��Χ�ģ���û����ͬ��Ч�ڵľ�������
		INSERT INTO Promotion.PRO_DEALER_POINT_SUB(DLid,ValidDate,PointAmount,OrderAmount,OtherAmount,
			CreateTime,ModifyDate,Status)
		SELECT B.DLID,A.VALIDDATE,A.Largess,0,0,
			GETDATE(),GETDATE(),1 FROM #TMP_Largess A,#TMP_FOUND B
		WHERE A.DEALERID = B.DEALERID 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_DEALER_POINT_SUB WHERE DLID = B.DLID AND VALIDDATE = A.VALIDDATE)
		
		INSERT INTO promotion.PRO_DEALER_POINT_LOG 
			(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
		SELECT b.DLid,'���߽���', @PolicyId,a.DealerId,@runPeriod,a.Largess,getdate(),[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.DealerId,@runPeriod)
		FROM #TMP_Largess A,promotion.PRO_DEALER_POINT B,#TMP_FOUND C
		WHERE A.DEALERID = B.DEALERID AND B.DLID = C.DLID
		AND CONVERT(NVARCHAR(19),B.CreateTime,121) = @INSERTDATE AND B.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		
		--����һ���������̵Ļ���(���ܰ���ƽ̨���ݣ����ƽ̨����ʹ�÷�Χ��һ����һ�µĻ���end**********************************
		
		--����ƽ̨�Ļ��֣�����ƽ̨����������ʹ�÷�Χ����˲������������һ���������ֳص��߼���.START****************************
		IF @PointUseRange = 'BU'
		BEGIN
			DELETE FROM #TMP_UPN
			DELETE FROM #TMP_FOUND_TMP
			DELETE FROM #TMP_FOUND
			
			--����ǰ���ߵ�BU��ֵ�UPN
			INSERT INTO #TMP_UPN(UPN) select distinct CFN_CustomerFaceNbr
			from CFN a inner join V_DivisionProductLineRelation b on a.CFN_ProductLine_BUM_ID=b.ProductLineID
			where b.IsEmerging='0' and b.DivisionName = @BU
			
			SELECT @ICOUNT_UPN = COUNT(*) FROM #TMP_UPN --��ǰ���ߵ�UPN����
			
			--�ҵ��Ѵ��ڵ���Ʒ��
			/* 
			--20161030 begin huakaichun ���ۼ���Ʒ���޸ĳɲ��ۼ�
			INSERT INTO #TMP_FOUND_TMP(DLID,DEALERID) SELECT DLID,DEALERID FROM (
			SELECT A.DLID,A.DealerId,COUNT(*) CNT,SUM(CASE ISNULL(B.UPN,'') WHEN '' THEN 0 ELSE 1 END) SM
			FROM #TMP_DLID_UPN A 
			LEFT JOIN (SELECT * FROM #TMP_Largess_Parent X,#TMP_UPN Y) B ON A.ParentDealerId = B.DealerId AND A.UPN = B.UPN
			GROUP BY A.DLID,A.DEALERID) T WHERE CNT = SM AND CNT = @ICOUNT_UPN
			--end huakaichun ���ۼ���Ʒ���޸ĳɲ��ۼ�
			*/
			
			--��������ҵ��������ϵ���Ʒ�أ�ֻ���ۼ�1����
			INSERT INTO #TMP_FOUND(DLID,DEALERID)
			SELECT DLID,DEALERID FROM (SELECT DLID,DEALERID,ROW_NUMBER() OVER(PARTITION BY DEALERID ORDER BY DLID) RN FROM #TMP_FOUND_TMP) T WHERE RN = 1
			
			SELECT @INSERTDATE = CONVERT(NVARCHAR(19),GETDATE(),121)
			
			--û���ҵ���ͬ��Ʒ��Χ�ľ����̻��ּ�¼
			INSERT INTO Promotion.PRO_DEALER_POINT(DEALERID,PointType,BU,CreateTime,ModifyDate,Remark1)
			SELECT DISTINCT ParentDealerId,CASE WHEN EXISTS(SELECT 1 FROM DealerMaster WHERE DMA_ID=ParentDealerId AND DMA_DealerType='LP') THEN 'Point' ELSE @ifCalRebateAR END,@BU,@INSERTDATE,@INSERTDATE,@PolicyId
			FROM #TMP_Largess_Parent A WHERE NOT EXISTS (SELECT * FROM #TMP_FOUND WHERE DEALERID = A.ParentDealerId)
			
			--INSERT��Ʒʹ�÷�Χ��
			SELECT @BUUseRange = 
				STUFF(REPLACE(REPLACE((
					SELECT HIER FROM (
						select distinct 'LEVEL1,'+a.CFN_Level1Code HIER
						from CFN a inner join V_DivisionProductLineRelation b on a.CFN_ProductLine_BUM_ID=b.ProductLineID
						where b.IsEmerging='0' and b.DivisionName = @BU) T
					FOR XML AUTO), '<T HIER="','|'), '"/>', ''), 1, 1, '')
		
			INSERT INTO Promotion.PRO_DEALER_POINT_DETAIL(DLid,ConditionId,OperTag,ConditionValue)
			SELECT DISTINCT A.DLid,3,'����',@BUUseRange
			FROM Promotion.PRO_DEALER_POINT A,#TMP_Largess_Parent C
			WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
			AND A.DEALERID = C.ParentDealerId 
			AND NOT EXISTS (SELECT * FROM Promotion.PRO_DEALER_POINT_DETAIL WHERE DLid = A.DLid)
			
			--���������β��Ļ��������¼������ʱ��
			INSERT INTO #TMP_FOUND(DLID,DEALERID)
			SELECT DLID,DEALERID FROM Promotion.PRO_DEALER_POINT A,#TMP_Largess_Parent B
			WHERE CONVERT(NVARCHAR(19),A.CreateTime,121) = @INSERTDATE AND A.Remark1 = CONVERT(NVARCHAR,@PolicyId)
			AND A.DEALERID = B.ParentDealerId
			AND NOT EXISTS (SELECT 1 FROM #TMP_FOUND WHERE DEALERID = B.ParentDealerId)
			
			--�ҵ���ͬ����Ч�ڼ�¼�����ӻ���
			UPDATE D SET PointAmount = PointAmount + ISNULL(B.Largess,0),
				ModifyDate = GETDATE()
			FROM Promotion.PRO_DEALER_POINT A,#TMP_Largess_Parent B,#TMP_FOUND C,Promotion.PRO_DEALER_POINT_SUB D
			WHERE A.DEALERID = B.ParentDealerId AND A.DLID = D.DLID AND A.DLID = C.DLID 
			AND B.VALIDDATE = D.ValidDate
			
			--��ͬ��Ʒ��Χ�ģ���û����ͬ��Ч�ڵľ�������
			INSERT INTO Promotion.PRO_DEALER_POINT_SUB(DLid,ValidDate,PointAmount,OrderAmount,OtherAmount,
				CreateTime,ModifyDate,Status)
			SELECT B.DLID,A.VALIDDATE,A.Largess,0,0,
				GETDATE(),GETDATE(),1 FROM #TMP_Largess_Parent A,#TMP_FOUND B
			WHERE A.ParentDealerId = B.DEALERID 
			AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_DEALER_POINT_SUB WHERE DLID = B.DLID AND VALIDDATE = A.VALIDDATE)
			
			INSERT INTO promotion.PRO_DEALER_POINT_LOG 
				(DLid,DLFrom,PolicyId,DEALERID,Period,Amount,LogDate,Remark)
			SELECT b.DLid,'���߽���', @PolicyId,a.ParentDealerId,@runPeriod,a.Largess,getdate(),[Promotion].[func_Pro_ProlicyClosingGetWFCode](@PolicyId,a.ParentDealerId,@runPeriod)
			FROM #TMP_Largess_Parent A,promotion.PRO_DEALER_POINT B,#TMP_FOUND C
			WHERE A.ParentDealerId = B.DEALERID AND B.DLID = C.DLID
			AND CONVERT(NVARCHAR(19),B.CreateTime,121) = @INSERTDATE AND B.Remark1 = CONVERT(NVARCHAR,@PolicyId)
		END
		--����ƽ̨�Ļ��֣�����ƽ̨����������ʹ�÷�Χ����˲������������һ���������ֳص��߼���.END****************************
	END
	
	--******************************�ƶ�����ʽ��*******************************************************************************
	EXEC Promotion.Proc_Pro_MoveData @PolicyId,'TMP','REP'
	
	--******************************��ռ����********************************************************************************
	SET @SQL = 'DELETE FROM '+@TMPTable
	PRINT @SQL
	EXEC(@SQL)
	
	SET @MSG = '��'+@runPeriod+'�������ѳɹ���'
	INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
	SELECT @PolicyId,'��ʽ','���˳ɹ�',@runPeriod,GETDATE(),GETDATE(),@MSG
	
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
    SET @vError = ISNULL(@error_procedure, '') + '��'
        + CONVERT(NVARCHAR(10), ISNULL(@error_line, '')) + '�г���[����ţ�'
        + CONVERT(NVARCHAR(10), ISNULL(@error_number, '')) + ']��'
        + ISNULL(@error_message, '')
    
    PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Closing Failed!' 
    
    INSERT INTO Promotion.PRO_CAL_LOG(PolicyId,CalModule,CalStatus,CalPeriod,StartTime,EndTime,Remark) 
		SELECT @PolicyId,'����','ʧ��',@runPeriod,GETDATE(),GETDATE(),@vError
        
END CATCH

GO


