DROP PROCEDURE [Workflow].[Proc_Contract_AmendmentT2_GetHtmlData]
GO


CREATE PROCEDURE [Workflow].[Proc_Contract_AmendmentT2_GetHtmlData]
	@InstanceId UNIQUEIDENTIFIER
AS
BEGIN
	--Template & Tables
	SELECT 'Contract_AmendmentT2' AS TemplateName,
	       'Main,Current,Proposals,NCM,KPI,Cfda,Qualification,Display' AS TableNames
	
	--DECLARE Start
	
	DECLARE @Hide NVARCHAR(100) = 'display: none; ';
	DECLARE @Show NVARCHAR(100) = ' ';
	
	DECLARE @IsDrm BIT;
	
	--Display
	DECLARE @Display_ReagionRSMShow NVARCHAR(100) = @Hide;
	DECLARE @Display_PaymentAmendShow NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentPayment NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosReason NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardReasonQ NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosQRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardQRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_ProductGroupRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_ConflictRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_HandoverRemark NVARCHAR(100) = @Hide;
	
	
	DECLARE @Display_CurrentProduct NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentPrice NVARCHAR(100) = @Hide;
	DECLARE @Display_PriceAmendShow NVARCHAR(100) = @Hide;
	DECLARE @Display_ProductAmendShow NVARCHAR(100) = @Hide;
	DECLARE @Display_SalesAmendShow NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentSpecialSales NVARCHAR(100) = @Hide;
	DECLARE @Display_Product NVARCHAR(100) = @Hide;
	DECLARE @Display_ProductRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_Price NVARCHAR(100) = @Hide;
	DECLARE @Display_PriceRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_SpecialSalesRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_QuotaTotal NVARCHAR(100) = @Hide;
	DECLARE @Display_QUOTAUSD NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardReason NVARCHAR(100) = @Hide;
	DECLARE @Display_ProductGroupMemo NVARCHAR(100) = @Hide;
	DECLARE @Display_ChangeQuarterShow NVARCHAR(100) = @Hide;
	DECLARE @Display_ChangeReason NVARCHAR(100) = @Hide;
	DECLARE @Display_HospitalAmendShow NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentHospital NVARCHAR(100) = @Hide;
	DECLARE @Display_QuotaAmendShow NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentQuota NVARCHAR(100) = @Hide;
	DECLARE @Display_Hospital NVARCHAR(100) = @Hide;
	DECLARE @Display_Quota NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosReasonQ NVARCHAR(100) = @Hide;
	
	
	--Main
	DECLARE @DealerType NVARCHAR(200) ;
	DECLARE @DepId NVARCHAR(200) ;
	DECLARE @SUBDEPID NVARCHAR(200) ;
	DECLARE @DealerName NVARCHAR(200) ;
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
	
	DECLARE @CurrentHospitalUrl NVARCHAR(1000) ;
	DECLARE @CurrentQuotaUrl NVARCHAR(1000) ;
	
	--Proposals
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
	SELECT @ProductAmend = ISNULL(ProductAmend, ''),
	       @PriceAmend = ISNULL(PriceAmend, ''),
	       @SalesAmend = ISNULL(SalesAmend, ''),
	       @HospitalAmend = ISNULL(HospitalAmend, ''),
	       @QuotaAmend = ISNULL(QuotaAmend, '')
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
	
	--Proposals
	SELECT @DealerLessHosQ = ISNULL(DealerLessHosQ, ''),
	       @HosLessStandardQ = ISNULL(HosLessStandardQ, ''),
	       @ProductGroupCheck = ISNULL(ProductGroupCheck, ''),
	       @DealerLessHos = ISNULL(DealerLessHos, ''),
	       @DealerLessHosQRemark = ISNULL(DealerLessHosQRemark, ''),
	       @HosLessStandard = ISNULL(HosLessStandard, ''),
	       @HosLessStandardQRemark = ISNULL(HosLessStandardQRemark, '')
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
	SET @HospitalUrl += '&ContractType=Appointment';
	
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
	
	--NCM
	SELECT @Conflict = ISNULL(A.Conflict, ''),
	       @Handover = ISNULL(A.Handover, '')
	FROM   [Contract].AmendmentNCM A
	WHERE  A.ContractId = @InstanceId;
	
	--Condition End
	
	--Data Start
	
	--Main	
	SELECT 	case when exists (select 1 from DealerAuthorizationTableTemp a where a.DAT_DCL_ID=@InstanceId and a.DAT_PMA_ID='61A77AEC-3800-4177-AA4B-64AA32FB9F47') then'该申请包含spyglass耗材产品授权，请在审批人中增加赵新平' else'' end as [Message],
	       ISNULL(ContractNo, '') ContractNo,
	       dbo.Func_GetCode('CONST_CONTRACT_DealerType', A.DealerType) DealerTypeShow,
	       ISNULL(B.DepFullName, '') DepIdShow,
	       ISNULL(C.CC_NameCN, '') SUBDEPIDShow,
	       ISNULL(EName, '') EName,
	       ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), '') RequestDate,
	       ISNULL(F.DepFullName, '') ApplicantDepShow,
	       ISNULL(E.DMA_ChineseName, '') Assessment,
	       ISNULL(CONVERT(NVARCHAR(7), AssessmentStart, 121), '') AssessmentStart,
	       ISNULL(D.DMA_SAP_Code + ' - ' + D.DMA_ChineseName, '') DealerNameShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsEquipment) IsEquipmentShow,
	       dbo.Func_GetCode('CONST_CONTRACT_MarketType', A.MarketType) MarketTypeShow,
	       ISNULL(CONVERT(NVARCHAR(10), DealerBeginDate, 121), '') DealerBeginDate,
	       ISNULL(CONVERT(NVARCHAR(10), DealerEndDate, 121), '') DealerEndDate,
	       ISNULL(CONVERT(NVARCHAR(10), AmendEffectiveDate, 121), '') AmendEffectiveDate,
	       A.Purpose Purpose,
	       (
	           SELECT TOP 1 T.ManagerName
	           FROM   MDM_Manager T
	           WHERE  A.ReagionRSM = T.EmpNo
	                  AND T.ManagerTitle = 'RSM'
	       ) AS ReagionRSMShow
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
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.PaymentAmend) PaymentAmendShow,
	       ISNULL(Payment, '') CurrentPayment,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.HospitalAmend) HospitalAmendShow,
	       SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)) CurrentHospital,
	       @CurrentHospitalUrl CurrentHospitalUrl,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.QuotaAmend) QuotaAmendShow,
	       SUBSTRING(Quota, 0, CHARINDEX('<', Quota)) CurrentQuota,
	       @CurrentQuotaUrl CurrentQuotaUrl,
	       ISNULL(Attachment, '') CurrentAttachment
	FROM   [Contract].AmendmentCurrent A
	WHERE  A.ContractId = @InstanceId;
	
	--Proposals
	SELECT dbo.Func_GetCode('CONST_CONTRACT_ProposalsProduct', A.Product) Product,
	       ISNULL(ProductRemark, '') ProductRemark,
	       ISNULL(Price, '') Price,
	       ISNULL(PriceRemark, '') PriceRemark,
	       ISNULL(SpecialSales, '') SpecialSales,
	       ISNULL(SpecialSalesRemark, '') SpecialSalesRemark,
	       ISNULL(SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)), '') Hospital,
	       @HospitalUrl HospitalUrl,
	       ISNULL(SUBSTRING(Quota, 0, CHARINDEX('<', Quota)), '') Quota,
	       @QuotaUrl QuotaUrl,
	       ISNULL(CONVERT(NVARCHAR(20), QuotaTotal), '') QuotaTotal,
	       ISNULL(CONVERT(NVARCHAR(20), QUOTAUSD), '') QUOTAUSD,
	       ISNULL(DealerLessHosReason, '') DealerLessHosReason,
	       ISNULL(DealerLessHosQRemark, '') DealerLessHosQRemark,
	       ISNULL(DealerLessHosReasonQ, '') DealerLessHosReasonQ,
	       ISNULL(HosLessStandardReason, '') HosLessStandardReason,
	       ISNULL(HosLessStandardQRemark, '') HosLessStandardQRemark,
	       ISNULL(DealerLessHosReasonQ, '') HosLessStandardReasonQ,
	       ISNULL(ProductGroupRemark, '') ProductGroupRemark,
	       ISNULL(ProductGroupMemo, '') ProductGroupMemo,
	       dbo.Func_GetCode('CONST_CONTRACT_ChangeQuarter', A.ChangeQuarter) ChangeQuarterShow,
	       ISNULL(ChangeReason, '') ChangeReason,
	       ISNULL(Attachment, '') Attachment
	FROM   [Contract].AmendmentProposals A
	WHERE  A.ContractId = @InstanceId;
	
	--NCM
	SELECT dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Conflict) ConflictShow,
	       ISNULL(A.ConflictRemark, '') ConflictRemark,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Handover) HandoverShow,
	       ISNULL(A.HandoverRemark, '') HandoverRemark
	FROM   [Contract].AmendmentNCM A
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
	
	IF @ProductAmend = '1'
	BEGIN
	    SET @Display_CurrentProduct = @Show;
	    SET @Display_ProductAmendShow = @Show;
	    SET @Display_Product = @Show;
	    SET @Display_ProductRemark = @Show;
	END
	
	
	
	IF @PriceAmend = '1'
	BEGIN
	    SET @Display_CurrentPrice = @Show;
	    SET @Display_PriceAmendShow = @Show;
	    SET @Display_Price = @Show;
	    SET @Display_PriceRemark = @Show;
	END
	
	
	IF @SalesAmend = '1'
	BEGIN
	    SET @Display_SalesAmendShow = @Show;
	    SET @Display_CurrentSpecialSales = @Show;
	    SET @Display_CurrentSpecialSales = @Show;
	    SET @Display_SpecialSalesRemark = @Show;
	END
	
	
	IF @HospitalAmend = '1'
	BEGIN
	    SET @Display_HospitalAmendShow = @Show;
	    SET @Display_CurrentHospital = @Show;
	    SET @Display_Hospital = @Show;
	END
	
	
	IF @QuotaAmend = '1'
	BEGIN
	    SET @Display_QuotaAmendShow = @Show;
	    SET @Display_CurrentQuota = @Show;
	    SET @Display_Quota = @Show;
	    SET @Display_QuotaTotal = @Show;
	    SET @Display_QUOTAUSD = @Show;
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
	    
	    SET @Display_ProductGroupMemo = @Show;
	    SET @Display_ChangeQuarterShow = @Show;
	    SET @Display_ChangeReason = @Show;
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
	       @Display_PaymentAmendShow Display_PaymentAmendShow,
	       @Display_CurrentPayment Display_CurrentPayment,
	       @Display_DealerLessHosReason Display_DealerLessHosReason,
	       @Display_HosLessStandardReasonQ Display_HosLessStandardReasonQ,
	       @Display_DealerLessHosQRemark Display_DealerLessHosQRemark,
	       @Display_HosLessStandardQRemark Display_HosLessStandardQRemark,
	       @Display_ProductGroupRemark Display_ProductGroupRemark,
	       @Display_ConflictRemark Display_ConflictRemark,
	       @Display_HandoverRemark Display_HandoverRemark,
	       @Display_CurrentProduct Display_CurrentProduct,
	       @Display_CurrentPrice Display_CurrentPrice,
	       @Display_PriceAmendShow Display_PriceAmendShow,
	       @Display_ProductAmendShow Display_ProductAmendShow,
	       @Display_SalesAmendShow Display_SalesAmendShow,
	       @Display_CurrentSpecialSales Display_CurrentSpecialSales,
	       @Display_Product Display_Product,
	       @Display_ProductRemark Display_ProductRemark,
	       @Display_Price Display_Price,
	       @Display_PriceRemark Display_PriceRemark,
	       @Display_SpecialSalesRemark Display_SpecialSalesRemark,
	       @Display_QuotaTotal Display_QuotaTotal,
	       @Display_QUOTAUSD Display_QUOTAUSD,
	       @Display_HosLessStandardReason Display_HosLessStandardReason,
	       @Display_ProductGroupMemo Display_ProductGroupMemo,
	       @Display_ChangeQuarterShow Display_ChangeQuarterShow,
	       @Display_ChangeReason Display_ChangeReason,
	       @Display_HospitalAmendShow Display_HospitalAmendShow,
	       @Display_CurrentHospital Display_CurrentHospital,
	       @Display_QuotaAmendShow Display_QuotaAmendShow,
	       @Display_CurrentQuota Display_CurrentQuota,
	       @Display_Hospital Display_Hospital,
	       @Display_Quota Display_Quota,
	       @Display_DealerLessHosReasonQ Display_DealerLessHosReasonQ
	       --Data End
END
GO


