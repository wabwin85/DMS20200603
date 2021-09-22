DROP PROCEDURE [dbo].[Pro_DCMS_DealerAOPMerge]
GO


/**********************************************
	功能：获取上个合同经销商指标数据
	作者：Huakaichun
	最后更新时间：	2016-06-14
	更新记录说明：
	1.创建 2016-06-14
**********************************************/
CREATE PROCEDURE [dbo].[Pro_DCMS_DealerAOPMerge]
	@ContractId NVARCHAR(36),
	@LastContractId NVARCHAR(36),
	@DealerId NVARCHAR(36),
	@ProductLineId NVARCHAR(36),
	@SubBU NVARCHAR(50),
	@MarketType NVARCHAR(10),
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@AOPType NVARCHAR(10),
	@SyType NVARCHAR(2),  --2，判断是否已经维护经销商指标，如果没有维护同步医院指标。 1，同步医院指标。 0，不同步
	@ContractType NVARCHAR(10),
	@IsValid NVARCHAR(MAX) OUTPUT
AS
BEGIN
CREATE TABLE #DealerAmountAOP
(
	ContractId uniqueidentifier,
	[Year] NVARCHAR(4),
	[Month] NVARCHAR(4),
	Amount Float
)
DECLARE @BeginMonth INT
IF @ContractType='Amendment' AND MONTH(GETDATE())>=MONTH(@BeginDate) AND YEAR(@BeginDate)=YEAR(GETDATE()) AND EXISTS (SELECT 1 FROM interface.ClassificationContract WHERE CC_Code=@SubBU AND ISNULL(CC_RV3,'')<>'1')
BEGIN
	SET @BeginMonth=MONTH(@BeginDate)+1;
END
ELSE
BEGIN
	SET @BeginMonth=MONTH(@BeginDate)
END
IF @SyType='2'
BEGIN
	IF EXISTS(SELECT 1 FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@ContractId)
	BEGIN
		SET @SyType=0;
	END
	ELSE
	BEGIN
		SET @SyType=1;
	END
END

IF @SyType=1
BEGIN
	--清除已维护数据
	DELETE A FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@ContractId;
	
	
	
	IF  ISNULL(@LastContractId,'')=''
	BEGIN

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

		INSERT INTO #ConTol (ContractId,DealerId,MarketType,BeginDate,EndDate,UpdateDate,SubBU,ContractType)
		SELECT a.CAP_ID,a.CAP_DMA_ID,a.CAP_MarketType,CAP_EffectiveDate,CAP_ExpirationDate,a.CAP_Update_Date,a.CAP_SubDepID ,'Appointment' from ContractAppointment a where a.CAP_Status='Completed' and a.CAP_DMA_ID=@DealerId and a.CAP_SubDepID=@SubBU
		UNION
		SELECT a.CAM_ID,a.CAM_DMA_ID,a.CAM_MarketType,CAM_Amendment_EffectiveDate,CAM_Agreement_ExpirationDate,a.CAM_Update_Date,a.CAM_SubDepID,'Amendment' from ContractAmendment a where a.CAM_Status='Completed' and  a.CAM_Quota_IsChange='1' and a.CAM_DMA_ID=@DealerId and a.CAM_SubDepID=@SubBU
		UNION
		SELECT  a.CRE_ID,a.CRE_DMA_ID,a.CRE_MarketType,CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Renewal,a.CRE_Update_Date,a.CRE_SubDepID,'Renewal'  from ContractRenewal a where a.CRE_Status='Completed' and a.CRE_DMA_ID=@DealerId and a.CRE_SubDepID=@SubBU
		
		SELECT TOP 1 @LastContractId=ContractId FROM #ConTol ORDER BY UpdateDate DESC
		
	END
	SET @IsValid=@LastContractId;

	IF ISNULL(@LastContractId,'')<>''
	BEGIN
		INSERT INTO  AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID)
		SELECT NEWID(),@ContractId,@DealerId,NULL,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID  FROM AOPDealerTemp A 
		WHERE A.AOPD_Contract_ID=@LastContractId AND CONVERT(int, A.AOPD_Year) =YEAR(@BeginDate);
	END 
	--汇总本次合同医院金额指标
	IF @AOPType='Unit'
	BEGIN
		INSERT INTO #DealerAmountAOP(ContractId,[Year],[Month],Amount)
		SELECT AOPDH_Contract_ID AS ContractId,AOPDH_Year AS [Year],AOPDH_Month AS [Month],SUM(AOPDH_Amount*DBO.GC_Fn_GetProductHospitalPrice(AOPDH_Hospital_ID,AOPDH_PCT_ID,AOPDH_Year,AOPDH_Month))  Amount
		FROM AOPDealerHospitalTemp  WHERE AOPDH_Contract_ID=@ContractId
		GROUP BY AOPDH_Contract_ID,AOPDH_Year,AOPDH_Month
	
	END	
	ELSE
	BEGIN
		INSERT INTO #DealerAmountAOP(ContractId,[Year],[Month],Amount)
		SELECT AOPDH_Contract_ID AS ContractId,AOPDH_Year AS [Year],AOPDH_Month AS [Month],SUM(AOPDH_Amount)  Amount
		FROM AOPDealerHospitalTemp  WHERE AOPDH_Contract_ID=@ContractId
		GROUP BY AOPDH_Contract_ID,AOPDH_Year,AOPDH_Month
	END

	IF EXISTS (SELECT 1 FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@ContractId)
	BEGIN
		
			UPDATE A SET A.AOPD_Amount=B.Amount
			FROM AOPDealerTemp A, 
			#DealerAmountAOP B 
			WHERE A.AOPD_Contract_ID=B.ContractId  AND A.AOPD_Year=B.[Year] AND A.AOPD_Month=B.[Month]  AND CONVERT(INT,A.AOPD_Year)=YEAR(@BeginDate) AND CONVERT(INT,A.AOPD_Month) >=@BeginMonth
			
			INSERT INTO  AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
			SELECT NEWID(),ContractId,@DealerId,@ProductLineId,@MarketType,A.[Year],A.[Month],A.Amount,GETDATE(),(SELECT TOP 1 CC_ID FROM INTERFACE.ClassificationContract WHERE CC_Code=@SubBU ) 
			FROM #DealerAmountAOP  A 
			WHERE ContractId=@ContractId and CONVERT(INT,a.Year) >YEAR(@BeginDate)

	END
	ELSE
	BEGIN
			INSERT INTO  AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID)
			SELECT NEWID(),ContractId,@DealerId,NULL,@ProductLineId,@MarketType,A.[Year],A.[Month],A.Amount,NULL,GETDATE(),(SELECT TOP 1 CC_ID FROM INTERFACE.ClassificationContract WHERE CC_Code=@SubBU) 
			FROM #DealerAmountAOP  A 
			WHERE ContractId=@ContractId and CONVERT(INT,a.Year) >=YEAR(@BeginDate)
			
	END


	IF ISNULL(@IsValid,'')='' 
		SET @IsValid='';
	END  
	
	
END

GO


