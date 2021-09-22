DROP PROCEDURE [Workflow].[Proc_Contract_AmendmentLp_GetHtmlData]
GO


CREATE PROCEDURE [Workflow].[Proc_Contract_AmendmentLp_GetHtmlData]
	@InstanceId UNIQUEIDENTIFIER
AS
BEGIN
	--Template & Tables
	SELECT 'Contract_AmendmentLp' AS TemplateName,
	       'Main,Current,Proposals,Ncm,Justification,PreContract,Quota,Service,Kpi,Cfda,Qualification,Display' AS 
	       TableNames
	
	--DECLARE Start
	
	DECLARE @Hide NVARCHAR(100) = 'display: none; ';
	DECLARE @Show NVARCHAR(100) = ' ';
	
	DECLARE @IsDrm BIT;
	
	--Display
	DECLARE @Display_ReagionRSM NVARCHAR(100) = @Hide;
	
	DECLARE @Display_ProductAmend NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentProduct NVARCHAR(100) = @Hide;
	DECLARE @Display_PriceAmend NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentPrice NVARCHAR(100) = @Hide;
	DECLARE @Display_SalesAmend NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentSpecialSales NVARCHAR(100) = @Hide;
	DECLARE @Display_HospitalAmend NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentHospital NVARCHAR(100) = @Hide;
	DECLARE @Display_QuotaAmend NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentQuota NVARCHAR(100) = @Hide;
	DECLARE @Display_PaymentAmend NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentPayment NVARCHAR(100) = @Hide;
	
	DECLARE @Display_Product NVARCHAR(100) = @Hide;
	DECLARE @Display_ProductRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_Price NVARCHAR(100) = @Hide;
	DECLARE @Display_PriceRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_SpecialSales NVARCHAR(100) = @Hide;
	DECLARE @Display_SpecialSalesRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_Hospital NVARCHAR(100) = @Hide;
	DECLARE @Display_Quota NVARCHAR(100) = @Hide;
	DECLARE @Display_QuotaTotal NVARCHAR(100) = @Hide;
	DECLARE @Display_QUOTAUSD NVARCHAR(100) = @Hide;
	DECLARE @Display_Payment NVARCHAR(100) = @Hide;
	DECLARE @Display_PayTerm NVARCHAR(100) = @Hide;
	DECLARE @Display_CreditTerm NVARCHAR(100) = @Hide;
	DECLARE @Display_CreditLimit NVARCHAR(100) = @Hide;
	DECLARE @Display_IsDeposit NVARCHAR(100) = @Hide;
	DECLARE @Display_Deposit NVARCHAR(100) = @Hide;
	DECLARE @Display_Inform NVARCHAR(100) = @Hide;
	DECLARE @Display_InformOther NVARCHAR(100) = @Hide;
	DECLARE @Display_Comment NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosReason NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosQRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosReasonQ NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardReason NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardQRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardReasonQ NVARCHAR(100) = @Hide;
	DECLARE @Display_ProductGroupRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_ChangeQuarter NVARCHAR(100) = @Hide;
	DECLARE @Display_ChangeReason NVARCHAR(100) = @Hide;
	DECLARE @Display_ProductGroupMemo NVARCHAR(100) = @Hide;
	
	DECLARE @Display_ConflictRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_HandoverRemark NVARCHAR(100) = @Hide;
	
	DECLARE @Display_Jus1_QDJL NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus4_EWFWFW NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus4_YWFW NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus6_TJR NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus6_QTFS NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus6_QTXX NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus5_SFCD NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus5_YYSM NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus5_JTMS NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus4_SQFW NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus8_YWZB NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus8_SFFGD NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus8_FGDFS NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus7_ZZBJ NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus7_SX NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus7_SYLW NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus7_HDMS NVARCHAR(100) = @Hide;
	
	DECLARE @Display_Pre4_ZDLY NVARCHAR(100) = @Hide;
	
	DECLARE @Display_ContractQuota NVARCHAR(100) = @Hide;
	DECLARE @Display_ContractBasic NVARCHAR(100) = @Hide;
	DECLARE @Display_ContractCompetitiveness NVARCHAR(100) = @Hide;
	
	--Main
	DECLARE @IsFirstContract NVARCHAR(200) ;
	DECLARE @DealerType NVARCHAR(200) ;
	DECLARE @DepId NVARCHAR(200) ;
	DECLARE @SUBDEPID NVARCHAR(200) ;
	DECLARE @CompanyID NVARCHAR(200) ;
	DECLARE @RequestDate NVARCHAR(200) ;
	DECLARE @DealerBeginDate NVARCHAR(200) ;
	DECLARE @AmendEffectiveDate NVARCHAR(200) ;
	DECLARE @DealerEndDate NVARCHAR(200) ;
	DECLARE @AOPTYPE NVARCHAR(200) ;
	DECLARE @IsLP NVARCHAR(200) ;
	DECLARE @MarketType NVARCHAR(200) ;
	DECLARE @HospitalType NVARCHAR(200) ;
	
	--Current
	DECLARE @ProductAmend NVARCHAR(200) ;
	DECLARE @PriceAmend NVARCHAR(200) ;
	DECLARE @SalesAmend NVARCHAR(200) ;
	DECLARE @HospitalAmend NVARCHAR(200) ;
	DECLARE @QuotaAmend NVARCHAR(200) ;
	DECLARE @PaymentAmend NVARCHAR(200) ;
	
	DECLARE @CurrentHospitalUrl NVARCHAR(1000) ;
	DECLARE @CurrentQuotaUrl NVARCHAR(1000) ;
	
	--NCM
	DECLARE @Conflict NVARCHAR(200) ;
	DECLARE @Handover NVARCHAR(200) ;
	
	--Proposals
	DECLARE @Payment NVARCHAR(200) ;
	DECLARE @IsDeposit NVARCHAR(200) ;
	DECLARE @Inform NVARCHAR(200) ;
	DECLARE @DealerLessHos NVARCHAR(200) ;
	DECLARE @DealerLessHosQ NVARCHAR(200) ;
	DECLARE @DealerLessHosQRemark NVARCHAR(200) ;
	DECLARE @HosLessStandard NVARCHAR(200) ;
	DECLARE @HosLessStandardQ NVARCHAR(200) ;
	DECLARE @HosLessStandardQRemark NVARCHAR(200) ;
	DECLARE @ProductGroupCheck NVARCHAR(200) ;
	
	DECLARE @HospitalUrl NVARCHAR(1000) ;
	DECLARE @QuotaUrl NVARCHAR(1000) ;
	
	--Justification
	DECLARE @Jus4_FWFW NVARCHAR(200) ;
	DECLARE @Jus4_EWFWFW NVARCHAR(200) ;
	DECLARE @Jus6_ZMFS NVARCHAR(200) ;
	DECLARE @Jus6_YY NVARCHAR(200) ;
	DECLARE @Jus5_SFCD NVARCHAR(200) ;
	DECLARE @Jus8_SFFGD NVARCHAR(200) ;
	DECLARE @Jus7_ZZBJ NVARCHAR(200) ;
	DECLARE @Jus7_SYLW NVARCHAR(200) ;
	
	--PreContract
	DECLARE @Pre4_FBZTK NVARCHAR(200) ;
	
	--DECLARE End
	
	--Condition Start
	
	SELECT @IsDrm = CASE 
	                     WHEN A.DepID = '5' THEN 1
	                     ELSE 0
	                END
	FROM   interface.MDM_EmployeeMaster A,
	       Lafite_IDENTITY B,
	       [Contract].AmendmentMain C
	WHERE  A.account = B.IDENTITY_CODE
	       AND B.Id = C.CreateUser
	       AND C.ContractId = @InstanceId
	
	--Main
	SELECT @IsFirstContract = ISNULL(A.IsFirstContract, ''),
	       @DealerType = ISNULL(A.DealerType, ''),
	       @DepId = A.DepId,
	       @SUBDEPID = ISNULL(A.SUBDEPID, ''),
	       @CompanyID = ISNULL(A.CompanyID, ''),
	       @RequestDate = ISNULL(CONVERT(NVARCHAR(10), A.RequestDate, 121), ''),
	       @DealerBeginDate = ISNULL(CONVERT(NVARCHAR(10), A.DealerBeginDate, 121),''),
	       @AmendEffectiveDate = ISNULL(CONVERT(NVARCHAR(10), A.AmendEffectiveDate, 121),''),
	       @DealerEndDate = ISNULL(CONVERT(NVARCHAR(10), A.DealerEndDate, 121),''),
	       @AOPTYPE = ISNULL(AOPTYPE, ''),
	       @IsLP = A.IsLP,
	       @MarketType = MarketType,
	       @HospitalType = A.HospitalType
	FROM   [Contract].AmendmentMain A
	WHERE  A.ContractId = @InstanceId;
	
	--Current
	SELECT @ProductAmend = ISNULL(A.ProductAmend, ''),
	       @PriceAmend = ISNULL(A.PriceAmend, ''),
	       @SalesAmend = ISNULL(A.SalesAmend, ''),
	       @HospitalAmend = ISNULL(A.HospitalAmend, ''),
	       @QuotaAmend = ISNULL(A.QuotaAmend, ''),
	       @PaymentAmend = ISNULL(A.PaymentAmend, '')
	FROM   [Contract].AmendmentCurrent A
	WHERE  A.ContractId = @InstanceId;
	
	SET @CurrentHospitalUrl = '';
	SET @CurrentHospitalUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl');
	SET @CurrentHospitalUrl += 'Contract/PagesEkp/Contract/DealerAopHistoryList.aspx';
	SET @CurrentHospitalUrl += '?ContractId=' + CONVERT(NVARCHAR(50), @InstanceId);
	SET @CurrentHospitalUrl += '&DealerId=' + CONVERT(NVARCHAR(50), @CompanyID);
	SET @CurrentHospitalUrl += '&SubBu=' + @SUBDEPID;
	SET @CurrentHospitalUrl += '&PropertyType=' + CASE WHEN @IsLP= '0' THEN '0'ELSE '2'END;
	SET @CurrentHospitalUrl += '&DepId=' + @DepId;
	SET @CurrentHospitalUrl += '&AopType=' + @AOPTYPE;
	SET @CurrentHospitalUrl += '&HospitalType=' + @HospitalType;
	       
	SET @CurrentQuotaUrl = '';
	SET @CurrentQuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl');
	SET @CurrentQuotaUrl += 'Contract/PagesEkp/Contract/DealerAopHistoryList.aspx';
	SET @CurrentQuotaUrl += '?ContractId=' + CONVERT(NVARCHAR(50), @InstanceId);
	SET @CurrentQuotaUrl += '&DealerId=' + CONVERT(NVARCHAR(50), @CompanyID);
	SET @CurrentQuotaUrl += '&SubBu=' + @SUBDEPID;
	SET @CurrentQuotaUrl += '&PropertyType=1';
	SET @CurrentQuotaUrl += '&DepId=' + @DepId;
	SET @CurrentQuotaUrl += '&AopType=' + @AOPTYPE;
	SET @CurrentQuotaUrl += '&HospitalType=' + @HospitalType;
	SET @CurrentQuotaUrl += '&DealerType=' + @DealerType;
	SET @CurrentQuotaUrl += '&EffectiveDate=' + @DealerBeginDate;
	SET @CurrentQuotaUrl += '&ExpirationDate=' + @DealerEndDate;
	SET @CurrentQuotaUrl += '&MarketType=' + @MarketType;
	
	--NCM
	SELECT @Conflict = ISNULL(A.Conflict, ''),
	       @Handover = ISNULL(A.Handover, '')
	FROM   [Contract].AmendmentNCM A
	WHERE  A.ContractId = @InstanceId;
	
	--Proposals
	SELECT @Payment = ISNULL(Payment, ''),
	       @Inform = ISNULL(Inform, ''),
	       @IsDeposit = IsDeposit,
	       @DealerLessHos = ISNULL(DealerLessHos, ''),
	       @DealerLessHosQ = ISNULL(DealerLessHosQ, ''),
	       @DealerLessHosQRemark = ISNULL(DealerLessHosQRemark, ''),
	       @HosLessStandard = ISNULL(HosLessStandard, ''),
	       @HosLessStandardQ = ISNULL(HosLessStandardQ, ''),
	       @HosLessStandardQRemark = ISNULL(HosLessStandardQRemark, ''),
	       @ProductGroupCheck = ISNULL(ProductGroupCheck, '')
	FROM   [Contract].AmendmentProposals A
	WHERE  A.ContractId = @InstanceId;
	
	SET @HospitalUrl = '';
	SET @HospitalUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl');
	SET @HospitalUrl += 'Contract/PagesEkp/Contract/DealerAuthorizationList.aspx';
	SET @HospitalUrl += '?ContractId=' + CONVERT(NVARCHAR(50), @InstanceId);
	SET @HospitalUrl += '&DealerId=' + CONVERT(NVARCHAR(50), @CompanyID);
	SET @HospitalUrl += '&ProductLine=' + @DepId;
	SET @HospitalUrl += '&SubBu=' + @SUBDEPID;
	SET @HospitalUrl += '&BeginDate=' + @AmendEffectiveDate;
	SET @HospitalUrl += '&EndDate=' + @DealerEndDate;
	SET @HospitalUrl += '&PropertyType=' + CONVERT(NVARCHAR(50), @IsLP);
	SET @HospitalUrl += '&DealerType=' + @DealerType;
	SET @HospitalUrl += '&MarketType=' + @MarketType;
	SET @HospitalUrl += '&ContractType=Amendment';
	
	SET @QuotaUrl = '';
	SET @QuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl');
	SET @QuotaUrl += 'Contract/PagesEkp/Contract/DealerAopList.aspx';
	SET @QuotaUrl += '?ContractId=' + CONVERT(NVARCHAR(50), @InstanceId);
	SET @QuotaUrl += '&DealerId=' + CONVERT(NVARCHAR(50), @CompanyID);
	SET @QuotaUrl += '&AopType=' + @AOPTYPE;
	SET @QuotaUrl += '&SubBu=' + @SUBDEPID;
	SET @QuotaUrl += '&ContractType=Amendment';
	SET @QuotaUrl += '&DepId=' + @DepId;
	SET @QuotaUrl += '&DealerType=' + @DealerType;
	SET @QuotaUrl += '&AgreementBegin=' + @AmendEffectiveDate;
	SET @QuotaUrl += '&AgreementEnd=' + @DealerEndDate;
	SET @QuotaUrl += '&MarketType=' + @MarketType;
	
	--Justification
	SELECT @Jus4_FWFW = ISNULL(Jus4_FWFW, ''),
	       @Jus4_EWFWFW = ISNULL(Jus4_EWFWFW, ''),
	       @Jus5_SFCD = ISNULL(Jus5_SFCD, ''),
	       @Jus6_ZMFS = ISNULL(Jus6_ZMFS, ''),
	       @Jus6_YY = ISNULL(Jus6_YY, ''),
	       @Jus7_ZZBJ = ISNULL(Jus7_ZZBJ, ''),
	       @Jus7_SYLW = ISNULL(Jus7_SYLW, ''),
	       @Jus8_SFFGD = ISNULL(Jus8_SFFGD, '')
	FROM   [Contract].AppointmentJustification A
	WHERE  A.ContractId = @InstanceId;
	
	--PreContract
	SELECT @Pre4_FBZTK = ISNULL(A.Pre4_FBZTK, '')
	FROM   [Contract].PreContractApproval A
	WHERE  A.ContractId = @InstanceId; 
	
	--Condition End
	
	--Data Start
	
	--Main	
	SELECT case when exists (select 1 from DealerAuthorizationTableTemp a where a.DAT_DCL_ID=@InstanceId and a.DAT_PMA_ID='61A77AEC-3800-4177-AA4B-64AA32FB9F47') then'该申请包含spyglass耗材产品授权，请在审批人中增加赵新平' else'' end as [Message],
	       ISNULL(ContractNo, '') ContractNo,
	       dbo.Func_GetCode('CONST_CONTRACT_DealerType', A.DealerType) DealerTypeShow,
	       ISNULL(B.DepFullName, '') DepIdShow,
	       ISNULL(C.CC_NameCN, '') SUBDEPIDShow,
	       ISNULL(EName, '') EName,
	       ISNULL(F.DepFullName, '') ApplicantDepShow,
	       ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), '') RequestDate,
	       ISNULL(E.DMA_ChineseName, '') Assessment,
	       ISNULL(CONVERT(NVARCHAR(7), AssessmentStart, 121), '') AssessmentStart,
	       ISNULL(D.DMA_SAP_Code + ' - ' + D.DMA_ChineseName, '') DealerNameShow,
	       dbo.Func_GetCode('CONST_CONTRACT_MarketType', A.MarketType) MarketTypeShow,
	       ISNULL(CONVERT(NVARCHAR(10), DealerBeginDate, 121), '') DealerBeginDate,
	       ISNULL(CONVERT(NVARCHAR(10), DealerEndDate, 121), '') DealerEndDate,
	       ISNULL(CONVERT(NVARCHAR(10), AmendEffectiveDate, 121), '') AmendEffectiveDate,
	       A.Purpose Purpose,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsEquipment) IsEquipmentShow,
	       (
	           SELECT TOP 1 T.ManagerName
	           FROM   MDM_Manager T
	           WHERE  A.ReagionRSM = T.EmpNo
	                  AND T.ManagerTitle = 'RSM'
	       ) ReagionRSMShow
	FROM   [Contract].AmendmentMain A
	       LEFT JOIN interface.mdm_department B
	            ON  CONVERT(NVARCHAR(10), A.DepId) = B.DepID
	       LEFT JOIN interface.ClassificationContract C
	            ON  A.SUBDEPID = C.CC_Code
	       LEFT JOIN DealerMaster D
	            ON  A.DealerName = D.DMA_SAP_Code
	       LEFT JOIN DealerMaster E
	            ON  A.Assessment = E.DMA_SAP_Code
	       LEFT JOIN interface.mdm_department F
	            ON  CONVERT(NVARCHAR(10), A.ApplicantDep) = F.DepID
	WHERE  A.ContractId = @InstanceId;
	
	--Current
	SELECT dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.ProductAmend) ProductAmendShow,
	       ISNULL(Product, '') CurrentProduct,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.PriceAmend) PriceAmendShow,
	       ISNULL(Price, '') CurrentPrice,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.SalesAmend) SalesAmendShow,
	       ISNULL(SpecialSales, '') CurrentSpecialSales,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.HospitalAmend) HospitalAmendShow,
	       SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)) CurrentHospital,
	       @CurrentHospitalUrl CurrentHospitalUrl,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.QuotaAmend) QuotaAmendShow,
	       SUBSTRING(Quota, 0, CHARINDEX('<', Quota)) CurrentQuota,
	       @CurrentQuotaUrl CurrentQuotaUrl,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.PaymentAmend) PaymentAmendShow,
	       ISNULL(Payment, '') CurrentPayment,
	       dbo.Func_GetAttachmentHtml(A.Attachment) CurrentAttachment
	FROM   [Contract].AmendmentCurrent A
	WHERE  A.ContractId = @InstanceId;
	
	--Proposals
	SELECT dbo.Func_GetCode('CONST_CONTRACT_ProposalsProduct', A.Product) Product,
	       ISNULL(ProductRemark, '') ProductRemark,
	       ISNULL(Price, '') Price,
	       ISNULL(PriceRemark, '') PriceRemark,
	       ISNULL(SpecialSales, '') SpecialSales,
	       ISNULL(SpecialSalesRemark, '') SpecialSalesRemark,
	       SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)) Hospital,
	       @HospitalUrl HospitalUrl,
	       SUBSTRING(Quota, 0, CHARINDEX('<', Quota)) Quota,
	       @QuotaUrl QuotaUrl,
	       ISNULL(CONVERT(NVARCHAR(20), QuotaTotal), '') QuotaTotal,
	       ISNULL(CONVERT(NVARCHAR(20), QUOTAUSD), '') QUOTAUSD,
	       dbo.Func_GetCode('CONST_CONTRACT_Payment', A.Payment) PaymentShow,
	       ISNULL(PayTerm, '') PayTerm,
	       dbo.Func_GetCode('CONST_CONTRACT_CreditTerm', A.CreditTerm) CreditTermShow,
	       ISNULL(CreditLimit, '') CreditLimit,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsDeposit) IsDepositShow,
	       ISNULL(Deposit, '') Deposit,
	       dbo.Func_GetCode2('CONST_CONTRACT_Inform', A.Inform) InformShow,
	       ISNULL(InformOther, '') InformOther,
	       ISNULL(Comment, '') Comment,
	       ISNULL(DealerLessHosReason, '') DealerLessHosReason,
	       ISNULL(DealerLessHosReasonQ, '') DealerLessHosReasonQ,
	       ISNULL(DealerLessHosQRemark, '') DealerLessHosQRemark,
	       ISNULL(HosLessStandardReason, '') HosLessStandardReason,
	       ISNULL(HosLessStandardReasonQ, '') HosLessStandardReasonQ,
	       ISNULL(HosLessStandardQRemark, '') HosLessStandardQRemark,
	       ISNULL(ProductGroupRemark, '') ProductGroupRemark,
	       dbo.Func_GetCode('CONST_CONTRACT_ChangeQuarter', A.ChangeQuarter) ChangeQuarterShow,
	       ISNULL(ChangeReason, '') ChangeReason,
	       ISNULL(ProductGroupMemo, '') ProductGroupMemo,
	       dbo.Func_GetAttachmentHtml(A.Attachment) Attachment
	FROM   [Contract].AmendmentProposals A
	WHERE  A.ContractId = @InstanceId;
	
	--NCM
	SELECT dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Conflict) ConflictShow,
	       ISNULL(A.ConflictRemark, '') ConflictRemark,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Handover) HandoverShow,
	       ISNULL(A.HandoverRemark, '') HandoverRemark
	FROM   [Contract].AmendmentNCM A
	WHERE  A.ContractId = @InstanceId;
	
	--Justification
	SELECT ISNULL(Jus1_QDJL, '') Jus1_QDJLShow,
	       dbo.Func_GetCode2('CONST_CONTRACT_Jus4_FWFW', A.Jus4_FWFW) Jus4_FWFWShow,
	       dbo.Func_GetCode2('CONST_CONTRACT_Jus4_EWFWFW', A.Jus4_EWFWFW) Jus4_EWFWFWShow,
	       ISNULL(Jus4_YWFW, '') Jus4_YWFW,
	       dbo.Func_GetCode2('CONST_CONTRACT_Jus6_ZMFS', A.Jus6_ZMFS) Jus6_ZMFSShow,
	       ISNULL(Jus6_TJR, '') Jus6_TJR,
	       ISNULL(Jus6_QTFS, '') Jus6_QTFS,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus6_JXSPG) Jus6_JXSPGShow,
	       dbo.Func_GetCode('CONST_CONTRACT_Jus6_YY', A.Jus6_YY) Jus6_YYShow,
	       ISNULL(Jus6_QTXX, '') Jus6_QTXX,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus6_XWYQ) Jus6_XWYQShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus5_SFCD) Jus5_SFCDShow,
	       ISNULL(Jus5_YYSM, '') Jus5_YYSM,
	       ISNULL(Jus5_JTMS, '') Jus5_JTMS,
	       ISNULL(Jus4_SQFW, '') Jus4_SQFW,
	       dbo.Func_GetCode('CONST_CONTRACT_Jus8_YWZB', A.Jus8_YWZB) Jus8_YWZBShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus8_SFFGD) Jus8_SFFGDShow,
	       ISNULL(Jus8_FGDFS, '') Jus8_FGDFS,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus7_ZZBJ) Jus7_ZZBJShow,
	       ISNULL(Jus7_SX, '') Jus7_SX,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus7_SYLW) Jus7_SYLWShow,
	       ISNULL(Jus7_HDMS, '') Jus7_HDMS
	FROM   [Contract].AppointmentJustification A
	WHERE  A.ContractId = @InstanceId;
	
	--PreContract
	SELECT dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre4_FBZTK) Pre4_FBZTKShow,
	       ISNULL(A.Pre4_ZDLY, '') Pre4_ZDLY,
	       dbo.Func_GetCode('CONST_CONTRACT_Pre7_SFTZ', A.Pre7_SFTZ) Pre7_SFTZShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre9_SHPZ) Pre9_SHPZShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre9_QYSQ) Pre9_QYSQShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre9_JKZS) Pre9_JKZSShow
	FROM   [Contract].PreContractApproval A
	WHERE  A.ContractId = @InstanceId; 
	
	--Quota
	SELECT Pre5_NF,
	       Pre5_Q1,
	       Pre5_Q2,
	       Pre5_Q3,
	       Pre5_Q4,
	       Pre5_HJ,
	       Pre5_DB
	FROM   [Contract].PreContractQuota
	WHERE  ContractId = @InstanceId
	ORDER BY
	       SortNo
	
	--Service
	SELECT Pre7_FWLX,
	       Pre7_LR,
	       Pre7_LRFW
	FROM   [Contract].PreContractService
	WHERE  ContractId = @InstanceId
	ORDER BY
	       SortNo
	
	--Kpi
	SELECT ISNULL(A.Column1, '') [Year],
	       ISNULL(A.Column2, '') [Quarter],
	       ISNULL(A.Column3, '') [Month],
	       ISNULL(A.Column5, '') Division,
	       ISNULL(A.Column7, '') SubBUName,
	       ISNULL(A.Column11, '') TotalScore
	FROM   DP.DealerMaster A
	WHERE  ModleID = '00000002-0002-0001-0000-000000000000'
	       AND DealerId = @CompanyID
	       AND (
	               (
	                   DATEPART(MONTH, CONVERT(DATETIME, @RequestDate, 121)) IN (1, 2, 3)
	                   AND Column1 = DATEPART(
	                           YEAR,
	                           DATEADD(YEAR, -1, CONVERT(DATETIME, @RequestDate, 121))
	                       )
	               )
	               OR (
	                      DATEPART(MONTH, CONVERT(DATETIME, @RequestDate, 121)) NOT IN (1, 2, 3)
	                      AND Column1 = DATEPART(YEAR, CONVERT(DATETIME, @RequestDate, 121))
	                  )
	           )
	ORDER BY
	       A.Column5,
	       A.Column7,
	       A.Column1,
	       A.Column2 
	
	--Cfda   
	SELECT DISTINCT A.GM_KIND GM_KIND,
	       A.GM_CATALOG GM_CATALOG,
	       A.CatagoryName CatagoryName
	FROM   V_SubBU_CFDACatalog A,
	       interface.ClassificationAuthorization B
	WHERE  A.CA_ID = B.CA_ID
	       AND B.CA_ParentCode = @SUBDEPID
	
	--Qualification
	SELECT TypeName FileType,
	       NAME [FileName],
	       dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'BscDp/Pages/Download.aspx?FileId=' + CONVERT(NVARCHAR(50), Id) 
	       + '&FileType=dcms' FileUrl
	FROM   (
	           SELECT AT_ID AS Id,
	                  AT_Name AS NAME,
	                  DIC.VALUE1 AS TypeName,
	                  CONVERT(NVARCHAR(10), AT_UploadDate, 120) AS UploadDate
	           FROM   dbo.Attachment a
	                  INNER JOIN dbo.Lafite_DICT DIC
	                       ON  DIC.DICT_KEY = a.AT_Type
	                  INNER JOIN (
	                           SELECT CAP_ID AS ContractID,
	                                  CAP_DMA_ID AS DMA_ID
	                           FROM   ContractAppointment 
	                           UNION                           
	                           SELECT CAM_ID,
	                                  CAM_DMA_ID
	                           FROM   ContractAmendment 
	                           UNION                           
	                           SELECT CRE_ID,
	                                  CRE_DMA_ID
	                           FROM   ContractRenewal 
	                           UNION                           
	                           SELECT CTE_ID,
	                                  CTE_DMA_ID
	                           FROM   ContractTermination
	                       ) comTb
	                       ON  comTb.ContractID = a.AT_Main_ID
	           WHERE  comTb.DMA_ID = @CompanyID
	                  AND DIC.DICT_KEY IN ('LP_Certificates', 'T1_Certificates')
	           UNION           
	           SELECT AT_ID AS Id,
	                  AT_Name AS NAME,
	                  DIC.VALUE1 AS TypeName,
	                  CONVERT(NVARCHAR(10), AT_UploadDate, 120) AS UploadDate
	           FROM   dbo.Attachment a
	                  INNER JOIN dbo.Lafite_DICT DIC
	                       ON  DIC.DICT_KEY = a.AT_Type
	                  INNER JOIN DealerMaster DM
	                       ON  DM.DMA_ID = A.AT_Main_ID
	           WHERE  DM.DMA_ID = @CompanyID
	                  AND AT_Name LIKE '%֤%'
	       )TB
	ORDER BY
	       UploadDate
	
	--Display	
	IF NOT (@DealerType = 'LP' AND @IsDrm = 1)
	   AND @DepId IN ('17', '19', '32', '35')
	BEGIN
	    SET @Display_ReagionRSM = @Show;
	END
	
	IF @ProductAmend = '1'
	BEGIN
	    SET @Display_ProductAmend = @Show;
	    SET @Display_CurrentProduct = @Show;
	    
	    SET @Display_Product = @Show;
	    SET @Display_ProductRemark = @Show;
	END
	
	IF @PriceAmend = '1'
	BEGIN
	    SET @Display_PriceAmend = @Show;
	    SET @Display_CurrentPrice = @Show;
	    
	    SET @Display_Price = @Show;
	    SET @Display_PriceRemark = @Show;
	END
	
	IF @SalesAmend = '1'
	BEGIN
	    SET @Display_SalesAmend = @Show;
	    SET @Display_CurrentSpecialSales = @Show;
	    
	    SET @Display_SpecialSales = @Show;
	    SET @Display_SpecialSalesRemark = @Show;
	END
	
	IF @HospitalAmend = '1'
	BEGIN
	    SET @Display_HospitalAmend = @Show;
	    SET @Display_CurrentHospital = @Show;
	    
	    SET @Display_Hospital = @Show;
	END
	
	IF @QuotaAmend = '1'
	BEGIN
	    SET @Display_QuotaAmend = @Show;
	    SET @Display_CurrentQuota = @Show;
	    
	    SET @Display_Quota = @Show;
	    SET @Display_QuotaTotal = @Show;
	    SET @Display_QUOTAUSD = @Show;
	    
	    IF @DealerLessHos = '0'
	    BEGIN
	        SET @Display_DealerLessHosReason = @Show;
	    END
	    
	    IF @DealerLessHosQRemark != ''
	    BEGIN
	        SET @Display_DealerLessHosQRemark = @Show;
	    END
	    
	    IF @DealerLessHosQ = '0'
	    BEGIN
	        SET @Display_DealerLessHosReasonQ = @Show;
	    END
	    
	    IF @HosLessStandard = '0'
	    BEGIN
	        SET @Display_HosLessStandardReason = @Show;
	    END
	    
	    IF @HosLessStandardQRemark != ''
	    BEGIN
	        SET @Display_HosLessStandardQRemark = @Show;
	    END
	    
	    IF @HosLessStandardQ = '0'
	    BEGIN
	        SET @Display_HosLessStandardReasonQ = @Show;
	    END
	    
	    IF @ProductGroupCheck = '0'
	    BEGIN
	        SET @Display_ProductGroupRemark = @Show;
	    END	
	    
	    SET @Display_ChangeQuarter = @Show;	
	    SET @Display_ChangeReason = @Show;	
	    SET @Display_ProductGroupMemo = @Show;	
	    
	    SET @Display_ContractQuota = @Show;
	END
	
	IF @PaymentAmend = '1'
	BEGIN
	    SET @Display_PaymentAmend = @Show;
	    SET @Display_CurrentPayment = @Show;
	    
	    SET @Display_Payment = @Show;
	    
	    IF @Payment = 'LC'
	    BEGIN
	        SET @Display_PayTerm = @Show;
	    END
	    
	    IF @Payment = 'Credit'
	    BEGIN
	        SET @Display_CreditTerm = @Show;
	        SET @Display_CreditLimit = @Show;
	    END
	    
	    SET @Display_IsDeposit = @Show;
	    
	    IF @IsDeposit = '1'
	    BEGIN
	        SET @Display_Deposit = @Show;
	        SET @Display_Inform = @Show;	    
	        
	        IF EXISTS (
	               SELECT 1
	               FROM   dbo.GC_Fn_SplitStringToTable(@Inform, ',') T
	               WHERE  T.VAL = 'Others'
	           )
	        BEGIN
	            SET @Display_InformOther = @Show;
	        END
	    END
	    
	    SET @Display_Comment = @Show;
	END
	
	IF @Conflict = '1'
	BEGIN
	    SET @Display_ConflictRemark = @Show;
	END	
	
	IF @Handover = '1'
	BEGIN
	    SET @Display_HandoverRemark = @Show;
	END	
	
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Display_Jus1_QDJL = @Show;
	    
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_FWFW, ',') T
	           WHERE  T.VAL = '70'
	       )
	    BEGIN
	        SET @Display_Jus4_EWFWFW = @Show;
	        
	        IF EXISTS (
	               SELECT 1
	               FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_EWFWFW, ',') T
	               WHERE  T.VAL = '60'
	           )
	        BEGIN
	            SET @Display_Jus4_YWFW = @Show;
	        END
	    END
	    
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_ZMFS, ',') T
	           WHERE  T.VAL = '70'
	       )
	    BEGIN
	        SET @Display_Jus6_TJR = @Show;
	    END
	    
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_ZMFS, ',') T
	           WHERE  T.VAL = '80'
	       )
	    BEGIN
	        SET @Display_Jus6_QTFS = @Show;
	    END
	    
	    IF EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_YY, ',') T
	           WHERE  T.VAL = '50'
	       )
	    BEGIN
	        SET @Display_Jus6_QTXX = @Show;
	    END
	    
	    SET @Display_Jus5_SFCD = @Show;
	    
	    IF @Jus5_SFCD = '1'
	    BEGIN
	        SET @Display_Jus5_YYSM = @Show;
	    END
	    
	    SET @Display_Jus5_JTMS = @Show;
	    SET @Display_Jus4_SQFW = @Show;
	    SET @Display_Jus8_YWZB = @Show;
	    SET @Display_Jus8_SFFGD = @Show;
	    
	    IF @Jus8_SFFGD = '1'
	    BEGIN
	        SET @Display_Jus8_FGDFS = @Show;
	    END
	    
	    SET @Display_Jus7_ZZBJ = @Show;
	    
	    IF @Jus7_ZZBJ = '1'
	    BEGIN
	        SET @Display_Jus7_SX = @Show;
	    END
	    
	    SET @Display_Jus7_SYLW = @Show;
	    
	    IF @Jus7_SYLW = '1'
	    BEGIN
	        SET @Display_Jus7_HDMS = @Show;
	    END
	END
	
	IF @Pre4_FBZTK = '1'
	BEGIN
	    SET @Display_Pre4_ZDLY = @Show;
	END
	
	IF @IsFirstContract = '1'
	BEGIN
	    SET @Display_ContractBasic = @Show;
	    SET @Display_ContractCompetitiveness = @Show;
	END
	
	SELECT @Display_ReagionRSM Display_ReagionRSM,
	       @Display_ProductAmend Display_ProductAmend,
	       @Display_CurrentProduct Display_CurrentProduct,
	       @Display_PriceAmend Display_PriceAmend,
	       @Display_CurrentPrice Display_CurrentPrice,
	       @Display_SalesAmend Display_SalesAmend,
	       @Display_CurrentSpecialSales Display_CurrentSpecialSales,
	       @Display_HospitalAmend Display_HospitalAmend,
	       @Display_CurrentHospital Display_CurrentHospital,
	       @Display_QuotaAmend Display_QuotaAmend,
	       @Display_CurrentQuota Display_CurrentQuota,
	       @Display_PaymentAmend Display_PaymentAmend,
	       @Display_CurrentPayment Display_CurrentPayment,
	       @Display_Product Display_Product,
	       @Display_ProductRemark Display_ProductRemark,
	       @Display_Price Display_Price,
	       @Display_PriceRemark Display_PriceRemark,
	       @Display_SpecialSales Display_SpecialSales,
	       @Display_SpecialSalesRemark Display_SpecialSalesRemark,
	       @Display_Hospital Display_Hospital,
	       @Display_Quota Display_Quota,
	       @Display_QuotaTotal Display_QuotaTotal,
	       @Display_QUOTAUSD Display_QUOTAUSD,
	       @Display_Payment Display_Payment,
	       @Display_PayTerm Display_PayTerm,
	       @Display_CreditTerm Display_CreditTerm,
	       @Display_CreditLimit Display_CreditLimit,
	       @Display_IsDeposit Display_IsDeposit,
	       @Display_Deposit Display_Deposit,
	       @Display_Inform Display_Inform,
	       @Display_InformOther Display_InformOther,
	       @Display_Comment Display_Comment,
	       @Display_DealerLessHosReason Display_DealerLessHosReason,
	       @Display_DealerLessHosQRemark Display_DealerLessHosQRemark,
	       @Display_DealerLessHosReasonQ Display_DealerLessHosReasonQ,
	       @Display_HosLessStandardReason Display_HosLessStandardReason,
	       @Display_HosLessStandardQRemark Display_HosLessStandardQRemark,
	       @Display_HosLessStandardReasonQ Display_HosLessStandardReasonQ,
	       @Display_ProductGroupRemark Display_ProductGroupRemark,
	       @Display_ChangeQuarter Display_ChangeQuarter,
	       @Display_ChangeReason Display_ChangeReason,
	       @Display_ProductGroupMemo Display_ProductGroupMemo,
	       @Display_ConflictRemark Display_ConflictRemark,
	       @Display_HandoverRemark Display_HandoverRemark,
	       @Display_Jus1_QDJL Display_Jus1_QDJL,
	       @Display_Jus4_EWFWFW Display_Jus4_EWFWFW,
	       @Display_Jus4_YWFW Display_Jus4_YWFW,
	       @Display_Jus6_TJR Display_Jus6_TJR,
	       @Display_Jus6_QTFS Display_Jus6_QTFS,
	       @Display_Jus6_QTXX Display_Jus6_QTXX,
	       @Display_Jus5_SFCD Display_Jus5_SFCD,
	       @Display_Jus5_YYSM Display_Jus5_YYSM,
	       @Display_Jus5_JTMS Display_Jus5_JTMS,
	       @Display_Jus4_SQFW Display_Jus4_SQFW,
	       @Display_Jus8_YWZB Display_Jus8_YWZB,
	       @Display_Jus8_SFFGD Display_Jus8_SFFGD,
	       @Display_Jus8_FGDFS Display_Jus8_FGDFS,
	       @Display_Jus7_ZZBJ Display_Jus7_ZZBJ,
	       @Display_Jus7_SX Display_Jus7_SX,
	       @Display_Jus7_SYLW Display_Jus7_SYLW,
	       @Display_Jus7_HDMS Display_Jus7_HDMS,
	       @Display_Pre4_ZDLY Display_Pre4_ZDLY,
	       @Display_ContractQuota Display_ContractQuota,
	       @Display_ContractBasic Display_ContractBasic,
	       @Display_ContractCompetitiveness Display_ContractCompetitiveness
	       
	       --Data End
END
GO


