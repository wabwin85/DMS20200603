DROP Procedure [interface].[P_I_EW_DCMS_GetAmendmentReturn]
GO


/*
平台收货确认数据处理
*/
Create Procedure [interface].[P_I_EW_DCMS_GetAmendmentReturn]
	@Contract_ID uniqueidentifier
AS
	DECLARE @Aop NVARCHAR(1000)
	DECLARE @AopTotal NVARCHAR(500)
	DECLARE @AopFormal NVARCHAR(1000)
	DECLARE @AopFormalTotal NVARCHAR(500) 
	
	DECLARE @Year NVARCHAR(20);
	DECLARE @Q1 decimal  ;
	DECLARE @Q2 decimal  ;
	DECLARE @Q3 decimal  ;
	DECLARE @Q4 decimal  ;
	DECLARE @DifferencesQ1 decimal  ;
	DECLARE @DifferencesQ2 decimal  ;
	DECLARE @DifferencesQ3 decimal  ;
	DECLARE @DifferencesQ4 decimal  ;
	
	DECLARE @RtnFormalVal NVARCHAR(4000);
	DECLARE @RtnDifferencesVal NVARCHAR(4000);
	

	CREATE TABLE #tbReturn
	(
		 Aop NVARCHAR(1000),
		 AopFormal NVARCHAR(1000),
		 AopDifferences NVARCHAR(1000),
	)
	
SET NOCOUNT ON
	BEGIN
	SELECT @Aop= interface.fn_I_EW_DCMS_GetDealerAOP(@Contract_ID);
	SET @RtnFormalVal='' 
	SET @RtnDifferencesVal=''
	
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
		SELECT	D.AOPD_Year,
			D.AOPD_Amount_1+ D.AOPD_Amount_2+D.AOPD_Amount_3 AS Q1,
			D.AOPD_Amount_4+ D.AOPD_Amount_5+D.AOPD_Amount_6 AS Q2,
			D.AOPD_Amount_7+ D.AOPD_Amount_8+D.AOPD_Amount_9 AS Q3,
			D.AOPD_Amount_10+ D.AOPD_Amount_11+D.AOPD_Amount_12 AS Q4,
			(TP.AOPD_Amount_1+ TP.AOPD_Amount_2+TP.AOPD_Amount_3)-(D.AOPD_Amount_1+ D.AOPD_Amount_2+D.AOPD_Amount_3) AS DifferencesQ1,
			(TP.AOPD_Amount_4+ TP.AOPD_Amount_5+TP.AOPD_Amount_6)-(D.AOPD_Amount_4+ D.AOPD_Amount_5+D.AOPD_Amount_6) AS DifferencesQ2,
			(TP.AOPD_Amount_7+ TP.AOPD_Amount_8+TP.AOPD_Amount_9)-(D.AOPD_Amount_7+ D.AOPD_Amount_8+D.AOPD_Amount_9) AS DifferencesQ3,
			(TP.AOPD_Amount_10+ TP.AOPD_Amount_11+TP.AOPD_Amount_12)-(D.AOPD_Amount_10+ D.AOPD_Amount_11+D.AOPD_Amount_12) AS DifferencesQ4
	FROM V_AOPDealer_Temp TP 
	INNER JOIN V_AOPDealer D  ON TP.AOPD_Dealer_DMA_ID=D.AOPD_Dealer_DMA_ID 
	AND TP.AOPD_ProductLine_BUM_ID=D.AOPD_ProductLine_BUM_ID 
	AND ISNULL(TP.AOPD_Market_Type,'0')=ISNULL(D.AOPD_Market_Type,'0')
	AND TP.AOPD_Year=D.AOPD_Year
	WHERE TP.AOPD_Contract_ID=@Contract_ID

	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @Year,@Q1,@Q2,@Q3,@Q4,@DifferencesQ1,@DifferencesQ2,@DifferencesQ3,@DifferencesQ4
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			SET @RtnFormalVal = @RtnFormalVal +@Year +'  [Q1:'+CONVERT(NVARCHAR(1000),@Q1)+'  Q2:'+CONVERT(NVARCHAR(1000),@Q2)+'  Q3:'+CONVERT(NVARCHAR(1000),@Q3)++'  Q4:'+CONVERT(NVARCHAR(100),@Q4)+'];   '
			SET @RtnDifferencesVal=@RtnDifferencesVal+@Year+'  [Q1:'+CONVERT(NVARCHAR(1000),@DifferencesQ1)+'  Q2:'+CONVERT(NVARCHAR(1000),@DifferencesQ2)+'  Q3:'+CONVERT(NVARCHAR(1000),@DifferencesQ3)++'  Q4:'+CONVERT(NVARCHAR(100),@DifferencesQ4)+'];   '
		FETCH NEXT FROM @PRODUCT_CUR INTO @Year,@Q1,@Q2,@Q3,@Q4,@DifferencesQ1,@DifferencesQ2,@DifferencesQ3,@DifferencesQ4
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
	
	INSERT INTO #tbReturn (Aop,AopFormal,AopDifferences) VALUES(@Aop,@RtnFormalVal,@RtnDifferencesVal)
	SELECT * FROM #tbReturn
	
	END
	




GO


