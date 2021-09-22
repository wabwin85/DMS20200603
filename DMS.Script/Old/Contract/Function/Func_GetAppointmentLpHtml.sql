DROP FUNCTION [Contract].[Func_GetAppointmentLpHtml]
GO


CREATE FUNCTION [Contract].[Func_GetAppointmentLpHtml]
(
  @ContractId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Rtn NVARCHAR(MAX);
  
  SET @Rtn = '<style type="text/css">table.gridtable {width:100%; font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}td.title{background-color: #E8E8E8;font-weight:bold;}</style>'
  
  --�Ƿ�DRM�û�����������RSMѡ�� 2016-11-09
  DECLARE @IsDrm BIT;
  SELECT @IsDrm = CASE 
                       WHEN A.DepID = '5' THEN 1
                       ELSE 0
                  END
  FROM   interface.MDM_EmployeeMaster A,
         Lafite_IDENTITY B,
         [Contract].TerminationMain C
  WHERE  A.account = B.IDENTITY_CODE
         AND B.Id = C.CreateUser
         AND C.ContractId = @ContractId
  
  --Main
  DECLARE @ContractNo NVARCHAR(200) ;
  DECLARE @DealerType NVARCHAR(200) ;
  DECLARE @DealerTypeShow NVARCHAR(200) ;
  DECLARE @DepId NVARCHAR(200) ;
  DECLARE @DepIdShow NVARCHAR(200) ;
  DECLARE @SUBDEPID NVARCHAR(200) ;
  DECLARE @SUBDEPIDShow NVARCHAR(200) ;
  DECLARE @EId NVARCHAR(200) ;
  DECLARE @EName NVARCHAR(200) ;
  DECLARE @RequestDate NVARCHAR(200) ;
  DECLARE @REASON NVARCHAR(200) ;
  DECLARE @REASONShow NVARCHAR(200) ;
  DECLARE @FORMERNAME NVARCHAR(200) ;
  DECLARE @FORMERNAMEShow NVARCHAR(200) ;
  DECLARE @Assessment NVARCHAR(200) ;
  DECLARE @AssessmentShow NVARCHAR(200) ;
  DECLARE @AssessmentStart NVARCHAR(200) ;
  DECLARE @ApplicantDepShow NVARCHAR(200) ;
  DECLARE @MarketType NVARCHAR(200) ;
  DECLARE @MarketTypeShow NVARCHAR(200) ;
  DECLARE @IAF NVARCHAR(200) ;
  DECLARE @ReagionRSMShow NVARCHAR(200) ;
  DECLARE @AOPTYPE NVARCHAR(200) ;
  DECLARE @PRICEAUTO INT ;
  DECLARE @REBATEAUTO INT ;
  DECLARE @HOSPITALTYPE INT ;
  DECLARE @IsLP NVARCHAR(200) ;
  DECLARE @ReagionRSM NVARCHAR(200) ;
  
  SELECT @ContractNo = ISNULL(ContractNo, ''),
         @DealerType = ISNULL(DealerType, ''),
         @DealerTypeShow = dbo.Func_GetCode('CONST_CONTRACT_DealerType', A.DealerType),
         @DepId = A.DepId,
         @DepIdShow = ISNULL(B.DepFullName, ''),
         @SUBDEPID = A.SUBDEPID,
         @SUBDEPIDShow = ISNULL(C.CC_NameCN, ''),
         @EId = ISNULL(EId, ''),
         @EName = ISNULL(EName, ''),
         @RequestDate = ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), ''),
         @REASON = A.REASON,
         @REASONShow = dbo.Func_GetCode('CONST_CONTRACT_Reason', A.REASON),
         @FORMERNAME = ISNULL(FORMERNAME, ''),
         @FORMERNAMEShow = ISNULL(D.DMA_ChineseName, ''),
         @Assessment = ISNULL(Assessment, ''),
         @AssessmentShow = ISNULL(E.DMA_ChineseName, ''),
         @AssessmentStart = ISNULL(CONVERT(NVARCHAR(10), AssessmentStart, 121), ''),
         @ApplicantDepShow = ISNULL(F.DepFullName, ''),
         @MarketType = MarketType,
         @MarketTypeShow = dbo.Func_GetCode('CONST_CONTRACT_MarketType', A.MarketType),
         @IAF = ISNULL(A.IAF, ''),
         @ReagionRSMShow = (
             SELECT TOP 1 T.ManagerName
             FROM   MDM_Manager T
             WHERE  A.ReagionRSM = T.EmpNo
                    AND T.ManagerTitle = 'RSM'
         ),
         @ReagionRSM = ISNULL(ReagionRSM, ''),
         @AOPTYPE = ISNULL(AOPTYPE, ''),
         @PRICEAUTO = PRICEAUTO,
         @REBATEAUTO = REBATEAUTO,
         @HOSPITALTYPE = HOSPITALTYPE,
         @IsLP = ISNULL(IsLP, '')
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
  WHERE  A.ContractId = @ContractId;
  
  --Justification
  DECLARE @Jus1_QDJLShow NVARCHAR(500) ;
  DECLARE @Jus3_JXSLX NVARCHAR(500) ;
  DECLARE @Jus3_DZYY NVARCHAR(500) ;
  DECLARE @Jus4_FWFW NVARCHAR(500) ;
  DECLARE @Jus4_FWFWShow NVARCHAR(500) ;
  DECLARE @Jus4_EWFWFW NVARCHAR(500) ;
  DECLARE @Jus4_EWFWFWShow NVARCHAR(500) ;
  DECLARE @Jus4_YWFW NVARCHAR(500) ;
  DECLARE @Jus4_SQFW NVARCHAR(500) ;
  DECLARE @Jus5_SFCD NVARCHAR(500) ;
  DECLARE @Jus5_SFCDShow NVARCHAR(500) ;
  DECLARE @Jus5_YYSM NVARCHAR(500) ;
  DECLARE @Jus5_JTMS NVARCHAR(500) ;
  DECLARE @Jus6_ZMFS NVARCHAR(500) ;
  DECLARE @Jus6_ZMFSShow NVARCHAR(500) ;
  DECLARE @Jus6_TJR NVARCHAR(500) ;
  DECLARE @Jus6_QTFS NVARCHAR(500) ;
  DECLARE @Jus6_JXSPG NVARCHAR(500) ;
  DECLARE @Jus6_JXSPGShow NVARCHAR(500) ;
  DECLARE @Jus6_YY NVARCHAR(500) ;
  DECLARE @Jus6_YYShow NVARCHAR(500) ;
  DECLARE @Jus6_QTXX NVARCHAR(500) ;
  DECLARE @Jus6_XWYQ NVARCHAR(500) ;
  DECLARE @Jus6_XWYQShow NVARCHAR(500) ;
  DECLARE @Jus7_ZZBJ NVARCHAR(500) ;
  DECLARE @Jus7_ZZBJShow NVARCHAR(500) ;
  DECLARE @Jus7_SX NVARCHAR(500) ;
  DECLARE @Jus7_SYLW NVARCHAR(500) ;
  DECLARE @Jus7_SYLWShow NVARCHAR(500) ;
  DECLARE @Jus7_HDMS NVARCHAR(500) ;
  DECLARE @Jus8_YWZBShow NVARCHAR(500) ;
  DECLARE @Jus8_SFFGD NVARCHAR(500) ;
  DECLARE @Jus8_SFFGDShow NVARCHAR(500) ;
  DECLARE @Jus8_FGDFS NVARCHAR(500) ;
  
  SELECT @Jus1_QDJLShow = ISNULL(Jus1_QDJL, ''),
         @Jus3_JXSLX = ISNULL(Jus3_JXSLX, ''),
         @Jus3_DZYY = ISNULL(Jus3_DZYY, ''),
         @Jus4_FWFW = ISNULL(Jus4_FWFW, ''),
         @Jus4_FWFWShow = dbo.Func_GetCode2('CONST_CONTRACT_Jus4_FWFW', A.Jus4_FWFW),
         @Jus4_EWFWFW = ISNULL(Jus4_EWFWFW, ''),
         @Jus4_EWFWFWShow = dbo.Func_GetCode2('CONST_CONTRACT_Jus4_EWFWFW', A.Jus4_EWFWFW),
         @Jus4_YWFW = ISNULL(Jus4_YWFW, ''),
         @Jus4_SQFW = ISNULL(Jus4_SQFW, ''),
         @Jus5_SFCD = ISNULL(Jus5_SFCD, ''),
         @Jus5_SFCDShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus5_SFCD),
         @Jus5_YYSM = ISNULL(Jus5_YYSM, ''),
         @Jus5_JTMS = ISNULL(Jus5_JTMS, ''),
         @Jus6_ZMFS = ISNULL(Jus6_ZMFS, ''),
         @Jus6_ZMFSShow = dbo.Func_GetCode2('CONST_CONTRACT_Jus6_ZMFS', A.Jus6_ZMFS),
         @Jus6_TJR = ISNULL(Jus6_TJR, ''),
         @Jus6_QTFS = ISNULL(Jus6_QTFS, ''),
         @Jus6_JXSPG = ISNULL(Jus6_JXSPG, ''),
         @Jus6_JXSPGShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus6_JXSPG),
         @Jus6_YY = ISNULL(Jus6_YY, ''),
         @Jus6_YYShow = dbo.Func_GetCode('CONST_CONTRACT_Jus6_YY', A.Jus6_YY),
         @Jus6_QTXX = ISNULL(Jus6_QTXX, ''),
         @Jus6_XWYQ = ISNULL(Jus6_XWYQ, ''),
         @Jus6_XWYQShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus6_XWYQ),
         @Jus7_ZZBJ = ISNULL(Jus7_ZZBJ, ''),
         @Jus7_ZZBJShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus7_ZZBJ),
         @Jus7_SX = ISNULL(Jus7_SX, ''),
         @Jus7_SYLW = ISNULL(Jus7_SYLW, ''),
         @Jus7_SYLWShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus7_SYLW),
         @Jus7_HDMS = ISNULL(Jus7_HDMS, ''),
         @Jus8_YWZBShow = dbo.Func_GetCode('CONST_CONTRACT_Jus8_YWZB', A.Jus8_YWZB),
         @Jus8_SFFGD = ISNULL(Jus8_SFFGD, ''),
         @Jus8_SFFGDShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Jus8_SFFGD),
         @Jus8_FGDFS = ISNULL(Jus8_FGDFS, '')
  FROM   [Contract].AppointmentJustification A
  WHERE  A.ContractId = @ContractId;
  
  --PreContract
  DECLARE @Pre1_HTLX NVARCHAR(2000) ;
  DECLARE @Pre4_FBZTK NVARCHAR(2000) ;
  DECLARE @Pre4_FBZTKShow NVARCHAR(2000) ;
  DECLARE @Pre4_ZDLY NVARCHAR(2000) ;
  DECLARE @Pre6_HTJZShow NVARCHAR(2000) ;
  DECLARE @Pre7_SFTZShow NVARCHAR(2000) ;
  DECLARE @Pre9_SHPZShow NVARCHAR(2000) ;
  DECLARE @Pre9_QYSQShow NVARCHAR(2000) ;
  DECLARE @Pre9_JKZSShow NVARCHAR(2000) ;
  
  SELECT @Pre1_HTLX = ISNULL(A.Pre1_HTLX, ''),
         @Pre4_FBZTK = ISNULL(A.Pre4_FBZTK, ''),
         @Pre4_FBZTKShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre4_FBZTK),
         @Pre4_ZDLY = ISNULL(A.Pre4_ZDLY, ''),
         @Pre6_HTJZShow = dbo.Func_GetCode('CONST_CONTRACT_Pre6_HTJZ', A.Pre6_HTJZ),
         @Pre7_SFTZShow = dbo.Func_GetCode('CONST_CONTRACT_Pre7_SFTZ', A.Pre7_SFTZ),
         @Pre9_SHPZShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre9_SHPZ),
         @Pre9_QYSQShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre9_QYSQ),
         @Pre9_JKZSShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Pre9_JKZS)
  FROM   [Contract].PreContractApproval A
  WHERE  A.ContractId = @ContractId; 
  
  --Head
  SET @Rtn += '<h4>������Ϣ(Application Information)</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td colspan="6" style="color: red;">ƽ̨��һ�������̣�����Ӣ�����룡<br />������ԭ��ѡ���¾����̣�ָ�ù�˾֮ǰ�벨�����κ���ʽ�ľ���ҵ��������<br/>(Please fill in English.<br/>  This application is applied to the dealer which hasn''' + 't  entered any business relationship with BSC.)</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td width="13%" class="title">���뵥��(Application No.)</td><td colspan="5">' + @ContractNo + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td width="13%" class="title">����������(Dealer Type)</td><td width="20%">' + @DealerTypeShow + '</td><td width="13%" class="title">��Ʒ��(Product Line)</td><td width="20%">' + @DepIdShow + '</td><td width="13%" class="title">��ͬ����(Sub-BU)</td><td width="21%">' + @SUBDEPIDShow + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">Ա����(Employee Number)</td><td>' + @EId + '</td><td class="title">������(Applicant)</td><td>' + @EName + '</td><td class="title">��������(Request Date)</td><td>' + @RequestDate + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">ָ���������� (Channel BP)</td><td>' + @Jus1_QDJLShow + '</td><td colspan="4">&nbsp;</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">ԭ��(Reason)</td><td colspan="3">' + @REASONShow + '</td>'
  IF @REASON != '1'
  BEGIN
      SET @Rtn += '<td class="title">������(Used  Name)</td><td>' + @FORMERNAMEShow + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
  END
  --Line 6
  IF @REASON = '3'
  BEGIN
      SET @Rtn += '<tr><td class="title">�ϲ����˾����� Merge check dealer </td><td>' + @AssessmentShow + '</td><td class="title">�ϲ����˿�ʼʱ�� Assessment Start Time</td><td colspan="3">' + @AssessmentStart + '</td></tr>'
  END
  --Line 7
  SET @Rtn += '<tr><td class="title">���벿��(Department)</td><td>' + @ApplicantDepShow + '</td><td class="title">�г�����(Marketing Type)</td><td colspan="3">' + @MarketTypeShow + '</td></tr>'
  --Line 8
  SET @Rtn += '<tr><td class="title">IAF</td><td colspan="5">' + dbo.Func_GetAttachmentHtml(@IAF) + '</td></tr>'
  --Line 9
  IF NOT (@DealerType = 'LP' AND @IsDrm = 1)
     AND @DepId IN ('17', '19', '32', '35')
  BEGIN
      SET @Rtn += '<tr><td class="title">RSM</td><td>' + @ReagionRSM + '</td><td colspan="4">&nbsp;</td></tr>'
  END
  
  SET @Rtn += '</table>'
  
  --Candidate
  DECLARE @CompanyName NVARCHAR(200) ;
  DECLARE @CompanyEName NVARCHAR(200) ;
  DECLARE @SAPCode NVARCHAR(200) ;
  DECLARE @Contact NVARCHAR(200) ;
  DECLARE @EMail NVARCHAR(200) ;
  DECLARE @IsEquipmentShow NVARCHAR(200) ;
  DECLARE @OfficeNumber NVARCHAR(200) ;
  DECLARE @Mobile NVARCHAR(200) ;
  DECLARE @DealerMarkShow NVARCHAR(200) ;
  DECLARE @OfficeAddress NVARCHAR(200) ;
  DECLARE @CompanyType NVARCHAR(200) ;
  DECLARE @EstablishedTime NVARCHAR(200) ;
  DECLARE @Capital NVARCHAR(200) ;
  DECLARE @Website NVARCHAR(200) ;
  DECLARE @LPSAPCodeShow NVARCHAR(500) ;
  DECLARE @CompanyID NVARCHAR(200) ;
  
  SELECT @CompanyName = ISNULL(CompanyName, ''),
         @CompanyEName = ISNULL(CompanyEName, ''),
         @SAPCode = ISNULL(SAPCode, ''),
         @Contact = ISNULL(Contact, ''),
         @EMail = ISNULL(EMail, ''),
         @IsEquipmentShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsEquipment),
         @OfficeNumber = ISNULL(OfficeNumber, ''),
         @Mobile = ISNULL(Mobile, ''),
         @DealerMarkShow = dbo.Func_GetCode('CONST_CONTRACT_DealerMark', A.DealerMark),
         @OfficeAddress = ISNULL(OfficeAddress, ''),
         @CompanyType = ISNULL(CompanyType, ''),
         @EstablishedTime = ISNULL(CONVERT(NVARCHAR(10), EstablishedTime, 121), ''),
         @Capital = ISNULL(Capital, ''),
         @Website = ISNULL(Website, ''),
         @LPSAPCodeShow = ISNULL(B.DMA_ChineseName, ''),
         @CompanyID = ISNULL(CompanyID, '')
  FROM   [Contract].AppointmentCandidate A
         LEFT JOIN DealerMaster B
              ON  A.LPSAPCode = B.DMA_SAP_Code
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>�¾����̻�����Ϣ New Dealer Basic Information</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="13%" class="title">��˾�������ƣ�Company Chinese Name��</td><td width="20%">' + @CompanyName + '</td><td width="13%" class="title">��˾Ӣ������(Company EName)</td><td width="20%">' + @CompanyEName + '</td><td width="13%" class="title">SAP Code</td><td width="21%">' + @SAPCode + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">��ϵ��(Contact)</td><td>' + @Contact + '</td><td class="title">�ʼ���ַ(EMail)</td><td>' + @EMail + '</td><td class="title">�Ƿ�Ϊ�豸�����̣�Equipment Dealer��</td><td>' + @IsEquipmentShow + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">�칫�ҵ绰����(Office Number)</td><td>' + @OfficeNumber + '</td><td class="title">�ֻ�����(Mobile)</td><td>' + @Mobile + '</td><td class="title">�����̱��(Dealer Mark)</td><td>' + @DealerMarkShow + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">�칫�ҵ�ַ(Office Address)</td><td colspan="3">' + @OfficeAddress + '</td><td class="title">��ҵ����(Company Type)</td><td>' + @CompanyType + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">��˾��������(Found Date)</td><td>' + @EstablishedTime + '</td><td class="title">��˾ע���ʱ�(Registered Capital)</td><td>' + @Capital + '</td><td class="title">��˾��վ(Company Website)</td><td>' + @Website + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">ѡ��������������Ϊ Boston Scientific �ṩ�ķ������ͺͷ�Χ(Select the service type and scope that the channel partner will provide to Boston Scientific)</td><td colspan="5">' + @Jus4_FWFWShow + '</td></tr>'
  --Line 5
  IF EXISTS (
         SELECT 1
         FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_FWFW, ',') T
         WHERE  T.VAL = '70'
     )
  BEGIN
      SET @Rtn += '<tr><td class="title">��ѡ��������������Ϊ Boston Scientific �ṩ��������������(Please select the type(s) of other services the channel partner will provide to Boston Scientific )</td><td colspan="5">' + @Jus4_EWFWFWShow + '</td></tr>'
  END
  --Line 5
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
      SET @Rtn += '<tr><td class="title">�������������ṩ�ķ���δ�����������������г��������ṩ�÷�������������(If the channel partner is providing a service(s) not listed in the previous two questions, please provide a description of the service(s) being provided.)</td><td colspan="5">' + @Jus4_YWFW + '</td></tr>'
  END
  
  SET @Rtn += '</table>'
  
  --Documents
  DECLARE @IsThreeLicense NVARCHAR(200) ;
  DECLARE @IsThreeLicenseShow NVARCHAR(200) ;
  DECLARE @BA NVARCHAR(1000);
  DECLARE @MA NVARCHAR(1000);
  DECLARE @TA NVARCHAR(1000);
  DECLARE @OA NVARCHAR(1000);
  
  SELECT @IsThreeLicense = IsThreeLicense,
         @IsThreeLicenseShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsThreeLicense),
         @BA = BA,
         @MA = MA,
         @TA = TA,
         @OA = OA
  FROM   [Contract].AppointmentDocuments A
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>֧���ļ�(Support Doc)</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="20%" class="title">�Ƿ���֤��һ(Is the license 3 in 1?)</td><td colspan="2">' + @IsThreeLicenseShow + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">(1)Ӫҵִ��<br/>(�벻Ҫ�����Ƽ������������û��ͨ�����ع��̹������ȼ��顣) (1) business license <br/> ((It must has been passed the annual audit by Chinese Trade Office.))</td><td>' + dbo.Func_GetAttachmentHtml(@BA) + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">(2)ҽ����е��Ӫ���֤<br/>(�벻Ҫ�����Ƽ��������ʿ�ٲ�Ʒ��CFDA�����ҽ����е��Ӫ���֤��Ӫ��Χ�ڡ�) (2)Medical License <br/> (It''' + 's scope must be contained BSC product CFDA code )</td><td>' + dbo.Func_GetAttachmentHtml(@MA) + '</td></tr>'
  --Line 4
  IF @IsThreeLicense != '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">(3)˰��Ǽ�֤<br/>(�벻Ҫ�����Ƽ������������û��ͨ������˰�����ȼ��顣) (3) tax registration certificate <br/> (please do not continue to recommend, if the dealer does not pass the annual inspection of the local tax bureau). )</td><td>' + dbo.Func_GetAttachmentHtml(@TA) + '</td></tr>'
  END
  --Line 5
  IF @IsThreeLicense != '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">(4)��֯��������֤<br/>(�벻Ҫ�����Ƽ������������û��ͨ���������������ල����ȼ��顣) (4) organization code certificate <br/> (please do not continue to recommend, if the dealer does not pass the local quality and technical supervision of the annual inspection. )</td><td>' + dbo.Func_GetAttachmentHtml(@OA) + '</td></tr>'
  END
  
  SET @Rtn += '</table>'
  
  --Competency
  DECLARE @HealthcareShow NVARCHAR(100) ;
  DECLARE @InterShow NVARCHAR(100) ;
  DECLARE @KOLShow NVARCHAR(100) ;
  DECLARE @MNC NVARCHAR(100) ;
  DECLARE @Justification NVARCHAR(500) ;
  
  SELECT @HealthcareShow = dbo.Func_GetCode('CONST_CONTRACT_Competency', A.Healthcare),
         @InterShow = dbo.Func_GetCode('CONST_CONTRACT_Competency', A.Inter),
         @KOLShow = dbo.Func_GetCode('CONST_CONTRACT_Competency', A.KOL),
         @MNC = ISNULL(MNC, ''),
         @Justification = ISNULL(Justification, '')
  FROM   [Contract].AppointmentCompetency A
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>����&�г��ľ������� Sales & market competitive ability</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="13%" class="title">ҽ����ҵ����(����) (Medical industry experience (years))</td><td width="20%">' + @HealthcareShow + '</td><td width="13%" class="title">������ҵ����(����)  Years of in intervention</td><td width="20%">' + @InterShow + '</td><td width="13%" class="title">��Ҫ�ͻ���ϵ(����) Years of relationship with KOL</td><td width="21%">' + @KOLShow + '</td></tr>'
  --Line 2
   SET @Rtn += '<tr><td colspan="2" class="title">��������ҵ����(�����˾����) (Collaborated MNC)</td><td colspan="4">' + @MNC + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td colspan="2" class="title">���������û��ӵ�����ϵ����������ṩ�������ɣ�If the dealer does not have the ability above, please provide other reasons:</td><td colspan="4">' + @Justification + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td colspan="2" class="title">���֪����������������(How was the channel partner identified?)</td><td colspan="4">' + @Jus6_ZMFSShow + '</td></tr>'
  --Line 3
  IF EXISTS (
         SELECT 1
         FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_ZMFS, ',') T
         WHERE  T.VAL = '70'
     )
  BEGIN
      SET @Rtn += '<tr><td colspan="2" class="title">ע���Ƽ�����/�����ʵ�������/������(Identify the name of the referring party and/or related entity.)</td><td colspan="4">' + @Jus6_TJR + '</td></tr>'
  END
  --Line 3
  IF EXISTS (
         SELECT 1
         FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_ZMFS, ',') T
         WHERE  T.VAL = '80'
     )
  BEGIN
      SET @Rtn += '<tr><td colspan="2" class="title">�ṩ���ڡ���������������(Provide a description for "Other".)</td><td colspan="4">' + @Jus6_QTFS + '</td></tr>'
  END
  --Line 3
  SET @Rtn += '<tr><td colspan="2" class="title">�Ƿ����Կ��ṩ�÷����������������������������(Were other channel partners evaluated for the services to be performed?)</td><td colspan="4">' + @Jus6_JXSPGShow + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td colspan="2" class="title">Ϊ��ѡ���������������(Why was this channel partner chosen?)</td><td colspan="4">' + @Jus6_YYShow + '</td></tr>'
  --Line 3
  IF EXISTS (
         SELECT 1
         FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_YY, ',') T
         WHERE  T.VAL = '50'
     )
  BEGIN
      SET @Rtn += '<tr><td colspan="2" class="title">�ṩ���ڡ���������������(Provide a description for "Other".)</td><td colspan="4">' + @Jus6_QTXX + '</td></tr>'
  END
  --Line 3
  SET @Rtn += '<tr><td colspan="2" class="title">�������������� Boston Scientific �Ƿ�����κ������ͻ������� Boston Scientific Code of Conduct ����(If there is any conflict between this channel partner and Boston Scientific? (Please ref.  Boston Scientific Code of Conduct))</td><td colspan="4">' + @Jus6_XWYQShow + '</td></tr>'
  SET @Rtn += '</table>'
  
  --Proposals
  DECLARE @ContractType NVARCHAR(100) ;
  DECLARE @BSC NVARCHAR(100) ;
  DECLARE @Exclusiveness NVARCHAR(100) ;
  DECLARE @AgreementBegin NVARCHAR(100) ;
  DECLARE @AgreementEnd NVARCHAR(100) ;
  DECLARE @ProductShow NVARCHAR(100) ;
  DECLARE @ProductRemark NVARCHAR(2000) ;
  DECLARE @Price NVARCHAR(50) ;
  DECLARE @PriceRemark NVARCHAR(4000) ;
  DECLARE @SpecialSales NVARCHAR(50) ;
  DECLARE @SpecialSalesRemark NVARCHAR(4000) ;
  DECLARE @Hospital NVARCHAR(2000) ;
  DECLARE @Quota NVARCHAR(2000) ;
  DECLARE @QuotaTotal NVARCHAR(20) ;
  DECLARE @QUOTAUSD NVARCHAR(20) ;
  DECLARE @AllProductAOP NVARCHAR(20) ;
  DECLARE @AllProductAopUSD NVARCHAR(20) ;
  DECLARE @Payment NVARCHAR(200) ;
  DECLARE @PaymentShow NVARCHAR(200) ;
  DECLARE @PayTerm NVARCHAR(200) ;
  DECLARE @CreditTerm NVARCHAR(200) ;
  DECLARE @CreditLimit NVARCHAR(200) ;
  DECLARE @IsDeposit NVARCHAR(200) ;
  DECLARE @IsDepositShow NVARCHAR(200) ;
  DECLARE @Deposit NVARCHAR(200) ;
  DECLARE @Inform NVARCHAR(200) ;
  DECLARE @InformShow NVARCHAR(200) ;
  DECLARE @InformOther NVARCHAR(200) ;
  DECLARE @Comment NVARCHAR(200) ;
  DECLARE @DealerLessHosQ NVARCHAR(20) ;
  DECLARE @DealerLessHosReason NVARCHAR(200) ;
  DECLARE @DealerLessHosReasonQ NVARCHAR(200) ;
  DECLARE @DealerLessHosQRemark NVARCHAR(1000) ;
  DECLARE @HosLessStandardQ NVARCHAR(1000) ;
  DECLARE @HosLessStandardReason NVARCHAR(200) ;
  DECLARE @HosLessStandardReasonQ NVARCHAR(200) ;
  DECLARE @HosLessStandardQRemark NVARCHAR(1000) ;
  DECLARE @Attachment NVARCHAR(1000) ;
  DECLARE @ISVAT NVARCHAR(200) ;
  DECLARE @ProductGroupCheck NVARCHAR(200) ;
  DECLARE @ProductGroupRemark NVARCHAR(2000) ;
  DECLARE @ProductGroupMemo NVARCHAR(2000) ;
  DECLARE @IsCorssBu NVARCHAR(20) ;
  DECLARE @CorssBuMemo NVARCHAR(2000) ;
  
  SELECT @ContractType = ISNULL(ContractType, ''),
         @BSC = ISNULL(BSC, ''),
         @Exclusiveness = ISNULL(Exclusiveness, ''),
         @AgreementBegin = ISNULL(CONVERT(NVARCHAR(10), AgreementBegin, 121), ''),
         @AgreementEnd = ISNULL(CONVERT(NVARCHAR(10), AgreementEnd, 121), ''),
         @ProductShow = dbo.Func_GetCode('CONST_CONTRACT_ProposalsProduct', A.Product),
         @ProductRemark = ISNULL(ProductRemark, ''),
         @Price = ISNULL(Price, ''),
         @PriceRemark = ISNULL(PriceRemark, ''),
         @SpecialSales = ISNULL(SpecialSales, ''),
         @SpecialSalesRemark = ISNULL(SpecialSalesRemark, ''),
         @Hospital = SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)),
         @Quota = SUBSTRING(Quota, 0, CHARINDEX('<', Quota)),
         @QuotaTotal = ISNULL(CONVERT(NVARCHAR(20), QuotaTotal), ''),
         @QUOTAUSD = ISNULL(CONVERT(NVARCHAR(20), QUOTAUSD), ''),
         @AllProductAOP = ISNULL(CONVERT(NVARCHAR(20), AllProductAOP), ''),
         @AllProductAopUSD = ISNULL(CONVERT(NVARCHAR(20), AllProductAopUSD), ''),
         @Payment = ISNULL(Payment, ''),
         @PaymentShow = dbo.Func_GetCode('CONST_CONTRACT_Payment', A.Payment),
         @PayTerm = ISNULL(PayTerm, ''),
         @CreditTerm = dbo.Func_GetCode('CONST_CONTRACT_CreditTerm', A.CreditTerm),
         @CreditLimit = ISNULL(CreditLimit, ''),
         @IsDeposit = IsDeposit,
         @IsDepositShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsDeposit),
         @Deposit = ISNULL(Deposit, ''),
         @Inform = ISNULL(Inform, ''),
         @InformShow = dbo.Func_GetCode2('CONST_CONTRACT_Inform', A.Inform),
         @InformOther = ISNULL(InformOther, ''),
         @Comment = ISNULL(Comment, ''),
         @DealerLessHosQ = ISNULL(DealerLessHosQ, ''),
         @DealerLessHosReason = ISNULL(DealerLessHosReason, ''),
         @DealerLessHosReasonQ = ISNULL(DealerLessHosReasonQ, ''),
         @DealerLessHosQRemark = ISNULL(DealerLessHosQRemark, ''),
         @HosLessStandardQ = ISNULL(HosLessStandardQ, ''),
         @HosLessStandardReason = ISNULL(HosLessStandardReason, ''),
         @HosLessStandardReasonQ = ISNULL(HosLessStandardReasonQ, ''),
         @HosLessStandardQRemark = ISNULL(HosLessStandardQRemark, ''),
         @Attachment = ISNULL(Attachment, ''),
         @ISVAT = ISNULL(ISVAT, ''),
         @ProductGroupCheck = ISNULL(ProductGroupCheck, ''),
         @ProductGroupRemark = ISNULL(ProductGroupRemark, ''),
         @ProductGroupMemo = ISNULL(ProductGroupMemo, ''),
         @IsCorssBu = ISNULL(IsCorssBu, ''),
         @CorssBuMemo = ISNULL(CorssBuMemo, '')
  FROM   [Contract].AppointmentProposals A
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>������ҵ��ƻ��� Preliminary business plan</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td class="title" width="25%">�������� Cooperation type</td><td width="25%">' + @ContractType + '</td><td class="title" width="25%">��ͬʵ�� Contractual entity</td><td width="25%">' + @BSC + '</td></tr>'
  --Line 1
  SET @Rtn += '<tr><td class="title">���Һ�ͬ Exclusive contract</td><td colspan="3">' + @Exclusiveness + '</td></tr>';
  --Line 1
  SET @Rtn += '<tr><td class="title">��������Ŀǰ�Ƿ�ֱ�Ӿ��� BSC ���۲�������һ����������ִ�У�(Are the above services being excuted internally or another channel partner?)</td><td>' + @Jus5_SFCDShow + '</td>'
  IF @Jus5_SFCD = '1'
  BEGIN
      SET @Rtn += '<td class="title">����Ϊ����Ҫ���ӻ������а��š�(Explain the reason for change)</td><td>' + @Jus5_YYSM + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
  END
  --Line 2
  SET @Rtn += '<tr><td class="title">����ͨ����Ӷ���Ƽ����������������������ҵ�����󡣣�Describe the business requestments that will be fulfilled by this channel partner)</td><td colspan="3">' + @Jus5_JTMS + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">Э������(Э����Ч��) ��Effective Date��</td><td>' + @AgreementBegin + '</td><td class="title">Э������(Э�鵽����) ��Expiration Date��</td><td>' + @AgreementEnd + '</td></tr>'
  --PreContract
  SET @Rtn += '<tr><td class="title">��Э���Ƿ�����Ǳ�׼��ͬ�����������ֹ����ֹ֪ͨ���ޣ�ͨ��Ϊ 60 �죩���ع���棩�� (Does the agreement contain non-standard contract provisions (end without reason,non-standard termination notification,inventory buyback))</td><td>' + @Pre4_FBZTKShow + '</td>'
  IF @Pre4_FBZTK = '1'
  BEGIN
      SET @Rtn += '<td class="title">���ṩ�Ǳ�׼������������ɡ�(Provide justification for the non-standard terms.��</td><td>' + @Pre4_ZDLY + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
  END
  --Line 3
  SET @Rtn += '<tr><td class="title">��Ʒ��(Product Line)</td><td>' + @ProductShow + '</td><td class="title">(����ǲ��ֲ�Ʒ�ߣ����г�)(if partial, please list)</td><td>' + @ProductRemark + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">�۸�<br/>��׼�۸��_%���ۿ�(Pricing Discount _% off standard price list)</td><td>' + @Price + '</td><td class="title">��ע��Remark��</td><td>' + @PriceRemark + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">���۷�������<br/>���Ȳɹ��ܶ��_% (Sales Rebate _% of the quarter purchase AMT)</td><td>' + @SpecialSales + '</td><td class="title">��ע��Remark��</td><td>' + @SpecialSalesRemark + '</td></tr>'
  --Line 6
  DECLARE @HospitalUrl NVARCHAR(1000)
  SET @HospitalUrl = '';
  SET @HospitalUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?ContractType=Appointment';
  SET @HospitalUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
  SET @HospitalUrl += '&DivisionID=' + @DepId;
  SET @HospitalUrl += '&PartsContractCode=' + @SUBDEPID;
  SET @HospitalUrl += '&TempDealerID=' + @CompanyID;
  SET @HospitalUrl += '&DealerType=' + @DealerType;
  SET @HospitalUrl += '&EffectiveDate=' + @AgreementBegin;
  SET @HospitalUrl += '&ExpirationDate=' + @AgreementEnd;
  SET @HospitalUrl += '&IsEmerging=' + @MarketType;
  SET @HospitalUrl += '&IsArea=' + @IsLP;
  SET @HospitalUrl += '&ProductAmend=1';
  SET @HospitalUrl += '&NeedAuth=True';
  SET @HospitalUrl += '&PageId=2';
  
  DECLARE @QuotaUrl NVARCHAR(1000)
  SET @QuotaUrl = '';
  SET @QuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?ContractType=Appointment';
  SET @QuotaUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
  SET @QuotaUrl += '&DivisionID=' + @DepId;
  SET @QuotaUrl += '&PartsContractCode=' + @SUBDEPID;
  SET @QuotaUrl += '&TempDealerID=' + @CompanyID;
  SET @QuotaUrl += '&DealerType=' + @DealerType;
  SET @QuotaUrl += '&EffectiveDate=' + @AgreementBegin;
  SET @QuotaUrl += '&ExpirationDate=' + @AgreementEnd;
  SET @QuotaUrl += '&IsEmerging=' + @MarketType;
  SET @QuotaUrl += '&AOPType=' + @AOPTYPE;
  SET @QuotaUrl += '&NeedAuth=True';
  SET @QuotaUrl += '&PageId=4';
  
  DECLARE @AuthUrl NVARCHAR(1000);
  SET @AuthUrl = '';
  SET @AuthUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/AuthList.aspx?ContractId=' + CONVERT(NVARCHAR(100), @ContractId);
  SET @AuthUrl += '&SUBDEPID=' + @SUBDEPID;
  SET @AuthUrl += '&IsLP=' + @IsLP;
  SET @AuthUrl += '&AgreementBegin=' + @AgreementBegin;
  
  SET @Rtn += '<tr><td class="title">����(ҽԺ)Territory (Hospital)</td><td>' + @Hospital + '&nbsp;<a href="' + @HospitalUrl + '" target="_blank">�鿴(See)</a><br/><a href="' + @AuthUrl + '" target="_blank"><h4>��Ȩ��ϸ�б�</h4></a></td><td class="title">�ɹ�ָ��(CNY)<br/>(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>' + @Quota + '&nbsp;<a href="' + @QuotaUrl + '" target="_blank">�鿴</a></td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">������������Щ����/����ִ�У�(list the territory (hospital) which will be excuted.)</td><td colspan="3">' + @Jus4_SQFW + '</td></tr>'
  --Line 7
  SET @Rtn += '<tr><td class="title">ָ���ܶ�(CNY)����˰ Quota Total (CNY Without VAT)</td><td>' + @QuotaTotal + '</td><td class="title">ָ���ܶ�(USD)����˰ Quota Total(USD Without VAT)</td><td>' + @QUOTAUSD + '</td></tr>'
  
  --PreContract
  SET @Rtn += '<tr><td colspan="4" style="margin: 10px !important; padding: 10px !important;"><table class="gridtable">';
  SET @Rtn += '<tr><td class="title" width="14%">��� (Year)</td><td class="title" width="14%">��һ����(Q1)</td><td class="title" width="14%">�ڶ�����(Q2)</td><td class="title" width="14%">��������(Q3)</td><td class="title" width="14%">���ļ���(Q4)</td><td class="title" width="14%">�ϼ�(Total)</td><td class="title" width="16%">% ����һ������۶� (% vs Actual purchase of LY )</td></tr>';
  
  DECLARE @Pre5_NF NVARCHAR(2000) ;
  DECLARE @Pre5_Q1 NVARCHAR(2000) ;
  DECLARE @Pre5_Q2 NVARCHAR(2000) ;
  DECLARE @Pre5_Q3 NVARCHAR(2000) ;
  DECLARE @Pre5_Q4 NVARCHAR(2000) ;
  DECLARE @Pre5_HJ NVARCHAR(2000) ;
  DECLARE @Pre5_DB NVARCHAR(2000) ;
  
  DECLARE CUR_QUOTA CURSOR  
  FOR
      SELECT Pre5_NF,
             Pre5_Q1,
             Pre5_Q2,
             Pre5_Q3,
             Pre5_Q4,
             Pre5_HJ,
             Pre5_DB
      FROM   [Contract].PreContractQuota
      WHERE  ContractId = @ContractId
      ORDER BY SortNo
  
  OPEN CUR_QUOTA
  FETCH NEXT FROM CUR_QUOTA INTO @Pre5_NF, @Pre5_Q1, @Pre5_Q2, @Pre5_Q3, @Pre5_Q4, @Pre5_HJ, @Pre5_DB
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @Rtn += '<tr><td>' + @Pre5_NF + '</td><td>' + @Pre5_Q1 + '</td><td>' + @Pre5_Q2 + '</td><td>' + @Pre5_Q3 + '</td><td>' + @Pre5_Q4 + '</td><td>' + @Pre5_HJ + '</td><td>' + @Pre5_DB + '</td></tr>';
      FETCH NEXT FROM CUR_QUOTA INTO @Pre5_NF, @Pre5_Q1, @Pre5_Q2, @Pre5_Q3, @Pre5_Q4, @Pre5_HJ, @Pre5_DB
  END
  CLOSE CUR_QUOTA
  DEALLOCATE CUR_QUOTA
  
  SET @Rtn += '</table></td></tr>'
  
  --PreContract
  --SET @Rtn += '<tr><td class="title" width="20%">���ⶨ����Ⱥ�ͬ��ֵ�Ƕ��٣�</td><td colspan="3">' + @Pre6_HTJZShow + '</td></tr>'
  --PreContract
  SET @Rtn += '<tr><td class="title">������������Ϊ Boston Scientific �ṩ��ֻһ����񣬻����Ƿ����ݷ����������Ե����� (If the channel partner''' + 's reward will be changed with service type changing?)</td><td colspan="3">' + @Pre7_SFTZShow + '</td></tr>'
  
  --PreContract
  SET @Rtn += '<tr><td colspan="4" style="margin: 10px !important; padding: 10px !important;"><table class="gridtable">';
  SET @Rtn += '<tr><td class="title" width="33%">�������� (Service Type)</td><td class="title" width="33%">������/��(Profit(Yes/no))</td><td class="title" width="34%">���ṩ������Χ(<10%, 10-20%, >20%)  (Range (<10%,10-20%, >20%))</td></tr>';
  
  DECLARE @Pre7_FWLX NVARCHAR(2000) ;
  DECLARE @Pre7_LR NVARCHAR(2000) ;
  DECLARE @Pre7_LRFW NVARCHAR(2000) ;
  
  DECLARE CUR_SERVICE CURSOR  
  FOR
      SELECT Pre7_FWLX,
             Pre7_LR,
             Pre7_LRFW
      FROM   [Contract].PreContractService
      WHERE  ContractId = @ContractId
      ORDER BY SortNo
  
  OPEN CUR_SERVICE
  FETCH NEXT FROM CUR_SERVICE INTO @Pre7_FWLX, @Pre7_LR, @Pre7_LRFW
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @Rtn += '<tr><td>' + @Pre7_FWLX + '</td><td>' + @Pre7_LR + '</td><td>' + @Pre7_LRFW + '</td></tr>';
      FETCH NEXT FROM CUR_SERVICE INTO @Pre7_FWLX, @Pre7_LR, @Pre7_LRFW
  END
  CLOSE CUR_SERVICE
  DEALLOCATE CUR_SERVICE
  
  SET @Rtn += '</table></td></tr>'
  
  --Line 8
  SET @Rtn += '<tr><td class="title">���ʽ Payment</td><td colspan="3">' + @PaymentShow + '</td></tr>'
  --PreContract
  IF @Payment = 'LC'
  BEGIN
      SET @Rtn += '<tr><td class="title">Ӧ�ڶ���������ɸ��(Payable within how many days?)</td><td colspan="3">' + @PayTerm + '</td></tr>'
  END
  --PreContract
  SET @Rtn += '<tr><td class="title" >�Ƿ��е����� (Is there a security amount?)</td><td colspan="3" >' + @IsDepositShow + '</td></tr>'
  --Line 9
  IF @Payment = 'Credit'
  BEGIN
      SET @Rtn += '<tr><td class="title">��������(����)(credit terms��Day)</td><td>' + @CreditTerm + '</td><td class="title">���ö��(CNY, ����ֵ˰)(Credit Limit) </td><td>' + @CreditLimit + '</td></tr>'
  END
  --Line 10
  IF @IsDeposit = '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">��֤��(CNY) Deposit</td><td>' + @Deposit + '</td><td class="title">��֤����ʽ Deposit Type</td><td>' + @InformShow + '</td></tr>'
  END
  --Line 11
  IF @IsDeposit = '1'
     AND EXISTS (
             SELECT 1
             FROM   dbo.GC_Fn_SplitStringToTable(@Inform, ',') T
             WHERE  T.VAL = 'Others'
         )
  BEGIN
      SET @Rtn += '<tr><td class="title">��֤����ʽ��ע  Deposit Type Remark</td><td colspan="3">' + @InformOther + '</td></tr></tr>'
  END
  --Line 12
  SET @Rtn += '<tr><td class="title">���ע Payment Remark</td><td colspan="3">' + @Comment + '</td></tr>'
  SET @Rtn += '<tr><td class="title">�������ܼƲɹ�ָ��С���ܼ�ҽԺָ���ԭ�� Reason for total dealer commercial purchase target less than total hospital target</td><td>' + @DealerLessHosReason 
  --Line 14
  IF @DealerLessHosQ = '0'
  BEGIN
      SET @Rtn +=  + @DealerLessHosQRemark + '</td>'
  END
  else 
	begin
	   SET @Rtn +='</td>'
	   end
  --Line 15
  SET @Rtn += '<td class="title">�����̼���ָ��С��ҽԺ����ָ���ԭ�� (Reason for Dealer quarterly commercial purchase target less than hospital quarterly target)</td><td>' + @DealerLessHosReasonQ + '</td></tr>'
  --Line 16
  
  
  SET @Rtn += '<tr><td class="title" width="25%">�ܼ�ҽԺʵ��ָ��С���ܼ�ҽԺ��׼ָ���ԭ�� (Reason for total actual hospital target less than total standard hospital target)</td><td>' + @HosLessStandardReason  
  --Line 17
  IF @HosLessStandardQ = '0'
  BEGIN
      SET @Rtn += + @HosLessStandardQRemark + '</td>'
  END
  else 
	begin
	   SET @Rtn +='</td>'
	   end
  --Line 18
  SET @Rtn += '<td class="title" width="25%">ҽԺʵ�ʼ���ָ��С��ҽԺ��׼����ָ���ԭ�� ��Reason for quarterly actual hospital target less than quarterly standard hospital target��</td><td>' + @HosLessStandardReasonQ 
  --Line 10
  
  IF @ProductGroupCheck = '0'
  BEGIN
      SET @Rtn +=  + @ProductGroupRemark + '</td></tr>'
  END
  else 
	begin
	   SET @Rtn +='</td></tr>'
	   end
  --Line 2
  SET @Rtn += '<tr><td class="title" width="25%">��Ʒ����Сָ�걸ע Product group minimal target remark</td><td >' + @ProductGroupMemo 
  --Line 2
  IF @IsCorssBu = '0'
  BEGIN
    
      SET @Rtn += '</br>��ѡ���BU�����̱�ע Do not choose to cross BU dealer remark</br>' + @CorssBuMemo + '</td>'
  END
  else 
	begin
	   SET @Rtn +='</td>'
	   end
  --Line 2
  SET @Rtn += '<td class="title" width="25%">����������������Ĺ��ң�����Ϊ Boston Scientific �ĵ�Լ�����������г���(What portion of the Boston Scientific Contracting Party''' + 's business will be driven by the channel partner in the country where the channel partner is performing services?)</td><td >' + @Jus8_YWZBShow + '</td></tr>'
  ---Line 1
  SET @Rtn += '<tr><td class="title" width="25%">�����������Ƿ���Ҫ��ǳ���ĸ�����������Ԥ�������������˻�����������ͬʵ�塢���������������������ڹ��ң���(Is the channel partner requesting non-routine payment terms (e.g.,advance payments, payments to multiple accounts, payments to a different entity, payments to a country other than where the channel partner is located)?)</td><td>' + @Jus8_SFFGDShow + '</td>'
  IF @Jus8_SFFGD = '1'
  BEGIN
      SET @Rtn += '<td class="title" width="25%">�г��ǳ���ĸ������� (List the non-routine payment terms.)</td><td>' + @Jus8_FGDFS + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
  END
  --Line 19
  SET @Rtn += '<tr><td class="title" width="25%">����(Attachement)</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@Attachment) + '</td></tr>'
  
  SET @Rtn += '</table>'
  
  --Other
  
  --Head
  SET @Rtn += '<h4>����(Other)</h4><table class="gridtable">'
  --Line 1
   SET @Rtn += '<tr><td class="title" width="25%">����������������������Ƿ���������Ա������(Dose the channel partner contact with foreign officials?)</td><td>' + @Jus7_ZZBJShow 
  --Line 2
  IF @Jus7_ZZBJ = '1'
  BEGIN
      SET @Rtn += '</br>�����˵Ƚ������ʡ�(Describe the nature of these interactions.)</br>' + @Jus7_SX + '</td>'
      
  END
  else
   begin
      set @Rtn+='</td>'
  --Line 3
  end
  SET @Rtn += '<td class="title" width="25%">�����������Ƿ����� Boston Scientific ����������������������Ӧ�̡�������̡������磩������(Dose the channel partner behalf BSC to contact with other 3rd. Part? (e.g.logistics supplier, events service provider, travel agency.))</td><td>' + @Jus7_SYLWShow 
  --Line 4
  IF @Jus7_SYLW = '1'
  BEGIN
      SET @Rtn += '</br>�����˵Ƚ������ʡ�(Describe the nature of these interactions.)</br>' + @Jus7_HDMS + '</td></tr>'
  END
   else
   begin
   set @Rtn+='</td></tr>'
   end
  --PreContract
  SET @Rtn += '<tr><td class="title"width="25%" >�������������ǩ����Э���Ƿ���Ҫ������˺���׼���羭���һ��ع�֤����(Whether the agreement need to be approved by related organization? (such as government offices))</td><td>' + @Pre9_SHPZShow + '</td><td class="title">�������������ǩ����Э���Ƿ���Ҫ����ǩԼ��Ȩ�� (Does an agreement with this channel partner require certification of appointment?)</td><td>' + @Pre9_QYSQShow + '</td></tr>'
  --PreContract
  
  --PreContract
  SET @Rtn += '<tr><td class="title">�������������ǩ����Э���Ƿ���Ҫ����֤�飿 (Whether the agreement needs import license?)</td><td colspan="3">' + @Pre9_JKZSShow + '</td></tr>'
  
  SET @Rtn += '</table>'
 
  
  --��BU������
  DECLARE @DealerCode NVARCHAR(500) ;
  DECLARE @DealerName NVARCHAR(500) ;
  DECLARE @BUName NVARCHAR(500) ;
  DECLARE @SubBUName NVARCHAR(500) ;
  DECLARE @HospitalCode NVARCHAR(500) ;
  DECLARE @HospitalName NVARCHAR(500) ;
  DECLARE @KpiScore NVARCHAR(500) ;
  
  DECLARE CUR_CROSS_BU CURSOR  
  FOR
      SELECT DISTINCT ISNULL(F.DMA_SAP_Code, '') SAPCode,
             ISNULL(F.DMA_ChineseName, '') DealerName,
             ISNULL(G.CC_DivisionName, '') BUName,
             ISNULL(G.CC_NameCN, '') SubBUName,
             ISNULL(E.HOS_Key_Account, '') HospitalCode,
             ISNULL(E.HOS_HospitalName, '') HospitalName,
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
                                ORDER BY TT.Column1 DESC, TT.Column2 DESC
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
                     WHERE  A.DAT_DCL_ID = @ContractId
                            AND D.HLA_HOS_ID = B.HOS_ID
                            AND M.CC_Code = H.SubDepId
                 )
      ORDER BY ISNULL(E.HOS_Key_Account, ''), ISNULL(F.DMA_SAP_Code, '')
  
  --Head
  SET @Rtn += '<h4>��BU������ Cross BU dealer</h4><table class="gridtable">'
  SET @Rtn += '<tr><td class="title" width="10%">ҽԺ��� (Hospital Number)</td><td class="title" width="25%">ҽԺ���� (Hospital Name)</td><td class="title" width="10%">�����̱��(Dealer Number)</td><td class="title" width="25%">����������(Dealer Name)</td><td class="title" width="10%">BU</td><td class="title" width="10%">SubBU</td><td class="title" width="10%">��������(KpiScore)</td></tr>'
  
  OPEN CUR_CROSS_BU
  FETCH NEXT FROM CUR_CROSS_BU INTO @DealerCode,@DealerName,@BUName,@SubBUName,@HospitalCode,@HospitalName,@KpiScore
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @Rtn += '<tr><td>' + @HospitalCode + '</td><td>' + @HospitalName + '</td><td>' + @DealerCode + '</td><td>' + @DealerName + '</td><td>' + @BUName + '</td><td>' + @SubBUName + '</td><td>' + @KpiScore + '</td></tr>'
      
      FETCH NEXT FROM CUR_CROSS_BU INTO @DealerCode,@DealerName,@BUName,@SubBUName,@HospitalCode,@HospitalName,@KpiScore
  END
  CLOSE CUR_CROSS_BU
  DEALLOCATE CUR_CROSS_BU
  
  SET @Rtn += '</table>'
  
  --ͬ��������
  DECLARE @SameDealerName NVARCHAR(500) ;
  DECLARE @SameMarketType NVARCHAR(500) ;
  DECLARE @SameProductLine NVARCHAR(500) ;
  DECLARE @SameLpName NVARCHAR(500) ;
  
  DECLARE CUR_SAME CURSOR  
  FOR
      SELECT distinct A.DMA_SAP_Code + ' - ' + A.DMA_ChineseName DealerName,
             dbo.Func_GetCode('CONST_CONTRACT_MarketType', B.MarketType) MarketType,
             D.DepFullName ProductLine,
             C.DMA_SAP_Code + ' - ' + C.DMA_ChineseName LpName
      FROM   DealerMaster A
             INNER JOIN V_DealerContractMaster B
                  ON  A.DMA_ID = B.DMA_ID
             INNER JOIN DealerMaster C
                  ON  A.DMA_Parent_DMA_ID = C.DMA_ID
             INNER JOIN interface.mdm_department D
                  ON  B.Division = D.DepID
      WHERE  A.DMA_ChineseName LIKE SUBSTRING(@CompanyName, 1, 8) + '%'
  
  --Head
  SET @Rtn += '<h4>ͬ�������� (Same Dealer Name)</h4><table class="gridtable">'
  SET @Rtn += '<tr><td class="title" width="25%">������(Dealer)</td><td class="title" width="25%">�����г� (Same Market Type)</td><td class="title" width="25%">��Ʒ�� (Product Line)</td><td class="title" width="25%">����ƽ̨(Same Lp Name)</td></tr>'
  
  OPEN CUR_SAME
  FETCH NEXT FROM CUR_SAME INTO @SameDealerName,@SameMarketType,@SameProductLine,@SameLpName
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @Rtn += '<tr><td>' + @SameDealerName + '</td><td>' + @SameMarketType + '</td><td>' + @SameProductLine + '</td><td>' + @SameLpName + '</td></tr>'
      
      FETCH NEXT FROM CUR_SAME INTO @SameDealerName,@SameMarketType,@SameProductLine,@SameLpName
  END
  CLOSE CUR_SAME
  DEALLOCATE CUR_SAME
  
  SET @Rtn += '</table>'
  
  --������������
  IF @REASON IN ('2', '3', '4')
  BEGIN
      DECLARE @RelateReason NVARCHAR(500) ;
      DECLARE @RelateRefSAPID NVARCHAR(500) ;
      DECLARE @RelateRefDealerName NVARCHAR(500) ;
      
      DECLARE CUR_RELATE CURSOR  
      FOR
          SELECT ISNULL(A.Column1, '') Reason,
                 ISNULL(A.Column2, '') RefSAPID,
                 ISNULL(A.Column3, '') RefDealerName
          FROM   DP.DealerMaster A,
                 dbo.DealerMaster B
          WHERE  A.DealerId = B.DMA_ID
                 AND A.ModleID = '00000001-0001-0007-0000-000000000000'
                 AND B.DMA_SAP_Code = @FORMERNAME
      
      --Head
      SET @Rtn += '<h4>������������ Former Name Dealer</h4><table class="gridtable">'
      SET @Rtn += '<tr><td class="title" width="33%">ԭ�� Reason</td><td class="title" width="33%">���������̱�� RelateRefSAPID </td><td class="title" width="34%">�������������� RelateRefDealerName</td></tr>'
      
      OPEN CUR_RELATE
      FETCH NEXT FROM CUR_RELATE INTO @RelateReason,@RelateRefSAPID,@RelateRefDealerName
      
      WHILE @@FETCH_STATUS = 0
      BEGIN
          SET @Rtn += '<tr><td>' + @RelateReason + '</td><td>' + @RelateRefSAPID + '</td><td>' + @RelateRefDealerName + '</td></tr>'
          
          FETCH NEXT FROM CUR_RELATE INTO @RelateReason,@RelateRefSAPID,@RelateRefDealerName
      END
      CLOSE CUR_RELATE
      DEALLOCATE CUR_RELATE
      
      SET @Rtn += '</table>'
  END
  
  --�ϲ����˾�����
  IF @REASON IN ('3')
  BEGIN
      DECLARE @AssessmentBiType NVARCHAR(500) ;
      DECLARE @AssessmentBiYear NVARCHAR(500) ;
      DECLARE @AssessmentBiQFrom NVARCHAR(500) ;
      DECLARE @AssessmentBiQTo NVARCHAR(500) ;
      DECLARE @AssessmentBiDivision NVARCHAR(500) ;
      DECLARE @AssessmentBiSubBu NVARCHAR(500) ;
      DECLARE @AssessmentBiCode NVARCHAR(500) ;
      DECLARE @AssessmentBiName NVARCHAR(500) ;
      DECLARE @AssessmentBiRemark NVARCHAR(500) ;
      DECLARE @AssessmentBiMarketType NVARCHAR(500) ;
      
      DECLARE CUR_Assessment CURSOR  
      FOR
          SELECT ISNULL(A.Column1, '') BiType,
                 ISNULL(A.Column2, '') BiYear,
                 ISNULL(A.Column3, '') BiQFrom,
                 ISNULL(A.Column4, '') BiQTo,
                 ISNULL(A.Column5, '') BiDivision,
                 ISNULL(A.Column6, '') BiSubBu,
                 ISNULL(A.Column7, '') BiCode,
                 ISNULL(A.Column8, '') BiName,
                 ISNULL(A.Column9, '') BiRemark,
                 ISNULL(A.Column10, '') BiMarketType
          FROM   DP.DealerMaster A,
                 dbo.DealerMaster B
          WHERE  A.DealerId = B.DMA_ID
                 AND A.ModleID = '00000001-0001-0008-0000-000000000000'
                 AND B.DMA_SAP_Code = @Assessment
      
      --Head
      SET @Rtn += '<h4>�ϲ����˾����� Merged Assessment Dealer</h4><table class="gridtable">'
      SET @Rtn += '<tr><td class="title" width="10%">���� Type</td><td class="title" width="10%">��� Year</td><td class="title" width="10%">��ʼ���� Start Quarter</td><td class="title" width="10%">�������� End Quarter</td><td class="title" width="10%">Division</td><td class="title" width="10%">SubBU</td><td class="title" width="10%">�����̱�� (Dealer Number)</td><td class="title" width="10%">���������� (Dealer Name)</td><td class="title" width="10%">��ע ��Remark��</td><td class="title" width="10%">������ Red and blue </td></tr>'
      
      OPEN CUR_Assessment
      FETCH NEXT FROM CUR_Assessment INTO @AssessmentBiType,@AssessmentBiYear,@AssessmentBiQFrom,@AssessmentBiQTo,@AssessmentBiDivision,@AssessmentBiSubBu,@AssessmentBiCode,@AssessmentBiName,@AssessmentBiRemark,@AssessmentBiMarketType
      
      WHILE @@FETCH_STATUS = 0
      BEGIN
          SET @Rtn += '<tr><td>' + @AssessmentBiType + '</td><td>' + @AssessmentBiYear + '</td><td>' + @AssessmentBiQFrom + '</td><td>' + @AssessmentBiQTo + '</td><td>' + @AssessmentBiDivision + '</td><td>' + @AssessmentBiSubBu + '</td><td>' + @AssessmentBiCode + '</td><td>' + @AssessmentBiName + '</td><td>' + @AssessmentBiRemark + '</td><td>' + @AssessmentBiMarketType + '</td></tr>'
          
          FETCH NEXT FROM CUR_Assessment INTO @AssessmentBiType,@AssessmentBiYear,@AssessmentBiQFrom,@AssessmentBiQTo,@AssessmentBiDivision,@AssessmentBiSubBu,@AssessmentBiCode,@AssessmentBiName,@AssessmentBiRemark,@AssessmentBiMarketType
      END
      CLOSE CUR_Assessment
      DEALLOCATE CUR_Assessment
      
      SET @Rtn += '</table>'
  END
  
  --CFDA��Ʒ����
  DECLARE @GM_KIND NVARCHAR(500) ;
  DECLARE @GM_CATALOG NVARCHAR(500) ;
  DECLARE @CatagoryName NVARCHAR(500) ;
  
  DECLARE CUR_CFDA CURSOR  
  FOR
      SELECT DISTINCT A.GM_KIND,
             A.GM_CATALOG,
             A.CatagoryName
      FROM   V_SubBU_CFDACatalog A,
             interface.ClassificationAuthorization B
      WHERE  A.CA_ID = B.CA_ID
             AND B.CA_ParentCode = @SUBDEPID
  
  --Head
  SET @Rtn += '<h4>CFDA��Ʒ���� CFDA Product Category</h4><table class="gridtable">'
  SET @Rtn += '<tr><td class="title" width="33%">���(level 1)</td><td class="title" width="33%">�������(level 2)</td><td class="title" width="34%">��������(Product Name)</td></tr>'
  
  OPEN CUR_CFDA
  FETCH NEXT FROM CUR_CFDA INTO @GM_KIND,@GM_CATALOG,@CatagoryName
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @Rtn += '<tr><td>' + @GM_KIND + '</td><td>' + @GM_CATALOG + '</td><td>' + @CatagoryName + '</td></tr>'
      
      FETCH NEXT FROM CUR_CFDA INTO @GM_KIND,@GM_CATALOG,@CatagoryName
  END
  CLOSE CUR_CFDA
  DEALLOCATE CUR_CFDA
  
  SET @Rtn += '</table>'
  /*
  DECLARE @AuthUrl NVARCHAR(1000);
  SET @AuthUrl = '';
  SET @AuthUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/AuthList.aspx?ContractId=' + CONVERT(NVARCHAR(100), @ContractId);
  SET @AuthUrl += '&SUBDEPID=' + @SUBDEPID;
  SET @AuthUrl += '&IsLP=' + @IsLP;
  SET @AuthUrl += '&AgreementBegin=' + @AgreementBegin;
  
  SET @Rtn += '<a href="' + @AuthUrl + '" target="_blank"><h4>��Ȩ��ϸ�б�</h4></a>'
  */
  RETURN ISNULL(@Rtn, '')
  
end

GO


