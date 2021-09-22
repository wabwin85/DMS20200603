
DROP FUNCTION [Contract].[Func_GetAmendmentT2Html]
GO


CREATE FUNCTION [Contract].[Func_GetAmendmentT2Html]
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
	DECLARE @DealerBeginDate NVARCHAR(200) ;
	DECLARE @DealerEndDate NVARCHAR(200) ;
	DECLARE @AmendEffectiveDate NVARCHAR(200) ;
	DECLARE @Purpose NVARCHAR(500) ;
	DECLARE @IsEquipmentShow NVARCHAR(200) ;	
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
	       @DealerBeginDate = ISNULL(CONVERT(NVARCHAR(10), DealerBeginDate, 121), ''),
	       @DealerEndDate = ISNULL(CONVERT(NVARCHAR(10), DealerEndDate, 121), ''),
	       @AmendEffectiveDate = ISNULL(CONVERT(NVARCHAR(10), AmendEffectiveDate, 121), ''),
	       @Purpose = A.Purpose,
	       @IsEquipmentShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsEquipment),
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
	FROM   [Contract].AmendmentMain A
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
	SET @Rtn += '<h4>申请信息</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td colspan="6" style="color: red;">平台和一级经销商，请用英文输入！</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td width="13%" class="title">申请单号</td><td colspan="5">' + @ContractNo + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td width="13%" class="title">经销商类型</td><td width="20%">' + @DealerTypeShow + '</td><td width="13%" class="title">产品线</td><td width="20%">' + @DepIdShow + '</td><td width="13%" class="title">合同分类</td><td width="21%">' + @SUBDEPIDShow + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">申请人</td><td>' + @EName + '</td><td class="title">申请部门</td><td>' + @ApplicantDepShow + '</td><td class="title">申请日期</td><td>' + @RequestDate + '</td></tr>'
	--Line 5
	SET @Rtn += '<tr><td class="title">经销商</td><td colspan="3">' + @DealerNameShow + '</td><td class="title">市场类型</td><td>' + @MarketTypeShow + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">原协议生效日</td><td>' + @DealerBeginDate + '</td><td class="title">原协议到期日</td><td>' + @DealerEndDate + '</td><td class="title">修改生效日</td><td>' + @AmendEffectiveDate + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">修改原因</td><td colspan="3">' + @Purpose + '</td><td class="title">是否为设备经销商</td><td>' + @IsEquipmentShow + '</td></tr>'
	--Line 8
	IF @DepId IN ('17', '19', '32', '35')
	BEGIN
	    SET @Rtn += '<tr><td class="title">RSM</td><td>' + @ReagionRSMShow + '</td><td colspan="4">&nbsp;</td></tr>'
	END
	
	SET @Rtn += '</table>'
	
	--Current
	DECLARE @ProductAmend NVARCHAR(200) ;
	DECLARE @ProductAmendShow NVARCHAR(200) ;
	DECLARE @CurrentProduct NVARCHAR(4000) ;
	DECLARE @PriceAmend NVARCHAR(200) ;
	DECLARE @PriceAmendShow NVARCHAR(200) ;
	DECLARE @CurrentPrice NVARCHAR(4000) ;
	DECLARE @SalesAmend NVARCHAR(200) ;
	DECLARE @SalesAmendShow NVARCHAR(200) ;
	DECLARE @CurrentSpecialSales NVARCHAR(4000) ;
	DECLARE @HospitalAmend NVARCHAR(200) ;
	DECLARE @HospitalAmendShow NVARCHAR(200) ;
	DECLARE @CurrentHospital NVARCHAR(4000) ;
	DECLARE @QuotaAmend NVARCHAR(200) ;
	DECLARE @QuotaAmendShow NVARCHAR(200) ;
	DECLARE @CurrentQuota NVARCHAR(4000) ;
	DECLARE @PaymentAmend NVARCHAR(200) ;
	DECLARE @PaymentAmendShow NVARCHAR(200) ;
	DECLARE @CurrentPayment NVARCHAR(2000) ;
	DECLARE @CurrentAttachment NVARCHAR(200) ;	    
	
	SELECT @ProductAmend = ISNULL(ProductAmend, ''),
	       @ProductAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.ProductAmend),
	       @CurrentProduct = ISNULL(Product, ''),
	       @PriceAmend = ISNULL(PriceAmend, ''),
	       @PriceAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.PriceAmend),
	       @CurrentPrice = ISNULL(Price, ''),
	       @SalesAmend = ISNULL(SalesAmend, ''),
	       @SalesAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.SalesAmend),
	       @CurrentSpecialSales = ISNULL(SpecialSales, ''),
	       @HospitalAmend = ISNULL(HospitalAmend, ''),
	       @HospitalAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.HospitalAmend),
	       @CurrentHospital = SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)),
	       @QuotaAmend = ISNULL(QuotaAmend, ''),
	       @QuotaAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.QuotaAmend),
	       @CurrentQuota = SUBSTRING(Quota, 0, CHARINDEX('<', Quota)),
	       @PaymentAmend = ISNULL(PaymentAmend, ''),
	       @PaymentAmendShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.PaymentAmend),
	       @CurrentPayment = ISNULL(Payment, ''),
	       @CurrentAttachment = ISNULL(Attachment, '')
	FROM   [Contract].AmendmentCurrent A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>当前协议条款</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">是否变更</td><td width="25%">' + @ProductAmendShow + '</td><td class="title" width="25%">产品线</td><td width="25%">' + @CurrentProduct + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">是否变更</td><td>' + @PriceAmendShow + '</td><td class="title">价格</td><td>' + @CurrentPrice + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">是否变更</td><td>' + @SalesAmendShow + '</td><td class="title">销售返利政策</td><td>' + @CurrentSpecialSales + '</td></tr>'
	--Line 4
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
	
	SET @Rtn += '<tr><td class="title">是否变更</td><td>' + @HospitalAmendShow + '</td><td class="title">区域(医院)</td><td>' + @CurrentHospital + '&nbsp;<a href="' + @CurrentHospitalUrl + '" target="_blank">查看</a></td></tr>'
	--Line 5	
	DECLARE @CurrentQuotaUrl NVARCHAR(1000)
	SET @CurrentQuotaUrl = '';
	SET @CurrentQuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?';
	SET @CurrentQuotaUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @CurrentQuotaUrl += '&DivisionID=' + @DepId;
	SET @CurrentQuotaUrl += '&PartsContractCode=' + @SUBDEPID;
	SET @CurrentQuotaUrl += '&DealerID=' + @CompanyID;
	SET @CurrentQuotaUrl += '&DealerType=' + @DealerType;
	SET @CurrentQuotaUrl += '&EffectiveDate=' + @AmendEffectiveDate;
	SET @CurrentQuotaUrl += '&ExpirationDate=' + @DealerEndDate;
	SET @CurrentQuotaUrl += '&IsEmerging=' + @MarketType;
	SET @CurrentQuotaUrl += '&AOPType=' + @AOPTYPE;
	SET @CurrentQuotaUrl += '&NeedAuth=True';
	SET @CurrentQuotaUrl += '&PageId=11';
	
	SET @Rtn += '<tr><td class="title">是否变更</td><td>' + @QuotaAmendShow + '</td><td class="title">采购指标(CNY)<br />(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>' + @CurrentQuota + '&nbsp;<a href="' + @CurrentQuotaUrl + '" target="_blank">查看</a></td></td></tr>'
	--Line 6
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<td class="title">是否变更</td><td>' + @PaymentAmendShow + '</td><td class="title">付款方式</td><td>' + @CurrentPayment + '</td></tr>'
	END
	--Line 7
	SET @Rtn += '<tr><td class="title">附件</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@CurrentAttachment) + '</td></tr>'
	
	SET @Rtn += '</table>'
	
	--Proposals
	DECLARE @Product NVARCHAR(100) ;
	DECLARE @ProductRemark NVARCHAR(2000) ;
	DECLARE @Price NVARCHAR(50) ;
	DECLARE @PriceRemark NVARCHAR(4000) ;
	DECLARE @SpecialSales NVARCHAR(50) ;
	DECLARE @SpecialSalesRemark NVARCHAR(4000) ;
	DECLARE @Hospital NVARCHAR(2000) ;
	DECLARE @Quota NVARCHAR(2000) ;
	DECLARE @QuotaTotal NVARCHAR(20) ;
	DECLARE @QUOTAUSD NVARCHAR(20) ;
	DECLARE @Payment NVARCHAR(20) ;
	DECLARE @PaymentShow NVARCHAR(200) ;
	DECLARE @Comment NVARCHAR(300) ;
	DECLARE @CreditTerm NVARCHAR(50) ;
	DECLARE @CreditTermShow NVARCHAR(200) ;
	DECLARE @CreditLimit NVARCHAR(200) ;
	DECLARE @Deposit NVARCHAR(200) ;
	DECLARE @Inform NVARCHAR(100) ;
	DECLARE @InformShow NVARCHAR(500) ;
	DECLARE @InformOther NVARCHAR(500) ;
	DECLARE @DealerLessHosQ NVARCHAR(20) ;
	DECLARE @DealerLessHosReason NVARCHAR(200) ;
	DECLARE @DealerLessHosReasonQ NVARCHAR(200) ;
	DECLARE @DealerLessHosQRemark NVARCHAR(1000) ;
	DECLARE @HosLessStandardQ NVARCHAR(1000) ;
	DECLARE @HosLessStandardReason NVARCHAR(200) ;
	DECLARE @HosLessStandardReasonQ NVARCHAR(200) ;
	DECLARE @HosLessStandardQRemark NVARCHAR(1000) ;
	DECLARE @ChangeQuarter NVARCHAR(200) ;
	DECLARE @ChangeQuarterShow NVARCHAR(200) ;
	DECLARE @ChangeReason NVARCHAR(200) ;
	DECLARE @Attachment NVARCHAR(1000) ;
	DECLARE @ISVAT NVARCHAR(200) ;
	DECLARE @QUATOUP INT ;
	DECLARE @ProductGroupCheck NVARCHAR(200) ;
	DECLARE @ProductGroupRemark NVARCHAR(2000) ;
	DECLARE @ProductGroupMemo NVARCHAR(2000) ;
	
	SELECT @Product = dbo.Func_GetCode('CONST_CONTRACT_ProposalsProduct', A.Product),
	       @ProductRemark = ISNULL(ProductRemark, ''),
	       @Price = ISNULL(Price, ''),
	       @PriceRemark = ISNULL(PriceRemark, ''),
	       @SpecialSales = ISNULL(SpecialSales, ''),
	       @SpecialSalesRemark = ISNULL(SpecialSalesRemark, ''),
	       @Hospital = ISNULL(SUBSTRING(Hospital, 0, CHARINDEX('<', Hospital)), ''),
	       @Quota = ISNULL(SUBSTRING(Quota, 0, CHARINDEX('<', Quota)), ''),
	       @QuotaTotal = ISNULL(CONVERT(NVARCHAR(20), QuotaTotal), ''),
	       @QUOTAUSD = ISNULL(CONVERT(NVARCHAR(20), QUOTAUSD), ''),
	       @Payment = ISNULL(Payment, ''),
	       @PaymentShow = dbo.Func_GetCode('CONST_CONTRACT_Payment', A.Payment),
	       @Comment = ISNULL(Comment, ''),
	       @CreditTerm = ISNULL(CreditTerm, ''),
	       @CreditTermShow = dbo.Func_GetCode('CONST_CONTRACT_CreditTerm', A.CreditTerm),
	       @CreditLimit = ISNULL(CreditLimit, ''),
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
	       @ProductGroupCheck = ISNULL(ProductGroupCheck, ''),
	       @ProductGroupRemark = ISNULL(ProductGroupRemark, ''),
	       @ProductGroupMemo = ISNULL(ProductGroupMemo, ''),
	       @ChangeQuarter = ISNULL(ChangeQuarter, ''),
	       @ChangeQuarterShow = dbo.Func_GetCode('CONST_CONTRACT_ChangeQuarter', A.ChangeQuarter),
	       @ChangeReason = ISNULL(ChangeReason, ''),
	       @Attachment = ISNULL(Attachment, ''),
	       @ISVAT = ISNULL(ISVAT, ''),
	       @QUATOUP = ISNULL(QUATOUP, '')
	FROM   [Contract].AmendmentProposals A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>修改后协议条款</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">产品线</td><td width="25%">' + @Product + '</td><td class="title" width="25%">(如果是部分产品线，请列出)</td><td width="25%">' + @ProductRemark + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">价格<br/>标准价格的_%的折扣</td><td>' + @Price + '</td><td class="title">备注</td><td>' + @PriceRemark + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">销售返利政策<br/>季度采购总额的_%</td><td>' + @SpecialSales + '</td><td class="title">备注</td><td>' + @SpecialSalesRemark + '</td></tr>'
	--Line 4
	DECLARE @HospitalUrl NVARCHAR(1000)
	SET @HospitalUrl = '';
	SET @HospitalUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?ContractType=Amendment';
	SET @HospitalUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @HospitalUrl += '&DivisionID=' + @DepId;
	SET @HospitalUrl += '&PartsContractCode=' + @SUBDEPID;
	SET @HospitalUrl += '&TempDealerID=' + @CompanyID;
	SET @HospitalUrl += '&DealerType=' + @DealerType;
	SET @HospitalUrl += '&EffectiveDate=' + @AmendEffectiveDate;
	SET @HospitalUrl += '&ExpirationDate=' + @DealerEndDate;
	SET @HospitalUrl += '&IsEmerging=' + @MarketType;
	SET @HospitalUrl += '&IsArea=' + @IsLP;
	SET @HospitalUrl += '&ProductAmend=1' + @ProductAmend;
	SET @HospitalUrl += '&NeedAuth=True';
	SET @HospitalUrl += '&PageId=2';
	
	DECLARE @QuotaUrl NVARCHAR(1000)
	SET @QuotaUrl = '';
	SET @QuotaUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'API.aspx?ContractType=Amendment';
	SET @QuotaUrl += '&InstanceID=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @QuotaUrl += '&DivisionID=' + @DepId;
	SET @QuotaUrl += '&PartsContractCode=' + @SUBDEPID;
	SET @QuotaUrl += '&TempDealerID=' + @CompanyID;
	SET @QuotaUrl += '&DealerType=' + @DealerType;
	SET @QuotaUrl += '&EffectiveDate=' + @AmendEffectiveDate;
	SET @QuotaUrl += '&ExpirationDate=' + @DealerEndDate;
	SET @QuotaUrl += '&IsEmerging=' + @MarketType;
	SET @QuotaUrl += '&AOPType=' + @AOPTYPE;
	SET @QuotaUrl += '&NeedAuth=True';
	SET @QuotaUrl += '&PageId=4';
	
	DECLARE @AuthUrl NVARCHAR(1000);
	SET @AuthUrl = '';
	SET @AuthUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/AuthList.aspx?ContractId=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @AuthUrl += '&SUBDEPID=' + @SUBDEPID;
	SET @AuthUrl += '&IsLP=' + @IsLP;
	SET @AuthUrl += '&AgreementBegin=' + @AmendEffectiveDate;
	
	SET @Rtn += '<tr><td class="title">区域(医院)</td><td>' + @Hospital + '&nbsp;<a href="' + @HospitalUrl + '" target="_blank">查看</a><br/><a href="' + @AuthUrl + '" target="_blank"><h4>授权明细列表</h4></a></td><td class="title">采购指标(CNY)<br/>(BSC SFX Rate:USD 1 = CNY 6.69)</td><td>' + @Quota + '&nbsp;<a href="' + @QuotaUrl + '" target="_blank">查看</a></td></tr>'
	--Line 5
	SET @Rtn += '<tr><td class="title">指标总额(CNY)不含税</td><td>' + @QuotaTotal + '</td><td class="title">指标总额(USD)不含税</td><td>' + @QUOTAUSD + '</td></tr>'
	--Line 13
	--SET @Rtn += '<tr><td class="title">经销商总计采购指标小于总计医院指标的原因</td><td colspan="3">' + @DealerLessHosReason + '</td></tr>'
	--Line 14
	IF @DealerLessHosQ = '0'
	BEGIN
		SET @Rtn += '<tr><td class="title">经销商总计采购指标小于总计医院指标的原因</td><td>' + @DealerLessHosReason + '</td><td colspan="2">' + @DealerLessHosQRemark + '</td></tr>'
	 
	END
	ELSE
	BEGIN
		SET @Rtn += '<tr><td class="title">经销商总计采购指标小于总计医院指标的原因</td><td colspan="3">' + @DealerLessHosReason + '</td></tr>'
	END
	
	--Line 15
	SET @Rtn += '<tr><td class="title">经销商季度指标小于医院季度指标的原因</td><td>' + @DealerLessHosReasonQ + '</td><td class="title">医院实际指标小于医院标准指标的原因</td><td>' + @HosLessStandardReason + '</td></tr>'
	
	--Line 17
	IF @HosLessStandardQ = '0'
	BEGIN
	    SET @Rtn += '<tr><td colspan="4">' + @HosLessStandardQRemark + '</td></tr>'
	END
	--Line 18
	--SET @Rtn += '<tr><td class="title">医院实际季度指标小于医院标准季度指标的原因</td><td colspan="3">' + @HosLessStandardReasonQ + '</td></tr>'
	--Line 14
	IF @ProductGroupCheck = '0'
	BEGIN
		SET @Rtn += '<tr><td class="title">医院实际季度指标小于医院标准季度指标的原因</td><td>' + @HosLessStandardReasonQ + '</td><td colspan="2">' + @ProductGroupRemark + '</td></tr>'
	END
	ELSE
	BEGIN
		SET @Rtn += '<tr><td class="title">医院实际季度指标小于医院标准季度指标的原因</td><td colspan="3">' + @HosLessStandardReasonQ + '</td></tr>'
	END
	
	SET @Rtn += '<tr><td class="title">产品组最小指标备注</td><td colspan="3">' + @ProductGroupRemark + '</td></tr>'
	--Line 18
	SET @Rtn += '<tr><td class="title">当季指标更改原因</td><td>' + @ChangeQuarterShow + '</td><td class="title">当季指标更改的详细原因</td><td>' + @ChangeReason + '</td></tr>'
	--Line 17
	SET @Rtn += '<tr><td class="title">附件</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@Attachment) + '</td></tr>'
	
	SET @Rtn += '</table>'
	
	--·其他
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
	FROM   [Contract].AmendmentNCM A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>其他</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">1.) 如果以上业务计划书增加当前经销商协议的产品线或区域，那么会与任何其他现有经销商的独家协议条款冲突吗？还是会与任何新任命经销商潜在冲突？</td><td>' + @ConflictShow + '</td></tr>'
	--Line 2
	IF @Conflict = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">如果是，请说明</td><td>' + @ConflictRemark + '</td></tr>'
	END
	--Line 3
	SET @Rtn += '<tr><td class="title">2.) 如果以上业务计划书削减当前经销商协议的产品线或区域，谁将接管这个经销商削减的业务？</td><td>' + @HandoverShow + '</td></tr>'
	--Line 3
	IF @Handover = '1'
	BEGIN
	    SET @Rtn += '<tr><td class="title">如果是，请说明</td><td>' + @HandoverRemark + '</td></tr>'
	END
	
	SET @Rtn += '</table>' 
	
	--历史KPI
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
	               )
	               ORDER BY A.Column5,A.Column7, A.Column1,A.Column2
	
	--Head
	SET @Rtn += '<h4>历史KPI</h4><table class="gridtable">'
	SET @Rtn += '<tr><td class="title" width="19%">年份</td><td class="title" width="19%">季度</td><td class="title" width="20%">Division</td><td class="title" width="21%">Sub BU</td><td class="title" width="21%">总分</td></tr>'
	
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
	SET @Rtn += '<h4>CFDA产品分类</h4><table class="gridtable">'
	SET @Rtn += '<tr><td class="title" width="33%">类别</td><td class="title" width="33%">分类代码</td><td class="title" width="34%">分类名称</td></tr>'
	
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
	
	--资质文件
	SET @Rtn += [Contract].Func_GetQualificationFileHtml(@CompanyID);
	
	/*
	DECLARE @AuthUrl NVARCHAR(1000);
	SET @AuthUrl = '';
	SET @AuthUrl += dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/PagesEwf/Contract/AuthList.aspx?ContractId=' + CONVERT(NVARCHAR(100), @ContractId);
	SET @AuthUrl += '&SUBDEPID=' + @SUBDEPID;
	SET @AuthUrl += '&IsLP=' + @IsLP;
	SET @AuthUrl += '&AgreementBegin=' + @AmendEffectiveDate;
	
	SET @Rtn += '<a href="' + @AuthUrl + '" target="_blank"><h4>授权明细列表</h4></a>'
	*/
	RETURN ISNULL(@Rtn, '')
END
GO


