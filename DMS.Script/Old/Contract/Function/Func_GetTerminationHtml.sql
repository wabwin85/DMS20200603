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
	SET @Rtn += '<h4>������Ϣ</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td colspan="6" style="color: red;">ƽ̨��һ�������̣�����Ӣ�����룡</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title" width="13%">���뵥��</td><td colspan="5">' + @ContractNo + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title" width="13%">��Ʒ��</td><td width="20%">' + @DepIdShow + '</td><td class="title" width="13%">��ͬ����</td><td width="20%">' + @SUBDEPIDShow + '</td><td class="title" width="13%">������</td><td width="21%">' + @EName + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">��������</td><td>' + @RequestDate + '</td><td class="title">���벿��</td><td>' + @ApplicantDepShow + '</td><td class="title">�г�����</td><td>' + @MarketTypeShow + '</td></tr>'
	--Line 5
	SET @Rtn += '<tr><td class="title">����������</td><td>' + @DealerTypeShow + '</td><td class="title">������</td><td colspan="3">' + @DealerNameShow + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">Э����Ч��</td><td>' + @DealerBeginDate + '</td><td class="title">Э�鵽����</td><td>' + @DealerEndDate + '</td><td class="title">��ֹ����</td><td>' + @DealerEndTypShow + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">��ֹ��Ч��</td><td colspan="5">' + @PlanExpiration + '</td></tr>'
	--Line 8
	SET @Rtn += '<tr><td class="title">��ֹԭ��</td><td colspan="5">' + @DealerEndReasonShow + '</td></tr>'
	--Line 9
	IF @DealerEndReason = 'Others'
	BEGIN
	    SET @Rtn += '<tr><td class="title">������ֹԭ��</td><td colspan="5">' + @OtherReason + '</td></tr>'
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
	SET @Rtn += '<tr><td class="title">ָ���ܶ�(CNY)(����˰)</td><td>' + @Quotatotal + '</td><td class="title">ָ���ܶ�(USD)����˰</td><td colspan="3">' + @QUOTAUSD + '</td></tr>'
	
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
	SET @Rtn += '<h4>�����̵�ǰ״̬</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">1. ) �Ƿ���δ��ɵ�Ͷ�깤��?</td><td width="25%">' + @TenderIssueShow + '</td><td class="title" width="25%">��ע</td><td width="25%">' + @TenderIssueRemark + '</td></tr>'
	--Line 2
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">2. ) �����̵ķ��� (CNY��Exculde VAT)</td><td>' + @RebateShow + '</td><td class="title">�������(CNY, inc. VAT)</td><td>' + @RebateAmt + '</td></tr>'
	END
	--Line 3
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">3. ) �����̴��� (CNY��Exculde VAT)</td><td>' + @PromotionShow + '</td><td class="title">�������(CNY, inc. VAT)</td><td>' + @PromotionAmt + '</td></tr>'
	END
	--Line 4
	SET @Rtn += '<tr><td class="title">4. ) ������Ͷ�߻��� (CNY��Exculde VAT)</td><td>' + @ComplaintShow + '</td><td class="title">Ͷ�߻������(CNY, inc. VAT)</td><td>' + @ComplaintAmt + '</td></tr>'
	--Line 5
	IF @GoodsReturn = '1'
	BEGIN
		SET @Rtn += '<tr><td class="title">5. ) ��������ֹ���Ƿ����˻�</td><td>' + @GoodsReturnShow + '</td><td class="title">�˻������</td><td>' + @GoodsReturnAmt + '</td></tr>'
	END
	--Line 6
	SET @Rtn += '<tr><td class="title">���ӻ�ԭ��</td><td colspan="3">' + @ReturnReasonShow + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">���ӻ���Ʒ�嵥</td><td>' + @IsRGAAttachShow + '</td><td class="title">�嵥����</td><td>' + dbo.Func_GetAttachmentHtml(@RGAAttach) + '</td></tr>'
	--Line 8
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">6. ) �������Ƿ������ʿ�����֪ͨ��</td><td>' + @CreditMemoShow + '</td><td class="title">��ע</td><td>' + @CreditMemoRemark + '</td></tr>'
	END
	--Line 9
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">7. ) �Ƿ�ʹ����̴�����������ҪBSC֧��������</td><td>' + @IsPendingPaymentShow + '</td><td class="title">���</td><td>' + @PendingAmt + '</td></tr>'
	END
	--Line 10
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">�������ԭ��</td><td colspan="3">' + @PendingRemark + '</td></tr>'
	END
	--Line 11
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">8.) ������Ӧ���˿� (CNY, inc. VAT)</td><td colspan="3">' + @CurrentAR + '</td></tr>'
	END
	--Line 12
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">9.) �� �ֽ��Ѻ</td><td>' + @CashDepositShow + '</td><td class="title">���</td><td>' + @CashDepositAmt + '</td></tr>'
	END
	--Line 13
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">9.) �� ���б���</td><td>' + @BGuaranteeShow + '</td><td class="title">���</td><td>' + @BGuaranteeAmt + '</td></tr>'
	END
	--Line 14
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">9.) �� ��˾����</td><td>' + @CGuaranteeShow + '</td><td class="title">���</td><td>' + @CGuaranteeAmt + '</td></tr>'
	END
	--Line 15
	SET @Rtn += '<tr><td class="title">10.) ������ȱ����δ��Ķ��ڼ��� (CNY, inc. VAT)</td><td>' + @InventoryShow + '</td><td class="title">���</td><td>' + @InventoryAmt + '</td></tr>'
	--Line 16
	SET @Rtn += '<tr><td class="title">����嵥</td><td colspan="3">' + dbo.Func_GetAttachmentHtml(@InventoryList) + '</td></tr>'
	--Line 17
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">11.) ������ (CNY, inc. VAT)</td><td>' + @EstimatedAR + '</td><td class="title">�������뻵����ʧ(wirte off)</td><td>' + @Wirteoff + '</td></tr>'
	END
	--Line 18
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">12.) ������������Ƿ�����д����ƻ�</td><td colspan="3">' + @PaymentPlan + '</td></tr>'
	END
	--Line 19
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">13.) ���ʼ��᣿</td><td>' + @ReserveShow + '</td><td class="title">���ʽ��</td><td>' + @ReserveAmt + '</td></tr>'
	END
	--Line 20
	IF @DealerType != 'T2'
	BEGIN
	    SET @Rtn += '<tr><td class="title">��������</td><td colspan="3">' + @ReserveTypeShow + '</td></tr>'
	END
	
	SET @Rtn += '</table>'
	
	--��Handover
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
	SET @Rtn += '<h4>ҵ�񽻽�</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">˭���ӹܴ˾�����ҵ��</td><td>' + @TakeOver + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">�ӹܾ���������</td><td>' + @TakeOverTypeShow + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">������¾����̣��Ƿ��Ѿ��ύ�¾��������룿</td><td>' + @TakeOverIsNewShow + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">�Ƿ��Ѿ�֪ͨ�����̲���Լ����ֹ��</td><td>' + @HandoverNotifiedShow + '</td></tr>'
	--Line 5
	SET @Rtn += '<tr><td class="title">��ʱ֪ͨ�����̲���Լ����ֹ��</td><td>' + @WhenNotify + '</td></tr>'
	--Line 6
	SET @Rtn += '<tr><td class="title">��ʱ��ɽ��㣿</td><td>' + @WhenSettlement + '</td></tr>'
	--Line 7
	SET @Rtn += '<tr><td class="title">��ʱ��ɽ��ӹ�����</td><td>' + @WhenHandover + '</td></tr>'
	
	SET @Rtn += '</table>' 
	
	--��
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
	--SET @Rtn += '<h4>����</h4><table class="gridtable">'
	SET @Rtn += '<h4>����</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">�Ƿ񽫴���֪ͨ��DRM, Finance, Operations & HEGA��</td><td>' + @NotifiedShow + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">�Ƿ������Ĳ�ȷ�����Ͻ����᰸��</td><td>' + @ReviewedShow + '</td></tr>'
	--Line 3
	SET @Rtn += '<tr><td class="title">�Ƿ���Ϊ���ӹ����ύ�¾�����������</td><td>' + @HandoverShow + '</td></tr>'
	--Line 4
	SET @Rtn += '<tr><td class="title">���û�У���˵��</td><td>' + @HandoverRemark + '</td></tr>'
	
	SET @Rtn += '</table>' 
	
	--��EndForm
	DECLARE @CurrentQuota NVARCHAR(2000) ;
	DECLARE @ActualSales NVARCHAR(2000) ;
	DECLARE @TenderDetails NVARCHAR(2000) ;
	
	SELECT @CurrentQuota = ISNULL(CONVERT(NVARCHAR(100), A.CurrentQuota), ''),
	       @ActualSales = ISNULL(CONVERT(NVARCHAR(100), A.ActualSales), ''),
	       @TenderDetails = ISNULL(A.TenderDetails, '')
	FROM   [Contract].TerminationEndForm A
	WHERE  A.ContractId = @ContractId;
	
	--Head
	SET @Rtn += '<h4>����������Լ / ��ֹ���</h4><table class="gridtable">'
	--Line 1
	SET @Rtn += '<tr><td class="title" width="25%">��������ǰ����ָ���ܶ�</td><td width="25%">' + @CurrentQuota + '</td><td class="title" width="25%">������ǰ����ʵ�ʲɹ��ܶ�</td><td width="25%">' + @ActualSales + '</td></tr>'
	--Line 2
	SET @Rtn += '<tr><td class="title">��ʿ�ٿ�ѧ�ھ�������ֹЭ��֮��<br />��Ҫ�����μ�Ͷ�꣬���ṩ��ϸ��Ϣ</td><td colspan="3">' + @TenderDetails + '</td></tr>'
	
	SET @Rtn += '</table>'
	
	RETURN @Rtn
END
GO


