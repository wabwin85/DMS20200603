DROP Procedure [dbo].[DCMSAnnexNoticeMailSend]
GO


/*
附件上传后发送通知邮件
*/
CREATE Procedure [dbo].[DCMSAnnexNoticeMailSend]
	@Type	NVARCHAR(20) ,
	@ContractId	NVARCHAR(36) ,
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(MAX) OUTPUT
AS
	CREATE TABLE #tbContract
	(
		 ContractId uniqueidentifier,
		 ContractType NVARCHAR(500),
		 DealerId uniqueidentifier ,
		 ProductLineId uniqueidentifier,
		 MarketType NVARCHAR(10),
		 ContractState NVARCHAR(100)
	)
	DECLARE @DealerId uniqueidentifier;
	DECLARE @DealerName NVARCHAR(200);
	DECLARE @ProductLineId uniqueidentifier;
	DECLARE @ProductLineName NVARCHAR(200);
	DECLARE @MarketType NVARCHAR(10);
	
	DECLARE @DealerAccount NVARCHAR(20);
	
	DECLARE @MailTital NVARCHAR(500);
	DECLARE @MailBody NVARCHAR(1000);
	DECLARE @MailAddress NVARCHAR(1000);
	
	DECLARE @MailTitalLP NVARCHAR(500);
	DECLARE @MailBodyLP NVARCHAR(1000);
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	--整合合同数据
	INSERT INTO #tbContract
	SELECT CAP_ID,ContractType,CAP_DMA_ID,DP.ProductLineID,CAP_MarketType,CAP_Status FROM (
	SELECT CAP_ID,'Appointment' ContractType ,CAP_DMA_ID,CAP_Division,ISNULL(CAP_MarketType,0) CAP_MarketType,CAP_Status FROM ContractAppointment
	UNION
	SELECT CAM_ID,'Amendment',CAM_DMA_ID,CAM_Division,ISNULL(CAM_MarketType,0),CAM_Status FROM ContractAmendment
	UNION
	SELECT CRE_ID,'Renewal',CRE_DMA_ID,CRE_Division,ISNULL(CRE_MarketType,0),CRE_Status FROM ContractRenewal) TAB
	LEFT JOIN V_DivisionProductLineRelation DP ON DP.DivisionName=TAB.CAP_Division AND DP.IsEmerging='0'
	
	SELECT @DealerId=a.DealerId,@DealerName=B.DMA_ChineseName,@ProductLineId=C.ProductLineID,@ProductLineName=c.ProductLineName,@MarketType=A.MarketType ,@MailAddress=b.DMA_Email
	FROM #tbContract A 
	LEFT JOIN DealerMaster B ON A.DealerId=B.DMA_ID 
	LEFT JOIN V_DivisionProductLineRelation C ON A.ProductLineId=C.ProductLineID AND C.IsEmerging='0'
	WHERE A.ContractId=@ContractId
	
	IF @Type='Agreement'
	BEGIN
		SET @MailTital=NULL SET @MailBody=NULL ;
		--Notice Dealer
		IF( ISNULL(@MailAddress,'')<>'' )
		BEGIN
			SELECT @MailTital=MMT_Subject,	@MailBody=MMT_Body FROM MailMessageTemplate  WHERE MMT_Code='EMAL_DCMS_DealerAgreement_Dealer'
			SET @MailBody=REPLACE(@MailBody,'{#ProductName}',ISNULL(@ProductLineName,''))
			INSERT INTO MailMessageQueue (MMQ_ID,	MMQ_QueueNo,	MMQ_From,	MMQ_To,	MMQ_Subject,	MMQ_Body,	MMQ_Status,	MMQ_CreateDate,	MMQ_SendDate)
			VALUES(NEWID(),'email','',@MailAddress,@MailTital,@MailBody,'Waiting',GETDATE(),NULL)
		END
		
		SET @MailTital=NULL SET @MailBody=NULL ;
		SELECT @MailTital=MMT_Subject,	@MailBody=MMT_Body FROM MailMessageTemplate  WHERE MMT_Code='EMAL_DCMS_DealerAgreement_BSC'
		SET @MailBody=REPLACE(REPLACE(@MailBody,'{#ProductName}',ISNULL(@ProductLineName,'0')),'{#DealerName}',ISNULL(@DealerName,''))
		--Notice NCM
		IF @MarketType='1'
		BEGIN
			INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
			SELECT NEWID(),'email','',MDA_MailAddress,@MailTital,@MailBody,'Waiting',GETDATE(),NULL 
			FROM MailDeliveryAddress 
			WHERE MDA_MailType='DCMS_BSC' AND	MDA_MailTo='MAK1' AND MDA_ProductLineID=@ProductLineId
		END
		ELSE IF @MarketType='0'
		BEGIN
			INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
			SELECT NEWID(),'email','',MDA_MailAddress,@MailTital,@MailBody,'Waiting',GETDATE(),NULL 
			FROM MailDeliveryAddress 
			WHERE MDA_MailType='DCMS_BSC' AND	MDA_MailTo='MAK0' AND MDA_ProductLineID=@ProductLineId
		END
		
		--Notice CO
		INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		SELECT NEWID(),'email','',MDA_MailAddress,@MailTital,@MailBody,'Waiting',GETDATE(),NULL 
		FROM MailDeliveryAddress 
		WHERE MDA_MailType='DCMS_BSC' AND	MDA_MailTo='CO' AND MDA_ProductLineID=@ProductLineId
			
		--Notice Eric
		--
	END
	IF @Type='Supplementary'
	BEGIN
		SET @MailTital=NULL SET @MailBody=NULL ;
		
		DECLARE @AmendmentDate DATETIME;
		SELECT @MailTital=MMT_Subject,	@MailBody=MMT_Body FROM MailMessageTemplate  WHERE MMT_Code='EMAL_DCMS_SupplementaryLetter_BSC'
		SELECT @AmendmentDate=CAM_Amendment_EffectiveDate FROM ContractAmendment WHERE CAM_ID=@ContractId;
		
		SET @MailBody=REPLACE(REPLACE(REPLACE(@MailBody,'{#ProductName}',ISNULL(@ProductLineName,'')),'{#DealerName}',ISNULL(@DealerName,'')),'{#AmendmentDate}',CONVERT(NVARCHAR(10), ISNULL(@AmendmentDate,'1990-01-01'),120))
		
		--Notice NCM
		IF @MarketType='1'
		BEGIN
			INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
			SELECT NEWID(),'email','',MDA_MailAddress,@MailTital,@MailBody,'Waiting',GETDATE(),NULL 
			FROM MailDeliveryAddress 
			WHERE MDA_MailType='DCMS_BSC' AND	MDA_MailTo='MAK1' AND MDA_ProductLineID=@ProductLineId
		END
		ELSE IF @MarketType='0'
		BEGIN
			INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
			SELECT NEWID(),'email','',MDA_MailAddress,@MailTital,@MailBody,'Waiting',GETDATE(),NULL 
			FROM MailDeliveryAddress 
			WHERE MDA_MailType='DCMS_BSC' AND	MDA_MailTo='MAK0' AND MDA_ProductLineID=@ProductLineId
		END
		
		--Notice CO
		INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		SELECT NEWID(),'email','',MDA_MailAddress,@MailTital,@MailBody,'Waiting',GETDATE(),NULL 
		FROM MailDeliveryAddress 
		WHERE MDA_MailType='DCMS_BSC' AND	MDA_MailTo='CO' AND MDA_ProductLineID=@ProductLineId
			
		--Notice Eric
		--
	END
	
	/* Sarah 2016-9-21 邮件通知不发账号信息到平台和经销商*/
	IF @Type='AppointmentT2'
	BEGIN
		SET @MailTital=NULL SET @MailBody=NULL ;
		SELECT @MailTital=MMT_Subject,	@MailBody=MMT_Body FROM MailMessageTemplate  WHERE MMT_Code='EMAL_DCMS_NewDealerContract_Dealer'
		SELECT @DealerAccount=DM.DMA_SAP_Code FROM DealerMaster DM WHERE DM.DMA_ID=@DealerId;
		IF ISNULL(@DealerAccount,'')<>''
		BEGIN
			SET @DealerAccount=@DealerAccount+'_01';
		END
		
		SET @MailBody=REPLACE(REPLACE(@MailBody,'{#DealerAccount}',@DealerAccount),'{#DealerName}',ISNULL(@DealerName,''))
		IF ISNULL(@MailAddress,'')<>''
		BEGIN
			INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
			VALUES(NEWID(),'email','',@MailAddress,@MailTital,@MailBody,'Waiting',GETDATE(),NULL)
		END
		
		--发给二级经销商的邮件同事发给平台
		SELECT @MailTitalLP=MMT_Subject,	@MailBodyLP=MMT_Body FROM MailMessageTemplate  WHERE MMT_Code='EMAL_DCMS_NewDealerContract_LP'
		SET @MailBodyLP=REPLACE(REPLACE(REPLACE(@MailBodyLP,'{#DealerAccount}',@DealerAccount),'{#DealerName}',ISNULL(@DealerName,'')),'{#ProductName}',@ProductLineName)
		INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		SELECT NEWID(),'email','' ,A.MDA_MailAddress,@MailTitalLP,@MailBodyLP,'Waiting',GETDATE(),NULL
		FROM MailDeliveryAddress  A
		INNER JOIN Client ON A.MDA_MailTo=Client.CLT_ID
		INNER JOIN DealerMaster B ON B.DMA_Parent_DMA_ID=Client.CLT_Corp_Id 
		AND B.DMA_ID=@DealerId
		WHERE MDA_MailType='DCMS_BSC'
		AND MDA_ProductLineID =@ProductLineId;
		
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


