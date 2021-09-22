USE [BSC_DMS140717]
GO

/****** Object:  StoredProcedure [dbo].[GC_ContractUpdateSubmint]    Script Date: 2018/3/30 16:04:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
管理员调整合同修改
*/
alter Procedure [dbo].[GC_ContractUpdateSubmint]
    @TempId uniqueidentifier,
    @ContractType NVARCHAR(20),   --Amendment、Renewal、Termination、Appointment
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
    
AS
		
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	Declare @ContractId uniqueidentifier
	Declare @UpdateUser uniqueidentifier
	Declare @DealerId NVARCHAR(36)
	Declare @CheckAut int
	Declare @CheckAOP int
	SET @CheckAut=0
	SET @CheckAOP=0
	
	CREATE TABLE #TempProduct(
		[HistoryId] [uniqueidentifier] NOT NULL,
		[DAT_PMA_ID] [uniqueidentifier] NOT NULL,
		[DAT_ID] [uniqueidentifier] NOT NULL,
		[DAT_DCL_ID] [uniqueidentifier] NOT NULL,
		[DAT_DMA_ID] [uniqueidentifier] NULL,
		[DAT_DMA_ID_Actual] [uniqueidentifier] NULL,
		[DAT_ProductLine_BUM_ID] [uniqueidentifier] NULL,
		[DAT_AuthorizationType] [nvarchar](50) NOT NULL,
		[DAT_HospitalListDesc] [nvarchar](200) NULL,
		[DAT_ProductDescription] [nvarchar](200) NULL)

	CREATE TABLE #HospitalList(
		[HistoryId] [uniqueidentifier] NOT NULL,
		[ID] [uniqueidentifier] NOT NULL,
		[Contract_ID] [uniqueidentifier] NOT NULL,
		[Contract_Type] [nvarchar](50) NULL,
		[PL_ID] [uniqueidentifier] NULL,
		[HOS_ID] [uniqueidentifier] NULL,
		[Territory_Type] [nvarchar](50) NULL,
		[HOS_Depart] [nvarchar](500) NULL,
		[HOS_DepartType] [nvarchar](500) NULL,
		[HOS_DepartRemark] [nvarchar](2000) NULL)

	CREATE TABLE #AopHospital(
		[HistoryId] [uniqueidentifier] NOT NULL,
		[AOPDH_ID] [uniqueidentifier] NOT NULL,
		[AOPDH_Contract_ID] [uniqueidentifier] NOT NULL,
		[AOPDH_Dealer_DMA_ID] [uniqueidentifier] NOT NULL,
		[AOPDH_Dealer_DMA_ID_Actual] [uniqueidentifier] NULL,
		[AOPDH_ProductLine_BUM_ID] [uniqueidentifier] NOT NULL,
		[AOPDH_Hospital_ID] [uniqueidentifier] NOT NULL,
		[AOPDH_Year] [nvarchar](30) NULL,
		[AOPDH_Month] [nvarchar](50) NULL,
		[AOPDH_Amount] [float] NULL,
		[AOPDH_Update_User_ID] [uniqueidentifier] NULL,
		[AOPDH_Update_Date] [datetime] NULL,
		[AOPDH_PCT_ID] [uniqueidentifier] NULL)

	CREATE TABLE #AopDealer(
		[HistoryId] [uniqueidentifier] NOT NULL,
		[AOPD_ID] [uniqueidentifier] NOT NULL,
		[AOPD_Contract_ID] [uniqueidentifier] NOT NULL,
		[AOPD_Dealer_DMA_ID] [uniqueidentifier] NOT NULL,
		[AOPD_Dealer_DMA_ID_Actual] [uniqueidentifier] NULL,
		[AOPD_ProductLine_BUM_ID] [uniqueidentifier] NOT NULL,
		[AOPD_Market_Type] [nvarchar](30) NULL,
		[AOPD_Year] [nvarchar](30) NOT NULL,
		[AOPD_Month] [nvarchar](50) NOT NULL,
		[AOPD_Amount] [float] NULL,
		[AOPD_Update_User_ID] [uniqueidentifier] NULL,
		[AOPD_Update_Date] [datetime] NULL,
		[AOPD_CC_ID] [uniqueidentifier] NULL)
	
if @ContractType='Termination'
	begin
	select @ContractId=ContractId , @UpdateUser=UpdateUser  FROM Contract.TerminationMaintemp WHERE Temp_Id=@TempId
	if @ContractId is not null
	 DELETE Contract.TerminationMaintempHistory WHERE His_id=@TempId;
	 DELETE Contract.TerminationStatusTempHistory WHERE His_id=@TempId;
	 DELETE Contract.TerminationEndFormTempHistory WHERE His_id=@TempId;
	 DELETE Contract.TerminationHandoverTempHistory WHERE His_id=@TempId;
	 DELETE Contract.TerminationNCMTempHistory WHERE His_id=@TempId;
	
	insert into Contract.TerminationEndFormTempHistory (His_Id, ContractId,CurrentQuota,ActualSales,TenderDetails)
	select @TempId,v.ContractId,v.CurrentQuota,v.ActualSales,v.TenderDetails from Contract.TerminationEndForm v where v.ContractId=@ContractId

	insert into  Contract.TerminationMaintempHistory (His_Id,ContractId,ContractNo,ContractStatus,DealerType,DepId,SUBDEPID,EId,EName,ApplicantDep,RequestDate,MarketType,DealerName,DealerBeginDate,DealerEndDate,DealerEndTyp,PlanExpiration,DealerEndReason,OtherReason,IAF,Quotatotal,QUOTAUSD,ReagionRSM,ISVAT,LPCode,ETitle,CreateUser,CreateDate,UpdateUser,UpdateDate,CurrentApprove,NextApprove)
    select @TempId,ContractId,ContractNo,ContractStatus,DealerType,DepId,SUBDEPID,EId,EName,ApplicantDep,RequestDate,MarketType,DealerName,DealerBeginDate,DealerEndDate,DealerEndTyp,PlanExpiration,DealerEndReason,OtherReason,IAF,Quotatotal,QUOTAUSD,ReagionRSM,ISVAT,LPCode,ETitle,CreateUser,CreateDate,@UpdateUser,UpdateDate,CurrentApprove,NextApprove from Contract.TerminationMain c where c.ContractId=@ContractId

	insert into Contract.TerminationNCMTempHistory (His_Id,ContractId,Notified,Reviewed,Handover,HandoverRemark)
	select @TempId,ContractId,Notified,Reviewed,Handover,HandoverRemark from Contract.TerminationNCMTemp  t where t.ContractId=@ContractId
	
	insert into Contract.TerminationHandoverTempHistory (His_Id,ContractId,TakeOver,TakeOverType,TakeOverIsNew,Notified,WhenNotify,WhenSettlement,WhenHandover,FollowUp,FollowUpRemark,FieldOperation,FieldOperationRemark,AdverseEvent,AdverseEventRemark,SubmitImplant,SubmitImplantRemark,InventoryDispose,InventoryDisposeRemark1,InventoryDisposeRemark2)
	select @TempId,ContractId,TakeOver,TakeOverType,TakeOverIsNew,Notified,WhenNotify,WhenSettlement,WhenHandover,FollowUp,FollowUpRemark,FieldOperation,FieldOperationRemark,AdverseEvent,AdverseEventRemark,SubmitImplant,SubmitImplantRemark,InventoryDispose,InventoryDisposeRemark1,InventoryDisposeRemark2 from Contract.TerminationHandover s where s.ContractId=@ContractId

	insert into Contract.TerminationStatusTempHistory(His_Id ,ContractId,TenderIssue,TenderIssueRemark,Rebate,RebateAmt,Promotion,PromotionAmt,Complaint,ComplaintAmt,GoodsReturn,GoodsReturnAmt,ReturnReason,IsRGAAttach,RGAAttach,CreditMemo,CreditMemoRemark,IsPendingPayment,PendingAmt,PendingRemark,CurrentAR,CashDeposit,CashDepositAmt,BGuarantee,BGuaranteeAmt,CGuarantee,CGuaranteeAmt,Inventory,InventoryAmt,InventoryList,EstimatedAR,Wirteoff,PaymentPlan,Reserve,ReserveAmt,ReserveType)
	select @TempId ,ContractId,TenderIssue,TenderIssueRemark,Rebate,RebateAmt,Promotion,PromotionAmt,Complaint,ComplaintAmt,GoodsReturn,GoodsReturnAmt,ReturnReason,IsRGAAttach,RGAAttach,CreditMemo,CreditMemoRemark,IsPendingPayment,PendingAmt,PendingRemark,CurrentAR,CashDeposit,CashDepositAmt,BGuarantee,BGuaranteeAmt,CGuarantee,CGuaranteeAmt,Inventory,InventoryAmt,InventoryList,EstimatedAR,Wirteoff,PaymentPlan,Reserve,ReserveAmt,ReserveType from Contract.TerminationStatus o where o.ContractId=@ContractId
    
	update a set a.CurrentQuota=b.CurrentQuota	,a.ActualSales=b.ActualSales,a.TenderDetails=b.TenderDetails from  Contract.TerminationEndForm a
	INNER JOIN Contract.TerminationEndFormTemp b ON a.ContractId=b.ContractId
	WHERE b.Temp_Id=@TempId 
	AND a.ContractId=@ContractId


	update a set a.ContractId=b.ContractId,a.ContractNo=b.ContractNo,a.ContractStatus=b.ContractStatus,a.DealerType=b.DealerType,a.DepId=b.DepId,a.SUBDEPID=b.SUBDEPID,a.EId=b.EId,a.EName=b.EName,a.ApplicantDep=b.ApplicantDep,a.RequestDate=b.RequestDate,a.MarketType=b.MarketType,a.DealerName=b.DealerName,a.DealerBeginDate=b.DealerBeginDate,a.DealerEndDate=b.DealerEndDate,a.DealerEndTyp=b.DealerEndTyp,a.PlanExpiration=b.PlanExpiration,a.DealerEndReason=b.DealerEndReason,a.OtherReason=b.OtherReason,a.IAF=b.IAF,a.Quotatotal=a.Quotatotal,a.QUOTAUSD=b.QUOTAUSD,a.ReagionRSM=b.ReagionRSM,a.ISVAT=b.ISVAT,a.LPCode=b.LPCode,a.ETitle=b.ETitle,a.CreateUser=b.CreateUser,a.CreateDate=b.CreateDate,a.UpdateUser=b.UpdateUser,a.UpdateDate=b.UpdateDate,a.CurrentApprove=b.CurrentApprove,a.NextApprove=b.NextApprove from  Contract.TerminationMain a
	INNER JOIN Contract.TerminationMaintemp b ON a.ContractId=b.ContractId
	WHERE b.Temp_Id=@TempId 
	AND a.ContractId=@ContractId

	update a set a.ContractId=b.ContractId,a.Notified=b.Notified,a.Reviewed=b.Reviewed,a.Handover=b.Handover,a.HandoverRemark=b.HandoverRemark from  Contract.TerminationNCM a
	INNER JOIN Contract.TerminationNCMTemp b ON a.ContractId=b.ContractId
	WHERE b.Temp_Id=@TempId 
	AND a.ContractId=@ContractId

	update a set a.ContractId=b.ContractId,a.TakeOver=b.TakeOver,a.TakeOverType=b.TakeOverType,a.TakeOverIsNew=b.TakeOverIsNew,a.Notified=B.Notified,WhenNotify=b.WhenNotify,a.WhenSettlement=b.WhenSettlement,a.WhenHandover=b.WhenHandover,a.FollowUp=b.FollowUp,a.FollowUpRemark=b.FollowUpRemark,a.FieldOperation=b.FieldOperation,a.FieldOperationRemark=b.FieldOperationRemark,a.AdverseEvent=b.AdverseEvent,a.AdverseEventRemark=b.AdverseEventRemark,a.SubmitImplant=b.SubmitImplant,a.SubmitImplantRemark=b.SubmitImplantRemark,a.InventoryDispose=b.InventoryDispose,a.InventoryDisposeRemark1=b.InventoryDisposeRemark1,a.InventoryDisposeRemark2=b.InventoryDisposeRemark2 from  Contract.TerminationHandover a
	INNER JOIN Contract.TerminationHandoverTemp b ON a.ContractId=b.ContractId
	WHERE b.Temp_Id=@TempId 
	AND a.ContractId=@ContractId


	update a set a.ContractId=b.ContractId,a.TenderIssue=b.TenderIssue,a.TenderIssueRemark=b.TenderIssueRemark,a.Rebate=b.Rebate,a.RebateAmt=b.RebateAmt,a.Promotion=b.Promotion,a.PromotionAmt=b.PromotionAmt,a.Complaint=b.Complaint,a.ComplaintAmt=b.ComplaintAmt,a.GoodsReturn=b.GoodsReturn,a.GoodsReturnAmt=b.GoodsReturnAmt,a.ReturnReason=b.ReturnReason,a.IsRGAAttach=b.IsRGAAttach,a.RGAAttach=b.RGAAttach,a.CreditMemo=b.CreditMemo,a.CreditMemoRemark=b.CreditMemoRemark,a.IsPendingPayment=b.IsPendingPayment,a.PendingAmt=b.PendingAmt,a.PendingRemark=b.PendingRemark,a.CurrentAR=b.CurrentAR,a.CashDeposit=b.CashDeposit,a.CashDepositAmt=b.CashDepositAmt,a.BGuarantee=b.BGuarantee,a.BGuaranteeAmt=b.BGuaranteeAmt,a.CGuarantee=b.CGuarantee,a.CGuaranteeAmt=b.CGuaranteeAmt,a.Inventory=b.Inventory,a.InventoryAmt=b.InventoryAmt,a.InventoryList=b.InventoryList,a.EstimatedAR=b.EstimatedAR,a.Wirteoff=b.Wirteoff,a.PaymentPlan=b.PaymentPlan,a.Reserve=b.Reserve,a.ReserveAmt=b.ReserveAmt,a.ReserveType=b.ReserveType from  Contract.TerminationStatus a
	INNER JOIN Contract.TerminationStatusTemp b ON a.ContractId=b.ContractId
	WHERE b.Temp_Id=@TempId 
	AND a.ContractId=@ContractId
	end
  
IF 	@ContractType='Amendment'
	BEGIN
		SELECT @ContractId=ContractId,@UpdateUser=UpdateUser FROM Contract.AmendmentMainTemp WHERE TempId=@TempId
		IF @ContractId IS NOT NULL
		BEGIN
			SELECT @DealerId=A.CompanyID FROM Contract.AmendmentMain A WHERE A.ContractId=@ContractId
			--备份当前数据
			DELETE Contract.AmendmentMainHistory WHERE HistoryId=@TempId;
			DELETE Contract.AmendmentProposalsHistory WHERE HistoryId=@TempId;
			
			INSERT INTO Contract.AmendmentMainHistory
			(HistoryId,ContractId,ContractNo,ContractStatus,DealerType,DepId,SUBDEPID,EId,EName,ApplicantDep,RequestDate,CompanyID,DealerName,MarketType,DealerBeginDate,DealerEndDate,AmendEffectiveDate,Purpose,IsEquipment,ReagionRSM,AOPTYPE,PRICEAUTO,REBATEAUTO,HospitalType,LPSapCode,IsLP,ETitle,IsFirstContract,CurrentApprove,NextApprove,Assessment,AssessmentStart,AssessmentEnd,UpdateUser,UpdateDate)
			SELECT @TempId,ContractId,ContractNo,ContractStatus,DealerType,DepId,SUBDEPID,EId,EName,ApplicantDep,RequestDate,CompanyID,DealerName,MarketType,DealerBeginDate,DealerEndDate,AmendEffectiveDate,Purpose,IsEquipment,ReagionRSM,AOPTYPE,PRICEAUTO,REBATEAUTO,HospitalType,LPSapCode,IsLP,ETitle,IsFirstContract,CurrentApprove,NextApprove,Assessment,AssessmentStart,AssessmentEnd,@UpdateUser,GETDATE()
			FROM Contract.AmendmentMain
			WHERE ContractId=@ContractId
			
			INSERT INTO [Contract].[AmendmentProposalsHistory]
			(HistoryId,ContractId,Product,ProductRemark,Price,PriceRemark,SpecialSales,SpecialSalesRemark,Hospital,Quota,QuotaTotal,QUOTAUSD,AllProductAop,AllProductAopUSD,Payment,CreditTerm,CreditLimit,PayTerm,IsDeposit,Deposit,Inform,InformOther,Comment,DealerLessHos,DealerLessHosReason,DealerLessHosReasonQ,DealerLessHosQ,DealerLessHosQRemark,HosLessStandard,HosLessStandardReason,HosLessStandardReasonQ,HosLessStandardQ,HosLessStandardQRemark,Attachment,ChangeQuarter,ChangeReason,ISVAT,QUATOUP,HosHavZorro,CheckData,QuarterChange,ProductGroupCheck,ProductGroupRemark,ProductGroupMemo)
			SELECT @TempId,ContractId,Product,ProductRemark,Price,PriceRemark,SpecialSales,SpecialSalesRemark,Hospital,Quota,QuotaTotal,QUOTAUSD,AllProductAop,AllProductAopUSD,Payment,CreditTerm,CreditLimit,PayTerm,IsDeposit,Deposit,Inform,InformOther,Comment,DealerLessHos,DealerLessHosReason,DealerLessHosReasonQ,DealerLessHosQ,DealerLessHosQRemark,HosLessStandard,HosLessStandardReason,HosLessStandardReasonQ,HosLessStandardQ,HosLessStandardQRemark,Attachment,ChangeQuarter,ChangeReason,ISVAT,QUATOUP,HosHavZorro,CheckData,QuarterChange,ProductGroupCheck,ProductGroupRemark,ProductGroupMemo
			FROM Contract.AmendmentProposals
			WHERE ContractId=@ContractId
			
			--更新当前数据
			UPDATE A SET A.Purpose=b.Purpose ,a.IsEquipment=b.IsEquipment,a.Assessment=b.Assessment,a.AssessmentStart=b.AssessmentStart ,a.AssessmentEnd=b.AssessmentEnd
				,A.AmendEffectiveDate=b.AmendEffectiveDate
			FROM Contract.AmendmentMain A 
			INNER JOIN Contract.AmendmentMainTemp B ON A.ContractId=B.ContractId
			WHERE B.TempId=@TempId 
			AND A.ContractId=@ContractId
			
			UPDATE A SET A.Payment=b.Payment ,a.CreditTerm=b.CreditTerm,
					a.CreditLimit=b.CreditLimit,a.PayTerm=b.PayTerm ,a.IsDeposit=b.IsDeposit,a.Deposit=b.Deposit
					,a.Inform=b.Inform,a.InformOther=b.InformOther,a.Comment=b.Comment
			FROM Contract.AmendmentProposals A 
			INNER JOIN Contract.AmendmentProposalsTemp B ON A.ContractId=B.ContractId
			WHERE B.TempId=@TempId 
			AND A.ContractId=@ContractId
			
			--授权被变更
			IF EXISTS(SELECT 1 FROM Contract.DealerAuthorizationTableTempHistory WHERE HistoryId=@TempId)
			BEGIN
				UPDATE Contract.AmendmentCurrent SET HospitalAmend=1 WHERE ContractId=@ContractId
			END
			--指标被变更
			IF EXISTS(SELECT 1 FROM Contract.AOPDealerTempHistory WHERE HistoryId=@TempId)
			BEGIN
				UPDATE Contract.AmendmentCurrent SET QuotaAmend=1 WHERE ContractId=@ContractId
			END
			
			--保存临时修改授权
			IF EXISTS(SELECT 1 FROM Contract.DealerAuthorizationTableTempHistory WHERE HistoryId=@TempId)
			BEGIN
				Declare @HospitalCount int
				SET @CheckAut=1
				SELECT @HospitalCount=COUNT(distinct HOS_ID) FROM Contract.ContractTerritoryHistory WHERE HistoryId= @TempId
				 
				UPDATE Contract.AmendmentProposals 
					SET Hospital=CONVERT(nvarchar,@HospitalCount)+' Hospital(s)<button type="button" class="btn btn-sm btn-primary yahei" onclick="showHospital();"><i class="icon-cog icon-on-right bigger-110"></i>&nbsp;授权</button>'
				WHERE ContractId=@ContractId
			END
			--保存临时修改指标
			IF EXISTS(SELECT 1 FROM Contract.AOPDealerTempHistory WHERE HistoryId=@TempId)
			BEGIN
				SET @CheckAOP=1
				 
				
				Declare @AOP NVARCHAR(500)
				Declare @AOPTotal FLOAT
				Declare @AOPQ1 FLOAT
				Declare @AOPQ2 FLOAT
				Declare @AOPQ3 FLOAT
				Declare @AOPQ4 FLOAT
				Declare @AOPYear NVARCHAR(10)
				
				SELECT @AOPTotal=AOPD_Amount1+AOPD_Amount2+AOPD_Amount3+AOPD_Amount4+AOPD_Amount5+AOPD_Amount6+AOPD_Amount7+AOPD_Amount8+AOPD_Amount9+AOPD_Amount10+AOPD_Amount11+AOPD_Amount12 FROM Contract.AOPDealerTempHistory WHERE HistoryId=@TempId;
				SELECT * INTO #AOPTEMP FROM Contract.AOPDealerTempHistory WHERE HistoryId=@TempId
				
				DECLARE @PRODUCT_CUR cursor;
				SET @PRODUCT_CUR=cursor for 
					SELECT DISTINCT AOPD_Year FROM #AOPTEMP;
				OPEN @PRODUCT_CUR
				FETCH NEXT FROM @PRODUCT_CUR INTO @AOPYear
				WHILE @@FETCH_STATUS = 0        
					BEGIN
						SELECT @AOPQ1=AOPD_Amount1+AOPD_Amount2+AOPD_Amount3 FROM Contract.AOPDealerTempHistory  WHERE HistoryId=@TempId AND AOPD_Year=@AOPYear 
						SELECT @AOPQ2=AOPD_Amount4+AOPD_Amount5+AOPD_Amount6 FROM Contract.AOPDealerTempHistory  WHERE HistoryId=@TempId AND AOPD_Year=@AOPYear 
						SELECT @AOPQ3=AOPD_Amount7+AOPD_Amount8+AOPD_Amount9 FROM Contract.AOPDealerTempHistory  WHERE HistoryId=@TempId AND AOPD_Year=@AOPYear 
						SELECT @AOPQ4=+AOPD_Amount10+AOPD_Amount11+AOPD_Amount12 FROM Contract.AOPDealerTempHistory  WHERE HistoryId=@TempId AND AOPD_Year=@AOPYear 
					
						SET @AOP=(ISNULL(@AOP,'')+@AOPYear+'  [Q1:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@AOPQ1),0)
									+';  Q2:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@AOPQ2),0)
									+';  Q3:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@AOPQ3),0)
									+';  Q4:'+dbo.GetFormatString(CONVERT(NVARCHAR(1000),@AOPQ4),0)+']')
					FETCH NEXT FROM @PRODUCT_CUR INTO @AOPYear
					END
				CLOSE @PRODUCT_CUR
				DEALLOCATE @PRODUCT_CUR ;
				
				UPDATE Contract.AmendmentProposals 
					SET Quota=@AOP,	
					QuotaTotal=CONVERT(Decimal(18,2),@AOPTotal),	
					QUOTAUSD=CONVERT(Decimal(18,2),(@AOPTotal/6.69))	
					--,AllProductAop='',	
					--AllProductAopUSD=''
				WHERE ContractId=@ContractId
			END
			
		END
		
	END
	
	--维护授权
	IF  @CheckAut=1
	BEGIN
		--将调整后数据放入临时表
		INSERT INTO #TempProduct(HistoryId,DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription)
		SELECT HistoryId,DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription 
		FROM  Contract.DealerAuthorizationTableTempHistory WHERE HistoryId=@TempId
		INSERT INTO #HospitalList(HistoryId,ID,Contract_ID,Contract_Type,PL_ID,HOS_ID,Territory_Type,HOS_Depart,HOS_DepartType,HOS_DepartRemark)
		SELECT HistoryId,ID,Contract_ID,Contract_Type,PL_ID,HOS_ID,Territory_Type,HOS_Depart,HOS_DepartType,HOS_DepartRemark
		FROM  Contract.ContractTerritoryHistory WHERE HistoryId=@TempId 
		
		--删除调整后数据
		DELETE Contract.ContractTerritoryHistory WHERE HistoryId=@TempId
		DELETE Contract.DealerAuthorizationTableTempHistory WHERE HistoryId=@TempId
		
		--将当前数据放入历史表
		INSERT INTO Contract.DealerAuthorizationTableTempHistory(HistoryId,DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription )
		SELECT @TempId, DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription 
		FROM DealerAuthorizationTableTemp A 
		WHERE A.DAT_DCL_ID=@ContractId
		
		INSERT INTO Contract.ContractTerritoryHistory(HistoryId,ID,Contract_ID,Contract_Type,PL_ID,HOS_ID,Territory_Type,HOS_Depart,HOS_DepartType,HOS_DepartRemark )
		SELECT @TempId,ID,Contract_ID,Contract_Type,PL_ID,HOS_ID,Territory_Type,HOS_Depart,HOS_DepartType,HOS_DepartRemark
		FROM ContractTerritory A 
		INNER JOIN DealerAuthorizationTableTemp B ON A.Contract_ID=B.DAT_ID
		WHERE B.DAT_DCL_ID=@ContractId
		
		--将临时表中调整后数据放入正式数据
		DELETE  B FROM DealerAuthorizationTableTemp A INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
		WHERE A.DAT_DCL_ID=@ContractId
		DELETE DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@ContractId
		
		INSERT INTO DealerAuthorizationTableTemp (DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription)
		SELECT DAT_PMA_ID,DAT_ID,DAT_DCL_ID,DAT_DMA_ID,DAT_DMA_ID_Actual,DAT_ProductLine_BUM_ID,DAT_AuthorizationType,DAT_HospitalListDesc,DAT_ProductDescription 
		FROM #TempProduct 
		WHERE HistoryId=@TempId
		
		INSERT INTO ContractTerritory (ID,Contract_ID,Contract_Type,PL_ID,HOS_ID,Territory_Type,HOS_Depart,HOS_DepartType,HOS_DepartRemark )
		SELECT ID,Contract_ID,Contract_Type,PL_ID,HOS_ID,Territory_Type,HOS_Depart,HOS_DepartType,HOS_DepartRemark
		FROM  #HospitalList WHERE HistoryId=@TempId 
	END
	
	--维护指标
	IF  @CheckAOP=1
	BEGIN
		INSERT INTO #AopHospital(HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID)
		SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'01',AOPDH_Amount1,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'02',AOPDH_Amount2,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'03',AOPDH_Amount3,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'04',AOPDH_Amount4,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'05',AOPDH_Amount5,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'06',AOPDH_Amount6,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'07',AOPDH_Amount7,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'08',AOPDH_Amount8,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'09',AOPDH_Amount9,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'10',AOPDH_Amount10,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'11',AOPDH_Amount11,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		UNION SELECT HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,'12',AOPDH_Amount12,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID FROM  Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		
		
		INSERT INTO #AopDealer(HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID)
		SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'01',AOPD_Amount1,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'02',AOPD_Amount2,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'03',AOPD_Amount3,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'04',AOPD_Amount4,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'05',AOPD_Amount5,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'06',AOPD_Amount6,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'07',AOPD_Amount7,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'08',AOPD_Amount8,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'09',AOPD_Amount9,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'10',AOPD_Amount10,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'11',AOPD_Amount11,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 
		UNION SELECT HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,'12',AOPD_Amount12,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID FROM  Contract.AOPDealerTempHistory WHERE HistoryId=@TempId 


		DELETE Contract.AOPDealerHospitalTempHistory WHERE HistoryId=@TempId
		DELETE Contract.AOPDealerTempHistory WHERE HistoryId=@TempId
		
		INSERT INTO Contract.AOPDealerHospitalTempHistory(HistoryId,AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Amount1,AOPDH_Amount2,AOPDH_Amount3,AOPDH_Amount4,AOPDH_Amount5,AOPDH_Amount6,AOPDH_Amount7,AOPDH_Amount8,AOPDH_Amount9,AOPDH_Amount10,AOPDH_Amount11,AOPDH_Amount12,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID )
		SELECT @TempId, NEWID(),AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Amount_1,AOPDH_Amount_2,AOPDH_Amount_3,AOPDH_Amount_4,AOPDH_Amount_5,AOPDH_Amount_6,AOPDH_Amount_7,AOPDH_Amount_8,AOPDH_Amount_9,AOPDH_Amount_10,AOPDH_Amount_11,AOPDH_Amount_12,null,GETDATE(),AOPDH_PCT_ID
		FROM V_AOPDealerHospital_Temp A 
		WHERE A.AOPDH_Contract_ID=@ContractId
		
		INSERT INTO Contract.AOPDealerTempHistory(HistoryId,AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Amount1,AOPD_Amount2,AOPD_Amount3,AOPD_Amount4,AOPD_Amount5,AOPD_Amount6,AOPD_Amount7,AOPD_Amount8,AOPD_Amount9,AOPD_Amount10,AOPD_Amount11,AOPD_Amount12,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID)
		SELECT @TempId, NEWID(),AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Amount_1,AOPD_Amount_2,AOPD_Amount_3,AOPD_Amount_4,AOPD_Amount_5,AOPD_Amount_6,AOPD_Amount_7,AOPD_Amount_8,AOPD_Amount_7,AOPD_Amount_10,AOPD_Amount_11,AOPD_Amount_12,null,GETDATE(),AOPD_CC_ID
		FROM V_AOPDealer_Temp A 
		WHERE A.AOPD_Contract_ID=@ContractId
		
		DELETE  A FROM AOPDealerHospitalTemp A  WHERE A.AOPDH_Contract_ID=@ContractId
		DELETE AOPDealerTemp WHERE AOPD_Contract_ID=@ContractId
		
		INSERT INTO AOPDealerHospitalTemp (AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID)
		SELECT NEWID(),AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date,AOPDH_PCT_ID
		FROM #AopHospital 
		WHERE HistoryId=@TempId
		
		INSERT INTO AOPDealerTemp (AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID )
		SELECT NEWID(),AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date,AOPD_CC_ID
		FROM  #AopDealer WHERE HistoryId=@TempId 
		
	END


	SET @IsValid = 'Success';
COMMIT TRAN

SET NOCOUNT OFF
return 1
END TRY
BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    return -1
    
END CATCH







GO


