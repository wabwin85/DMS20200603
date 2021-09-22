
/****** Object:  StoredProcedure [Workflow].[Proc_Contract_RenewalT2_GetHtmlData]    Script Date: 2019/11/22 14:25:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [Workflow].[Proc_Contract_RenewalT2_GetHtmlData]
	@InstanceId UNIQUEIDENTIFIER
AS
BEGIN
	--Template & Tables
	SELECT 'Contract_RenewalT2' AS TemplateName,
	       'Main,Current,Proposals,NCM,KPI,Cfda,Qualification,Display,DDReport' AS TableNames
	
	--DECLARE Start
	
	DECLARE @Hide NVARCHAR(100) = 'display: none; ';
	DECLARE @Show NVARCHAR(100) = ' ';
	
	DECLARE @IsDrm BIT;
	
	--Display
	DECLARE @Display_ReagionRSMShow NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosQRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardQRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_ProductGroupRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_ConflictRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_HandoverRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosReason NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardReasonQ NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardReason NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosReasonQ NVARCHAR(100) = @Hide;
	
	--Main
	DECLARE @DealerType NVARCHAR(200) ;
	DECLARE @DepId NVARCHAR(200) ;
	DECLARE @SUBDEPID NVARCHAR(200) ;
	DECLARE @DealerName NVARCHAR(200) ;
	DECLARE @CompanyID NVARCHAR(200) ;
	DECLARE @RequestDate NVARCHAR(200) ;
	DECLARE @AOPTYPE NVARCHAR(200) ;
	DECLARE @IsLP NVARCHAR(200) ;
	DECLARE @MarketType NVARCHAR(200) ;
	DECLARE @HospitalType NVARCHAR(200) ;
	
	--Current	
	DECLARE @CurrentAgreementBegin NVARCHAR(200) ;
	DECLARE @CurrentAgreementEnd NVARCHAR(200) ;
	
	DECLARE @CurrentHospitalUrl NVARCHAR(1000) ;
	DECLARE @CurrentQuotaUrl NVARCHAR(1000) ;
	
	--Proposals
	DECLARE @AgreementBegin NVARCHAR(200) ;
	DECLARE @AgreementEnd NVARCHAR(200) ;
	DECLARE @DealerLessHosQ NVARCHAR(200) ;
	DECLARE @HosLessStandardQ NVARCHAR(200) ;
	DECLARE @ProductGroupCheck NVARCHAR(200) ;
	DECLARE @DealerLessHos NVARCHAR(200) ;
	DECLARE @DealerLessHosQRemark NVARCHAR(200) ;
	DECLARE @HosLessStandard NVARCHAR(200) ;
	DECLARE @HosLessStandardQRemark NVARCHAR(200) ;
	
	DECLARE @HospitalUrl NVARCHAR(1000) ;
	DECLARE @QuotaUrl NVARCHAR(1000) ;
	
	--NCM
	DECLARE @Conflict NVARCHAR(200) ;
	DECLARE @Handover NVARCHAR(200) ;
	

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
	SELECT @DealerType = ISNULL(A.DealerType, ''),
	       @DepId = A.DepId,
	       @SUBDEPID = A.SUBDEPID,
	       @DealerName = ISNULL(A.DealerName, ''),
	       @CompanyID = ISNULL(A.CompanyID, ''),
	       @RequestDate = ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), ''),
	       @AOPTYPE = ISNULL(AOPTYPE, ''),
	       @IsLP = A.IsLP,
	       @MarketType = MarketType,
	       @HospitalType = A.HospitalType
	FROM   [Contract].RenewalMain A
	WHERE  A.ContractId = @InstanceId;
	
	--Current	
	SELECT @CurrentAgreementBegin = ISNULL(CONVERT(NVARCHAR(10), A.AgreementBegin, 121), ''),
	       @CurrentAgreementEnd = ISNULL(CONVERT(NVARCHAR(10), A.AgreementEnd, 121), '')
	FROM   [Contract].RenewalCurrent A
	WHERE  A.ContractId = @InstanceId;
	
	SET @CurrentHospitalUrl = '';
	SET @CurrentHospitalUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl');
	SET @CurrentHospitalUrl += 'Contract/PagesEkp/Contract/DealerAopHistoryList.aspx';
	SET @CurrentHospitalUrl += '?ContractId=' + CONVERT(NVARCHAR(50), @InstanceId);
	SET @CurrentHospitalUrl += '&DealerId=' + CONVERT(NVARCHAR(50), @CompanyID);
	SET @CurrentHospitalUrl += '&SubBu=' + @SUBDEPID;
	SET @CurrentHospitalUrl += '&PropertyType=0';
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
	SET @CurrentQuotaUrl += '&EffectiveDate=' + @CurrentAgreementBegin;
	SET @CurrentQuotaUrl += '&ExpirationDate=' + @CurrentAgreementEnd;
	SET @CurrentQuotaUrl += '&MarketType=' + @MarketType;
	
	--Proposals
	SELECT @AgreementBegin = CONVERT(NVARCHAR(10), A.AgreementBegin, 121),
	       @AgreementEnd = CONVERT(NVARCHAR(10), A.AgreementEnd, 121),
	       @DealerLessHosQ = ISNULL(DealerLessHosQ, ''),
	       @HosLessStandardQ = ISNULL(HosLessStandardQ, ''),
	       @ProductGroupCheck = ISNULL(ProductGroupCheck, 0),
	       @DealerLessHos = ISNULL(DealerLessHos, ''),
	       @DealerLessHosQRemark = ISNULL(DealerLessHosQRemark, ''),
	       @HosLessStandard = ISNULL(HosLessStandard, ''),
	       @HosLessStandardQRemark = ISNULL(HosLessStandardQRemark, '')
	FROM   [Contract].RenewalProposals A
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
	SET @HospitalUrl += '&PropertyType=0';
	SET @HospitalUrl += '&DealerType=' + @DealerType;
	SET @HospitalUrl += '&MarketType=' + @MarketType;
	SET @HospitalUrl += '&ContractType=Renewal';
	
	SET @QuotaUrl = '';
	SET @QuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl');
	SET @QuotaUrl += 'Contract/PagesEkp/Contract/DealerAopList.aspx';
	SET @QuotaUrl += '?ContractId=' + CONVERT(NVARCHAR(50), @InstanceId);
	SET @QuotaUrl += '&DealerId=' + CONVERT(NVARCHAR(50), @CompanyID);
	SET @QuotaUrl += '&AopType=' + @AOPTYPE;
	SET @QuotaUrl += '&SubBu=' + @SUBDEPID;
	SET @QuotaUrl += '&ContractType=Renewal';
	SET @QuotaUrl += '&DepId=' + @DepId;
	SET @QuotaUrl += '&DealerType=' + @DealerType;
	SET @QuotaUrl += '&AgreementBegin=' + @AgreementBegin;
	SET @QuotaUrl += '&AgreementEnd=' + @AgreementEnd;
	SET @QuotaUrl += '&MarketType=' + @MarketType;
	
	--NCM
	SELECT @Conflict = ISNULL(A.Conflict, ''),
	       @Handover = ISNULL(A.Handover, '')
	FROM   [Contract].RenewalNCM A
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
	       ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), '') RequestDate,
	       ISNULL(F.DepFullName, '') ApplicantDepShow,
	       ISNULL(D.DMA_SAP_Code + ' - ' + D.DMA_ChineseName, '') DealerNameShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsEquipment) IsEquipmentShow,
	       dbo.Func_GetCode('CONST_CONTRACT_MarketType', A.MarketType) MarketTypeShow,
	       (
	           SELECT TOP 1 T.ManagerName
	           FROM   MDM_Manager T
	           WHERE  A.ReagionRSM = T.EmpNo
	                  AND T.ManagerTitle = 'RSM'
	       ) AS ReagionRSMShow,
	       ISNULL(A.IAF, '') IAF
	FROM   [Contract].RenewalMain A
	       LEFT JOIN interface.mdm_department B
	            ON  CONVERT(NVARCHAR(10), A.DepId) = B.DepID
	       LEFT JOIN interface.ClassificationContract C
	            ON  A.SUBDEPID = C.CC_Code
	       LEFT JOIN DealerMaster D
	            ON  A.DealerName = D.DMA_SAP_Code
	       LEFT JOIN interface.mdm_department F
	            ON  CONVERT(NVARCHAR(10), A.ApplicantDep) = F.DepID
	WHERE  A.ContractId = @InstanceId;
	
	--Current
	SELECT ISNULL(A.ContractType, '') CurrentContractType,
	       ISNULL(A.BSC, '') CurrentBSC,
	       ISNULL(A.Exclusiveness, '') CurrentExclusiveness,
	       ISNULL(CONVERT(NVARCHAR(10), A.AgreementBegin, 121), '') CurrentAgreementBegin,
	       ISNULL(CONVERT(NVARCHAR(10), A.AgreementEnd, 121), '') CurrentAgreementEnd,
	       ISNULL(A.Product, '') CurrentProduct,
	       ISNULL(A.ProductRemark, '') CurrentProductRemark,
	       ISNULL(A.Price, '') CurrentPrice,
	       ISNULL(A.PriceRemark, '') CurrentPriceRemark,
	       ISNULL(A.SpecialSales, '') CurrentSpecialSales,
	       ISNULL(A.SpecialSalesRemark, '') CurrentSpecialSalesRemark,
	       SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)) CurrentHospital,
	       @CurrentHospitalUrl CurrentHospitalUrl,
	       SUBSTRING(Quota, 0, CHARINDEX('<', Quota)) CurrentQuota,
	       @CurrentQuotaUrl CurrentQuotaUrl,
	       ISNULL(CONVERT(NVARCHAR(20), QuotaTotal), '') CurrentQuotaTotal,
	       ISNULL(A.Attachment, '') CurrentAttachment
	FROM   [Contract].RenewalCurrent A
	WHERE  A.ContractId = @InstanceId;
	
	--Proposals
	SELECT ISNULL(A.ContractType, '') ContractType,
	       ISNULL(A.BSC, '') BSC,
	       ISNULL(A.Exclusiveness, '') Exclusiveness,
	       CONVERT(NVARCHAR(10), A.AgreementBegin, 121) AgreementBegin,
	       CONVERT(NVARCHAR(10), A.AgreementEnd, 121) AgreementEnd,
	       dbo.Func_GetCode('CONST_CONTRACT_ProposalsProduct', A.Product) Product,
	       ISNULL(ProductRemark, '') ProductRemark,
	       ISNULL(Price, '') Price,
	       ISNULL(PriceRemark, '') PriceRemark,
	       ISNULL(SpecialSales, '') SpecialSales,
	       ISNULL(SpecialSalesRemark, '') SpecialSalesRemark,
	       SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)) Hospital,
	       @HospitalUrl HospitalUrl,
	       SUBSTRING(Quota, 0, CHARINDEX('<', Quota)) Quota,
	       @QuotaUrl QuotaUrl,
	       CONVERT(NVARCHAR(20), QuotaTotal) QuotaTotal,
	       CONVERT(NVARCHAR(20), QUOTAUSD) QUOTAUSD,
	       ISNULL(DealerLessHosReason, '') DealerLessHosReason,
	       ISNULL(DealerLessHosQRemark, '') DealerLessHosQRemark,
	       ISNULL(DealerLessHosReasonQ, '') DealerLessHosReasonQ,
	       ISNULL(HosLessStandardReason, '') HosLessStandardReason,
	       ISNULL(HosLessStandardQRemark, '') HosLessStandardQRemark,
	       ISNULL(HosLessStandardReasonQ, '') HosLessStandardReasonQ,
	       ISNULL(ProductGroupRemark, '') ProductGroupRemark,
	       ISNULL(ProductGroupMemo, '') ProductGroupMemo,
	       ISNULL(Attachment, '') Attachment
	FROM   [Contract].RenewalProposals A
	WHERE  A.ContractId = @InstanceId;
	
	--NCM
	SELECT dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Conflict) ConflictShow,
	       ISNULL(A.ConflictRemark, '') ConflictRemark,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Handover) HandoverShow,
	       ISNULL(A.HandoverRemark, '') HandoverRemark
	FROM   [Contract].RenewalNCM A
	WHERE  A.ContractId = @InstanceId;
	
	--kpi
	SELECT A.Column1 [Year],
	       A.Column2 [Quarter],
	       A.Column5 Division,
	       A.Column7 SubBUName,
	       A.Column11 TotalScore
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
	    SET @Display_ReagionRSMShow = @Show;
	END
	
	
	IF @DealerLessHos = '1'
	BEGIN
	    SET @Display_DealerLessHosReason = @Show;
	END
	
	IF @DealerLessHosQRemark <> ''
	BEGIN
	    SET @Display_DealerLessHosQRemark = @Show;
	END
	
	IF @DealerLessHosQ = '1'
	BEGIN
	    SET @Display_DealerLessHosReasonQ = @Show;
	END
	
	IF @HosLessStandard = '1'
	BEGIN
	    SET @Display_HosLessStandardReason = @Show;
	END
	
	IF @HosLessStandardQRemark <> ''
	BEGIN
	    SET @Display_HosLessStandardQRemark = @Show;
	END
	
	IF @HosLessStandardQ = '1'
	BEGIN
	    SET @Display_HosLessStandardReasonQ = @Show;
	END
	
	IF @ProductGroupCheck = '0'
	BEGIN
	    SET @Display_ProductGroupRemark = @Show;
	END
	
	
	
	
	
	IF @Conflict = '1'
	BEGIN
	    SET @Display_ConflictRemark = @Show;
	END
	
	IF @Handover = '1'
	BEGIN
	    SET @Display_HandoverRemark = @Show;
	END
	
	SELECT @Display_ReagionRSMShow Display_ReagionRSMShow,
	       @Display_DealerLessHosReason Display_DealerLessHosReason,
	       @Display_DealerLessHosReasonQ Display_DealerLessHosReasonQ,
	       @Display_HosLessStandardReasonQ Display_HosLessStandardReasonQ,
	       @Display_HosLessStandardReason Display_HosLessStandardReason,
	       @Display_DealerLessHosQRemark Display_DealerLessHosQRemark,
	       @Display_HosLessStandardQRemark Display_HosLessStandardQRemark,
	       @Display_ProductGroupRemark Display_ProductGroupRemark,
	       @Display_ConflictRemark Display_ConflictRemark,
	       @Display_HandoverRemark Display_HandoverRemark
	
	
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
