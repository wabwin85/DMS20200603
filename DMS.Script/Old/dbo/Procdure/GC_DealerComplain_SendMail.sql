DROP PROCEDURE [dbo].[GC_DealerComplain_SendMail]
GO

CREATE PROCEDURE [dbo].[GC_DealerComplain_SendMail]
	@DC_Id uniqueidentifier,
	@DC_Type NVARCHAR(100)
AS
	DECLARE @DC_Status nvarchar(100);
	DECLARE @PRODUCTTYPE nvarchar(100);
	DECLARE @BU nvarchar(100);
	
	DECLARE @Mail_Tital nvarchar(500);
	DECLARE @Mail_Body nvarchar(MAX);
	DECLARE @Mail_Address nvarchar(200);
	DECLARE @INITIALEMAIL nvarchar(200);
	DECLARE @UserId uniqueidentifier;
	
	DECLARE @Content nvarchar(MAX);
	
	DECLARE @DC_ComplainNbr nvarchar(100);
	DECLARE @DC_ComplainId nvarchar(200);
	DECLARE @DISTRIBUTORCUSTOMER nvarchar(100);
	DECLARE @DN nvarchar(100);
	DECLARE @UPN nvarchar(100);
	DECLARE @LOT nvarchar(100);
	
	IF @DC_Type='BSC'
	BEGIN
		SELECT @DC_Status=DC_Status,@PRODUCTTYPE=PRODUCTTYPE,@BU=BU FROM DealerComplain WHERE DC_ID=@DC_Id
	END
	ELSE IF @DC_Type='CRM'
	BEGIN
		SELECT @DC_Status=DC_Status,@PRODUCTTYPE=PRODUCTTYPE,@BU='CRM' FROM DealerComplainCRM WHERE DC_ID=@DC_Id
	END
	IF @DC_Status='Confirmed'
	BEGIN
		--投诉已确认、请返回投诉产品 系统能够自动推送邮件给申请人
		IF @PRODUCTTYPE='6'
		BEGIN
			--产品类型为机器,状态为投诉已确认、请返回投诉产品
			SET @Content=''
			SET @Mail_Tital=''
			SET @Mail_Body=''
			SET @Mail_Address=''
			
			SET @DC_ComplainNbr=''
			SET @DC_ComplainId=''
			SET @DISTRIBUTORCUSTOMER=''
			SET @DN=''
			SET @UPN=''
			SET @LOT=''
			SET @UserId=NULL;
			SET @Content=''
			
			IF @DC_Type='BSC'
			BEGIN
				SELECT @DC_ComplainNbr=ISNULL(DC_ComplainNbr,''),@DISTRIBUTORCUSTOMER=(SELECT HOS_HospitalName FROM Hospital WHERE HOS_Key_Account=ISNULL(DISTRIBUTORCUSTOMER,'')),@DN=ISNULL(DN,'')
				,@UserId=isnull(DC_CreatedBy,'00000000-0000-0000-0000-000000000000'),@DC_ComplainId=COMPLAINTID ,@INITIALEMAIL=ISNULL(INITIALEMAIL,'') FROM DealerComplain WHERE DC_ID=@DC_Id
			END
			ELSE IF @DC_Type='CRM'
			BEGIN
				SELECT @DC_ComplainNbr=ISNULL(DC_ComplainNbr,''),@DISTRIBUTORCUSTOMER=ISNULL(PhysicianHospital,''),@DN=ISNULL(DN,''),@INITIALEMAIL=''
				,@UserId=isnull(DC_CreatedBy,'00000000-0000-0000-0000-000000000000'),@DC_ComplainId='PI:'+[PI]+';IAN:'+IAN  FROM DealerComplainCRM WHERE DC_ID=@DC_Id
			END
			
			SET @Content+=('<tr><td>'+isnull(@DC_ComplainId,'')+'</td><td>'+isnull(@DISTRIBUTORCUSTOMER,'')+'</td></tr>')
			
			SELECT @Mail_Tital=A.MMT_Subject,@Mail_Body=A.MMT_Body FROM MailMessageTemplate a WHERE A.MMT_Code='EMAIL_DealerComplain_01'
			IF ISNULL(@Mail_Tital,'')<>'' AND ISNULL(@Mail_Body,'')<>''
			BEGIN
				SET @Mail_Tital=REPLACE(@Mail_Tital,'{#OrderNub}',@DC_ComplainNbr);
				SET @Mail_Body=REPLACE(@Mail_Body,'{#EmbeddedContent}',@Content);
				
				SELECT @Mail_Address=ISNULL(ISNULL(A.EMAIL1,A.EMAIL2),'') FROM Lafite_IDENTITY A WHERE A.Id=@UserId;
				IF @Mail_Address<>''
				BEGIN
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@Mail_Address,@Mail_Tital,@Mail_Body,'Waiting',GETDATE(),NULL
				END
				IF @INITIALEMAIL<>''
				BEGIN
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@INITIALEMAIL,@Mail_Tital,@Mail_Body,'Waiting',GETDATE(),NULL
				END
			END
			
		END
		IF @PRODUCTTYPE='25' AND @BU='SH'
		BEGIN
			SET @Content=''
			SET @Mail_Tital=''
			SET @Mail_Body=''
			SET @Mail_Address=''
			
			SET @DC_ComplainNbr=''
			SET @DC_ComplainId=''
			SET @DISTRIBUTORCUSTOMER=''
			SET @DN=''
			SET @UPN=''
			SET @LOT=''
			SET @UserId=NULL;
			SET @Content=''
			
			--如果投诉为“综合”，且BU为“结构性心脏SH”
			IF @DC_Type='BSC'
			BEGIN
				SELECT @DC_ComplainNbr=ISNULL(DC_ComplainNbr,''),@DISTRIBUTORCUSTOMER=(SELECT HOS_HospitalName FROM Hospital WHERE HOS_Key_Account=ISNULL(DISTRIBUTORCUSTOMER,'')),@DN=ISNULL(DN,''),@UPN=ISNULL(UPN,''),@LOT=ISNULL(LOT,''),
				@UserId=isnull(DC_CreatedBy,'00000000-0000-0000-0000-000000000000'),@DC_ComplainId=COMPLAINTID,@INITIALEMAIL=ISNULL(INITIALEMAIL,'')   FROM DealerComplain WHERE DC_ID=@DC_Id
			END
			ELSE IF @DC_Type='CRM'
			BEGIN
				SELECT @DC_ComplainNbr=ISNULL(DC_ComplainNbr,''),@DISTRIBUTORCUSTOMER=ISNULL(PhysicianHospital,''),@DN=ISNULL(DN,''),@UPN='CRM',@LOT=ISNULL(LOT,''),
				@UserId=isnull(DC_CreatedBy,'00000000-0000-0000-0000-000000000000'),@DC_ComplainId='PI:'+[PI]+';IAN:'+IAN,@INITIALEMAIL=''  FROM DealerComplainCRM WHERE DC_ID=@DC_Id
			END
			SET @Content+=('<tr><td>'+@DC_ComplainId+'</td><td>'+@UPN+'</td><td>'+@LOT+'</td><td>'+@DISTRIBUTORCUSTOMER+'</td></tr>')
			
			SELECT @Mail_Tital=A.MMT_Subject,@Mail_Body=A.MMT_Body FROM MailMessageTemplate a WHERE A.MMT_Code='EMAIL_DealerComplain_02'
			IF ISNULL(@Mail_Tital,'')<>'' AND ISNULL(@Mail_Body,'')<>''
			BEGIN
				SET @Mail_Tital=REPLACE(@Mail_Tital,'{#OrderNub}',@DC_ComplainNbr);
				SET @Mail_Body=REPLACE(@Mail_Body,'{#EmbeddedContent}',@Content);
				
				SELECT @Mail_Address=ISNULL(ISNULL(A.EMAIL1,A.EMAIL2),'') FROM Lafite_IDENTITY A WHERE A.Id=@UserId;
				IF @Mail_Address<>''
				BEGIN
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@Mail_Address,@Mail_Tital,@Mail_Body,'Waiting',GETDATE(),NULL
				END
				IF @INITIALEMAIL<>''
				BEGIN
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@INITIALEMAIL,@Mail_Tital,@Mail_Body,'Waiting',GETDATE(),NULL
				END
			END
			
		END
		IF @PRODUCTTYPE='25' AND @BU='Cardio'
		BEGIN
			--如果投诉为“综合”，且BU为“IC”
			SET @Mail_Tital=''
			SET @Mail_Body=''
			SET @Mail_Address=''
			
			SET @DC_ComplainNbr=''
			SET @DISTRIBUTORCUSTOMER=''
			SET @DN=''
			SET @UPN=''
			SET @LOT=''
			SET @UserId=NULL;
			SET @Content=''
			IF @DC_Type='BSC'
			BEGIN
				SELECT @DC_ComplainNbr=ISNULL(DC_ComplainNbr,''),@DISTRIBUTORCUSTOMER=(SELECT HOS_HospitalName FROM Hospital WHERE HOS_Key_Account=ISNULL(DISTRIBUTORCUSTOMER,'')),@DN=ISNULL(DN,''),@UPN=ISNULL(UPN,''),@LOT=ISNULL(LOT,''),
				@UserId=isnull(DC_CreatedBy,'00000000-0000-0000-0000-000000000000'),@DC_ComplainId=COMPLAINTID,@INITIALEMAIL=ISNULL(INITIALEMAIL,'')  FROM DealerComplain WHERE DC_ID=@DC_Id
			END
			ELSE IF @DC_Type='CRM'
			BEGIN
				SELECT @DC_ComplainNbr=ISNULL(DC_ComplainNbr,''),@DISTRIBUTORCUSTOMER=ISNULL(PhysicianHospital,''),@DN=ISNULL(DN,''),@UPN='CRM',@LOT=ISNULL(LOT,''),
				@UserId=isnull(DC_CreatedBy,'00000000-0000-0000-0000-000000000000'),@DC_ComplainId='PI:'+[PI]+';IAN:'+IAN,@INITIALEMAIL=''  FROM DealerComplainCRM WHERE DC_ID=@DC_Id
			END
			
			SET @Content+=('<tr><td>'+@DC_ComplainId+'</td><td>'+@UPN+'</td><td>'+@LOT+'</td><td>'+@DISTRIBUTORCUSTOMER+'</td></tr>')
			
			SELECT @Mail_Tital=A.MMT_Subject,@Mail_Body=A.MMT_Body FROM MailMessageTemplate a WHERE A.MMT_Code='EMAIL_DealerComplain_03'
			IF ISNULL(@Mail_Tital,'')<>'' AND ISNULL(@Mail_Body,'')<>''
			BEGIN
				SET @Mail_Tital=REPLACE(@Mail_Tital,'{#OrderNub}',@DC_ComplainNbr);
				SET @Mail_Body=REPLACE(@Mail_Body,'{#EmbeddedContent}',@Content);
				
				SELECT @Mail_Address=ISNULL(ISNULL(A.EMAIL1,A.EMAIL2),'') FROM Lafite_IDENTITY A WHERE A.Id=@UserId;
				IF @Mail_Address<>''
				BEGIN
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@Mail_Address,@Mail_Tital,@Mail_Body,'Waiting',GETDATE(),NULL
				END
				IF @INITIALEMAIL<>''
				BEGIN
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@INITIALEMAIL,@Mail_Tital,@Mail_Body,'Waiting',GETDATE(),NULL
				END
			END
			
		END
		IF @PRODUCTTYPE='25' AND @BU IN ('EP','Endo','PI','Uro')
		BEGIN
			--如果投诉为“综合”，且BU为“EP, Endo, PI, Uro”
			SET @Mail_Tital=''
			SET @Mail_Body=''
			SET @Mail_Address=''
			
			SET @DC_ComplainNbr=''
			SET @DISTRIBUTORCUSTOMER=''
			SET @DN=''
			SET @UPN=''
			SET @LOT=''
			SET @UserId=NULL;
			SET @Content=''
			
			IF @DC_Type='BSC'
			BEGIN
				SELECT @DC_ComplainNbr=ISNULL(DC_ComplainNbr,''),@DISTRIBUTORCUSTOMER=(SELECT HOS_HospitalName FROM Hospital WHERE HOS_Key_Account=ISNULL(DISTRIBUTORCUSTOMER,'')),@DN=ISNULL(DN,''),@UPN=ISNULL(UPN,''),@LOT=ISNULL(LOT,''),
				@UserId=isnull(DC_CreatedBy,'00000000-0000-0000-0000-000000000000'),@DC_ComplainId=COMPLAINTID,@INITIALEMAIL=ISNULL(INITIALEMAIL,'')   FROM DealerComplain WHERE DC_ID=@DC_Id
			END
			ELSE IF @DC_Type='CRM'
			BEGIN
				SELECT @DC_ComplainNbr=ISNULL(DC_ComplainNbr,''),@DISTRIBUTORCUSTOMER=ISNULL(PhysicianHospital,''),@DN=ISNULL(DN,''),@UPN='CRM',@LOT=ISNULL(LOT,''),
				@UserId=isnull(DC_CreatedBy,'00000000-0000-0000-0000-000000000000'),@DC_ComplainId='PI:'+[PI]+';IAN:'+IAN ,@INITIALEMAIL='' FROM DealerComplainCRM WHERE DC_ID=@DC_Id
			END
			
			SET @Content+=('<tr><td>'+@DC_ComplainId+'</td><td>'+@UPN+'</td><td>'+@LOT+'</td><td>'+@DISTRIBUTORCUSTOMER+'</td></tr>')
			
			SELECT @Mail_Tital=A.MMT_Subject,@Mail_Body=A.MMT_Body FROM MailMessageTemplate a WHERE A.MMT_Code='EMAIL_DealerComplain_04'
			IF ISNULL(@Mail_Tital,'')<>'' AND ISNULL(@Mail_Body,'')<>''
			BEGIN
				SET @Mail_Tital=REPLACE(@Mail_Tital,'{#OrderNub}',@DC_ComplainNbr);
				SET @Mail_Body=REPLACE(@Mail_Body,'{#EmbeddedContent}',@Content);
				
				SELECT @Mail_Address=ISNULL(ISNULL(A.EMAIL1,A.EMAIL2),'') FROM Lafite_IDENTITY A WHERE A.Id=@UserId;
				IF @Mail_Address<>''
				BEGIN
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@Mail_Address,@Mail_Tital,@Mail_Body,'Waiting',GETDATE(),NULL
				END
				IF @INITIALEMAIL<>''
				BEGIN
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@INITIALEMAIL,@Mail_Tital,@Mail_Body,'Waiting',GETDATE(),NULL
				END
			END
		END
	END
	
	IF @DC_Status='Completed'
	BEGIN
		--“波科已退款给平台/T1”后，DMS系统自动推送邮件给T2的同时，也推送给平台
		SET @Mail_Tital=''
		SET @Mail_Body=''
		SET @Mail_Address=''
		
		DECLARE @DealerName nvarchar(100);
		DECLARE @LPDealerId uniqueidentifier;
		IF @DC_Type='BSC'
		BEGIN
			SELECT @DC_ComplainNbr=ISNULL(DC_ComplainNbr,''),@DealerName=B.DMA_ChineseName ,@LPDealerId=b.DMA_Parent_DMA_ID
			,@UserId=isnull(DC_CreatedBy,'00000000-0000-0000-0000-000000000000')
			FROM DealerComplain A INNER JOIN DealerMaster B ON A.DC_CorpId=B.DMA_ID WHERE DC_ID=@DC_Id
		END
		ELSE IF @DC_Type='CRM'
		BEGIN
			SELECT @DC_ComplainNbr=ISNULL(DC_ComplainNbr,''),@DealerName=B.DMA_ChineseName ,@LPDealerId=b.DMA_Parent_DMA_ID
			,@UserId=isnull(DC_CreatedBy,'00000000-0000-0000-0000-000000000000')
			FROM DealerComplainCRM A INNER JOIN DealerMaster B ON A.DC_CorpId=B.DMA_ID WHERE DC_ID=@DC_Id
		END
		--SET @Content+=('<tr><td>'+@DC_ComplainNbr+'</td><td>'+@DN+'</td><td>'+@UPN+'</td><td>'+@LOT+'</td><td>'+@DISTRIBUTORCUSTOMER+'</td></tr>')
		
		SELECT @Mail_Tital=A.MMT_Subject,@Mail_Body=A.MMT_Body FROM MailMessageTemplate a WHERE A.MMT_Code='EMAIL_QACOMPLAIN_PAYMENT'
		IF ISNULL(@Mail_Tital,'')<>'' AND ISNULL(@Mail_Body,'')<>''
		BEGIN
			SET @Mail_Body=REPLACE(REPLACE(@Mail_Body,'{#UploadNo}',@DC_ComplainNbr),'{#DealerName}',@DealerName);
			
			SELECT @Mail_Address=ISNULL(ISNULL(A.EMAIL1,A.EMAIL2),'') FROM Lafite_IDENTITY A WHERE A.Id=@UserId;
			IF @Mail_Address<>''
			BEGIN
				--发邮件给经销商
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',@Mail_Address,@Mail_Tital,@Mail_Body,'Waiting',GETDATE(),NULL
			END
			--发邮件给平台
			INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
			SELECT NEWID(),'email','',MDA_MailAddress,@Mail_Tital,@Mail_Body,'Waiting',GETDATE(),NULL
			FROM MailDeliveryAddress 
			INNER JOIN Client ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID AND Client.CLT_Corp_Id=@LPDealerId
			WHERE MDA_MailType='QAComplainBSC' 
		END
	END
	
	

GO