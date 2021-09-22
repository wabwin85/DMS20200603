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
  SET @Rtn += '<h4>������Ϣ</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td colspan="6" style="color: red;">ƽ̨��һ�������̣�����Ӣ�����룡<br />������ԭ��ѡ���¾����̣�ָ�ù�˾���������˾֮ǰ�벨�Ƽ�ƽ̨���κ���ʽ�ľ���ҵ��������</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td width="13%" class="title">���뵥��</td><td colspan="5">' + @ContractNo + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td width="13%" class="title">����������</td><td width="20%">' + @DealerTypeShow + '</td><td width="13%" class="title">��Ʒ��</td><td colspan="3">' + @DepIdShow + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">Ա����</td><td width="20%">' + @EId + '</td><td class="title">������</td><td width="20%">' + @EName + '</td><td width="13%" class="title">��������</td><td width="21%">' + @RequestDate + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">���벿��</td><td colspan="5">' + @ApplicantDepShow + '</td></tr>'
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
  SET @Rtn += '<h4>�¾����̻�����Ϣ</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="25%" class="title">��˾��������</td><td width="25%">' + @CompanyName + '</td><td width="25%" class="title">��˾Ӣ������</td><td width="25%">' + @CompanyEName + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">��ϵ��</td><td>' + @Contact + '</td><td class="title">�ʼ���ַ</td><td>' + @EMail + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">�칫�ҵ绰����</td><td>' + @OfficeNumber + '</td><td class="title">�ֻ�����</td><td>' + @Mobile + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">�칫�ҵ�ַ</td><td colspan="3">' + @OfficeAddress + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">��˾��������</td><td>' + @EstablishedTime + '</td><td class="title">��˾ע���ʱ�</td><td>' + @Capital + '</td></tr>'
  --Line 6
  IF @IsForeign = '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">�Ƿ��⹫˾</td><td>' + @IsForeignShow + '</td><td class="title">���⹫˾��ע</td><td>' + @ForeignRemark + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<tr><td class="title">�Ƿ��⹫˾</td><td colspan="3">' + @IsForeignShow + '</td></tr>'
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
  SET @Rtn += '<h4>֧���ļ�</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td class="title" width="25%">�Ƿ���֤��һ</td><td>' + @IsThreeLicenseShow + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">(1)Ӫҵִ��<br/>(�벻Ҫ�����Ƽ������������û��ͨ�����ع��̹������ȼ��顣)</td><td>' + dbo.Func_GetAttachmentHtml(@BA) + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">(2)����ó�׾�Ӫ�߱����ǼǱ�<br/>(�벻Ҫ�����Ƽ��������ó��˾û�ж���ó�׾�Ӫ�߱����ǼǱ�)</td><td>' + dbo.Func_GetAttachmentHtml(@RA) + '</td></tr>'
  --Line 4
  IF @IsThreeLicense != '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">(3)˰��Ǽ�֤<br/>(�벻Ҫ�����Ƽ������������û��ͨ������˰�����ȼ��顣)</td><td>' + dbo.Func_GetAttachmentHtml(@TA) + '</td></tr>'
  END
  --Line 5
  IF @IsThreeLicense != '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">(4)��֯��������֤<br/>(�벻Ҫ�����Ƽ������������û��ͨ���������������ල����ȼ��顣)</td><td>' + dbo.Func_GetAttachmentHtml(@OA) + '</td></tr>'
  END
  
  SET @Rtn += '</table>'
  
  --Proposals
  DECLARE @AccountForm NVARCHAR(1000) ;
  
  SELECT @AccountForm = AccountForm
  FROM   [Contract].AppointmentProposals A
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>������ҵ��ƻ���</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td class="title" width="25%">���������</td><td>' + dbo.Func_GetAttachmentHtml(@AccountForm) + '</td></tr>'
  
  SET @Rtn += '</table>'
  
  RETURN ISNULL(@Rtn, '')
END

GO


