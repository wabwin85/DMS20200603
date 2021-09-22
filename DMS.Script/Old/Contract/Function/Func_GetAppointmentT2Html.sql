
DROP FUNCTION [Contract].[Func_GetAppointmentT2Html]
GO


CREATE FUNCTION [Contract].[Func_GetAppointmentT2Html]
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
  DECLARE @ReagionRSMShow NVARCHAR(200) ;
  DECLARE @TypeRemark NVARCHAR(200) ;
  DECLARE @AOPTYPE NVARCHAR(200) ;
  DECLARE @PRICEAUTO INT ;
  DECLARE @REBATEAUTO INT ;
  DECLARE @HOSPITALTYPE INT ;
  DECLARE @IsLP NVARCHAR(200) ;
  
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
         @ReagionRSMShow = (
             SELECT TOP 1 T.ManagerName
             FROM   MDM_Manager T
             WHERE  A.ReagionRSM = T.EmpNo
                    AND T.ManagerTitle = 'RSM'
         ),
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
  
  --Head
  SET @Rtn += '<h4>������Ϣ</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td colspan="6" style="color: red;">ƽ̨��һ�������̣�����Ӣ�����룡<br />������ԭ��ѡ���¾����̣�ָ�ù�˾֮ǰ�벨�Ƽ�ƽ̨���κ���ʽ�ľ���ҵ��������</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td width="13%" class="title">���뵥��</td><td colspan="5">' + @ContractNo + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td width="13%" class="title">����������</td><td width="20%">' + @DealerTypeShow + '</td><td width="13%" class="title">��Ʒ��</td><td width="20%">' + @DepIdShow + '</td><td width="13%" class="title">��ͬ����</td><td width="21%">' + @SUBDEPIDShow + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">Ա����</td><td>' + @EId + '</td><td class="title">������</td><td>' + @EName + '</td><td class="title">��������</td><td>' + @RequestDate + '</td></tr>'
  --Line 5
  IF @REASON != '1'
  BEGIN
      SET @Rtn += '<tr><td class="title">ԭ��</td><td colspan="3">' + @REASONShow + '</td><td class="title">������</td><td>' + @FORMERNAMEShow + '</td></tr>'
  END
  ELSE
  BEGIN
      SET @Rtn += '<tr><td class="title">ԭ��</td><td colspan="5">' + @REASONShow + '</td></tr>'
  END
  --Line 6
  IF @REASON = '3'
  BEGIN
      SET @Rtn += '<tr><td class="title">�ϲ����˾�����</td><td>' + @AssessmentShow + '</td><td class="title">�ϲ����˿�ʼʱ��</td><td colspan="3">' + @AssessmentStart + '</td></tr>'
  END
  --Line 7
  SET @Rtn += '<tr><td class="title">���벿��</td><td>' + @ApplicantDepShow + '</td><td class="title">�г�����</td><td colspan="3">' + @MarketTypeShow + '</td></tr>'
  --Line 8
  IF @DepId IN ('17', '19', '32', '35')
  BEGIN
      SET @Rtn += '<tr><td class="title">RSM</td><td>' + @ReagionRSMShow + '</td><td colspan="4">&nbsp;</td></tr>'
  END
  
  SET @Rtn += '</table>'
  
  --Candidate
  DECLARE @CompanyName NVARCHAR(200) ;
  DECLARE @Contact NVARCHAR(200) ;
  DECLARE @EMail NVARCHAR(200) ;
  DECLARE @IsEquipmentShow NVARCHAR(200) ;
  DECLARE @OfficeNumber NVARCHAR(200) ;
  DECLARE @Mobile NVARCHAR(200) ;
  DECLARE @DealerMarkShow NVARCHAR(200) ;
  DECLARE @OfficeAddress NVARCHAR(200) ;
  DECLARE @EstablishedTime NVARCHAR(200) ;
  DECLARE @Capital NVARCHAR(200) ;
  DECLARE @LPSAPCodeShow NVARCHAR(500) ;
  DECLARE @CompanyID NVARCHAR(200) ;
  
  SELECT @CompanyName = ISNULL(CompanyName, ''),
         @Contact = ISNULL(Contact, ''),
         @EMail = ISNULL(EMail, ''),
         @IsEquipmentShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsEquipment),
         @OfficeNumber = ISNULL(OfficeNumber, ''),
         @Mobile = ISNULL(Mobile, ''),
         @DealerMarkShow = dbo.Func_GetCode('CONST_CONTRACT_DealerMark', A.DealerMark),
         @OfficeAddress = ISNULL(OfficeAddress, ''),
         @EstablishedTime = ISNULL(CONVERT(NVARCHAR(10), EstablishedTime, 121), ''),
         @Capital = ISNULL(Capital, ''),
         @LPSAPCodeShow = ISNULL(B.DMA_ChineseName, ''),
         @CompanyID = ISNULL(CompanyID, '')
  FROM   [Contract].AppointmentCandidate A
         LEFT JOIN DealerMaster B
              ON  A.LPSAPCode = B.DMA_SAP_Code
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>�¾����̻�����Ϣ</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="13%" class="title">��˾��������</td><td colspan="5">' + @CompanyName + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td width="13%" class="title">��ϵ��</td><td width="20%">' + @Contact + '</td><td width="13%" class="title">�ʼ���ַ</td><td width="20%">' + @EMail + '</td><td width="13%" class="title">�Ƿ�Ϊ�豸������</td><td width="21%">' + @IsEquipmentShow + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">�칫�ҵ绰����</td><td>' + @OfficeNumber + '</td><td class="title">�ֻ�����</td><td>' + @Mobile + '</td><td class="title">�����̱��</td><td>' + @DealerMarkShow + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">�칫�ҵ�ַ</td><td colspan="5">' + @OfficeAddress + '</td>'
  --Line 5
  SET @Rtn += '<tr><td class="title">��˾��������</td><td>' + @EstablishedTime + '</td><td class="title">��˾ע���ʱ�</td><td colspan="3">' + @Capital + '</td></tr>'
  --Line 6
  SET @Rtn += '<tr><td class="title">ƽ̨��˾����</td><td colspan="5">' + @LPSAPCodeShow + '</td></tr>'
  
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
  SET @Rtn += '<h4>֧���ļ�</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="25%" class="title">�Ƿ���֤��һ</td><td colspan="2">' + @IsThreeLicenseShow + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">(1)Ӫҵִ��<br/>(�벻Ҫ�����Ƽ������������û��ͨ�����ع��̹������ȼ��顣)</td><td>' + dbo.Func_GetAttachmentHtml(@BA) + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">(2)ҽ����е��Ӫ���֤<br/>(�벻Ҫ�����Ƽ��������ʿ�ٲ�Ʒ��CFDA�����ҽ����е��Ӫ���֤��Ӫ��Χ�ڡ�)</td><td>' + dbo.Func_GetAttachmentHtml(@MA) + '</td></tr>'
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
  
  --Competency
  DECLARE @HealthcareShow NVARCHAR(100) ;
  DECLARE @InterShow NVARCHAR(100) ;
  DECLARE @KOLShow NVARCHAR(100) ;
  DECLARE @MNC NVARCHAR(100) ;
  DECLARE @Justification NVARCHAR(500) ;
  
  SELECT @HealthcareShow = dbo.Func_GetCode('CONST_CONTRACT_Competency', A.Healthcare),
         @InterShow = dbo.Func_GetCode('CONST_CONTRACT_Competency', A.Inter),
         @KOLShow = dbo.Func_GetCode('CONST_CONTRACT_Competency', A.KOL),
         @MNC = MNC,
         @Justification = Justification
  FROM   [Contract].AppointmentCompetency A
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>����&�г��ľ�������</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="13%" class="title">ҽ����ҵ����(����)</td><td width="20%">' + @HealthcareShow + '</td><td width="13%" class="title">������ҵ����(����)</td><td width="20%">' + @InterShow + '</td><td width="13%" class="title">��Ҫ�ͻ���ϵ(����)</td><td width="21%">' + @KOLShow + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">��������ҵ����(�����˾����)</td><td colspan="5">' + @MNC + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">���������û��ӵ�����ϵ����������ṩ�������ɣ�</td><td colspan="5">' + @Justification + '</td></tr>'
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
  
  SELECT @ContractType = ContractType,
         @BSC = BSC,
         @Exclusiveness = Exclusiveness,
         @AgreementBegin = ISNULL(CONVERT(NVARCHAR(10), AgreementBegin, 121), ''),
         @AgreementEnd = ISNULL(CONVERT(NVARCHAR(10), AgreementEnd, 121), ''),
         @ProductShow = dbo.Func_GetCode('CONST_CONTRACT_ProposalsProduct', A.Product),
         @ProductRemark = ProductRemark,
         @Price = Price,
         @PriceRemark = PriceRemark,
         @SpecialSales = SpecialSales,
         @SpecialSalesRemark = SpecialSalesRemark,
         @Hospital = SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)),
         @Quota = SUBSTRING(Quota, 0, CHARINDEX('<', Quota)),
         @QuotaTotal = ISNULL(CONVERT(NVARCHAR(20), QuotaTotal), ''),
         @QUOTAUSD = ISNULL(CONVERT(NVARCHAR(20), QUOTAUSD), ''),
         @AllProductAOP = ISNULL(CONVERT(NVARCHAR(20), AllProductAOP), ''),
         @AllProductAopUSD = ISNULL(CONVERT(NVARCHAR(20), AllProductAopUSD), ''),
         @DealerLessHosQ = DealerLessHosQ,
         @DealerLessHosReason = DealerLessHosReason,
         @DealerLessHosReasonQ = DealerLessHosReasonQ,
         @DealerLessHosQRemark = DealerLessHosQRemark,
         @HosLessStandardQ = HosLessStandardQ,
         @HosLessStandardReason = HosLessStandardReason,
         @HosLessStandardReasonQ = HosLessStandardReasonQ,
         @HosLessStandardQRemark = HosLessStandardQRemark,
         @ProductGroupCheck = ISNULL(ProductGroupCheck, ''),
         @ProductGroupRemark = ISNULL(ProductGroupRemark, ''),
         @ProductGroupMemo = ISNULL(ProductGroupMemo, ''),
         @IsCorssBu = ISNULL(IsCorssBu, ''),
         @CorssBuMemo = ISNULL(CorssBuMemo, ''),
         @Attachment = Attachment,
         @ISVAT = ISVAT
  FROM   [Contract].AppointmentProposals A
  WHERE  A.ContractId = @ContractId;
  
  --Head
  SET @Rtn += '<h4>������ҵ��ƻ���</h4><table class="gridtable">'
  --Line 1
  SET @Rtn += '<tr><td width="13%" class="title">��������</td><td width="20%">' + @ContractType + '</td><td width="13%" class="title">��ͬʵ��</td><td width="20%">' + @BSC + '</td><td width="13%" class="title">���Һ�ͬ</td><td width="21%">' + @Exclusiveness + '</td></tr>'
  --Line 2
  SET @Rtn += '<tr><td class="title">Э������(Э����Ч��)</td><td>' + @AgreementBegin + '</td><td class="title">Э������(Э�鵽����)</td><td colspan="3">' + @AgreementEnd + '</td></tr>'
  --Line 3
  SET @Rtn += '<tr><td class="title">��Ʒ��</td><td>' + @ProductShow + '</td><td class="title">(����ǲ��ֲ�Ʒ�ߣ����г�)</td><td colspan="3">' + @ProductRemark + '</td></tr>'
  --Line 4
  SET @Rtn += '<tr><td class="title">�۸�<br/>��׼�۸��_%���ۿ�</td><td>' + @Price + '</td><td class="title">��ע</td><td colspan="3">' + @PriceRemark + '</td></tr>'
  --Line 5
  SET @Rtn += '<tr><td class="title">���۷�������<br/>���Ȳɹ��ܶ��_%</td><td>' + @SpecialSales + '</td><td class="title">��ע</td><td colspan="3">' + @SpecialSalesRemark + '</td></tr>'
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
  
  SET @Rtn += '<tr><td class="title">����(ҽԺ)</td><td>' + @Hospital + '&nbsp;<a href="' + @HospitalUrl + '" target="_blank">�鿴</a><br/><a href="' + @AuthUrl + '" target="_blank"><h4>��Ȩ��ϸ�б�</h4></a></td><td class="title">�ɹ�ָ��(CNY)<br/>(BSC SFX Rate:USD 1 = CNY 6.69)</td><td colspan="3">' + @Quota + '<a href="' + @QuotaUrl + '" target="_blank">�鿴</a></td></tr>'
  --Line 7
  SET @Rtn += '<tr><td class="title">ָ���ܶ�(CNY)����˰</td><td>' + @QuotaTotal + '</td><td class="title">ָ���ܶ�(USD)����˰</td><td colspan="3">' + @QUOTAUSD + '</td></tr>'
  --Line 8
   SET @Rtn += '<tr><td class="title" >�������ܼƲɹ�ָ��С���ܼ�ҽԺָ���ԭ��</td><td >' + @DealerLessHosReason 
  --Line 9
  IF @DealerLessHosQ = '0'
  BEGIN
      SET @Rtn +=  +@DealerLessHosQRemark + '</td>'
  END
  else
  begin
    SET @Rtn +='</td>'
  end
  --Line 10
  SET @Rtn += '<td class="title">�����̼���ָ��С��ҽԺ����ָ���ԭ��</td><td colspan="3">' + @DealerLessHosReasonQ + '</td></tr>'
  --Line 11
  SET @Rtn += '<tr><td class="title">�ܼ�ҽԺʵ��ָ��С���ܼ�ҽԺ��׼ָ���ԭ��</td><td>' + @HosLessStandardReason 
  --Line 12
  IF @HosLessStandardQ = '0'
  BEGIN
     
      SET @Rtn += + @HosLessStandardQRemark + '</td>'
  END
  else
  begin
  set @Rtn+='</td>'
  end
  --Line 13
  SET @Rtn += '<td class="title">ҽԺʵ�ʼ���ָ��С��ҽԺ��׼����ָ���ԭ��</td><td colspan="3">' + @HosLessStandardReasonQ 
  --Line 14
  IF @ProductGroupCheck = '0'
  BEGIN
      SET @Rtn +=  + @ProductGroupRemark + '</td></tr>'
  END
  else
  begin
  
  set @Rtn +='</td></tr>'
  end
  SET @Rtn += '<tr><td class="title">��Ʒ����Сָ�걸ע</td><td >' + @ProductGroupRemark 
  --Line 2
  IF @IsCorssBu = '0'
  BEGIN
      SET @Rtn += '</br>��ѡ���BU�����̱�ע</br>' + @CorssBuMemo+'</td>'
  END
  else
  begin
  set @Rtn+='</td>'
  end

  --Line 15  
  SET @Rtn += '<td class="title">����</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@Attachment) + '</td></tr>'
  
  SET @Rtn += '</table>'
  
 
 
  
  
  --��BU������
  DECLARE @SAPCode NVARCHAR(500) ;
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
  SET @Rtn += '<h4>��BU������</h4><table class="gridtable">'
  SET @Rtn += '<tr><td class="title" width="10%">ҽԺ���</td><td class="title" width="25%">ҽԺ����</td><td class="title" width="10%">�����̱��</td><td class="title" width="25%">����������</td><td class="title" width="10%">BU</td><td class="title" width="10%">SubBU</td><td class="title" width="10%">��������</td></tr>'
  
  OPEN CUR_CROSS_BU
  FETCH NEXT FROM CUR_CROSS_BU INTO @SAPCode,@DealerName,@BUName,@SubBUName,@HospitalCode,@HospitalName,@KpiScore
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
      SET @Rtn += '<tr><td>' + @HospitalCode + '</td><td>' + @HospitalName + '</td><td>' + @SAPCode + '</td><td>' + @DealerName + '</td><td>' + @BUName + '</td><td>' + @SubBUName + '</td><td>' + @KpiScore + '</td></tr>'
      
      FETCH NEXT FROM CUR_CROSS_BU INTO @SAPCode,@DealerName,@BUName,@SubBUName,@HospitalCode,@HospitalName,@KpiScore
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
      SELECT A.DMA_SAP_Code + ' - ' + A.DMA_ChineseName DealerName,
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
  SET @Rtn += '<h4>ͬ��������</h4><table class="gridtable">'
  SET @Rtn += '<tr><td width="25%" class="title">������</td><td width="25%" class="title">�����г�</td><td width="25%" class="title">��Ʒ��</td><td width="25%" class="title">����ƽ̨</td></tr>'
  
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
      SET @Rtn += '<h4>������������</h4><table class="gridtable">'
      SET @Rtn += '<tr><td width="33%" class="title">ԭ��</td><td width="33%" class="title">���������̱��</td><td width="34%" class="title">��������������</td></tr>'
      
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
      SET @Rtn += '<h4>�ϲ����˾�����</h4><table class="gridtable">'
      SET @Rtn += '<tr><td width="10%" class="title">����</td><td width="10%" class="title">���</td><td width="10%" class="title">��ʼ����</td><td width="10%" class="title">��������</td><td width="10%" class="title">Division</td><td width="10%" class="title">SubBU</td><td width="10%" class="title">�����̱��</td><td width="10%" class="title">����������</td><td width="10%" class="title">��ע</td><td width="10%" class="title">������</td></tr>'
      
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
  SET @Rtn += '<h4>CFDA��Ʒ����</h4><table class="gridtable">'
  SET @Rtn += '<tr><td class="title" width="33%">���</td><td class="title" width="33%">�������</td><td class="title" width="34%">��������</td></tr>'
  
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
END
GO


