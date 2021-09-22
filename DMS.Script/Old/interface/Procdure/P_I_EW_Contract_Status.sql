DROP PROCEDURE [interface].[P_I_EW_Contract_Status]
GO



CREATE PROCEDURE [interface].[P_I_EW_Contract_Status]
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
	SELECT top 1 @ApplicantUser=isnull(Name,'') FROM [interface].[Biz_Dealer_Approval] WHERE ApplicationID=@Contract_ID ORDER BY DoneTime ;
	SELECT  @MarktType= CONVERT(NVARCHAR(10),ISNULL(MarketType,0)),@SubDepID= SubDepID,@Division=Division FROM Interface.T_I_EW_Contract A WHERE A.InstanceID=@Contract_ID;
	SELECT @CC_ID= CC_ID,@CC_NameCN=CC_NameCN FROM interface.ClassificationContract a WHERE A.CC_Code=@SubDepID;
	INSERT INTO #TBProductLine (Id)
		SELECT DV.ProductLineID FROM V_DivisionProductLineRelation  DV
		WHERE DV.DivisionName=@Division AND DV.IsEmerging='0';
	SELECT @DivCode=A.DivisionCode FROM V_DivisionProductLineRelation A WHERE  A.DivisionName=@Division AND A.IsEmerging='0';
	
	IF EXISTS (SELECT 1 FROM [interface].[T_I_EW_ContractState]  A WHERE A.ContractId=@Contract_ID)
	BEGIN
		DELETE [interface].[T_I_EW_ContractState] WHERE ContractId=@Contract_ID;
	END
	
	
	IF @Contract_Type='Appointment'
	BEGIN
		UPDATE ContractAppointment 	SET CAP_Status=@Contract_Status ,CAP_Update_Date=GETDATE()	WHERE CAP_ID=@Contract_ID;
		
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
		
		SELECT @DMA_ID=a.CAP_DMA_ID,@dealerName= CAP_Company_Name,@email=CAP_Email_Address,@ISEquipment=CAP_Type,@Division=CAP_Division  ,@DM_TY=B.DealerLevel
		FROM ContractAppointment A
		INNER JOIN INTERFACE.T_I_EW_Contract  B ON A.CAP_ID=B.InstanceID
		WHERE A.CAP_ID=@Contract_ID
		
		SELECT @dealerAccount=DealerMaster.DMA_SAP_Code,@dealerTypeEM=DealerMaster.DMA_DealerType 
			FROM Lafite_IDENTITY INNER JOIN  DealerMaster 
			ON Lafite_IDENTITY.Corp_ID=DealerMaster.DMA_ID   
			WHERE  DealerMaster.DMA_ID=@DMA_ID
			and DealerMaster.DMA_DealerType=@DM_TY;
			
		SELECT @ProductName_App= ProductLineName FROM V_DivisionProductLineRelation WHERE DivisionName=@Division AND IsEmerging='0'
		SET @dealerAccount=ISNULL(@dealerAccount,'')+'_01';
		--账号建立后邮件通知Dealer LP CO
		select @mailNameCo=MMT_Subject,@mailBodyCo=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_DEALERACCOUNTTOCO';
		IF (@dealerTypeEM='T1' OR @dealerTypeEM='LP' OR @dealerTypeEM='RLD')
		BEGIN
			IF(@Contract_Status='COApproved')
			BEGIN
				select @mailName=MMT_Subject,@mailBody=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_DEALERIAF';
				SET @mailBody=REPLACE(REPLACE(REPLACE(@mailBody,'{#DealerName}','倍通同事'),'{#Account}',@dealerAccount),'{#ApplicantUser}',ISNULL(@ApplicantUser,''));
				SET @mailName=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailName
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				VALUES(NEWID(),'email','','bsc-dms@crediteyes.com',@mailName,@mailBody,'Waiting',GETDATE(),NULL);
				
				
				--通知CO
				SET @mailBodyCo=REPLACE(REPLACE(@mailBodyCo,'{#DealerName}',@dealerName),'{#ApplicantUser}',@ApplicantUser);
				SET @mailNameCo=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailNameCo
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',MDA_MailAddress,@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL
				FROM MailDeliveryAddress WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO'
				--VALUES(NEWID(),'email','','YingSarah.Huang@bsci.com',@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL);
				
			END
			IF(@Contract_Status='Completed')
			BEGIN
				--通知经销商
				select @mailName=MMT_Subject,@mailBody=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_CompleteTONewDealer';
				SET @mailBody=REPLACE(@mailBody,'{#Account}',@dealerAccount);
				SET @mailName=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailName
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				VALUES(NEWID(),'email','',@email,@mailName,@mailBody,'Waiting',GETDATE(),NULL);
			
				--发邮件通知CO准备Agreemen
				select @mailNameCo=MMT_Subject,@mailBodyCo=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_READYAGREEMEN';
				SET @mailBodyCo=REPLACE(REPLACE(REPLACE(REPLACE(@mailBodyCo,'{#DealerName}',@dealerName),'{#ProductLine}',@ProductName_App),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
				SET @mailNameCo=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailNameCo
				
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',MDA_MailAddress,@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL
				FROM MailDeliveryAddress WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO'
				--VALUES(NEWID(),'email','','YingSarah.Huang@bsci.com',@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL);
			END
		END
		ELSE IF (@dealerTypeEM='T2' AND @Contract_Status='Completed' )
		BEGIN
			DECLARE @dealerNameLP NVARCHAR(200)
			DECLARE @dealerIdLP NVARCHAR(36)
			SELECT @dealerNameLP=pdm.DMA_ChineseName,@dealerIdLP=pdm.DMA_ID 
			FROM DealerMaster dm 
			INNER JOIN DealerMaster pdm on  dm.DMA_Parent_DMA_ID=pdm.DMA_ID WHERE dm.DMA_ID=@DMA_ID
			
			--通知LP
			IF (ISNULL(@dealerIdLP,'')<>'')
			BEGIN
				SELECT @mailNameLP=MMT_Subject,@mailBodyLP=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_DEALERIAFTOLP';
				SET @mailBodyLP=REPLACE(REPLACE(REPLACE(@mailBodyLP,'{#DealerNameLP}',@dealerNameLP),'{#DealerName}',@dealerName),'{#ApplicantUser}',@ApplicantUser);
				SET @mailNameLP=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailNameLP
				
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',MDA_MailAddress,@mailNameLP,@mailBodyLP,'Waiting',GETDATE(),NULL
				FROM MailDeliveryAddress 
				INNER JOIN Client 
					ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
					AND Client.CLT_Corp_Id=@dealerIdLP
				WHERE MDA_MailType='DCMS' 
				--抄送CO
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',MDA_MailAddress,@mailNameLP,@mailBodyLP,'Waiting',GETDATE(),NULL
				FROM MailDeliveryAddress 
				WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
				
			END
			--通知CO
			SET @mailBodyCo=REPLACE(REPLACE(@mailBodyCo,'{#DealerName}',@dealerName),'{#ApplicantUser}',@ApplicantUser);;
			SET @mailNameCo=@Division+'-'+@CC_NameCN+'-'+@dealerName+'-'+'Appointment'+'('+@dealerTypeEM+')-'+@mailNameCo
			INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
			SELECT NEWID(),'email','',MDA_MailAddress,@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL
			FROM MailDeliveryAddress WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
			--VALUES(NEWID(),'email','','YingSarah.Huang@bsci.com',@mailNameCo,@mailBodyCo,'Waiting',GETDATE(),NULL);
		END
		
		--修改正式表
		IF(@Contract_Status='Completed')
		BEGIN
			SELECT @DMA_ID=CAP_DMA_ID,@CON_BEGIN=CAP_EffectiveDate,@CON_END=CAP_ExpirationDate,@Division=CAP_Division FROM  ContractAppointment WHERE CAP_ID= @Contract_ID
			
			INSERT INTO [interface].[T_I_EW_ContractState] (ContractId,BeginDate,ContractState,ContractType,SynState)
			VALUES(@Contract_ID,@CON_BEGIN,'Completed','Appointment','0')
		END
		
	END
	
	IF @Contract_Type='Amendment'
	BEGIN
		UPDATE ContractAmendment SET	CAM_Status=@Contract_Status ,CAM_Update_Date=GETDATE() WHERE CAM_ID=@Contract_ID;
		
		IF(@Contract_Status='Completed')
		BEGIN
			DECLARE @Amd_DelerType NVARCHAR(200);
			DECLARE @Amd_DelerName NVARCHAR(200);
			
			SELECT @DMA_ID=CAM_DMA_ID,@Amd_DelerName=DealerMaster.DMA_ChineseName,@CON_BEGIN=CAM_Amendment_EffectiveDate,@CON_END=CAM_Agreement_ExpirationDate,@Division=CAM_Division ,@Amd_DelerType=DealerMaster.DMA_DealerType
			FROM  ContractAmendment 
			INNER JOIN DealerMaster ON ContractAmendment.CAM_DMA_ID=DealerMaster.DMA_ID
			WHERE CAM_ID= @Contract_ID
			
			INSERT INTO [interface].[T_I_EW_ContractState] (ContractId,BeginDate,ContractState,ContractType,SynState)
			VALUES(@Contract_ID,@CON_BEGIN,'Completed','Amendment','0')
			
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
				IF(@Amd_email_Address IS NOT NULL )
				BEGIN
					--发邮件给DealerMaster提供的邮件地址
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					VALUES(NEWID(),'email','',@Amd_email_Address,@Amd_email_Name,@Amd_email_Body,'Waiting',GETDATE(),NULL);
				END
				IF (@Amd_DelerType='LP')
				BEGIN
					--发邮件给平台各负责人 
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',MDA_MailAddress,@Amd_email_Name,@Amd_email_Body,'Waiting',GETDATE(),NULL
					FROM MailDeliveryAddress 
					INNER JOIN Client 
						ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
						AND Client.CLT_Corp_Id=@DMA_ID
					WHERE MDA_MailType='DCMS' 
				END
			END
			IF (@Amd_DelerType='T2')
			BEGIN
				SELECT @Amd_Dma_Id_LP=b.DMA_ID FROM DealerMaster a 
				INNER JOIN DealerMaster b ON a.DMA_Parent_DMA_ID=b.DMA_ID
				where a.DMA_ID=@DMA_ID;
				
				select @Amd_email_Name=MMT_Subject,@Amd_email_Body=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_AMIND_TOLP';
				SET @Amd_email_Body=REPLACE(REPLACE(REPLACE(REPLACE(@Amd_email_Body,'{#ProductLine}',@Amd_email_Pl),'{#DealerName}',@Amd_DelerName),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
				SET @Amd_email_Name=@Division+'-'+@CC_NameCN+'-'+@Amd_DelerName+'-'+'Amendment'+'('+@Amd_DelerType+')-'+@Amd_email_Name
				
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',MDA_MailAddress,@Amd_email_Name,@Amd_email_Body,'Waiting',GETDATE(),NULL
				FROM MailDeliveryAddress 
				INNER JOIN Client 
					ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
					AND Client.CLT_Corp_Id=@Amd_Dma_Id_LP
				WHERE MDA_MailType='DCMS' 
				--抄送CO
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',MDA_MailAddress,@Amd_email_Name,@Amd_email_Body,'Waiting',GETDATE(),NULL
				FROM MailDeliveryAddress 
				WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
				
			END
			--通知CO
			SET @Amd_email_Name='';
			SET @Amd_email_Body='';
			select @Amd_email_Name=MMT_Subject,@Amd_email_Body=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_COMPLETE_TOCO';
			
			SET @Amd_email_Name=REPLACE(@Amd_email_Name,'{#ContractType}','Amendment')
			SET @Amd_email_Body=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Amd_email_Body,'{#ContractType}','Amendment'),'{#DealerName}',@Amd_DelerName),'{#ProductLine}',@Amd_email_Pl),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
			
			INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
			SELECT NEWID(),'email','',MDA_MailAddress,@Amd_email_Name,@Amd_email_Body,'Waiting',GETDATE(),NULL
			FROM MailDeliveryAddress 
			WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
			
		END
	END
	
	IF @Contract_Type='Renewal'
	BEGIN
		--更改合同状态
		UPDATE ContractRenewal 	SET CRE_Status=@Contract_Status ,CRE_Update_Date=GETDATE()	WHERE CRE_ID=@Contract_ID;
		
		--获取参数
		SELECT @DMA_ID=CRE_DMA_ID,@CON_BEGIN=CRE_Agrmt_EffectiveDate_Renewal,@CON_END=CRE_Agrmt_ExpirationDate_Renewal,@Division=CRE_Division 
		FROM  ContractRenewal WHERE CRE_ID= @Contract_ID
		
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
				IF(ISNULL(@emailAddress_Ren,'')<>'')
				BEGIN
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					VALUES(NEWID(),'email','',@emailAddress_Ren,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL);
					
						--抄送CO
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',MDA_MailAddress,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL
					FROM MailDeliveryAddress 
					WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
				
				END
				IF(@DelerType_Ren='LP')
				BEGIN
					--发邮件给平台各负责人 
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',MDA_MailAddress,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL
					FROM MailDeliveryAddress 
					INNER JOIN Client 
						ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
						AND Client.CLT_Corp_Id=@DMA_ID
					WHERE MDA_MailType='DCMS'
					
				END
			END
		END
		IF(@DelerType_Ren='T2')
		BEGIN
			IF (@Contract_Status='Completed')
			BEGIN
				select @emailName_Ren=MMT_Subject,@emailBody_Ren=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_RENEWAL_TOLPIAF';
				SET @emailBody_Ren=REPLACE(REPLACE(REPLACE(REPLACE(@emailBody_Ren,'{#ProductLine}',isnull(@ProductLine_Ren,'')),'{#DealerName}',isnull(@DelerName_Ren,'')),'{#SubBU}',isnull(@CC_NameCN,'')),'{#ApplicantUser}',isnull(@ApplicantUser,''));
				SET @emailName_Ren=@Division+'-'+@CC_NameCN+'-'+@DelerName_Ren+'-'+'Renewal'+'('+@DelerType_Ren+')-'+@emailName_Ren
				
				--发邮件给平台各负责人 
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',MDA_MailAddress,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL
				FROM MailDeliveryAddress 
				INNER JOIN Client 
					ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
					AND Client.CLT_Corp_Id=@ParentDmaId_Ren
				WHERE MDA_MailType='DCMS'
				
				--抄送CO
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',MDA_MailAddress,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL
				FROM MailDeliveryAddress 
				WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
			END
		END
		IF (@Contract_Status='Completed')
		BEGIN
			--审批完成通知CO
			SET @emailName_Ren='';
			SET @emailBody_Ren='';
			select @emailName_Ren=MMT_Subject,@emailBody_Ren=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_COMPLETE_TOCO';
			
			SET @emailName_Ren=REPLACE(@emailName_Ren,'{#ContractType}','Renewal')
			SET @emailBody_Ren=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@emailBody_Ren,'{#ContractType}','Renewal'),'{#DealerName}',isnull(@DelerName_Ren,'')),'{#ProductLine}',isnull(@ProductLine_Ren,'')),'{#SubBU}',isnull(@CC_NameCN,'')),'{#ApplicantUser}',isnull(@ApplicantUser,''));
			
			INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
			SELECT NEWID(),'email','',MDA_MailAddress,@emailName_Ren,@emailBody_Ren,'Waiting',GETDATE(),NULL
			FROM MailDeliveryAddress 
			WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
		END
		
		--更改正式表
		IF(@Contract_Status='Completed')
		BEGIN
			INSERT INTO [interface].[T_I_EW_ContractState] (ContractId,BeginDate,ContractState,ContractType,SynState)
			VALUES(@Contract_ID,@CON_BEGIN,'Completed','Renewal','0')
		END
	END
	
	IF @Contract_Type='Termination'
	BEGIN
		UPDATE ContractTermination 	SET CTE_Status=@Contract_Status ,CTE_Update_Date=GETDATE()	WHERE CTE_ID=@Contract_ID;
		
		IF(@Contract_Status='Completed')
		BEGIN
			DECLARE @Tm_DelerType NVARCHAR(200);
			DECLARE @Tm_DelerName NVARCHAR(200);
			
			SELECT @DMA_ID=CTE_DMA_ID,@CON_BEGIN=CTE_Termination_EffectiveDate,@CON_END=CTE_Agreement_ExpirationDate,@Division=CTE_Division ,
					@Tm_DelerType=DealerMaster.DMA_DealerType,@Tm_DelerName=DealerMaster.DMA_ChineseName
			FROM  ContractTermination 
			LEFT JOIN DealerMaster ON ContractTermination.CTE_DMA_ID=DealerMaster.DMA_ID
			WHERE CTE_ID= @Contract_ID
			
			INSERT INTO [interface].[T_I_EW_ContractState] (ContractId,BeginDate,ContractState,ContractType,SynState)
			VALUES(@Contract_ID,@CON_BEGIN,'Completed','Termination','0')
			
			
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
				
				IF(@Tm_email_Address IS NOT NULL )
				BEGIN
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					VALUES(NEWID(),'email','',@Tm_email_Address,@Tm_email_Name,@Tm_email_Body,'Waiting',GETDATE(),NULL);
				END
				IF (@Tm_DelerType='LP')
				BEGIN
					--发邮件给平台各负责人 
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',MDA_MailAddress,@Tm_email_Name,@Tm_email_Body,'Waiting',GETDATE(),NULL
					FROM MailDeliveryAddress 
					INNER JOIN Client 
						ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
						AND Client.CLT_Corp_Id=@DMA_ID
					WHERE MDA_MailType='DCMS'
				END
			END
			IF (@Tm_DelerType='T2')
			BEGIN
				DECLARE @Tm_Dma_Id_LP NVARCHAR(36)
				SELECT @Tm_Dma_Id_LP=b.DMA_ID FROM DealerMaster a 
				INNER JOIN DealerMaster b ON a.DMA_Parent_DMA_ID=b.DMA_ID
				where a.DMA_ID=@DMA_ID;
				
				select @Tm_email_Name=MMT_Subject,@Tm_email_Body=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_Termina_TOLP';
				SET @Tm_email_Body=REPLACE(REPLACE(REPLACE(REPLACE(@Tm_email_Body,'{#ProductLine}',@Tm_email_Pl),'{#DealerName}',@Tm_DelerName),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
				SET @Tm_email_Name=@Division+'-'+@CC_NameCN+'-'+@Tm_DelerName+'-'+'Termination'+'('+@Tm_DelerType+')-'+@Tm_email_Name
				
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',MDA_MailAddress,@Tm_email_Name,@Tm_email_Body,'Waiting',GETDATE(),NULL
				FROM MailDeliveryAddress 
				INNER JOIN Client 
					ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
					AND Client.CLT_Corp_Id=@Tm_Dma_Id_LP
				WHERE MDA_MailType='DCMS'
				--抄送CO
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',MDA_MailAddress,@Tm_email_Name,@Tm_email_Body,'Waiting',GETDATE(),NULL
				FROM MailDeliveryAddress 
				WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
			END
			
			--审批完成通知CO
			SET @Tm_email_Name='';
			SET @Tm_email_Body='';
			select @Tm_email_Name=MMT_Subject,@Tm_email_Body=MMT_Body from MailMessageTemplate  where MMT_Code= 'EMAIL_CONTRACT_COMPLETE_TOCO';
			
			SET @Tm_email_Name=REPLACE(@Tm_email_Name,'{#ContractType}','Termination')
			SET @Tm_email_Body=REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@Tm_email_Body,'{#ContractType}','Termination'),'{#DealerName}',@Tm_DelerName),'{#ProductLine}',@Tm_email_Pl),'{#SubBU}',@CC_NameCN),'{#ApplicantUser}',@ApplicantUser);
			
			INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
			SELECT NEWID(),'email','',MDA_MailAddress,@Tm_email_Name,@Tm_email_Body,'Waiting',GETDATE(),NULL
			FROM MailDeliveryAddress 
			WHERE MDA_MailType='DCMS' AND MDA_MailTo='CO';
			
		END
	END
	
	--审批完成后
	IF(@Contract_Status='Completed')
	BEGIN
		
		IF (@Contract_Type='Appointment')
		BEGIN
			--分配菜单
			EXEC [dbo].[GC_OpenAccountPermissions] @DMA_ID,'',''
		END
		EXEC [dbo].[GC_UpdateProcessIndex]@Contract_ID,@Contract_Type,@CON_BEGIN,NULL,NULL
	END
	
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES(NEWID(),@Contract_ID,'00000000-0000-0000-0000-000000000000',GETDATE (),'Success',@Contract_Type+' 合同 '+@Contract_Status+' 状态同步成功')
	
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
	
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES(NEWID(),@Contract_ID,'00000000-0000-0000-0000-000000000000',GETDATE (),'Failure',@Contract_Type+' 合同 '+@Contract_Status+' 同步失败:'+@vError)
	
    return -1
END CATCH

GO


