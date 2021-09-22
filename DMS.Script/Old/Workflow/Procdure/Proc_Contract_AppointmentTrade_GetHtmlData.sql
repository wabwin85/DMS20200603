
DROP PROCEDURE [Workflow].[Proc_Contract_AppointmentTrade_GetHtmlData]
GO


CREATE PROCEDURE [Workflow].[Proc_Contract_AppointmentTrade_GetHtmlData]
	@InstanceId UNIQUEIDENTIFIER
AS
BEGIN
	--Template & Tables
	SELECT 'Contract_AppointmentTrade' AS TemplateName,
	       'Main,Candidate,Documents,Proposals,Display' AS TableNames
	
	--DECLARE Start
	
	DECLARE @Hide NVARCHAR(100) = 'display: none; ';
	DECLARE @Show NVARCHAR(100) = ' ';
		
	--Display
	DECLARE @Display_ReagionRSM NVARCHAR(100) = @Hide;
	DECLARE @Display_ForeignRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_TA NVARCHAR(100) = @Hide;
	DECLARE @Display_OA NVARCHAR(100) = @Hide;
	
	--Main
	DECLARE @DepId NVARCHAR(200) ;
	
	--Candidate
	DECLARE @IsForeign NVARCHAR(200) ;
	
	--Documents
	DECLARE @IsThreeLicense NVARCHAR(200) ;
	
	--DECLARE End
	
	--Condition Start
	
	--Main
	SELECT @DepId = A.DepId
	FROM   [Contract].AppointmentMain A
	WHERE  A.ContractId = @InstanceId;
	
	--Candidate
	SELECT @IsForeign = ISNULL(A.IsForeign, '')
	FROM   [Contract].AppointmentCandidate A
	WHERE  A.ContractId = @InstanceId;
	
	--Documents
	SELECT @IsThreeLicense = IsThreeLicense
	FROM   [Contract].AppointmentDocuments A
	WHERE  A.ContractId = @InstanceId;
	
	--Condition End
	
	--Data Start
	
	--Main	
	SELECT ISNULL(A.ContractNo, '') ContractNo,
	       dbo.Func_GetCode('CONST_CONTRACT_DealerType', A.DealerType) DealerTypeShow,
	       ISNULL(B.DepFullName, '') DepIdShow,
	       ISNULL(A.EId, '') EId,
	       ISNULL(A.EName, '') EName,
	       ISNULL(CONVERT(NVARCHAR(10), A.RequestDate, 121), '') RequestDate,
	       ISNULL(F.DepFullName, '') ApplicantDepShow,
	       (
	           SELECT TOP 1 T.ManagerName
	           FROM   MDM_Manager T
	           WHERE  A.ReagionRSM = T.EmpNo
	                  AND T.ManagerTitle = 'RSM'
	       ) AS ReagionRSMShow
	FROM   [Contract].AppointmentMain A
	       LEFT JOIN interface.mdm_department B
	            ON  CONVERT(NVARCHAR(10), A.DepId) = B.DepID
	       LEFT JOIN interface.mdm_department F
	            ON  CONVERT(NVARCHAR(10), A.ApplicantDep) = F.DepID
	WHERE  A.ContractId = @InstanceId;
	
	--Candidate
	SELECT ISNULL(CompanyName, '') CompanyName,
	       ISNULL(CompanyEName, '') CompanyEName,
	       ISNULL(Contact, '') Contact,
	       ISNULL(EMail, '') EMail,
	       ISNULL(OfficeNumber, '') OfficeNumber,
	       ISNULL(Mobile, '') Mobile,
	       ISNULL(OfficeAddress, '') OfficeAddress,
	       ISNULL(CONVERT(NVARCHAR(10), EstablishedTime, 121), '') EstablishedTime,
	       ISNULL(Capital, '') Capital,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsForeign) IsForeignShow,
	       ISNULL(ForeignRemark, '') ForeignRemark
	FROM   [Contract].AppointmentCandidate A
	WHERE  A.ContractId = @InstanceId;
	
	--Documents
	SELECT dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsThreeLicense) IsThreeLicenseShow,
	       dbo.Func_GetAttachmentHtml(BA) BA,
	       dbo.Func_GetAttachmentHtml(TA) TA,
	       dbo.Func_GetAttachmentHtml(OA) OA,
	       dbo.Func_GetAttachmentHtml(RA) RA
	FROM   [Contract].AppointmentDocuments A
	WHERE  A.ContractId = @InstanceId;
	
	--Proposals
	SELECT dbo.Func_GetAttachmentHtml(A.AccountForm) AccountForm
	FROM   [Contract].AppointmentProposals A
	WHERE  A.ContractId = @InstanceId;
	
	--Display
	IF @DepId IN ('17', '19', '32', '35')
	BEGIN
	    SET @Display_ReagionRSM = @Show;
	END
	
	IF @IsForeign = '1'
	BEGIN
	    SET @Display_ForeignRemark = @Show;
	END
	
	IF @IsThreeLicense != '1'
	BEGIN
	    SET @Display_TA = @Show;
	    SET @Display_OA = @Show;
	END
	
	SELECT @Display_ReagionRSM Display_ReagionRSM,
	       @Display_ForeignRemark Display_ForeignRemark,
	       @Display_TA Display_TA,
	       @Display_OA Display_OA
	       
	       --Data End
END
GO


