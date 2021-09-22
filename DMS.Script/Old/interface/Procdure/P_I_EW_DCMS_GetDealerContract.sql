
DROP Procedure [interface].[P_I_EW_DCMS_GetDealerContract]
GO

CREATE Procedure [interface].[P_I_EW_DCMS_GetDealerContract]
	@DMA_SAP_Code NVARCHAR(50) ,   
	@Division Int, 
	@SubDepCode NVARCHAR(50),   
	@MarketType NVARCHAR(10)   
	 
AS
	DECLARE @DivisionName NVARCHAR(50)
	DECLARE @ContractID uniqueidentifier
	DECLARE @DMA_ID uniqueidentifier
	DECLARE @SubDepId uniqueidentifier

	DECLARE @ContractType NVARCHAR(50)
	DECLARE @AOPDealerSum NVARCHAR(500)
	DECLARE @HoapitalQty INT
	DECLARE @HoapitalString NVARCHAR(500)
	DECLARE @AreaString NVARCHAR(500)
	DECLARE @AreaQty INT
	
	DECLARE @AOPtotal float  ;
	DECLARE @RtnVal NVARCHAR(2000) ;
	DECLARE @Year NVARCHAR(20)  ;
	DECLARE @Q1 decimal(18,2)  ;
	DECLARE @Q2 decimal(18,2)   ;
	DECLARE @Q3 decimal(18,2)   ;
	DECLARE @Q4 decimal(18,2)   ;
	
	CREATE TABLE #tbReturn
	(
		 SAP_Code NVARCHAR(50),
		 DMA_ID uniqueidentifier,
		 Division Int,
		 DivisionName nvarchar(1000),
		 EffectiveDate datetime,
		 ExpirationDate datetime,
		 DealerType nvarchar(1000),
		 ContractType nvarchar(1000),
		 BSCEntity nvarchar(1000),
		 Exclusiveness nvarchar(1000),
		 ProductLine nvarchar(1000),
		 ProductLineRemark nvarchar(2000),
		 Pricing_Discount nvarchar(1000),
		 Pricing_Discount_Remark nvarchar(max),
		 Pricing_Rebate nvarchar(1000),
		 Pricing_Rebate_Remark nvarchar(max),
		 PaymentTerm nvarchar(1000),
		 CreditLimit nvarchar(1000),
		 CreditTerm nvarchar(500),
		 SecurityDeposit nvarchar(1000),
		 Attachment nvarchar(2000),
		 AOPDealerQuarter  nvarchar(2000),
		 AOPDealerSum float ,
		 HoapitalString nvarchar(2000),
		 Inform nvarchar(2000),
		 InformOther nvarchar(1000),
		 AreaString nvarchar(2000),
		 PayTerm nvarchar(50),
		 IsDeposit INT
	)

	
SET NOCOUNT ON
BEGIN  
	SET @RtnVal='';
	
	--获取SubBU
	SELECT @SubDepId=CC_ID FROM interface.ClassificationContract(nolock) where CC_Code=CONVERT(nvarchar(100), @SubDepCode)
	--获取BU
	SELECT @DivisionName=DivisionName FROM V_DivisionProductLineRelation WHERE  DivisionCode=CONVERT(NVARCHAR(10),@Division) and IsEmerging='0'
	--获取经销商		   
	SELECT @DMA_ID=DMA_ID FROM DealerMaster(nolock) WHERE DealerMaster.DMA_SAP_Code=@DMA_SAP_Code;
	
	--获取上个合同指标
		 
	CREATE TABLE #ConTol
	(
		ContractId uniqueidentifier,
		DealerId uniqueidentifier,
		SubBU NVARCHAR(50),
		MarketType INT,
		BeginDate DATETIME,
		EndDate DATETIME,
		ContractType NVARCHAR(50),
		UpdateDate DATETIME,
		Quota INT,--指标
		Auth INT--授权
	)
	DECLARE @LastAOPContractId uniqueidentifier;
	DECLARE @LastAuthContractId uniqueidentifier;
	
	--获取上个信息
	INSERT INTO #ConTol (ContractId,DealerId,MarketType,BeginDate,EndDate,SubBU,ContractType,UpdateDate,Quota,Auth)
	SELECT a.CAP_ID,a.CAP_DMA_ID,a.CAP_MarketType,CAP_EffectiveDate,CAP_ExpirationDate,a.CAP_SubDepID ,'Appointment',a.CAP_Update_Date,1,1 from ContractAppointment a where a.CAP_Status='Completed' and a.CAP_DMA_ID=@DMA_ID and a.CAP_SubDepID=@SubDepCode 
	UNION
	SELECT a.CAM_ID,a.CAM_DMA_ID,a.CAM_MarketType,CAM_Amendment_EffectiveDate,CAM_Agreement_ExpirationDate,a.CAM_SubDepID,'Amendment',a.CAM_Update_Date,CASE WHEN ISNULL(a.CAM_Quota_IsChange,0)=1 THEN 1 ELSE 0 END,CASE WHEN ISNULL(a.CAM_Territory_IsChange,0)=1 THEN 1 ELSE 0 END  from ContractAmendment a where a.CAM_Status='Completed' and a.CAM_DMA_ID=@DMA_ID and a.CAM_SubDepID=@SubDepCode 
	UNION
	SELECT  a.CRE_ID,a.CRE_DMA_ID,a.CRE_MarketType,CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Renewal,a.CRE_SubDepID,'Renewal',a.CRE_Update_Date,1,1  from ContractRenewal a where a.CRE_Status='Completed' and a.CRE_DMA_ID=@DMA_ID and a.CRE_SubDepID=@SubDepCode 
	
	--获取上个指标信息
	SELECT TOP 1 @LastAOPContractId=ContractId FROM #ConTol WHERE Quota=1  ORDER BY UpdateDate DESC
	IF @LastAOPContractId IS NOT NULL
	BEGIN
		DECLARE @PRODUCT_CUR cursor;
		SET @PRODUCT_CUR=cursor for 
			SELECT aopd.AOPD_Year AS Year,
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_1 + aopd.AOPD_Amount_2 + aopd.AOPD_Amount_3)),
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_4 + aopd.AOPD_Amount_5 + aopd.AOPD_Amount_6)),
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_7 + aopd.AOPD_Amount_8 + aopd.AOPD_Amount_9)),
					CONVERT(decimal(18,2),(aopd.AOPD_Amount_10 + aopd.AOPD_Amount_11 + aopd.AOPD_Amount_12))
			  FROM  V_AOPDealer_Temp aopd(nolock)
			WHERE  aopd.AOPD_Contract_ID=@LastAOPContractId
			OPEN @PRODUCT_CUR
			FETCH NEXT FROM @PRODUCT_CUR INTO @Year,@Q1,@Q2,@Q3,@Q4
			WHILE @@FETCH_STATUS = 0        
				BEGIN
				SET @RtnVal = @RtnVal +@Year +'  [Q1:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q1),0)+';  Q2:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q2),0)+';  Q3:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q3),0)++';  Q4:'+dbo.GetFormatString(CONVERT(NVARCHAR(100),@Q4),0)+'];   '
				FETCH NEXT FROM @PRODUCT_CUR INTO @Year,@Q1,@Q2,@Q3,@Q4
				END
			CLOSE @PRODUCT_CUR
			DEALLOCATE @PRODUCT_CUR ;
			
			SELECT @AOPtotal=SUM(AOPD_Amount_Y)	FROM  V_AOPDealer_Temp aopd(nolock) WHERE aopd.AOPD_Contract_ID=@LastAOPContractId;
			 
	END
	
	SELECT TOP 1 @LastAuthContractId=ContractId FROM #ConTol WHERE Auth=1  ORDER BY UpdateDate DESC
	
	--获取上个授权医院
	SET @HoapitalQty=0;
	IF @LastAuthContractId IS NOT NULL
	BEGIN
		SELECT @HoapitalQty=Count(*) FROM 
		(SELECT DISTINCT B.HOS_ID FROM DealerAuthorizationTableTemp A INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID WHERE a.DAT_DCL_ID=@LastAuthContractId) TAB
	END
	
	SET @HoapitalString  =(CONVERT(nvarchar(50),@HoapitalQty)+ ' Hospital(s)');
    
	--获取上个授权区域	
	SET @AreaQty=0;
	IF @LastAuthContractId IS NOT NULL
	BEGIN
		SELECT @AreaQty=Count(*) FROM 
		(SELECT DISTINCT B.TA_Area FROM DealerAuthorizationAreaTemp A INNER JOIN TerritoryArea B ON A.DA_ID=B.TA_DA_ID WHERE a.DA_DCL_ID=@LastAuthContractId) TAB
	END
	SET @AreaString=(CONVERT(nvarchar(50),@AreaQty)+ ' Territory(s)')
		
	
	INSERT INTO #tbReturn(SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
	ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
	Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther,AreaString,PayTerm,IsDeposit)
	SELECT @DMA_SAP_Code,DCM_DMA_ID,@Division,@DivisionName ,DCM_EffectiveDate,
	case when DCM_TerminationDate is not null and DCM_TerminationDate< DCM_ExpirationDate then DCM_TerminationDate else DCM_ExpirationDate end,
	DCM_DealerType,
	DCM_ContractType,DCM_BSCEntity,DCM_Exclusiveness,DCM_ProductLine,DCM_ProductLineRemark,DCM_Pricing_Discount,DCM_Pricing_Discount_Remark,
	DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,DCM_Payment_Term,DCM_Credit_Limit,DCM_Credit_Term,DCM_Security_Deposit,DCM_Attachment,@RtnVal,@AOPtotal,@HoapitalString,DCM_Guarantee,DCM_GuaranteeRemark,@AreaString,DCM_PayTerm,DCM_IsDeposit
	FROM DealerContractMaster(nolock)
	WHERE  DCM_DMA_ID  IN (SELECT DMA_ID FROM DealerMaster(nolock) WHERE DealerMaster.DMA_SAP_Code=@DMA_SAP_Code)
	AND CONVERT(NVARCHAR(10),DCM_Division)=Convert(NVARCHAR(10),@Division)
	AND CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))=@MarketType
	and DCM_CC_ID=@SubDepId
  
    
	IF EXISTS(SELECT 1 FROM #tbReturn)
	BEGIN
		select SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
		ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
		Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther ,AreaString,@MarketType as MarketType,@SubDepCode as CCode,PayTerm,IsDeposit
		,0 AS IsNewProduct
		from #tbReturn; 
	END
	ELSE
	BEGIN
		select @DMA_SAP_Code AS SAP_Code,@DMA_ID AS DMA_ID,NULL AS Division,NULL AS DivisionName,NULL AS EffectiveDate,(SELECT MAX(DCM_ExpirationDate) FROM DealerContractMaster WHERE DCM_DMA_ID =@DMA_ID) AS ExpirationDate,NULL AS DealerType,
		NULL AS ContractType,NULL AS BSCEntity,NULL AS Exclusiveness,NULL AS ProductLine,NULL AS ProductLineRemark,NULL AS Pricing_Discount,NULL AS Pricing_Discount_Remark,
		NULL AS Pricing_Rebate,NULL AS Pricing_Rebate_Remark,NULL AS PaymentTerm,NULL AS CreditLimit,NULL AS CreditTerm,NULL AS SecurityDeposit,NULL AS Attachment,NULL AS AOPDealerQuarter,
		NULL AS AOPDealerSum,NULL AS HoapitalString,NULL AS Inform,NULL AS InformOther ,NULL AS AreaString,@MarketType as MarketType,@SubDepCode as CCode,NULL AS PayTerm,NULL AS IsDeposit
		,CASE WHEN EXISTS(SELECT 1 FROM DealerContractMaster A WHERE A.DCM_Division=@Division AND A.DCM_DMA_ID=@DMA_ID) THEN 0 ELSE 1 END AS IsNewProduct;
		
	END
END
GO


