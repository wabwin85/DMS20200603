DROP PROCEDURE [dbo].[Pro_DCMS_GetContractProperty_Last]
GO


/**********************************************
	功能：获取经销商上个合同授权数据
	作者：Huakaichun
	最后更新时间：	2016-06-14
	更新记录说明：
	1.创建 2016-06-14
	2.修改 2017-04-17 （最小指标设定逻辑调整。一个医院，有一个指标产品分类有标准指标，该产品其他产品分类不设最小指标）
**********************************************/
CREATE PROCEDURE [dbo].[Pro_DCMS_GetContractProperty_Last]
	@ContractId NVARCHAR(36),
	@DealerId NVARCHAR(36),
	@ProductLineId NVARCHAR(36),
	@SubBU NVARCHAR(50),
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PropertyType INT,  --0: 授权，1：指标，2：区域授权
	@ContractType NVARCHAR(50),
	@retMassage NVARCHAR(2000) OUTPUT
AS
BEGIN

DECLARE @LastContractId uniqueidentifier
DECLARE @BeginDateMonth INT
IF @ContractType='Amendment' AND MONTH(GETDATE())>=MONTH(@BeginDate) AND YEAR(@BeginDate)=YEAR(GETDATE()) AND EXISTS (SELECT 1 FROM interface.ClassificationContract WHERE CC_Code=@SubBU AND ISNULL(CC_RV3,'')<>'1')
BEGIN
	SET @BeginDateMonth=MONTH(@BeginDate)+1;
END
ELSE BEGIN
	SET @BeginDateMonth=MONTH(@BeginDate) ;
END


CREATE TABLE #monthAOPTemp
(
	AopMonth NVARCHAR(50)
)
CREATE TABLE #yearAOPTemp
(
	AopYear NVARCHAR(50)
)


create clustered index index_AopMonth on #monthAOPTemp(AopMonth)
create clustered index index_AopYear on #yearAOPTemp(AopYear)
	 
CREATE TABLE #ConTol
(
	ContractId uniqueidentifier,
	DealerId uniqueidentifier,
	SubBU NVARCHAR(50),
	MarketType INT,
	BeginDate DATETIME,
	EndDate DATETIME,
	ContractType NVARCHAR(50),
	UpdateDate DATETIME
)

INSERT INTO #ConTol (ContractId,DealerId,MarketType,BeginDate,EndDate,SubBU,ContractType,UpdateDate)
SELECT a.CAP_ID,a.CAP_DMA_ID,a.CAP_MarketType,CAP_EffectiveDate,CAP_ExpirationDate,a.CAP_SubDepID ,'Appointment',a.CAP_Update_Date from ContractAppointment a where a.CAP_Status='Completed' and a.CAP_DMA_ID=@DealerId and a.CAP_SubDepID=@SubBU 
UNION
SELECT a.CAM_ID,a.CAM_DMA_ID,a.CAM_MarketType,CAM_Amendment_EffectiveDate,CAM_Agreement_ExpirationDate,a.CAM_SubDepID,'Amendment',a.CAM_Update_Date from ContractAmendment a where a.CAM_Status='Completed' and (((@PropertyType=0 OR @PropertyType=2) AND a.CAM_Territory_IsChange='1') OR (@PropertyType=1 AND a.CAM_Quota_IsChange='1')) and a.CAM_DMA_ID=@DealerId and a.CAM_SubDepID=@SubBU 
UNION
SELECT  a.CRE_ID,a.CRE_DMA_ID,a.CRE_MarketType,CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Renewal,a.CRE_SubDepID,'Renewal',a.CRE_Update_Date  from ContractRenewal a where a.CRE_Status='Completed' and a.CRE_DMA_ID=@DealerId and a.CRE_SubDepID=@SubBU 
--UNION
--SELECT  a.CTE_ID,a.CTE_DMA_ID,a.CTE_MarketType,CTE_Termination_EffectiveDate,NULL,a.CTE_SubDepID,'Renewal',a.CTE_Update_Date  from ContractTermination a where a.CTE_Status='Completed' and a.CTE_DMA_ID=@DealerId and a.CTE_SubDepID=@SubBU

IF  EXISTS(SELECT 1 FROM #ConTol WHERE ContractId=@ContractId)
BEGIN
	DECLARE @UpdateDate DATETIME
	SELECT @UpdateDate =UpdateDate FROM #ConTol WHERE ContractId=@ContractId;
	SELECT TOP 1 @LastContractId=ContractId FROM #ConTol WHERE CONVERT(NVARCHAR(10),UpdateDate,120) <CONVERT(NVARCHAR(10),@UpdateDate,120)  ORDER BY UpdateDate DESC
END
ELSE
BEGIN
	SELECT TOP 1 @LastContractId=ContractId FROM #ConTol  ORDER BY UpdateDate DESC
END
IF @LastContractId IS NOT NULL 
	SET @retMassage=CONVERT(NVARCHAR(36),@LastContractId);


CREATE TABLE #MD
(
	OLD_DAT_ID uniqueidentifier,
	NEW_DAT_ID uniqueidentifier
)
create clustered index index_OLD_DAT_ID on #MD(OLD_DAT_ID)

IF @PropertyType=0 AND NOT EXISTS(SELECT 1 FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@ContractId)
BEGIN
	IF  @LastContractId IS NOT NULL
	BEGIN
	
		INSERT INTO #MD(OLD_DAT_ID,NEW_DAT_ID)
		SELECT A.DAT_ID,NEWID() FROM DealerAuthorizationTableTemp A 
		WHERE A.DAT_DCL_ID=@LastContractId 
		AND A.DAT_PMA_ID IN (SELECT distinct c.CA_ID FROM interface.ClassificationAuthorization c where (@BeginDate between CA_StartDate and CA_EndDate)  and c.CA_ParentCode=@SubBU and c.CA_ID is not null )

		INSERT INTO DealerAuthorizationTableTemp (DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription)
		SELECT DAT_PMA_ID,B.NEW_DAT_ID,@ContractId,@DealerId,isnull(DAT_DMA_ID_Actual,A.DAT_DMA_ID),DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription 
		FROM DealerAuthorizationTableTemp A 
		INNER JOIN #MD B ON A.DAT_ID=B.OLD_DAT_ID
		
		INSERT INTO ContractTerritory(ID,Contract_ID,HOS_ID,Territory_Type,HOS_Depart,HOS_DepartType,HOS_DepartRemark)
		SELECT NEWID(),B.NEW_DAT_ID,A.HOS_ID,'Old',A.HOS_Depart,A.HOS_DepartType,A.HOS_DepartRemark FROM ContractTerritory A 
		INNER JOIN #MD B ON A.Contract_ID=B.OLD_DAT_ID
		WHERE EXISTS(SELECT 1 FROM Hospital D WHERE D.HOS_ID=A.HOS_ID AND D.HOS_ActiveFlag=1)
	END
END
ELSE IF @PropertyType=2 AND NOT EXISTS(SELECT 1 FROM DealerAuthorizationAreaTemp WHERE DA_DCL_ID=@ContractId)
BEGIN
	IF  @LastContractId IS NOT NULL
	BEGIN

		INSERT INTO #MD(OLD_DAT_ID,NEW_DAT_ID)
		SELECT A.DA_ID,NEWID() FROM DealerAuthorizationAreaTemp A 
		WHERE A.DA_DCL_ID=@LastContractId 
		AND A.DA_PMA_ID IN (SELECT distinct c.CA_ID FROM interface.ClassificationAuthorization c where (isnull(@BeginDate,'2017-08-01') between c.CA_StartDate and c.CA_EndDate) and c.CA_ParentCode=@SubBU and c.CA_ID is not null )

		INSERT INTO DealerAuthorizationAreaTemp (DA_PMA_ID,DA_ID,DA_DCL_ID,DA_DMA_ID,DA_DMA_ID_Actual,DA_ProductLine_BUM_ID,DA_AuthorizationType)
		SELECT DA_PMA_ID,B.NEW_DAT_ID,@ContractId,@DealerId,DA_DMA_ID_Actual,DA_ProductLine_BUM_ID,DA_AuthorizationType
		FROM DealerAuthorizationAreaTemp A 
		INNER JOIN #MD B ON A.DA_ID=B.OLD_DAT_ID
		
		
		INSERT INTO TerritoryAreaExcTemp(TAE_DA_ID,TAE_HOS_ID,TAE_ID,TAE_Remark)
		SELECT B.NEW_DAT_ID,A.TAE_HOS_ID,NEWID(),A.TAE_Remark FROM TerritoryAreaExcTemp A 
		INNER JOIN #MD B ON A.TAE_DA_ID=B.OLD_DAT_ID
		
		INSERT INTO TerritoryAreaTemp(TA_DA_ID,TA_ID,TA_Area,TA_Remark)
		SELECT B.NEW_DAT_ID,NEWID(),A.TA_Area,A.TA_Remark FROM TerritoryAreaTemp A 
		INNER JOIN #MD B ON A.TA_DA_ID=B.OLD_DAT_ID
		
	END
END
ELSE IF @PropertyType=1
BEGIN
	
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('01');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('02');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('03');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('04');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('05');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('06');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('07');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('08');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('09');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('10');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('11');
	INSERT INTO #monthAOPTemp(AopMonth) VALUES('12');
	
	
	Declare @Count int,@PCount int
	set @Count=YEAR(@BeginDate)
	set @PCount=YEAR(@EndDate)
	while @Count<=@PCount
	BEGIN
		INSERT INTO #yearAOPTemp(AopYear) VALUES(CONVERT(NVARCHAR(5),@Count))
		SET @Count=@Count+1;
	END
	
	CREATE TABLE #aop
	(
		DealerId uniqueidentifier,
		ProductLineId uniqueidentifier,
		PCT_ID uniqueidentifier,
		HospitalId uniqueidentifier,
		AOPYear NVARCHAR(50),
		AOPMonth NVARCHAR(50),
	
		AOP_History  float,--历史指标
		AOP_Standard float,--标准指标
		AOP_Min float,--最小指标
		
		DeleteFlg INT
	)
	create clustered index index_producthosaop on #aop(PCT_ID,HospitalId,AOPYear,AOPMonth)
	
	--上个合同医院指标
	IF (@LastContractId IS NOT NULL) and (exists (select 1 from AOPDealerHospitalTemp where AOPDH_Contract_ID=@LastContractId ))
	BEGIN
		INSERT INTO #aop(DealerId,ProductLineId,PCT_ID,HospitalId,AOPYear,AOPMonth,AOP_History)
		SELECT isnull(A.AOPDH_Dealer_DMA_ID_Actual,a.AOPDH_Dealer_DMA_ID),A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year,A.AOPDH_Month ,AOPDH_Amount
		FROM AOPDealerHospitalTemp a 
		WHERE A.AOPDH_Contract_ID=@LastContractId  
		AND CONVERT(INT,A.AOPDH_Year) >=YEAR(@BeginDate) 
		AND CONVERT(INT,A.AOPDH_Year)<=YEAR(@EndDate)
		AND A.AOPDH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure WHERE CC_Code=@SubBU AND @BeginDate Between StartDate AND EndDate)
		;
	END
	ELSE IF (@LastContractId IS NOT NULL) and (NOT exists (select 1 from AOPDealerHospitalTemp where AOPDH_Contract_ID=@LastContractId ))
	BEGIN
		--临时表被删除
		INSERT INTO #aop(DealerId,ProductLineId,PCT_ID,HospitalId,AOPYear,AOPMonth,AOP_History)
		SELECT A.AOPDH_Dealer_DMA_ID,A.AOPDH_ProductLine_BUM_ID,A.AOPDH_PCT_ID,A.AOPDH_Hospital_ID,A.AOPDH_Year,A.AOPDH_Month ,AOPDH_Amount
		FROM AOPDealerHospital a 
		WHERE A.AOPDH_Dealer_DMA_ID=@DealerId  
		AND CONVERT(INT,A.AOPDH_Year) >=YEAR(@BeginDate) 
		AND CONVERT(INT,A.AOPDH_Year)<=YEAR(@EndDate)
		AND A.AOPDH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure WHERE CC_Code=@SubBU AND @BeginDate Between StartDate AND EndDate)
		;
	END
	--UPDATE #aop SET AOP_History=0 WHERE ISNULL(AOP_History,0)=0;
	
	--维护本次合同新增的合同产品
	
	INSERT INTO #aop(DealerId,ProductLineId,PCT_ID,HospitalId,AOPYear,AOPMonth)
	SELECT DAT_DMA_ID,DAT_ProductLine_BUM_ID,CQ_ID,HOS_ID,E.AopYear,F.AopMonth FROM (
	SELECT A.DAT_DMA_ID,A.DAT_ProductLine_BUM_ID,C.CQ_ID,B.HOS_ID 
	FROM DealerAuthorizationTableTemp A 
	INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID 
	INNER JOIN (SELECT DISTINCT CA_ID,CQ_ID FROM V_ProductClassificationStructure WHERE CC_Code=@SubBU AND CQ_ID IS NOT NULL AND @BeginDate Between StartDate AND EndDate) C ON C.CA_ID=A.DAT_PMA_ID 
	WHERE A.DAT_DCL_ID=@ContractId
	) TAB,#yearAOPTemp E,#monthAOPTemp F
	WHERE NOT EXISTS 
		(SELECT 1 FROM #aop EX 
		WHERE EX.HospitalId=TAB.HOS_ID 
		AND ex.PCT_ID=TAB.CQ_ID
		AND EX.ProductLineId=TAB.DAT_ProductLine_BUM_ID
		AND EX.AOPYear=e.AopYear 
		)
		
	--维护删除状态
	UPDATE A SET A.DeleteFlg=1 FROM #aop A WHERE NOT EXISTS (SELECT 1 FROM (
				SELECT A.DAT_DMA_ID,A.DAT_ProductLine_BUM_ID,C.CQ_ID,B.HOS_ID 
				FROM DealerAuthorizationTableTemp A 
				INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID 
				INNER JOIN (SELECT DISTINCT CA_ID,CQ_ID FROM V_ProductClassificationStructure WHERE CC_Code=@SubBU AND CQ_ID IS NOT NULL AND @BeginDate Between StartDate AND EndDate) C ON C.CA_ID=A.DAT_PMA_ID
				WHERE A.DAT_DCL_ID=@ContractId
				) TAB WHERE TAB.HOS_ID=A.HospitalId AND TAB.CQ_ID=A.PCT_ID AND TAB.DAT_DMA_ID=A.DealerId AND TAB.DAT_ProductLine_BUM_ID=a.ProductLineId)
	
	UPDATE #aop SET DeleteFlg=0 WHERE ISNULL(DeleteFlg,0)<>1;
	--维护标准指标
	UPDATE A SET   A.AOP_Standard=B.AOPHR_January FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='01' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_February FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='02' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_March FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='03' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_April FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='04' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_May FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='05' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_June FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='06' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_July FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='07' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_August FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='08' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_September FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='09' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_October FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='10' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_November FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='11' 
	UPDATE A SET   A.AOP_Standard=B.AOPHR_December FROM #aop  A,AOPHospitalReference B WHERE A.AOPYear=B.AOPHR_Year AND A.PCT_ID=B.AOPHR_PCT_ID AND A.HospitalId=B.AOPHR_Hospital_ID AND A.ProductLineId =B.AOPHR_ProductLine_BUM_ID AND A.AOPMonth='12' 
	
	
	--维护最小值
	--1.1确认最小值类型
	DECLARE @AvgAop money
	DECLARE @MinTypeAop NVARCHAR(20)
	IF  EXISTS (SELECT  1 FROM AOPMIN A INNER JOIN INTERFACE.ClassificationContract B ON A.AOPM_CC_ID=B.CC_ID WHERE A.AOPM_ProductLine_ID=@ProductLineId AND B.CC_Code=@SubBU AND CONVERT(INT,A.AOPM_Year)=YEAR(@BeginDate)  AND A.AOPM_CQ_ID IS NULL and (@BeginDate between CC_StartDate and CC_EndDate))
	BEGIN
		SET @AvgAop=0; 
		SET @MinTypeAop='CCAmont'  --同一医院同一合同分类，只有汇总最小指标
		SELECT @AvgAop=AOPM_Amount FROM AOPMIN A INNER JOIN INTERFACE.ClassificationContract B ON A.AOPM_CC_ID=B.CC_ID WHERE A.AOPM_ProductLine_ID=@ProductLineId AND B.CC_Code=@SubBU AND CONVERT(INT,A.AOPM_Year)=YEAR(@BeginDate)  AND A.AOPM_CQ_ID IS NULL and (@BeginDate between CC_StartDate and CC_EndDate) ;
		IF EXISTS (SELECT 1 FROM #aop WHERE ISNULL(DeleteFlg,0)<>1)
		BEGIN
			SET @AvgAop= @AvgAop/(SELECT COUNT( DISTINCT PCT_ID ) FROM #aop WHERE ISNULL(DeleteFlg,0)<>1);
		END
		ELSE
		BEGIN
			SET @AvgAop=0
		END
	END
	ELSE IF EXISTS (SELECT  1 FROM AOPMIN A INNER JOIN INTERFACE.ClassificationContract B ON A.AOPM_CC_ID=B.CC_ID WHERE  A.AOPM_ProductLine_ID=@ProductLineId AND B.CC_Code=@SubBU AND A.AOPM_CQ_ID IN (SELECT PCT_ID FROM #aop WHERE ISNULL(DeleteFlg,0)<>1) AND CONVERT(INT,A.AOPM_Year)=YEAR(@BeginDate) and (@BeginDate between CC_StartDate and CC_EndDate))
	BEGIN
		SET @MinTypeAop='CQAmont'
	END
	ELSE 
	BEGIN
		SET @MinTypeAop=''
	END
	
	IF @MinTypeAop='CCAmont' 
	BEGIN
		UPDATE A SET A.AOP_Min=@AvgAop  FROM #aop A WHERE CONVERT(INT,A.AOPYear)=YEAR(@BeginDate)
			AND NOT EXISTS (SELECT 1 FROM (select distinct M.AOPYear,M.HospitalId from #aop M WHERE (M.AOP_History<>0 OR M.AOP_Standard<>0)) H WHERE H.HospitalId=A.HospitalId AND A.AOPYear=H.AOPYear);
			
		UPDATE A SET A.AOP_Min=0  FROM #aop A WHERE CONVERT(INT,A.AOPYear)<>YEAR(@BeginDate)
	END
	IF @MinTypeAop='CQAmont' 
	BEGIN
		UPDATE A SET A.AOP_Min=B.AOPM_Amount  FROM #aop A ,AOPMIN B WHERE A.PCT_ID=B.AOPM_CQ_ID AND B.AOPM_ProductLine_ID=A.ProductLineId AND B.AOPM_Year=A.AOPYear
		AND NOT EXISTS (SELECT 1 FROM (select distinct M.AOPYear,M.HospitalId from #aop M WHERE (M.AOP_History<>0 OR M.AOP_Standard<>0)) H WHERE H.HospitalId=A.HospitalId AND A.AOPYear=H.AOPYear)
	END
	
	
	--维护正式表
	INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID,AOPDH_Amount)
	SELECT NEWID(),@ContractId,A.DealerId,NULL,A.ProductLineId,A.HospitalId,A.AOPYear,A.AOPMonth,NULL,GETDATE(),A.PCT_ID ,
	CASE WHEN A.AOP_History IS NOT NULL  THEN A.AOP_History
		 ELSE 0  END
	FROM #aop A 
	WHERE (CONVERT(INT,A.AOPYear)=YEAR(@BeginDate) AND CONVERT(INT,A.AOPMonth)<@BeginDateMonth)
	AND NOT EXISTS(SELECT 1 FROM AOPDealerHospitalTemp B WHERE B.AOPDH_Contract_ID=@ContractId AND B.AOPDH_Hospital_ID=A.HospitalId AND B.AOPDH_PCT_ID=A.PCT_ID AND B.AOPDH_Year=A.AOPYear AND CONVERT(INT,B.AOPDH_Month)=CONVERT(INT,A.AOPMonth)) 
	
	INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID,AOPDH_Amount)
	SELECT NEWID(),@ContractId,A.DealerId,NULL,A.ProductLineId,A.HospitalId,A.AOPYear,A.AOPMonth,NULL,GETDATE(),A.PCT_ID ,
	CASE WHEN A.AOP_History IS NOT NULL  THEN A.AOP_History
		 WHEN A.AOP_History IS NULL AND  A.AOP_Standard IS NOT NULL THEN A.AOP_Standard 
		 WHEN A.AOP_History IS NULL AND  A.AOP_Standard IS NULL AND A.AOP_Min IS NOT NULL THEN A.AOP_Min 
		 ELSE 0  END
	FROM #aop A 
	WHERE ((CONVERT(INT,A.AOPYear)=YEAR(@BeginDate) AND CONVERT(INT,A.AOPMonth)>=@BeginDateMonth) OR (CONVERT(INT,A.AOPYear)>YEAR(@BeginDate)))
	AND NOT EXISTS(SELECT 1 FROM AOPDealerHospitalTemp B WHERE B.AOPDH_Contract_ID=@ContractId AND B.AOPDH_Hospital_ID=A.HospitalId AND B.AOPDH_PCT_ID=A.PCT_ID AND B.AOPDH_Year=A.AOPYear AND CONVERT(INT,B.AOPDH_Month)=CONVERT(INT,A.AOPMonth)) 
	
	--删除部分未来月份指标设置为0
	
	UPDATE A SET A.AOPDH_Amount=0  
	FROM AOPDealerHospitalTemp A 
	INNER JOIN #aop B ON A.AOPDH_Contract_ID=@ContractId AND B.HospitalId=A.AOPDH_Hospital_ID AND A.AOPDH_PCT_ID=B.PCT_ID AND A.AOPDH_Year=B.AOPYear AND A.AOPDH_Month=B.AOPMonth
	WHERE B.DeleteFlg=1 
	AND ((CONVERT(INT,A.AOPDH_Year)=YEAR(@BeginDate) AND CONVERT(INT,A.AOPDH_Month)>=@BeginDateMonth) OR (CONVERT(INT,A.AOPDH_Year)>YEAR(@BeginDate)))
	
	--删除终止日期以后指标
	UPDATE A SET A.AOPDH_Amount=0  
	FROM AOPDealerHospitalTemp A 
	INNER JOIN #aop B ON A.AOPDH_Contract_ID=@ContractId 
	AND B.HospitalId=A.AOPDH_Hospital_ID 
	AND A.AOPDH_PCT_ID=B.PCT_ID 
	AND A.AOPDH_Year=B.AOPYear 
	AND A.AOPDH_Month=B.AOPMonth
	WHERE B.DeleteFlg=0
	AND CONVERT(INT,A.AOPDH_Year)=YEAR(@EndDate) 
	AND CONVERT(INT,A.AOPDH_Month)>MONTH(@EndDate)
	
	--删除全年续约终止授权医院指标
	IF @LastContractId IS NOT NULL
	BEGIN
	DELETE C  FROM AOPDealerHospitalTemp C 
	WHERE  c.AOPDH_Contract_ID=@ContractId and NOT EXISTS (SELECT 1 FROM (
				SELECT A.DAT_DMA_ID,A.DAT_ProductLine_BUM_ID,C.CQ_ID,B.HOS_ID 
				FROM DealerAuthorizationTableTemp A 
				INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID 
				INNER JOIN (SELECT DISTINCT CA_ID,CQ_ID FROM V_ProductClassificationStructure WHERE CQ_ID IS NOT NULL AND @BeginDate Between StartDate AND EndDate) C ON C.CA_ID=A.DAT_PMA_ID
				WHERE A.DAT_DCL_ID=@ContractId
				) tb WHERE TB.CQ_ID=C.AOPDH_PCT_ID AND tb.HOS_ID=C.AOPDH_Hospital_ID
				)
	   AND NOT EXISTS( SELECT 1 FROM V_AOPDealerHospital_Temp TP 
						   WHERE  TP.AOPDH_Contract_ID=@LastContractId
						   AND C.AOPDH_Year=TP.AOPDH_Year 
						   AND C.AOPDH_Hospital_ID=TP.AOPDH_Hospital_ID
						   AND C.AOPDH_PCT_ID=TP.AOPDH_PCT_ID
						   )
	 END
	 ELSE
	 BEGIN
		DELETE C  FROM AOPDealerHospitalTemp C 
			WHERE c.AOPDH_Contract_ID=@ContractId and NOT EXISTS (SELECT 1 FROM (
						SELECT A.DAT_DMA_ID,A.DAT_ProductLine_BUM_ID,C.CQ_ID,B.HOS_ID 
						FROM DealerAuthorizationTableTemp A 
						INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID 
						INNER JOIN (SELECT DISTINCT CA_ID,CQ_ID FROM V_ProductClassificationStructure WHERE CQ_ID IS NOT NULL AND @BeginDate Between StartDate AND EndDate) C ON C.CA_ID=A.DAT_PMA_ID
						WHERE A.DAT_DCL_ID=@ContractId
						) tb WHERE TB.CQ_ID=C.AOPDH_PCT_ID AND tb.HOS_ID=C.AOPDH_Hospital_ID
						)
	 END
END

DROP TABLE #monthAOPTemp
DROP TABLE #yearAOPTemp 
DROP TABLE #ConTol

IF ISNULL(@retMassage,'')='' 
	SET @retMassage='';

END  

GO


