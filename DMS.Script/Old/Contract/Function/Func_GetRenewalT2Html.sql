
DROP FUNCTION [Contract].[Func_GetRenewalT2Html]
GO


CREATE FUNCTION [Contract].[Func_GetRenewalT2Html]
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
	DECLARE @EName NVARCHAR(200) ;
	DECLARE @ApplicantDepShow NVARCHAR(200) ;
	DECLARE @RequestDate NVARCHAR(200) ;
	DECLARE @CompanyID NVARCHAR(200) ;
	DECLARE @DealerName NVARCHAR(200) ;
	DECLARE @DealerNameShow NVARCHAR(500) ;
	DECLARE @MarketType NVARCHAR(200) ;
	DECLARE @MarketTypeShow NVARCHAR(200) ;
	DECLARE @IsEquipmentShow NVARCHAR(200) ;
	DECLARE @IAF NVARCHAR(200) ;	
	DECLARE @ReagionRSMShow NVARCHAR(200) ;
	DECLARE @AOPTYPE NVARCHAR(200) ;
	DECLARE @PRICEAUTO NVARCHAR(200) ;
	DECLARE @REBATEAUTO NVARCHAR(200) ;
	DECLARE @HospitalType NVARCHAR(200) ;
	DECLARE @IsLP NVARCHAR(200) ;
	
	SELECT @ContractNo = ISNULL(ContractNo, ''),
	       @DealerType = A.DealerType,
	       @DealerTypeShow = dbo.Func_GetCode('CONST_CONTRACT_DealerType', A.DealerType),
	       @DepId = A.DepId,
	       @DepIdShow = ISNULL(B.DepFullName, ''),
	       @SUBDEPID = A.SUBDEPID,
	       @SUBDEPIDShow = ISNULL(C.CC_NameCN, ''),
	       @EName = ISNULL(EName, ''),
	       @ApplicantDepShow = ISNULL(F.DepFullName, ''),
	       @RequestDate = ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), ''),
	       @CompanyID = ISNULL(A.CompanyID, ''),
	       @DealerName = ISNULL(A.DealerName, ''),
	       @DealerNameShow = ISNULL(D.DMA_SAP_Code + ' - ' + D.DMA_ChineseName, ''),
	       @MarketType = MarketType,
	       @MarketTypeShow = dbo.Func_GetCode('CONST_CONTRACT_MarketType', A.MarketType),
	       @IsEquipmentShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsEquipment),
	       @IAF = ISNULL(A.IAF, ''),
	       @ReagionRSMShow = (
	           SELECT TOP 1 T.ManagerName
	           FROM   MDM_Manager T
	           WHERE  A.ReagionRSM = T.EmpNo
	                  AND T.ManagerTitle = 'RSM'
	       ),
	       @AOPTYPE = A.AOPTYPE,
	       @PRICEAUTO = A.PRICEAUTO,
	       @REBATEAUTO = A.REBATEAUTO,
	       @HospitalType = A.HospitalType,
	       @IsLP = A.IsLP
	FROM   [Contract].RenewalMain A
	       LEFT JOIN interface.mdm_department B
	            ON  CONVERT(NVARCHAR(10), A.DepId) = B.DepID
	       LEFT JOIN interface.ClassificationContract C
	            ON  A.SUBDEPID = C.CC_Code
	       LEFT JOIN DealerMaster D
	            ON  A.DealerName = D.DMA_SAP_Code
	       LEFT JOIN interface.mdm_department F
	            ON  CONVERT(NVARCHAR(10), A.ApplicantDep) = F.DepID
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>������Ϣ</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td colspan="6" style="color: red;">ƽ̨��һ�������̣�����Ӣ�����룡</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title" width="13%">���뵥��</td><td colspan="5">' + @ContractNo + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title" width="13%">����������</td><td width="20%">' + @DealerTypeShow + '</td><td class="title" width="13%">��Ʒ��</td><td width="20%">' + @DepIdShow + '</td><td class="title" width="13%">��ͬ����</td><td width="21%">' + @SUBDEPIDShow + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">������</td><td>' + @EName + '</td><td class="title">���벿��</td><td>' + @ApplicantDepShow + '</td><td class="title">��������</td><td>' + @RequestDate + '</td></tr>'
	--Line 5
	SET @Rtn += '<tr><td class="title">������</td><td colspan="3">' + @DealerNameShow + '</td><td class="title">�г�����</td><td>' + @MarketTypeShow + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">�Ƿ�Ϊ�豸������</td><td colspan="5">' + @IsEquipmentShow + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">IAF</td><td colspan="5">' + dbo.Func_GetAttachmentHtml(@IAF) + '</td></tr>'
	--Line 8
	IF @DepId IN ('17', '19', '32', '35')
	BEGIN
	    SET @Rtn += '<tr><td class="title">RSM</td><td colspan="5">' + @ReagionRSMShow + '</td></tr>'
	END
	
	SET @Rtn += '</table>'
	
	--Current
	DECLARE @CurrentContractType NVARCHAR(2000) ;
	DECLARE @CurrentBSC NVARCHAR(2000) ;
	DECLARE @CurrentExclusiveness NVARCHAR(2000) ;
	DECLARE @CurrentAgreementBegin NVARCHAR(2000) ;
	DECLARE @CurrentAgreementEnd NVARCHAR(2000) ;
	DECLARE @CurrentProduct NVARCHAR(2000) ;
	DECLARE @CurrentProductRemark NVARCHAR(2000) ;
	DECLARE @CurrentPrice NVARCHAR(2000) ;
	DECLARE @CurrentPriceRemark NVARCHAR(2000) ;
	DECLARE @CurrentSpecialSales NVARCHAR(2000) ;
	DECLARE @CurrentSpecialSalesRemark NVARCHAR(2000) ;
	DECLARE @CurrentHospital NVARCHAR(2000) ;
	DECLARE @CurrentQuota NVARCHAR(2000) ;
	DECLARE @CurrentQuotaTotal NVARCHAR(2000) ;
	DECLARE @CurrentAttachment NVARCHAR(2000) ;
	
	SELECT @CurrentContractType = ISNULL(A.ContractType, ''),
	       @CurrentBSC = ISNULL(A.BSC, ''),
	       @CurrentExclusiveness = ISNULL(A.Exclusiveness, ''),
	       @CurrentAgreementBegin = ISNULL(CONVERT(NVARCHAR(10), A.AgreementBegin, 121), ''),
	       @CurrentAgreementEnd = ISNULL(CONVERT(NVARCHAR(10), A.AgreementEnd, 121), ''),
	       @CurrentProduct = ISNULL(A.Product, ''),
	       @CurrentProductRemark = ISNULL(A.ProductRemark, ''),
	       @CurrentPrice = ISNULL(A.Price, ''),
	       @CurrentPriceRemark = ISNULL(A.PriceRemark, ''),
	       @CurrentSpecialSales = ISNULL(A.SpecialSales, ''),
	       @CurrentSpecialSalesRemark = ISNULL(A.SpecialSalesRemark, ''),
	       @CurrentHospital = SUBSTRING(A.Hospital, 0, CHARINDEX('<', Hospital)),
	       @CurrentQuota = SUBSTRING(A.Quota, 0, CHARINDEX('<', Hospital)),
	       @CurrentQuotaTotal = ISNULL(CONVERT(NVARCHAR(20), QuotaTotal), ''),
	       @CurrentAttachment = ISNULL(A.Attachment, '')
	FROM   [Contract].RenewalCurrent A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>��ǰЭ������</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="13%">��������</td><td width="20%">' + @CurrentContractType + '</td><td class="title" width="13%">��ͬʵ��</td><td width="20%">' + @CurrentBSC + '</td><td class="title" width="13%">���Һ�ͬ</td><td width="20%">' + @CurrentExclusiveness + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">Э������ Э����Ч��</td><td>' + @CurrentAgreementBegin + '</td><td class="title">Э������ Э�鵽����</td><td colspan="3">' + @CurrentAgreementEnd + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">��Ʒ��</td><td>' + @CurrentProduct + '</td><td class="title">(����ǲ��ֲ�Ʒ�ߣ����г�)</td><td colspan="3">' + @CurrentPriceRemark + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">�۸�<br />��׼�۸��_%���ۿ�</td><td>' + @CurrentPrice + '</td><td class="title">��ע</td><td colspan="3">' + @CurrentPriceRemark + '</td></tr>'
	--Line 5
	SET @Rtn += '<tr><td class="title">���۷�������<br />���Ȳɹ��ܶ��_%</td><td>' + @CurrentSpecialSales + '</td><td class="title">��ע</td><td colspan="3">' + @CurrentSpecialSalesRemark + '</td></tr>'
	--Line 6
	DECLARE @CurrentHospitalUrl NVARCHAR(1000)
	SET @CurrentHospitalUrl = '';
	SET @CurrentHospitalUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?';
	SET @CurrentHospitalUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @CurrentHospitalUrl += '&DivisionID=' + @DepId;
	SET @CurrentHospitalUrl += '&PartsContractCode=' + @SUBDEPID;
	SET @CurrentHospitalUrl += '&DealerID=' + @CompanyID;
	SET @CurrentHospitalUrl += '&IsEmerging=' + @MarketType;
	SET @CurrentHospitalUrl += '&AOPType=' + @AOPTYPE;
	SET @CurrentHospitalUrl += '&NeedAuth=True';
	IF (@HospitalType = '0')
	BEGIN
	    SET @CurrentHospitalUrl += '&PageId=9';
	END
	ELSE
	BEGIN
	    SET @CurrentHospitalUrl += '&PageId=10';
	END
	
	DECLARE @CurrentQuotaUrl NVARCHAR(1000)
	SET @CurrentQuotaUrl = '';
	SET @CurrentQuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?';
	SET @CurrentQuotaUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @CurrentQuotaUrl += '&DivisionID=' + @DepId;
	SET @CurrentQuotaUrl += '&PartsContractCode=' + @SUBDEPID;
	SET @CurrentQuotaUrl += '&DealerID=' + @CompanyID;
	SET @CurrentQuotaUrl += '&DealerType=' + @DealerType;
	SET @CurrentQuotaUrl += '&EffectiveDate=' + @CurrentAgreementBegin;
	SET @CurrentQuotaUrl += '&ExpirationDate=' + @CurrentAgreementEnd;
	SET @CurrentQuotaUrl += '&IsEmerging=' + @MarketType;
	SET @CurrentQuotaUrl += '&AOPType=' + @AOPTYPE;
	SET @CurrentQuotaUrl += '&NeedAuth=True';
	SET @CurrentQuotaUrl += '&PageId=11';
	
	SET @Rtn += '<tr><td class="title">����(ҽԺ)</td><td>' + @CurrentHospital + '&nbsp;<a href="' + @CurrentHospitalUrl + '" target="_blank">�鿴</a></td><td class="title">�ɹ�ָ��(CNY)<br />(BSC SFX Rate:USD 1 = CNY 6.69)</td><td colspan="3">' + @CurrentQuota + '&nbsp;<a href="' + @CurrentQuotaUrl + '" target="_blank">�鿴</a></td></tr>'
	SET @Rtn += '<tr><td class="title">ָ���ܶ�(CNY)����˰</td><td colspan="5">' + @CurrentQuotaTotal + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">����</td><td colspan="5">' + dbo.Func_GetAttachmentHtml(@CurrentAttachment) + '</td></tr>'
	
	SET @Rtn += '</table>'
	
	--Proposals
	DECLARE @ContractType NVARCHAR(2000) ;
	DECLARE @BSC NVARCHAR(2000) ;
	DECLARE @Exclusiveness NVARCHAR(2000) ;
	DECLARE @AgreementBegin NVARCHAR(2000) ;
	DECLARE @AgreementEnd NVARCHAR(2000) ;
	DECLARE @Product NVARCHAR(2000) ;
	DECLARE @ProductRemark NVARCHAR(2000) ;
	DECLARE @Price NVARCHAR(2000) ;
	DECLARE @PriceRemark NVARCHAR(2000) ;
	DECLARE @SpecialSales NVARCHAR(2000) ;
	DECLARE @SpecialSalesRemark NVARCHAR(2000) ;
	DECLARE @Hospital NVARCHAR(2000) ;
	DECLARE @Quota NVARCHAR(2000) ;
	DECLARE @QuotaTotal NVARCHAR(2000) ;
	DECLARE @QUOTAUSD NVARCHAR(2000) ;
	DECLARE @AllProductAop NVARCHAR(2000) ;
	DECLARE @AllProductAopUSD NVARCHAR(2000) ;
	DECLARE @DealerLessHosReason NVARCHAR(2000) ;
	DECLARE @DealerLessHosReasonQ NVARCHAR(2000) ;
	DECLARE @DealerLessHosQ NVARCHAR(2000) ;
	DECLARE @DealerLessHosQRemark NVARCHAR(2000) ;
	DECLARE @HosLessStandardReason NVARCHAR(2000) ;
	DECLARE @HosLessStandardReasonQ NVARCHAR(2000) ;
	DECLARE @HosLessStandardQ NVARCHAR(2000) ;
	DECLARE @HosLessStandardQRemark NVARCHAR(2000) ;
	DECLARE @Attachment NVARCHAR(2000) ;
	DECLARE @ISVAT NVARCHAR(2000) ;
	DECLARE @ProductGroupCheck NVARCHAR(10);
	DECLARE @ProductGroupRemark NVARCHAR(2000);
	DECLARE @ProductGroupMemo NVARCHAR(2000);	
	
	SELECT @ContractType = ISNULL(A.ContractType, ''),
	       @BSC = ISNULL(A.BSC, ''),
	       @Exclusiveness = ISNULL(A.Exclusiveness, ''),
	       @AgreementBegin = CONVERT(NVARCHAR(10), A.AgreementBegin, 121),
	       @AgreementEnd = CONVERT(NVARCHAR(10), A.AgreementEnd, 121),
	       @Product = dbo.Func_GetCode('CONST_CONTRACT_ProposalsProduct', A.Product),
	       @ProductRemark = ISNULL(ProductRemark, ''),
	       @Price = ISNULL(Price, ''),
	       @PriceRemark = ISNULL(PriceRemark, ''),
	       @SpecialSales = ISNULL(SpecialSales, ''),
	       @SpecialSalesRemark = ISNULL(SpecialSalesRemark, ''),
	       @Hospital = SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)),
	       @Quota = SUBSTRING(Quota, 0, CHARINDEX('<', Quota)),
	       @QuotaTotal = CONVERT(NVARCHAR(20), QuotaTotal),
	       @QUOTAUSD = CONVERT(NVARCHAR(20), QUOTAUSD),
	       @AllProductAop = CONVERT(NVARCHAR(20), AllProductAop),
	       @AllProductAopUSD = CONVERT(NVARCHAR(20), AllProductAopUSD),
	       @DealerLessHosQ = ISNULL(DealerLessHosQ, ''),
	       @DealerLessHosReason = ISNULL(DealerLessHosReason, ''),
	       @DealerLessHosReasonQ = ISNULL(DealerLessHosReasonQ, ''),
	       @DealerLessHosQRemark = ISNULL(DealerLessHosQRemark, ''),
	       @HosLessStandardQ = ISNULL(HosLessStandardQ, ''),
	       @HosLessStandardReason = ISNULL(HosLessStandardReason, ''),
	       @HosLessStandardReasonQ = ISNULL(HosLessStandardReasonQ, ''),
	       @HosLessStandardQRemark = ISNULL(HosLessStandardQRemark, ''),
	       @Attachment = ISNULL(Attachment, ''),
	       @ProductGroupCheck = ISNULL(ProductGroupCheck, 0),
	       @ProductGroupRemark = ISNULL(ProductGroupRemark, ''),
	       @ProductGroupMemo = ISNULL(ProductGroupMemo, ''),
	       @ISVAT = ISNULL(ISVAT, '')
	FROM   [Contract].RenewalProposals A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>��Լ��Э������</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">��������</td><td width="25%">' + @ContractType + '</td><td class="title" width="25%">��ͬʵ��</td><td width="25%">' + @BSC + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">���Һ�ͬ</td><td colspan="3">' + @Exclusiveness + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">Э������(Э����Ч��)</td><td>' + @AgreementBegin + '</td><td class="title">Э������(Э�鵽����)</td><td>' + @AgreementEnd + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">��Ʒ��</td><td>' + @Product + '</td><td class="title">(����ǲ��ֲ�Ʒ�ߣ����г�)</td><td>' + @ProductRemark + '</td></tr>'
	--Line 5
	SET @Rtn += '<tr><td class="title">�۸�<br/>��׼�۸��_%���ۿ�</td><td>' + @Price + '</td><td class="title">��ע</td><td>' + @PriceRemark + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">���۷�������<br/>���Ȳɹ��ܶ��_%</td><td>' + @SpecialSales + '</td><td class="title">��ע</td><td>' + @SpecialSalesRemark + '</td></tr>'
	--Line 7
	DECLARE @HospitalUrl NVARCHAR(1000)
	SET @HospitalUrl = '';
	SET @HospitalUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?ContractType=Renewal';
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
	SET @QuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?ContractType=Renewal';
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
	
	SET @Rtn += '<tr><td class="title">����(ҽԺ)</td><td>' + @Hospital + '&nbsp;<a href="' + @HospitalUrl + '" target="_blank">�鿴</a><br/><a href="' + @AuthUrl + '" target="_blank"><h4>��Ȩ��ϸ�б�</h4></a></td><td class="title">�ɹ�ָ��(CNY)<br/>(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>' + @Quota + '&nbsp;<a href="' + @QuotaUrl + '" target="_blank">�鿴</a></td></tr>'
	--Line 8
	SET @Rtn += '<tr><td class="title">ָ���ܶ�(CNY)����˰</td><td>' + @QuotaTotal + '</td><td class="title">ָ���ܶ�(USD)����˰</td><td>' + @QUOTAUSD + '</td></tr>'
	--Line 10
    SET @Rtn += '<tr><td class="title">�������ܼƲɹ�ָ��С���ܼ�ҽԺָ���ԭ��</td><td >' + @DealerLessHosReason 
	
	if @DealerLessHosQ = '0'
	begin
	SET @Rtn += +@DealerLessHosQRemark+'</td>'
	end
	else 
	begin
		SET @Rtn +='</td>'
	end
	SET @Rtn+='<td class="title">�����̼���ָ��С��ҽԺ����ָ���ԭ�� </td><td>' + @DealerLessHosReasonQ + '</td></tr>'
	--Line 14
   SET @Rtn += '<tr><td class="title">�ܼ�ҽԺʵ��ָ��С���ܼ�ҽԺ��׼ָ���ԭ�� </td><td >' + @HosLessStandardReason 
	IF @HosLessStandardQ = '0'
	BEGIN
	    SET @Rtn += + @HosLessStandardQRemark +'</td>'
	END
	else 
	begin
	   SET @Rtn +='</td>'
	   end
	
	SET @Rtn +='<td class="title" >�ܼ�ҽԺʵ��ָ��С���ܼ�ҽԺ��׼ָ���ԭ�� </td><td>' + @HosLessStandardReasonQ 
	--Line 17
	
	
	IF @ProductGroupCheck = '0'
	BEGIN
	   SET @Rtn += + @ProductGroupRemark +'</td></tr>'
	END
	else 
	begin
	   SET @Rtn +='</td></tr>'
	   end
	   
	
	SET @Rtn += '<tr><td class="title">��Ʒ����Сָ�걸ע</td><td>' + @ProductGroupMemo + '</td><td class="title">����</td><td>' + dbo.Func_GetAttachmentHtml(@Attachment) + '</td></tr>'
	--Line 16

	
	SET @Rtn += '</table>'
	
	--������
	DECLARE @Conflict NVARCHAR(100) ;
	DECLARE @ConflictShow NVARCHAR(100) ;
	DECLARE @ConflictRemark NVARCHAR(2000) ;
	DECLARE @Handover NVARCHAR(100) ;
	DECLARE @HandoverShow NVARCHAR(100) ;
	DECLARE @HandoverRemark NVARCHAR(2000) ;
	
	SELECT @Conflict = ISNULL(A.Conflict, ''),
	       @ConflictShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Conflict),
	       @ConflictRemark = ISNULL(A.ConflictRemark, ''),
	       @Handover = ISNULL(A.Handover, ''),
	       @HandoverShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Handover),
	       @HandoverRemark = ISNULL(A.HandoverRemark, '')
	FROM   [Contract].RenewalNCM A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>����</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">1.) �������ҵ��ƻ������ӵ�ǰ������Э��Ĳ�Ʒ�߻�������ô�����κ��������о����̵Ķ���Э�������ͻ�𣿻��ǻ����κ�������������Ǳ�ڳ�ͻ��</td><td>' + @ConflictShow + '</td></tr>'
	--Line 2
	IF @Conflict = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">����ǣ���˵��</td><td>' + @ConflictRemark + '</td></tr>'
	END
	--Line 3
	SET @Rtn += '<tr><td class="title">2.) �������ҵ��ƻ���������ǰ������Э��Ĳ�Ʒ�߻�����˭���ӹ����������������ҵ��</td><td>' + @HandoverShow + '</td></tr>'
	--Line 3
	IF @Handover = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">����ǣ���˵��</td><td>' + @HandoverRemark + '</td></tr>'
	END
	
	SET @Rtn += '</table>' 
	
	--��ʷKPI
	DECLARE @KpiYear NVARCHAR(500) ;
	DECLARE @KpiQuarter NVARCHAR(500) ;
	DECLARE @KpiMonth NVARCHAR(500) ;
	DECLARE @KpiDivision NVARCHAR(500) ;
	DECLARE @KpiSubBUName NVARCHAR(500) ;
	DECLARE @KpiTotalScore NVARCHAR(500) ;
	
	DECLARE CUR_KPI CURSOR  
	FOR
	    SELECT A.Column1 [Year],
	           A.Column2 [Quarter],
	           A.Column3 [Month],
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
	               ) ORDER BY A.Column5,A.Column7, A.Column1,A.Column2
	
	--Head
	SET @Rtn += '<h4>��ʷKPI</h4><table class="gridtable">'
	SET @Rtn += '<tr><td class="title" width="19%">���</td><td class="title" width="19%">����</td><td class="title" width="20%">Division</td><td class="title" width="21%">Sub BU</td><td class="title" width="21%">�ܷ�</td></tr>'
	OPEN CUR_KPI
	FETCH NEXT FROM CUR_KPI INTO @KpiYear,@KpiQuarter,@KpiMonth,@KpiDivision,@KpiSubBUName,@KpiTotalScore
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @Rtn += '<tr><td>' + @KpiYear + '</td><td>' + @KpiQuarter + '</td><td>' + @KpiDivision + '</td><td>' + @KpiSubBUName + '</td><td>' + @KpiTotalScore + '</td></tr>'
	    
	    FETCH NEXT FROM CUR_KPI INTO @KpiYear,@KpiQuarter,@KpiMonth,@KpiDivision,@KpiSubBUName,@KpiTotalScore
	END
	CLOSE CUR_KPI
	DEALLOCATE CUR_KPI
	
	SET @Rtn += '</table>'
	
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
	
	--�����ļ�
	SET @Rtn += [Contract].Func_GetQualificationFileHtml(@CompanyID);
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


