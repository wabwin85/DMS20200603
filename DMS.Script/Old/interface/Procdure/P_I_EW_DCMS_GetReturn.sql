DROP Procedure [interface].[P_I_EW_DCMS_GetReturn]
GO


/*
完成合同填写后获取授权指标返回值
*/
CREATE Procedure [interface].[P_I_EW_DCMS_GetReturn]
	@Contract_ID uniqueidentifier,@BeginDate DateTime ,@EndDate DateTime,@ContractType nvarchar(20),@LastBeginDate DateTime 
AS
	DECLARE @Area NVARCHAR(50)
	DECLARE @AreaCount INT
	DECLARE @Hospital NVARCHAR(50)
	DECLARE @Aop NVARCHAR(1000)
	DECLARE @AopTotal float
	DECLARE @HospitalQuty INT 
	
	DECLARE @ProClass NVARCHAR(1000)
	DECLARE @ProPrice NVARCHAR(1000)
	DECLARE @ProRebate NVARCHAR(1000)
	DECLARE @ProProductLine NVARCHAR(50)
	
	DECLARE @MiddleValue int
	DECLARE @MiddleString NVARCHAR(50)
	
	DECLARE @MiddleValue2 int
	DECLARE @MiddleString2 NVARCHAR(50)
	
	--Begin Amendment
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
	--End Amendment

	DECLARE @CheckData INT;
	DECLARE @BeginDateYear INT;
	DECLARE @BeginDateMonth INT;
	DECLARE @Parameter1 Money;
	DECLARE @Parameter2 Money;
	
	DECLARE @BeginMiddleMonth INT;
	DECLARE @EndMiddleMonth INT;
	
	DECLARE @QuarterChange INT;
	DECLARE @DealerLessHos INT;
	DECLARE @HosLessStandard INT;
	DECLARE @HosHavZorro INT;
	DECLARE @AllProductAOP decimal;
	
	DECLARE @DealerLessHosQ INT
	DECLARE	@DealerLessHosQRemark NVARCHAR(800)
	DECLARE	@HosLessStandardQ INT
	DECLARE	@HosLessStandardQRemark NVARCHAR(800)
	DECLARE @ExceedTenPercent INT
	DECLARE @ProductGroupCheck INT
	DECLARE @ProductGroupRemark NVARCHAR(500)
	DECLARE @TerritoryString NVARCHAR(MAX)
	
	CREATE TABLE #tbReturn
	(
		 Hospital NVARCHAR(50),
		 HospitalQty Int ,
		 Aop NVARCHAR(1000),
		 AopTotal NVARCHAR(500),
		 ProductClassification NVARCHAR(1000),
		 ProductPrice NVARCHAR(1000),
		 ProductLine NVARCHAR(50),
		 ProductRebate NVARCHAR(1000),
		 
		 AopFormal NVARCHAR(1000),
		 AopDifferences NVARCHAR(1000),
		 
		 AreaQty INT,
		 Area NVARCHAR(50),
		 CheckData INT ,--Amendment过去月份指标是否被更改了
		
		 QuarterChange INT , --Amendment当前季度指标是否被更改
		 DealerLessHos INT, --经销商指标小于医院指标
		 HosLessStandard INT, --医院实际指标小于医院标准指标
		 HosHavZorro INT, --医院实际指标包含0
		 AllProductAOP decimal, --所有产品线指标合计
		 
		 DealerLessHosQ INT, --经销商季度指标小于医院季度指标
		 DealerLessHosQRemark NVARCHAR(800), --经销商指标小于医院指标备注
		 
		 HosLessStandardQ INT,--医院实际季度指标小于医院标准季度指标备注
		 HosLessStandardQRemark NVARCHAR(800), --医院实际指标小于医院标准指标备注
		 ExceedTenPercent INT,  --Amendment 指标调整超过10%
		 ProductGroupCheck INT,  --产品组最小指标校验
		 ProductGroupRemark NVARCHAR(500),
		 TerritoryString NVARCHAR(MAX),--授权医院所在省份汇总
	)
	
	CREATE TABLE #tamp
	(
		TP_HOS_ID uniqueidentifier NULL,
		TP_ProductLineId uniqueidentifier NULL,
		TP_PCT_ID uniqueidentifier NULL,
		TP_MONTH NVARCHAR(10) NULL,
		TP_Amount float null
	)
	
	CREATE TABLE #AOPReturn
	(
		DealerId uniqueidentifier NULL,
		CC_ID uniqueidentifier NULL,
		Year NVARCHAR(10) NULL,
		Q1 DECIMAL(18,4) NULL,
		Q2 DECIMAL(18,4) NULL,
		Q3 DECIMAL(18,4) NULL,
		Q4 DECIMAL(18,4) NULL,
		SumYear DECIMAL(18,4) NULL,
		LastSales  DECIMAL(18,4) NULL,
		AOPRatio DECIMAL(18,4) NULL
	)
	
	CREATE TABLE #Purchase
	(
		Year NVARCHAR(10) NULL,
		SumPurchase DECIMAL(18,4) NULL
	)
	 
SET NOCOUNT ON
	BEGIN
	
	--1.0 过去月份、本季度指标变动 判断
	SET @BeginDateYear=YEAR(@BeginDate);
	SET @BeginDateMonth=MONTH(@BeginDate);
	IF (MONTH(DATEADD(qq, DATEDIFF(qq,0,@BeginDate), 0))+2)>=(MONTH(DATEADD(qq, DATEDIFF(qq,0,@BeginDate), 0))) 
	BEGIN
		SET @BeginMiddleMonth=(MONTH(DATEADD(qq, DATEDIFF(qq,0,@BeginDate), 0)));
		SET @EndMiddleMonth=(MONTH(DATEADD(qq, DATEDIFF(qq,0,@BeginDate), 0))+2);
	END
	IF @ContractType='Amendment'
	BEGIN
		IF NOT Exists (SELECT 1 FROM AOPDealer A INNER JOIN AOPDealerTemp B ON 
		A.AOPD_Dealer_DMA_ID=B.AOPD_Dealer_DMA_ID 
		AND A.AOPD_ProductLine_BUM_ID=B.AOPD_ProductLine_BUM_ID 
		AND A.AOPD_CC_ID=B.AOPD_CC_ID 
		AND A.AOPD_Year=B.AOPD_Year 
		AND A.AOPD_Month=B.AOPD_Month 
		AND ISNULL(A.AOPD_Market_Type,'0')='0' WHERE B.AOPD_Contract_ID=@Contract_ID)
		BEGIN
			SET @CheckData=1;
			SET @QuarterChange=1;
		END
		ELSE BEGIN
			SET @Parameter1=0;
			SET @Parameter2=0;
			SELECT @Parameter1=ISNULL(SUM(A.AOPD_Amount),0) FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@Contract_ID AND A.AOPD_Year=@BeginDateYear AND A.AOPD_Month <@BeginDateMonth
			SELECT @Parameter2=ISNULL(SUM(A.AOPD_Amount),0) FROM AOPDealer A INNER JOIN AOPDealerTemp B ON A.AOPD_Dealer_DMA_ID=B.AOPD_Dealer_DMA_ID AND A.AOPD_ProductLine_BUM_ID=B.AOPD_ProductLine_BUM_ID AND A.AOPD_CC_ID=B.AOPD_CC_ID AND A.AOPD_Year=B.AOPD_Year AND A.AOPD_Month=B.AOPD_Month AND ISNULL(A.AOPD_Market_Type,'0')='0' WHERE B.AOPD_Contract_ID=@Contract_ID AND A.AOPD_Month< @BeginDateMonth
			IF @Parameter1=@Parameter2
			BEGIN
				SET @CheckData=1
			END
			ELSE BEGIN
				SET @CheckData=0
			END
			
			SET @Parameter1=0;
			SET @Parameter2=0;
			SELECT @Parameter2=ISNULL(SUM(A.AOPD_Amount),0) FROM AOPDealer A INNER JOIN AOPDealerTemp B ON A.AOPD_Dealer_DMA_ID=B.AOPD_Dealer_DMA_ID AND A.AOPD_ProductLine_BUM_ID=B.AOPD_ProductLine_BUM_ID AND A.AOPD_CC_ID=B.AOPD_CC_ID AND A.AOPD_Year=B.AOPD_Year AND A.AOPD_Month=B.AOPD_Month AND ISNULL(A.AOPD_Market_Type,'0')='0' WHERE B.AOPD_Contract_ID=@Contract_ID 
			AND A.AOPD_Month BETWEEN @BeginMiddleMonth AND @EndMiddleMonth
			SELECT @Parameter1=ISNULL(SUM(A.AOPD_Amount),0) FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@Contract_ID AND A.AOPD_Year=@BeginDateYear 
			AND A.AOPD_Month BETWEEN @BeginMiddleMonth AND @EndMiddleMonth 
			
			IF @Parameter1=@Parameter2
			BEGIN
				SET @QuarterChange=1
			END
			ELSE BEGIN
				SET @QuarterChange=0
			END
			
		END
		
	END
	ELSE BEGIN
		SET @CheckData =1;
		SET @QuarterChange=1;
	END
	--2.0 经销商实际指标与医院实际指标比较
	SET @Parameter1=0;	--经销商指标
	SET @Parameter2=0;	--医院指标
	SELECT @Parameter1=ISNULL(SUM(A.AOPD_Amount),0) FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@Contract_ID AND A.AOPD_Year=@BeginDateYear  
	IF  EXISTS(SELECT 1 FROM AOPDealerHospitalTemp WHERE AOPDH_Contract_ID=@Contract_ID)
	BEGIN
		SELECT @Parameter2=ISNULL(SUM(A.AOPDH_Amount),0) FROM AOPDealerHospitalTemp A WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	END
	ELSE IF EXISTS(SELECT 1 FROM AOPICDealerHospitalTemp WHERE AOPICH_Contract_ID=@Contract_ID)
	BEGIN
		SELECT @Parameter2=ISNULL(SUM(hos.AOPICH_Unit_Y *price.CP_Price),0)
		  FROM V_AOPICDealerHospital_Temp hos
		  INNER JOIN AOPHospitalProductMapping MP ON MP.AOPHPM_ContractId=hos.AOPICH_Contract_ID and hos.AOPICH_PCT_ID=mp.AOPHPM_PCT_ID and mp.AOPHPM_Hos_Id=hos.AOPICH_Hospital_ID
		  INNER  JOIN (SELECT DISTINCT CQ_ID,CP_ID,CP_Price,Year,CC_ProductLineID FROM V_ProductClassificationStructure ) price ON price.CC_ProductLineID=hos.AOPICH_ProductLine_ID AND price.CQ_ID=hos.AOPICH_PCT_ID and hos.AOPICH_Year=price.Year AND price.CP_ID=MP.AOPHPM_PCP_ID
		  WHERE hos.AOPICH_Contract_ID=@Contract_ID
		  GROUP BY hos.AOPICH_Contract_ID,hos.AOPICH_DMA_ID,hos.AOPICH_ProductLine_ID,hos.AOPICH_Year 
	END
	IF ROUND(@Parameter1,4)>=ROUND(@Parameter2,4)
	BEGIN
		SET @DealerLessHos=1;
	END
	ELSE
	BEGIN
		SET @DealerLessHos=0;
	END
	
	--2.1季度 经销商实际指标与医院实际指标比较
	
	--DECLARE @DealerLessHosQ INT
	--DECLARE	@DealerLessHosQRemark NVARCHAR(800)
	
	DECLARE @CurrentQ INT;
	IF MONTH(@BeginDate) IN (1,2,3) SET @CurrentQ=1;
	
	IF MONTH(@BeginDate) IN (4,5,6) SET @CurrentQ=2;
	
	IF MONTH(@BeginDate) IN (7,8,9) SET @CurrentQ=3;
	
	IF MONTH(@BeginDate) IN (10,11,12) SET @CurrentQ=4;
	
	IF @CurrentQ <=1
	BEGIN
		SET @Parameter1=0;	--经销商指标
		SET @Parameter2=0;	--医院指标
		
		SELECT @Parameter1=ISNULL(SUM(A.AOPD_Amount),0) FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@Contract_ID AND A.AOPD_Year=@BeginDateYear AND A.AOPD_Month IN ('01','02','03')
		
		IF  EXISTS(SELECT 1 FROM AOPDealerHospitalTemp WHERE AOPDH_Contract_ID=@Contract_ID)
		BEGIN
			SELECT @Parameter2=ISNULL(SUM(A.AOPDH_Amount),0) FROM AOPDealerHospitalTemp A WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear AND A.AOPDH_Month IN ('01','02','03')
		END
		ELSE IF EXISTS(SELECT 1 FROM AOPICDealerHospitalTemp WHERE AOPICH_Contract_ID=@Contract_ID)
		BEGIN
			SELECT @Parameter2=ISNULL(SUM(hos.AOPICH_Unit *price.CP_Price),0)
			  FROM AOPICDealerHospitalTemp hos
			  INNER JOIN AOPHospitalProductMapping MP ON MP.AOPHPM_ContractId=hos.AOPICH_Contract_ID and hos.AOPICH_PCT_ID=mp.AOPHPM_PCT_ID and mp.AOPHPM_Hos_Id=hos.AOPICH_Hospital_ID
			  INNER  JOIN (SELECT DISTINCT CQ_ID,CP_ID,CP_Price,Year,CC_ProductLineID FROM V_ProductClassificationStructure ) price ON price.CC_ProductLineID=hos.AOPICH_ProductLine_ID AND price.CQ_ID=hos.AOPICH_PCT_ID and hos.AOPICH_Year=price.Year AND price.CP_ID=MP.AOPHPM_PCP_ID
			  WHERE hos.AOPICH_Contract_ID=@Contract_ID AND hos.AOPICH_Month IN ('01','02','03')
			  GROUP BY hos.AOPICH_Contract_ID,hos.AOPICH_DMA_ID,hos.AOPICH_ProductLine_ID,hos.AOPICH_Year 
		END
		IF ROUND(@Parameter1,4)>=ROUND(@Parameter2,4)
		BEGIN
			SET @DealerLessHosQ=1;
		END
		ELSE
		BEGIN
			SET @DealerLessHosQ=0;
			SET @DealerLessHosQRemark='Q1'
		END
	END
	IF @CurrentQ <=2
	BEGIN
		SET @Parameter1=0;	--经销商指标
		SET @Parameter2=0;	--医院指标
		
		SELECT @Parameter1=ISNULL(SUM(A.AOPD_Amount),0) FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@Contract_ID AND A.AOPD_Year=@BeginDateYear AND A.AOPD_Month IN ('04','05','06')
		
		IF  EXISTS(SELECT 1 FROM AOPDealerHospitalTemp WHERE AOPDH_Contract_ID=@Contract_ID)
		BEGIN
			SELECT @Parameter2=ISNULL(SUM(A.AOPDH_Amount),0) FROM AOPDealerHospitalTemp A WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear AND A.AOPDH_Month IN ('04','05','06')
		END
		ELSE IF EXISTS(SELECT 1 FROM AOPICDealerHospitalTemp WHERE AOPICH_Contract_ID=@Contract_ID)
		BEGIN
			SELECT @Parameter2=ISNULL(SUM(hos.AOPICH_Unit *price.CP_Price),0)
			  FROM AOPICDealerHospitalTemp hos
			  INNER JOIN AOPHospitalProductMapping MP ON MP.AOPHPM_ContractId=hos.AOPICH_Contract_ID and hos.AOPICH_PCT_ID=mp.AOPHPM_PCT_ID and mp.AOPHPM_Hos_Id=hos.AOPICH_Hospital_ID
			  INNER  JOIN (SELECT DISTINCT CQ_ID,CP_ID,CP_Price,Year,CC_ProductLineID FROM V_ProductClassificationStructure ) price ON price.CC_ProductLineID=hos.AOPICH_ProductLine_ID AND price.CQ_ID=hos.AOPICH_PCT_ID and hos.AOPICH_Year=price.Year AND price.CP_ID=MP.AOPHPM_PCP_ID
			  WHERE hos.AOPICH_Contract_ID=@Contract_ID AND hos.AOPICH_Month IN ('04','05','06')
			  GROUP BY hos.AOPICH_Contract_ID,hos.AOPICH_DMA_ID,hos.AOPICH_ProductLine_ID,hos.AOPICH_Year 
		END
		IF ROUND(@Parameter1,4)>=ROUND(@Parameter2,4)
		BEGIN
			--SET @DealerLessHosQ=1;
			SET @DealerLessHosQ=(CASE WHEN @DealerLessHosQ=0 THEN 0 ELSE 1 END);
		END
		ELSE
		BEGIN
			SET @DealerLessHosQ=0;
			SET @DealerLessHosQRemark=(CASE WHEN ISNULL(@DealerLessHosQRemark,'')='' THEN 'Q2' ELSE @DealerLessHosQRemark+',Q2' END)
		END
	END
	IF @CurrentQ <=3
	BEGIN
		SET @Parameter1=0;	--经销商指标
		SET @Parameter2=0;	--医院指标
		
		SELECT @Parameter1=ISNULL(SUM(A.AOPD_Amount),0) FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@Contract_ID AND A.AOPD_Year=@BeginDateYear AND A.AOPD_Month IN ('07','08','09')
		
		IF  EXISTS(SELECT 1 FROM AOPDealerHospitalTemp WHERE AOPDH_Contract_ID=@Contract_ID)
		BEGIN
			SELECT @Parameter2=ISNULL(SUM(A.AOPDH_Amount),0) FROM AOPDealerHospitalTemp A WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear AND A.AOPDH_Month IN ('07','08','09')
		END
		ELSE IF EXISTS(SELECT 1 FROM AOPICDealerHospitalTemp WHERE AOPICH_Contract_ID=@Contract_ID)
		BEGIN
			SELECT @Parameter2=ISNULL(SUM(hos.AOPICH_Unit *price.CP_Price),0)
			  FROM AOPICDealerHospitalTemp hos
			  INNER JOIN AOPHospitalProductMapping MP ON MP.AOPHPM_ContractId=hos.AOPICH_Contract_ID and hos.AOPICH_PCT_ID=mp.AOPHPM_PCT_ID and mp.AOPHPM_Hos_Id=hos.AOPICH_Hospital_ID
			  INNER  JOIN (SELECT DISTINCT CQ_ID,CP_ID,CP_Price,Year,CC_ProductLineID FROM V_ProductClassificationStructure ) price ON price.CC_ProductLineID=hos.AOPICH_ProductLine_ID AND price.CQ_ID=hos.AOPICH_PCT_ID and hos.AOPICH_Year=price.Year AND price.CP_ID=MP.AOPHPM_PCP_ID
			  WHERE hos.AOPICH_Contract_ID=@Contract_ID AND hos.AOPICH_Month IN ('07','08','09')
			  GROUP BY hos.AOPICH_Contract_ID,hos.AOPICH_DMA_ID,hos.AOPICH_ProductLine_ID,hos.AOPICH_Year 
		END
		IF ROUND(@Parameter1,4)>=ROUND(@Parameter2,4)
		BEGIN
			--SET @DealerLessHosQ=1;
			SET @DealerLessHosQ=(CASE WHEN @DealerLessHosQ=0 THEN 0 ELSE 1 END);
		END
		ELSE
		BEGIN
			SET @DealerLessHosQ=0;
			SET @DealerLessHosQRemark=(CASE WHEN ISNULL(@DealerLessHosQRemark,'')='' THEN 'Q3' ELSE @DealerLessHosQRemark+',Q3' END)
		END
	END
	IF @CurrentQ <=4
	BEGIN
		SET @Parameter1=0;	--经销商指标
		SET @Parameter2=0;	--医院指标
		
		SELECT @Parameter1=ISNULL(SUM(A.AOPD_Amount),0) FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@Contract_ID AND A.AOPD_Year=@BeginDateYear AND A.AOPD_Month IN ('10','11','12')
		
		IF  EXISTS(SELECT 1 FROM AOPDealerHospitalTemp WHERE AOPDH_Contract_ID=@Contract_ID)
		BEGIN
			SELECT @Parameter2=ISNULL(SUM(A.AOPDH_Amount),0) FROM AOPDealerHospitalTemp A WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear AND A.AOPDH_Month IN ('10','11','12')
		END
		ELSE IF EXISTS(SELECT 1 FROM AOPICDealerHospitalTemp WHERE AOPICH_Contract_ID=@Contract_ID)
		BEGIN
			SELECT @Parameter2=ISNULL(SUM(hos.AOPICH_Unit *price.CP_Price),0)
			  FROM AOPICDealerHospitalTemp hos
			  INNER JOIN AOPHospitalProductMapping MP ON MP.AOPHPM_ContractId=hos.AOPICH_Contract_ID and hos.AOPICH_PCT_ID=mp.AOPHPM_PCT_ID and mp.AOPHPM_Hos_Id=hos.AOPICH_Hospital_ID
			  INNER  JOIN (SELECT DISTINCT CQ_ID,CP_ID,CP_Price,Year,CC_ProductLineID FROM V_ProductClassificationStructure ) price ON price.CC_ProductLineID=hos.AOPICH_ProductLine_ID AND price.CQ_ID=hos.AOPICH_PCT_ID and hos.AOPICH_Year=price.Year AND price.CP_ID=MP.AOPHPM_PCP_ID
			  WHERE hos.AOPICH_Contract_ID=@Contract_ID AND hos.AOPICH_Month IN ('10','11','12')
			  GROUP BY hos.AOPICH_Contract_ID,hos.AOPICH_DMA_ID,hos.AOPICH_ProductLine_ID,hos.AOPICH_Year 
		END
		IF ROUND(@Parameter1,4)>=ROUND(@Parameter2,4)
		BEGIN
			--SET @DealerLessHosQ=1;
			SET @DealerLessHosQ=(CASE WHEN @DealerLessHosQ=0 THEN 0 ELSE 1 END);
		END
		ELSE
		BEGIN
			SET @DealerLessHosQ=0;
			SET @DealerLessHosQRemark=(CASE WHEN ISNULL(@DealerLessHosQRemark,'')='' THEN 'Q4' ELSE @DealerLessHosQRemark+',Q4' END)
		END
	END
	
	IF ISNULL(@DealerLessHosQRemark,'')<>''  SET @DealerLessHosQRemark= (@DealerLessHosQRemark+' 经销商采购指标小于医院实际指标');
	
	
	
	
	--3.0 医院实际指标与医院标准指标比较
	--(是全年比较还是可修改月份开始比较) 现在是全年比较
	INSERT INTO #tamp(TP_HOS_ID,TP_ProductLineId,TP_PCT_ID,TP_MONTH,TP_Amount)
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'01',B.AOPHR_January FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'02',B.AOPHR_February FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'03',B.AOPHR_March FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'04',B.AOPHR_April FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'05',B.AOPHR_May FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'06',B.AOPHR_June FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'07',B.AOPHR_July FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'08',B.AOPHR_August FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'09',B.AOPHR_September FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'10',B.AOPHR_October FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'11',B.AOPHR_November FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
	UNION
	SELECT B.AOPHR_Hospital_ID,B.AOPHR_ProductLine_BUM_ID,B.AOPHR_PCT_ID,'12',B.AOPHR_December FROM V_AOPDealerHospital_Temp A 
	INNER JOIN AOPHospitalReference B ON A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_Hospital_ID=B.AOPHR_Hospital_ID AND A.AOPDH_Year=B.AOPHR_Year
	WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear;
	
	INSERT INTO #tamp(TP_HOS_ID,TP_ProductLineId,TP_PCT_ID,TP_MONTH,TP_Amount)
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'01',B.AOPICHR_January FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'02',B.AOPICHR_February FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'03',B.AOPICHR_March FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'04',B.AOPICHR_April FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'05',B.AOPICHR_May FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'06',B.AOPICHR_June FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'07',B.AOPICHR_July FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'08',B.AOPICHR_August FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'09',B.AOPICHR_September FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'10',B.AOPICHR_October FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'11',B.AOPICHR_November FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
	UNION
	SELECT B.AOPICHR_Hospital_ID,B.AOPICHR_ProductLine_ID,B.AOPICHR_PCT_ID,'12',B.AOPICHR_December FROM V_AOPICDealerHospital_Temp A 
	INNER JOIN AOPICDealerHospitalReference B ON A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_Hospital_ID=B.AOPICHR_Hospital_ID AND A.AOPICH_Year=B.AOPICHR_Year
	WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear;
	
	IF EXISTS( SELECT 1 FROM (
				SELECT A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year, Round(SUM(A.AOPDH_Amount),0) AS Amount FROM AOPDealerHospitalTemp A 
					WHERE A.AOPDH_Contract_ID=@Contract_ID  AND A.AOPDH_Year=@BeginDateYear AND CONVERT(INT, A.AOPDH_Month) >=@BeginDateMonth
				GROUP BY A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year
				UNION
				SELECT A.AOPICH_ProductLine_ID,A.AOPICH_PCT_ID,A.AOPICH_Hospital_ID,A.AOPICH_Year, Round(SUM(A.AOPICH_Unit),0) FROM AOPICDealerHospitalTemp A 
					WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear AND CONVERT(INT,A.AOPICH_Month) >=@BeginDateMonth
				GROUP BY A.AOPICH_ProductLine_ID,A.AOPICH_PCT_ID,A.AOPICH_Hospital_ID,A.AOPICH_Year)  AS TAB_TMP
	LEFT JOIN ( SELECT TP_HOS_ID ,TP_ProductLineId ,TP_PCT_ID ,Round(SUM(TP_Amount),0)  AS TP_Amount FROM #tamp WHERE CONVERT(INT,TP_MONTH) >=@BeginDateMonth 
				GROUP BY TP_HOS_ID ,TP_ProductLineId ,TP_PCT_ID	) TP 
	 ON TP.TP_HOS_ID=TAB_TMP.AOPDH_Hospital_ID AND  TP.TP_ProductLineId=TAB_TMP.AOPDH_ProductLine_BUM_ID AND TP.TP_PCT_ID=TAB_TMP.AOPDH_PCT_ID
	WHERE TP.TP_Amount>TAB_TMP.Amount)
	BEGIN
		SET @HosLessStandard=0;
	END
	ELSE 
	BEGIN
		SET @HosLessStandard=1;
	END
	
	--3.1 医院实际季度指标和表准指标判断
	IF @CurrentQ <=1
	BEGIN
		IF EXISTS( SELECT 1 FROM (
				SELECT A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year, Round(SUM(A.AOPDH_Amount),0) AS Amount FROM AOPDealerHospitalTemp A 
					WHERE A.AOPDH_Contract_ID=@Contract_ID  AND A.AOPDH_Year=@BeginDateYear AND CONVERT(INT, A.AOPDH_Month) >=@BeginDateMonth
					AND A.AOPDH_Month IN ('01','02','03')
				GROUP BY A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year
				UNION
				SELECT A.AOPICH_ProductLine_ID,A.AOPICH_PCT_ID,A.AOPICH_Hospital_ID,A.AOPICH_Year, Round(SUM(A.AOPICH_Unit),0) FROM AOPICDealerHospitalTemp A 
					WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear AND CONVERT(INT,A.AOPICH_Month) >=@BeginDateMonth AND A.AOPICH_Month IN ('01','02','03')
					GROUP BY A.AOPICH_ProductLine_ID,A.AOPICH_PCT_ID,A.AOPICH_Hospital_ID,A.AOPICH_Year)  AS TAB_TMP
		LEFT JOIN ( SELECT TP_HOS_ID ,TP_ProductLineId ,TP_PCT_ID ,Round(SUM(TP_Amount),0)  AS TP_Amount FROM #tamp WHERE CONVERT(INT,TP_MONTH) >=@BeginDateMonth  AND TP_MONTH IN ('01','02','03')
					GROUP BY TP_HOS_ID ,TP_ProductLineId ,TP_PCT_ID	) TP 
		 ON TP.TP_HOS_ID=TAB_TMP.AOPDH_Hospital_ID AND  TP.TP_ProductLineId=TAB_TMP.AOPDH_ProductLine_BUM_ID AND TP.TP_PCT_ID=TAB_TMP.AOPDH_PCT_ID
		WHERE TP.TP_Amount>TAB_TMP.Amount)
		BEGIN
			SET @HosLessStandardQ=0;
			SET @HosLessStandardQRemark='Q1'
		END
		ELSE 
		BEGIN
			SET @HosLessStandardQ=1;
		END
	END
	
	IF @CurrentQ <=2
	BEGIN
		IF EXISTS( SELECT 1 FROM (
				SELECT A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year, Round(SUM(A.AOPDH_Amount),0) AS Amount FROM AOPDealerHospitalTemp A 
					WHERE A.AOPDH_Contract_ID=@Contract_ID  AND A.AOPDH_Year=@BeginDateYear AND CONVERT(INT, A.AOPDH_Month) >=@BeginDateMonth
					AND A.AOPDH_Month IN ('04','05','06')
				GROUP BY A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year
				UNION
				SELECT A.AOPICH_ProductLine_ID,A.AOPICH_PCT_ID,A.AOPICH_Hospital_ID,A.AOPICH_Year, Round(SUM(A.AOPICH_Unit),0) FROM AOPICDealerHospitalTemp A 
					WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear AND CONVERT(INT,A.AOPICH_Month) >=@BeginDateMonth AND A.AOPICH_Month IN ('04','05','06')
					GROUP BY A.AOPICH_ProductLine_ID,A.AOPICH_PCT_ID,A.AOPICH_Hospital_ID,A.AOPICH_Year)  AS TAB_TMP
		LEFT JOIN ( SELECT TP_HOS_ID ,TP_ProductLineId ,TP_PCT_ID ,Round(SUM(TP_Amount),0)  AS TP_Amount FROM #tamp WHERE CONVERT(INT,TP_MONTH) >=@BeginDateMonth  AND TP_MONTH IN ('04','05','06')
					GROUP BY TP_HOS_ID ,TP_ProductLineId ,TP_PCT_ID	) TP 
		 ON TP.TP_HOS_ID=TAB_TMP.AOPDH_Hospital_ID AND  TP.TP_ProductLineId=TAB_TMP.AOPDH_ProductLine_BUM_ID AND TP.TP_PCT_ID=TAB_TMP.AOPDH_PCT_ID
		WHERE TP.TP_Amount>TAB_TMP.Amount)
		BEGIN
			SET @HosLessStandardQ=0;
			SET @HosLessStandardQRemark=(CASE WHEN ISNULL(@HosLessStandardQRemark,'')='' THEN 'Q2' ELSE @HosLessStandardQRemark+',Q2' END)
		END
		ELSE 
		BEGIN
			--SET @HosLessStandardQ=1;
			SET @HosLessStandardQ=(CASE WHEN @HosLessStandardQ=0 THEN 0 ELSE 1 END);
		END
	END
	
	
	IF @CurrentQ <=3
	BEGIN
		IF EXISTS( SELECT 1 FROM (
				SELECT A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year, Round(SUM(A.AOPDH_Amount),0) AS Amount FROM AOPDealerHospitalTemp A 
					WHERE A.AOPDH_Contract_ID=@Contract_ID  AND A.AOPDH_Year=@BeginDateYear AND CONVERT(INT, A.AOPDH_Month) >=@BeginDateMonth
					AND A.AOPDH_Month IN ('07','08','09')
				GROUP BY A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year
				UNION
				SELECT A.AOPICH_ProductLine_ID,A.AOPICH_PCT_ID,A.AOPICH_Hospital_ID,A.AOPICH_Year, Round(SUM(A.AOPICH_Unit),0) FROM AOPICDealerHospitalTemp A 
					WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear AND CONVERT(INT,A.AOPICH_Month) >=@BeginDateMonth AND A.AOPICH_Month IN ('07','08','09')
					GROUP BY A.AOPICH_ProductLine_ID,A.AOPICH_PCT_ID,A.AOPICH_Hospital_ID,A.AOPICH_Year)  AS TAB_TMP
		LEFT JOIN ( SELECT TP_HOS_ID ,TP_ProductLineId ,TP_PCT_ID ,Round(SUM(TP_Amount),0)  AS TP_Amount FROM #tamp WHERE CONVERT(INT,TP_MONTH) >=@BeginDateMonth  AND TP_MONTH IN ('07','08','09')
					GROUP BY TP_HOS_ID ,TP_ProductLineId ,TP_PCT_ID	) TP 
		 ON TP.TP_HOS_ID=TAB_TMP.AOPDH_Hospital_ID AND  TP.TP_ProductLineId=TAB_TMP.AOPDH_ProductLine_BUM_ID AND TP.TP_PCT_ID=TAB_TMP.AOPDH_PCT_ID
		WHERE TP.TP_Amount>TAB_TMP.Amount)
		BEGIN
			SET @HosLessStandardQ=0;
			SET @HosLessStandardQRemark=(CASE WHEN ISNULL(@HosLessStandardQRemark,'')='' THEN 'Q3' ELSE @HosLessStandardQRemark+',Q3' END)
		END
		ELSE 
		BEGIN
			--SET @HosLessStandardQ=1;
			SET @HosLessStandardQ=(CASE WHEN @HosLessStandardQ=0 THEN 0 ELSE 1 END);
		END
	END
	
	
	IF @CurrentQ <=4
	BEGIN
		IF EXISTS( SELECT 1 FROM (
				SELECT A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year, Round(SUM(A.AOPDH_Amount),0) AS Amount FROM AOPDealerHospitalTemp A 
					WHERE A.AOPDH_Contract_ID=@Contract_ID  AND A.AOPDH_Year=@BeginDateYear AND CONVERT(INT, A.AOPDH_Month) >=@BeginDateMonth
					AND A.AOPDH_Month IN ('10','11','12')
				GROUP BY A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year
				UNION
				SELECT A.AOPICH_ProductLine_ID,A.AOPICH_PCT_ID,A.AOPICH_Hospital_ID,A.AOPICH_Year, Round(SUM(A.AOPICH_Unit),0) FROM AOPICDealerHospitalTemp A 
					WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear AND CONVERT(INT,A.AOPICH_Month) >=@BeginDateMonth AND A.AOPICH_Month IN ('10','11','12')
					GROUP BY A.AOPICH_ProductLine_ID,A.AOPICH_PCT_ID,A.AOPICH_Hospital_ID,A.AOPICH_Year)  AS TAB_TMP
		LEFT JOIN ( SELECT TP_HOS_ID ,TP_ProductLineId ,TP_PCT_ID ,Round(SUM(TP_Amount),0)  AS TP_Amount FROM #tamp WHERE CONVERT(INT,TP_MONTH) >=@BeginDateMonth  AND TP_MONTH IN ('10','11','12')
					GROUP BY TP_HOS_ID ,TP_ProductLineId ,TP_PCT_ID	) TP 
		 ON TP.TP_HOS_ID=TAB_TMP.AOPDH_Hospital_ID AND  TP.TP_ProductLineId=TAB_TMP.AOPDH_ProductLine_BUM_ID AND TP.TP_PCT_ID=TAB_TMP.AOPDH_PCT_ID
		WHERE TP.TP_Amount>TAB_TMP.Amount)
		BEGIN
			SET @HosLessStandardQ=0;
			SET @HosLessStandardQRemark=(CASE WHEN ISNULL(@HosLessStandardQRemark,'')='' THEN 'Q4' ELSE @HosLessStandardQRemark+',Q4' END)
		END
		ELSE 
		BEGIN
			--SET @HosLessStandardQ=1;
			SET @HosLessStandardQ=(CASE WHEN @HosLessStandardQ=0 THEN 0 ELSE 1 END);
		END
	END
	
	IF ISNULL(@HosLessStandardQRemark,'')<>''  SET @HosLessStandardQRemark= (@HosLessStandardQRemark+' 医院实际指标小于医院标准指标');
	
	/*
	--取消------------------------------------------------------------------------
	IF EXISTS(	SELECT 1 FROM V_AOPDealerHospital_Temp A 
					LEFT JOIN AOPHospitalReference B ON B.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID AND A.AOPDH_PCT_ID=B.AOPHR_PCT_ID AND A.AOPDH_ProductLine_BUM_ID=B.AOPHR_ProductLine_BUM_ID AND A.AOPDH_Year=B.AOPHR_Year
					WHERE ROUND(ISNULL(B.AOPHR_January+B.AOPHR_February+B.AOPHR_March+B.AOPHR_April+B.AOPHR_May+B.AOPHR_June+B.AOPHR_July+B.AOPHR_August+B.AOPHR_September+B.AOPHR_October+B.AOPHR_November+B.AOPHR_December,0),4)>ROUND(A.AOPDH_Amount_Y ,4)
					AND A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear)
	BEGIN
		SET @HosLessStandard=0;
	END
	ELSE IF EXISTS (	SELECT 1 FROM V_AOPICDealerHospital_Temp A 
					LEFT JOIN AOPICDealerHospitalReference B ON B.AOPICHR_Hospital_ID=A.AOPICH_Hospital_ID AND A.AOPICH_PCT_ID=B.AOPICHR_PCT_ID AND A.AOPICH_ProductLine_ID=B.AOPICHR_ProductLine_ID AND A.AOPICH_Year=B.AOPICHR_Year
					WHERE ROUND(ISNULL(B.AOPICHR_January+B.AOPICHR_February+B.AOPICHR_March+B.AOPICHR_April+B.AOPICHR_May+B.AOPICHR_June+B.AOPICHR_July+B.AOPICHR_August+B.AOPICHR_September+B.AOPICHR_October+B.AOPICHR_November+B.AOPICHR_December,0),4)>ROUND(A.AOPICH_Unit_Y ,4)
					AND A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear)
	BEGIN
		SET @HosLessStandard=0;
	END
	ELSE
	BEGIN
		SET @HosLessStandard=1;
	END
	*/
	--------------------------------------------------------------------------
	--4.0 医院实际指标包含0
	IF EXISTS(SELECT 1 FROM (SELECT AOPDH_Year,A.AOPDH_Hospital_ID,SUM(A.AOPDH_Amount_Y) Amount_Y FROM V_AOPDealerHospital_Temp A 
									WHERE A.AOPDH_Contract_ID=@Contract_ID AND A.AOPDH_Year=@BeginDateYear
								GROUP BY AOPDH_Year,A.AOPDH_Hospital_ID) B  WHERE B.Amount_Y =0 )
	 OR EXISTS(SELECT 1 FROM (SELECT A.AOPICH_Year,A.AOPICH_Hospital_ID,SUM(A.AOPICH_Unit_Y) Unit_Y FROM V_AOPICDealerHospital_Temp A 
									WHERE A.AOPICH_Contract_ID=@Contract_ID AND A.AOPICH_Year=@BeginDateYear
								GROUP BY A.AOPICH_Year,A.AOPICH_Hospital_ID) B WHERE B.Unit_Y =0 )
	BEGIN
		IF EXISTS(SELECT 1 FROM AOPMIN A  
				INNER JOIN(SELECT DISTINCT AOPD_ProductLine_BUM_ID,AOPD_CC_ID FROM AOPDealerTemp WHERE AOPD_Contract_ID=@Contract_ID) B 
				ON B.AOPD_ProductLine_BUM_ID=A.AOPM_ProductLine_ID AND B.AOPD_CC_ID=A.AOPM_CC_ID AND A.AOPM_Year=@BeginDateYear)
		BEGIN
			SET @HosHavZorro=0
		END
		ELSE
		BEGIN
			SET @HosHavZorro=1
		END
	END
	ELSE
	BEGIN
		SET @HosHavZorro=1
	END
	
	IF NOT EXISTS (SELECT 1 FROM V_AOPDealerHospital_Temp WHERE AOPDH_Contract_ID=@Contract_ID)
	BEGIN
		SET @HosHavZorro=0
	END
	
	--5. 合并经销商所有指标
	SET @AllProductAOP=0;
	SELECT @AllProductAOP=ISNULL(A.AOPD_Amount_Y,0) FROM V_AOPDealer_Temp A WHERE A.AOPD_Contract_ID=@Contract_ID AND A.AOPD_Year=@BeginDateYear
	SELECT @AllProductAOP=(@AllProductAOP+ISNULL(SUM(A.AOPD_Amount_Y),0)) FROM V_AOPDealer A 
		INNER JOIN V_DivisionProductLineRelation B ON A.AOPD_ProductLine_BUM_ID=B.ProductLineID AND B.IsEmerging='0'
		INNER JOIN V_DealerContractMaster C ON A.AOPD_Dealer_DMA_ID=C.DMA_ID AND CONVERT(NVARCHAR(10),C.Division)=B.DivisionCode AND C.ActiveFlag='1' AND C.CC_ID=A.AOPD_CC_ID
	WHERE  A.AOPD_Year=@BeginDateYear 
	AND A.AOPD_Dealer_DMA_ID IN (SELECT DISTINCT AOPD_Dealer_DMA_ID FROM AOPDealerTemp WHERE AOPD_Contract_ID=@Contract_ID)
	AND NOT EXISTS (SELECT 1 FROM V_AOPDealer_Temp TP 
		WHERE TP.AOPD_Contract_ID=@Contract_ID AND TP.AOPD_Year=@BeginDateYear 
			AND TP.AOPD_ProductLine_BUM_ID= A.AOPD_ProductLine_BUM_ID AND TP.AOPD_CC_ID=A.AOPD_CC_ID 
			AND TP.AOPD_Dealer_DMA_ID=A.AOPD_Dealer_DMA_ID AND TP.AOPD_Year=A.AOPD_Year)
	 
	 --方承普通
	 IF  EXISTS (SELECT 1 FROM AOPDealerTemp WHERE AOPD_Contract_ID=@Contract_ID AND AOPD_Dealer_DMA_ID='A00FCD75-951D-4D91-8F24-A29900DA5E85')
	 BEGIN
		SELECT @AllProductAOP=(@AllProductAOP+ISNULL(SUM(A.AOPD_Amount_Y),0)) FROM V_AOPDealer A 
			INNER JOIN V_DivisionProductLineRelation B ON A.AOPD_ProductLine_BUM_ID=B.ProductLineID AND B.IsEmerging='0'
			INNER JOIN V_DealerContractMaster C ON A.AOPD_Dealer_DMA_ID=C.DMA_ID AND CONVERT(NVARCHAR(10),C.Division)=B.DivisionCode 
						AND C.ActiveFlag='1' AND C.CC_ID=A.AOPD_CC_ID
		WHERE  A.AOPD_Year=@BeginDateYear 
		AND  A.AOPD_Dealer_DMA_ID='33029AF0-CFCF-495E-B057-550D16C41E4A'
	 END
	 --方承新兴
	 IF  EXISTS (SELECT 1 FROM AOPDealerTemp WHERE AOPD_Contract_ID=@Contract_ID AND AOPD_Dealer_DMA_ID='33029AF0-CFCF-495E-B057-550D16C41E4A')
	 BEGIN
		SELECT @AllProductAOP=(@AllProductAOP+ISNULL(SUM(A.AOPD_Amount_Y),0)) FROM V_AOPDealer A 
			INNER JOIN V_DivisionProductLineRelation B ON A.AOPD_ProductLine_BUM_ID=B.ProductLineID AND B.IsEmerging='0'
			INNER JOIN V_DealerContractMaster C ON A.AOPD_Dealer_DMA_ID=C.DMA_ID AND CONVERT(NVARCHAR(10),C.Division)=B.DivisionCode 
						AND C.ActiveFlag='1' AND C.CC_ID=A.AOPD_CC_ID
		WHERE  A.AOPD_Year=@BeginDateYear 
		AND  A.AOPD_Dealer_DMA_ID='A00FCD75-951D-4D91-8F24-A29900DA5E85'
	 END
	 --国科普通
	  IF  EXISTS (SELECT 1 FROM AOPDealerTemp WHERE AOPD_Contract_ID=@Contract_ID AND AOPD_Dealer_DMA_ID='84C83F71-93B4-4EFD-AB51-12354AFABAC3')
	 BEGIN
		SELECT @AllProductAOP=(@AllProductAOP+ISNULL(SUM(A.AOPD_Amount_Y),0)) FROM V_AOPDealer A 
			INNER JOIN V_DivisionProductLineRelation B ON A.AOPD_ProductLine_BUM_ID=B.ProductLineID AND B.IsEmerging='0'
			INNER JOIN V_DealerContractMaster C ON A.AOPD_Dealer_DMA_ID=C.DMA_ID AND CONVERT(NVARCHAR(10),C.Division)=B.DivisionCode 
						AND C.ActiveFlag='1' AND C.CC_ID=A.AOPD_CC_ID
		WHERE  A.AOPD_Year=@BeginDateYear 
		AND  A.AOPD_Dealer_DMA_ID='A54ADD15-CB13-4850-9848-6DA4576207CB'
	 END
	 --国科新兴
	 IF  EXISTS (SELECT 1 FROM AOPDealerTemp WHERE AOPD_Contract_ID=@Contract_ID AND AOPD_Dealer_DMA_ID='A54ADD15-CB13-4850-9848-6DA4576207CB')
	 BEGIN
		SELECT @AllProductAOP=(@AllProductAOP+ISNULL(SUM(A.AOPD_Amount_Y),0)) FROM V_AOPDealer A 
			INNER JOIN V_DivisionProductLineRelation B ON A.AOPD_ProductLine_BUM_ID=B.ProductLineID AND B.IsEmerging='0'
			INNER JOIN V_DealerContractMaster C ON A.AOPD_Dealer_DMA_ID=C.DMA_ID AND CONVERT(NVARCHAR(10),C.Division)=B.DivisionCode 
						AND C.ActiveFlag='1' AND C.CC_ID=A.AOPD_CC_ID
		WHERE  A.AOPD_Year=@BeginDateYear 
		AND  A.AOPD_Dealer_DMA_ID='84C83F71-93B4-4EFD-AB51-12354AFABAC3'
	 END
	
	--
	SELECT @Hospital= interface.fn_I_EW_DCMS_GetAuthorizeHospital(@Contract_ID);
	IF @Hospital IS NOT NULL
	BEGIN
		 SET @HospitalQuty=CONVERT(INT,SUBSTRING(@Hospital,-11,LEN(@Hospital)))
	END
	
	SELECT @AreaCount=COUNT( DISTINCT  B.TA_Area) FROM DealerAuthorizationAreaTemp A INNER JOIN TerritoryAreaTemp B ON A.DA_ID=B.TA_DA_ID WHERE A.DA_DCL_ID=@Contract_ID
	IF @AreaCount=0
	BEGIN
		 SET @Area= '0'+' Territory' 
	END
	ELSE
	BEGIN
		SET @Area= CONVERT(nvarchar(10), @AreaCount)+' Territory(s)' 
	END
	
	SELECT @Aop= interface.fn_I_EW_DCMS_GetDealerAOP(@Contract_ID);
	SELECT @AopTotal=SUM( AOPD_Amount_Y)
			  FROM V_AOPDealer_Temp
			  left join View_ProductLine pl on pl.Id=V_AOPDealer_Temp.AOPD_ProductLine_BUM_ID
			  WHERE AOPD_Contract_ID=@Contract_ID
	
	
	
	DECLARE @PName NVARCHAR(500)
	DECLARE @PPrice NVARCHAR(500)
	DECLARE @PRebate NVARCHAR(500)
	DECLARE @PTName NVARCHAR(2000)
	DECLARE @PTPrice NVARCHAR(2000)
	
	
	SET @ProClass='';
	SET @ProRebate='';
	SET @ProPrice='';
	SET @PTName='';
	SET @PTPrice='';
	
	SET @MiddleValue=0;
	SET @MiddleValue2=0;
	
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT DISTINCT PC.CQ_NameCN,PC.CQ_RV2,PC.CQ_RV1,PP.CP_Price,PP.CP_Rebate FROM AOPHospitalProductMapping MP
	INNER JOIN interface.ClassificationQuota PC ON MP.AOPHPM_PCT_ID=PC.CQ_ID
	INNER JOIN interface.ClassificationQuotaPrice pp ON PP.CP_ID=MP.AOPHPM_PCP_ID
	WHERE MP.AOPHPM_ContractId=@Contract_ID
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @PName,@PTName,@PTPrice,@PPrice,@PRebate
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			SET @MiddleValue=@MiddleValue+1;
			if(@MiddleValue%2<>0)
			BEGIN
				IF( ISNULL(@PTPrice,'')='')
				BEGIN
					SET @ProPrice =@ProPrice +(@PName+':  '+(SELECT  [dbo].[GetFormatString] (@PPrice,'0') ) +' CNY,')+' &emsp;';
					SET @ProClass=@ProClass+@PName+','+' &emsp;';
				END
				ELSE
				BEGIN
					SET @ProPrice =@ProPrice +@PName+'('+@PTPrice+'),'+' &emsp;';
					SET @ProClass=@ProClass+@PName+'('+@PTName+'),'+' &emsp;';
				END
				
			
			END
			ELSE
			BEGIN
			IF( ISNULL(@PTPrice,'')='')
				BEGIN
					SET @ProPrice=@ProPrice+(@PName+':  '+(SELECT  [dbo].[GetFormatString] (@PPrice,'0') ) +' CNY,')+' &emsp;<br/> ';
					SET @ProClass=@ProClass+@PName+','+' &emsp;<br/>';
				END
				ELSE
				BEGIN
					SET @ProPrice=@ProPrice+@PName+'('+@PTPrice+'),'+' &emsp;<br/> ';
					SET @ProClass=@ProClass+@PName+'('+@PTName+'),'+' &emsp;<br/>';
				END
			END
			--SET @ProPrice+=(@PName+':'+(SELECT  [dbo].[GetFormatString] (@PPrice,'0') ) +'CNY,')
			
			
			IF ISNULL(@PRebate,'')<>'' 
			BEGIN
				SET @MiddleValue2=@MiddleValue2+1;
				if(@MiddleValue2%2<>0)
				BEGIN
					SET @ProRebate =@ProRebate +(@PName+':  '+@PRebate+',')+' &emsp;';
				
				END
				ELSE
				BEGIN
					SET @ProRebate=@ProRebate+(@PName+':  '+ @PRebate+',') +' &emsp;<br/>';
				END
				--SET @ProRebate+=(@PName+':'+@PRebate+',   ')
			END
        FETCH NEXT FROM @PRODUCT_CUR INTO @PName,@PTName,@PTPrice,@PPrice,@PRebate
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
	
	IF LEN(@ProClass)>0
	BEGIN
		SET @MiddleString=SUBSTRING(@ProClass,LEN(@ProClass)-4,LEN(@ProClass))
		IF(@MiddleString='<br/>')
		BEGIN
			SET @ProClass=SUBSTRING(@ProClass,0,LEN(@ProClass)-12)
		END
		ELSE
		BEGIN
			SET @ProClass=SUBSTRING(@ProClass,0,LEN(@ProClass)-7)
		END
		
		--SET @ProClass=SUBSTRING(@ProClass,0,LEN(@ProClass))
	END
	IF LEN(@ProPrice)>0
	BEGIN
		SET @MiddleString=SUBSTRING(@ProPrice,LEN(@ProPrice)-4,LEN(@ProPrice))
		IF(@MiddleString='<br/>')
		BEGIN
			SET @ProPrice=SUBSTRING(@ProPrice,0,LEN(@ProPrice)-12)
		END
		ELSE
		BEGIN
			SET @ProPrice=SUBSTRING(@ProPrice,0,LEN(@ProPrice)-7)
		END
	END
	
	IF LEN(@ProRebate)>0
	BEGIN
		
		SET @MiddleString2=SUBSTRING(@ProRebate,LEN(@ProRebate)-4,LEN(@ProRebate))
		IF(@MiddleString2='<br/>')
		BEGIN
			SET @ProRebate+='<b style=" color: Red;">具体返利标准请见返利政策</b>'
		END
		ELSE
		BEGIN
			SET @ProRebate+='<b style=" color: Red;">具体返利标准请见返利政策</b>'
		END
	END
	
	DECLARE @ClassCount1 int ;
	DECLARE @ClassCount2 int ;
	DECLARE @CC_Code Nvarchar(100);
	
	SELECT  DISTINCT @CC_Code=b.CC_Code 
	FROM AOPDealerTemp A
	inner join (select distinct CC_Code,CC_ID from V_ProductClassificationStructure ) b on a.AOPD_CC_ID=b.CC_ID
	WHERE AOPD_Contract_ID=@Contract_ID
	
	SELECT @ClassCount1=COUNT(*) FROM (
	SELECT DISTINCT DAT_PMA_ID  FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@Contract_ID) B ;
	
	SELECT @ClassCount2=COUNT(*) FROM interface.ClassificationAuthorization A WHERE A.CA_ParentCode=@CC_Code
	IF(@ClassCount2=@ClassCount1)
	BEGIN
		SET @ProProductLine='All'
	END
	ELSE
	BEGIN
		SET @ProProductLine='Partial'
	END
	
	--Begin Amendment 获取正式指标 与 合同指标比较值
	
	SET @RtnFormalVal='' 
	SET @RtnDifferencesVal=''
	
	DECLARE @PRODUCT_CUR3 cursor;
	SET @PRODUCT_CUR3=cursor for 
	SELECT	D.AOPD_Year,
			ISNULL(D.AOPD_Amount_1,0)+ ISNULL(D.AOPD_Amount_2,0)+ISNULL(D.AOPD_Amount_3,0) AS Q1,
			ISNULL(D.AOPD_Amount_4,0)+ ISNULL(D.AOPD_Amount_5,0)+ISNULL(D.AOPD_Amount_6,0) AS Q2,
			ISNULL(D.AOPD_Amount_7,0)+ ISNULL(D.AOPD_Amount_8,0)+ISNULL(D.AOPD_Amount_9,0) AS Q3,
			ISNULL(D.AOPD_Amount_10,0)+ ISNULL(D.AOPD_Amount_11,0)+ISNULL(D.AOPD_Amount_12,0) AS Q4,
			(ISNULL(TP.AOPD_Amount_1,0)+ ISNULL(TP.AOPD_Amount_2,0)+ISNULL(TP.AOPD_Amount_3,0))-(ISNULL(D.AOPD_Amount_1,0)+ ISNULL(D.AOPD_Amount_2,0)+ISNULL(D.AOPD_Amount_3,0)) AS DifferencesQ1,
			(ISNULL(TP.AOPD_Amount_4,0)+ ISNULL(TP.AOPD_Amount_5,0)+ISNULL(TP.AOPD_Amount_6,0))-(ISNULL(D.AOPD_Amount_4,0)+ ISNULL(D.AOPD_Amount_5,0)+ISNULL(D.AOPD_Amount_6,0)) AS DifferencesQ2,
			(ISNULL(TP.AOPD_Amount_7,0)+ ISNULL(TP.AOPD_Amount_8,0)+ISNULL(TP.AOPD_Amount_9,0))-(ISNULL(D.AOPD_Amount_7,0)+ ISNULL(D.AOPD_Amount_8,0)+ISNULL(D.AOPD_Amount_9,0)) AS DifferencesQ3,
			(ISNULL(TP.AOPD_Amount_10,0)+ ISNULL(TP.AOPD_Amount_11,0)+ISNULL(TP.AOPD_Amount_12,0))-(ISNULL(D.AOPD_Amount_10,0)+ ISNULL(D.AOPD_Amount_11,0)+ISNULL(D.AOPD_Amount_12,0)) AS DifferencesQ4
	FROM V_AOPDealer_Temp TP 
	INNER JOIN V_AOPDealer D  ON TP.AOPD_Dealer_DMA_ID=D.AOPD_Dealer_DMA_ID 
	AND TP.AOPD_ProductLine_BUM_ID=D.AOPD_ProductLine_BUM_ID 
	AND ISNULL(TP.AOPD_Market_Type,'0')=ISNULL(D.AOPD_Market_Type,'0')
	AND TP.AOPD_Year=D.AOPD_Year
	AND TP.AOPD_CC_ID=D.AOPD_CC_ID
	WHERE TP.AOPD_Contract_ID=@Contract_ID

	OPEN @PRODUCT_CUR3
    FETCH NEXT FROM @PRODUCT_CUR3 INTO @Year,@Q1,@Q2,@Q3,@Q4,@DifferencesQ1,@DifferencesQ2,@DifferencesQ3,@DifferencesQ4
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			SET @RtnFormalVal = @RtnFormalVal +@Year +'  [Q1:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@Q1),0)+';  Q2:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@Q2),0)+';  Q3:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@Q3),0)++';  Q4:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q4),0)+'];   '
			SET @RtnDifferencesVal=@RtnDifferencesVal+@Year+'  [Q1:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@DifferencesQ1),0)+';  Q2:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@DifferencesQ2),0)+';  Q3:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@DifferencesQ3),0)++';  Q4:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@DifferencesQ4),0)+'];   '
		FETCH NEXT FROM @PRODUCT_CUR3 INTO @Year,@Q1,@Q2,@Q3,@Q4,@DifferencesQ1,@DifferencesQ2,@DifferencesQ3,@DifferencesQ4
        END
    CLOSE @PRODUCT_CUR3
    DEALLOCATE @PRODUCT_CUR3 ;
	
	--End Amendment
	
	DECLARE @AopTotalString NVARCHAR(1000)
	SELECT @AopTotalString=dbo.GetFormatString( ISNULL(@AopTotal,0),0)
	SET @AopTotalString=REPLACE(@AopTotalString,',','')
	
	
	--6. 判断Amendment指标是否超过10%
	SET @ExceedTenPercent=1;
	
	IF @ContractType='Amendment'
	BEGIN
		IF EXISTS( SELECT 1 FROM V_AOPDealer_Temp a 
		inner join V_AOPDealer b ON a.AOPD_Dealer_DMA_ID=b.AOPD_Dealer_DMA_ID 
		and a.AOPD_Market_Type=b.AOPD_Market_Type 
		and a.AOPD_ProductLine_BUM_ID =b.AOPD_ProductLine_BUM_ID
		and a.AOPD_CC_ID=b.AOPD_CC_ID
		and a.AOPD_Year=b.AOPD_Year 
		and a.AOPD_Contract_ID=@Contract_ID
		AND (A.AOPD_Amount_Y-B.AOPD_Amount_Y)<>0
		AND (ABS(A.AOPD_Amount_Y-B.AOPD_Amount_Y)/A.AOPD_Amount_Y) >0.1
		) 
		BEGIN
			SET @ExceedTenPercent=0;
			 
		END
		
	END
	
	--7. 产品组最小指标校验
	SET @ProductGroupCheck=1;
	DECLARE @ProductGroupAmount DECIMAL(18,4);
	DECLARE @ProductGroupAmountMin DECIMAL(18,4);
	SELECT @ProductGroupAmountMin=SUM(PG_Amount) FROM dbo.AOPProductGroup A 
	WHERE EXISTS (SELECT 1 FROM AOPDealerHospitalTemp B 
					WHERE B.AOPDH_Contract_ID=@Contract_ID 
					AND B.AOPDH_ProductLine_BUM_ID=A.PG_ProductLineId 
					AND b.AOPDH_PCT_ID in (select distinct c.CQ_ID from dbo.GC_Fn_SplitStringToTable(a.PG_AOPCode,','),interface.ClassificationQuota C where c.CQ_Code=VAL) )
	IF @ProductGroupAmountMin>0
	BEGIN
		SELECT @ProductGroupAmount=SUM(A.AOPDH_Amount) FROM AOPDealerHospitalTemp A  
		WHERE A.AOPDH_Contract_ID=@Contract_ID and CONVERT(INT,a.AOPDH_Year)=YEAR(@LastBeginDate)  AND A.AOPDH_PCT_ID 
		IN (SELECT distinct CQ_ID  FROM interface.ClassificationQuota B 
				inner join dbo.AOPProductGroup C on b.CQ_Code in (select VAL from dbo.GC_Fn_SplitStringToTable(c.PG_AOPCode,',')) )
		DECLARE @T INT
		
		IF YEAR(@LastBeginDate)=YEAR(@EndDate)
		BEGIN
			SET @T= MONTH(@EndDate)-MONTH(@LastBeginDate)+1
		END
		ELSE
		BEGIN
			SET @T= 13-MONTH(@LastBeginDate)
		END
		IF @ProductGroupAmount<(@ProductGroupAmountMin/12) *@T
		BEGIN
			SET @ProductGroupCheck=0;
			SET @ProductGroupRemark='经销商产品组指标'+dbo.GetFormatString(@ProductGroupAmount,2) +'小于最小指标'+dbo.GetFormatString(@ProductGroupAmountMin,2)
		END
	END
	
	--8.授权医院所在省份汇总
	SELECT @TerritoryString=
	STUFF(REPLACE(REPLACE((
				SELECT A.Province RESULT FROM (SELECT DISTINCT C.HOS_Province AS Province FROM DealerAuthorizationTableTemp a 
					INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
					INNER JOIN Hospital C ON C.HOS_ID=B.HOS_ID
				WHERE A.DAT_DCL_ID=@Contract_ID) A 
					FOR XML AUTO
				), '<A RESULT="', ','), '"/>', ''), 1, 1, '')
				
	
	INSERT INTO #tbReturn (Hospital,HospitalQty,Aop,AopTotal,ProductClassification,ProductPrice,ProductLine,ProductRebate,AopFormal,AopDifferences,AreaQty,Area,CheckData,QuarterChange , DealerLessHos, HosLessStandard ,HosHavZorro ,AllProductAOP,DealerLessHosQ,DealerLessHosQRemark,HosLessStandardQ,HosLessStandardQRemark,ExceedTenPercent,ProductGroupCheck,ProductGroupRemark,TerritoryString) 
	VALUES(@Hospital,@HospitalQuty,@Aop,@AopTotalString,@ProClass,@ProPrice,@ProProductLine,@ProRebate,@RtnFormalVal,@RtnDifferencesVal,@AreaCount,@Area,@CheckData,@QuarterChange , @DealerLessHos, @HosLessStandard ,@HosHavZorro ,@AllProductAOP,@DealerLessHosQ,@DealerLessHosQRemark,@HosLessStandardQ,@HosLessStandardQRemark,@ExceedTenPercent,@ProductGroupCheck,@ProductGroupRemark,@TerritoryString)
	
	--table 1 汇总校验信息
	SELECT * FROM #tbReturn
	
	--table 2 查询指标与占比
	INSERT INTO #AOPReturn(DealerId,CC_ID,Year,Q1,Q2,Q3,Q4,SumYear)
	SELECT a.AOPD_Dealer_DMA_ID,a.AOPD_CC_ID,A.AOPD_Year as N'Year',SUM(a.AOPD_Amount_1+a.AOPD_Amount_2+a.AOPD_Amount_3)Q1 ,
		SUM(a.AOPD_Amount_4+a.AOPD_Amount_5+a.AOPD_Amount_6)Q2,
		SUM(a.AOPD_Amount_7+a.AOPD_Amount_8+a.AOPD_Amount_9)Q3 ,
		SUM(a.AOPD_Amount_10+a.AOPD_Amount_11+a.AOPD_Amount_12)Q4,
		SUM(A.AOPD_Amount_Y) SumYear
	FROM V_AOPDealer_Temp A 
	WHERE A.AOPD_Contract_ID=@Contract_ID
	GROUP BY a.AOPD_Dealer_DMA_ID,a.AOPD_CC_ID,A.AOPD_Year
	
	--一级/LP采购
	INSERT INTO #Purchase(Year,SumPurchase)
	SELECT C.[Year],SUM(C.PurchaseAmount) 
	FROM #AOPReturn A 
	INNER JOIN DealerMaster B ON B.DMA_ID=A.DealerId 
	INNER JOIN INTERFACE.T_I_QV_BSCPurchase C ON C.SAPID=B.DMA_SAP_Code  
			AND CONVERT(nvarchar(10),C.transactionDate,120) >=CONVERT(nvarchar(10),DATEADD(YYYY,-1,@BeginDate),120) 
		AND CONVERT(nvarchar(10),C.transactionDate,120) <=CONVERT(nvarchar(10),DATEADD(YYYY,-1,@EndDate),120)
	INNER JOIN CFN ON C.UPN=CFN_CustomerFaceNbr
	WHERE EXISTS(SELECT 1 FROM V_ProductClassificationStructure PS WHERE PS.CC_ID=A.CC_ID AND CFN_ProductCatagory_PCT_ID=PS.CA_ID)
	OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure PS WHERE PS.CC_ID=A.CC_ID AND CFN_ProductLine_BUM_ID=PS.CA_ID)
	GROUP BY C.[Year]
	
	
	IF EXISTS (SELECT 1 FROM #Purchase)
	BEGIN
		UPDATE A SET A.LastSales=B.SumPurchase,A.AOPRatio=(B.SumPurchase/SumYear)
		FROM #AOPReturn A,#Purchase B WHERE A.Year=B.Year AND ISNULL(B.SumPurchase,0)>0 AND ISNULL(SumYear,0)>0
	END
	SELECT Year,Q1,Q2,Q3,Q4,SumYear,LastSales,AOPRatio FROM #AOPReturn
	
	
	--table3 授权医院在其他产品线授权经销商
	IF @ContractType='Appointment'
	BEGIN
		SELECT F.DMA_SAP_Code SAPCode,F.DMA_ChineseName DealerName,E.HOS_Key_Account HospitalCode,E.HOS_HospitalName HospitalName FROM DealerAuthorizationTable c 
		INNER JOIN HospitalList  d on c.DAT_ID=d.HLA_DAT_ID
		INNER JOIN Hospital E ON E.HOS_ID=D.HLA_HOS_ID
		INNER JOIN DealerMaster F ON F.DMA_ID=C.DAT_DMA_ID
		WHERE  CONVERT(NVARCHAR(10),GETDATE(),120)>=CONVERT(NVARCHAR(10),c.DAT_StartDate ,120)
		AND CONVERT(NVARCHAR(10),GETDATE(),120)<=CONVERT(NVARCHAR(10),DAT_EndDate ,120)
		AND DAT_Type='Normal'
		AND NOT EXISTS(
		SELECT 1 FROM DealerAuthorizationTableTemp A 
		INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
		WHERE A.DAT_DCL_ID=@Contract_ID AND D.HLA_HOS_ID=B.HOS_ID  AND A.DAT_DMA_ID=C.DAT_DMA_ID)
	END
	
	END
	




GO


