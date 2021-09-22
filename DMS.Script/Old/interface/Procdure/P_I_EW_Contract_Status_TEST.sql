DROP PROCEDURE [interface].[P_I_EW_Contract_Status_TEST]
GO


/*
合同状态修改
*/
CREATE PROCEDURE [interface].[P_I_EW_Contract_Status_TEST]
@Contract_ID nvarchar(36), @Contract_Type nvarchar(50), @Contract_Status nvarchar(20), @RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
WITH EXEC AS CALLER
AS
DECLARE @Division NVARCHAR(100)
DECLARE @DivCode NVARCHAR(100)
DECLARE @SubDepID NVARCHAR(50)
DECLARE @CC_ID uniqueidentifier
DECLARE @CC_NameCN NVARCHAR(500)
	DECLARE @ProductLine uniqueidentifier
	DECLARE @DMA_ID uniqueidentifier
	DECLARE @CON_BEGIN DATETIME
	DECLARE @CON_END DATETIME
	DECLARE @CON_NUMB NVARCHAR(20)
	-----市场分类参数
	--DECLARE @Mark  NVARCHAR(20) --是否新兴市场
	DECLARE @MarktType  NVARCHAR(10) --是否新兴市场
	DECLARE @HasDCL_ID  uniqueidentifier-- 判断是否已有老合同
	DECLARE @MarkDAT_ID uniqueidentifier
	CREATE TABLE #TBProductLine
	(
		Id uniqueidentifier
	)
	---修改正式数据库合同主表
	DECLARE @ConStartDate NVARCHAR(10)
	DECLARE @ConStopDate NVARCHAR(10)
	DECLARE @ConDclID uniqueidentifier
	DECLARE @ConDatID uniqueidentifier
  DECLARE @ConPMA_ID uniqueidentifier
	--维护DealerContractMast
	DECLARE @FinalBegin datetime
	DECLARE @FinalEnd datetime
	DECLARE @Exclusiveness NVARCHAR(100)
	DECLARE @ProductLin NVARCHAR(100)
	DECLARE @ProductLinRemarks NVARCHAR(100)
	DECLARE @Prices NVARCHAR(100)
	DECLARE @PricesRemarks NVARCHAR(2000)
	DECLARE @SpecialSales NVARCHAR(100)
	DECLARE @SpecialSalesRemarks NVARCHAR(2000)
	DECLARE @CreditLimits NVARCHAR(100)
	DECLARE @Payment NVARCHAR(100)
	DECLARE @SecurityDeposit NVARCHAR(100)
	DECLARE @Account NVARCHAR(100)
	DECLARE @GuaranteeWay NVARCHAR(200)
	DECLARE @GuaranteeWayRemark NVARCHAR(1000)
	DECLARE @Attachment NVARCHAR(100)
	--Amendment参数
	DECLARE @AmendmentSQLUpdate NVARCHAR(2000)
	DECLARE @AmdProductIsChange bit
	DECLARE @AmdPriceIsChange bit
	DECLARE @AmdSpecialIsChange bit
	DECLARE @AmdHospitalIsChange bit
	DECLARE @AmdQuotaIsChange bit
	DECLARE @AmdPaymentIsChange bit
	DECLARE @AmdCreditLimitIsChange bit
	--SUB BU
	DECLARE @SUBBU_ProductLineId uniqueidentifier
	DECLARE @SUBBU_PMA_ID uniqueidentifier
	DECLARE @SUBBU_DMA_ID uniqueidentifier
	DECLARE @SUBBU_DAT_ID_Temp uniqueidentifier
	DECLARE @SUBBU_DAT_ID uniqueidentifier
	--ApplicantUser
	DECLARE @ApplicantUser NVARCHAR(100)
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SELECT top 1 @ApplicantUser=Name FROM [interface].[Biz_Dealer_Approval] WHERE ApplicationID=@Contract_ID ORDER BY DoneTime ;
	SELECT  @MarktType= CONVERT(NVARCHAR(10),ISNULL(MarketType,0)),@SubDepID= SubDepID,@Division=Division FROM Interface.T_I_EW_Contract A WHERE A.InstanceID=@Contract_ID;
	SELECT @CC_ID= CC_ID,@CC_NameCN=CC_NameCN FROM interface.ClassificationContract a WHERE A.CC_Code=@SubDepID;
	INSERT INTO #TBProductLine (Id)
		SELECT DV.ProductLineID FROM V_DivisionProductLineRelation  DV
		WHERE DV.DivisionName=@Division AND DV.IsEmerging='0';
	SELECT @DivCode=A.DivisionCode FROM V_DivisionProductLineRelation A WHERE  A.DivisionName=@Division AND A.IsEmerging='0';
	--维护历史记录
	IF(@Contract_Status='Completed' )
	BEGIN
		IF (@Contract_Type='Appointment')
		BEGIN
			SELECT @DMA_ID=CAP_DMA_ID,@Division=CAP_Division FROM  ContractAppointment WHERE CAP_ID= @Contract_ID
			
			--向历史表中添加最初数据
			DELETE HospitalListHistory WHERE HLH_CurrentContractID=@Contract_ID
			DELETE AOPDealerHistory WHERE ADH_CurrentContractID=@Contract_ID
			DELETE AOPDealerHospitaHistory WHERE ADHH_CurrentContractID=@Contract_ID
			DELETE AOPICDealerHospitalHistory WHERE ADHPH_CurrentContractID=@Contract_ID
			
			INSERT INTO HospitalListHistory
			(HLH_ID,HLH_CurrentContractID,HLH_HOS_ID)
			SELECT NEWID(),@Contract_ID,tab.HOS_ID  from  (SELECT distinct tr.HOS_ID 
			FROM ContractTerritory tr 
			INNER JOIN DealerAuthorizationTableTemp tp ON tp.DAT_ID=tr.Contract_ID
			WHERE tp.DAT_DCL_ID=@Contract_ID) tab;
			
			INSERT INTO AOPDealerHistory 
			([ADH_ID] ,[ADH_ChangeToContractID] ,[ADH_CurrentContractID],[ADH_DMA_ID],[ADH_Year],
			[ADH_January],[ADH_February],[ADH_March] ,[ADH_April]     ,[ADH_May]    ,
			[ADH_June],[ADH_July]  ,[ADH_August] ,[ADH_September] ,[ADH_October]
			,[ADH_November],[ADH_December])
			SELECT NEWID(),NULL,@Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Year,
			AOPD_Amount_1,AOPD_Amount_2,AOPD_Amount_3,AOPD_Amount_4,AOPD_Amount_5,
			AOPD_Amount_6,AOPD_Amount_7,AOPD_Amount_8,AOPD_Amount_9,AOPD_Amount_10,
			AOPD_Amount_11,AOPD_Amount_12
			FROM [dbo].[V_AOPDealer_Temp]
			WHERE AOPD_Contract_ID=@Contract_ID;
			
			INSERT INTO AOPDealerHospitaHistory 
			([ADHH_ID] ,[ADHH_ChangeToContractID] ,[ADHH_CurrentContractID],[ADHH_DMA_ID],[ADHH_HospitalID],ADHH_PCT_ID,[ADHH_Year],
			[ADHH_January],[ADHH_February],[ADHH_March] ,[ADHH_April]     ,[ADHH_May]    ,
			[ADHH_June],[ADHH_July]  ,[ADHH_August] ,[ADHH_September] ,[ADHH_October]
			,[ADHH_November],[ADHH_December])
			SELECT NEWID(),NULL,@Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_Hospital_ID,AOPDH_PCT_ID, AOPDH_Year,
			AOPDH_Amount_1,AOPDH_Amount_2,AOPDH_Amount_3,AOPDH_Amount_4,AOPDH_Amount_5,
			AOPDH_Amount_6,AOPDH_Amount_7,AOPDH_Amount_8,AOPDH_Amount_9,AOPDH_Amount_10,
			AOPDH_Amount_11,AOPDH_Amount_12
			FROM [dbo].[V_AOPDealerHospital_Temp]
			WHERE AOPDH_Contract_ID=@Contract_ID;
			
			INSERT INTO AOPICDealerHospitalHistory 
			(ADHPH_ID ,[ADHPH_ChangeToContractID] ,[ADHPH_CurrentContractID],[ADHPH_DMA_ID],[ADHPH_HospitalID],ADHPH_PCT_ID,[ADHPH_Year],
			[ADHPH_January],[ADHPH_February],[ADHPH_March] ,[ADHPH_April]     ,[ADHPH_May]    ,
			[ADHPH_June],[ADHPH_July]  ,[ADHPH_August] ,[ADHPH_September] ,[ADHPH_October]
			,[ADHPH_November],[ADHPH_December])
			SELECT NEWID(),NULL,@Contract_ID,AOPICH_DMA_ID,AOPICH_Hospital_ID, AOPICH_PCT_ID,AOPICH_Year,
			AOPICH_Unit_1,AOPICH_Unit_2,AOPICH_Unit_3,AOPICH_Unit_4,AOPICH_Unit_5,
			AOPICH_Unit_6,AOPICH_Unit_7,AOPICH_Unit_8,AOPICH_Unit_9,AOPICH_Unit_10,
			AOPICH_Unit_11,AOPICH_Unit_12
			FROM [dbo].[V_AOPICDealerHospital_Temp]
			WHERE AOPICH_Contract_ID=@Contract_ID;
			
		END
		IF (@Contract_Type='Amendment')
		BEGIN
			SELECT @DMA_ID=CAM_DMA_ID,@Division=CAM_Division
			FROM  ContractAmendment 
			INNER JOIN DealerMaster ON ContractAmendment.CAM_DMA_ID=DealerMaster.DMA_ID
			WHERE CAM_ID= @Contract_ID
		END
		IF (@Contract_Type='Renewal')
		BEGIN
			SELECT @DMA_ID=CRE_DMA_ID,@Division=CRE_Division
			FROM  ContractRenewal WHERE CRE_ID= @Contract_ID
		END
		IF (@Contract_Type='Termination')
		BEGIN
			SELECT @DMA_ID=CTE_DMA_ID,@Division=CTE_Division
			FROM  ContractTermination 
			LEFT JOIN DealerMaster ON ContractTermination.CTE_DMA_ID=DealerMaster.DMA_ID
			WHERE CTE_ID= @Contract_ID
		END
		SELECT @ProductLine= ProductLineID FROM V_DivisionProductLineRelation WHERE DivisionName=@Division AND IsEmerging='0'
		--清空当前合同历史数据
		DELETE HospitalListHistory WHERE HLH_ChangeToContractID=@Contract_ID;
		DELETE AOPDealerHistory WHERE [ADH_ChangeToContractID]=@Contract_ID;
		DELETE AOPDealerHospitaHistory WHERE [ADHH_ChangeToContractID]=@Contract_ID;
		DELETE AOPICDealerHospitalHistory WHERE [ADHPH_ChangeToContractID]=@Contract_ID;
		
	
		--插入历史表
		IF(ISNULL(@MarktType,'0'))='2'
		BEGIN
			INSERT INTO HospitalListHistory(HLH_ID,HLH_ChangeToContractID,HLH_CurrentContractID,HLH_HOS_ID)
			SELECT NEWID(),@Contract_ID,NULL,HLA_HOS_ID FROM (
			SELECT DISTINCT HLA_HOS_ID
			FROM HospitalList hos
			INNER JOIN DealerAuthorizationTable aut on hos.HLA_DAT_ID=aut.DAT_ID
			INNER JOIN (SELECT distinct a.CC_ID,a.CA_ID  FROM V_ProductClassificationStructure a) pcs on pcs.CA_ID=aut.DAT_PMA_ID
			INNER JOIN V_AllHospitalMarketProperty amp ON amp.ProductLineID=aut.DAT_ProductLine_BUM_ID and amp.HOS_ID=hos.HLA_HOS_ID
			WHERE aut.DAT_ProductLine_BUM_ID =@ProductLine
			AND aut.DAT_DMA_ID=@DMA_ID
			AND pcs.CC_ID=@CC_ID)TAB
			
			INSERT INTO AOPDealerHistory 
			([ADH_ID] ,[ADH_ChangeToContractID] ,[ADH_CurrentContractID],[ADH_DMA_ID],[ADH_Year],
			[ADH_January],[ADH_February],[ADH_March] ,[ADH_April]     ,[ADH_May]    ,
			[ADH_June],[ADH_July]  ,[ADH_August] ,[ADH_September] ,[ADH_October]
			,[ADH_November],[ADH_December])
			SELECT NEWID(),@Contract_ID,NULL,AOPD_Dealer_DMA_ID,AOPD_Year,
			AOPD_Amount_1,AOPD_Amount_2,AOPD_Amount_3,AOPD_Amount_4,AOPD_Amount_5,
			AOPD_Amount_6,AOPD_Amount_7,AOPD_Amount_8,AOPD_Amount_9,AOPD_Amount_10,
			AOPD_Amount_11,AOPD_Amount_12
			FROM [dbo].[V_AOPDealer]
			WHERE AOPD_Dealer_DMA_ID=@DMA_ID
			AND AOPD_ProductLine_BUM_ID =@ProductLine
			AND AOPD_CC_ID=@CC_ID
			AND AOPD_Year IN (SELECT AOPD_Year FROM AOPDealerTemp WHERE AOPD_Contract_ID=@Contract_ID);

			INSERT INTO AOPDealerHospitaHistory 
			([ADHH_ID] ,[ADHH_ChangeToContractID] ,[ADHH_CurrentContractID],[ADHH_DMA_ID],[ADHH_HospitalID],[ADHH_Year],
			[ADHH_January],[ADHH_February],[ADHH_March] ,[ADHH_April]     ,[ADHH_May]    ,
			[ADHH_June],[ADHH_July]  ,[ADHH_August] ,[ADHH_September] ,[ADHH_October]
			,[ADHH_November],[ADHH_December])
			SELECT NEWID(),@Contract_ID,NULL,AOPDH_Dealer_DMA_ID,AOPDH_Hospital_ID,AOPDH_Year,
			AOPDH_Amount_1,AOPDH_Amount_2,AOPDH_Amount_3,AOPDH_Amount_4,AOPDH_Amount_5,
			AOPDH_Amount_6,AOPDH_Amount_7,AOPDH_Amount_8,AOPDH_Amount_9,AOPDH_Amount_10,
			AOPDH_Amount_11,AOPDH_Amount_12
			FROM [dbo].[V_AOPDealerHospital] AOP
			INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=AOP.AOPDH_ProductLine_BUM_ID AND AMP.HOS_ID=AOP.AOPDH_Hospital_ID
			WHERE AOPDH_Dealer_DMA_ID=@DMA_ID
			AND AOPDH_ProductLine_BUM_ID =@ProductLine
			AND AOPDH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure A WHERE A.CC_ID =@CC_ID)

			INSERT INTO AOPICDealerHospitalHistory 
			(ADHPH_ID ,[ADHPH_ChangeToContractID] ,[ADHPH_CurrentContractID],[ADHPH_DMA_ID],[ADHPH_HospitalID],ADHPH_PCT_ID,[ADHPH_Year],
			[ADHPH_January],[ADHPH_February],[ADHPH_March] ,[ADHPH_April]     ,[ADHPH_May]    ,
			[ADHPH_June],[ADHPH_July]  ,[ADHPH_August] ,[ADHPH_September] ,[ADHPH_October]
			,[ADHPH_November],[ADHPH_December])
			SELECT NEWID(),@Contract_ID,NULL,AOPICH_DMA_ID,AOPICH_Hospital_ID,AOPICH_PCT_ID,AOPICH_Year,
			AOPICH_Unit_1,AOPICH_Unit_2,AOPICH_Unit_3,AOPICH_Unit_4,AOPICH_Unit_5,
			AOPICH_Unit_6,AOPICH_Unit_7,AOPICH_Unit_8,AOPICH_Unit_9,AOPICH_Unit_10,
			AOPICH_Unit_11,AOPICH_Unit_12
			FROM [dbo].[V_AOPICDealerHospital] AOP
			INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=AOP.AOPICH_ProductLine_ID AND AMP.HOS_ID=AOP.AOPICH_Hospital_ID
			WHERE AOPICH_DMA_ID=@DMA_ID
			AND AOPICH_ProductLine_ID =@ProductLine
			AND AOPICH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure A WHERE A.CC_ID =@CC_ID)
		END
		ELSE
		BEGIN
			INSERT INTO HospitalListHistory(HLH_ID,HLH_ChangeToContractID,HLH_CurrentContractID,HLH_HOS_ID)
			SELECT NEWID(),@Contract_ID,NULL,HLA_HOS_ID
			FROM HospitalList hos
			INNER JOIN DealerAuthorizationTable aut on hos.HLA_DAT_ID=aut.DAT_ID
			INNER JOIN (SELECT distinct a.CC_ID,a.CA_ID  FROM V_ProductClassificationStructure a) pcs on pcs.CA_ID=aut.DAT_PMA_ID
			INNER JOIN V_AllHospitalMarketProperty amp ON amp.ProductLineID=aut.DAT_ProductLine_BUM_ID and amp.HOS_ID=hos.HLA_HOS_ID
			WHERE aut.DAT_ProductLine_BUM_ID =@ProductLine
			AND aut.DAT_DMA_ID=@DMA_ID
			AND pcs.CC_ID=@CC_ID
			AND ISNULL(amp.MarketProperty,0) =CONVERT(INT , @MarktType);
			
			
			INSERT INTO AOPDealerHistory 
			([ADH_ID] ,[ADH_ChangeToContractID] ,[ADH_CurrentContractID],[ADH_DMA_ID],[ADH_Year],
			[ADH_January],[ADH_February],[ADH_March] ,[ADH_April]     ,[ADH_May]    ,
			[ADH_June],[ADH_July]  ,[ADH_August] ,[ADH_September] ,[ADH_October]
			,[ADH_November],[ADH_December])
			SELECT NEWID(),@Contract_ID,NULL,AOPD_Dealer_DMA_ID,AOPD_Year,
			AOPD_Amount_1,AOPD_Amount_2,AOPD_Amount_3,AOPD_Amount_4,AOPD_Amount_5,
			AOPD_Amount_6,AOPD_Amount_7,AOPD_Amount_8,AOPD_Amount_9,AOPD_Amount_10,
			AOPD_Amount_11,AOPD_Amount_12
			FROM [dbo].[V_AOPDealer]
			WHERE AOPD_Dealer_DMA_ID=@DMA_ID
			AND AOPD_ProductLine_BUM_ID =@ProductLine
			AND AOPD_CC_ID=@CC_ID
			AND ISNULL(AOPD_Market_Type,'0')=@MarktType;

			INSERT INTO AOPDealerHospitaHistory 
			([ADHH_ID] ,[ADHH_ChangeToContractID] ,[ADHH_CurrentContractID],[ADHH_DMA_ID],[ADHH_HospitalID],[ADHH_Year],
			[ADHH_January],[ADHH_February],[ADHH_March] ,[ADHH_April]     ,[ADHH_May]    ,
			[ADHH_June],[ADHH_July]  ,[ADHH_August] ,[ADHH_September] ,[ADHH_October]
			,[ADHH_November],[ADHH_December])
			SELECT NEWID(),@Contract_ID,NULL,AOPDH_Dealer_DMA_ID,AOPDH_Hospital_ID,AOPDH_Year,
			AOPDH_Amount_1,AOPDH_Amount_2,AOPDH_Amount_3,AOPDH_Amount_4,AOPDH_Amount_5,
			AOPDH_Amount_6,AOPDH_Amount_7,AOPDH_Amount_8,AOPDH_Amount_9,AOPDH_Amount_10,
			AOPDH_Amount_11,AOPDH_Amount_12
			FROM [dbo].[V_AOPDealerHospital] AOP
			INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=AOP.AOPDH_ProductLine_BUM_ID AND AMP.HOS_ID=AOP.AOPDH_Hospital_ID
			WHERE AOPDH_Dealer_DMA_ID=@DMA_ID
			AND AOPDH_ProductLine_BUM_ID =@ProductLine
			AND AOPDH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure A WHERE A.CC_ID =@CC_ID)
			AND ISNULL(AMP.MarketProperty,0)=CONVERT(INT ,@MarktType)

			INSERT INTO AOPICDealerHospitalHistory 
			(ADHPH_ID ,[ADHPH_ChangeToContractID] ,[ADHPH_CurrentContractID],[ADHPH_DMA_ID],[ADHPH_HospitalID],ADHPH_PCT_ID,[ADHPH_Year],
			[ADHPH_January],[ADHPH_February],[ADHPH_March] ,[ADHPH_April]     ,[ADHPH_May]    ,
			[ADHPH_June],[ADHPH_July]  ,[ADHPH_August] ,[ADHPH_September] ,[ADHPH_October]
			,[ADHPH_November],[ADHPH_December])
			SELECT NEWID(),@Contract_ID,NULL,AOPICH_DMA_ID,AOPICH_Hospital_ID,AOPICH_PCT_ID,AOPICH_Year,
			AOPICH_Unit_1,AOPICH_Unit_2,AOPICH_Unit_3,AOPICH_Unit_4,AOPICH_Unit_5,
			AOPICH_Unit_6,AOPICH_Unit_7,AOPICH_Unit_8,AOPICH_Unit_9,AOPICH_Unit_10,
			AOPICH_Unit_11,AOPICH_Unit_12
			FROM [dbo].[V_AOPICDealerHospital] AOP
			INNER JOIN V_AllHospitalMarketProperty AMP ON AMP.ProductLineID=AOP.AOPICH_ProductLine_ID AND AMP.HOS_ID=AOP.AOPICH_Hospital_ID
			WHERE AOPICH_DMA_ID=@DMA_ID
			AND AOPICH_ProductLine_ID =@ProductLine
			AND AOPICH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure A WHERE A.CC_ID =@CC_ID)
			AND ISNULL(AMP.MarketProperty,0)=CONVERT(INT ,@MarktType)
		END
		UPDATE ContractChangeMapping SET CCM_ChangeToContractID=@Contract_ID
		WHERE CCM_DMA_ID=@DMA_ID
		AND  CCM_ChangeToContractID is null;
		
		INSERT INTO ContractChangeMapping (CCM_ID,CCM_DMA_ID,CCM_CurrentContractID,CCM_ChangeToContractID)
		VALUES(NEWID(),@DMA_ID,@Contract_ID,NULL);
	END
	
	
	IF @Contract_Type='Appointment'
	BEGIN
		UPDATE ContractAppointment 
		SET CAP_Status=@Contract_Status ,
			CAP_Update_Date=GETDATE()
		WHERE CAP_ID=@Contract_ID;
		
		DECLARE @DM_TY NVARCHAR(50)
		--发邮件通知填写IAF
		DECLARE @email NVARCHAR(200)
		DECLARE @dealerTypeEM NVARCHAR(5)
		DECLARE @ISEquipment NVARCHAR(5)
		DECLARE @dealerName NVARCHAR(500)
		DECLARE @dealerAccount NVARCHAR(100)
		DECLARE @mailBody NVARCHAR(4000)
		DECLARE @mailName NVARCHAR(100)
		DECLARE @mailBodyCo NVARCHAR(4000)
		DECLARE @mailNameCo NVARCHAR(100)
		DECLARE @mailBodyLP NVARCHAR(4000)
		DECLARE @mailNameLP NVARCHAR(100)
		DECLARE @ProductName_App NVARCHAR(100)
		
		SELECT @dealerName= CAP_Company_Name,@email=CAP_Email_Address,@ISEquipment=CAP_Type,@Division=CAP_Division  ,@DM_TY=B.DealerLevel
		FROM ContractAppointment A
		INNER JOIN INTERFACE.T_I_EW_Contract  B ON A.CAP_ID=B.InstanceID
		WHERE A.CAP_ID=@Contract_ID
		
		SELECT @dealerAccount=DealerMaster.DMA_SAP_Code,@dealerTypeEM=DealerMaster.DMA_DealerType 
			FROM Lafite_IDENTITY INNER JOIN  DealerMaster 
			ON Lafite_IDENTITY.Corp_ID=DealerMaster.DMA_ID   
			WHERE  DealerMaster.DMA_ChineseName=@dealerName
			and DealerMaster.DMA_DealerType=@DM_TY;
			
		SELECT @ProductName_App= ProductLineName FROM V_DivisionProductLineRelation WHERE DivisionName=@Division AND IsEmerging='0'
		SET @dealerAccount=ISNULL(@dealerAccount,'')+'_01';
		--账号建立后邮件通知Dealer LP CO
		select @mailNameCo=MMT_Subject,@mailBodyCo=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_DEALERACCOUNTTOCO';
		IF (@dealerTypeEM='T1' OR @dealerTypeEM='LP')
		BEGIN
			IF(@Contract_Status='COApproved')
			BEGIN
				select @mailName=MMT_Subject,@mailBody=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_DEALERIAF';
				SET @mailBody=REPLACE(REPLACE(REPLACE(@mailBody,'{#DealerName}',@dealerName),'{#Account}',@dealerAccount),'{#ApplicantUser}',ISNULL(@ApplicantUser,''));
				SET @mailName=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailName
				--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--VALUES(NEWID(),'email','',@email,@mailName,@mailBody,'Waiting',GETDATE(),NULL);
				
				
				--通知CO
				SET @mailBodyCo=REPLACE(REPLACE(@mailBodyCo,'{#DealerName}',@dealerName),'{#ApplicantUser}',@ApplicantUser);
				SET @mailNameCo=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailNameCo
				--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--SELECT NEWID(),'email','',MDA_MailAddress,@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL
				--FROM MailDeliveryAddress WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO'
				----VALUES(NEWID(),'email','','YingSarah.Huang@bsci.com',@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL);
				
			END
			IF(@Contract_Status='Completed')
			BEGIN
				--发邮件通知CO准备Agreemen
				select @mailNameCo=MMT_Subject,@mailBodyCo=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_READYAGREEMEN';
				SET @mailBodyCo=REPLACE(REPLACE(REPLACE(REPLACE(@mailBodyCo,'{#DealerName}',@dealerName),'{#ProductLine}',@ProductName_App),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
				SET @mailNameCo=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailNameCo
				
				--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--SELECT NEWID(),'email','',MDA_MailAddress,@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL
				--FROM MailDeliveryAddress WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO'
				--VALUES(NEWID(),'email','','YingSarah.Huang@bsci.com',@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL);
			END
		END
		ELSE IF (@dealerTypeEM='T2' AND @Contract_Status='Completed' )
		BEGIN
			DECLARE @dealerNameLP NVARCHAR(200)
			DECLARE @dealerIdLP NVARCHAR(36)
			SELECT @dealerNameLP=pdm.DMA_ChineseName,@dealerIdLP=pdm.DMA_ID FROM DealerMaster dm INNER JOIN DealerMaster pdm on  dm.DMA_Parent_DMA_ID=pdm.DMA_ID WHERE dm.DMA_ChineseName=@dealerName
			
			--通知LP
			IF (ISNULL(@dealerIdLP,'')<>'')
			BEGIN
				SELECT @mailNameLP=MMT_Subject,@mailBodyLP=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_DEALERIAFTOLP';
				SET @mailBodyLP=REPLACE(REPLACE(REPLACE(@mailBodyLP,'{#DealerNameLP}',@dealerNameLP),'{#DealerName}',@dealerName),'{#ApplicantUser}',@ApplicantUser);
				SET @mailNameLP=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailNameLP
				
				--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--SELECT NEWID(),'email','',MDA_MailAddress,@mailNameLP,@mailBodyLP,'Waiting',GETDATE(),NULL
				--FROM MailDeliveryAddress 
				--INNER JOIN Client 
				--	ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
				--	AND Client.CLT_Corp_Id=@dealerIdLP
				--WHERE MDA_MailType='DCMS' 
				----抄送CO
				--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--SELECT NEWID(),'email','',MDA_MailAddress,@mailNameLP,@mailBodyLP,'Waiting',GETDATE(),NULL
				--FROM MailDeliveryAddress 
				--WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
				
			END
			--通知CO
			SET @mailBodyCo=REPLACE(REPLACE(@mailBodyCo,'{#DealerName}',@dealerName),'{#ApplicantUser}',@ApplicantUser);;
			SET @mailNameCo=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailNameCo
			--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
			--SELECT NEWID(),'email','',MDA_MailAddress,@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL
			--FROM MailDeliveryAddress WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
			----VALUES(NEWID(),'email','','YingSarah.Huang@bsci.com',@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL);
		END
		
		--修改正式表
		IF(@Contract_Status='Completed')
		BEGIN
			SELECT @DMA_ID=CAP_DMA_ID,@CON_BEGIN=CAP_EffectiveDate,@CON_END=CAP_ExpirationDate,@Division=CAP_Division FROM  ContractAppointment WHERE CAP_ID= @Contract_ID
			
			DECLARE @PRODUCT_CUR cursor;
			SET @PRODUCT_CUR=cursor for  
				SELECT DAT_ID,DAT_DMA_ID_Actual,DAT_PMA_ID,DAT_ProductLine_BUM_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@Contract_ID
			OPEN @PRODUCT_CUR
			FETCH NEXT FROM @PRODUCT_CUR INTO @SUBBU_DAT_ID_Temp,@SUBBU_DMA_ID,@SUBBU_PMA_ID,@SUBBU_ProductLineId
			WHILE @@FETCH_STATUS = 0        
				BEGIN
					SET @SUBBU_DAT_ID =NULL;
					SELECT @SUBBU_DAT_ID=DAT_ID FROM DealerAuthorizationTable A WHERE A.DAT_DMA_ID=@SUBBU_DMA_ID AND A.DAT_PMA_ID=@SUBBU_PMA_ID AND A.DAT_ProductLine_BUM_ID=@SUBBU_ProductLineId
					
					IF(@SUBBU_DAT_ID IS NOT NULL )
					BEGIN
						IF(ISNULL(@MarktType,'0'))='2'
						BEGIN
							DELETE HospitalList WHERE HLA_DAT_ID=@SUBBU_DAT_ID;
						END
						ELSE
						BEGIN
							DELETE HospitalList WHERE HLA_DAT_ID=@SUBBU_DAT_ID AND HLA_HOS_ID IN (SELECT AMP.HOS_ID FROM V_AllHospitalMarketProperty AMP INNER JOIN #TBProductLine C ON AMP.ProductLineID =C.Id AND ISNULL(AMP.MarketProperty,0)=CONVERT(INT, @MarktType)  )
						END
					END
					ELSE
					BEGIN
						SET @HasDCL_ID=NULL;
						SELECT @HasDCL_ID=DCL_ID FROM DealerContract A WHERE A.DCL_DMA_ID=@SUBBU_DMA_ID
						IF @HasDCL_ID IS NOT NULL
						BEGIN
							SET @SUBBU_DAT_ID=NEWID();
							INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,	DAT_ID,	DAT_DCL_ID,	DAT_DMA_ID,	DAT_ProductLine_BUM_ID,	DAT_AuthorizationType)
							VALUES(@SUBBU_PMA_ID,@SUBBU_DAT_ID,@HasDCL_ID,@SUBBU_DMA_ID,@SUBBU_ProductLineId,'1')
						END
						ELSE
						BEGIN
							SELECT @CON_NUMB='Contract-'+CONVERT(VARCHAR,(MAX(substring(DCL_ContractNumber,10,LEN(DCL_ContractNumber)))+1),20) FROM DealerContract WHERE DCL_ContractNumber  NOT IN ('Contract-TM','Contract-GKHT')
							SET @HasDCL_ID=NEWID();
							SET @SUBBU_DAT_ID=NEWID();
							
							INSERT INTO DealerContract(DCL_ID,DCL_StartDate,DCL_ApprovedBy,DCL_StopDate,DCL_ContractNumber,DCL_ContractYears,DCL_DMA_ID,DCL_Approval_ID,DCL_CreatedDate,DCL_CreatedBy)
							VALUES(@HasDCL_ID,@CON_BEGIN,NULL,@CON_END,@CON_NUMB,NULL,@DMA_ID,NULL,GETDATE(),'00000000-0000-0000-0000-000000000000');
							
							INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,	DAT_ID,	DAT_DCL_ID,	DAT_DMA_ID,	DAT_ProductLine_BUM_ID,	DAT_AuthorizationType)
							VALUES(@SUBBU_PMA_ID,@SUBBU_DAT_ID,@HasDCL_ID,@SUBBU_DMA_ID,@SUBBU_ProductLineId,'1')
						END
					END
					
					INSERT INTO HospitalList (HLA_DAT_ID,HLA_HOS_ID,HLA_ID,HLA_Remark,HLA_HOS_Depart,	HLA_HOS_DepartType,	HLA_HOS_DepartRemark)
					SELECT @SUBBU_DAT_ID,tr.HOS_ID,tr.ID,Null,TR.HOS_Depart,TR.HOS_DepartType,TR.HOS_DepartRemark FROM ContractTerritory tr 
					WHERE TR.Contract_ID=@SUBBU_DAT_ID_Temp;
					
				 FETCH NEXT FROM @PRODUCT_CUR INTO @SUBBU_DAT_ID_Temp,@SUBBU_DMA_ID,@SUBBU_PMA_ID,@SUBBU_ProductLineId
				END
			CLOSE @PRODUCT_CUR
			DEALLOCATE @PRODUCT_CUR ;
			--删除该合同中终止授权产品分类
			IF(ISNULL(@MarktType,'0'))='2'
			BEGIN
				DELETE HospitalList WHERE 
				 HLA_DAT_ID IN (
				SELECT DAT_ID FROM DealerAuthorizationTable 
				WHERE DAT_DMA_ID=@DMA_ID 
				AND DAT_ProductLine_BUM_ID in (select DAT_ProductLine_BUM_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@Contract_ID)
				AND DAT_PMA_ID NOT in (SELECT DAT_PMA_ID FROM DealerAuthorizationTableTemp A WHERE A.DAT_DCL_ID =@Contract_ID)
				AND DAT_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization where CA_ParentCode=@SubDepID)
				)
			END
			ELSE
			BEGIN
				DELETE HospitalList WHERE 
				HLA_HOS_ID IN (SELECT AMP.HOS_ID FROM V_AllHospitalMarketProperty AMP INNER JOIN #TBProductLine C ON AMP.ProductLineID =C.Id AND ISNULL(AMP.MarketProperty,0)=CONVERT(INT, @MarktType))
				AND HLA_DAT_ID IN (
				SELECT DAT_ID FROM DealerAuthorizationTable 
				WHERE DAT_DMA_ID=@DMA_ID 
				AND DAT_ProductLine_BUM_ID in (select DAT_ProductLine_BUM_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@Contract_ID)
				AND DAT_PMA_ID NOT in (SELECT DAT_PMA_ID FROM DealerAuthorizationTableTemp A WHERE A.DAT_DCL_ID =@Contract_ID)
				AND DAT_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization where CA_ParentCode=@SubDepID)
				)
			END
			
			--将合同数据维护到DealerContractMaster
			DECLARE @Check_DCM_APM INT; 
			SELECT @Check_DCM_APM=COUNT(*) FROM DealerContractMaster A
			INNER JOIN V_DivisionProductLineRelation DV ON DV.DivisionCode=CONVERT(NVARCHAR(10),A.DCM_Division) AND DV.IsEmerging='0'
			WHERE DCM_DMA_ID=@DMA_ID AND DV.DivisionName=@Division AND  CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))=@MarktType AND DCM_CC_ID=@CC_ID;
			
			IF(@Check_DCM_APM>0)
			BEGIN
				UPDATE DealerContractMaster 
				SET [DCM_ContractType]=A.CAP_Contract_Type,[DCM_BSCEntity]=A.CAP_BSC_Entity,
					[DCM_Exclusiveness]=A.CAP_Exclusiveness,[DCM_EffectiveDate]=A.CAP_EffectiveDate,
					[DCM_ExpirationDate]=A.CAP_ExpirationDate,
					[DCM_ProductLine]=(CASE WHEN A.CAP_ProductLine='All' THEN 'All' ELSE 'Partial' END),
					[DCM_ProductLineRemark]=(CASE WHEN A.CAP_ProductLine='All' THEN NULL ELSE CAP_ProductLine END),
					[DCM_Credit_Limit]=A.CAP_Credit_Limit,[DCM_Credit_Term]=A.CAP_Account,
					[DCM_Pricing]=A.CAP_Pricing,[DCM_Pricing_Discount]=A.CAP_Pricing_Discount,
					[DCM_Pricing_Discount_Remark]=A.CAP_Pricing_Discount_Remark, [DCM_Pricing_Rebate]=A.CAP_Pricing_Rebate,
					[DCM_Pricing_Rebate_Remark]=A.CAP_Pricing_Rebate_Remark,[DCM_Payment_Term]=A.CAP_Payment_Term,
					[DCM_Security_Deposit]=A.CAP_Security_Deposit,[DCM_Guarantee]=A.CAP_Guarantee_Remark,
					[DCM_Attachment]=A.CAP_Attachment,[DCM_Update_Date]=GETDATE(),
					[DCM_TerminationDate]=null
				FROM ContractAppointment A  
				INNER JOIN DealerMaster B ON A.CAP_DMA_ID=B.DMA_ID
				INNER JOIN V_DivisionProductLineRelation DV ON DV.DivisionName=A.CAP_Division AND DV.IsEmerging='0'
				WHERE A.CAP_ID=@Contract_ID
				AND DealerContractMaster.DCM_DMA_ID=B.DMA_ID 
				AND CONVERT(NVARCHAR(10),DealerContractMaster.DCM_Division)=DV.DivisionCode
				AND CONVERT(NVARCHAR(10),ISNULL(DealerContractMaster.DCM_MarketType,0))= @MarktType
				AND DCM_CC_ID=@CC_ID;
			END
			ELSE
			BEGIN
				INSERT INTO DealerContractMaster
				(DCM_CC_ID,[DCM_ID],[DCM_DMA_ID],[DCM_Division],[DCM_MarketType],[DCM_ContractType],[DCM_DealerType],[DCM_BSCEntity]
				,[DCM_Exclusiveness],[DCM_EffectiveDate],[DCM_ExpirationDate],[DCM_ProductLine],[DCM_ProductLineRemark]
				,[DCM_Credit_Limit],[DCM_Credit_Term],[DCM_Pricing],[DCM_Pricing_Discount],[DCM_Pricing_Discount_Remark],[DCM_Pricing_Rebate]
				,[DCM_Pricing_Rebate_Remark],[DCM_Payment_Term],[DCM_Security_Deposit],[DCM_Guarantee],[DCM_GuaranteeRemark],[DCM_Attachment],[DCM_Delete_flag],[DCM_Update_Date],[DCM_FirstContractDate],DCM_FristCooperationDate)
				SELECT @CC_ID,NEWID(),CAP_DMA_ID,(SELECT REV1 FROM Lafite_ATTRIBUTE WHERE ATTRIBUTE_TYPE='BU' AND DELETE_FLAG='0' AND ATTRIBUTE_NAME=ContractAppointment.CAP_Division ),
				ISNULL(CAP_MarketType,0),CAP_Contract_Type,DealerMaster.DMA_DealerType,CAP_BSC_Entity,
				CAP_Exclusiveness,CAP_EffectiveDate,CAP_ExpirationDate, (CASE WHEN CAP_ProductLine='All' THEN 'All' ELSE 'Partial' END),(CASE WHEN CAP_ProductLine='All' THEN NULL ELSE CAP_ProductLine END),
				CAP_Credit_Limit,CAP_Account,CAP_Pricing,CAP_Pricing_Discount,CAP_Pricing_Discount_Remark,CAP_Pricing_Rebate,
				CAP_Pricing_Rebate_Remark,CAP_Payment_Term,CAP_Security_Deposit,CAP_Guarantee,CAP_Guarantee_Remark,CAP_Attachment,'0',getdate(),CAP_EffectiveDate,CAP_EffectiveDate
				FROM ContractAppointment
				INNER JOIN DealerMaster ON ContractAppointment.CAP_DMA_ID=DealerMaster.DMA_ID
				WHERE ContractAppointment.CAP_ID=@Contract_ID;
			 END
		END
		
	END
	
	IF @Contract_Type='Amendment'
	BEGIN
		UPDATE ContractAmendment 
		SET	CAM_Status=@Contract_Status
			 ,CAM_Update_Date=GETDATE()
		WHERE CAM_ID=@Contract_ID;
		
		IF(@Contract_Status='Completed')
		BEGIN
			DECLARE @Amd_DelerType NVARCHAR(200);
			DECLARE @Amd_DelerName NVARCHAR(200);
			
			SELECT @DMA_ID=CAM_DMA_ID,@Amd_DelerName=DealerMaster.DMA_ChineseName,@CON_BEGIN=CAM_Amendment_EffectiveDate,@CON_END=CAM_Agreement_ExpirationDate,@Division=CAM_Division ,@Amd_DelerType=DealerMaster.DMA_DealerType
			FROM  ContractAmendment 
			INNER JOIN DealerMaster ON ContractAmendment.CAM_DMA_ID=DealerMaster.DMA_ID
			WHERE CAM_ID= @Contract_ID
			
			--------------------------------
			--发邮件
			DECLARE @Amd_email_Address NVARCHAR(200)
			DECLARE @Amd_email_Pl NVARCHAR(200)
			DECLARE @Amd_email_Name NVARCHAR(300)
			DECLARE @Amd_email_Body NVARCHAR(4000)
			DECLARE @Amd_Dma_Id_LP NVARCHAR(36)
			
			SELECT TOP 1  @Amd_email_Pl=b.ATTRIBUTE_NAME FROM #TBProductLine a,View_ProductLine b WHERE a.Id=b.Id; 
			
			IF (@Amd_DelerType='T1' OR @Amd_DelerType='LP')
			BEGIN	
				SELECT @Amd_email_Address=DMA_Email FROM DealerMaster a where a.DMA_ID=@DMA_ID;
				SELECT @Amd_email_Name=MMT_Subject,@Amd_email_Body=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_AMIND_TODEALER';
				SET @Amd_email_Name=@Division+'-'+@CC_NameCN+'-'+@Amd_DelerName+'-'+'Amendment'+'('+@Amd_DelerType+')-'+@Amd_email_Name
				
				SET @Amd_email_Body=REPLACE(REPLACE(REPLACE(@Amd_email_Body,'{#ProductLine}',@Amd_email_Pl),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
				--IF(@Amd_email_Address IS NOT NULL )
				--BEGIN
				--	--发邮件给DealerMaster提供的邮件地址
				--	select 1 ;
				--	--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--	--VALUES(NEWID(),'email','',@Amd_email_Address,@Amd_email_Name,@Amd_email_Body,'Waiting',GETDATE(),NULL);
				--END
				--IF (@Amd_DelerType='LP')
				--BEGIN
				--	--发邮件给平台各负责人 
				--	INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--	SELECT NEWID(),'email','',MDA_MailAddress,@Amd_email_Name,@Amd_email_Body,'Waiting',GETDATE(),NULL
				--	FROM MailDeliveryAddress 
				--	INNER JOIN Client 
				--		ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
				--		AND Client.CLT_Corp_Id=@DMA_ID
				--	WHERE MDA_MailType='DCMS' 
				--END
			END
			IF (@Amd_DelerType='T2')
			BEGIN
				SELECT @Amd_Dma_Id_LP=b.DMA_ID FROM DealerMaster a 
				INNER JOIN DealerMaster b ON a.DMA_Parent_DMA_ID=b.DMA_ID
				where a.DMA_ID=@DMA_ID;
				
				select @Amd_email_Name=MMT_Subject,@Amd_email_Body=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_AMIND_TOLP';
				SET @Amd_email_Body=REPLACE(REPLACE(REPLACE(REPLACE(@Amd_email_Body,'{#ProductLine}',@Amd_email_Pl),'{#DealerName}',@Amd_DelerName),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
				SET @Amd_email_Name=@Division+'-'+@CC_NameCN+'-'+@Amd_DelerName+'-'+'Amendment'+'('+@Amd_DelerType+')-'+@Amd_email_Name
				
				--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--SELECT NEWID(),'email','',MDA_MailAddress,@Amd_email_Name,@Amd_email_Body,'Waiting',GETDATE(),NULL
				--FROM MailDeliveryAddress 
				--INNER JOIN Client 
				--	ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
				--	AND Client.CLT_Corp_Id=@Amd_Dma_Id_LP
				--WHERE MDA_MailType='DCMS' 
				----抄送CO
				--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--SELECT NEWID(),'email','',MDA_MailAddress,@Amd_email_Name,@Amd_email_Body,'Waiting',GETDATE(),NULL
				--FROM MailDeliveryAddress 
				--WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
				
			END
			--通知CO
			SET @Amd_email_Name='';
			SET @Amd_email_Body='';
			select @Amd_email_Name=MMT_Subject,@Amd_email_Body=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_COMPLETE_TOCO';
			
			SET @Amd_email_Name=REPLACE(@Amd_email_Name,'{#ContractType}','Amendment')
			SET @Amd_email_Body=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Amd_email_Body,'{#ContractType}','Amendment'),'{#DealerName}',@Amd_DelerName),'{#ProductLine}',@Amd_email_Pl),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
			
			--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
			--SELECT NEWID(),'email','',MDA_MailAddress,@Amd_email_Name,@Amd_email_Body,'Waiting',GETDATE(),NULL
			--FROM MailDeliveryAddress 
			--WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
			
			
			--------------------------------
			SET @AmendmentSQLUpdate='';
			SELECT	--@Exclusiveness=CRE_Exclusiveness_Renewal,
					@AmdProductIsChange=CAM_ProductLine_IsChange,
					@ProductLin=CAM_ProductLine_New,@ProductLinRemarks=CAM_ProductLine_Remarks,
					
					@AmdPriceIsChange=CAM_Price_IsChange,
					@Prices=CAM_Price_New,@PricesRemarks=CAM_Price_Remarks,
					
					@AmdSpecialIsChange=CAM_Special_IsChange,
					@SpecialSales=CAM_Special_Amendment,@SpecialSalesRemarks=CAM_Special_Amendment_Remraks,
					
					@AmdHospitalIsChange=CAM_Territory_IsChange,
					@AmdQuotaIsChange=CAM_Quota_IsChange,
					
					@AmdPaymentIsChange=CAM_Payment_IsChange,
					@Payment=CAM_Payment_New,
					@CreditLimits=CAM_Credit_Limit_New,
					@Account=CAM_Account_New,
					@SecurityDeposit=CAM_Security_Deposit_New ,
					@GuaranteeWay=CAM_Guarantee_Way_New,
					@GuaranteeWayRemark=CAM_Guarantee_Way_Remark,
					@Attachment=CAM_Attachment_New
					
					--,@SecurityDeposit=CAM_SecurityDeposit_Renewal 
			FROM ContractAmendment WHERE CAM_ID= @Contract_ID
			--如果有授权，删除已有授权医院
			IF(@AmdHospitalIsChange =1)
			BEGIN
				DECLARE @PRODUCT_CUR1 cursor;
				SET @PRODUCT_CUR1=cursor for  
					SELECT DAT_ID,DAT_DMA_ID_Actual,DAT_PMA_ID,DAT_ProductLine_BUM_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@Contract_ID
				OPEN @PRODUCT_CUR1
				FETCH NEXT FROM @PRODUCT_CUR1 INTO @SUBBU_DAT_ID_Temp,@SUBBU_DMA_ID,@SUBBU_PMA_ID,@SUBBU_ProductLineId
				WHILE @@FETCH_STATUS = 0        
					BEGIN
						SET @SUBBU_DAT_ID =NULL;
						SELECT @SUBBU_DAT_ID=DAT_ID FROM DealerAuthorizationTable A WHERE A.DAT_DMA_ID=@SUBBU_DMA_ID AND A.DAT_PMA_ID=@SUBBU_PMA_ID AND A.DAT_ProductLine_BUM_ID=@SUBBU_ProductLineId
						
						IF(@SUBBU_DAT_ID IS NOT NULL )
						BEGIN
							IF(ISNULL(@MarktType,'0'))='2'
							BEGIN
								DELETE HospitalList WHERE HLA_DAT_ID=@SUBBU_DAT_ID;
							END
							ELSE
							BEGIN
								DELETE HospitalList WHERE HLA_DAT_ID=@SUBBU_DAT_ID AND HLA_HOS_ID IN (SELECT AMP.HOS_ID FROM V_AllHospitalMarketProperty AMP INNER JOIN #TBProductLine C ON AMP.ProductLineID =C.Id AND ISNULL(AMP.MarketProperty,0)=CONVERT(INT, @MarktType)  )
							END
						END
						ELSE
						BEGIN
							SET @HasDCL_ID=NULL;
							SELECT @HasDCL_ID=DCL_ID FROM DealerContract A WHERE A.DCL_DMA_ID=@SUBBU_DMA_ID
							IF @HasDCL_ID IS NOT NULL
							BEGIN
								SET @SUBBU_DAT_ID=NEWID();
								INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,	DAT_ID,	DAT_DCL_ID,	DAT_DMA_ID,	DAT_ProductLine_BUM_ID,	DAT_AuthorizationType)
								VALUES(@SUBBU_PMA_ID,@SUBBU_DAT_ID,@HasDCL_ID,@SUBBU_DMA_ID,@SUBBU_ProductLineId,'1')
							END
							ELSE
							BEGIN
								SELECT @CON_NUMB='Contract-'+CONVERT(VARCHAR,(MAX(substring(DCL_ContractNumber,10,LEN(DCL_ContractNumber)))+1),20) FROM DealerContract WHERE DCL_ContractNumber  NOT IN ('Contract-TM','Contract-GKHT')
								SET @HasDCL_ID=NEWID();
								SET @SUBBU_DAT_ID=NEWID();
								
								INSERT INTO DealerContract(DCL_ID,DCL_StartDate,DCL_ApprovedBy,DCL_StopDate,DCL_ContractNumber,DCL_ContractYears,DCL_DMA_ID,DCL_Approval_ID,DCL_CreatedDate,DCL_CreatedBy)
								VALUES(@HasDCL_ID,@CON_BEGIN,NULL,@CON_END,@CON_NUMB,NULL,@DMA_ID,NULL,GETDATE(),'00000000-0000-0000-0000-000000000000');
								
								INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,	DAT_ID,	DAT_DCL_ID,	DAT_DMA_ID,	DAT_ProductLine_BUM_ID,	DAT_AuthorizationType)
								VALUES(@SUBBU_PMA_ID,@SUBBU_DAT_ID,@HasDCL_ID,@SUBBU_DMA_ID,@SUBBU_ProductLineId,'1')
							END
						END
						
						INSERT INTO HospitalList (HLA_DAT_ID,HLA_HOS_ID,HLA_ID,HLA_Remark,HLA_HOS_Depart,	HLA_HOS_DepartType,	HLA_HOS_DepartRemark)
						SELECT @SUBBU_DAT_ID,tr.HOS_ID,tr.ID,Null,TR.HOS_Depart,TR.HOS_DepartType,TR.HOS_DepartRemark FROM ContractTerritory tr 
						WHERE TR.Contract_ID=@SUBBU_DAT_ID_Temp;
						
					 FETCH NEXT FROM @PRODUCT_CUR1 INTO @SUBBU_DAT_ID_Temp,@SUBBU_DMA_ID,@SUBBU_PMA_ID,@SUBBU_ProductLineId
					END
				CLOSE @PRODUCT_CUR1
				DEALLOCATE @PRODUCT_CUR1 ;
				--删除该合同中终止授权产品分类
				IF(ISNULL(@MarktType,'0'))='2'
				BEGIN
					DELETE HospitalList WHERE 
					 HLA_DAT_ID IN (
					SELECT DAT_ID FROM DealerAuthorizationTable 
					WHERE DAT_DMA_ID=@DMA_ID 
					AND DAT_ProductLine_BUM_ID in (select DAT_ProductLine_BUM_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@Contract_ID)
					AND DAT_PMA_ID NOT in (SELECT DAT_PMA_ID FROM DealerAuthorizationTableTemp A WHERE A.DAT_DCL_ID =@Contract_ID)
					AND DAT_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization where CA_ParentCode=@SubDepID)
					)
				END
				ELSE
				BEGIN
					DELETE HospitalList WHERE 
					HLA_HOS_ID IN (SELECT AMP.HOS_ID FROM V_AllHospitalMarketProperty AMP INNER JOIN #TBProductLine C ON AMP.ProductLineID =C.Id AND ISNULL(AMP.MarketProperty,0)=CONVERT(INT, @MarktType))
					AND HLA_DAT_ID IN (
					SELECT DAT_ID FROM DealerAuthorizationTable 
					WHERE DAT_DMA_ID=@DMA_ID 
					AND DAT_ProductLine_BUM_ID in (select DAT_ProductLine_BUM_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@Contract_ID)
					AND DAT_PMA_ID NOT in (SELECT DAT_PMA_ID FROM DealerAuthorizationTableTemp A WHERE A.DAT_DCL_ID =@Contract_ID)
					AND DAT_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization where CA_ParentCode=@SubDepID)
					)
				END
			END
			
			DECLARE @Check_DCM_AMD INT; 
			SELECT @Check_DCM_AMD=COUNT(*) FROM DealerContractMaster A
			INNER JOIN V_DivisionProductLineRelation DV ON DV.DivisionCode=CONVERT(NVARCHAR(10),A.DCM_Division) AND DV.IsEmerging='0'
			WHERE DCM_DMA_ID=@DMA_ID AND DV.DivisionName=@Division AND  CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))= @MarktType
			AND DCM_CC_ID=@CC_ID;
			
			IF @Check_DCM_AMD >0
			BEGIN
				SET @AmendmentSQLUpdate=' UPDATE DealerContractMaster SET DCM_Update_Date=''' + Convert(NVARCHAR(12),GETDATE(),111)+'''  '
				IF @AmdProductIsChange=1
				BEGIN
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' ,DCM_ProductLine= ''' + @ProductLin+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' ,DCM_ProductLineRemark= ''' + ISNULL( @PricesRemarks,'')+''' '
				END
				IF @AmdPriceIsChange =1
				BEGIN
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Pricing_Discount= ''' + ISNULL( @Prices,'')+''', DCM_Pricing_Discount_Remark=''' + ISNULL( @PricesRemarks,'')+''' '
				END
				IF @AmdSpecialIsChange=1
				BEGIN
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Pricing_Rebate= ''' + ISNULL( @SpecialSales,'')+''', DCM_Pricing_Rebate_Remark=''' + ISNULL( @SpecialSalesRemarks,'')+''' '
				END
				IF @AmdPaymentIsChange=1
				BEGIN
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Payment_Term= ''' + ISNULL( @Payment,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Credit_Limit= ''' + ISNULL( @CreditLimits,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Attachment= ''' + ISNULL( @Attachment,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Guarantee= ''' + ISNULL( @GuaranteeWay,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_GuaranteeRemark= ''' + ISNULL( @GuaranteeWayRemark,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Credit_Term= ''' + ISNULL( @Account,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_Security_Deposit= ''' + ISNULL( @SecurityDeposit,'')+''' '
					SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ', DCM_TerminationDate= null '
					
				END
				SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' WHERE DCM_DMA_ID= ''' + Convert(NVARCHAR(36),@DMA_ID)+''' '
				SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' AND  DCM_Division IN (SELECT REV1 FROM Lafite_ATTRIBUTE WHERE ATTRIBUTE_TYPE= '+'''BU'' ' + ' AND DELETE_FLAG=0 AND ATTRIBUTE_NAME= '''+@Division+''' )'
				SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' AND CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))='+@MarktType ;
				SET @AmendmentSQLUpdate =@AmendmentSQLUpdate+ ' AND DCM_CC_ID=''' +CONVERT(NVARCHAR(100), @CC_ID)+''' '
				
				EXEC(@AmendmentSQLUpdate) ;
			END
			ELSE
			BEGIN
				INSERT INTO DealerContractMaster (DCM_CC_ID,DCM_ID,DCM_DMA_ID,DCM_DealerType,DCM_Division,DCM_MarketType,DCM_ContractType,DCM_BSCEntity,
				DCM_Update_Date,DCM_EffectiveDate,DCM_ExpirationDate,DCM_ProductLine,DCM_ProductLineRemark,
				DCM_Pricing_Discount,DCM_Pricing_Discount_Remark,DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,
				DCM_Payment_Term,DCM_Credit_Limit,DCM_Attachment,DCM_Guarantee,DCM_GuaranteeRemark,DCM_Credit_Term,DCM_Security_Deposit,DCM_FirstContractDate,DCM_FristCooperationDate)
				SELECT @CC_ID,NEWID(),B.DMA_ID,B.DMA_DealerType,(SELECT TOP 1 DV.DivisionCode FROM V_DivisionProductLineRelation DV WHERE DV.DivisionName=A.CAM_Division),@MarktType,'Dealer','China',
				Convert(NVARCHAR(12),GETDATE(),111),Convert(NVARCHAR(12),CAM_Amendment_EffectiveDate,111),CONVERT(varchar(12) , @CON_END, 111 ),@ProductLin,ISNULL( @PricesRemarks,''),
				ISNULL( @Prices,''),ISNULL( @PricesRemarks,''),ISNULL( @SpecialSales,''),ISNULL( @SpecialSalesRemarks,''),
				ISNULL( @Payment,''),ISNULL( @CreditLimits,''),ISNULL( @Attachment,''),ISNULL( @GuaranteeWay,''),ISNULL( @GuaranteeWayRemark,''),ISNULL( @Account,''),ISNULL( @SecurityDeposit,''),Convert(NVARCHAR(12),CAM_Amendment_EffectiveDate,111),Convert(NVARCHAR(12),CAM_Amendment_EffectiveDate,111)
				FROM ContractAmendment A  INNER JOIN DealerMaster B ON A.CAM_DMA_ID=B.DMA_ID
				WHERE A.CAM_ID=@Contract_ID
				
			END
		
			
		END
	END
	
	IF @Contract_Type='Renewal'
	BEGIN
		--更改合同状态
		UPDATE ContractRenewal 
		SET CRE_Status=@Contract_Status 
		,CRE_Update_Date=GETDATE()
		WHERE CRE_ID=@Contract_ID;
		
		--获取参数
		SELECT @DMA_ID=CRE_DMA_ID,@CON_BEGIN=CRE_Agrmt_EffectiveDate_Renewal,@CON_END=CRE_Agrmt_ExpirationDate_Renewal,@Division=CRE_Division 
		FROM  ContractRenewal WHERE CRE_ID= @Contract_ID
		
		--INSERT INTO #TBProductLine (Id) SELECT tbPl.ProductLineId FROM (SELECT t1.AttributeID AS ProductLineId ,t2.ATTRIBUTE_NAME AS DivisionName
		--	FROM Cache_OrganizationUnits t1, Lafite_ATTRIBUTE t2
		--	WHERE t1.AttributeType = 'Product_Line' AND t1.RootID = t2.Id 
		--	AND t1.RootID IN (SELECT AttributeID FROM Cache_OrganizationUnits WHERE AttributeType = 'BU')) AS  tbPl WHERE tbPl.DivisionName=@Division;
		
		--发邮件
		DECLARE @emailName_Ren NVARCHAR(1000)
		DECLARE @emailBody_Ren NVARCHAR(4000)
		DECLARE @emailAddress_Ren NVARCHAR(36)
		DECLARE @ParentDmaId_Ren NVARCHAR(36)
		DECLARE @DelerName_Ren NVARCHAR(200);
		DECLARE @DelerType_Ren NVARCHAR(200);
		DECLARE @ProductLine_Ren NVARCHAR(200);
		SELECT TOP 1  @ProductLine_Ren=b.ATTRIBUTE_NAME FROM #TBProductLine a,View_ProductLine b WHERE a.Id=b.Id; 
		
		SELECT @emailAddress_Ren=a.DMA_Email,@DelerType_Ren=a.DMA_DealerType,@DelerName_Ren=a.DMA_ChineseName,@ParentDmaId_Ren=b.DMA_ID
		FROM  DealerMaster a
		INNER JOIN DealerMaster b on a.DMA_Parent_DMA_ID=b.DMA_ID
		WHERE a.DMA_ID=@DMA_ID;
		 
		IF(@DelerType_Ren='T1' OR @DelerType_Ren='LP')
		BEGIN
			IF (@Contract_Status='COApproved')
			BEGIN
				select @emailName_Ren=MMT_Subject,@emailBody_Ren=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_RENEWAL_TODEALERIAF';
				SET @emailBody_Ren=REPLACE(REPLACE(REPLACE(@emailBody_Ren,'{#ProductLine}',@ProductLine_Ren),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
			END
			IF (@Contract_Status='Completed')
			BEGIN
				--同Amdment
				select @emailName_Ren=MMT_Subject,@emailBody_Ren=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_AMIND_TODEALER';
				SET @emailBody_Ren=REPLACE(REPLACE(REPLACE(@emailBody_Ren,'{#ProductLine}',@ProductLine_Ren),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
			END
			IF(@Contract_Status='COApproved' OR @Contract_Status='Completed')
			BEGIN
				SET @emailName_Ren=@Division+'-'+@CC_NameCN+'-'+@DelerName_Ren+'-'+'Renewal'+'('+@DelerType_Ren+')-'+@emailName_Ren
				--IF(ISNULL(@emailAddress_Ren,'')<>'')
				--BEGIN
				--	INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--	VALUES(NEWID(),'email','',@emailAddress_Ren,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL);
					
				--		--抄送CO
				--	INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--	SELECT NEWID(),'email','',MDA_MailAddress,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL
				--	FROM MailDeliveryAddress 
				--	WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
				
				--END
				--IF(@DelerType_Ren='LP')
				--BEGIN
				--	--发邮件给平台各负责人 
				--	INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--	SELECT NEWID(),'email','',MDA_MailAddress,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL
				--	FROM MailDeliveryAddress 
				--	INNER JOIN Client 
				--		ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
				--		AND Client.CLT_Corp_Id=@DMA_ID
				--	WHERE MDA_MailType='DCMS'
					
				--END
			END
		END
		--IF(@DelerType_Ren='T2')
		--BEGIN
		--	IF (@Contract_Status='Completed')
		--	BEGIN
		--		select @emailName_Ren=MMT_Subject,@emailBody_Ren=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_RENEWAL_TOLPIAF';
		--		SET @emailBody_Ren=REPLACE(REPLACE(REPLACE(REPLACE(@emailBody_Ren,'{#ProductLine}',@ProductLine_Ren),'{#DealerName}',@DelerName_Ren),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
		--		SET @emailName_Ren=@Division+'-'+@CC_NameCN+'-'+@DelerName_Ren+'-'+'Renewal'+'('+@DelerType_Ren+')-'+@emailName_Ren
				
		--		--发邮件给平台各负责人 
		--		INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
		--		SELECT NEWID(),'email','',MDA_MailAddress,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL
		--		FROM MailDeliveryAddress 
		--		INNER JOIN Client 
		--			ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
		--			AND Client.CLT_Corp_Id=@ParentDmaId_Ren
		--		WHERE MDA_MailType='DCMS'
				
		--		--抄送CO
		--		INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
		--		SELECT NEWID(),'email','',MDA_MailAddress,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL
		--		FROM MailDeliveryAddress 
		--		WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
		--	END
		--END
		--IF (@Contract_Status='Completed')
		--BEGIN
		--	--审批完成通知CO
		--	SET @emailName_Ren='';
		--	SET @emailBody_Ren='';
		--	select @emailName_Ren=MMT_Subject,@emailBody_Ren=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_COMPLETE_TOCO';
			
		--	SET @emailName_Ren=REPLACE(@emailName_Ren,'{#ContractType}','Renewal')
		--	SET @emailBody_Ren=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@emailBody_Ren,'{#ContractType}','Renewal'),'{#DealerName}',@DelerName_Ren),'{#ProductLine}',@ProductLine_Ren),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
			
		--	INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
		--	SELECT NEWID(),'email','',MDA_MailAddress,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL
		--	FROM MailDeliveryAddress 
		--	WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
		--END
		
		--更改正式表
		IF(@Contract_Status='Completed')
		BEGIN
			--1.维护授权
			DECLARE @PRODUCT_CUR2 cursor;
			SET @PRODUCT_CUR2=cursor for  
				SELECT DAT_ID,DAT_DMA_ID_Actual,DAT_PMA_ID,DAT_ProductLine_BUM_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@Contract_ID
			OPEN @PRODUCT_CUR2
			FETCH NEXT FROM @PRODUCT_CUR2 INTO @SUBBU_DAT_ID_Temp,@SUBBU_DMA_ID,@SUBBU_PMA_ID,@SUBBU_ProductLineId
			WHILE @@FETCH_STATUS = 0        
				BEGIN
					SET @SUBBU_DAT_ID =NULL;
					SELECT @SUBBU_DAT_ID=DAT_ID FROM DealerAuthorizationTable A WHERE A.DAT_DMA_ID=@SUBBU_DMA_ID AND A.DAT_PMA_ID=@SUBBU_PMA_ID AND A.DAT_ProductLine_BUM_ID=@SUBBU_ProductLineId
					
					IF(@SUBBU_DAT_ID IS NOT NULL )
					BEGIN
						IF(ISNULL(@MarktType,'0'))='2'
						BEGIN
							DELETE HospitalList WHERE HLA_DAT_ID=@SUBBU_DAT_ID;
						END
						ELSE
						BEGIN
							DELETE HospitalList WHERE HLA_DAT_ID=@SUBBU_DAT_ID AND HLA_HOS_ID IN (SELECT AMP.HOS_ID FROM V_AllHospitalMarketProperty AMP INNER JOIN #TBProductLine C ON AMP.ProductLineID =C.Id AND ISNULL(AMP.MarketProperty,0)=CONVERT(INT, @MarktType)  )
						END
					END
					ELSE
					BEGIN
						SET @HasDCL_ID=NULL;
						SELECT @HasDCL_ID=DCL_ID FROM DealerContract A WHERE A.DCL_DMA_ID=@SUBBU_DMA_ID
						IF @HasDCL_ID IS NOT NULL
						BEGIN
							SET @SUBBU_DAT_ID=NEWID();
							INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,	DAT_ID,	DAT_DCL_ID,	DAT_DMA_ID,	DAT_ProductLine_BUM_ID,	DAT_AuthorizationType)
							VALUES(@SUBBU_PMA_ID,@SUBBU_DAT_ID,@HasDCL_ID,@SUBBU_DMA_ID,@SUBBU_ProductLineId,'1')
						END
						ELSE
						BEGIN
							SELECT @CON_NUMB='Contract-'+CONVERT(VARCHAR,(MAX(substring(DCL_ContractNumber,10,LEN(DCL_ContractNumber)))+1),20) FROM DealerContract WHERE DCL_ContractNumber  NOT IN ('Contract-TM','Contract-GKHT')
							SET @HasDCL_ID=NEWID();
							SET @SUBBU_DAT_ID=NEWID();
							
							INSERT INTO DealerContract(DCL_ID,DCL_StartDate,DCL_ApprovedBy,DCL_StopDate,DCL_ContractNumber,DCL_ContractYears,DCL_DMA_ID,DCL_Approval_ID,DCL_CreatedDate,DCL_CreatedBy)
							VALUES(@HasDCL_ID,@CON_BEGIN,NULL,@CON_END,@CON_NUMB,NULL,@DMA_ID,NULL,GETDATE(),'00000000-0000-0000-0000-000000000000');
							
							INSERT INTO DealerAuthorizationTable (DAT_PMA_ID,	DAT_ID,	DAT_DCL_ID,	DAT_DMA_ID,	DAT_ProductLine_BUM_ID,	DAT_AuthorizationType)
							VALUES(@SUBBU_PMA_ID,@SUBBU_DAT_ID,@HasDCL_ID,@SUBBU_DMA_ID,@SUBBU_ProductLineId,'1')
						END
					END
					
					INSERT INTO HospitalList (HLA_DAT_ID,HLA_HOS_ID,HLA_ID,HLA_Remark,HLA_HOS_Depart,	HLA_HOS_DepartType,	HLA_HOS_DepartRemark)
					SELECT @SUBBU_DAT_ID,tr.HOS_ID,tr.ID,Null,TR.HOS_Depart,TR.HOS_DepartType,TR.HOS_DepartRemark FROM ContractTerritory tr 
					WHERE TR.Contract_ID=@SUBBU_DAT_ID_Temp;
					
				 FETCH NEXT FROM @PRODUCT_CUR2 INTO @SUBBU_DAT_ID_Temp,@SUBBU_DMA_ID,@SUBBU_PMA_ID,@SUBBU_ProductLineId
				END
			CLOSE @PRODUCT_CUR2
			DEALLOCATE @PRODUCT_CUR2 ;
			--删除该合同中终止授权产品分类
			IF(ISNULL(@MarktType,'0'))='2'
			BEGIN
				DELETE HospitalList WHERE 
				 HLA_DAT_ID IN (
				SELECT DAT_ID FROM DealerAuthorizationTable 
				WHERE DAT_DMA_ID=@DMA_ID 
				AND DAT_ProductLine_BUM_ID in (select DAT_ProductLine_BUM_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@Contract_ID)
				AND DAT_PMA_ID NOT in (SELECT DAT_PMA_ID FROM DealerAuthorizationTableTemp A WHERE A.DAT_DCL_ID =@Contract_ID)
				AND DAT_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization where CA_ParentCode=@SubDepID)
				)
			END
			ELSE
			BEGIN
				DELETE HospitalList WHERE 
				HLA_HOS_ID IN (SELECT AMP.HOS_ID FROM V_AllHospitalMarketProperty AMP INNER JOIN #TBProductLine C ON AMP.ProductLineID =C.Id AND ISNULL(AMP.MarketProperty,0)=CONVERT(INT, @MarktType))
				AND HLA_DAT_ID IN (
				SELECT DAT_ID FROM DealerAuthorizationTable 
				WHERE DAT_DMA_ID=@DMA_ID 
				AND DAT_ProductLine_BUM_ID in (select DAT_ProductLine_BUM_ID FROM DealerAuthorizationTableTemp WHERE DAT_DCL_ID=@Contract_ID)
				AND DAT_PMA_ID NOT in (SELECT DAT_PMA_ID FROM DealerAuthorizationTableTemp A WHERE A.DAT_DCL_ID =@Contract_ID)
				AND DAT_PMA_ID IN (SELECT CA_ID FROM interface.ClassificationAuthorization where CA_ParentCode=@SubDepID)
				)
			END
			
			
			
			
			--2.将合同数据维护到DealerContractMaster
			--Renewal 中 DCM_Credit_Term\DCM_Guarantee字段没有
			SELECT	@Exclusiveness=CRE_Exclusiveness_Renewal,@ProductLin=CRE_ProductLine_New,@ProductLinRemarks=CRE_ProductLine_Remarks,
					@Prices=CRE_Prices_Renewal,@PricesRemarks=CRE_Prices_Remarks,
					@SpecialSales=CRE_SpecialSales_Renewal,@SpecialSalesRemarks=CRE_SpecialSales_Remarks,
					@CreditLimits=CRE_CreditLimits_Renewal,@Payment=CRE_Payment_Renewal,@SecurityDeposit=CRE_SecurityDeposit_Renewal,
					@Account=CRE_Account_Renewal,
					@GuaranteeWay=CRE_Guarantee_Way_Renewal,
					@GuaranteeWayRemark=CRE_Guarantee_Way_Remark,
					@Attachment=CRE_Attachment_Renewal
			FROM ContractRenewal WHERE CRE_ID= @Contract_ID
		
			DECLARE @Check_DCM_REW INT; 
			set @Check_DCM_REW=0;
			SELECT @Check_DCM_REW=COUNT(*) FROM DealerContractMaster A
			WHERE DCM_DMA_ID=@DMA_ID 
				AND CONVERT(NVARCHAR(10), A.DCM_Division)=@DivCode 
				AND CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))= @MarktType 
				AND A.DCM_CC_ID=@CC_ID
			
			IF(@Check_DCM_REW>0)
			BEGIN
				UPDATE DealerContractMaster 
				SET DCM_Exclusiveness=@Exclusiveness,
					DCM_EffectiveDate=@CON_BEGIN,
					DCM_ExpirationDate=@CON_END,
					DCM_ProductLine=@ProductLin, 
					DCM_ProductLineRemark=@ProductLinRemarks,
					DCM_Pricing_Discount=@Prices,
					DCM_Pricing_Discount_Remark=@PricesRemarks,
					DCM_Pricing_Rebate=@SpecialSales, 
					DCM_Pricing_Rebate_Remark=@SpecialSalesRemarks,
					DCM_Credit_Limit=@CreditLimits,
					DCM_Payment_Term=@Payment,
					DCM_Security_Deposit=@SecurityDeposit,
					DCM_Credit_Term=@Account,
					DCM_Guarantee=@GuaranteeWay,
					DCM_GuaranteeRemark=@GuaranteeWayRemark,
					DCM_Attachment =@Attachment,
					DCM_TerminationDate=null
				WHERE DCM_DMA_ID=@DMA_ID  
				AND  CONVERT(NVARCHAR(10), DCM_Division) =@DivCode
				AND  CONVERT(NVARCHAR(10),ISNULL(DCM_MarketType,0))= @MarktType
				AND DCM_CC_ID=@CC_ID
			END
			ELSE
			BEGIN
				INSERT INTO DealerContractMaster(DCM_CC_ID,DCM_ID,DCM_DMA_ID,DCM_DealerType,DCM_Division,DCM_MarketType,
				DCM_Update_Date,DCM_EffectiveDate,DCM_ExpirationDate,DCM_ProductLine,DCM_ProductLineRemark,
				DCM_Pricing_Discount,DCM_Pricing_Discount_Remark,DCM_Pricing_Rebate,DCM_Pricing_Rebate_Remark,
				DCM_Credit_Limit,DCM_Payment_Term,DCM_Security_Deposit,DCM_Credit_Term,
				DCM_Guarantee,DCM_GuaranteeRemark,DCM_Attachment,DCM_ContractType,	DCM_BSCEntity,	DCM_Exclusiveness)
				SELECT @CC_ID,NEWID(),B.DMA_ID,B.DMA_DealerType,(SELECT TOP 1 DV.DivisionCode FROM V_DivisionProductLineRelation DV WHERE DV.DivisionName=A.CRE_Division),@MarktType,
				GETDATE(),A.CRE_Agrmt_EffectiveDate_Renewal,A.CRE_Agrmt_ExpirationDate_Renewal,@ProductLin,@ProductLinRemarks,
				@Prices,@PricesRemarks,@SpecialSales,@SpecialSalesRemarks,
				@CreditLimits,@Payment,@SecurityDeposit,@Account,@GuaranteeWay,@GuaranteeWayRemark,@Attachment,'Dealer','China','Exclusive'
				FROM ContractRenewal A INNER JOIN DealerMaster B ON A.CRE_DMA_ID=B.DMA_ID
				WHERE A.CRE_ID=@Contract_ID
			END
			
		END
	END
	
	IF @Contract_Type='Termination'
	BEGIN
		UPDATE ContractTermination 
		SET CTE_Status=@Contract_Status 
		,CTE_Update_Date=GETDATE()
		WHERE CTE_ID=@Contract_ID;
		
		IF(@Contract_Status='Completed')
		BEGIN
			DECLARE @Tm_DelerType NVARCHAR(200);
			DECLARE @Tm_DelerName NVARCHAR(200);
			
			SELECT @DMA_ID=CTE_DMA_ID,@CON_BEGIN=CTE_Termination_EffectiveDate,@CON_END=CTE_Agreement_ExpirationDate,@Division=CTE_Division ,
					@Tm_DelerType=DealerMaster.DMA_DealerType,@Tm_DelerName=DealerMaster.DMA_ChineseName
			FROM  ContractTermination 
			LEFT JOIN DealerMaster ON ContractTermination.CTE_DMA_ID=DealerMaster.DMA_ID
			WHERE CTE_ID= @Contract_ID
			
			--------------------------------
			--发邮件
			DECLARE @Tm_email_Address NVARCHAR(200)
			DECLARE @Tm_email_Pl NVARCHAR(200)
			DECLARE @Tm_email_Name NVARCHAR(300)
			DECLARE @Tm_email_Body NVARCHAR(4000)
			
			SELECT TOP 1  @Tm_email_Pl=b.ATTRIBUTE_NAME FROM #TBProductLine a,View_ProductLine b WHERE a.Id=b.Id; 
			
			IF (@Tm_DelerType='T1' OR @Tm_DelerType='LP')
			BEGIN
				SELECT @Tm_email_Address=DMA_Email FROM DealerMaster WHERE DMA_ID=@DMA_ID;
				select @Tm_email_Name=MMT_Subject,@Tm_email_Body=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_Termina_TODEALER';
				SET @Tm_email_Body=REPLACE(REPLACE(REPLACE(@Tm_email_Body,'{#ProductLine}',@Tm_email_Pl),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
				SET @Tm_email_Name=@Division+'-'+@CC_NameCN+'-'+@Tm_DelerName+'-'+'Termination'+'('+@Tm_DelerType+')-'+@Tm_email_Name
				
				--IF(@Tm_email_Address IS NOT NULL )
				--BEGIN
				--	INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--	VALUES(NEWID(),'email','',@Tm_email_Address,@Tm_email_Name,@Tm_email_Body,'Waiting',GETDATE(),NULL);
				--END
				--IF (@Tm_DelerType='LP')
				--BEGIN
				--	--发邮件给平台各负责人 
				--	INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				--	SELECT NEWID(),'email','',MDA_MailAddress,@Tm_email_Name,@Tm_email_Body,'Waiting',GETDATE(),NULL
				--	FROM MailDeliveryAddress 
				--	INNER JOIN Client 
				--		ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
				--		AND Client.CLT_Corp_Id=@DMA_ID
				--	WHERE MDA_MailType='DCMS'
				--END
			END
			--IF (@Tm_DelerType='T2')
			--BEGIN
			--	DECLARE @Tm_Dma_Id_LP NVARCHAR(36)
			--	SELECT @Tm_Dma_Id_LP=b.DMA_ID FROM DealerMaster a 
			--	INNER JOIN DealerMaster b ON a.DMA_Parent_DMA_ID=b.DMA_ID
			--	where a.DMA_ID=@DMA_ID;
				
			--	select @Tm_email_Name=MMT_Subject,@Tm_email_Body=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_Termina_TOLP';
			--	SET @Tm_email_Body=REPLACE(REPLACE(REPLACE(REPLACE(@Tm_email_Body,'{#ProductLine}',@Tm_email_Pl),'{#DealerName}',@Tm_DelerName),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
			--	SET @Tm_email_Name=@Division+'-'+@CC_NameCN+'-'+@Tm_DelerName+'-'+'Termination'+'('+@Tm_DelerType+')-'+@Tm_email_Name
				
			--	INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
			--	SELECT NEWID(),'email','',MDA_MailAddress,@Tm_email_Name,@Tm_email_Body,'Waiting',GETDATE(),NULL
			--	FROM MailDeliveryAddress 
			--	INNER JOIN Client 
			--		ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
			--		AND Client.CLT_Corp_Id=@Tm_Dma_Id_LP
			--	WHERE MDA_MailType='DCMS'
			--	--抄送CO
			--	INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
			--	SELECT NEWID(),'email','',MDA_MailAddress,@Tm_email_Name,@Tm_email_Body,'Waiting',GETDATE(),NULL
			--	FROM MailDeliveryAddress 
			--	WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
			--END
			
			--审批完成通知CO
			SET @Tm_email_Name='';
			SET @Tm_email_Body='';
			select @Tm_email_Name=MMT_Subject,@Tm_email_Body=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_COMPLETE_TOCO';
			
			SET @Tm_email_Name=REPLACE(@Tm_email_Name,'{#ContractType}','Termination')
			SET @Tm_email_Body=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Tm_email_Body,'{#ContractType}','Termination'),'{#DealerName}',@Tm_DelerName),'{#ProductLine}',@Tm_email_Pl),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
			
			--INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
			--SELECT NEWID(),'email','',MDA_MailAddress,@Tm_email_Name,@Tm_email_Body,'Waiting',GETDATE(),NULL
			--FROM MailDeliveryAddress 
			--WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
			
		END
	END
	
	--审批完成后
	IF(@Contract_Status='Completed')
	BEGIN
	 /*1.修改经销商指标*/
		IF((@AmdQuotaIsChange is null or @AmdQuotaIsChange=0) and @Contract_Type= 'Amendment' )
		begin 
			SET @RtnMsg = '';
		end
		ELSE 
		BEGIN 
			IF (@Contract_Type= 'Termination')
			BEGIN
				DECLARE @TerminationType NVARCHAR(20);
				DECLARE @DivisionCode NVARCHAR(20);
				DECLARE @TerminationEffectiveDate DATETIME;
				DECLARE @TerminationMarketType NVARCHAR(20);
				
				SELECT @DMA_ID=CTE_DMA_ID,
				@TerminationMarketType=CTE_MarketType,
				@TerminationEffectiveDate=CTE_Termination_EffectiveDate,
				@Division=CTE_Division ,
				@DivisionCode=(SELECT REV1 
				FROM Lafite_ATTRIBUTE 
				WHERE ATTRIBUTE_TYPE='BU' 
				AND DELETE_FLAG='0' 
				AND ATTRIBUTE_NAME=CTE_Division) ,
				@TerminationType=CTE_TerminationStatus 
				FROM  ContractTermination 
				LEFT JOIN DealerMaster ON ContractTermination.CTE_DMA_ID=DealerMaster.DMA_ID
				WHERE CTE_ID= @Contract_ID
			
				IF(@TerminationType='Non-Renewal')
				BEGIN
					UPDATE DealerContractMaster SET DCM_TerminationDate=@TerminationEffectiveDate  
					WHERE DCM_DMA_ID=@DMA_ID 
					AND DCM_Division=@DivisionCode
					AND CONVERT( nvarchar(10),ISNULL(DCM_MarketType,0))=ISNULL(@TerminationMarketType,'0')
					AND DCM_CC_ID=@CC_ID;
				END
				else
				BEGIN
					UPDATE DealerContractMaster SET DCM_TerminationDate=@TerminationEffectiveDate  
					WHERE DCM_DMA_ID=@DMA_ID 
					AND DCM_Division=@DivisionCode
					AND CONVERT( nvarchar(10),ISNULL(DCM_MarketType,0))=ISNULL(@TerminationMarketType,'0')
					AND DCM_CC_ID=@CC_ID;
				END
				
			END
			ELSE
			BEGIN
				IF @MarktType='2'
				BEGIN
					DELETE AOPICDealerHospital 
					WHERE AOPICH_ID IN
							  (SELECT aop.AOPICH_ID FROM    AOPICDealerHospital aop
							   INNER JOIN AOPICDealerHospitalTemp aoptemp 
							   ON aop.AOPICH_DMA_ID =aoptemp.AOPICH_DMA_ID_Actual 
							   AND aop.AOPICH_ProductLine_ID = aoptemp.AOPICH_ProductLine_ID
										 AND aop.AOPICH_Year =aoptemp.AOPICH_Year
								WHERE aoptemp.AOPICH_Contract_ID = @Contract_ID)
						  AND AOPICH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure WHERE CC_ID=@CC_ID)						
				
							
					DELETE AOPDealerHospital  
					WHERE  AOPDealerHospital.AOPDH_ID IN
						(SELECT aop.AOPDH_ID FROM    AOPDealerHospital aop
						   INNER JOIN AOPDealerHospitalTemp aoptemp 
									ON aop.AOPDH_Dealer_DMA_ID =aoptemp.AOPDH_Dealer_DMA_ID_Actual 
										AND aop.AOPDH_ProductLine_BUM_ID = aoptemp.AOPDH_ProductLine_BUM_ID
										AND aop.AOPDH_Year =aoptemp.AOPDH_Year
							WHERE aoptemp.AOPDH_Contract_ID = @Contract_ID)
						AND AOPDH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure WHERE CC_ID=@CC_ID)		
				END
				ELSE
				BEGIN
					DELETE AOPICDealerHospital 
					WHERE AOPICDealerHospital.AOPICH_ID IN
							  (SELECT aop.AOPICH_ID FROM    AOPICDealerHospital aop
							   INNER JOIN AOPICDealerHospitalTemp aoptemp 
							   ON aop.AOPICH_DMA_ID =aoptemp.AOPICH_DMA_ID_Actual 
							   AND aop.AOPICH_ProductLine_ID = aoptemp.AOPICH_ProductLine_ID
										 AND aop.AOPICH_Year =aoptemp.AOPICH_Year
								WHERE aoptemp.AOPICH_Contract_ID = @Contract_ID)
						AND AOPICDealerHospital.AOPICH_Hospital_ID IN(SELECT AMP.Hos_Id FROM V_AllHospitalMarketProperty AMP WHERE ISNULL(AMP.MarketProperty,0) = CONVERT(INT, @MarktType) AND AMP.DivisionName=@Division)
						AND AOPICH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure WHERE CC_ID=@CC_ID)	
						
					DELETE AOPDealerHospital  
					WHERE  AOPDealerHospital.AOPDH_ID IN
							(SELECT aop.AOPDH_ID FROM    AOPDealerHospital aop
							   INNER JOIN AOPDealerHospitalTemp aoptemp 
										ON aop.AOPDH_Dealer_DMA_ID =aoptemp.AOPDH_Dealer_DMA_ID_Actual 
											AND aop.AOPDH_ProductLine_BUM_ID = aoptemp.AOPDH_ProductLine_BUM_ID
											AND aop.AOPDH_Year =aoptemp.AOPDH_Year
											--AND aop.AOPDH_PCT_ID=aoptemp.AOPDH_PCT_ID
								WHERE aoptemp.AOPDH_Contract_ID = @Contract_ID)
						AND AOPDealerHospital.AOPDH_Hospital_ID IN(SELECT AMP.Hos_Id FROM V_AllHospitalMarketProperty AMP WHERE ISNULL(AMP.MarketProperty,0) = CONVERT(INT,@MarktType) AND AMP.DivisionName=@Division)
						AND AOPDH_PCT_ID IN (SELECT DISTINCT CQ_ID FROM V_ProductClassificationStructure WHERE CC_ID=@CC_ID)	
				END
				
				DELETE AOPDealer
				WHERE AOPD_Dealer_DMA_ID=@DMA_ID
				AND AOPD_ProductLine_BUM_ID IN (SELECT ID FROM #TBProductLine)
				AND ISNULL(AOPD_Market_Type,'0')=@MarktType
				And AOPD_CC_ID =  (SELECT DISTINCT AOPD_CC_ID FROM AOPDealerTemp WHERE AOPD_Contract_ID=@Contract_ID)
				AND AOPD_Year IN (SELECT DISTINCT AOPD_Year FROM AOPDealerTemp WHERE AOPD_Contract_ID=@Contract_ID);
				
			END
			
			INSERT INTO AOPDealer(AOPD_CC_ID,AOPD_ID,AOPD_Dealer_DMA_ID,AOPD_ProductLine_BUM_ID,AOPD_Market_Type,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date)
			SELECT AOPD_CC_ID,AOPD_ID,AOPD_Dealer_DMA_ID_Actual,AOPD_ProductLine_BUM_ID,@MarktType,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_User_ID,AOPD_Update_Date 
			FROM AOPDealerTemp aop 
			WHERE aop.AOPD_Contract_ID=@Contract_ID and aop.AOPD_Dealer_DMA_ID_Actual=@DMA_ID;
			
			INSERT INTO AOPDealerHospital(AOPDH_PCT_ID,AOPDH_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Hospital_ID,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date)
			SELECT AOPDH_PCT_ID,AOPDH_ID,AOPDH_Dealer_DMA_ID_Actual,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Hospital_ID,AOPDH_Month,AOPDH_Amount,AOPDH_Update_User_ID,AOPDH_Update_Date 
			FROM AOPDealerHospitalTemp aop 
			WHERE aop.AOPDH_Contract_ID=@Contract_ID and aop.AOPDH_Dealer_DMA_ID_Actual=@DMA_ID;
			
			INSERT INTO AOPICDealerHospital( AOPICH_ID , AOPICH_DMA_ID , AOPICH_ProductLine_ID, AOPICH_PCT_ID, AOPICH_Year , AOPICH_Hospital_ID , AOPICH_Month, AOPICH_Unit, AOPICH_Update_User_ID, AOPICH_Update_Date)
			SELECT AOPICH_ID, AOPICH_DMA_ID_Actual, AOPICH_ProductLine_ID, AOPICH_PCT_ID, AOPICH_Year, AOPICH_Hospital_ID, AOPICH_Month, AOPICH_Unit, AOPICH_Update_User_ID, AOPICH_Update_Date
			FROM AOPICDealerHospitalTemp aop  
			WHERE aop.AOPICH_Contract_ID =@Contract_ID and aop.AOPICH_DMA_ID_Actual=@DMA_ID;
			
			--跟新HospitalProductMapping 状态
			UPDATE AOPHospitalProductMapping 
			SET AOPHPM_ActiveFlag=0 
			FROM ( select distinct CC_ID,CQ_ID from  V_ProductClassificationStructure) PC WHERE PC.CQ_ID=AOPHospitalProductMapping.AOPHPM_PCT_ID AND PC.CC_ID =@CC_ID
			AND AOPHospitalProductMapping.AOPHPM_Dma_id=@DMA_ID;
			--设置当前合同为有效状态
			UPDATE AOPHospitalProductMapping SET  AOPHPM_ActiveFlag=1 WHERE AOPHPM_ContractId=@Contract_ID;
			
			
			IF (@Contract_Type='Appointment')
			BEGIN
				--分配菜单
				EXEC [dbo].[GC_OpenAccountPermissions] @DMA_ID,'',''
			END
		END	
		
		/* 授权区域更主信息表*/
		EXEC [dbo].[GC_MaintainAreaAutStatus] @Contract_ID, @Contract_Type
	END
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
END CATCH

GO


