DROP PROCEDURE [Promotion].[Proc_Pro_Cal_SubBuSalesAmount]
GO





/**********************************************
	功能：计算产品线医院植入总金额
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_SubBuSalesAmount]
	@PolicyFactorId Int	--政策因素编号
AS
BEGIN
	CREATE TABLE #TEMP 
	(
		DEALERID uniqueidentifier,
		HospitalId NVARCHAR(100),
		BU NVARCHAR(100),
		SUBBU NVARCHAR(100),
		DActual Money --医院植入金额
	)
	DECLARE @SQL NVARCHAR(MAX)
	
	DECLARE @PolicyId NVARCHAR(200) --政策编号
	DECLARE @CalModule NVARCHAR(100)--计算类型 （正式、预算）
	DECLARE @Period NVARCHAR(100) --计算周期（季度，月度）
	DECLARE @BU NVARCHAR(50) --产品线
	DECLARE @SUBBU NVARCHAR(50) --产品分类
	DECLARE @ifCalPurchaseAR NVARCHAR(100) --本政策赠品是否算入植入达成	
	DECLARE @CurrentPeriod NVARCHAR(100) --最新已计算周期
	DECLARE @StartDate NVARCHAR(10) --促销开始时间
	DECLARE @CalType NVARCHAR(10) --促销类型 (ByDealer、ByHospital)
	
	DECLARE @runPeriod NVARCHAR(100) --本次计算日期
	DECLARE @BeginYearMonth NVARCHAR(100) 
	
	/*参照产品线商业采购达标率，但是要区分此政策是ByDealer/ByHospital来决定是更新到经销商级别还是医院级别
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
	IF @CalModule = '正式'
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
			
			IF @Period='月度'
			BEGIN
				UPDATE D SET DActual=A.MActual 
				FROM #TEMP D,[interface].[T_I_QV_DealerHospital_Quota] A,DealerMaster B ,V_DivisionProductLineRelation C
				WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND	C.DivisionCode=A.Division AND C.IsEmerging='0' 
					AND C.DivisionName=D.BU AND A.SubDept=D.SUBBU
					AND A.YearMonth=@runPeriod
			END
			IF @Period='季度'
			BEGIN
				SELECT TOP 1 @BeginYearMonth=YearMonth FROM [interface].[T_I_QV_DealerHospital_Quota] WHERE YearMonth IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY YearMonth DESC
				UPDATE D SET DActual=A.QTDActual 
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
			IF @Period='月度'
			BEGIN
				INSERT INTO #TEMP (DEALERID,HospitalId,BU,SUBBU,DActual)
				SELECT DMA_ID,A.HospitalCode,@BU,@SUBBU,A.MActual
				FROM interface.T_I_QV_Hospital_Quota A
				INNER JOIN DealerMaster b ON A.SAPCode=B.DMA_SAP_Code
				INNER JOIN #TMP_DEALER C ON C.DEALERID=B.DMA_ID 
				INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.DivisionCode=A.Division
				--INNER JOIN Hospital E ON E.HOS_Key_Account=A.HospitalCode
				WHERE a.YearMonth=@runPeriod
				AND D.DivisionName=@BU
				AND A.SubDept=@SUBBU
			END
			IF @Period='季度'
			BEGIN
				SELECT TOP 1 @BeginYearMonth=YearMonth FROM [interface].[T_I_QV_DealerHospital_Quota] WHERE YearMonth IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY YearMonth DESC
				INSERT INTO #TEMP (DEALERID,HospitalId,BU,SUBBU,DActual)
				SELECT DMA_ID,A.HospitalCode,@BU,@SUBBU,A.MActual
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
			--INSERT INTO #TEMP (DEALERID,BU)
			--SELECT DISTINCT DEALERID ,@BU FROM #TMP_DEALER
			
			IF @Period='月度'
			BEGIN
				INSERT INTO #TEMP (DEALERID,BU,DActual)
				SELECT D.DEALERID,C.DivisionName,SUM(A.MActual) FROM #TMP_DEALER D 
				INNER JOIN DealerMaster B ON D.DEALERID=B.DMA_ID
				INNER JOIN [interface].[T_I_QV_DealerHospital_Quota] A ON A.SAPCode=B.DMA_SAP_Code 
				INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND C.DivisionCode=A.Division
				WHERE A.YearMonth=@runPeriod
				AND C.DivisionName=@BU
				GROUP BY D.DEALERID,C.DivisionName
				
				--UPDATE D SET DActual= SUM(A.MActual) 
				--FROM #TEMP D,[interface].[T_I_QV_DealerHospital_Quota] A,DealerMaster B ,V_DivisionProductLineRelation C
				--WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND	C.DivisionCode=A.Division AND C.IsEmerging='0' 
				--	AND C.DivisionName=D.BU 
				--	AND A.YearMonth=@runPeriod
			END
			IF @Period='季度'
			BEGIN
				SELECT TOP 1 @BeginYearMonth=YearMonth FROM [interface].[T_I_QV_DealerHospital_Quota] WHERE YearMonth IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY YearMonth DESC
				
				INSERT INTO #TEMP (DEALERID,BU,DActual)
				SELECT D.DEALERID,C.DivisionName,SUM(A.QTDActual) FROM #TMP_DEALER D 
				INNER JOIN DealerMaster B ON D.DEALERID=B.DMA_ID
				INNER JOIN [interface].[T_I_QV_DealerHospital_Quota] A ON A.SAPCode=B.DMA_SAP_Code 
				INNER JOIN V_DivisionProductLineRelation C ON C.IsEmerging='0' AND C.DivisionCode=A.Division
				WHERE A.YearMonth=@BeginYearMonth
				AND C.DivisionName=@BU
				GROUP BY D.DEALERID,C.DivisionName
				
				--UPDATE D SET DActual=SUM(A.QTDActual) 
				--FROM #TEMP D,
				--[interface].[T_I_QV_DealerHospital_Quota]  A,
				--DealerMaster B ,
				--V_DivisionProductLineRelation C 
				--WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND	C.DivisionCode=A.Division AND C.IsEmerging='0' 
				--	AND C.DivisionName=D.BU AND A.YearMonth=@BeginYearMonth
			END
			
		END
		ELSE IF @CalType='ByHospital'
		BEGIN
			IF @Period='月度'
			BEGIN
				INSERT INTO #TEMP (DEALERID,HospitalId,BU,DActual)
				SELECT DMA_ID,A.HospitalCode,@BU,SUM(A.MActual)
				FROM interface.T_I_QV_Hospital_Quota A
				INNER JOIN DealerMaster b ON A.SAPCode=B.DMA_SAP_Code
				INNER JOIN #TMP_DEALER C ON C.DEALERID=B.DMA_ID 
				INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.DivisionCode=A.Division
				--INNER JOIN Hospital E ON E.HOS_Key_Account=A.HospitalCode
				WHERE a.YearMonth=@runPeriod
				AND D.DivisionName=@BU
				GROUP BY B.DMA_ID,HospitalCode
			END
			IF @Period='季度'
			BEGIN
				SELECT TOP 1 @BeginYearMonth=YearMonth FROM [interface].[T_I_QV_DealerHospital_Quota] WHERE YearMonth IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY YearMonth DESC
				INSERT INTO #TEMP (DEALERID,HospitalId,BU,DActual)
				SELECT DMA_ID,A.HospitalCode,@BU,SUM(A.MActual)
				FROM interface.T_I_QV_Hospital_Quota A
				INNER JOIN DealerMaster b ON A.SAPCode=B.DMA_SAP_Code
				INNER JOIN #TMP_DEALER C ON C.DEALERID=B.DMA_ID 
				INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.DivisionCode=A.Division
				--INNER JOIN Hospital E ON E.HOS_Key_Account=A.HospitalCode
				WHERE a.YearMonth=@BeginYearMonth
				AND D.DivisionName=@BU
				GROUP BY B.DMA_ID,A.HospitalCode
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
		
		FETCH NEXT FROM @PRODUCT_CUR INTO @SourceColumn,@ColumnName
		END
	CLOSE @PRODUCT_CUR
	DEALLOCATE @PRODUCT_CUR ;
	SET @SQLUpdate=SUBSTRING(@SQLUpdate,0,LEN(@SQLUpdate)-1)
	SET @SQL+=@SQLUpdate;
	SET @SQL+= (' FROM #TEMP a,'+@UpdateTabeName+' b WHERE a.DEALERID=b.DealerId'+@ByHospitalSQL) 
	
	EXEC (@SQL);
	PRINT @SQL;
	RETURN 
END


GO


