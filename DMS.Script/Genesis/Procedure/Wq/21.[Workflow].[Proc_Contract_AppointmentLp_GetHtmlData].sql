
/****** Object:  StoredProcedure [Workflow].[Proc_Contract_AppointmentLp_GetHtmlData]    Script Date: 2019/11/22 14:04:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [Workflow].[Proc_Contract_AppointmentLp_GetHtmlData]
	@InstanceId UNIQUEIDENTIFIER
AS
BEGIN
	--Template & Tables
	SELECT 'Contract_AppointmentLp' AS TemplateName,
	       'Main,Candidate,Documents,Competency,Proposals,Justification,PreContract,Quota,Service,CrossBu,SameDealer,FormerDealer,AssessmentDealer,Cfda,Display,DDReport' AS 
	       TableNames
	
	--DECLARE Start
	
	DECLARE @Hide NVARCHAR(100) = 'display: none; ';
	DECLARE @Show NVARCHAR(100) = ' ';
	
	DECLARE @IsDrm BIT;
	
	--Display
	DECLARE @Display_FORMERNAME NVARCHAR(100) = @Hide;
	DECLARE @Display_Assessment NVARCHAR(100) = @Hide;
	DECLARE @Display_AssessmentStart NVARCHAR(100) = @Hide;
	DECLARE @Display_ReagionRSM NVARCHAR(100) = @Hide;
	DECLARE @Display_TA NVARCHAR(100) = @Hide;
	DECLARE @Display_OA NVARCHAR(100) = @Hide;
	DECLARE @Display_PayTerm NVARCHAR(100) = @Hide;
	DECLARE @Display_CreditTerm NVARCHAR(100) = @Hide;
	DECLARE @Display_CreditLimit NVARCHAR(100) = @Hide;
	DECLARE @Display_Deposit NVARCHAR(100) = @Hide;
	DECLARE @Display_Inform NVARCHAR(100) = @Hide;
	DECLARE @Display_InformOther NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosReason NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosQRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosReasonQ NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardReason NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardQRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardReasonQ NVARCHAR(100) = @Hide;
	DECLARE @Display_ProductGroupRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_CorssBuMemo NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus4_EWFWFW NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus4_YWFW NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus6_TJR NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus6_QTFS NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus6_QTXX NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus5_YYSM NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus8_FGDFS NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus7_SX NVARCHAR(100) = @Hide;
	DECLARE @Display_Jus7_HDMS NVARCHAR(100) = @Hide;
	DECLARE @Display_Pre4_ZDLY NVARCHAR(100) = @Hide;
	DECLARE @Display_FormerDealer NVARCHAR(100) = @Hide;
	DECLARE @Display_AssessmentDealer NVARCHAR(100) = @Hide;
	
	--Main
	DECLARE @REASON NVARCHAR(200) ;
	DECLARE @DealerType NVARCHAR(200) ;
	DECLARE @DepId NVARCHAR(200) ;
	DECLARE @SUBDEPID NVARCHAR(200) ;
	DECLARE @FORMERNAME NVARCHAR(200) ;
	DECLARE @Assessment NVARCHAR(200) ;
	DECLARE @AOPTYPE NVARCHAR(200) ;
	DECLARE @IsLP NVARCHAR(200) ;
	DECLARE @MarketType NVARCHAR(200) ;
	
	--Candidate
	DECLARE @CompanyName NVARCHAR(200) ;
	DECLARE @CompanyID UNIQUEIDENTIFIER ;
	SET @CompanyID = NULL
	--Documents
	DECLARE @IsThreeLicense NVARCHAR(200) ;
	
	--Proposals
	DECLARE @AgreementBegin NVARCHAR(200) ;
	DECLARE @AgreementEnd NVARCHAR(200) ;
	DECLARE @Payment NVARCHAR(200) ;
	DECLARE @Inform NVARCHAR(200) ;
	DECLARE @IsDeposit NVARCHAR(200) ;
	DECLARE @DealerLessHos NVARCHAR(200) ;
	DECLARE @DealerLessHosQ NVARCHAR(200) ;
	DECLARE @DealerLessHosQRemark NVARCHAR(200) ;
	DECLARE @HosLessStandard NVARCHAR(200) ;
	DECLARE @HosLessStandardQ NVARCHAR(200) ;
	DECLARE @HosLessStandardQRemark NVARCHAR(200) ;
	DECLARE @ProductGroupCheck NVARCHAR(200) ;
	DECLARE @IsCorssBu NVARCHAR(200) ;
	
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
	       [Contract].AppointmentMain C
	WHERE  A.account = B.IDENTITY_CODE
	       AND B.Id = C.CreateUser
	       AND C.ContractId = @InstanceId
	
	--Main
	SELECT @REASON = A.REASON,
	       @DealerType = ISNULL(A.DealerType, ''),
	       @DepId = A.DepId,
	       @SUBDEPID = A.SUBDEPID,
	       @FORMERNAME = ISNULL(FORMERNAME, ''),
	       @Assessment = ISNULL(Assessment, ''),
	       @AOPTYPE = ISNULL(AOPTYPE, ''),
	       @IsLP = A.IsLP,
	       @MarketType = MarketType
	FROM   [Contract].AppointmentMain A
	WHERE  A.ContractId = @InstanceId;
	
	--Candidate
	SELECT @CompanyName = ISNULL(CompanyName, ''),
	       @CompanyID = A.CompanyID
	FROM   [Contract].AppointmentCandidate A
	WHERE  A.ContractId = @InstanceId;
	
	--Documents
	SELECT @IsThreeLicense = IsThreeLicense
	FROM   [Contract].AppointmentDocuments A
	WHERE  A.ContractId = @InstanceId;
	
	--Proposals
	SELECT @AgreementBegin = CONVERT(NVARCHAR(10), A.AgreementBegin, 121),
	       @AgreementEnd = CONVERT(NVARCHAR(10), A.AgreementEnd, 121),
	       @Payment = ISNULL(Payment, ''),
	       @Inform = ISNULL(Inform, ''),
	       @IsDeposit = IsDeposit,
	       @DealerLessHos = ISNULL(DealerLessHos, ''),
	       @DealerLessHosQ = ISNULL(DealerLessHosQ, ''),
	       @DealerLessHosQRemark = ISNULL(DealerLessHosQRemark, ''),
	       @HosLessStandard = ISNULL(HosLessStandard, ''),
	       @HosLessStandardQ = ISNULL(HosLessStandardQ, ''),
	       @HosLessStandardQRemark = ISNULL(HosLessStandardQRemark, ''),
	       @ProductGroupCheck = ISNULL(ProductGroupCheck, ''),
	       @IsCorssBu = ISNULL(IsCorssBu, '')
	FROM   [Contract].AppointmentProposals A
	WHERE  A.ContractId = @InstanceId;
	
	SET @HospitalUrl = '';
	SET @HospitalUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl');
	SET @HospitalUrl += 'Contract/PagesEkp/Contract/DealerAuthorizationList.aspx';
	SET @HospitalUrl += '?ContractId=' + CONVERT(NVARCHAR(50), @InstanceId);
	SET @HospitalUrl += '&DealerId=' + CONVERT(NVARCHAR(50), @CompanyID);
	SET @HospitalUrl += '&ProductLine=' + @DepId;
	SET @HospitalUrl += '&SubBu=' + @SUBDEPID;
	SET @HospitalUrl += '&BeginDate=' + @AgreementBegin;
	SET @HospitalUrl += '&EndDate=' + @AgreementEnd;
	SET @HospitalUrl += '&PropertyType=' + CASE @DealerType WHEN 'LP' THEN '1' ELSE '0' END;
	SET @HospitalUrl += '&DealerType=' + @DealerType;
	SET @HospitalUrl += '&MarketType=' + @MarketType;
	SET @HospitalUrl += '&ContractType=Appointment';
	
	SET @QuotaUrl = '';
	SET @QuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl');
	SET @QuotaUrl += 'Contract/PagesEkp/Contract/DealerAopList.aspx';
	SET @QuotaUrl += '?ContractId=' + CONVERT(NVARCHAR(50), @InstanceId);
	SET @QuotaUrl += '&DealerId=' + CONVERT(NVARCHAR(50), @CompanyID);
	SET @QuotaUrl += '&AopType=' + @AOPTYPE;
	SET @QuotaUrl += '&SubBu=' + @SUBDEPID;
	SET @QuotaUrl += '&ContractType=Appointment';
	SET @QuotaUrl += '&DepId=' + @DepId;
	SET @QuotaUrl += '&DealerType=' + @DealerType;
	SET @QuotaUrl += '&AgreementBegin=' + @AgreementBegin;
	SET @QuotaUrl += '&AgreementEnd=' + @AgreementEnd;
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
	       ISNULL(EId, '') EId,
	       ISNULL(EName, '') EName,
	       ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), '') RequestDate,
	       dbo.Func_GetCode('CONST_CONTRACT_Reason', A.REASON) REASONShow,
	       ISNULL(D.DMA_ChineseName, '') FORMERNAMEShow,
	       ISNULL(E.DMA_ChineseName, '') AssessmentShow,
	       ISNULL(CONVERT(NVARCHAR(7), AssessmentStart, 121), '') AssessmentStart,
	       ISNULL(F.DepFullName, '') ApplicantDepShow,
	       dbo.Func_GetCode('CONST_CONTRACT_MarketType', A.MarketType) MarketTypeShow,
	       (
	           SELECT TOP 1 T.ManagerName
	           FROM   MDM_Manager T
	           WHERE  A.ReagionRSM = T.EmpNo
	                  AND T.ManagerTitle = 'RSM'
	       ) AS ReagionRSMShow,
	       dbo.Func_GetAttachmentHtml(A.IAF) IAF
	FROM   [Contract].AppointmentMain A
	       LEFT JOIN interface.mdm_department B
	            ON  CONVERT(NVARCHAR(10), A.DepId) = B.DepID
	       LEFT JOIN interface.ClassificationContract C
	            ON  A.SUBDEPID = C.CC_Code
	       LEFT JOIN DealerMaster D
	            ON  A.FORMERNAME = D.DMA_SAP_Code
	       LEFT JOIN DealerMaster E
	            ON  A.Assessment = E.DMA_SAP_Code
	       LEFT JOIN interface.mdm_department F
	            ON  CONVERT(NVARCHAR(10), A.ApplicantDep) = F.DepID
	WHERE  A.ContractId = @InstanceId;
	
	--Candidate
	SELECT ISNULL(CompanyName, '') CompanyName,
	       ISNULL(CompanyEName, '') CompanyEName,
	       ISNULL(SAPCode, '') SAPCode,
	       ISNULL(Contact, '') Contact,
	       ISNULL(EMail, '') EMail,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsEquipment) IsEquipmentShow,
	       ISNULL(OfficeNumber, '') OfficeNumber,
	       ISNULL(Mobile, '') Mobile,
	       dbo.Func_GetCode('CONST_CONTRACT_DealerMark', A.DealerMark) DealerMarkShow,
	       ISNULL(OfficeAddress, '') OfficeAddress,
	       ISNULL(CompanyType, '') CompanyType,
	       ISNULL(CONVERT(NVARCHAR(10), EstablishedTime, 121), '') EstablishedTime,
	       ISNULL(Capital, '') Capital,
	       ISNULL(Website, '') Website,
	       ISNULL(BusinessContact, '') BusinessContact,
	       ISNULL(BusinessEMail, '') BusinessEMail,
	       ISNULL(BusinessMobile, '') BusinessMobile
	FROM   [Contract].AppointmentCandidate A
	WHERE  A.ContractId = @InstanceId;
	
	--Documents
	SELECT dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsThreeLicense) IsThreeLicenseShow,
	       dbo.Func_GetAttachmentHtml(BA) BA,
	       dbo.Func_GetAttachmentHtml(MA) MA,
		   dbo.Func_GetAttachmentHtml(Bak) Bak,
	       dbo.Func_GetAttachmentHtml(TA) TA,
	       dbo.Func_GetAttachmentHtml(OA) OA
	FROM   [Contract].AppointmentDocuments A
	WHERE  A.ContractId = @InstanceId;
	
	--Competency
	SELECT dbo.Func_GetCode('CONST_CONTRACT_Competency', A.Healthcare) HealthcareShow,
	       dbo.Func_GetCode('CONST_CONTRACT_Competency', A.Inter) InterShow,
	       dbo.Func_GetCode('CONST_CONTRACT_Competency', A.KOL) KOLShow,
	       ISNULL(MNC, '') MNC,
	       ISNULL(Justification, '') Justification
	FROM   [Contract].AppointmentCompetency A
	WHERE  A.ContractId = @InstanceId;
	
	--Proposals
	SELECT ISNULL(ContractType, '') ContractType,
	       ISNULL(BSC, '') BSC,
	       ISNULL(Exclusiveness, '') Exclusiveness,
	       ISNULL(CONVERT(NVARCHAR(10), AgreementBegin, 121), '') AgreementBegin,
	       ISNULL(CONVERT(NVARCHAR(10), AgreementEnd, 121), '') AgreementEnd,
	       dbo.Func_GetCode('CONST_CONTRACT_ProposalsProduct', A.Product) ProductShow,
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
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsDeposit) IsDepositShow,
	       dbo.Func_GetCode('CONST_CONTRACT_CreditTerm', A.CreditTerm) CreditTerm,
	       ISNULL(CreditLimit, '') CreditLimit,
	       ISNULL(Deposit, '') Deposit,
	       dbo.Func_GetCode2('CONST_CONTRACT_Inform', A.Inform) InformShow,
	       ISNULL(InformOther, '') InformOther,
	       ISNULL(Comment, '') Comment,
	       ISNULL(DealerLessHosReason, '') DealerLessHosReason,
	       ISNULL(DealerLessHosQRemark, '') DealerLessHosQRemark,
	       ISNULL(DealerLessHosReasonQ, '') DealerLessHosReasonQ,
	       ISNULL(HosLessStandardReason, '') HosLessStandardReason,
	       ISNULL(HosLessStandardQRemark, '') HosLessStandardQRemark,
	       ISNULL(HosLessStandardReasonQ, '') HosLessStandardReasonQ,
	       ISNULL(ProductGroupRemark, '') ProductGroupRemark,
	       ISNULL(ProductGroupMemo, '') ProductGroupMemo,
	       ISNULL(CorssBuMemo, '') CorssBuMemo,
	       dbo.Func_GetAttachmentHtml(A.Attachment) Attachment
	FROM   [Contract].AppointmentProposals A
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
	
	--CrossBu
	SELECT DISTINCT ISNULL(E.HOS_Key_Account, '') HospitalCode,
	       ISNULL(E.HOS_HospitalName, '') HospitalName,
	       ISNULL(F.DMA_SAP_Code, '') DealerCode,
	       ISNULL(F.DMA_ChineseName, '') DealerName,
	       ISNULL(G.CC_DivisionName, '') BUName,
	       ISNULL(G.CC_NameCN, '') SubBUName,
	       ISNULL(
	           (
	               SELECT T.Column11
	               FROM   DP.DealerMaster T
	               WHERE  T.ID = (
	                          SELECT TOP 1 TT.ID
	                          FROM   DP.DealerMaster TT
	                          WHERE  TT.ModleID = '00000002-0002-0001-0000-000000000000'
	                                 AND TT.Column8 COLLATE Chinese_PRC_CI_AS = F.DMA_SAP_Code COLLATE Chinese_PRC_CI_AS
	                                 AND TT.Column6 COLLATE Chinese_PRC_CI_AS = G.CC_Code COLLATE Chinese_PRC_CI_AS
	                          ORDER BY
	                                 TT.Column1 DESC,
	                                 TT.Column2 DESC
	                      )
	           ),
	           ''
	       ) KpiScore
	FROM   DealerAuthorizationTable c
	       INNER JOIN HospitalList d
	            ON  c.DAT_ID = d.HLA_DAT_ID
	       INNER JOIN Hospital E
	            ON  E.HOS_ID = D.HLA_HOS_ID
	       INNER JOIN DealerMaster F
	            ON  F.DMA_ID = C.DAT_DMA_ID
	       INNER JOIN (
	                SELECT DISTINCT CC_ID,
	                       CC_Code,
	                       CC_NameCN,
	                       CC_Division,
	                       CC_DivisionName,
	                       CC_ProductLineID,
	                       CC_ProductLineName,
	                       CA_ID,
	                       CA_Code
	                FROM   V_ProductClassificationStructure
	            ) G
	            ON  G.CC_ProductLineID = C.DAT_ProductLine_BUM_ID
	            AND G.CA_ID = C.DAT_PMA_ID
	       INNER JOIN CONTRACT.CrossBuMapping H
	            ON  H.CorssSubDepId = G.CC_Code
	WHERE  CONVERT(NVARCHAR(10), GETDATE(), 120) >= CONVERT(NVARCHAR(10), c.DAT_StartDate, 120)
	       AND CONVERT(NVARCHAR(10), GETDATE(), 120) <= CONVERT(NVARCHAR(10), DAT_EndDate, 120)
	       AND DAT_Type = 'Normal'
	       AND EXISTS(
	               SELECT 1
	               FROM   DealerAuthorizationTableTemp A
	                      INNER JOIN ContractTerritory B
	                           ON  A.DAT_ID = B.Contract_ID
	                      INNER JOIN (
	                               SELECT DISTINCT CC_ID,
	                                      CC_Code,
	                                      CC_NameCN,
	                                      CC_Division,
	                                      CC_DivisionName,
	                                      CC_ProductLineID,
	                                      CC_ProductLineName,
	                                      CA_ID,
	                                      CA_Code
	                               FROM   V_ProductClassificationStructure
	                           ) M
	                           ON  M.CC_ProductLineID = A.DAT_ProductLine_BUM_ID
	                           AND M.CA_ID = A.DAT_PMA_ID
	               WHERE  A.DAT_DCL_ID = @InstanceId
	                      AND D.HLA_HOS_ID = B.HOS_ID
	                      AND M.CC_Code = H.SubDepId
	           )
	ORDER BY
	       ISNULL(E.HOS_Key_Account, ''),
	       ISNULL(F.DMA_SAP_Code, '')
	
	--SameDealer
	SELECT DISTINCT A.DMA_SAP_Code + ' - ' + A.DMA_ChineseName SameDealerName,
	       dbo.Func_GetCode('CONST_CONTRACT_MarketType', B.MarketType) SameMarketType,
	       D.DepFullName SameProductLine,
	       C.DMA_SAP_Code + ' - ' + C.DMA_ChineseName SameLpName
	FROM   DealerMaster A
	       INNER JOIN V_DealerContractMaster B
	            ON  A.DMA_ID = B.DMA_ID
	       INNER JOIN DealerMaster C
	            ON  A.DMA_Parent_DMA_ID = C.DMA_ID
	       INNER JOIN interface.mdm_department D
	            ON  B.Division = D.DepID
	WHERE  A.DMA_ChineseName LIKE SUBSTRING(@CompanyName, 1, 8) + '%'
	
	--FormerDealer
	IF @REASON IN ('2', '3', '4')
	BEGIN
	    SELECT ISNULL(A.Column1, '') RelateReason,
	           ISNULL(A.Column2, '') RelateRefSAPID,
	           ISNULL(A.Column3, '') RelateRefDealerName
	    FROM   DP.DealerMaster A,
	           dbo.DealerMaster B
	    WHERE  A.DealerId = B.DMA_ID
	           AND A.ModleID = '00000001-0001-0007-0000-000000000000'
	           AND B.DMA_SAP_Code = @FORMERNAME
	END
	ELSE
	BEGIN
	    SELECT '' A
	    WHERE  1 = 2
	END
	
	--AssessmentDealer   
	IF @REASON IN ('3')
	BEGIN
	    SELECT ISNULL(A.Column1, '') AssessmentBiType,
	           ISNULL(A.Column2, '') AssessmentBiYear,
	           ISNULL(A.Column3, '') AssessmentBiQFrom,
	           ISNULL(A.Column4, '') AssessmentBiQTo,
	           ISNULL(A.Column5, '') AssessmentBiDivision,
	           ISNULL(A.Column6, '') AssessmentBiSubBu,
	           ISNULL(A.Column7, '') AssessmentBiCode,
	           ISNULL(A.Column8, '') AssessmentBiName,
	           ISNULL(A.Column9, '') AssessmentBiRemark,
	           ISNULL(A.Column10, '') AssessmentBiMarketType
	    FROM   DP.DealerMaster A,
	           dbo.DealerMaster B
	    WHERE  A.DealerId = B.DMA_ID
	           AND A.ModleID = '00000001-0001-0008-0000-000000000000'
	           AND B.DMA_SAP_Code = @Assessment
	END
	ELSE
	BEGIN
	    SELECT '' A
	    WHERE  1 = 2
	END
	
	--Cfda   
	SELECT DISTINCT A.GM_KIND GM_KIND,
	       A.GM_CATALOG GM_CATALOG,
	       A.CatagoryName CatagoryName
	FROM   V_SubBU_CFDACatalog A,
	       interface.ClassificationAuthorization B
	WHERE  A.CA_ID = B.CA_ID
	       AND B.CA_ParentCode = @SUBDEPID
	
	--Display
	IF @REASON <> 1
	BEGIN
	    SET @Display_FORMERNAME = @Show;
	END
	
	IF @REASON = 3
	BEGIN
	    SET @Display_Assessment = @Show;
	    SET @Display_AssessmentStart = @Show;
	END
	
	IF NOT (@DealerType = 'LP' AND @IsDrm = 1)
	   AND @DepId IN ('17', '19', '32', '35')
	BEGIN
	    SET @Display_ReagionRSM = @Show;
	END
	
	IF @IsThreeLicense != '1'
	BEGIN
	    SET @Display_TA = @Show;
	    SET @Display_OA = @Show;
	END
	
	IF @Payment = 'LC'
	BEGIN
	    SET @Display_PayTerm = @Show;
	END
	
	IF @Payment = 'Credit'
	BEGIN
	    SET @Display_CreditTerm = @Show;
	    SET @Display_CreditLimit = @Show;
	END
	
	IF @IsDeposit = '1'
	BEGIN
	    SET @Display_Deposit = @Show;
	    SET @Display_Inform = @Show;
	END
	
	IF @IsDeposit = '1'
	   AND EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Inform, ',') T
	           WHERE  T.VAL = 'Others'
	       )
	BEGIN
	    SET @Display_InformOther = @Show;
	END
	
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
	
	IF @IsCorssBu = '0'
	BEGIN
	    SET @Display_CorssBuMemo = @Show;
	END  
	
	IF EXISTS (
	       SELECT 1
	       FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_FWFW, ',') T
	       WHERE  T.VAL = '70'
	   )
	BEGIN
	    SET @Display_Jus4_EWFWFW = @Show;
	END
	
	IF EXISTS (
	       SELECT 1
	       FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_FWFW, ',') T
	       WHERE  T.VAL = '70'
	   )
	   AND EXISTS (
	           SELECT 1
	           FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_EWFWFW, ',') T
	           WHERE  T.VAL = '60'
	       )
	BEGIN
	    SET @Display_Jus4_YWFW = @Show;
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
	
	IF @Jus5_SFCD = '1'
	BEGIN
	    SET @Display_Jus5_YYSM = @Show;
	END
	
	IF @Jus8_SFFGD = '1'
	BEGIN
	    SET @Display_Jus8_FGDFS = @Show;
	END
	
	IF @Jus7_ZZBJ = '1'
	BEGIN
	    SET @Display_Jus7_SX = @Show;
	END
	
	IF @Jus7_SYLW = '1'
	BEGIN
	    SET @Display_Jus7_HDMS = @Show;
	END
	
	IF @Pre4_FBZTK = '1'
	BEGIN
	    SET @Display_Pre4_ZDLY = @Show;
	END
	
	IF @REASON IN ('2', '3', '4')
	BEGIN
	    SET @Display_FormerDealer = @Show;
	END
	
	IF @REASON IN ('3')
	BEGIN
	    SET @Display_AssessmentDealer = @Show;
	END
	
	SELECT @Display_FORMERNAME Display_FORMERNAME,
	       @Display_Assessment Display_Assessment,
	       @Display_AssessmentStart Display_AssessmentStart,
	       @Display_ReagionRSM Display_ReagionRSM,
	       @Display_TA Display_TA,
	       @Display_OA Display_OA,
	       @Display_PayTerm Display_PayTerm,
	       @Display_CreditTerm Display_CreditTerm,
	       @Display_CreditLimit Display_CreditLimit,
	       @Display_Deposit Display_Deposit,
	       @Display_Inform Display_Inform,
	       @Display_InformOther Display_InformOther,
	       @Display_DealerLessHosReason Display_DealerLessHosReason,
	       @Display_DealerLessHosQRemark Display_DealerLessHosQRemark,
	       @Display_DealerLessHosReasonQ Display_DealerLessHosReasonQ,
	       @Display_HosLessStandardReason Display_HosLessStandardReason,
	       @Display_HosLessStandardQRemark Display_HosLessStandardQRemark,
	       @Display_HosLessStandardReasonQ Display_HosLessStandardReasonQ,
	       @Display_ProductGroupRemark Display_ProductGroupRemark,
	       @Display_CorssBuMemo Display_CorssBuMemo,
	       @Display_Jus4_EWFWFW Display_Jus4_EWFWFW,
	       @Display_Jus4_YWFW Display_Jus4_YWFW,
	       @Display_Jus6_TJR Display_Jus6_TJR,
	       @Display_Jus6_QTFS Display_Jus6_QTFS,
	       @Display_Jus6_QTXX Display_Jus6_QTXX,
	       @Display_Jus5_YYSM Display_Jus5_YYSM,
	       @Display_Jus8_FGDFS Display_Jus8_FGDFS,
	       @Display_Jus7_SX Display_Jus7_SX,
	       @Display_Jus7_HDMS Display_Jus7_HDMS,
	       @Display_Pre4_ZDLY Display_Pre4_ZDLY,
	       @Display_FormerDealer Display_FormerDealer,
	       @Display_AssessmentDealer Display_AssessmentDealer
	
	--DDReport
	IF NOT EXISTS(SELECT 1 FROM DealerMasterDD WHERE DMDD_DealerID=@CompanyID AND DMDD_DealerID IS NOT NULL)
	BEGIN
		SELECT  '' 'DDReportName',
				'' 'DDStartDate',
				'' 'DDEndDate',
				'' 'DDAttachment'
	END
	ELSE
	BEGIN
		SELECT TOP 1 
		DMDD_ReportName 'DDReportName',
		CONVERT(nvarchar(10),DMDD_StartDate,120) 'DDStartDate',
		CONVERT(nvarchar(10),DMDD_EndDate,120) 'DDEndDate',
		dbo.Func_GetAttachmentHtml(DMDD_DD) 'DDAttachment'
		FROM DealerMasterDD
		WHERE DMDD_DealerID=@CompanyID
		AND DMDD_DealerID IS NOT NULL  
		Order BY DMDD_UpdateDate DESC 
	END
	       --Data End
END



