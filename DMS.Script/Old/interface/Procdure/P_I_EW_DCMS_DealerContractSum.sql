DROP Procedure [interface].[P_I_EW_DCMS_DealerContractSum]
GO


CREATE Procedure [interface].[P_I_EW_DCMS_DealerContractSum]
AS
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
		  MarketType int,
		 CCode nvarchar(1000)
	)

	
SET NOCOUNT ON
	BEGIN  
		TRUNCATE TABLE interface.T_I_EW_DealerContractReturn
		
		INSERT INTO #tbReturn(SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
		ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
		Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther,AreaString
		,MarketType,CCode)
		SELECT C.DMA_SAP_Code,DCM_DMA_ID,CONVERT(INT, B.DivisionCode),B.DivisionName ,DCM_EffectiveDate,
		--DCM_ExpirationDate,
		case when DCM_TerminationDate is not null and DCM_TerminationDate< DCM_ExpirationDate then DCM_TerminationDate else DCM_ExpirationDate end,
		DCM_DealerType,
		DCM_ContractType,DCM_BSCEntity,DCM_Exclusiveness,DCM_ProductLine,DCM_ProductLineRemark,DCM_Pricing_Discount,DCM_Pricing_Discount_Remark,
		DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,DCM_Payment_Term,DCM_Credit_Limit,DCM_Credit_Term,DCM_Security_Deposit,DCM_Attachment,
		[dbo].[GC_Fn_ContractSum](A.DCM_DMA_ID,B.ProductLineID,A.DCM_CC_ID,A.DCM_MarketType,DCM_EffectiveDate,DCM_ExpirationDate,2) AS AOPString,
		--NULL,
		CONVERT(float, ISNULL([dbo].[GC_Fn_ContractSum](A.DCM_DMA_ID,B.ProductLineID,A.DCM_CC_ID,A.DCM_MarketType,DCM_EffectiveDate,DCM_ExpirationDate,1),'0')) AS AOPSum ,
		--NULL,
		[dbo].[GC_Fn_ContractSum](A.DCM_DMA_ID,B.ProductLineID,A.DCM_CC_ID,A.DCM_MarketType,DCM_EffectiveDate,DCM_ExpirationDate,3) AS HospitalSting,
		--NULL,
		DCM_Guarantee,DCM_GuaranteeRemark,
		[dbo].[GC_Fn_ContractSum](A.DCM_DMA_ID,B.ProductLineID,A.DCM_CC_ID,A.DCM_MarketType,DCM_EffectiveDate,DCM_ExpirationDate,4) AS AreHospitalSting
		,isnull(a.DCM_MarketType,0)
		,d.CC_Code
		FROM DealerContractMaster(nolock) A
		inner join V_DivisionProductLineRelation b on CONVERT(NVARCHAR(10),a.DCM_Division)=b.DivisionCode AND B.IsEmerging='0'
		INNER JOIN DealerMaster C ON C.DMA_ID=A.DCM_DMA_ID
		INNER JOIN interface.ClassificationContract d ON D.CC_ID=A.DCM_CC_ID
		
		insert into interface.T_I_EW_DealerContractReturn (InstanceID,SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
		ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
		Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther,AreaString,MarketType, CCode )
		select NEWID(),SAP_Code,DMA_ID,Division,DivisionName,EffectiveDate,ExpirationDate,DealerType,
		ContractType,BSCEntity,Exclusiveness,ProductLine,ProductLineRemark,Pricing_Discount,Pricing_Discount_Remark,
		Pricing_Rebate,Pricing_Rebate_Remark,PaymentTerm,CreditLimit,CreditTerm,SecurityDeposit,Attachment,AOPDealerQuarter,AOPDealerSum,HoapitalString,Inform,InformOther ,AreaString,MarketType, CCode 
		from #tbReturn; 
    END 
	
	
	 




GO


