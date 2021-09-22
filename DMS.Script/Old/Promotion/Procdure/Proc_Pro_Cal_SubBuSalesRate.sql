
DROP PROCEDURE [Promotion].[Proc_Pro_Cal_SubBuSalesRate]
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_SubBuSalesRate]
	@PolicyFactorId Int	--�������ر��
AS
BEGIN
	CREATE TABLE #TEMP 
	(
		DEALERID uniqueidentifier,
		HospitalId NVARCHAR(100),
		BU NVARCHAR(100),
		SUBBU NVARCHAR(100),
		DActual Money default 0 , --ʵ��ֲ��
		DPlan Money default 0 ,  --�ƻ�ֲ��
		DRate Money default 0    --����� =ʵ��ֲ�� /�ƻ�ֲ��
	)
	DECLARE @SQL NVARCHAR(MAX)
	
	DECLARE @PolicyId NVARCHAR(200) --���߱��
	DECLARE @CalModule NVARCHAR(100)--�������� ����ʽ��Ԥ�㣩
	DECLARE @Period NVARCHAR(100) --�������ڣ����ȣ��¶ȣ�
	DECLARE @BU NVARCHAR(50) --��Ʒ��
	DECLARE @SUBBU NVARCHAR(50) --��Ʒ����
	DECLARE @ifCalPurchaseAR NVARCHAR(100) --��������Ʒ�Ƿ�����ֲ����	
	DECLARE @CurrentPeriod NVARCHAR(100) --�����Ѽ�������
	DECLARE @StartDate NVARCHAR(10) --������ʼʱ��
	DECLARE @CalType NVARCHAR(10) --�������� (ByDealer��ByHospital)
	
	DECLARE @runPeriod NVARCHAR(100) --���μ�������
	DECLARE @BeginYearMonth NVARCHAR(100) 
	
	/*���ղ�Ʒ����ҵ�ɹ�����ʣ�����Ҫ���ִ�������ByDealer/ByHospital�������Ǹ��µ������̼�����ҽԺ����
	*/
	SELECT @PolicyId=A.PolicyId,@CalModule=A.CalModule,@Period=A.Period,@BU=A.BU ,@ifCalPurchaseAR=A.ifCalPurchaseAR,@CurrentPeriod=CurrentPeriod,
		@StartDate=StartDate,@SUBBU=A.SubBu,@CalType=A.CalType
	FROM Promotion.PRO_POLICY A,Promotion.PRO_POLICY_FACTOR B
	WHERE A.PolicyId =B.PolicyId AND B.PolicyFactorId = @PolicyFactorId
	
	IF ISNULL(@CurrentPeriod,'') = ''
	SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	ELSE
	SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
	
	DECLARE @UpdateTabeName NVARCHAR(100)
	IF @CalModule = '��ʽ'
	BEGIN
		SELECT @UpdateTabeName=TempTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END
	ELSE
	BEGIN
		SELECT @UpdateTabeName=PreTableName FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId
	END
	
	CREATE TABLE #TMP_DEALER
	(
		DEALERID UNIQUEIDENTIFIER
	)
	SET @SQL = N'INSERT INTO #TMP_DEALER(DEALERID) SELECT DISTINCT DEALERID FROM '+@UpdateTabeName
	EXEC(@SQL)
	
	IF ISNULL(@SUBBU,'')<>''
	BEGIN
		IF @CalType='ByDealer'
		BEGIN
			INSERT INTO #TEMP (DEALERID,BU,SUBBU)
			 	SELECT DEALERID,@BU,@SUBBU FROM #TMP_DEALER
				
			IF @Period='�¶�'
			BEGIN
				UPDATE D SET DActual=A.MActual ,DPlan=A.MPlan,DRate=A.MRate_D
				FROM #TEMP D,[interface].[T_I_QV_DealerHospital_Quota] A,DealerMaster B ,V_DivisionProductLineRelation C
				WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND	C.DivisionCode=A.Division AND C.IsEmerging='0' 
					AND C.DivisionName=D.BU AND A.SubDept=D.SUBBU
					AND A.YearMonth=@runPeriod
			END
			IF @Period='����'
			BEGIN
				SELECT TOP 1 @BeginYearMonth=YearMonth FROM [interface].[T_I_QV_DealerHospital_Quota] WHERE YearMonth IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY YearMonth DESC
				UPDATE D SET DActual=A.QTDActual ,DPlan=A.QTDPlan,DRate=A.QTDRate_D
				FROM #TEMP D,
				[interface].[T_I_QV_DealerHospital_Quota]  A,
				DealerMaster B ,
				V_DivisionProductLineRelation C 
				WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND	C.DivisionCode=A.Division AND C.IsEmerging='0' 
					AND C.DivisionName=D.BU AND A.SubDept=D.SUBBU AND A.YearMonth=@BeginYearMonth
			END
			
		END
		ELSE IF @CalType='ByHospital'
		BEGIN
			IF @Period='�¶�'
			BEGIN
				INSERT INTO #TEMP (DEALERID,HospitalId,BU,SUBBU,DActual,DPlan,DRate)
				SELECT DMA_ID,A.HospitalCode,@BU,@SUBBU,A.MActual,A.MPlan,A.MRate_D 
				FROM interface.T_I_QV_Hospital_Quota A
				INNER JOIN DealerMaster b ON A.SAPCode=B.DMA_SAP_Code
				INNER JOIN #TMP_DEALER C ON C.DEALERID=B.DMA_ID 
				INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.DivisionCode=A.Division
				--INNER JOIN Hospital E ON E.HOS_Key_Account=A.HospitalCode
				WHERE a.YearMonth=@runPeriod
				AND D.DivisionName=@BU
				AND A.SubDept=@SUBBU
			END
			IF @Period='����'
			BEGIN
				SELECT TOP 1 @BeginYearMonth=YearMonth FROM [interface].[T_I_QV_DealerHospital_Quota] WHERE YearMonth IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY YearMonth DESC
				INSERT INTO #TEMP (DEALERID,HospitalId,BU,SUBBU,DActual,DPlan,DRate)
				SELECT DMA_ID,A.HospitalCode,@BU,@SUBBU,A.QTDActual,A.QTDPlan,A.QTDRate_D  
				FROM interface.T_I_QV_Hospital_Quota A
				INNER JOIN DealerMaster b ON A.SAPCode=B.DMA_SAP_Code
				INNER JOIN #TMP_DEALER C ON C.DEALERID=B.DMA_ID 
				INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.DivisionCode=A.Division
				--INNER JOIN Hospital E ON E.HOS_Key_Account=A.HospitalCode
				WHERE a.YearMonth=@BeginYearMonth
				AND D.DivisionName=@BU
				AND A.SubDept=@SUBBU
			END
		END
	END
	ELSE
	BEGIN
		IF @CalType='ByDealer'
		BEGIN
			INSERT INTO #TEMP (DEALERID,BU)
			SELECT DEALERID,@BU FROM #TMP_DEALER
			
			IF @Period='�¶�'
			BEGIN
				UPDATE D SET DActual=A.MActual ,DPlan=A.MPlan,DRate=A.MRate_D
				FROM #TEMP D,(SELECT SAPCode,Division,YearMonth,SUM(MActual) AS [MActual],SUM(MPlan) AS [MPlan],
				CASE ISNULL(SUM(MPlan),0) WHEN 0 THEN 0 ELSE (SUM(MActual)/SUM(MPlan)) END AS [MRate_D] 
				FROM [interface].[T_I_QV_DealerHospital_Quota] WHERE YearMonth=@runPeriod GROUP BY SAPCode,Division,YearMonth) A,DealerMaster B ,V_DivisionProductLineRelation C
				WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND	C.DivisionCode=A.Division AND C.IsEmerging='0' 
					AND C.DivisionName=D.BU 
					AND A.YearMonth=@runPeriod
			END
			IF @Period='����'
			BEGIN
				SELECT TOP 1 @BeginYearMonth=YearMonth FROM [interface].[T_I_QV_DealerHospital_Quota] WHERE YearMonth IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY YearMonth DESC
				UPDATE D SET DActual=A.QTDActual ,DPlan=A.QTDPlan,DRate=A.QTDRate_D
				FROM #TEMP D,
				(SELECT SAPCode,Division,YearMonth,SUM(QTDActual) AS [QTDActual],SUM(QTDPlan) AS [QTDPlan],
				CASE ISNULL(SUM(QTDPlan),0) WHEN 0 THEN 0 ELSE (SUM(QTDActual)/SUM(QTDPlan)) END AS [QTDRate_D] FROM [interface].[T_I_QV_DealerHospital_Quota] WHERE YearMonth=@BeginYearMonth GROUP BY SAPCode,Division,YearMonth)  A,
				DealerMaster B ,
				V_DivisionProductLineRelation C 
				WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND	C.DivisionCode=A.Division AND C.IsEmerging='0' 
					AND C.DivisionName=D.BU AND A.YearMonth=@BeginYearMonth
			END
			
		END
		ELSE IF @CalType='ByHospital'
		BEGIN
			IF @Period='�¶�'
			BEGIN
				INSERT INTO #TEMP (DEALERID,HospitalId,BU,DActual,DPlan,DRate)
				SELECT DMA_ID,A.HospitalCode,@BU,A.MActual,A.MPlan,A.MRate_D 
				FROM (SELECT SAPCode,Division,HospitalCode,YearMonth,SUM(MActual) AS [MActual],SUM(MPlan) AS [MPlan],
				CASE ISNULL(SUM(MPlan),0) WHEN 0 THEN 0 ELSE (SUM(MActual)/SUM(MPlan)) END AS [MRate_D]  FROM interface.T_I_QV_Hospital_Quota WHERE YearMonth=@runPeriod GROUP BY SAPCode,Division,HospitalCode,YearMonth) A
				INNER JOIN DealerMaster b ON A.SAPCode=B.DMA_SAP_Code
				INNER JOIN #TMP_DEALER C ON C.DEALERID=B.DMA_ID 
				INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.DivisionCode=A.Division
				--INNER JOIN Hospital E ON E.HOS_Key_Account=A.HospitalCode
				WHERE a.YearMonth=@runPeriod
				AND D.DivisionName=@BU
				
			END
			IF @Period='����'
			BEGIN
				SELECT TOP 1 @BeginYearMonth=YearMonth FROM [interface].[T_I_QV_DealerHospital_Quota] WHERE YearMonth IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY YearMonth DESC
				INSERT INTO #TEMP (DEALERID,HospitalId,BU,DActual,DPlan,DRate)
				SELECT DMA_ID,A.HospitalCode,@BU,A.QTDActual,A.QTDPlan,A.QTDRate_D 
				FROM (SELECT SAPCode,Division,HospitalCode,YearMonth,SUM(QTDActual) AS [QTDActual],SUM(QTDPlan) AS [QTDPlan],
				CASE ISNULL(SUM(QTDPlan),0) WHEN 0 THEN 0 ELSE (SUM(QTDActual)/SUM(QTDPlan)) END AS [QTDRate_D]  FROM interface.T_I_QV_Hospital_Quota WHERE YearMonth=@BeginYearMonth GROUP BY SAPCode,Division,HospitalCode,YearMonth) A
				INNER JOIN DealerMaster b ON A.SAPCode=B.DMA_SAP_Code
				INNER JOIN #TMP_DEALER C ON C.DEALERID=B.DMA_ID 
				INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.DivisionCode=A.Division
				--INNER JOIN Hospital E ON E.HOS_Key_Account=A.HospitalCode
				WHERE a.YearMonth=@BeginYearMonth
				AND D.DivisionName=@BU
				
			END
		END
	END
	
	DECLARE @SourceColumn NVARCHAR(100)
	DECLARE @ColumnName NVARCHAR(100)
	DECLARE @SQLUpdate NVARCHAR(max)
	DECLARE @ByHospitalSQL  NVARCHAR(500)
	IF @CalType='ByDealer'
	BEGIN
		SET @ByHospitalSQL='';
	END
	IF @CalType='ByHospital'
	BEGIN
		SET @ByHospitalSQL=' AND a.HospitalId =b.HospitalId ';
	END
	
	SET @SQL ='UPDATE b '
	SET @SQLUpdate =''
	
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT SourceColumn,ColumnName FROM [PROMOTION].[func_Pro_Utility_getColumnName](@PolicyFactorId,@runPeriod)
	OPEN @PRODUCT_CUR
	FETCH NEXT FROM @PRODUCT_CUR INTO @SourceColumn,@ColumnName
	WHILE @@FETCH_STATUS = 0        
		BEGIN 
		  IF @SourceColumn='DPlan'
		  BEGIN
			IF LEN (@SQLUpdate)=0
			BEGIN
				SET @SQLUpdate+= (' SET '+@ColumnName+'= a.DPlan  ,')
			END
			ELSE
			BEGIN
				SET @SQLUpdate+= (@ColumnName+'= a.DPlan  ,')
			END
			
		  END
		  IF @SourceColumn='DActual'
		  BEGIN
			IF LEN (@SQLUpdate)=0
			BEGIN
				SET @SQLUpdate+= (' SET '+@ColumnName+'= a.DActual  ,')
			END
			ELSE
			BEGIN
				SET @SQLUpdate+= (@ColumnName+'= a.DActual  ,')
			END
			
		  END
		  IF @SourceColumn='DRate'
		  BEGIN
			IF LEN (@SQLUpdate)=0
			BEGIN
				SET @SQLUpdate+= (' SET '+@ColumnName+'= a.DRate  ,')
			END
			ELSE
			BEGIN
				SET @SQLUpdate+= (@ColumnName+'= a.DRate  ,')
			END
			
		  END
		FETCH NEXT FROM @PRODUCT_CUR INTO @SourceColumn,@ColumnName
		END
	CLOSE @PRODUCT_CUR
	DEALLOCATE @PRODUCT_CUR ;
	SET @SQLUpdate=SUBSTRING(@SQLUpdate,0,LEN(@SQLUpdate)-1)
	SET @SQL+=@SQLUpdate;
	SET @SQL+= (' FROM #TEMP a,'+@UpdateTabeName+' b WHERE a.DEALERID=b.DealerId'+@ByHospitalSQL) 
	PRINT @SQL
	EXEC(@SQL) 
	RETURN 
END

GO


