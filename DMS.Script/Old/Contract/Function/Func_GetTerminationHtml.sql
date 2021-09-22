DROP FUNCTION [Contract].[Func_GetTerminationHtml]
GO


CREATE FUNCTION [Contract].[Func_GetTerminationHtml]
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
	DECLARE @DepId NVARCHAR(200) ;
	DECLARE @DepIdShow NVARCHAR(200) ;
	DECLARE @SUBDEPID NVARCHAR(200) ;
	DECLARE @SUBDEPIDShow NVARCHAR(200) ;
	DECLARE @EName NVARCHAR(200) ;
	DECLARE @RequestDate NVARCHAR(200) ;
	DECLARE @ApplicantDepShow NVARCHAR(200) ;
	DECLARE @MarketTypeShow NVARCHAR(200) ;
	DECLARE @DealerType NVARCHAR(200) ;
	DECLARE @DealerTypeShow NVARCHAR(200) ;
	DECLARE @DealerName NVARCHAR(500) ;
	DECLARE @DealerNameShow NVARCHAR(500) ;
	DECLARE @DealerBeginDate NVARCHAR(200) ;
	DECLARE @DealerEndDate NVARCHAR(200) ;
	DECLARE @DealerEndTypShow NVARCHAR(200) ;
	DECLARE @PlanExpiration NVARCHAR(200) ;
	DECLARE @DealerEndReason NVARCHAR(200) ;
	DECLARE @DealerEndReasonShow NVARCHAR(200) ;
	DECLARE @OtherReason NVARCHAR(200) ;
	DECLARE @IAF NVARCHAR(200) ;
	DECLARE @ReagionRSMShow NVARCHAR(200) ;
	DECLARE @Quotatotal NVARCHAR(200) ;
	DECLARE @QUOTAUSD NVARCHAR(200) ;
	
	SELECT @ContractNo = ISNULL(ContractNo, ''),
	       @DepId = A.DepId,
	       @DepIdShow = ISNULL(B.DepFullName, ''),
	       @SUBDEPID = A.SUBDEPID,
	       @SUBDEPIDShow = ISNULL(C.CC_NameCN, ''),
	       @EName = ISNULL(EName, ''),
	       @RequestDate = ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), ''),
	       @ApplicantDepShow = ISNULL(F.DepFullName, ''),
	       @MarketTypeShow = dbo.Func_GetCode('CONST_CONTRACT_MarketType', A.MarketType),
	       @DealerType = A.DealerType,
	       @DealerTypeShow = dbo.Func_GetCode('CONST_CONTRACT_DealerType', A.DealerType),
	       @DealerName = ISNULL(A.DealerName, ''),
	       @DealerNameShow = ISNULL(D.DMA_SAP_Code + ' - ' + D.DMA_ChineseName, ''),
	       @DealerBeginDate = ISNULL(CONVERT(NVARCHAR(10), DealerBeginDate, 121), ''),
	       @DealerEndDate = ISNULL(CONVERT(NVARCHAR(10), DealerEndDate, 121), ''),
	       @MarketTypeShow = dbo.Func_GetCode('CONST_CONTRACT_MarketType', A.MarketType),
	       @DealerEndTypShow = dbo.Func_GetCode('CONST_CONTRACT_DealerEndTyp', A.DealerEndTyp),
	       @PlanExpiration = ISNULL(CONVERT(NVARCHAR(10), PlanExpiration, 121), ''),
	       @DealerEndReason = ISNULL(A.DealerEndReason, ''),
	       @DealerEndReasonShow = dbo.Func_GetCode('CONST_CONTRACT_DealerEndReason', A.DealerEndReason),
	       @OtherReason = ISNULL(A.OtherReason, ''),
	       @IAF = ISNULL(A.IAF, ''),
	       @ReagionRSMShow = (
	           SELECT TOP 1 T.ManagerName
	           FROM   MDM_Manager T
	           WHERE  A.ReagionRSM = T.EmpNo
	                  AND T.ManagerTitle = 'RSM'
	       ),
	       @Quotatotal = ISNULL(CONVERT(NVARCHAR(20), Quotatotal), ''),
	       @QUOTAUSD = ISNULL(CONVERT(NVARCHAR(20), QUOTAUSD), '')
	FROM   [Contract].TerminationMain A
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
	SET @Rtn += '<tr><td class="title" width="13%">申请单号</td><td colspan="5">' + @ContractNo + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title" width="13%">产品线</td><td width="20%">' + @DepIdShow + '</td><td class="title" width="13%">合同分类</td><td width="20%">' + @SUBDEPIDShow + '</td><td class="title" width="13%">申请人</td><td width="21%">' + @EName + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">申请日期</td><td>' + @RequestDate + '</td><td class="title">申请部门</td><td>' + @ApplicantDepShow + '</td><td class="title">市场类型</td><td>' + @MarketTypeShow + '</td></tr>'
	--Line 5
	SET @Rtn += '<tr><td class="title">经销商类型</td><td>' + @DealerTypeShow + '</td><td class="title">经销商</td><td colspan="3">' + @DealerNameShow + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">协议生效日</td><td>' + @DealerBeginDate + '</td><td class="title">协议到期日</td><td>' + @DealerEndDate + '</td><td class="title">终止类型</td><td>' + @DealerEndTypShow + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">终止生效日</td><td colspan="5">' + @PlanExpiration + '</td></tr>'
	--Line 8
	SET @Rtn += '<tr><td class="title">终止原因</td><td colspan="5">' + @DealerEndReasonShow + '</td></tr>'
	--Line 9
	IF @DealerEndReason = 'Others'
	BEGIN
	    SET @Rtn += '<tr><td class="title">其他终止原因</td><td colspan="5">' + @OtherReason + '</td></tr>'
	END
	--Line 10
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">IAF</td><td colspan="5">' + dbo.Func_GetAttachmentHtml(@IAF) + '</td></tr>'
	END
	--Line 11
	IF NOT (@DealerType = 'LP' AND @IsDrm = 1)
	   AND @DepId IN ('17', '19', '32', '35')
	BEGIN
	    SET @Rtn += '<tr><td class="title">RSM</td><td colspan="5">' + @ReagionRSMShow + '</td></tr>'
	END
	--Line 12
	SET @Rtn += '<tr><td class="title">指标总额(CNY)(不含税)</td><td>' + @Quotatotal + '</td><td class="title">指标总额(USD)不含税</td><td colspan="3">' + @QUOTAUSD + '</td></tr>'
	
	SET @Rtn += '</table>'
	
	--Status
	DECLARE @TenderIssueShow NVARCHAR(2000) ;
	DECLARE @TenderIssueRemark NVARCHAR(2000) ;
	DECLARE @RebateShow NVARCHAR(2000) ;
	DECLARE @RebateAmt NVARCHAR(2000) ;
	DECLARE @PromotionShow NVARCHAR(2000) ;
	DECLARE @PromotionAmt NVARCHAR(2000) ;
	DECLARE @ComplaintShow NVARCHAR(2000) ;
	DECLARE @ComplaintAmt NVARCHAR(2000) ;
	DECLARE @GoodsReturn NVARCHAR(2000) ;
	DECLARE @GoodsReturnShow NVARCHAR(2000) ;
	DECLARE @GoodsReturnAmt NVARCHAR(2000) ;
	DECLARE @ReturnReasonShow NVARCHAR(2000) ;
	DECLARE @IsRGAAttachShow NVARCHAR(2000) ;
	DECLARE @RGAAttach NVARCHAR(2000) ;
	DECLARE @CreditMemoShow NVARCHAR(2000) ;
	DECLARE @CreditMemoRemark NVARCHAR(2000) ;
	DECLARE @IsPendingPaymentShow NVARCHAR(2000) ;
	DECLARE @PendingAmt NVARCHAR(2000) ;
	DECLARE @PendingRemark NVARCHAR(2000) ;
	DECLARE @CurrentAR NVARCHAR(2000) ;
	DECLARE @CashDepositShow NVARCHAR(2000) ;
	DECLARE @CashDepositAmt NVARCHAR(2000) ;
	DECLARE @BGuaranteeShow NVARCHAR(2000) ;
	DECLARE @BGuaranteeAmt NVARCHAR(2000) ;
	DECLARE @CGuaranteeShow NVARCHAR(2000) ;
	DECLARE @CGuaranteeAmt NVARCHAR(2000) ;
	DECLARE @InventoryShow NVARCHAR(2000) ;
	DECLARE @InventoryAmt NVARCHAR(2000) ;
	DECLARE @InventoryList NVARCHAR(2000) ;
	DECLARE @EstimatedAR NVARCHAR(2000) ;
	DECLARE @Wirteoff NVARCHAR(2000) ;
	DECLARE @PaymentPlan NVARCHAR(2000) ;
	DECLARE @ReserveShow NVARCHAR(2000) ;
	DECLARE @ReserveAmt NVARCHAR(2000) ;
	DECLARE @ReserveTypeShow NVARCHAR(2000) ;
	
	SELECT @TenderIssueShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.TenderIssue),
	       @TenderIssueRemark = ISNULL(A.TenderIssueRemark, ''),
	       @RebateShow = dbo.Func_GetCode('CONST_CONTRACT_RebatePromotionComplaint', A.Rebate),
	       @RebateAmt = ISNULL(CONVERT(NVARCHAR(20), A.RebateAmt), ''),
	       @PromotionShow = dbo.Func_GetCode('CONST_CONTRACT_RebatePromotionComplaint', A.Promotion),
	       @PromotionAmt = ISNULL(CONVERT(NVARCHAR(20), A.PromotionAmt), ''),
	       @ComplaintShow = dbo.Func_GetCode('CONST_CONTRACT_RebatePromotionComplaint', A.Complaint),
	       @ComplaintAmt = ISNULL(CONVERT(NVARCHAR(20), A.ComplaintAmt), ''),
	       @GoodsReturn = ISNULL(CONVERT(NVARCHAR(20), A.GoodsReturn), ''),
	       @GoodsReturnShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.GoodsReturn),
	       @GoodsReturnAmt = ISNULL(CONVERT(NVARCHAR(20), A.GoodsReturnAmt), ''),
	       @ReturnReasonShow = dbo.Func_GetCode('CONST_CONTRACT_ReturnReason', A.ReturnReason),
	       @IsRGAAttachShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsRGAAttach),
	       @RGAAttach = ISNULL(A.RGAAttach, ''),
	       @CreditMemoShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.CreditMemo),
	       @CreditMemoRemark = ISNULL(A.CreditMemoRemark, ''),
	       @IsPendingPaymentShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsPendingPayment),
	       @PendingAmt = ISNULL(CONVERT(NVARCHAR(20), A.PendingAmt), ''),
	       @PendingRemark = ISNULL(A.PendingRemark, ''),
	       @CurrentAR = ISNULL(CONVERT(NVARCHAR(20), A.CurrentAR), ''),
	       @CashDepositShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.CashDeposit),
	       @CashDepositAmt = ISNULL(CONVERT(NVARCHAR(20), A.CashDepositAmt), ''),
	       @BGuaranteeShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.BGuarantee),
	       @BGuaranteeAmt = ISNULL(CONVERT(NVARCHAR(20), A.BGuaranteeAmt), ''),
	       @CGuaranteeShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.CGuarantee),
	       @CGuaranteeAmt = ISNULL(CONVERT(NVARCHAR(20), A.CGuaranteeAmt), ''),
	       @InventoryShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Inventory),
	       @InventoryAmt = ISNULL(CONVERT(NVARCHAR(20), A.InventoryAmt), ''),
	       @InventoryList = ISNULL(A.InventoryList, ''),
	       @EstimatedAR = ISNULL(CONVERT(NVARCHAR(20), A.EstimatedAR), ''),
	       @Wirteoff = ISNULL(CONVERT(NVARCHAR(20), A.Wirteoff), ''),
	       @PaymentPlan = ISNULL(A.PaymentPlan, ''),
	       @ReserveShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Reserve),
	       @ReserveAmt = ISNULL(CONVERT(NVARCHAR(20), A.ReserveAmt), ''),
	       @ReserveTypeShow = dbo.Func_GetCode2('CONST_CONTRACT_ReserveType', A.ReserveType)
	FROM   [Contract].TerminationStatus A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>经销商当前状态</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">1. ) 是否有未完成的投标工作?</td><td width="25%">' + @TenderIssueShow + '</td><td class="title" width="25%">备注</td><td width="25%">' + @TenderIssueRemark + '</td></tr>'
	--Line 2
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">2. ) 代理商的返利 (CNY，Exculde VAT)</td><td>' + @RebateShow + '</td><td class="title">返利金额(CNY, inc. VAT)</td><td>' + @RebateAmt + '</td></tr>'
	END
	--Line 3
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">3. ) 代理商促销 (CNY，Exculde VAT)</td><td>' + @PromotionShow + '</td><td class="title">促销金额(CNY, inc. VAT)</td><td>' + @PromotionAmt + '</td></tr>'
	END
	--Line 4
	SET @Rtn += '<tr><td class="title">4. ) 代理商投诉换货 (CNY，Exculde VAT)</td><td>' + @ComplaintShow + '</td><td class="title">投诉换货金额(CNY, inc. VAT)</td><td>' + @ComplaintAmt + '</td></tr>'
	--Line 5
	IF @GoodsReturn = '1'
	BEGIN
		SET @Rtn += '<tr><td class="title">5. ) 代理商终止后是否有退货</td><td>' + @GoodsReturnShow + '</td><td class="title">退换货金额</td><td>' + @GoodsReturnAmt + '</td></tr>'
	END
	--Line 6
	SET @Rtn += '<tr><td class="title">交接货原因</td><td colspan="3">' + @ReturnReasonShow + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">交接货产品清单</td><td>' + @IsRGAAttachShow + '</td><td class="title">清单附件</td><td>' + dbo.Func_GetAttachmentHtml(@RGAAttach) + '</td></tr>'
	--Line 8
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">6. ) 代理商是否有资质开红字通知单</td><td>' + @CreditMemoShow + '</td><td class="title">备注</td><td>' + @CreditMemoRemark + '</td></tr>'
	END
	--Line 9
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">7. ) 是否和代理商存在争议款项，需要BSC支付代理商</td><td>' + @IsPendingPaymentShow + '</td><td class="title">金额</td><td>' + @PendingAmt + '</td></tr>'
	END
	--Line 10
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">争议款项原因</td><td colspan="3">' + @PendingRemark + '</td></tr>'
	END
	--Line 11
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">8.) 经销商应付账款 (CNY, inc. VAT)</td><td colspan="3">' + @CurrentAR + '</td></tr>'
	END
	--Line 12
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">9.) ① 现金抵押</td><td>' + @CashDepositShow + '</td><td class="title">金额</td><td>' + @CashDepositAmt + '</td></tr>'
	END
	--Line 13
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">9.) ② 银行保函</td><td>' + @BGuaranteeShow + '</td><td class="title">金额</td><td>' + @BGuaranteeAmt + '</td></tr>'
	END
	--Line 14
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">9.) ③ 公司保函</td><td>' + @CGuaranteeShow + '</td><td class="title">金额</td><td>' + @CGuaranteeAmt + '</td></tr>'
	END
	--Line 15
	SET @Rtn += '<tr><td class="title">10.) 代理商缺货和未清的短期寄售 (CNY, inc. VAT)</td><td>' + @InventoryShow + '</td><td class="title">金额</td><td>' + @InventoryAmt + '</td></tr>'
	--Line 16
	SET @Rtn += '<tr><td class="title">库存清单</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@InventoryList) + '</td></tr>'
	--Line 17
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">11.) 结算金额 (CNY, inc. VAT)</td><td>' + @EstimatedAR + '</td><td class="title">其中申请坏账损失(wirte off)</td><td>' + @Wirteoff + '</td></tr>'
	END
	--Line 18
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">12.) 如果清算后仍有欠款，请填写付款计划</td><td colspan="3">' + @PaymentPlan + '</td></tr>'
	END
	--Line 19
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">13.) 坏帐计提？</td><td>' + @ReserveShow + '</td><td class="title">坏帐金额</td><td>' + @ReserveAmt + '</td></tr>'
	END
	--Line 20
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">坏帐类型</td><td colspan="3">' + @ReserveTypeShow + '</td></tr>'
	END
	
	SET @Rtn += '</table>'
	
	--·Handover
	DECLARE @TakeOver NVARCHAR(2000) ;
	DECLARE @TakeOverTypeShow NVARCHAR(2000) ;
	DECLARE @TakeOverIsNewShow NVARCHAR(2000) ;
	DECLARE @HandoverNotifiedShow NVARCHAR(2000) ;
	DECLARE @WhenNotify NVARCHAR(2000) ;
	DECLARE @WhenSettlement NVARCHAR(2000) ;
	DECLARE @WhenHandover NVARCHAR(2000) ;
	
	SELECT @TakeOver = ISNULL(A.TakeOver, ''),
	       @TakeOverTypeShow = dbo.Func_GetCode('CONST_CONTRACT_TakeOverType', A.TakeOverType),
	       @TakeOverIsNewShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.TakeOverIsNew),
	       @HandoverNotifiedShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Notified),
	       @WhenNotify = ISNULL(CONVERT(NVARCHAR(7), A.WhenNotify, 121), ''),
	       @WhenSettlement = ISNULL(CONVERT(NVARCHAR(7), A.WhenSettlement, 121), ''),
	       @WhenHandover = ISNULL(CONVERT(NVARCHAR(7), A.WhenHandover, 121), '')
	FROM   [Contract].TerminationHandover A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>业务交接</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">谁来接管此经销商业务？</td><td>' + @TakeOver + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">接管经销商类型</td><td>' + @TakeOverTypeShow + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">如果是新经销商，是否已经提交新经销商申请？</td><td>' + @TakeOverIsNewShow + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">是否已经通知经销商不续约或终止？</td><td>' + @HandoverNotifiedShow + '</td></tr>'
	--Line 5
	SET @Rtn += '<tr><td class="title">何时通知经销商不续约或终止？</td><td>' + @WhenNotify + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">何时完成结算？</td><td>' + @WhenSettlement + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">何时完成交接工作？</td><td>' + @WhenHandover + '</td></tr>'
	
	SET @Rtn += '</table>' 
	
	--·
	DECLARE @NotifiedShow NVARCHAR(2000) ;
	DECLARE @ReviewedShow NVARCHAR(2000) ;
	DECLARE @HandoverShow NVARCHAR(2000) ;
	DECLARE @HandoverRemark NVARCHAR(2000) ;
	
	SELECT @NotifiedShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Notified),
	       @ReviewedShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Reviewed),
	       @HandoverShow = dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Handover),
	       @HandoverRemark = ISNULL(A.HandoverRemark, '')
	FROM   [Contract].TerminationNCM A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	--SET @Rtn += '<h4>其他</h4><table class="gridtable">'
	SET @Rtn += '<h4>交接</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">是否将此事通知到DRM, Finance, Operations & HEGA？</td><td>' + @NotifiedShow + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">是否已审阅并确认以上结算提案？</td><td>' + @ReviewedShow + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">是否已为交接工作提交新经销商申请表格？</td><td>' + @HandoverShow + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">如果没有，请说明</td><td>' + @HandoverRemark + '</td></tr>'
	
	SET @Rtn += '</table>' 
	
	--·EndForm
	DECLARE @CurrentQuota NVARCHAR(2000) ;
	DECLARE @ActualSales NVARCHAR(2000) ;
	DECLARE @TenderDetails NVARCHAR(2000) ;
	
	SELECT @CurrentQuota = ISNULL(CONVERT(NVARCHAR(100), A.CurrentQuota), ''),
	       @ActualSales = ISNULL(CONVERT(NVARCHAR(100), A.ActualSales), ''),
	       @TenderDetails = ISNULL(A.TenderDetails, '')
	FROM   [Contract].TerminationEndForm A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>第三方不续约 / 终止表格</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">截至到当前季度指标总额</td><td width="25%">' + @CurrentQuota + '</td><td class="title" width="25%">截至当前季度实际采购总额</td><td width="25%">' + @ActualSales + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">波士顿科学在经销商终止协议之后<br />若要继续参加投标，请提供详细信息</td><td colspan="3">' + @TenderDetails + '</td></tr>'
	
	SET @Rtn += '</table>'
	
	RETURN @Rtn
END
GO


