DROP FUNCTION [Contract].[Func_GetAppointmentTradeHtml]
GO


CREATE FUNCTION [Contract].[Func_GetAppointmentTradeHtml]
(
  @ContractId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Rtn NVARCHAR(MAX);
  
  SET @Rtn = '<style type="text/css">table.gridtable {width:100%; font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}td.title{background-color: #E8E8E8;font-weight:bold;}</style>'
  
  --Main
  DECLARE @ContractNo NVARCHAR(200) ;
  DECLARE @DealerTypeShow NVARCHAR(200) ;
  DECLARE @DepId NVARCHAR(200) ;
  DECLARE @DepIdShow NVARCHAR(200) ;
  DECLARE @EId NVARCHAR(200) ;
  DECLARE @EName NVARCHAR(200) ;
  DECLARE @RequestDate NVARCHAR(200) ;
  DECLARE @ApplicantDepShow NVARCHAR(200) ;
  DECLARE @ReagionRSMShow NVARCHAR(200) ;
  
  SELECT @ContractNo = ISNULL(ContractNo, ''),
         @DealerTypeShow = dbo.Func_GetCode('CONST_CONTRACT_DealerType', A.DealerType),
         @DepId = A.DepId,
         @DepIdShow = ISNULL(B.DepFullName, ''),
         @EId = ISNULL(EId, ''),
         @EName = ISNULL(EName, ''),
         @RequestDate = ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), ''),
         @ApplicantDepShow = ISNULL(C.DepFullName, ''),
         @ReagionRSMShow = (
             SELECT TOP 1 T.ManagerName
             FROM   MDM_Manager T
             WHERE  A.ReagionRSM = T.EmpNo
                    AND T.ManagerTitle = 'RSM'
         )
  FROM   [Contract].AppointmentMain A
         LEFT JOIN interface.mdm_department B
              ON  CONVERT(NVARCHAR(10), A.DepId) = B.DepID
         LEFT JOIN interface.mdm_department C
              ON  CONVERT(NVARCHAR(10), A.ApplicantDep) = C.DepID
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>申请信息</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td colspan="6" style="color: red;">平台和一级经销商，请用英文输入！<br />若申请原因选择新经销商，指该公司及其关联公司之前与波科及平台无任何形式的经销业务往来。</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td width="13%" class="title">申请单号</td><td colspan="5">' + @ContractNo + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td width="13%" class="title">经销商类型</td><td width="20%">' + @DealerTypeShow + '</td><td width="13%" class="title">产品线</td><td colspan="3">' + @DepIdShow + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">员工号</td><td width="20%">' + @EId + '</td><td class="title">申请人</td><td width="20%">' + @EName + '</td><td width="13%" class="title">申请日期</td><td width="21%">' + @RequestDate + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">申请部门</td><td colspan="5">' + @ApplicantDepShow + '</td></tr>'
  --Line 6
  IF @DepId IN ('17', '19', '32', '35')
  BEGIN
      SET @Rtn += '<tr><td class="title">RSM</td><td colspan="5">' + @ReagionRSMShow + '</td></tr>'
  END
  
  SET @Rtn += '</table>'
  
  --Candidate
  DECLARE @CompanyName NVARCHAR(200) ;
  DECLARE @CompanyEName NVARCHAR(500) ;
  DECLARE @Contact NVARCHAR(200) ;
  DECLARE @EMail NVARCHAR(200) ;
  DECLARE @OfficeNumber NVARCHAR(200) ;
  DECLARE @Mobile NVARCHAR(200) ;
  DECLARE @OfficeAddress NVARCHAR(200) ;
  DECLARE @EstablishedTime NVARCHAR(200) ;
  DECLARE @Capital NVARCHAR(200) ;
  DECLARE @IsForeign NVARCHAR(200) ;
  DECLARE @IsForeignShow NVARCHAR(200) ;
  DECLARE @ForeignRemark NVARCHAR(1000) ;
  
  SELECT @CompanyName = ISNULL(CompanyName, ''),
         @CompanyEName = ISNULL(CompanyEName, ''),
         @Contact = ISNULL(Contact, ''),
         @EMail = ISNULL(EMail, ''),
         @OfficeNumber = ISNULL(OfficeNumber, ''),
         @Mobile = ISNULL(Mobile, ''),
         @OfficeAddress = ISNULL(OfficeAddress, ''),
         @EstablishedTime = ISNULL(CONVERT(NVARCHAR(10), EstablishedTime, 121), ''),
         @Capital = ISNULL(Capital, ''),
         @IsForeign = A.IsForeign,
         @IsForeignShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsForeign),
         @ForeignRemark = ISNULL(ForeignRemark, '')
  FROM   [Contract].AppointmentCandidate A
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>新经销商基本信息</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="25%" class="title">公司中文名称</td><td width="25%">' + @CompanyName + '</td><td width="25%" class="title">公司英文名称</td><td width="25%">' + @CompanyEName + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">联系人</td><td>' + @Contact + '</td><td class="title">邮件地址</td><td>' + @EMail + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">办公室电话号码</td><td>' + @OfficeNumber + '</td><td class="title">手机号码</td><td>' + @Mobile + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">办公室地址</td><td colspan="3">' + @OfficeAddress + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">公司成立日期</td><td>' + @EstablishedTime + '</td><td class="title">公司注册资本</td><td>' + @Capital + '</td></tr>'
  --Line 6
  IF @IsForeign = '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">是否境外公司</td><td>' + @IsForeignShow + '</td><td class="title">境外公司备注</td><td>' + @ForeignRemark + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<tr><td class="title">是否境外公司</td><td colspan="3">' + @IsForeignShow + '</td></tr>'
  END
  
  SET @Rtn += '</table>'
  
  --Documents
  DECLARE @IsThreeLicense NVARCHAR(200) ;
  DECLARE @IsThreeLicenseShow NVARCHAR(200) ;
  DECLARE @BA NVARCHAR(1000);
  DECLARE @TA NVARCHAR(1000);
  DECLARE @OA NVARCHAR(1000);
  DECLARE @RA NVARCHAR(1000);
  
  SELECT @IsThreeLicense = IsThreeLicense,
         @IsThreeLicenseShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsThreeLicense),
         @BA = BA,
         @TA = TA,
         @OA = OA,
         @RA = RA
  FROM   [Contract].AppointmentDocuments A
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>支持文件</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td class="title" width="25%">是否三证合一</td><td>' + @IsThreeLicenseShow + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">(1)营业执照<br/>(请不要继续推荐，如果经销商没有通过当地工商管理局年度检验。)</td><td>' + dbo.Func_GetAttachmentHtml(@BA) + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">(2)对外贸易经营者备案登记表<br/>(请不要继续推荐，如果外贸公司没有对外贸易经营者备案登记表。)</td><td>' + dbo.Func_GetAttachmentHtml(@RA) + '</td></tr>'
  --Line 4
  IF @IsThreeLicense != '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">(3)税务登记证<br/>(请不要继续推荐，如果经销商没有通过当地税务局年度检验。)</td><td>' + dbo.Func_GetAttachmentHtml(@TA) + '</td></tr>'
  END
  --Line 5
  IF @IsThreeLicense != '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">(4)组织机构代码证<br/>(请不要继续推荐，如果经销商没有通过当地质量技术监督局年度检验。)</td><td>' + dbo.Func_GetAttachmentHtml(@OA) + '</td></tr>'
  END
  
  SET @Rtn += '</table>'
  
  --Proposals
  DECLARE @AccountForm NVARCHAR(1000) ;
  
  SELECT @AccountForm = AccountForm
  FROM   [Contract].AppointmentProposals A
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>初步的业务计划书</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td class="title" width="25%">开户申请表</td><td>' + dbo.Func_GetAttachmentHtml(@AccountForm) + '</td></tr>'
  
  SET @Rtn += '</table>'
  
  RETURN ISNULL(@Rtn, '')
END

GO


