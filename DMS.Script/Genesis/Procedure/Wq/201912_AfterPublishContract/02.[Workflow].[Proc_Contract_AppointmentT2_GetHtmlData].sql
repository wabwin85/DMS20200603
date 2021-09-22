
/****** Object:  StoredProcedure [Workflow].[Proc_Contract_AppointmentT2_GetHtmlData]    Script Date: 2019/12/2 13:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [Workflow].[Proc_Contract_AppointmentT2_GetHtmlData]
	@InstanceId UNIQUEIDENTIFIER
AS
BEGIN
	--Template & Tables
	SELECT 'Contract_AppointmentT2' AS TemplateName,
	       'Main,Candidate,Documents,Competency,Proposals,CrossBu,SameDealer,FormerDealer,AssessmentDealer,Cfda,Display,DDReport,TrainInfo' AS 
	       TableNames
	
	--DECLARE Start
	
	DECLARE @Hide NVARCHAR(100) = 'display: none; ';
	DECLARE @Show NVARCHAR(100) = ' ';
	
	DECLARE @IsDrm BIT;
	
	--Display
	DECLARE @Display_REASONShow NVARCHAR(100) = @Hide;
	DECLARE @Display_FORMERNAME NVARCHAR(100) = @Hide;
	DECLARE @Display_AssessmentShow NVARCHAR(100) = @Hide;
	DECLARE @Display_AssessmentStart NVARCHAR(100) = @Hide;
	DECLARE @Display_ReagionRSMShow NVARCHAR(100) = @Hide;
	DECLARE @Display_TA NVARCHAR(100) = @Hide;
	DECLARE @Display_OA NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosReasonQ NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardQRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_ProductGroupRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosQRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_CorssBuMemo NVARCHAR(100) = @Hide;
	DECLARE @Display_FormerDealer NVARCHAR(100) = @Hide;
	DECLARE @Display_AssessmentDealer NVARCHAR(100) = @Hide;
	DECLARE @Display_DealerLessHosReason NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardReasonQ NVARCHAR(100) = @Hide;
	DECLARE @Display_HosLessStandardReason NVARCHAR(100) = @Hide;
	
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
	
	--Documents
	DECLARE @IsThreeLicense NVARCHAR(200) ;
	
	--Proposals
	DECLARE @AgreementBegin NVARCHAR(200) ;
	DECLARE @AgreementEnd NVARCHAR(200) ;
	DECLARE @DealerLessHosQ NVARCHAR(200) ;
	DECLARE @HosLessStandardQ NVARCHAR(200) ;
	DECLARE @ProductGroupCheck NVARCHAR(200) ;
	DECLARE @IsCorssBu NVARCHAR(200) ;
	DECLARE @DealerLessHos NVARCHAR(200) ;
	DECLARE @DealerLessHosQRemark NVARCHAR(200) ;
	DECLARE @HosLessStandard NVARCHAR(200) ;
	DECLARE @HosLessStandardQRemark NVARCHAR(200);
	
	DECLARE @HospitalUrl NVARCHAR(1000) ;
	DECLARE @QuotaUrl NVARCHAR(1000) ;
	

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
		   @MarketType = A.MarketType
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
	       @DealerLessHosQ = ISNULL(DealerLessHosQ, ''),
	       @HosLessStandardQ = ISNULL(HosLessStandardQ, ''),
	       @ProductGroupCheck = ISNULL(ProductGroupCheck, ''),
	       @IsCorssBu = ISNULL(IsCorssBu, ''),
	       @DealerLessHos = ISNULL(DealerLessHos, ''),
	       @DealerLessHosQRemark = ISNULL(DealerLessHosQRemark, ''),
	       @HosLessStandard = ISNULL(HosLessStandard, ''),
	       @HosLessStandardQRemark = ISNULL(HosLessStandardQRemark, '')
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
	SET @HospitalUrl += '&PropertyType=0';
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
	
	--Condition End
	
	--Data Start
	
	--Main	
	SELECT  case when exists (select 1 from DealerAuthorizationTableTemp a where a.DAT_DCL_ID=@InstanceId and a.DAT_PMA_ID='61A77AEC-3800-4177-AA4B-64AA32FB9F47') then'该申请包含spyglass耗材产品授权，请在审批人中增加赵新平' else'' end as [Message],
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
	       ) AS ReagionRSMShow
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
	       ISNULL(Contact, '') Contact,
	       ISNULL(EMail, '') EMail,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsEquipment) IsEquipmentShow,
	       ISNULL(OfficeNumber, '') OfficeNumber,
	       ISNULL(Mobile, '') Mobile,
	       dbo.Func_GetCode('CONST_CONTRACT_DealerMark', A.DealerMark) DealerMarkShow,
	       ISNULL(OfficeAddress, '') OfficeAddress,
	       ISNULL(CONVERT(NVARCHAR(10), EstablishedTime, 121), '') EstablishedTime,
	       ISNULL(Capital, '') Capital,
	       ISNULL(B.DMA_ChineseShortName, '') LPSAPCodeShow,
	       ISNULL(BusinessContact, '') BusinessContact,
	       ISNULL(BusinessEMail, '') BusinessEMail,
	       ISNULL(BusinessMobile, '') BusinessMobile
	FROM   [Contract].AppointmentCandidate A
	       LEFT JOIN DealerMaster B
	            ON  A.LPSAPCode = B.DMA_SAP_Code
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
	
	
	
	--CrossBu
	SELECT DISTINCT ISNULL(E.HOS_Key_Account, '') HospitalCode,
	       ISNULL(E.HOS_HospitalName, '') HospitalName,
	       ISNULL(F.DMA_SAP_Code, '') SAPCode,
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
	    SET @Display_REASONShow = @Show;
	    SET @Display_FORMERNAME = @Show;
	END
	ELSE
	BEGIN
	    SET @Display_REASONShow = @Show;
	END
	
	IF @REASON = 3
	BEGIN
	    SET @Display_AssessmentShow = @Show;
	    SET @Display_AssessmentStart = @Show;
	END
	
	IF NOT (@DealerType = 'LP' AND @IsDrm = 1)
	   AND @DepId IN ('17', '19', '32', '35')
	BEGIN
	    SET @Display_ReagionRSMShow = @Show;
	END
	
	IF @IsThreeLicense != '1'
	BEGIN
	    SET @Display_TA = @Show;
	    SET @Display_OA = @Show;
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
	
	IF @IsCorssBu = '0'
	BEGIN
	    SET @Display_CorssBuMemo = @Show;
	END  
	
	IF @REASON IN ('2', '3', '4')
	BEGIN
	    SET @Display_FormerDealer = @Show;
	END
	
	IF @REASON IN ('3')
	BEGIN
	    SET @Display_AssessmentDealer = @Show;
	END
	
	SELECT @Display_REASONShow Display_REASONShow,
	       @Display_FORMERNAME Display_FORMERNAME,
	       @Display_REASONShow Display_REASONShow,
	       @Display_DealerLessHosReason Display_DealerLessHosReason,
	       @Display_DealerLessHosReasonQ Display_DealerLessHosReasonQ,
	       @Display_HosLessStandardReasonQ Display_HosLessStandardReasonQ,
	       @Display_HosLessStandardReason Display_HosLessStandardReason,
	       @Display_AssessmentShow Display_AssessmentShow,
	       @Display_AssessmentStart Display_AssessmentStart,
	       @Display_ReagionRSMShow Display_ReagionRSMShow,
	       @Display_TA Display_TA,
	       @Display_OA Display_OA,
	       @Display_HosLessStandardQRemark Display_HosLessStandardQRemark,
	       @Display_ProductGroupRemark Display_ProductGroupRemark,
	       @Display_CorssBuMemo Display_CorssBuMemo,
	       @Display_FormerDealer Display_FormerDealer,
	       @Display_AssessmentDealer Display_AssessmentDealer,
	       @Display_DealerLessHosQRemark Display_DealerLessHosQRemark


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

	--TrainInfo
	
	SELECT TestType TrainType,
		   TestName TrainName,
		   CONVERT(varchar(100), TestDate, 120) TrainDate,
		   TestStatus IsPass
	FROM(
		   SELECT ROW_NUMBER() OVER (PARTITION BY TestType ORDER BY TestDate DESC) rowId,* 
		   FROM interface.T_I_MDM_DealerTraining
		   WHERE DealerID=@CompanyID
		)  AS tab 
	WHERE rowId=1
	       --Data End
END

