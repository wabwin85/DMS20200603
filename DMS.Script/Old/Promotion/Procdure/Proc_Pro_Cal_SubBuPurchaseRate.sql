DROP PROCEDURE [Promotion].[Proc_Pro_Cal_SubBuPurchaseRate]
GO





/**********************************************
	���ܣ������Ʒ����ҵ�ɹ������
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_SubBuPurchaseRate]
	@PolicyFactorId Int	--�������ر��
AS
BEGIN
	CREATE TABLE #TEMP 
	(
		DEALERID uniqueidentifier,
		BU NVARCHAR(100),
		SUBBU NVARCHAR(100),
		DActual Money , --ʵ�ʲɹ�
		DPlan Money ,  --�ƻ��ɹ�
		DRate Money    --����� =ʵ�ʲɹ�/�ƻ��ɹ�
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
	
	DECLARE @runPeriod NVARCHAR(100) --���μ�������
	
	
	--STEP1:ͨ��PolicyId�����߱�����ز���(��������\����BU\��ǰ��������ĸ��ڼ�
	SELECT @PolicyId=A.PolicyId,@CalModule=A.CalModule,@Period=A.Period,@BU=A.BU ,@ifCalPurchaseAR=A.ifCalPurchaseAR,@CurrentPeriod=CurrentPeriod,
		@StartDate=StartDate,@SUBBU=A.SubBu
	FROM Promotion.PRO_POLICY A,Promotion.PRO_POLICY_FACTOR B
	WHERE A.PolicyId =B.PolicyId AND B.PolicyFactorId = @PolicyFactorId
	
	DECLARE @UpdateTabeName NVARCHAR(100)
	IF @CalModule='��ʽ'
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
	
	--STEP2:���漰�����ߵľ����̵Ĳ�Ʒ����ҵ�ɹ���������ɵ�#TMP��
	--2.1 ά����Ҫ���㾭���̵�Temp��
	INSERT INTO #TEMP (DEALERID,BU,SUBBU)
	SELECT DEALERID ,@BU,@SUBBU FROM #TMP_DEALER
	
	--2.2 ά��������
	DECLARE @BeginYearMonth NVARCHAR(100) 
	IF ISNULL(@CurrentPeriod,'') = ''
	SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate)
	ELSE
	SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
		
	IF ISNULL(@SUBBU,'')<>''
	BEGIN
		IF @Period='�¶�'
		BEGIN
			UPDATE D SET DActual=A.���²ɹ�_RMB_D ,DPlan=A.����ָ���_RMB_D,DRate=A.DQuotaM_D
			FROM #TEMP D,[interface].[T_I_QV_Dealer_Quota_B] A,DealerMaster B 
			WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND A.��������=D.BU AND A.SubDept=D.SUBBU
			AND A.����=@runPeriod
		END
		IF @Period='����'
		BEGIN
			
			SELECT TOP 1 @BeginYearMonth=����  FROM [interface].[T_I_QV_Dealer_Quota_B] WHERE ���� IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY ���� DESC 
			UPDATE D SET DActual=A.���Ȳɹ�_RMB_D ,DPlan=A.����ָ���_RMB_D,DRate=A.DQuotaQ_D
			FROM #TEMP D,
			[interface].[T_I_QV_Dealer_Quota_B] A,
			DealerMaster B 
			WHERE A.SAPCode=B.DMA_SAP_Code  AND D.DEALERID=B.DMA_ID AND A.��������=D.BU AND A.SubDept=D.SUBBU AND A.����=@BeginYearMonth
			
		END
	END
	ELSE
	BEGIN
		IF @Period='�¶�'
		BEGIN
			UPDATE D SET DActual=A.���²ɹ�_RMB_D ,DPlan=A.����ָ���_RMB_D,DRate=A.DQuotaM_D
			FROM #TEMP D,(SELECT SAPCode,��������,����,SUM(���²ɹ�_RMB_D) AS [���²ɹ�_RMB_D], SUM(����ָ���_RMB_D) AS [����ָ���_RMB_D],SUM(DQuotaM_D)  AS DQuotaM_D FROM [interface].[T_I_QV_Dealer_Quota_B] WHERE ����=@runPeriod  GROUP BY SAPCode,��������,���� ) A,DealerMaster B 
			WHERE A.SAPCode=B.DMA_SAP_Code AND D.DEALERID=B.DMA_ID AND A.��������=D.BU 
			AND A.����=@runPeriod
		END
		IF @Period='����'
		BEGIN
			
			SELECT TOP 1 @BeginYearMonth=����  FROM [interface].[T_I_QV_Dealer_Quota_B] WHERE ���� IN (SELECT IYearMonth FROM  [Promotion].[func_Pro_Utility_getPeriodForMonth](@Period,@runPeriod))  ORDER BY ���� DESC 
			UPDATE D SET DActual=A.���Ȳɹ�_RMB_D ,DPlan=A.����ָ���_RMB_D,DRate=A.DQuotaQ_D
			FROM #TEMP D,
			(SELECT SAPCode,��������,����,SUM(���Ȳɹ�_RMB_D) AS [���Ȳɹ�_RMB_D], SUM(����ָ���_RMB_D) AS [����ָ���_RMB_D],SUM(DQuotaQ_D)  AS [DQuotaQ_D] FROM [interface].[T_I_QV_Dealer_Quota_B] WHERE ����=@BeginYearMonth  GROUP BY SAPCode,��������,���� ) A,
			DealerMaster B 
			WHERE A.SAPCode=B.DMA_SAP_Code  AND D.DEALERID=B.DMA_ID AND A.��������=D.BU  AND A.����=@BeginYearMonth
			
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


