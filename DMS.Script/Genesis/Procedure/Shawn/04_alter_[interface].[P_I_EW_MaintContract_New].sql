
/****** Object:  StoredProcedure [interface].[P_I_EW_MaintContract_New]    Script Date: 2019/11/21 17:26:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
维护合同主数据
*/
ALTER Procedure [interface].[P_I_EW_MaintContract_New]
	@InstanceID NVARCHAR(36),	  
	@Contract_Type NVARCHAR(50),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS BEGIN
	DECLARE @UserID uniqueidentifier
	Set  @UserID =@InstanceID;
	DECLARE @ContractID uniqueidentifier
	DECLARE @ContractType NVARCHAR(50)
	DECLARE @DMA_ID uniqueidentifier
	DECLARE @DealerLevel NVARCHAR(20)
	DECLARE @DealerName NVARCHAR(100)
	DECLARE @DealerEnName NVARCHAR(200)
	DECLARE @ProductLine NVARCHAR(4000)
	DECLARE @ProductLineRenewal NVARCHAR(4000)
	DECLARE @EMail NVARCHAR(200)
	--DECLARE @TerritoryRenewal NVARCHAR(4000)
	DECLARE @CM_ID uniqueidentifier
	DECLARE @DealerType NVARCHAR(5)
	DECLARE @Parent_DMA_ID uniqueidentifier
	DECLARE @OperationType Int --判断操作类型：0.新增 ，其他表示修改
	DECLARE @CheckConMat Int --判断是否已维护合同主表：0.没有维护
	DECLARE @DMA_ID_Midd uniqueidentifier
	--Termination 参数
	DECLARE @DMACountry NVARCHAR(100)
	--Add by Hua 2015-11-13
	DECLARE @DealerMark NVARCHAR(200)
	DECLARE @DealerMarketType INT
	DECLARE @SubCompanyId UNIQUEIDENTIFIER
    
	

	
	--判断操作类型
	SELECT @OperationType=COUNT(*) FROM interface.T_I_EW_Contract  (nolock) WHERE InstanceID=@InstanceID
	
	--从E-workeflow临时表同步到DCMS临时表
	if(@Contract_Type='Appointment')
	BEGIN
		IF(@OperationType<>0)
		BEGIN
			SELECT @CheckConMat=COUNT(*) FROM ContractAppointment (nolock) WHERE CAP_ID=@InstanceID AND CAP_CM_ID<>'00000000-0000-0000-0000-000000000000'
			IF(@CheckConMat>0)
			BEGIN
				SELECT @CM_ID=CAP_CM_ID FROM ContractAppointment (nolock) WHERE CAP_ID=@InstanceID 
			END
			--获取经销商ID
			SELECT  @DMA_ID_Midd=CAP_DMA_ID FROM ContractAppointment (nolock) WHERE CAP_ID=@InstanceID;
			DELETE interface.T_I_EW_Contract WHERE InstanceID=@InstanceID;
			DELETE ContractAppointment WHERE CAP_ID=@InstanceID;
			
		END
		INSERT INTO interface.T_I_EW_Contract(SubDepID,
						InstanceID,UserID,ContractID,Contract_Type,MarketType,
						DMA_ID,Dealer_Name,Dealer_EN_Name,DealerType,Parent_DMA_ID,Contact_Person,Email_Address,Office_Number,Mobile_Phone,Office_Address,Company_Type,Established_Time,Registered_Capital,Website,
						Healthcare_Experience,Interventional_Experience,KOL_Relationships,Business_Partnerships,Competency_Justifications,
						Non_Compete,Non_Compete_Reason,Sub_Dealers,HasConflict_Interest,HasConflict_Interest_Remarks,HasConflict_Dealer,Conflict_Dealer_Remarks,
						Business_License,Medical_License,Tax_Registration,
						FCPA_Concerns_Property1,FCPA_Concerns_Property2,FCPA_Concerns_Property3,FCPA_Concerns_Other,
						Interview_Date,Venue,Interview,Interview_Findings,COCTraining_Date,
						Division,Recommender,Job_Title,DealerLevel,
						ARContract_Type,BSC_Entity,Exclusiveness,Agreement_EffectiveDate,Agreement_ExpirationDate,ProductLine,ProductLine_Remarks,Price,Price_Remarks,Special_Sales,Special_Sales_Remarks,Payment_Term,Credit_Limit,Security_Deposit,Open_Account,Guarantee_Way,Guarantee_Way_Remark,
						Attachment,Reason,FormeRname,DealerMark,PayTerm,IsDeposit
						)
						SELECT top 1 SubDepID,
						CONVERT(uniqueidentifier,Main.ContractId),CONVERT(uniqueidentifier,@UserID),CONVERT(uniqueidentifier,Main.ContractId),'Appointment',MARKETTYPE,
						CompanyID,CompanyName,CompanyEName,IsEquipment,(SELECT DealerMaster.DMA_ID FROM DealerMaster WHERE DealerMaster.DMA_SAP_Code=LPSAPCode ),Contact,EMail,OfficeNumber,Mobile,OfficeAddress,CompanyType,EstablishedTime,Capital,Website,
						Healthcare,Inter,KOL,MNC,Justification,
						null Compete,null CompeteRemark,null SubDealer,null Interest,null InterestRemark,null Exclusive,null ExclusiveRemark,
						Documents.BizLicense,Documents.MedicalLicense,Documents.Tax,
						null Officials, null CompanyB, null ShareholdersB,null Others,
						null Interview,null Venue,null Interviewee,null Findings,null COCTraining,
						(SELECT DEP.DivisionName FROM V_DivisionProductLineRelation DEP WHERE DEP.DivisionCode=Convert(NVARCHAR(10),Main.DepId) AND DEP.IsEmerging='0') as Division
						,Main.EName,Main.ETitle,(case when isnull(Main.DealerType,'')='RLD' THEN 'LP' ELSE Main.DealerType END)  AS  DealerType,
						Proposals.ContractType,BSC,Exclusiveness,AgreementBegin,AgreementEnd,(case when Product='All' then 'All' else isnull(ProductRemark,Product) end)   ,ProductRemark,Price,PriceRemark,SpecialSales,SpecialSalesRemark,Payment,CreditLimit,Deposit,CreditTerm,Inform,InformOther
						,Proposals.Attachment,Main.Reason,Main.FormeRname,Candidate.DealerMark
						--,Comment
						,PayTerm,IsDeposit
						FROM Contract.AppointmentMain Main (nolock)
						LEfT join  Contract.AppointmentCompetency Competency (nolock) on Main.ContractId=Competency.ContractId
						--inner join  Contract.AppointmentConflict Conflict  on Conflict.ContractId=Competency.ContractId
						inner join  Contract.AppointmentDocuments Documents (nolock) on Documents.ContractId=Main.ContractId
						--inner join Contract.AppointmentFCPA FCPA on FCPA.ContractId=Competency.ContractId
						--inner join Contract.AppointmentInterView InterView on InterView.ContractId=Competency.ContractId
						inner join Contract.AppointmentCandidate Candidate  (nolock) on Candidate.ContractId=Main.ContractId
						inner join Contract.AppointmentProposals  Proposals (nolock)  on Proposals.ContractId=Main.ContractId
						WHERE  Main.ContractId=@InstanceID
	
	END
	if(@Contract_Type='Amendment')
	BEGIN
		IF(@OperationType<>0)
		BEGIN
			DELETE interface.T_I_EW_Contract WHERE InstanceID=@InstanceID;
			DELETE ContractAmendment WHERE CAM_ID=@InstanceID;
		END
		SELECT @CM_ID=CM_ID ,@DMACountry=CM_Country
		FROM ContractMaster cm (nolock)
		INNER JOIN DealerMaster dm  (nolock) ON  cm.CM_DMA_ID=dm.DMA_ID
		INNER JOIN [interface].[Biz_Dealer_Amend_Main] ifMain (nolock) on ifMain.DealerName=dm.DMA_SAP_Code
		WHERE ifMain.ApplicationID=@InstanceID;
		
		INSERT INTO interface.T_I_EW_Contract
		(SubDepID,InstanceID,UserID,ContractID,Contract_Type,DMA_ID,DealerLevel
		 ,Dealer_Name,MarketType,Division, Amendment_Purpose
		 ,Agreement_EffectiveDate,Agreement_ExpirationDate,Amendment_EffectiveDate
		 ,Standard_Amendment
		 ,ProductLine_IsChange,ProductLine,ProductLine_Renewal,ProductLine_Remarks
		 ,Price_IsChange,Price,Price_Renewal,Price_Remarks
		 ,Special_IsChange,Special_Sales,Special_Sales_Renewal,Special_Sales_Remarks
		 ,Territory_IsChange,Territory_Remarks,Quota_IsChange,Quotas_Remarks
		 ,Payment_IsChange,Payment_Term,Payment_Term_Renewal,Payment_Term_Remarks
		 ,Credit_Limit_IsChange,Credit_Limit,CreditLimit_Renewal,CreditLimit_Remarks
		 ,Open_Account,Open_Account_Renewal,Guarantee_Way,Guarantee_Way_Renewal,GuaranteeW_Renl_Remark
		 ,Security_Deposit,Security_Deposit_Renewal,Security_Deposit_Remarks
		 ,Attachment,Attachment_Renewal
		 ,HasConflict_Dealer,Conflict_Dealer_Remarks,Business_Handover,PayTerm,IsDeposit
		 )
		 SELECT top 1 SubDepID,CONVERT(uniqueidentifier,mian.ContractId),CONVERT(uniqueidentifier,@UserID),CONVERT(uniqueidentifier,mian.ContractId),'Amendment',(SELECT DMA_ID FROM DealerMaster WHERE DMA_SAP_Code=mian.DealerName), dm.DMA_DealerType,
		 dm.DMA_ChineseName,mian.MarketType,(SELECT DEP.DivisionName FROM V_DivisionProductLineRelation DEP WHERE DEP.DivisionCode=Convert(NVARCHAR(10),mian.DepId) AND IsEmerging='0') as Division
		,mian.Purpose
		,mian.DealerBeginDate,mian.DealerEndDate,mian.AmendEffectiveDate
		,null
		,tCurrent.ProductAmend,(dcm.DCM_ProductLine+' '+ISNULL(dcm.DCM_ProductLineRemark,'')),proposals.Product, proposals.ProductRemark
		,tCurrent.PriceAmend,(ISNULL(dcm.DCM_Pricing_Discount,'')+'% off standard price list '+ISNULL(dcm.DCM_Pricing_Discount_Remark,'')), proposals.Price,proposals.PriceRemark
		,tCurrent.SalesAmend,(ISNULL(dcm.DCM_Pricing_Rebate,'')+'% of the quarter purchase ammount '+ISNULL(dcm.DCM_Pricing_Rebate_Remark,'')),proposals.SpecialSales,proposals.SpecialSalesRemark
		,tCurrent.HospitalAmend,proposals.Hospital,tCurrent.QuotaAmend,proposals.Quota
		,tCurrent.PaymentAmend,dcm.DCM_Payment_Term,proposals.Payment,null
		,null,dcm.DCM_Credit_Limit,proposals.CreditLimit,null
		,dcm.DCM_Credit_Term,proposals.CreditTerm,	dcm.DCM_Guarantee,proposals.Inform,InformOther
		,dcm.DCM_Security_Deposit,Proposals.Deposit,''
		,dcm.DCM_Attachment,proposals.Attachment
		,ncm.Conflict,	ncm.ConflictRemark,ncm.HandoverRemark
		,proposals.PayTerm,proposals.IsDeposit
		 FROM Contract.AmendmentMain mian (nolock) 
		 INNER JOIN Contract.AmendmentCurrent tCurrent (nolock) ON  mian.ContractId=tCurrent.ContractId
		 INNER JOIN Contract.AmendmentProposals proposals (nolock) ON tCurrent.ContractId=proposals.ContractId
		 INNER JOIN Contract.AmendmentNCM ncm (nolock) ON proposals.ContractId=ncm.ContractId
		 INNER JOIN DealerMaster dm (nolock) ON dm.DMA_SAP_Code=mian.DealerName and dm.DMA_DealerType=mian.DealerType
		 INNER JOIN interface.ClassificationContract cc (nolock) on cc.CC_Code=mian.SubDepID
		 LEFT JOIN DealerContractMaster dcm (nolock) 
		 on dcm.DCM_DMA_ID=dm.DMA_ID and dcm.DCM_Division=mian.DepId 
		 and dcm.DCM_DealerType=mian.DealerType and ISNULL(dcm.DCM_MarketType,'')=ISNULL(mian.MarketType,'')
		 and dcm.DCM_CC_ID=cc.CC_ID
		 WHERE mian.ContractId=@InstanceID
		
	END
	
	if(@Contract_Type='Termination')
	BEGIN
		IF(@OperationType<>0)
		BEGIN
			DELETE interface.T_I_EW_Contract WHERE InstanceID=@InstanceID;
			DELETE ContractTermination WHERE CTE_ID=@InstanceID;
			DELETE TerminationForm WHERE TF_ID=@InstanceID;
		END
		SELECT @CM_ID=CM_ID ,@DMACountry=CM_Country
		FROM ContractMaster cm (nolock)
		INNER JOIN DealerMaster dm (nolock) ON  cm.CM_DMA_ID=dm.DMA_ID
		INNER JOIN [interface].[Biz_Dealer_End_Main] ifMain (nolock) on ifMain.DealerName=dm.DMA_SAP_Code
		WHERE ifMain.ApplicationID=@InstanceID;
		
		INSERT INTO interface.T_I_EW_Contract(SubDepID,
		InstanceID,UserID,ContractID,Contract_Type,DMA_ID,DealerLevel,
		Dealer_Name,MarketType,Division,Agreement_ExpirationDate,Termination_EffectiveDate,
		TerminationStatus,TerminationsReasons,TerminationsReasonsRemark,PendTender,PendTenderRemark,
		TheRebate,RebateRemark,Promotion,PromotionAmount,Complaint,
		ComplaintAmount,TermRetn,TermRetnAmount,TermRetnRemark,ScarletLetter,
		
		ScarletLetterRemark,DisputeMoney,DisputeMoneyAmount,DisputeMoneyRemark,CurrentAR,
		CurrentARRemark,CashDeposit,CashDepositAmount,Bguarantee,BGuaranteeAmount,
		Cguarantee,CGuaranteeAmount,Inventory,InventoryAmount,EstimatedAR,
		EstimatedARWirte,PaymentPlan,TakeOver,TakeOverType,TakeOverNew,Timeline_HasNotified,
		Timeline_WhenNotify,Timeline_WhenSettlement,Timeline_WhenHandover,HasCommunications,HasSettlementProposals,
		HasBusinessHandover,BusinessHandover_Specify
		)
		SELECT top 1 SubDepID,CONVERT(uniqueidentifier,Main.ContractId),CONVERT(uniqueidentifier,@UserID),CONVERT(uniqueidentifier,Main.ContractId),'Termination',(SELECT DMA_ID FROM DealerMaster WHERE DMA_SAP_Code=Main.DealerName),(SELECT DMA_DealerType FROM DealerMaster WHERE DMA_SAP_Code=Main.DealerName),
		(SELECT DMA_ChineseName FROM DealerMaster WHERE DMA_SAP_Code=Main.DealerName),Main.MarketType,(SELECT DEP.DivisionName FROM V_DivisionProductLineRelation DEP WHERE DEP.DivisionCode=Convert(NVARCHAR(10),Main.DepId) AND DEP.IsEmerging='0') as Division,
		DealerEndDate,PlanExpiration,
		DealerEndTyp,DealerEndReason,OtherReason,TenderIssue,TenderIssueRemark,
		[Rebate],[RebateAmt],[Promotion],[PromotionAmt],[Complaint],
		[ComplaintAmt],[GoodsReturn],[GoodsReturnAmt],[ReturnReason],[CreditMemo],
		[CreditMemoRemark],[IsPendingPayment],[PendingAmt],[PendingRemark],[CurrentAR],
		null,[CashDeposit],[CashDepositAmt],[BGuarantee],[BGuaranteeAmt],
		[CGuarantee],[CGuaranteeAmt],[Inventory],[InventoryAmt],[EstimatedAR],
		[Wirteoff],[PaymentPlan],[TakeOver],[TakeOverType],[TakeOverIsNew],Handover.Notified,
		WhenNotify,WhenSettlement,WhenHandover,NCM.Notified,Reviewed,
		NCM.Handover,HandoverRemark
		
		FROM Contract.TerminationMain Main (nolock)
		INNER JOIN Contract.TerminationStatus Staus (nolock) ON Main.ContractId=Staus.ContractId
		INNER JOIN Contract.TerminationNCM Ncm (nolock) ON Ncm.ContractId=Main.ContractId
		INNER JOIN Contract.TerminationHandover  Handover (nolock) ON Handover.ContractId=Main.ContractId
		WHERE Main.ContractId=@InstanceID
	END
	IF(@Contract_Type='Renewal')
	BEGIN
		IF(@OperationType<>0)
		BEGIN
			DELETE interface.T_I_EW_Contract WHERE InstanceID=@InstanceID;
			DELETE ContractRenewal WHERE CRE_ID=@InstanceID;
		END
		SELECT @CM_ID=CM_ID ,@DMACountry=CM_Country
		FROM ContractMaster cm (nolock)
		INNER JOIN DealerMaster dm (nolock) ON  cm.CM_DMA_ID=dm.DMA_ID
		INNER JOIN [interface].[Biz_Dealer_End_Main] ifMain (nolock) on ifMain.DealerName=dm.DMA_SAP_Code
		WHERE ifMain.ApplicationID=@InstanceID;
		
		INSERT INTO interface.T_I_EW_Contract
		(SubDepID,InstanceID,UserID,ContractID,Contract_Type,DMA_ID,DealerLevel
		 ,Dealer_Name,MarketType,Division,
		 ARContract_Type,ContractType_Renewal,ContractType_Remarks
		 ,BSC_Entity,BSC_Entity_Renewal,BSC_Entity_Remarks,Exclusiveness,Exclusiveness_Renewal,Exclusiveness_Remarks
		 ,Agreement_EffectiveDate,Agreement_ExpirationDate,Agreement_EffectiveDate_Renewal,Agreement_ExpirationDate_Renewal,AgreementTerm_Remarks
		 ,ProductLine,ProductLine_Renewal,ProductLine_Remarks
		 ,Price,Price_Renewal,Price_Remarks,Special_Sales,Special_Sales_Renewal,Special_Sales_Remarks,Quotas_Remarks
		 ,Payment_Term,Payment_Term_Renewal,Payment_Term_Remarks,Credit_Limit,CreditLimit_Renewal,CreditLimit_Remarks
		 ,Security_Deposit,Security_Deposit_Renewal,Security_Deposit_Remarks
		 ,HasConflict_Dealer,Conflict_Dealer_Remarks,Business_Handover
		 ,Open_Account,Open_Account_Renewal,Guarantee_Way,Guarantee_Way_Renewal,GuaranteeW_Renl_Remark
		 ,Attachment,Attachment_Renewal,PayTerm,IsDeposit
		)
		SELECT top 1 SubDepID, CONVERT(uniqueidentifier,main.ContractId),CONVERT(uniqueidentifier,@UserID),CONVERT(uniqueidentifier,main.ContractId),'Renewal',(SELECT DMA_ID FROM DealerMaster WHERE DMA_SAP_Code=Main.DealerName), dm.DMA_DealerType,
		dm.DMA_ChineseName,Main.MarketType,(SELECT DEP.DivisionName FROM V_DivisionProductLineRelation DEP WHERE DEP.DivisionCode=Convert(NVARCHAR(10),Main.DepId) AND IsEmerging='0') as Division,
		dcm.DCM_ContractType,Proposals.ContractType,''
		,dcm.DCM_BSCEntity,Proposals.BSC,'',dcm.DCM_Exclusiveness,Proposals.Exclusiveness,''
		,dcm.DCM_EffectiveDate,dcm.DCM_ExpirationDate,Proposals.AgreementBegin,Proposals.AgreementEnd,''
		,(dcm.DCM_ProductLine+' '+ ISNULL(dcm.DCM_ProductLineRemark,'')),Proposals.Product,Proposals.ProductRemark
		,isnull(dcm.DCM_Pricing_Discount,''),isnull(Proposals.Price,''),Proposals.PriceRemark,isnull(dcm.DCM_Pricing_Rebate,''),isnull(Proposals.SpecialSales,''),Proposals.SpecialSalesRemark,''
		,isnull(dcm.DCM_Payment_Term,''),isnull(Proposals.Payment,''),'',dcm.DCM_Credit_Limit,Proposals.CreditLimit,''
		,isnull(dcm.DCM_Security_Deposit,''),isnull(Proposals.Deposit,''),''
		,ncm.Conflict,ncm.ConflictRemark,ncm.HandoverRemark
		,dcm.DCM_Credit_Term,proposals.CreditTerm,	dcm.DCM_Guarantee,proposals.Inform,InformOther
		,dcm.DCM_Attachment,proposals.Attachment
		--,ncm.Handover
		,Proposals.PayTerm,Proposals.IsDeposit
		FROM Contract.RenewalMain main (nolock)
		INNER JOIN Contract.RenewalProposals Proposals (nolock) ON main.ContractId=Proposals.ContractId
		INNER JOIN Contract.RenewalNCM ncm (nolock) ON  Proposals.ContractId=ncm.ContractId
		INNER JOIN DealerMaster dm (nolock) ON dm.DMA_SAP_Code=Main.DealerName and dm.DMA_DealerType=main.DealerType
		INNER JOIN interface.ClassificationContract cc (nolock) on cc.CC_Code=main.SubDepID
		LEFT JOIN DealerContractMaster dcm (nolock) on dcm.DCM_DMA_ID=dm.DMA_ID 
					and dcm.DCM_DealerType=main.DealerType 
					and dcm.DCM_Division=Main.DepId 
					and ISNULL(dcm.DCM_MarketType,'')=ISNULL(Main.MarketType,'')
					and dcm.DCM_CC_ID=cc.CC_ID
		WHERE Main.ContractId=@InstanceID
	END
	
	
	
	--从DCMS临时表同步到DCMS正式表
	SELECT	@ContractID=ContractID,
			@ContractType=Contract_Type,
			@DMA_ID=DMA_ID,
			@DealerName=Dealer_Name,
			@DealerEnName=Dealer_EN_Name,
			@ProductLine=ProductLine,
			@ProductLineRenewal=ProductLine_Renewal,
			@EMail= Email_Address ,
			--@Territory=Territory ,
			--@TerritoryRenewal=Territory_Renewal,
			@DealerLevel=Case  when DealerLevel='Trade' then 'T1' else DealerLevel end ,
			@DealerType=DealerType,
			@Parent_DMA_ID=Parent_DMA_ID,
			@DealerMark=DealerMark,
			@DealerMarketType=case when isnull(MarketType,2)=2 then 0 else  isnull(MarketType,2) end
	FROM interface.T_I_EW_Contract (nolock)
	WHERE InstanceID=@InstanceID AND UserID=@UserID;
	
	IF (@DealerLevel='T1' OR @DealerLevel='LP' OR @DealerLevel='LS')
	BEGIN
		IF (@ContractType='Appointment' OR @ContractType='Amendment'OR @ContractType='Termination')
		BEGIN
			--不为空表示合同修改，并且经销商已经维护过IAF
			IF(@CM_ID IS NULL)
			BEGIN
				SET @CM_ID='00000000-0000-0000-0000-000000000000';
			END
		END
		ELSE IF (@ContractType='Renewal')
		BEGIN
			SELECT @CM_ID=CM_ID FROM ContractMaster MS WHERE MS.CM_DMA_ID=@DMA_ID
		END
	END
	ELSE
	BEGIN
		--二级经销商不需要维护
		SET @CM_ID='00000000-0000-0000-0000-000000000000'
	END

	--获取分子公司
	SELECT @SubCompanyId=SubCompanyId FROM dbo.V_DivisionProductLineRelation dpr 
	WHERE dpr.DivisionCode=(SELECT TOP 1 DepId FROM (SELECT DepId FROM Contract.AppointmentMain ap WHERE ap.ContractId=@ContractID
	UNION SELECT DepId FROM Contract.AmendmentMain am WHERE am.ContractId=@ContractID
	UNION SELECT DepId FROM Contract.RenewalMain rm WHERE rm.ContractId=@ContractID
	UNION SELECT DepId FROM Contract.TerminationMain tm WHERE tm.ContractId=@ContractID) x)
	
	--一.维护基础数据
	IF (@ContractType='Appointment')
		BEGIN
			DECLARE @CheckId int
			DECLARE @drParameters NVARCHAR(5) --Appointment经销商是否已经存在
			DECLARE @SameDealerNameType NVARCHAR(20)
			IF(@DMA_ID_Midd IS NULL)
			BEGIN
				SELECT @CheckId=Count(*) FROM DealerMaster dm (nolock) WHERE (dm.DMA_ID=@DMA_ID OR dm.DMA_ChineseName=@DealerName) and dm.DMA_DealerType=@DealerLevel and dm.DMA_ActiveFlag=1 and (@Parent_DMA_ID is null OR DMA_Parent_DMA_ID= @Parent_DMA_ID) and @DealerMarketType=ISNULL(DMA_MarketType,0)
				IF (@CheckId=0)
				BEGIN
					SET @drParameters='NEW';
				END
				ELSE 
				BEGIN
					SET @drParameters='OLD';
					--不同合同对应同一家修改经销商信息
					SET @SameDealerNameType='DiffContract'
				END
			END
			ELSE
				BEGIN
					SET @drParameters='OLD';
					--同一张合同修改经销商信息
					SET @SameDealerNameType='SameContract' 
				END
			
			IF (@drParameters='NEW')
			BEGIN
				--1.1创建账号分配权限
				----1.1.1导入经销商
				DECLARE @SAPCode NVARCHAR(20)
				IF @DealerLevel='T2'
				BEGIN
					IF(@Parent_DMA_ID IS NOT NULL)
					BEGIN
						--DRM要求这样修改
						IF (@Parent_DMA_ID IN ('3D9B9EA0-1214-42CA-A2EF-D93C5C887040','2F2D2BD9-6FAE-4A40-BC44-8E5FECC1C6DD'))
						BEGIN
							SELECT @SAPCode=MAX(DealerMaster.DMA_SAP_Code)+1 FROM DealerMaster (nolock) 
							WHERE DealerMaster.DMA_DealerType='T2' AND DMA_Parent_DMA_ID in ('3D9B9EA0-1214-42CA-A2EF-D93C5C887040','2F2D2BD9-6FAE-4A40-BC44-8E5FECC1C6DD');
						END
						ELSE
						BEGIN
							SELECT @SAPCode=MAX(DealerMaster.DMA_SAP_Code)+1 FROM DealerMaster (nolock) 
							WHERE DealerMaster.DMA_DealerType='T2' AND DMA_Parent_DMA_ID=@Parent_DMA_ID;
						END
						
						
						IF @Parent_DMA_ID='A00FCD75-951D-4D91-8F24-A29900DA5E85'
						BEGIN
							IF @SAPCode='3000' 
							BEGIN
								--方程由2开头转到6开头
								SET @SAPCode='6000'
							END
						END
						IF @Parent_DMA_ID='84C83F71-93B4-4EFD-AB51-12354AFABAC3'
						BEGIN
							--IF	@SAPCode='4000'
							--BEGIN
							--	--国科由3开头转到9开头 
							--	SET @SAPCode='7000'
							--END
							SELECT @SAPCode=MAX(DealerMaster.DMA_SAP_Code)+1 FROM DealerMaster 
							WHERE DealerMaster.DMA_DealerType='T2' AND DMA_Parent_DMA_ID in ('84C83F71-93B4-4EFD-AB51-12354AFABAC3','192106C0-F51C-45BD-8725-DCED4F36E26D');
								
						END
						IF @Parent_DMA_ID='33029AF0-CFCF-495E-B057-550D16C41E4A'
						BEGIN
							--方承蓝海
							IF ISNULL(@SAPCode,'')=''
							BEGIN
								SET @SAPCode='4001'
							END
						END
						IF @Parent_DMA_ID='A54ADD15-CB13-4850-9848-6DA4576207CB'
						BEGIN
							--国科蓝海
							IF ISNULL(@SAPCode,'')=''
							BEGIN
								SET @SAPCode='5001'
							END
						END
						IF @Parent_DMA_ID='2F2D2BD9-6FAE-4A40-BC44-8E5FECC1C6DD' or @Parent_DMA_ID='3D9B9EA0-1214-42CA-A2EF-D93C5C887040'
						BEGIN
							--国药河南
							IF ISNULL(@SAPCode,'')=''
							BEGIN
								
								SELECT @SAPCode=MAX(DealerMaster.DMA_SAP_Code)+1 FROM DealerMaster 
								WHERE DealerMaster.DMA_DealerType='T2' AND DMA_Parent_DMA_ID in ('3D9B9EA0-1214-42CA-A2EF-D93C5C887040','2F2D2BD9-6FAE-4A40-BC44-8E5FECC1C6DD');
								
							END
						END
						IF @Parent_DMA_ID='192106C0-F51C-45BD-8725-DCED4F36E26D'--不在使用 编号预留给国科红海二级
						BEGIN
							--国科恒瑞（北京）医疗科技有限公司 
							IF ISNULL(@SAPCode,'')=''
							BEGIN
								SET @SAPCode='9001'
							END
						END
						IF @Parent_DMA_ID='C4F0725F-D325-4730-BC0C-DBBE4CA3F4BD'
						BEGIN
							--上海秉程医疗器械有限公司
							IF ISNULL(@SAPCode,'')=''
							BEGIN
								SET @SAPCode='1001'
							END
						END
					END
					ELSE
					BEGIN
						SELECT @SAPCode=MAX(DealerMaster.DMA_SAP_Code)+1 FROM DealerMaster WHERE DealerMaster.DMA_DealerType='T2';
					END
				END
				ELSE 
				BEGIN
					--select @SAPCode=REPLACE(REPLACE(REPLACE(CONVERT(varchar,GETDATE(),120),'-',''),' ',''),':','');
					SELECT @SAPCode=SAPCode FROM contract.AppointmentCandidate where contractid=@InstanceID
				END
				insert into DealerMaster
					  (DMA_ID,DMA_SAP_Code,DMA_ChineseName,DMA_ChineseShortName,DMA_EnglishName,DMA_EnglishShortName,DMA_ActiveFlag,DMA_DealerType,DMA_HostCompanyFlag,DMA_Email
					  ,DMA_CompanyType,DMA_Phone,DMA_ContactPerson,DMA_Address,DMA_Reason,DMA_FormeRname,DMA_MarketType,DMA_SubCompanyId)
				SELECT DMA_ID, @SAPCode,@DealerName,@DealerName, @DealerEnName, null,1, @DealerLevel,'0',@EMail
					   ,CASE WHEN Company_Type='Trade' THEN 'T1' ELSE Company_Type END,Mobile_Phone,Contact_Person,Office_Address,Reason,FormeRname
					   ,case when isnull( MarketType,0)=2 then 0 else isnull( MarketType,0)end AS MarketType,@SubCompanyId
				FROM interface.T_I_EW_Contract (nolock)
				WHERE InstanceID=@InstanceID AND UserID=@UserID;
				
				insert into dbo.DealerMark (ID,DMA_ID,DealerMark) 
				SELECT NEWID(),DMA_ID,@DealerMark FROM interface.T_I_EW_Contract (nolock)
				WHERE InstanceID=@InstanceID AND UserID=@UserID; 
			
				--维护经销商主表数据
				IF NOT EXISTS(SELECT 1 FROM DealerMasterMain WHERE DMM_ChineseName=@DealerName)
				BEGIN
					insert into DealerMasterMain
					  (DMM_ID,DMM_ERP_Code,DMM_ChineseName,DMM_EnglishName,DMM_EnglishShortName,DMM_ActiveFlag,DMM_DealerType
					  ,DMM_CompanyType,DMM_Address)
					SELECT NewID(), @SAPCode,@DealerName, @DealerEnName, null,1, @DealerLevel
						   ,CASE WHEN Company_Type='Trade' THEN 'T1' ELSE Company_Type END,Office_Address
					FROM interface.T_I_EW_Contract (nolock)
					WHERE InstanceID=@InstanceID AND UserID=@UserID;
				END
				ELSE
				BEGIN
					UPDATE DealerMasterMain
					SET   DMM_ERP_Code = @SAPCode,
					      DMM_EnglishName = @DealerEnName,
						  DMM_DealerType = @DealerLevel,
						  DMM_CompanyType = (SELECT CASE WHEN Company_Type='Trade' THEN 'T1' ELSE Company_Type END FROM interface.T_I_EW_Contract (nolock) WHERE InstanceID=@InstanceID AND UserID=@UserID),
						  DMM_Address = (SELECT Office_Address FROM interface.T_I_EW_Contract (nolock) WHERE InstanceID=@InstanceID AND UserID=@UserID)
					WHERE DMM_ChineseName = @DealerName
				END
				----1.1.2更新上级经销商
				--一级
				update DealerMaster set DealerMaster.DMA_Parent_DMA_ID = 'FB62D945-C9D7-4B0F-8D26-4672D2C728B7'
				where DealerMaster.DMA_DealerType in ('LP','T1','LS')
				and DealerMaster.DMA_ID=@DMA_ID;
				--二级（所属一级）
				IF(@Parent_DMA_ID IS NOT NULL)
				BEGIN
					UPDATE  DealerMaster SET DMA_Parent_DMA_ID=@Parent_DMA_ID
					,DMA_ChineseShortName=DMA_ChineseName+' - '+DMA_SAP_Code+' - T2 - '+
					(select top 1 a.VALUE1 from Lafite_DICT a 
						inner join DealerMaster c  on a.DICT_KEY=c.DMA_SAP_Code
						where DICT_TYPE='CONST_DealerShortName'  
						and c.DMA_ID=@Parent_DMA_ID ) 
					WHERE DealerMaster.DMA_ID=@DMA_ID;
				END

				DECLARE @BusinessContact NVARCHAR(200)
				DECLARE @BusinessEMail NVARCHAR(200)
				DECLARE @BusinessMobile NVARCHAR(200)
				SELECT @BusinessContact=BusinessContact,	@BusinessEMail=BusinessEMail,	@BusinessMobile=BusinessMobile FROM Contract.AppointmentCandidate WHERE ContractId=@ContractID
				----1.1.3添加用户角色
				DECLARE @IDENTITY_ID uniqueidentifier
				DECLARE @IDENTITY_ID_ADMIN UNIQUEIDENTIFIER
                DECLARE @CompanyAbbr NVARCHAR(2)
				SET @IDENTITY_ID=NEWID();
				SET @IDENTITY_ID_ADMIN=NEWID();
				SET @CompanyAbbr=ISNULL((SELECT TOP 1 REV1 FROM dbo.Lafite_ATTRIBUTE WHERE ATTRIBUTE_TYPE='SUBCOMPANY' AND Id=@SubCompanyId),'BP');
				INSERT INTO Lafite_IDENTITY 
							(Id,IDENTITY_CODE,LOWERED_IDENTITY_CODE,IDENTITY_NAME,
							BOOLEAN_FLAG,IDENTITY_TYPE,LastActivityDate,Corp_ID,APP_ID,DELETE_FLAG,
							CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE,PHONE,EMAIL1)
						VALUES(@IDENTITY_ID,@CompanyAbbr+'_'+@SAPCode+'_01',@CompanyAbbr+'_'+@SAPCode+'_01',@BusinessContact,
							1,'Dealer',getdate(),@DMA_ID,'4028931b0f0fc135010f0fc1356a0001',0,
							'00000000-0000-0000-0000-000000000000',GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE(),@BusinessMobile,@BusinessEMail);
				
				INSERT INTO Lafite_IDENTITY 
							(Id,IDENTITY_CODE,LOWERED_IDENTITY_CODE,IDENTITY_NAME,
							BOOLEAN_FLAG,IDENTITY_TYPE,LastActivityDate,Corp_ID,APP_ID,DELETE_FLAG,
							CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
						VALUES(@IDENTITY_ID_ADMIN,@CompanyAbbr+'_'+@SAPCode+'_99',@CompanyAbbr+'_'+@SAPCode+'_99',@DealerName,
							1,'Dealer',getdate(),@DMA_ID,'4028931b0f0fc135010f0fc1356a0001',0,
							'00000000-0000-0000-0000-000000000000',GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE());
							
				INSERT INTO dbo.Lafite_Membership
				values(@IDENTITY_ID,'uP+EbopPTG0B39oyAiK4xObGIpI=','1','0CUL9PVxpraROvtfgwOTnQ==',
				null,'','',null,null,'4028931b0f0fc135010f0fc1356a0001',1,0,GETDATE(),GETDATE(),'j3Mj1nPQ5V3HA5wvn6CvSvMq0qY=',GETDATE(),GETDATE(),0,GETDATE(),'0',GETDATE(),null)
				
				INSERT INTO dbo.Lafite_Membership
				values(@IDENTITY_ID_ADMIN,'uP+EbopPTG0B39oyAiK4xObGIpI=','1','0CUL9PVxpraROvtfgwOTnQ==',
				null,'','',null,null,'4028931b0f0fc135010f0fc1356a0001',1,0,GETDATE(),GETDATE(),'j3Mj1nPQ5V3HA5wvn6CvSvMq0qY=',GETDATE(),GETDATE(),0,GETDATE(),'0',GETDATE(),null)
				
				--分配权限（不分一二级）
				insert into [dbo].[Lafite_IDENTITY_MAP]([Id],[IDENTITY_ID],[MAP_TYPE],[MAP_ID],[APP_ID],[DELETE_FLAG],[CREATE_USER],[CREATE_DATE],[LAST_UPDATE_USER],[LAST_UPDATE_DATE]) 
				values (NEWID(),@IDENTITY_ID,'Role','5fb483d8-e1c0-47d7-b6fa-a2bc00b73fc5','4028931b0f0fc135010f0fc1356a0001','0','Administrator',GETDATE(),'Administrator',GETDATE());
				
				insert into [dbo].[Lafite_IDENTITY_MAP]([Id],[IDENTITY_ID],[MAP_TYPE],[MAP_ID],[APP_ID],[DELETE_FLAG],[CREATE_USER],[CREATE_DATE],[LAST_UPDATE_USER],[LAST_UPDATE_DATE]) 
				values (NEWID(),@IDENTITY_ID_ADMIN,'Role','5fb483d8-e1c0-47d7-b6fa-a2bc00b73fc5','4028931b0f0fc135010f0fc1356a0001','0','Administrator',GETDATE(),'Administrator',GETDATE());
				

			END
			ELSE IF (@drParameters='OLD')
			 BEGIN
					IF(@DMA_ID_Midd IS NULL)
					BEGIN
						SELECT @DMA_ID= DMA_ID FROM DealerMaster dm (nolock) WHERE dm.DMA_ChineseName=@DealerName and dm.DMA_DealerType=@DealerLevel and dm.DMA_ActiveFlag='1' and (isnull(@Parent_DMA_ID,'00000000-0000-0000-0000-000000000000')='00000000-0000-0000-0000-000000000000' or dm.DMA_Parent_DMA_ID=@Parent_DMA_ID)
					END
					ELSE
					BEGIN
						SET @DMA_ID=@DMA_ID_Midd;
					END
					--修改经销商中英文名称
					IF (@SameDealerNameType='SameContract')
					BEGIN
						UPDATE  DealerMaster SET DMA_ChineseName=@DealerName,DMA_EnglishName=@DealerEnName,DMA_DealerType=@DealerLevel WHERE DMA_ID=@DMA_ID
					END
			 END
			--1.2 维护数据到正式表
			--CAP_Pricing_Discount,CAP_Pricing_Discount_Remark,CAP_Pricing_Rebate,CAP_Pricing_Rebate_Remark,CAP_Quotas,CAP_COC_Traning_Date
			--维护合同主信息
			INSERT INTO ContractAppointment 
						(CAP_SubDepID,	CAP_ID,CAP_CM_ID,CAP_DMA_ID,CAP_Division,CAP_MarketType,CAP_Recommender,
							CAP_Job_Title,CAP_Company_Name,CAP_Contact_Person,CAP_Email_Address,CAP_Office_Number,
							CAP_Mobile_Phone,CAP_Office_Address,CAP_Company_Type,CAP_Established_Time,CAP_Registered_Capital,
							CAP_Website,CAP_Business_License,CAP_Medical_License,CAP_Tax_Registration,CAP_Healthcare_Experience,
							CAP_Interventional_Experience,CAP_KOL_Relationships,CAP_Business_Partnerships,CAP_Competency_Justifications,CAP_Contract_Type,
							CAP_BSC_Entity,CAP_Exclusiveness,CAP_EffectiveDate,CAP_ExpirationDate,CAP_ProductLine,CAP_Pricing,
							CAP_Payment_Term,CAP_Special_Sales,CAP_Credit_Limit,CAP_Security_Deposit,CAP_Account,CAP_Guarantee,CAP_Guarantee_Remark,
							CAP_Interview_Date,CAP_Venue,CAP_Interview,CAP_Interview_Findings,CAP_COC_Traning_Date,CAP_Non_Compete,
							CAP_Non_Compete_Reason,CAP_Sub_Dealers,CAP_FCPA_Concerns_Property1,CAP_FCPA_Concerns_Property2,CAP_FCPA_Concerns_Property3,
							CAP_FCPA_Concerns_Other,CAP_Dealer_Conflict,CAP_Dealer_Conflict_Reason,CAP_Exclusive_Conflict,CAP_Exclusive_Conflict_Reason,
							--CAP_RSM_PrintName,CAP_RSM_Date,CAP_NCM_PrintName,CAP_NCM_Date,CAP_NSM_PrintName,
							--CAP_NSM_Date,CAP_NCMForPart2_PrintName,CAP_NCMForPart2_Date,
							CAP_Type,CAP_Create_Date,CAP_Create_User,
							CAP_Pricing_Discount,CAP_Pricing_Discount_Remark,CAP_Pricing_Rebate,CAP_Pricing_Rebate_Remark,
							CAP_Attachment,CAP_Reason,CAP_FormeRname,CAP_PayTerm,CAP_IsDeposit,CAP_BeginDateOld)
						SELECT SubDepID, @ContractID,@CM_ID,@DMA_ID,Division,MarketType,Recommender,
						Job_Title,Dealer_Name,Contact_Person,Email_Address,Office_Number,
						Mobile_Phone,Office_Address,Company_Type,Established_Time,Registered_Capital,
						Website,Business_License,Medical_License,Tax_Registration,Healthcare_Experience,
						Interventional_Experience,KOL_Relationships,Business_Partnerships,Competency_Justifications,ARContract_Type,
						BSC_Entity,Exclusiveness,Agreement_EffectiveDate,Agreement_ExpirationDate,ProductLine,Price,
						Payment_Term,Special_Sales,Credit_Limit,Security_Deposit,Open_Account,Guarantee_Way,Guarantee_Way_Remark,
						Interview_Date,Venue,Interview,Interview_Findings,COCTraining_Date,Non_Compete,
						Non_Compete_Reason,Sub_Dealers,FCPA_Concerns_Property1,FCPA_Concerns_Property2,FCPA_Concerns_Property3,
						FCPA_Concerns_Other,HasConflict_Interest,HasConflict_Interest_Remarks,HasConflict_Dealer,Conflict_Dealer_Remarks,
						--RSM_PrintName,RSM_Date,NCM_PrintName,NCM_Date,NSM_PrintName,
						--NSM_Date,NCMForPart2_PrintName,NCMForPart2_Date,
						DealerType,Create_Date,Create_User,
						Price,Price_Remarks,Special_Sales,Special_Sales_Remarks,
						Attachment,Reason,FormeRname,PayTerm,IsDeposit,Agreement_EffectiveDate
						FROM interface.T_I_EW_Contract (nolock)
				WHERE InstanceID=@InstanceID AND UserID=@UserID;
				
		END
	IF (@ContractType='Amendment')
		BEGIN
			
			INSERT INTO ContractAmendment
			(CAM_SubDepID,CAM_ID,CAM_CM_ID,CAM_DMA_ID,CAM_Division,CAM_Dealer_Name,
			CAM_MarketType,
			CAM_Amendment_Reason ,
			CAM_Agreement_EffectiveDate,CAM_Agreement_ExpirationDate,CAM_Amendment_EffectiveDate,CAM_Standard_Amendment,
			CAM_ProductLine_IsChange,CAM_ProductLine_Old,CAM_ProductLine_New,
			CAM_ProductLine_Remarks,
			CAM_Price_IsChange,
			CAM_Price_Old,CAM_Price_New,CAM_Price_Remarks,
			CAM_Territory_IsChange,CAM_Quota_IsChange,
			CAM_Territory_Remarks,CAM_Quota_Remakrs,
			CAM_Payment_IsChange,
			CAM_Payment_Old,CAM_Payment_New,CAM_Payment_Remarks,
			CAM_Credit_Limit_IsChange,CAM_Credit_Limit_Old,CAM_Credit_Limit_New,CAM_Account_Old,CAM_Account_New,
			CAM_Guarantee_Way_Old,CAM_Guarantee_Way_New,CAM_Guarantee_Way_Remark,
			CAM_Special_IsChange,CAM_Special_Old,
			CAM_Special_Amendment,CAM_Special_Amendment_Remraks,
			CAM_Security_Deposit_Old,CAM_Security_Deposit_New,
			CAM_Attachment_Old,CAM_Attachment_New,
			CAM_HasConflict,CAM_Conflict_Remarks,CAM_Business_Handover,
			--CAM_RSM_PrintName,CAM_RSM_Date,CAM_NCM_PrintName,CAM_NCM_Date,CAM_NSM_PrintName,CAM_NSM_Date,
			--CAM_DRM_PrintName,CAM_DRM_Date,CAM_FC_PrintName,CAM_FC_Date,CAM_CD_PrintName,CAM_CD_Date,
			CAM_Create_Date,CAM_Create_User,CAM_PayTerm,CAM_IsDeposit,CAM_BeginDateOld)
			SELECT SubDepID,@ContractID, isnull(@CM_ID,'00000000-0000-0000-0000-000000000000'),@DMA_ID,Division,Dealer_Name,
			MarketType,
			Amendment_Purpose,
			Agreement_EffectiveDate,Agreement_ExpirationDate,Amendment_EffectiveDate,Standard_Amendment,
			ProductLine_IsChange,ProductLine,ProductLine_Renewal,
			ProductLine_Remarks,
			Price_IsChange,
			Price,Price_Renewal,Price_Remarks,
			Territory_IsChange,Quota_IsChange,
			Territory_Remarks,Quotas_Remarks,
			Payment_IsChange,
			Payment_Term,Payment_Term_Renewal,Payment_Term_Remarks,
			Credit_Limit_IsChange,Credit_Limit,CreditLimit_Renewal,Open_Account,Open_Account_Renewal,
			Guarantee_Way,Guarantee_Way_Renewal,GuaranteeW_Renl_Remark,
			Special_IsChange,Special_Sales,
			Special_Sales_Renewal,Special_Sales_Remarks,
			Security_Deposit,Security_Deposit_Renewal,
			Attachment,Attachment_Renewal,
			HasConflict_Dealer,Conflict_Dealer_Remarks,Business_Handover,
			--RSM_PrintName,RSM_Date,NCM_PrintName,NCM_Date,NSM_PrintName,NSM_Date,
			--CAM_DRM_PrintName,CAM_DRM_Date,CAM_FinanceDirector_PrintName,CAM_FinanceDirector_Date,CAM_CountryDirector_PrintName,CAM_CountryDirector_Date,
			Create_Date,Create_User,PayTerm,IsDeposit,Amendment_EffectiveDate
			FROM interface.T_I_EW_Contract (nolock)
			WHERE InstanceID=@InstanceID AND UserID=@UserID;
		END
	IF (@ContractType='Renewal')
		BEGIN
			UPDATE ContractMaster SET CM_Status='Draft' WHERE CM_DMA_ID=@DMA_ID AND CM_ID=@CM_ID;
			INSERT INTO ContractRenewal
			(CRE_SubDepID,CRE_ID,CRE_CM_ID,CRE_DMA_ID,CRE_Division,CRE_MarketType,CRE_Dealer_Name,
			CRE_ContractType_Current,CRE_ContractType_Renewal,CRE_ContractType_Remarks,CRE_BSCEntity_Current,CRE_BSCEntity_Renewal,
			CRE_BSCEntity_Remarks,CRE_Exclusiveness_Current,CRE_Exclusiveness_Renewal,CRE_Exclusiveness_Remarks,CRE_Agrmt_EffectiveDate_Current,
			CRE_Agrmt_EffectiveDate_Renewal,CRE_Agrmt_ExpirationDate_Current,CRE_Agrmt_ExpirationDate_Renewal,CRE_AgreementTerm_Remarks,
			CRE_ProductLine_Old,CRE_ProductLine_New,CRE_ProductLine_Remarks,
			CRE_Prices_Current,CRE_Prices_Renewal,CRE_Prices_Remarks,CRE_Territory_Remarks,CRE_Quota_Remakrs,
			CRE_SpecialSales_Current,CRE_SpecialSales_Renewal,CRE_SpecialSales_Remarks,CRE_Payment_Current,CRE_Payment_Renewal,
			CRE_Payment_Remarks,CRE_CreditLimits_Current,CRE_CreditLimits_Renewal,CRE_CreditLimits_Remarks,CRE_SecurityDeposit_Current,
			CRE_SecurityDeposit_Renewal,CRE_SecurityDeposit_Remarks,CRE_HasConflict,CRE_Conflict_Remarks,CRE_Business_Handover,
			CRE_Account_Current,CRE_Account_Renewal,CRE_Guarantee_Way_Current,CRE_Guarantee_Way_Renewal,CRE_Guarantee_Way_Remark,
			CRE_Attachment_Renewal,
			--CRE_RSM_PrintName,CRE_RSM_Date,CRE_NCM_PrintName,CRE_NCM_Date,
			--CRE_NSM_PrintName,CRE_NSM_Date,CRE_NCMForPart2_PrintName,CRE_NCMForPart2_Date,
			CRE_Create_Date,CRE_Create_User,CRE_PayTerm,CRE_IsDeposit,CRE_BeginDateOld)
			SELECT SubDepID,@ContractID,isnull(@CM_ID,'00000000-0000-0000-0000-000000000000'),@DMA_ID,Division,MarketType,Dealer_Name,
			ARContract_Type,ContractType_Renewal,ContractType_Remarks,BSC_Entity,BSC_Entity_Renewal,
			BSC_Entity_Remarks,Exclusiveness,Exclusiveness_Renewal,Exclusiveness_Remarks,Agreement_EffectiveDate,
			Agreement_EffectiveDate_Renewal,Agreement_ExpirationDate,Agreement_ExpirationDate_Renewal,AgreementTerm_Remarks,
			ProductLine,ProductLine_Renewal,ProductLine_Remarks,
			Price,Price_Renewal,Price_Remarks,Territory_Remarks,Quotas_Remarks,
			Special_Sales,Special_Sales_Renewal,Special_Sales_Remarks,Payment_Term,Payment_Term_Renewal,
			Payment_Term_Remarks,Credit_Limit,CreditLimit_Renewal,CreditLimit_Remarks,Security_Deposit,
			Security_Deposit_Renewal,Security_Deposit_Remarks,HasConflict_Dealer,Conflict_Dealer_Remarks,Business_Handover,
			Open_Account,Open_Account_Renewal,Guarantee_Way,Guarantee_Way_Renewal,GuaranteeW_Renl_Remark,
			Attachment_Renewal,
			--RSM_PrintName,RSM_Date,NCM_PrintName,NCM_Date,
			--NSM_PrintName,NSM_Date,NCMForPart2_PrintName,NCMForPart2_Date,
			Create_Date,Create_User,PayTerm,IsDeposit,Agreement_EffectiveDate_Renewal
			FROM interface.T_I_EW_Contract (nolock)
			WHERE InstanceID=@InstanceID AND UserID=@UserID;
		END
	IF (@ContractType='Termination')
		BEGIN
			INSERT INTO ContractTermination
			(CTE_SubDepID,CTE_ID,CTE_CM_ID,CTE_DMA_ID,CTE_Division,CTE_Dealer_Name,CTE_MarketType,
			CTE_Agreement_ExpirationDate,CTE_Termination_EffectiveDate,CTE_TerminationStatus,
			
			CTE_TerminationsReasons,CTE_TerminationsReasonsRemark,CTE_PendTender,CTE_PendTenderRemark,CTE_Rebate,
			CTE_RebateAmount,CTE_Promotion,CTE_PromotionAmount,CTE_Complaint,CTE_ComplaintAmount,
			CTE_TermRetn,CTE_TermRetnAmount,CTE_TermRetnRemark,CTE_ScarletLetter,CTE_ScarletLetterRemark,
			CTE_DisputeMoney,CTE_DisputeMoneyAmount,CTE_DisputeMoneyRemark,CTE_CurrentAR,CTE_CurrentARRemark,
			CTE_CashDeposit,CTE_CashDepositAmount,CTE_BGuarantee,CTE_BGuaranteeAmount,CTE_CGuarantee,
			CTE_CGuaranteeAmount,CTE_Inventory,CTE_InventoryAmount,CTE_EstimatedAR,CTE_EstimatedARWirte,
			CTE_PaymentPlan,CTE_TakeOver,CTE_TakeOverType,
			CTE_Timeline_HasNotified,CTE_Timeline_WhenNotify,
			CTE_Timeline_WhenSettlement,CTE_Timeline_WhenHandover,CTE_HasCommunications,CTE_HasSettlementProposals,CTE_HasBusinessHandover,
			CTE_BusinessHandover_Specify,
			--CTE_RSM_PrintName,CTE_RSM_Date,CTE_NCM_PrintName,
			--CTE_NCM_Date,CTE_NSM_PrintName,CTE_NSM_Date,CTE_NCMForPart2_PrintName,CTE_NCMForPart2_Date,
			CTE_Create_Date,CTE_Create_User,CTE_TakeOverNew,CTE_BeginDateOld)
			SELECT SubDepID,@ContractID,@CM_ID,@DMA_ID,Division,Dealer_Name,MarketType,
			Agreement_ExpirationDate,Termination_EffectiveDate,TerminationStatus,
			TerminationsReasons,TerminationsReasonsRemark,PendTender,PendTenderRemark,TheRebate,
			RebateRemark,Promotion,PromotionAmount,Complaint,ComplaintAmount,
			TermRetn,TermRetnAmount,TermRetnRemark,ScarletLetter,ScarletLetterRemark,
			DisputeMoney,DisputeMoneyAmount,DisputeMoneyRemark,CurrentAR,CurrentARRemark,
			CashDeposit,CashDepositAmount,Bguarantee,BGuaranteeAmount,Cguarantee,
			CGuaranteeAmount,	Inventory,InventoryAmount,EstimatedAR,EstimatedARWirte,
			PaymentPlan,TakeOver,TakeOverType
			,Timeline_HasNotified,Timeline_WhenNotify,
			Timeline_WhenSettlement,Timeline_WhenHandover,HasCommunications,HasSettlementProposals,HasBusinessHandover,
			BusinessHandover_Specify,
			--RSM_PrintName,RSM_Date,NCM_PrintName,
			--NCM_Date,NSM_PrintName,NSM_Date,NCMForPart2_PrintName,NCMForPart2_Date,
			Create_Date,Create_User,TakeOverNew,Termination_EffectiveDate
			FROM interface.T_I_EW_Contract (nolock)
			WHERE InstanceID=@InstanceID AND UserID=@UserID;
			
			--维护From7数据
			--update 2014-01-20
			--获取当前经销商指标
			DECLARE @ProductLineID uniqueidentifier
			DECLARE @AOPDealerTole float
			
			INSERT INTO TerminationForm
			(TF_ID,TF_CM_ID,TF_DMA_ID,TF_Head_Parm1,TF_Head_Parm2,
			TF_Head_Parm3,TF_Head_Parm4,TF_Head_Parm5,TF_Company_Name,TF_Country,
			TF_IsExclusive,TF_ExpirationDate,TF_Termination_EffectiveDate,
			TF_Reasons,TF_Reason_OtherReasons,
			--TF_Reason_AccRec,TF_Reason_NotQuota,TF_Reason_PlDis,TF_Reason_Other,TF_Reason_OtherReasons,
			TF_OutstandingAmount,TF_QuotaAmount,TF_ActualSales,
			TF_GoodsAmount,TF_HasRGAAttached,TF_IsOutstandingTenders,TF_PostTermination,
			TF_DuePayment,TF_CreditAmount,TF_IsBankGuarantee,TF_GuaranteeAmount,TF_IsReserve,
			TF_ReserveAmount,TF_Settlement,TF_WriteOff,TF_ReserveType
			)
			SELECT @InstanceID,@CM_ID,@DMA_ID,'1','1',
			'0','0','0',DealerMaster.DMA_EnglishName,@DMACountry,
			CTE_TerminationStatus,CTE_Agreement_ExpirationDate,CTE_Termination_EffectiveDate,
			CTE_TerminationsReasons,CTE_TerminationsReasonsRemark,
			CTE_CurrentAR,endfrom.CurrentQuota,endfrom.ActualSales,
			CTE_TermRetnAmount,endstatus.IsRGAAttach,CTE_PendTender,endfrom.TenderDetails,
			CTE_DisputeMoney,CTE_DisputeMoneyAmount,CTE_BGuarantee ,CTE_BGuaranteeAmount, Reserve,
			ReserveAmt,CTE_EstimatedAR ,CTE_EstimatedARWirte ,ReserveType
			
			FROM ContractTermination (nolock)
			INNER JOIN Interface.T_I_EW_Contract  AS T_I_EW_Contract (nolock) ON ContractTermination.CTE_ID=T_I_EW_Contract.InstanceID
			INNER JOIN Contract.TerminationMain main (nolock) ON main.ContractId=ContractTermination.CTE_ID
			INNER JOIN Contract.TerminationEndForm endfrom (nolock) ON main.ContractId=endfrom.ContractId
			INNER JOIN Contract.TerminationStatus endstatus (nolock) on endstatus.ContractId=main.ContractId
			INNER JOIN DealerMaster (nolock) ON DealerMaster.DMA_ID=T_I_EW_Contract.DMA_ID
			WHERE ContractTermination.CTE_ID=@InstanceID 
			
		END
	
	/*授权、指标设定正式DealerID*/
	--修改授权区域
	UPDATE DealerAuthorizationTableTemp SET DAT_DMA_ID_Actual=@DMA_ID WHERE DAT_DCL_ID=@InstanceID
	--修改经销商指标
	UPDATE AOPDealerTemp SET AOPD_Dealer_DMA_ID_Actual=@DMA_ID WHERE AOPD_Contract_ID=@InstanceID
	--修改医院指标
	UPDATE AOPDealerHospitalTemp SET AOPDH_Dealer_DMA_ID_Actual=@DMA_ID WHERE AOPDH_Contract_ID=@InstanceID
	--修改医院产品分类指标
	UPDATE AOPICDealerHospitalTemp SET AOPICH_DMA_ID_Actual=@DMA_ID WHERE AOPICH_Contract_ID=@InstanceID
	
	--更新标准经销商ID
	UPDATE ContractAppointment SET CAP_DMA_ID=@DMA_ID WHERE CAP_ID=@InstanceID
	
	--修改区域授权经销商ID
	UPDATE DealerAuthorizationAreaTemp SET DA_DMA_ID_Actual=@DMA_ID WHERE DA_DCL_ID=@InstanceID;
	
	
END