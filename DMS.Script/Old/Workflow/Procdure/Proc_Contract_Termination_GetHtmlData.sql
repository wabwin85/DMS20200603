DROP PROCEDURE [Workflow].[Proc_Contract_Termination_GetHtmlData]
GO

CREATE PROCEDURE [Workflow].[Proc_Contract_Termination_GetHtmlData]
	@InstanceId UNIQUEIDENTIFIER
AS
BEGIN
	--Template & Tables
	SELECT 'Contract_Termination' AS TemplateName,
	       'Main,Status,Handover,NCM,EndForm,Display' AS TableNames
	
	--DECLARE Start
	
	DECLARE @Hide NVARCHAR(100) = 'display: none; ';
	DECLARE @Show NVARCHAR(100) = ' ';
	
	DECLARE @IsDrm BIT;
	
	--Display
	DECLARE @Display_OtherReason NVARCHAR(100) = @Hide;
	DECLARE @Display_IAF NVARCHAR(100) = @Hide;
	DECLARE @Display_ReagionRSM NVARCHAR(100) = @Hide;
	DECLARE @Display_RebateShow NVARCHAR(100) = @Hide;
	DECLARE @Display_RebateAmt NVARCHAR(100) = @Hide;
	DECLARE @Display_PromotionShow NVARCHAR(100) = @Hide;
	DECLARE @Display_PromotionAmt NVARCHAR(100) = @Hide;
	DECLARE @Display_GoodsReturnShow NVARCHAR(100) = @Hide;
	DECLARE @Display_GoodsReturnAmt NVARCHAR(100) = @Hide;
	DECLARE @Display_CreditMemoShow NVARCHAR(100) = @Hide;
	DECLARE @Display_CreditMemoRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_IsPendingPaymentShow NVARCHAR(100) = @Hide;
	DECLARE @Display_PendingAmt NVARCHAR(100) = @Hide;
	DECLARE @Display_PendingRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_CurrentAR NVARCHAR(100) = @Hide;
	DECLARE @Display_CashDepositShow NVARCHAR(100) = @Hide;
	DECLARE @Display_CashDepositAmt NVARCHAR(100) = @Hide;
	DECLARE @Display_BGuaranteeShow NVARCHAR(100) = @Hide;
	DECLARE @Display_BGuaranteeAmt NVARCHAR(100) = @Hide;
	DECLARE @Display_CGuaranteeShow NVARCHAR(100) = @Hide;
	DECLARE @Display_CGuaranteeAmt NVARCHAR(100) = @Hide;
	DECLARE @Display_EstimatedAR NVARCHAR(100) = @Hide;
	DECLARE @Display_Wirteoff NVARCHAR(100) = @Hide;
	DECLARE @Display_PaymentPlan NVARCHAR(100) = @Hide;
	DECLARE @Display_ReserveShow NVARCHAR(100) = @Hide;
	DECLARE @Display_ReserveAmt NVARCHAR(100) = @Hide;
	DECLARE @Display_ReserveTypeShow NVARCHAR(100) = @Hide;
	
	DECLARE @Display_FollowUp NVARCHAR(100) = @Hide;
	DECLARE @Display_FollowUpRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_FieldOperation NVARCHAR(100) = @Hide;
	DECLARE @Display_FieldOperationRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_AdverseEvent NVARCHAR(100) = @Hide;
	DECLARE @Display_AdverseEventRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_SubmitImplant NVARCHAR(100) = @Hide;
	DECLARE @Display_SubmitImplantRemark NVARCHAR(100) = @Hide;
	DECLARE @Display_InventoryDispose NVARCHAR(100) = @Hide;
	DECLARE @Display_InventoryDisposeRemark1 NVARCHAR(100) = @Hide;
	DECLARE @Display_InventoryDisposeRemark2 NVARCHAR(100) = @Hide;
	
	--Main
	DECLARE @DealerEndReason NVARCHAR(200) ;
	DECLARE @DealerType NVARCHAR(200) ;
	DECLARE @DepId NVARCHAR(200) ;
	DECLARE @SUBDEPID NVARCHAR(200) ;
	
	--Status
	DECLARE @GoodsReturn NVARCHAR(200) ;
	
	--Handover
	DECLARE @FollowUp INT;
	DECLARE @FieldOperation INT;
	DECLARE @AdverseEvent INT;
	DECLARE @SubmitImplant INT;
	DECLARE @InventoryDispose NVARCHAR(20);
	
	--NCM
	
	--EndForm
	
	--DECLARE End
	
	--Condition Start
	SELECT @IsDrm = CASE 
	                     WHEN A.DepID = '5' THEN 1
	                     ELSE 0
	                END
	FROM   interface.MDM_EmployeeMaster A,
	       Lafite_IDENTITY B,
	       [Contract].AppointmentMain C
	WHERE  A.account = B.IDENTITY_CODE
	       AND B.Id = C.CreateUser
	       AND C.ContractId = @InstanceId
	
	--Main
	SELECT @DealerType = ISNULL(A.DealerType, ''),
	       @DealerEndReason = ISNULL(A.DealerEndReason, ''),
	       @DepId = A.DepId,
	       @SUBDEPID = A.SUBDEPID
	FROM   [Contract].TerminationMain A
	WHERE  A.ContractId = @InstanceId;
	
	--Status
	SELECT @GoodsReturn = ISNULL(CONVERT(NVARCHAR(20), A.GoodsReturn), '')
	FROM   [Contract].TerminationStatus A
	WHERE  A.ContractId = @InstanceId;
	
	--Handover
	SELECT @FollowUp = A.FollowUp,
	       @FieldOperation = A.FieldOperation,
	       @AdverseEvent = A.AdverseEvent,
	       @SubmitImplant = A.SubmitImplant,
	       @InventoryDispose = A.InventoryDispose
	FROM   [Contract].TerminationHandover A
	WHERE  A.ContractId = @InstanceId;
	
	--NCM
	
	--EndForm
	
	--Condition End
	
	--Data Start
	
	--Main
	SELECT ISNULL(ContractNo, '') ContractNo,
	       dbo.Func_GetCode('CONST_CONTRACT_DealerType', A.DealerType) DealerTypeShow,
	       ISNULL(B.DepFullName, '') DepIdShow,
	       ISNULL(C.CC_NameCN, '') SUBDEPIDShow,
	       ISNULL(EName, '') EName,
	       ISNULL(CONVERT(NVARCHAR(10), RequestDate, 121), '') RequestDate,
	       ISNULL(F.DepFullName, '') ApplicantDepShow,
	       dbo.Func_GetCode('CONST_CONTRACT_MarketType', A.MarketType) MarketTypeShow,
	       ISNULL(D.DMA_SAP_Code + ' - ' + D.DMA_ChineseName, '') DealerNameShow,
	       ISNULL(CONVERT(NVARCHAR(10), DealerBeginDate, 121), '') DealerBeginDate,
	       ISNULL(CONVERT(NVARCHAR(10), DealerEndDate, 121), '') DealerEndDate,
	       ISNULL(CONVERT(NVARCHAR(10), PlanExpiration, 121), '') PlanExpiration,
	       dbo.Func_GetCode('CONST_CONTRACT_DealerEndTyp', A.DealerEndTyp) DealerEndTypShow,
	       dbo.Func_GetCode('CONST_CONTRACT_DealerEndReason', A.DealerEndReason) DealerEndReasonShow,
	       ISNULL(A.OtherReason, '') OtherReason,
	       dbo.Func_GetAttachmentHtml(A.IAF) IAF,
	       (
	           SELECT TOP 1 T.ManagerName
	           FROM   MDM_Manager T
	           WHERE  A.ReagionRSM = T.EmpNo
	                  AND T.ManagerTitle = 'RSM'
	       ) AS ReagionRSMShow,
	       ISNULL(CONVERT(NVARCHAR(20), Quotatotal), '') Quotatotal,
	       ISNULL(CONVERT(NVARCHAR(20), QUOTAUSD), '') QUOTAUSD
	FROM   [Contract].TerminationMain A
	       LEFT JOIN interface.mdm_department B
	            ON  CONVERT(NVARCHAR(10), A.DepId) = B.DepID
	       LEFT JOIN interface.ClassificationContract C
	            ON  A.SUBDEPID = C.CC_Code
	       LEFT JOIN DealerMaster D
	            ON  A.DealerName = D.DMA_SAP_Code
	       LEFT JOIN interface.mdm_department F
	            ON  CONVERT(NVARCHAR(10), A.ApplicantDep) = F.DepID
	WHERE  A.ContractId = @InstanceId;
	
	--Status
	SELECT dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.TenderIssue) TenderIssueShow,
	       ISNULL(A.TenderIssueRemark, '') TenderIssueRemark,
	       dbo.Func_GetCode('CONST_CONTRACT_RebatePromotionComplaint', A.Rebate) RebateShow,
	       ISNULL(CONVERT(NVARCHAR(20), A.RebateAmt), '') RebateAmt,
	       dbo.Func_GetCode('CONST_CONTRACT_RebatePromotionComplaint', A.Promotion) PromotionShow,
	       ISNULL(CONVERT(NVARCHAR(20), A.PromotionAmt), '') PromotionAmt,
	       dbo.Func_GetCode('CONST_CONTRACT_RebatePromotionComplaint', A.Complaint) ComplaintShow,
	       ISNULL(CONVERT(NVARCHAR(20), A.ComplaintAmt), '') ComplaintAmt,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.GoodsReturn) GoodsReturnShow,
	       ISNULL(CONVERT(NVARCHAR(20), A.GoodsReturnAmt), '') GoodsReturnAmt,
	       dbo.Func_GetCode('CONST_CONTRACT_ReturnReason', A.ReturnReason) ReturnReasonShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsRGAAttach) IsRGAAttachShow,
	       ISNULL(A.RGAAttach, '') RGAAttach,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.CreditMemo) CreditMemoShow,
	       ISNULL(A.CreditMemoRemark, '') CreditMemoRemark,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.IsPendingPayment) IsPendingPaymentShow,
	       ISNULL(CONVERT(NVARCHAR(20), A.PendingAmt), '') PendingAmt,
	       ISNULL(A.PendingRemark, '') PendingRemark,
	       ISNULL(CONVERT(NVARCHAR(20), A.CurrentAR), '') CurrentAR,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.CashDeposit) CashDepositShow,
	       ISNULL(CONVERT(NVARCHAR(20), A.CashDepositAmt), '') CashDepositAmt,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.BGuarantee) BGuaranteeShow,
	       ISNULL(CONVERT(NVARCHAR(20), A.BGuaranteeAmt), '') BGuaranteeAmt,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.CGuarantee) CGuaranteeShow,
	       ISNULL(CONVERT(NVARCHAR(20), A.CGuaranteeAmt), '') CGuaranteeAmt,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Inventory) InventoryShow,
	       ISNULL(CONVERT(NVARCHAR(20), A.InventoryAmt), '') InventoryAmt,
	       ISNULL(A.InventoryList, '') InventoryList,
	       ISNULL(CONVERT(NVARCHAR(20), A.EstimatedAR), '') EstimatedAR,
	       ISNULL(CONVERT(NVARCHAR(20), A.Wirteoff), '') Wirteoff,
	       ISNULL(A.PaymentPlan, '') PaymentPlan,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Reserve) ReserveShow,
	       ISNULL(CONVERT(NVARCHAR(20), A.ReserveAmt), '') ReserveAmt,
	       dbo.Func_GetCode2('CONST_CONTRACT_ReserveType', A.ReserveType) ReserveTypeShow
	FROM   [Contract].TerminationStatus A
	WHERE  A.ContractId = @InstanceId;
	
	--Handover
	SELECT ISNULL(A.TakeOver, '') TakeOver,
	       dbo.Func_GetCode('CONST_CONTRACT_TakeOverType', A.TakeOverType) TakeOverTypeShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.TakeOverIsNew) TakeOverIsNewShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Notified) HandoverNotifiedShow,
	       ISNULL(CONVERT(NVARCHAR(7), A.WhenNotify, 121), '') WhenNotify,
	       ISNULL(CONVERT(NVARCHAR(7), A.WhenSettlement, 121), '') WhenSettlement,
	       ISNULL(CONVERT(NVARCHAR(7), A.WhenHandover, 121), '') WhenHandover,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.FollowUp) FollowUpShow,
	       A.FollowUpRemark,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.FieldOperation) FieldOperationShow,
	       A.FieldOperationRemark,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.AdverseEvent) AdverseEventShow,
	       A.AdverseEventRemark,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.SubmitImplant) SubmitImplantShow,
	       CONVERT(NVARCHAR(10), A.SubmitImplantRemark, 121) SubmitImplantRemark,
	       dbo.Func_GetCode('CONST_CONTRACT_InventoryDispose', A.InventoryDispose) InventoryDisposeShow,
	       A.InventoryDisposeRemark1,
	       A.InventoryDisposeRemark2
	FROM   [Contract].TerminationHandover A
	WHERE  A.ContractId = @InstanceId;
	
	--NCM
	SELECT dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Notified) NotifiedShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Reviewed) ReviewedShow,
	       dbo.Func_GetCode('CONST_CONTRACT_YesNo', A.Handover) HandoverShow,
	       ISNULL(A.HandoverRemark, '') HandoverRemark
	FROM   [Contract].TerminationNCM A
	WHERE  A.ContractId = @InstanceId;
	
	
	--EndForm
	SELECT ISNULL(CONVERT(NVARCHAR(100), A.CurrentQuota), '') CurrentQuota,
	       ISNULL(CONVERT(NVARCHAR(100), A.ActualSales), '') ActualSales,
	       ISNULL(A.TenderDetails, '') TenderDetails
	FROM   [Contract].TerminationEndForm A
	WHERE  A.ContractId = @InstanceId;
	
	--Display
	IF @DealerEndReason = 'Others'
	BEGIN
	    SET @Display_OtherReason = @show
	END
	
	IF @DealerType != 'T2'
	BEGIN
	    SET @Display_IAF = @Show;
	    SET @Display_RebateShow = @Show;
	    SET @Display_RebateAmt = @Show;
	    SET @Display_PromotionShow = @Show;
	    SET @Display_PromotionAmt = @Show;
	    SET @Display_CreditMemoShow = @Show;
	    SET @Display_CreditMemoRemark = @Show;
	    SET @Display_IsPendingPaymentShow = @Show;
	    SET @Display_PendingAmt = @Show;
	    SET @Display_PendingRemark = @Show;
	    SET @Display_CurrentAR = @Show;
	    SET @Display_CashDepositShow = @Show;
	    SET @Display_CashDepositAmt = @Show;
	    SET @Display_BGuaranteeShow = @Show;
	    SET @Display_BGuaranteeAmt = @Show;
	    SET @Display_CGuaranteeShow = @Show;
	    SET @Display_CGuaranteeAmt = @Show;
	    SET @Display_EstimatedAR = @Show;
	    SET @Display_Wirteoff = @Show;
	    SET @Display_PaymentPlan = @Show;
	    SET @Display_ReserveShow = @Show;
	    SET @Display_ReserveAmt = @Show;
	    SET @Display_ReserveTypeShow = @Show;
	END
	
	IF NOT (@DealerType = 'LP' AND @IsDrm = 1)
	   AND @DepId IN ('17', '19', '32', '35')
	BEGIN
	    SET @Display_ReagionRSM = @Show;
	END
	
	IF @GoodsReturn = '1'
	BEGIN
	    SET @Display_GoodsReturnShow = @Show;
	    SET @Display_GoodsReturnAmt = @Show;
	END	
	
	IF @DealerType != 'T2'
	BEGIN
	    SET @Display_FollowUp = @Show;
	    IF @FollowUp = 1
	    BEGIN
	        SET @Display_FollowUpRemark = @Show;
	    END
	    
	    SET @Display_FieldOperation = @Show;
	    IF @FieldOperation = 1
	    BEGIN
	        SET @Display_FieldOperationRemark = @Show;
	    END
	    
	    SET @Display_AdverseEvent = @Show;
	    IF @AdverseEvent = 1
	    BEGIN
	        SET @Display_AdverseEventRemark = @Show;
	    END
	    
	    IF @DepId = '19'
	    BEGIN
	        SET @Display_SubmitImplant = @Show;
	        IF @SubmitImplant = 0
	        BEGIN
	            SET @Display_SubmitImplantRemark = @Show;
	        END
	    END
	    
	    SET @Display_InventoryDispose = @Show;
	    IF @InventoryDispose = 'Dealer'
	    BEGIN
	        SET @Display_InventoryDisposeRemark1 = @Show;
	    END
	    ELSE 
	    IF @InventoryDispose = 'Other'
	    BEGIN
	        SET @Display_InventoryDisposeRemark2 = @Show;
	    END
	END
	
	SELECT @Display_OtherReason Display_OtherReason,
	       @Display_IAF Display_IAF,
	       @Display_ReagionRSM Display_ReagionRSM,
	       @Display_RebateShow Display_RebateShow,
	       @Display_RebateAmt Display_RebateAmt,
	       @Display_PromotionShow Display_PromotionShow,
	       @Display_PromotionAmt Display_PromotionAmt,
	       @Display_GoodsReturnShow Display_GoodsReturnShow,
	       @Display_GoodsReturnAmt Display_GoodsReturnAmt,
	       @Display_CreditMemoShow Display_CreditMemoShow,
	       @Display_CreditMemoRemark Display_CreditMemoRemark,
	       @Display_IsPendingPaymentShow Display_IsPendingPaymentShow,
	       @Display_PendingAmt Display_PendingAmt,
	       @Display_PendingRemark Display_PendingRemark,
	       @Display_CurrentAR Display_CurrentAR,
	       @Display_CashDepositShow Display_CashDepositShow,
	       @Display_CashDepositAmt Display_CashDepositAmt,
	       @Display_BGuaranteeShow Display_BGuaranteeShow,
	       @Display_BGuaranteeAmt Display_BGuaranteeAmt,
	       @Display_CGuaranteeShow Display_CGuaranteeShow,
	       @Display_CGuaranteeAmt Display_CGuaranteeAmt,
	       @Display_EstimatedAR Display_EstimatedAR,
	       @Display_Wirteoff Display_Wirteoff,
	       @Display_PaymentPlan Display_PaymentPlan,
	       @Display_ReserveShow Display_ReserveShow,
	       @Display_ReserveAmt Display_ReserveAmt,
	       @Display_ReserveTypeShow Display_ReserveTypeShow,
	       @Display_FollowUp Display_FollowUp,
	       @Display_FollowUpRemark Display_FollowUpRemark,
	       @Display_FieldOperation Display_FieldOperation,
	       @Display_FieldOperationRemark Display_FieldOperationRemark,
	       @Display_AdverseEvent Display_AdverseEvent,
	       @Display_AdverseEventRemark Display_AdverseEventRemark,
	       @Display_SubmitImplant Display_SubmitImplant,
	       @Display_SubmitImplantRemark Display_SubmitImplantRemark,
	       @Display_InventoryDispose Display_InventoryDispose,
	       @Display_InventoryDisposeRemark1 Display_InventoryDisposeRemark1,
	       @Display_InventoryDisposeRemark2 Display_InventoryDisposeRemark2
	       --Data End
END
GO


