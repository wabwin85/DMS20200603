DROP PROCEDURE [interface].[P_I_EW_ContractAOPComplete]
GO



CREATE PROCEDURE [interface].[P_I_EW_ContractAOPComplete]
@Contract_ID nvarchar(36), @Contract_Type nvarchar(50),@RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
WITH EXEC AS CALLER
AS
DECLARE @MarktType NVARCHAR(10)
DECLARE @SubDepID NVARCHAR(50)
DECLARE @Division NVARCHAR(10)
DECLARE @CC_ID uniqueidentifier
DECLARE @DMA_ID uniqueidentifier
DECLARE @BeginDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @BeginMonth INT
DECLARE @BeginYear INT
DECLARE @IYear INT
DECLARE @EndYear INT
DECLARE @YEARSTRING NVARCHAR(MAX);
DECLARE @ProductLineId uniqueidentifier

DECLARE @AMENDMENTBEGINDATE INT

CREATE TABLE #Temp
(
	HospitalId uniqueidentifier,
	PCT_ID uniqueidentifier
)
CREATE TABLE #TempPrice
(
	Id uniqueidentifier,
	Dma_id uniqueidentifier,
	Hos_Id uniqueidentifier,
	PCT_ID uniqueidentifier,
	PCP_ID uniqueidentifier
)

DECLARE @HasChange BIT
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	/*1. 数据准备*/
	SELECT  @MarktType= CONVERT(NVARCHAR(10),ISNULL(MarketType,0)),@SubDepID= SubDepID,@Division=Division 
		FROM Interface.T_I_EW_Contract A WHERE A.InstanceID=@Contract_ID;
	SELECT @CC_ID= CC_ID FROM interface.ClassificationContract a WHERE A.CC_Code=@SubDepID;
	SELECT @ProductLineId=A.ProductLineID FROM V_DivisionProductLineRelation A WHERE A.IsEmerging='0' AND A.DivisionName=@Division;
	--获取合同开始时间
	IF @Contract_Type='Appointment'
	BEGIN
		SELECT @BeginDate=CAP_EffectiveDate,@EndDate=CAP_ExpirationDate,@DMA_ID=CAP_DMA_ID FROM ContractAppointment A WHERE A.CAP_ID=@Contract_ID
		SET @HasChange=1;
	END
	IF @Contract_Type='Amendment'
	BEGIN
		SELECT @BeginDate=CAM_Amendment_EffectiveDate, @EndDate=CAM_Agreement_ExpirationDate,@DMA_ID=CAM_DMA_ID 
		,@HasChange=ISNULL(CAM_Quota_IsChange,0)
		FROM ContractAmendment A WHERE A.CAM_ID=@Contract_ID
	END
	IF @Contract_Type='Renewal'
	BEGIN
		SELECT @BeginDate=CRE_Agrmt_EffectiveDate_Renewal,@EndDate=CRE_Agrmt_ExpirationDate_Renewal,@DMA_ID=CRE_DMA_ID FROM ContractRenewal A WHERE A.CRE_ID=@Contract_ID
		SET @HasChange=1;
	END
	IF @HasChange=1
	BEGIN
		SET @BeginMonth=MONTH(@BeginDate);
		--如果是Amendment 需要查看当前月份指标是否能够被修改
		--(15号只控制在提申请操作界面，不控制在审批完成后同步数据)
		--begin add on 2016-5-12
		--IF @Contract_Type='Amendment'
		--BEGIN
		--	SELECT @AMENDMENTBEGINDATE=CONVERT(INT,ValueDate) FROM ContractConfig A
		--	WHERE CONVERT(NVARCHAR(10), A.DateEnd, 112) >= CONVERT(NVARCHAR(10), @BeginDate, 112)
		--	AND CONVERT(NVARCHAR(10), A.DateBegin, 112) <= CONVERT(NVARCHAR(10), @BeginDate, 112)
		--	SET @AMENDMENTBEGINDATE=ISNULL(@AMENDMENTBEGINDATE,15);
			
		--	IF DAY(@BeginDate) >@AMENDMENTBEGINDATE
		--	BEGIN
		--		SET @BeginMonth +=1;
		--	END
		--END
		--end add on 2016-5-12
		
		SET @BeginYear=YEAR(@BeginDate);
		SET @EndYear=YEAR(@EndDate);
		SET @YEARSTRING='1900,';
		SET @IYear=@BeginYear+1;
		WHILE  @IYear<= @EndYear
		BEGIN
			SET @YEARSTRING+=(CONVERT(NVARCHAR(8),@IYear)+',');
			SET @IYear+=1;
		END
		
		/*2. 经销商指标*/
		--删除开始年份开始月份以后的指标 和 之后年份的指标
		DELETE A FROM AOPDealer A 
		INNER JOIN AOPDealerTemp  B ON A.AOPD_Dealer_DMA_ID=B.AOPD_Dealer_DMA_ID_Actual 
			AND B.AOPD_ProductLine_BUM_ID=A.AOPD_ProductLine_BUM_ID
			AND B.AOPD_CC_ID=A.AOPD_CC_ID
			AND ISNULL(B.AOPD_Market_Type,'0')=ISNULL(A.AOPD_Market_Type,'0')
			AND A.AOPD_Year=B.AOPD_Year
			AND ((A.AOPD_Year=CONVERT(NVARCHAR(10),@BeginYear)AND CONVERT(INT,ISNULL(A.AOPD_Month,'0'))>= @BeginMonth)
				OR (A.AOPD_Year IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@YEARSTRING,',')))
				)
			AND B.AOPD_Contract_ID=@Contract_ID
		--维护经销商指标
		IF NOT EXISTS(SELECT 1 FROM AOPDealer A INNER JOIN AOPDealerTemp  B ON A.AOPD_Dealer_DMA_ID=B.AOPD_Dealer_DMA_ID_Actual 
			AND B.AOPD_ProductLine_BUM_ID=A.AOPD_ProductLine_BUM_ID
			AND B.AOPD_CC_ID=A.AOPD_CC_ID
			AND ISNULL(B.AOPD_Market_Type,'0')=ISNULL(A.AOPD_Market_Type,'0')
			AND A.AOPD_Year=B.AOPD_Year
			AND A.AOPD_Year=CONVERT(NVARCHAR(10),@BeginYear)
			AND B.AOPD_Contract_ID=@Contract_ID)
			
			BEGIN
				INSERT INTO AOPDealer(AOPD_CC_ID,AOPD_ID,AOPD_Dealer_DMA_ID,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date)
				SELECT AOPD_CC_ID,AOPD_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,@MarktType,AOPD_Year,AOPD_Month,'0',AOPD_Update_User_ID,AOPD_Update_Date 
				FROM AOPDealerTemp aop 
				WHERE aop.AOPD_Contract_ID=@Contract_ID AND aop.AOPD_Year=CONVERT(NVARCHAR(10),@BeginYear) and CONVERT(INT,ISNULL(aop.AOPD_Month,'0'))< @BeginMonth;
		
			END
		
		INSERT INTO AOPDealer(AOPD_CC_ID,AOPD_ID,AOPD_Dealer_DMA_ID,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date)
		SELECT AOPD_CC_ID,AOPD_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,@MarktType,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date 
		FROM AOPDealerTemp aop 
		WHERE aop.AOPD_Contract_ID=@Contract_ID AND aop.AOPD_Year=CONVERT(NVARCHAR(10),@BeginYear) and CONVERT(INT,ISNULL(aop.AOPD_Month,'0'))>= @BeginMonth;
		
		INSERT INTO AOPDealer(AOPD_CC_ID,AOPD_ID,AOPD_Dealer_DMA_ID,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date)
		SELECT AOPD_CC_ID,AOPD_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,@MarktType,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date 
		FROM AOPDealerTemp aop 
		WHERE aop.AOPD_Contract_ID=@Contract_ID AND aop.AOPD_Year IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@YEARSTRING,','))
		
		IF ISNULL(@MarktType,'0')='2' 
		BEGIN
			IF EXISTS(SELECT 1 FROM AOPDealerHospitalTemp WHERE AOPDH_Contract_ID=@Contract_ID)
			BEGIN
			/*3. 医院金额指标*/
				INSERT INTO #Temp(HospitalId,PCT_ID)
				SELECT DISTINCT A.AOPDH_Hospital_ID,A.AOPDH_PCT_ID FROM AOPDealerHospital A  
				WHERE A.AOPDH_Dealer_DMA_ID=@DMA_ID AND A.AOPDH_ProductLine_BUM_ID=@ProductLineId AND A.AOPDH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure WHERE CC_ID=@CC_ID AND (@BeginDate BETWEEN StartDate and EndDate ) )
				AND A.AOPDH_Year=CONVERT(NVARCHAR(10),@BeginYear)
				
				--新合同本年度不包含的医院指标分类组合之后月份设置为0
				UPDATE A  SET A.AOPDH_Amount=0
				FROM AOPDealerHospital A  
				WHERE A.AOPDH_Year=CONVERT(NVARCHAR(10),@BeginYear) AND  CONVERT(INT,ISNULL(A.AOPDH_Month,'0'))>= @BeginMonth
				AND A.AOPDH_ProductLine_BUM_ID=@ProductLineId
				AND A.AOPDH_Dealer_DMA_ID=@DMA_ID
				AND A.AOPDH_PCT_ID IN (SELECT PCT_ID FROM #Temp)
				AND NOT EXISTS (SELECT 1 FROM AOPDealerHospitalTemp B  WHERE B.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID AND B.AOPDH_PCT_ID=A.AOPDH_PCT_ID AND B.AOPDH_Contract_ID=@Contract_ID)
				
				--以后年份指标删除
				DELETE A FROM AOPDealerHospital A
				WHERE A.AOPDH_Dealer_DMA_ID=@DMA_ID
				AND A.AOPDH_ProductLine_BUM_ID=@ProductLineId
				AND A.AOPDH_PCT_ID IN (SELECT PCT_ID FROM #Temp)
				AND A.AOPDH_Year IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@YEARSTRING,','))
				
				--新合同包含的医院产品分类组合,本年度指标,根据开始时间更新指标
				UPDATE A SET AOPDH_Amount=B.AOPDH_Amount
				FROM AOPDealerHospital A,AOPDealerHospitalTemp B  
				WHERE A.AOPDH_Dealer_DMA_ID=B.AOPDH_Dealer_DMA_ID_Actual 
				AND A.AOPDH_Hospital_ID=B.AOPDH_Hospital_ID 
				AND A.AOPDH_Year=B.AOPDH_Year
				AND A.AOPDH_ProductLine_BUM_ID=B.AOPDH_ProductLine_BUM_ID
				AND A.AOPDH_PCT_ID=B.AOPDH_PCT_ID
				AND A.AOPDH_Year=CONVERT(NVARCHAR(10),@BeginYear)
				AND CONVERT(INT,ISNULL(A.AOPDH_Month,'0'))>= @BeginMonth
				AND A.AOPDH_Month=B.AOPDH_Month
				AND B.AOPDH_Contract_ID=@Contract_ID
				
				
				--新合同中,本年度不包含医院指标分类组合 以及 以后年份指标,新增进入正式表
					
				INSERT INTO AOPDealerHospital(AOPDH_PCT_ID,AOPDH_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Hospital_ID,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date)
				SELECT AOPDH_PCT_ID,AOPDH_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Hospital_ID,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date 
				FROM AOPDealerHospitalTemp aop 
				WHERE aop.AOPDH_Contract_ID=@Contract_ID 
				AND ((aop.AOPDH_Year=CONVERT(NVARCHAR(10),@BeginYear) 
						AND NOT EXISTS (SELECT 1 FROM #Temp B WHERE aop.AOPDH_PCT_ID=B.PCT_ID AND aop.AOPDH_Hospital_ID=B.HospitalId)
						AND aop.AOPDH_Month >=@BeginMonth
					)
					OR(aop.AOPDH_Year IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@YEARSTRING,','))))
				
				INSERT INTO AOPDealerHospital(AOPDH_PCT_ID,AOPDH_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Hospital_ID,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date)
				SELECT AOPDH_PCT_ID,AOPDH_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Hospital_ID,AOPDH_Month,'0',AOPDH_Update_User_ID,AOPDH_Update_Date 
				FROM AOPDealerHospitalTemp aop 
				WHERE aop.AOPDH_Contract_ID=@Contract_ID 
				AND aop.AOPDH_Year=CONVERT(NVARCHAR(10),@BeginYear) 
				AND NOT EXISTS (SELECT 1 FROM #Temp B WHERE aop.AOPDH_PCT_ID=B.PCT_ID AND aop.AOPDH_Hospital_ID=B.HospitalId)
				AND aop.AOPDH_Month <@BeginMonth
				
			END
			IF EXISTS(SELECT 1 FROM AOPICDealerHospitalTemp WHERE AOPICH_Contract_ID=@Contract_ID)
			BEGIN
			/*4. 医院数量指标*/
				INSERT INTO #Temp(HospitalId,PCT_ID)
				SELECT DISTINCT A.AOPICH_Hospital_ID,A.AOPICH_PCT_ID FROM AOPICDealerHospital A  
				WHERE A.AOPICH_DMA_ID=@DMA_ID AND A.AOPICH_ProductLine_ID=@ProductLineId AND A.AOPICH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure WHERE CC_ID=@CC_ID AND (@BeginDate BETWEEN StartDate and EndDate ))
				AND A.AOPICH_Year=CONVERT(NVARCHAR(10),@BeginYear)
				
				--新合同本年度不包含的医院指标分类组合之后月份设置为0
				UPDATE A  SET A.AOPICH_Unit=0
				FROM AOPICDealerHospital A  
				WHERE A.AOPICH_Year=CONVERT(NVARCHAR(10),@BeginYear) AND  CONVERT(INT,ISNULL(A.AOPICH_Month,'0'))>= @BeginMonth
				AND A.AOPICH_ProductLine_ID=@ProductLineId
				AND A.AOPICH_DMA_ID=@DMA_ID
				AND A.AOPICH_PCT_ID IN (SELECT PCT_ID FROM #Temp)
				AND NOT EXISTS (SELECT 1 FROM AOPICDealerHospitalTemp B  WHERE B.AOPICH_Hospital_ID=A.AOPICH_Hospital_ID AND B.AOPICH_PCT_ID=A.AOPICH_PCT_ID AND B.AOPICH_Contract_ID=@Contract_ID)
				
				--以后年份指标删除
				DELETE A FROM AOPICDealerHospital A
				WHERE A.AOPICH_DMA_ID=@DMA_ID
				AND A.AOPICH_ProductLine_ID=@ProductLineId
				AND A.AOPICH_PCT_ID IN (SELECT PCT_ID FROM #Temp)
				AND A.AOPICH_Year IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@YEARSTRING,','))
				
				--新合同包含的医院产品分类组合,本年度指标,根据开始时间更新指标
				UPDATE A SET AOPICH_Unit=B.AOPICH_Unit
				FROM AOPICDealerHospital A,AOPICDealerHospitalTemp B  
				WHERE A.AOPICH_DMA_ID=B.AOPICH_DMA_ID_Actual 
				AND A.AOPICH_Hospital_ID=B.AOPICH_Hospital_ID 
				AND A.AOPICH_Year=B.AOPICH_Year
				AND A.AOPICH_ProductLine_ID=B.AOPICH_ProductLine_ID
				AND A.AOPICH_PCT_ID=B.AOPICH_PCT_ID
				AND A.AOPICH_Year=CONVERT(NVARCHAR(10),@BeginYear)
				AND CONVERT(INT,ISNULL(A.AOPICH_Month,'0'))>= @BeginMonth
				AND A.AOPICH_Month=B.AOPICH_Month
				AND B.AOPICH_Contract_ID=@Contract_ID
				
				
				--新合同中,本年度不包含医院指标分类组合 以及 以后年份指标,新增进入正式表
					
				INSERT INTO AOPICDealerHospital( AOPICH_ID , AOPICH_DMA_ID , AOPICH_ProductLine_ID, AOPICH_PCT_ID, AOPICH_Year , AOPICH_Hospital_ID , AOPICH_Month, AOPICH_Unit, AOPICH_Update_User_ID, AOPICH_Update_Date)
				SELECT AOPICH_ID, AOPICH_DMA_ID_Actual, AOPICH_ProductLine_ID, AOPICH_PCT_ID, AOPICH_Year, AOPICH_Hospital_ID, AOPICH_Month, AOPICH_Unit, AOPICH_Update_User_ID, AOPICH_Update_Date
				FROM AOPICDealerHospitalTemp aop  
				WHERE aop.AOPICH_Contract_ID=@Contract_ID 
				AND ((aop.AOPICH_Year=CONVERT(NVARCHAR(10),@BeginYear) 
						AND NOT EXISTS (SELECT * FROM #Temp B WHERE aop.AOPICH_PCT_ID=B.PCT_ID AND aop.AOPICH_Hospital_ID=B.HospitalId)
						AND aop.AOPICH_Month >=@BeginMonth)
					OR(aop.AOPICH_Year IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@YEARSTRING,','))))
				
				INSERT INTO AOPICDealerHospital( AOPICH_ID , AOPICH_DMA_ID , AOPICH_ProductLine_ID, AOPICH_PCT_ID, AOPICH_Year , AOPICH_Hospital_ID , AOPICH_Month, AOPICH_Unit, AOPICH_Update_User_ID, AOPICH_Update_Date)
				SELECT AOPICH_ID, AOPICH_DMA_ID_Actual, AOPICH_ProductLine_ID, AOPICH_PCT_ID, AOPICH_Year, AOPICH_Hospital_ID, AOPICH_Month, '0', AOPICH_Update_User_ID, AOPICH_Update_Date
				FROM AOPICDealerHospitalTemp aop  
				WHERE aop.AOPICH_Contract_ID=@Contract_ID 
				AND aop.AOPICH_Year=CONVERT(NVARCHAR(10),@BeginYear) 
				AND NOT EXISTS (SELECT 1 FROM #Temp B WHERE aop.AOPICH_PCT_ID=B.PCT_ID AND aop.AOPICH_Hospital_ID=B.HospitalId)
				AND aop.AOPICH_Month <@BeginMonth
			END
		END
		ELSE
		BEGIN
			IF EXISTS(SELECT 1 FROM AOPDealerHospitalTemp WHERE AOPDH_Contract_ID=@Contract_ID)
			BEGIN
			/*3. 医院金额指标*/
				INSERT INTO #Temp(HospitalId,PCT_ID)
				SELECT DISTINCT A.AOPDH_Hospital_ID,A.AOPDH_PCT_ID FROM AOPDealerHospital A  
				INNER JOIN V_AllHospitalMarketProperty B  ON A.AOPDH_Hospital_ID=B.Hos_Id 
					AND CONVERT(NVARCHAR(10),B.MarketProperty)=@MarktType 
					AND B.ProductLineID=A.AOPDH_ProductLine_BUM_ID
					WHERE A.AOPDH_Dealer_DMA_ID=@DMA_ID AND A.AOPDH_ProductLine_BUM_ID=@ProductLineId AND A.AOPDH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure WHERE CC_ID=@CC_ID AND (@BeginDate BETWEEN StartDate and EndDate ))
				AND A.AOPDH_Year=CONVERT(NVARCHAR(10),@BeginYear)
				
				--新合同本年度不包含的医院指标分类组合之后月份设置为0
				UPDATE A  SET A.AOPDH_Amount=0
				FROM AOPDealerHospital A  
				INNER JOIN V_AllHospitalMarketProperty B ON A.AOPDH_Hospital_ID=B.Hos_Id AND A.AOPDH_ProductLine_BUM_ID=B.ProductLineID AND CONVERT(NVARCHAR(10),B.MarketProperty)=@MarktType 
				WHERE A.AOPDH_Year=CONVERT(NVARCHAR(10),@BeginYear) AND  CONVERT(INT,ISNULL(A.AOPDH_Month,'0'))>= @BeginMonth
				AND A.AOPDH_ProductLine_BUM_ID=@ProductLineId
				AND A.AOPDH_Dealer_DMA_ID=@DMA_ID
				AND A.AOPDH_PCT_ID IN (SELECT PCT_ID FROM #Temp)
				AND NOT EXISTS (SELECT 1 FROM AOPDealerHospitalTemp B  WHERE B.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID AND B.AOPDH_PCT_ID=A.AOPDH_PCT_ID AND B.AOPDH_Contract_ID=@Contract_ID)
				
				--以后年份指标删除
				DELETE A FROM AOPDealerHospital A ,V_AllHospitalMarketProperty B 
				WHERE A.AOPDH_Dealer_DMA_ID=@DMA_ID
				AND A.AOPDH_ProductLine_BUM_ID=@ProductLineId
				AND A.AOPDH_PCT_ID IN (SELECT PCT_ID FROM #Temp)
				AND A.AOPDH_Year IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@YEARSTRING,','))
				AND A.AOPDH_Hospital_ID=B.Hos_Id AND A.AOPDH_ProductLine_BUM_ID=B.ProductLineID AND CONVERT(NVARCHAR(10),B.MarketProperty)=@MarktType 
				
				--新合同包含的医院产品分类组合,本年度指标,根据开始时间更新指标
				UPDATE A SET AOPDH_Amount=B.AOPDH_Amount
				FROM AOPDealerHospital A,AOPDealerHospitalTemp B  
				WHERE A.AOPDH_Dealer_DMA_ID=B.AOPDH_Dealer_DMA_ID_Actual 
				AND A.AOPDH_Hospital_ID=B.AOPDH_Hospital_ID 
				AND A.AOPDH_Year=B.AOPDH_Year
				AND A.AOPDH_ProductLine_BUM_ID=B.AOPDH_ProductLine_BUM_ID
				AND A.AOPDH_PCT_ID=B.AOPDH_PCT_ID
				AND A.AOPDH_Year=CONVERT(NVARCHAR(10),@BeginYear)
				AND A.AOPDH_Month=B.AOPDH_Month
				AND CONVERT(INT,ISNULL(A.AOPDH_Month,'0'))>= @BeginMonth
				AND B.AOPDH_Contract_ID=@Contract_ID
				
				
				--新合同中,本年度不包含医院指标分类组合 以及 以后年份指标,新增进入正式表
					
				INSERT INTO AOPDealerHospital(AOPDH_PCT_ID,AOPDH_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Hospital_ID,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date)
				SELECT AOPDH_PCT_ID,AOPDH_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Hospital_ID,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date 
				FROM AOPDealerHospitalTemp aop 
				WHERE aop.AOPDH_Contract_ID=@Contract_ID 
				AND ((aop.AOPDH_Year=CONVERT(NVARCHAR(10),@BeginYear) 
						AND NOT EXISTS (SELECT 1 FROM #Temp B WHERE aop.AOPDH_PCT_ID=B.PCT_ID 
						AND aop.AOPDH_Hospital_ID=B.HospitalId)
						AND CONVERT(INT,ISNULL(aop.AOPDH_Month,'0'))>= @BeginMonth)
					OR(aop.AOPDH_Year IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@YEARSTRING,','))))
				
				INSERT INTO AOPDealerHospital(AOPDH_PCT_ID,AOPDH_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Hospital_ID,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date)
				SELECT AOPDH_PCT_ID,AOPDH_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Hospital_ID,AOPDH_Month,'0',AOPDH_Update_User_ID,AOPDH_Update_Date 
				FROM AOPDealerHospitalTemp aop 
				WHERE aop.AOPDH_Contract_ID=@Contract_ID 
				AND aop.AOPDH_Year=CONVERT(NVARCHAR(10),@BeginYear) 
						AND NOT EXISTS (SELECT 1 FROM #Temp B WHERE aop.AOPDH_PCT_ID=B.PCT_ID 
						AND aop.AOPDH_Hospital_ID=B.HospitalId)
						AND CONVERT(INT,ISNULL(aop.AOPDH_Month,'0'))< @BeginMonth
					
				
			END
			IF EXISTS(SELECT 1 FROM AOPICDealerHospitalTemp WHERE AOPICH_Contract_ID=@Contract_ID)
			BEGIN
			/*4. 医院数量指标*/
				INSERT INTO #Temp(HospitalId,PCT_ID)
				SELECT DISTINCT A.AOPICH_Hospital_ID,A.AOPICH_PCT_ID FROM AOPICDealerHospital A 
				INNER JOIN V_AllHospitalMarketProperty B  ON A.AOPICH_Hospital_ID=B.Hos_Id 
					AND CONVERT(NVARCHAR(10),B.MarketProperty)=@MarktType 
					AND B.ProductLineID=A.AOPICH_Hospital_ID
				WHERE A.AOPICH_DMA_ID=@DMA_ID AND A.AOPICH_ProductLine_ID=@ProductLineId AND A.AOPICH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure WHERE CC_ID=@CC_ID AND (@BeginDate BETWEEN StartDate and EndDate ))
				AND A.AOPICH_Year=CONVERT(NVARCHAR(10),@BeginYear)
				
				--新合同本年度不包含的医院指标分类组合之后月份设置为0
				UPDATE A  SET A.AOPICH_Unit=0
				FROM AOPICDealerHospital A  ,V_AllHospitalMarketProperty B
				WHERE A.AOPICH_Year=CONVERT(NVARCHAR(10),@BeginYear) AND  CONVERT(INT,ISNULL(A.AOPICH_Month,'0'))>= @BeginMonth
				AND A.AOPICH_ProductLine_ID=@ProductLineId
				AND A.AOPICH_DMA_ID=@DMA_ID
				AND A.AOPICH_PCT_ID IN (SELECT PCT_ID FROM #Temp)
				AND NOT EXISTS (SELECT 1 FROM AOPICDealerHospitalTemp B  WHERE B.AOPICH_Hospital_ID=A.AOPICH_Hospital_ID AND B.AOPICH_PCT_ID=A.AOPICH_PCT_ID AND B.AOPICH_Contract_ID=@Contract_ID)
				AND A.AOPICH_Hospital_ID=B.Hos_Id AND A.AOPICH_ProductLine_ID=B.ProductLineID AND CONVERT(NVARCHAR(10),B.MarketProperty)=@MarktType 
				
				--以后年份指标删除
				DELETE A FROM AOPICDealerHospital A,V_AllHospitalMarketProperty B
				WHERE A.AOPICH_DMA_ID=@DMA_ID
				AND A.AOPICH_ProductLine_ID=@ProductLineId
				AND A.AOPICH_PCT_ID IN (SELECT PCT_ID FROM #Temp)
				AND A.AOPICH_Year IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@YEARSTRING,','))
				AND A.AOPICH_Hospital_ID=B.Hos_Id AND A.AOPICH_ProductLine_ID=B.ProductLineID AND CONVERT(NVARCHAR(10),B.MarketProperty)=@MarktType
				
				--新合同包含的医院产品分类组合,本年度指标,根据开始时间更新指标
				UPDATE A SET AOPICH_Unit=B.AOPICH_Unit
				FROM AOPICDealerHospital A,AOPICDealerHospitalTemp B  
				WHERE A.AOPICH_DMA_ID=B.AOPICH_DMA_ID_Actual 
				AND A.AOPICH_Hospital_ID=B.AOPICH_Hospital_ID 
				AND A.AOPICH_Year=B.AOPICH_Year
				AND A.AOPICH_ProductLine_ID=B.AOPICH_ProductLine_ID
				AND A.AOPICH_PCT_ID=B.AOPICH_PCT_ID
				AND A.AOPICH_Year=CONVERT(NVARCHAR(10),@BeginYear)
				AND A.AOPICH_Month=B.AOPICH_Month
				AND B.AOPICH_Contract_ID=@Contract_ID
				AND CONVERT(INT,ISNULL(A.AOPICH_Month,'0'))>= @BeginMonth
				
				
				--新合同中,本年度不包含医院指标分类组合 以及 以后年份指标,新增进入正式表
					
				INSERT INTO AOPICDealerHospital( AOPICH_ID , AOPICH_DMA_ID , AOPICH_ProductLine_ID, AOPICH_PCT_ID, AOPICH_Year , AOPICH_Hospital_ID , AOPICH_Month, AOPICH_Unit, AOPICH_Update_User_ID, AOPICH_Update_Date)
				SELECT AOPICH_ID, AOPICH_DMA_ID_Actual, AOPICH_ProductLine_ID, AOPICH_PCT_ID, AOPICH_Year, AOPICH_Hospital_ID, AOPICH_Month, AOPICH_Unit, AOPICH_Update_User_ID, AOPICH_Update_Date
				FROM AOPICDealerHospitalTemp aop  
				WHERE aop.AOPICH_Contract_ID=@Contract_ID 
				AND ((aop.AOPICH_Year=CONVERT(NVARCHAR(10),@BeginYear) 
						AND NOT EXISTS (SELECT * FROM #Temp B WHERE aop.AOPICH_PCT_ID=B.PCT_ID  AND aop.AOPICH_Hospital_ID=B.HospitalId)
						AND CONVERT(INT,ISNULL(aop.AOPICH_Month,'0'))>= @BeginMonth
						)
					OR(aop.AOPICH_Year IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@YEARSTRING,','))))
				
				INSERT INTO AOPICDealerHospital( AOPICH_ID , AOPICH_DMA_ID , AOPICH_ProductLine_ID, AOPICH_PCT_ID, AOPICH_Year , AOPICH_Hospital_ID , AOPICH_Month, AOPICH_Unit, AOPICH_Update_User_ID, AOPICH_Update_Date)
				SELECT AOPICH_ID, AOPICH_DMA_ID_Actual, AOPICH_ProductLine_ID, AOPICH_PCT_ID, AOPICH_Year, AOPICH_Hospital_ID, AOPICH_Month, '0', AOPICH_Update_User_ID, AOPICH_Update_Date
				FROM AOPICDealerHospitalTemp aop  
				WHERE aop.AOPICH_Contract_ID=@Contract_ID 
				AND aop.AOPICH_Year=CONVERT(NVARCHAR(10),@BeginYear) 
				AND NOT EXISTS (SELECT * FROM #Temp B WHERE aop.AOPICH_PCT_ID=B.PCT_ID  AND aop.AOPICH_Hospital_ID=B.HospitalId)
				AND CONVERT(INT,ISNULL(aop.AOPICH_Month,'0'))< @BeginMonth
						
					
			END
		END
		
		INSERT INTO #TempPrice( Id,Dma_id,Hos_Id,PCT_ID,PCP_ID)
		SELECT A.AOPHPM_Id,A.AOPHPM_Dma_id,A.AOPHPM_Hos_Id,A.AOPHPM_PCT_ID,A.AOPHPM_PCP_ID 
		FROM AOPHospitalProductMapping A 
		WHERE A.AOPHPM_ActiveFlag=1
		AND A.AOPHPM_Dma_id=@DMA_ID
		AND A.AOPHPM_PCT_ID IN (SELECT DISTINCT B.CQ_ID FROM V_ProductClassificationStructure B WHERE B.CC_ID=@CC_ID AND (@BeginDate BETWEEN StartDate and EndDate ))
		AND (@MarktType='2' OR 
			(@MarktType<>'2' 
				AND A.AOPHPM_Hos_Id IN (SELECT D.Hos_Id FROM V_AllHospitalMarketProperty D WHERE CONVERT(NVARCHAR(10),D.MarketProperty)=@MarktType AND D.ProductLineID=@ProductLineId ))
			) 
		
		--跟新HospitalProductMapping 状态
		UPDATE A  
		SET AOPHPM_ActiveFlag=0 
		FROM AOPHospitalProductMapping A
		WHERE A.AOPHPM_Dma_id=@DMA_ID
		AND A.AOPHPM_PCT_ID IN (SELECT DISTINCT B.CQ_ID FROM V_ProductClassificationStructure B WHERE B.CC_ID=@CC_ID AND (@BeginDate BETWEEN StartDate and EndDate ))
		AND (@MarktType='2' OR 
			(@MarktType<>'2' 
				AND A.AOPHPM_Hos_Id IN (SELECT D.Hos_Id FROM V_AllHospitalMarketProperty D WHERE CONVERT(NVARCHAR(10),D.MarketProperty)=@MarktType AND D.ProductLineID=@ProductLineId ))
			) 
		
		--设置当前合同为有效状态
		UPDATE AOPHospitalProductMapping SET  AOPHPM_ActiveFlag=1 WHERE AOPHPM_ContractId=@Contract_ID;
		
		--设置本次被删除的医院产品分类对应价格
		SELECT DISTINCT A.AOPHPM_PCP_ID,A.AOPHPM_PCT_ID INTO #newPrice FROM AOPHospitalProductMapping A WHERE A.AOPHPM_ContractId=@Contract_ID;
		UPDATE A SET PCP_ID=B.AOPHPM_PCP_ID FROM #TempPrice A,#newPrice B
		WHERE A.PCT_ID=B.AOPHPM_PCT_ID
		
		DELETE A FROM #TempPrice A WHERE EXISTS (SELECT 1 FROM AOPICDealerHospitalTemp B WHERE A.Hos_Id=B.AOPICH_Hospital_ID AND A.PCT_ID=B.AOPICH_PCT_ID)
		
		UPDATE A SET AOPHPM_ActiveFlag=1 ,AOPHPM_PCP_ID=B.PCP_ID
		FROM AOPHospitalProductMapping A
		INNER JOIN #TempPrice B ON A.AOPHPM_Id=B.Id ;
	END	


COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES(NEWID(),@Contract_ID,'00000000-0000-0000-0000-000000000000',GETDATE (),'Failure',@Contract_Type+' 合同 历史数据 同步失败:'+@vError)
	
    return -1
END CATCH	

GO


