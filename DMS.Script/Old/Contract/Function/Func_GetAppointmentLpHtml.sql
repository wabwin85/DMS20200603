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
  
  --是否DRM用户，是则隐藏RSM选项 2016-11-09
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
  SET @Rtn += '<h4>申请信息(Application Information)</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td colspan="6" style="color: red;">平台和一级经销商，请用英文输入！<br />若申请原因选择新经销商，指该公司之前与波科无任何形式的经销业务往来。<br/>(Please fill in English.<br/>  This application is applied to the dealer which hasn''' + 't  entered any business relationship with BSC.)</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td width="13%" class="title">申请单号(Application No.)</td><td colspan="5">' + @ContractNo + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td width="13%" class="title">经销商类型(Dealer Type)</td><td width="20%">' + @DealerTypeShow + '</td><td width="13%" class="title">产品线(Product Line)</td><td width="20%">' + @DepIdShow + '</td><td width="13%" class="title">合同分类(Sub-BU)</td><td width="21%">' + @SUBDEPIDShow + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">员工号(Employee Number)</td><td>' + @EId + '</td><td class="title">申请人(Applicant)</td><td>' + @EName + '</td><td class="title">申请日期(Request Date)</td><td>' + @RequestDate + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">指定渠道经理 (Channel BP)</td><td>' + @Jus1_QDJLShow + '</td><td colspan="4">&nbsp;</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">原因(Reason)</td><td colspan="3">' + @REASONShow + '</td>'
  IF @REASON != '1'
  BEGIN
      SET @Rtn += '<td class="title">曾用名(Used  Name)</td><td>' + @FORMERNAMEShow + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
  END
  --Line 6
  IF @REASON = '3'
  BEGIN
      SET @Rtn += '<tr><td class="title">合并考核经销商 Merge check dealer </td><td>' + @AssessmentShow + '</td><td class="title">合并考核开始时间 Assessment Start Time</td><td colspan="3">' + @AssessmentStart + '</td></tr>'
  END
  --Line 7
  SET @Rtn += '<tr><td class="title">申请部门(Department)</td><td>' + @ApplicantDepShow + '</td><td class="title">市场类型(Marketing Type)</td><td colspan="3">' + @MarketTypeShow + '</td></tr>'
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
  SET @Rtn += '<h4>新经销商基本信息 New Dealer Basic Information</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="13%" class="title">公司中文名称（Company Chinese Name）</td><td width="20%">' + @CompanyName + '</td><td width="13%" class="title">公司英文名称(Company EName)</td><td width="20%">' + @CompanyEName + '</td><td width="13%" class="title">SAP Code</td><td width="21%">' + @SAPCode + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">联系人(Contact)</td><td>' + @Contact + '</td><td class="title">邮件地址(EMail)</td><td>' + @EMail + '</td><td class="title">是否为设备经销商（Equipment Dealer）</td><td>' + @IsEquipmentShow + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">办公室电话号码(Office Number)</td><td>' + @OfficeNumber + '</td><td class="title">手机号码(Mobile)</td><td>' + @Mobile + '</td><td class="title">经销商标记(Dealer Mark)</td><td>' + @DealerMarkShow + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">办公室地址(Office Address)</td><td colspan="3">' + @OfficeAddress + '</td><td class="title">企业类型(Company Type)</td><td>' + @CompanyType + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">公司成立日期(Found Date)</td><td>' + @EstablishedTime + '</td><td class="title">公司注册资本(Registered Capital)</td><td>' + @Capital + '</td><td class="title">公司网站(Company Website)</td><td>' + @Website + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">选择渠道合作方将为 Boston Scientific 提供的服务类型和范围(Select the service type and scope that the channel partner will provide to Boston Scientific)</td><td colspan="5">' + @Jus4_FWFWShow + '</td></tr>'
  --Line 5
  IF EXISTS (
         SELECT 1
         FROM   dbo.GC_Fn_SplitStringToTable(@Jus4_FWFW, ',') T
         WHERE  T.VAL = '70'
     )
  BEGIN
      SET @Rtn += '<tr><td class="title">请选择渠道合作方将为 Boston Scientific 提供的其他服务类型(Please select the type(s) of other services the channel partner will provide to Boston Scientific )</td><td colspan="5">' + @Jus4_EWFWFWShow + '</td></tr>'
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
      SET @Rtn += '<tr><td class="title">如渠道合作方提供的服务未在上述两个问题中列出，则请提供该服务的相关描述。(If the channel partner is providing a service(s) not listed in the previous two questions, please provide a description of the service(s) being provided.)</td><td colspan="5">' + @Jus4_YWFW + '</td></tr>'
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
  SET @Rtn += '<h4>支持文件(Support Doc)</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="20%" class="title">是否三证合一(Is the license 3 in 1?)</td><td colspan="2">' + @IsThreeLicenseShow + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">(1)营业执照<br/>(请不要继续推荐，如果经销商没有通过当地工商管理局年度检验。) (1) business license <br/> ((It must has been passed the annual audit by Chinese Trade Office.))</td><td>' + dbo.Func_GetAttachmentHtml(@BA) + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">(2)医疗器械经营许可证<br/>(请不要继续推荐，如果波士顿产品的CFDA类别不在医疗器械经营许可证经营范围内。) (2)Medical License <br/> (It''' + 's scope must be contained BSC product CFDA code )</td><td>' + dbo.Func_GetAttachmentHtml(@MA) + '</td></tr>'
  --Line 4
  IF @IsThreeLicense != '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">(3)税务登记证<br/>(请不要继续推荐，如果经销商没有通过当地税务局年度检验。) (3) tax registration certificate <br/> (please do not continue to recommend, if the dealer does not pass the annual inspection of the local tax bureau). )</td><td>' + dbo.Func_GetAttachmentHtml(@TA) + '</td></tr>'
  END
  --Line 5
  IF @IsThreeLicense != '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">(4)组织机构代码证<br/>(请不要继续推荐，如果经销商没有通过当地质量技术监督局年度检验。) (4) organization code certificate <br/> (please do not continue to recommend, if the dealer does not pass the local quality and technical supervision of the annual inspection. )</td><td>' + dbo.Func_GetAttachmentHtml(@OA) + '</td></tr>'
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
  SET @Rtn += '<h4>销售&市场的竞争能力 Sales & market competitive ability</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="13%" class="title">医疗行业经验(年限) (Medical industry experience (years))</td><td width="20%">' + @HealthcareShow + '</td><td width="13%" class="title">介入行业经验(年限)  Years of in intervention</td><td width="20%">' + @InterShow + '</td><td width="13%" class="title">主要客户关系(年限) Years of relationship with KOL</td><td width="21%">' + @KOLShow + '</td></tr>'
  --Line 2
   SET @Rtn += '<tr><td colspan="2" class="title">合作过的业务伙伴(跨国公司名称) (Collaborated MNC)</td><td colspan="4">' + @MNC + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td colspan="2" class="title">如果经销商没有拥有以上的能力，请提供其他理由：If the dealer does not have the ability above, please provide other reasons:</td><td colspan="4">' + @Justification + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td colspan="2" class="title">如何知晓此渠道合作方？(How was the channel partner identified?)</td><td colspan="4">' + @Jus6_ZMFSShow + '</td></tr>'
  --Line 3
  IF EXISTS (
         SELECT 1
         FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_ZMFS, ',') T
         WHERE  T.VAL = '70'
     )
  BEGIN
      SET @Rtn += '<tr><td colspan="2" class="title">注明推荐方和/或相关实体的名称/姓名。(Identify the name of the referring party and/or related entity.)</td><td colspan="4">' + @Jus6_TJR + '</td></tr>'
  END
  --Line 3
  IF EXISTS (
         SELECT 1
         FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_ZMFS, ',') T
         WHERE  T.VAL = '80'
     )
  BEGIN
      SET @Rtn += '<tr><td colspan="2" class="title">提供关于“其他”的描述。(Provide a description for "Other".)</td><td colspan="4">' + @Jus6_QTFS + '</td></tr>'
  END
  --Line 3
  SET @Rtn += '<tr><td colspan="2" class="title">是否曾对可提供该服务的其他渠道合作方进行评估？(Were other channel partners evaluated for the services to be performed?)</td><td colspan="4">' + @Jus6_JXSPGShow + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td colspan="2" class="title">为何选择此渠道合作方？(Why was this channel partner chosen?)</td><td colspan="4">' + @Jus6_YYShow + '</td></tr>'
  --Line 3
  IF EXISTS (
         SELECT 1
         FROM   dbo.GC_Fn_SplitStringToTable(@Jus6_YY, ',') T
         WHERE  T.VAL = '50'
     )
  BEGIN
      SET @Rtn += '<tr><td colspan="2" class="title">提供关于“其他”的描述。(Provide a description for "Other".)</td><td colspan="4">' + @Jus6_QTXX + '</td></tr>'
  END
  --Line 3
  SET @Rtn += '<tr><td colspan="2" class="title">此渠道合作方与 Boston Scientific 是否存在任何利益冲突（定义见 Boston Scientific Code of Conduct ）？(If there is any conflict between this channel partner and Boston Scientific? (Please ref.  Boston Scientific Code of Conduct))</td><td colspan="4">' + @Jus6_XWYQShow + '</td></tr>'
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
  SET @Rtn += '<h4>初步的业务计划书 Preliminary business plan</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td class="title" width="25%">合作类型 Cooperation type</td><td width="25%">' + @ContractType + '</td><td class="title" width="25%">合同实体 Contractual entity</td><td width="25%">' + @BSC + '</td></tr>'
  --Line 1
  SET @Rtn += '<tr><td class="title">独家合同 Exclusive contract</td><td colspan="3">' + @Exclusiveness + '</td></tr>';
  --Line 1
  SET @Rtn += '<tr><td class="title">上述服务目前是否直接经由 BSC 销售部或经由另一渠道合作方执行？(Are the above services being excuted internally or another channel partner?)</td><td>' + @Jus5_SFCDShow + '</td>'
  IF @Jus5_SFCD = '1'
  BEGIN
      SET @Rtn += '<td class="title">解释为何需要增加或变更现有安排。(Explain the reason for change)</td><td>' + @Jus5_YYSM + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
  END
  --Line 2
  SET @Rtn += '<tr><td class="title">描述通过雇佣此推荐的渠道合作方所能满足的业务需求。（Describe the business requestments that will be fulfilled by this channel partner)</td><td colspan="3">' + @Jus5_JTMS + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">协议期限(协议生效日) （Effective Date）</td><td>' + @AgreementBegin + '</td><td class="title">协议期限(协议到期日) （Expiration Date）</td><td>' + @AgreementEnd + '</td></tr>'
  --PreContract
  SET @Rtn += '<tr><td class="title">该协议是否包含非标准合同条款（如无因终止、终止通知期限（通常为 60 天）、回购库存）？ (Does the agreement contain non-standard contract provisions (end without reason,non-standard termination notification,inventory buyback))</td><td>' + @Pre4_FBZTKShow + '</td>'
  IF @Pre4_FBZTK = '1'
  BEGIN
      SET @Rtn += '<td class="title">请提供非标准条款的正当理由。(Provide justification for the non-standard terms.）</td><td>' + @Pre4_ZDLY + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
  END
  --Line 3
  SET @Rtn += '<tr><td class="title">产品线(Product Line)</td><td>' + @ProductShow + '</td><td class="title">(如果是部分产品线，请列出)(if partial, please list)</td><td>' + @ProductRemark + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">价格<br/>标准价格的_%的折扣(Pricing Discount _% off standard price list)</td><td>' + @Price + '</td><td class="title">备注（Remark）</td><td>' + @PriceRemark + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">销售返利政策<br/>季度采购总额的_% (Sales Rebate _% of the quarter purchase AMT)</td><td>' + @SpecialSales + '</td><td class="title">备注（Remark）</td><td>' + @SpecialSalesRemark + '</td></tr>'
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
  
  SET @Rtn += '<tr><td class="title">区域(医院)Territory (Hospital)</td><td>' + @Hospital + '&nbsp;<a href="' + @HospitalUrl + '" target="_blank">查看(See)</a><br/><a href="' + @AuthUrl + '" target="_blank"><h4>授权明细列表</h4></a></td><td class="title">采购指标(CNY)<br/>(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>' + @Quota + '&nbsp;<a href="' + @QuotaUrl + '" target="_blank">查看</a></td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">上述服务将在哪些区域/地区执行？(list the territory (hospital) which will be excuted.)</td><td colspan="3">' + @Jus4_SQFW + '</td></tr>'
  --Line 7
  SET @Rtn += '<tr><td class="title">指标总额(CNY)不含税 Quota Total (CNY Without VAT)</td><td>' + @QuotaTotal + '</td><td class="title">指标总额(USD)不含税 Quota Total(USD Without VAT)</td><td>' + @QUOTAUSD + '</td></tr>'
  
  --PreContract
  SET @Rtn += '<tr><td colspan="4" style="margin: 10px !important; padding: 10px !important;"><table class="gridtable">';
  SET @Rtn += '<tr><td class="title" width="14%">年份 (Year)</td><td class="title" width="14%">第一季度(Q1)</td><td class="title" width="14%">第二季度(Q2)</td><td class="title" width="14%">第三季度(Q3)</td><td class="title" width="14%">第四季度(Q4)</td><td class="title" width="14%">合计(Total)</td><td class="title" width="16%">% 对上一年度销售额 (% vs Actual purchase of LY )</td></tr>';
  
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
  --SET @Rtn += '<tr><td class="title" width="20%">所拟定的年度合同价值是多少？</td><td colspan="3">' + @Pre6_HTJZShow + '</td></tr>'
  --PreContract
  SET @Rtn += '<tr><td class="title">如渠道合作方为 Boston Scientific 提供不只一项服务，获利是否会根据服务类型予以调整？ (If the channel partner''' + 's reward will be changed with service type changing?)</td><td colspan="3">' + @Pre7_SFTZShow + '</td></tr>'
  
  --PreContract
  SET @Rtn += '<tr><td colspan="4" style="margin: 10px !important; padding: 10px !important;"><table class="gridtable">';
  SET @Rtn += '<tr><td class="title" width="33%">服务类型 (Service Type)</td><td class="title" width="33%">利润（是/否）(Profit(Yes/no))</td><td class="title" width="34%">所提供的利润范围(<10%, 10-20%, >20%)  (Range (<10%,10-20%, >20%))</td></tr>';
  
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
  SET @Rtn += '<tr><td class="title">付款方式 Payment</td><td colspan="3">' + @PaymentShow + '</td></tr>'
  --PreContract
  IF @Payment = 'LC'
  BEGIN
      SET @Rtn += '<tr><td class="title">应在多少天内完成付款？(Payable within how many days?)</td><td colspan="3">' + @PayTerm + '</td></tr>'
  END
  --PreContract
  SET @Rtn += '<tr><td class="title" >是否有担保？ (Is there a security amount?)</td><td colspan="3" >' + @IsDepositShow + '</td></tr>'
  --Line 9
  IF @Payment = 'Credit'
  BEGIN
      SET @Rtn += '<tr><td class="title">信用期限(天数)(credit terms（Day)</td><td>' + @CreditTerm + '</td><td class="title">信用额度(CNY, 含增值税)(Credit Limit) </td><td>' + @CreditLimit + '</td></tr>'
  END
  --Line 10
  IF @IsDeposit = '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">保证金(CNY) Deposit</td><td>' + @Deposit + '</td><td class="title">保证金形式 Deposit Type</td><td>' + @InformShow + '</td></tr>'
  END
  --Line 11
  IF @IsDeposit = '1'
     AND EXISTS (
             SELECT 1
             FROM   dbo.GC_Fn_SplitStringToTable(@Inform, ',') T
             WHERE  T.VAL = 'Others'
         )
  BEGIN
      SET @Rtn += '<tr><td class="title">保证金形式备注  Deposit Type Remark</td><td colspan="3">' + @InformOther + '</td></tr></tr>'
  END
  --Line 12
  SET @Rtn += '<tr><td class="title">付款备注 Payment Remark</td><td colspan="3">' + @Comment + '</td></tr>'
  SET @Rtn += '<tr><td class="title">经销商总计采购指标小于总计医院指标的原因 Reason for total dealer commercial purchase target less than total hospital target</td><td>' + @DealerLessHosReason 
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
  SET @Rtn += '<td class="title">经销商季度指标小于医院季度指标的原因 (Reason for Dealer quarterly commercial purchase target less than hospital quarterly target)</td><td>' + @DealerLessHosReasonQ + '</td></tr>'
  --Line 16
  
  
  SET @Rtn += '<tr><td class="title" width="25%">总计医院实际指标小于总计医院标准指标的原因 (Reason for total actual hospital target less than total standard hospital target)</td><td>' + @HosLessStandardReason  
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
  SET @Rtn += '<td class="title" width="25%">医院实际季度指标小于医院标准季度指标的原因 （Reason for quarterly actual hospital target less than quarterly standard hospital target）</td><td>' + @HosLessStandardReasonQ 
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
  SET @Rtn += '<tr><td class="title" width="25%">产品组最小指标备注 Product group minimal target remark</td><td >' + @ProductGroupMemo 
  --Line 2
  IF @IsCorssBu = '0'
  BEGIN
    
      SET @Rtn += '</br>不选择跨BU经销商备注 Do not choose to cross BU dealer remark</br>' + @CorssBuMemo + '</td>'
  END
  else 
	begin
	   SET @Rtn +='</td>'
	   end
  --Line 2
  SET @Rtn += '<td class="title" width="25%">在渠道合作方服务的国家，其能为 Boston Scientific 的缔约方带来多大的市场？(What portion of the Boston Scientific Contracting Party''' + 's business will be driven by the channel partner in the country where the channel partner is performing services?)</td><td >' + @Jus8_YWZBShow + '</td></tr>'
  ---Line 1
  SET @Rtn += '<tr><td class="title" width="25%">渠道合作方是否有要求非常规的付款条件（如预付款、付款至多个账户、付款至不同实体、付款至非渠道合作方所在国家）？(Is the channel partner requesting non-routine payment terms (e.g.,advance payments, payments to multiple accounts, payments to a different entity, payments to a country other than where the channel partner is located)?)</td><td>' + @Jus8_SFFGDShow + '</td>'
  IF @Jus8_SFFGD = '1'
  BEGIN
      SET @Rtn += '<td class="title" width="25%">列出非常规的付款条件 (List the non-routine payment terms.)</td><td>' + @Jus8_FGDFS + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<td>&nbsp;</td><td>&nbsp;</td></tr>'
  END
  --Line 19
  SET @Rtn += '<tr><td class="title" width="25%">附件(Attachement)</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@Attachment) + '</td></tr>'
  
  SET @Rtn += '</table>'
  
  --Other
  
  --Head
  SET @Rtn += '<h4>其他(Other)</h4><table class="gridtable">'
  --Line 1
   SET @Rtn += '<tr><td class="title" width="25%">渠道合作方在正常情况下是否会与外国官员交往？(Dose the channel partner contact with foreign officials?)</td><td>' + @Jus7_ZZBJShow 
  --Line 2
  IF @Jus7_ZZBJ = '1'
  BEGIN
      SET @Rtn += '</br>描述此等交往性质。(Describe the nature of these interactions.)</br>' + @Jus7_SX + '</td>'
      
  END
  else
   begin
      set @Rtn+='</td>'
  --Line 3
  end
  SET @Rtn += '<td class="title" width="25%">渠道合作方是否会代表 Boston Scientific 与其他第三方（如物流供应商、活动赞助商、旅行社）交往？(Dose the channel partner behalf BSC to contact with other 3rd. Part? (e.g.logistics supplier, events service provider, travel agency.))</td><td>' + @Jus7_SYLWShow 
  --Line 4
  IF @Jus7_SYLW = '1'
  BEGIN
      SET @Rtn += '</br>描述此等交往性质。(Describe the nature of these interactions.)</br>' + @Jus7_HDMS + '</td></tr>'
  END
   else
   begin
   set @Rtn+='</td></tr>'
   end
  --PreContract
  SET @Rtn += '<tr><td class="title"width="25%" >与此渠道合作方签订的协议是否需要经过审核和批准（如经国家机关公证）？(Whether the agreement need to be approved by related organization? (such as government offices))</td><td>' + @Pre9_SHPZShow + '</td><td class="title">与此渠道合作方签订的协议是否需要经过签约授权？ (Does an agreement with this channel partner require certification of appointment?)</td><td>' + @Pre9_QYSQShow + '</td></tr>'
  --PreContract
  
  --PreContract
  SET @Rtn += '<tr><td class="title">与此渠道合作方签订的协议是否需要进口证书？ (Whether the agreement needs import license?)</td><td colspan="3">' + @Pre9_JKZSShow + '</td></tr>'
  
  SET @Rtn += '</table>'
 
  
  --跨BU经销商
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
  SET @Rtn += '<h4>跨BU经销商 Cross BU dealer</h4><table class="gridtable">'
  SET @Rtn += '<tr><td class="title" width="10%">医院编号 (Hospital Number)</td><td class="title" width="25%">医院名称 (Hospital Name)</td><td class="title" width="10%">经销商编号(Dealer Number)</td><td class="title" width="25%">经销商名称(Dealer Name)</td><td class="title" width="10%">BU</td><td class="title" width="10%">SubBU</td><td class="title" width="10%">迪乐评分(KpiScore)</td></tr>'
  
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
  
  --同名经销商
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
  SET @Rtn += '<h4>同名经销商 (Same Dealer Name)</h4><table class="gridtable">'
  SET @Rtn += '<tr><td class="title" width="25%">经销商(Dealer)</td><td class="title" width="25%">所属市场 (Same Market Type)</td><td class="title" width="25%">产品线 (Product Line)</td><td class="title" width="25%">所属平台(Same Lp Name)</td></tr>'
  
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
  
  --曾用名经销商
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
      SET @Rtn += '<h4>曾用名经销商 Former Name Dealer</h4><table class="gridtable">'
      SET @Rtn += '<tr><td class="title" width="33%">原因 Reason</td><td class="title" width="33%">关联经销商编号 RelateRefSAPID </td><td class="title" width="34%">关联经销商名称 RelateRefDealerName</td></tr>'
      
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
  
  --合并考核经销商
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
      SET @Rtn += '<h4>合并考核经销商 Merged Assessment Dealer</h4><table class="gridtable">'
      SET @Rtn += '<tr><td class="title" width="10%">类型 Type</td><td class="title" width="10%">年份 Year</td><td class="title" width="10%">开始季度 Start Quarter</td><td class="title" width="10%">结束季度 End Quarter</td><td class="title" width="10%">Division</td><td class="title" width="10%">SubBU</td><td class="title" width="10%">经销商编号 (Dealer Number)</td><td class="title" width="10%">经销商名称 (Dealer Name)</td><td class="title" width="10%">备注 （Remark）</td><td class="title" width="10%">红蓝海 Red and blue </td></tr>'
      
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
  
  --CFDA产品分类
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
  SET @Rtn += '<h4>CFDA产品分类 CFDA Product Category</h4><table class="gridtable">'
  SET @Rtn += '<tr><td class="title" width="33%">类别(level 1)</td><td class="title" width="33%">分类代码(level 2)</td><td class="title" width="34%">分类名称(Product Name)</td></tr>'
  
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
  
  SET @Rtn += '<a href="' + @AuthUrl + '" target="_blank"><h4>授权明细列表</h4></a>'
  */
  RETURN ISNULL(@Rtn, '')
  
end

GO


