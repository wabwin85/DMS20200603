DROP PROCEDURE [Promotion].[Proc_Pro_Cal_SubBuPurchaseRate]
GO





/**********************************************
	功能：计算产品线商业采购达成率
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_SubBuPurchaseRate]
	@PolicyFactorId Int	--政策因素编号
AS
BEGIN
	CREATE TABLE #TEMP 
	(
		DEALERID uniqueidentifier,
		BU NVARCHAR(100),
		SUBBU NVARCHAR(100),
		DActual Money , --实际采购
		DPlan Money ,  --计划采购
		DRate Money    --达成率 =实际采购/计划采购
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
	
	DECLARE @runPeriod NVARCHAR(100) --本次计算日期
	
	
	--STEP1:通过PolicyId从政策表获得相关参数(计算粒度\所属BU\当前计算的是哪个期间
	SELECT @PolicyId=A.PolicyId,@CalModule=A.CalModule,@Period=A.Period,@BU=A.BU ,@ifCalPurchaseAR=A.ifCalPurchaseAR,@CurrentPeriod=CurrentPeriod,
		@StartDate=StartDate,@SUBBU=A.SubBu
	FROM Promotion.PRO_POLICY A,Promotion.PRO_POLICY_FACTOR B
	WHERE A.PolicyId =B.PolicyId AND B.PolicyFactorId = @PolicyFactorId
	
	DECLARE @UpdateTabeName NVARCHAR(100)
	IF @CalModule='正式'
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
	
	--STEP2:将涉及此政策的经销商的产品线商业采购达成率生成到#TMP表
	--2.1 维护需要计算经销商到Temp表
	INSERT INTO #TEMP (DEALERID,BU,SUBBU)
	SELECT DEALERID ,@BU,@SUBBU FROM #TMP_DEALER
	
	--2.2 维护经销商
	DECLARE @BeginYearMonth NVARCHAR(100) 
	IF ISNULL(@CurrentPeriod,'') = ''
	SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	ELSE
	SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
		
	IF ISNULL(@SUBBU,'')<>''
	BEGIN
		IF @Period='月度'
		BEGIN
			UPDATE D SET DActual=A.当月采购_RMB_D ,DPlan=A.当月指标额_RMB_D,DRate=A.DQuotaM_D
			FROM #TEMP D,[interface].[T_I_QV_Dealer_Quota_B] A,DealerMaster B 
			WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND A.部门名称=D.BU AND A.SubDept=D.SUBBU
			AND A.年月=@runPeriod
		END
		IF @Period='季度'
		BEGIN
			
			SELECT TOP 1 @BeginYearMonth=年月  FROM [interface].[T_I_QV_Dealer_Quota_B] WHERE 年月 IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY 年月 DESC 
			UPDATE D SET DActual=A.季度采购_RMB_D ,DPlan=A.季度指标额_RMB_D,DRate=A.DQuotaQ_D
			FROM #TEMP D,
			[interface].[T_I_QV_Dealer_Quota_B] A,
			DealerMaster B 
			WHERE A.SAPCode=B.DMA_SAP_Code  AND D.DEALERID=B.DMA_ID AND A.部门名称=D.BU AND A.SubDept=D.SUBBU AND A.年月=@BeginYearMonth
			
		END
	END
	ELSE
	BEGIN
		IF @Period='月度'
		BEGIN
			UPDATE D SET DActual=A.当月采购_RMB_D ,DPlan=A.当月指标额_RMB_D,DRate=A.DQuotaM_D
			FROM #TEMP D,(SELECT SAPCode,部门名称,年月,SUM(当月采购_RMB_D) AS [当月采购_RMB_D], SUM(当月指标额_RMB_D) AS [当月指标额_RMB_D],SUM(DQuotaM_D)  AS DQuotaM_D FROM [interface].[T_I_QV_Dealer_Quota_B] WHERE 年月=@runPeriod  GROUP BY SAPCode,部门名称,年月 ) A,DealerMaster B 
			WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND A.部门名称=D.BU 
			AND A.年月=@runPeriod
		END
		IF @Period='季度'
		BEGIN
			
			SELECT TOP 1 @BeginYearMonth=年月  FROM [interface].[T_I_QV_Dealer_Quota_B] WHERE 年月 IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY 年月 DESC 
			UPDATE D SET DActual=A.季度采购_RMB_D ,DPlan=A.季度指标额_RMB_D,DRate=A.DQuotaQ_D
			FROM #TEMP D,
			(SELECT SAPCode,部门名称,年月,SUM(季度采购_RMB_D) AS [季度采购_RMB_D], SUM(季度指标额_RMB_D) AS [季度指标额_RMB_D],SUM(DQuotaQ_D)  AS [DQuotaQ_D] FROM [interface].[T_I_QV_Dealer_Quota_B] WHERE 年月=@BeginYearMonth  GROUP BY SAPCode,部门名称,年月 ) A,
			DealerMaster B 
			WHERE A.SAPCode=B.DMA_SAP_Code  AND D.DEALERID=B.DMA_ID AND A.部门名称=D.BU  AND A.年月=@BeginYearMonth
			
		END
	END

	
	
	DECLARE @SourceColumn NVARCHAR(100)
	DECLARE @ColumnName NVARCHAR(100)
	DECLARE @SQLUpdate NVARCHAR(max)
	
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
	SET @SQL+= (' FROM #TEMP a,'+@UpdateTabeName+' b WHERE a.DEALERID=b.DealerId') 
	PRINT @SQL
	EXEC (@SQL)
END


GO


