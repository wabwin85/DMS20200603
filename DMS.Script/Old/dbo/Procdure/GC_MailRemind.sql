DROP Procedure [dbo].[GC_MailRemind]
GO


CREATE Procedure [dbo].[GC_MailRemind]
AS
BEGIN
	-------------------------------------------------------
	--1. 第三方披露表邮件通知
	-------------------------------------------------------
	DECLARE @ID UNIQUEIDENTIFIER;
	DECLARE @strMassage NVARCHAR(max);
	DECLARE @strSubject NVARCHAR(max);
	DECLARE @strBody NVARCHAR(max);
	--1.1 T1邮件通知CO
	SET @strSubject='第三方披露审批通知';
	SELECT 
	@strMassage=STUFF(REPLACE(REPLACE((
		SELECT DISTINCT B.DMA_ChineseName +'('+B.DMA_SAP_Code+')' RESULT
		FROM ThirdPartyDisclosure A 
		INNER JOIN DealerMaster B ON A.TPD_DMA_ID=B.DMA_ID
		WHERE A.TPD_ApprovalStatus='待审批' AND TPD_Status=1 AND B.DMA_DealerType='T1'
					FOR XML AUTO
				), '<A RESULT="', ','), '"/>', ''), 1, 1, '')
	IF ISNULL(@strMassage,'')<>''
	BEGIN
		SET @strBody='您好，您有未操作的第三方公司披露申请：<br/>'
		+@strMassage+'<br/>，请登陆DMS系统进行相应审批<br/> 链接：https://bscdealer.cn <br/><br/>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢';

		INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		SELECT NEWID(),'email','',MDA_MailAddress,@strSubject,@strBody,'Winting',GETDATE(),NULL FROM MailDeliveryAddress A WHERE A.MDA_ActiveFlag=1 AND A.MDA_MailType='DCMS' AND MDA_MailTo='CO'
	END

	--1.2 T2邮件通知平台
	SET @strMassage='';
	SET @strBody='';
	SELECT 
	@strMassage=STUFF(REPLACE(REPLACE((
		SELECT DISTINCT B.DMA_ChineseName +'('+B.DMA_SAP_Code+')' RESULT
		FROM ThirdPartyDisclosure A 
		INNER JOIN DealerMaster B ON A.TPD_DMA_ID=B.DMA_ID
		WHERE A.TPD_ApprovalStatus='待审批' AND TPD_Status=1 AND B.DMA_DealerType='T2' AND B.DMA_Parent_DMA_ID IN ('84C83F71-93B4-4EFD-AB51-12354AFABAC3','A54ADD15-CB13-4850-9848-6DA4576207CB')
					FOR XML AUTO
				), '<A RESULT="', ','), '"/>', ''), 1, 1, '')

	IF ISNULL(@strMassage,'')<>''
	BEGIN
		SET @strBody='您好，您有未操作的第三方公司披露申请：<br/>'
		+@strMassage+'<br/>，请登陆DMS系统进行相应审批<br/> 链接：https://bscdealer.cn <br/><br/>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢';

		INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		SELECT NEWID(),'email','','yhliu@heng-tai.com.cn',@strSubject,@strBody,'Winting',GETDATE(),NULL 
	END


	SET @strMassage='';
	SET @strBody='';
	SELECT 
	@strMassage=STUFF(REPLACE(REPLACE((
		SELECT DISTINCT B.DMA_ChineseName +'('+B.DMA_SAP_Code+')' RESULT
		FROM ThirdPartyDisclosure A 
		INNER JOIN DealerMaster B ON A.TPD_DMA_ID=B.DMA_ID
		WHERE A.TPD_ApprovalStatus='待审批' AND TPD_Status=1 AND B.DMA_DealerType='T2' AND B.DMA_Parent_DMA_ID IN ('A00FCD75-951D-4D91-8F24-A29900DA5E85','33029AF0-CFCF-495E-B057-550D16C41E4A')
					FOR XML AUTO
				), '<A RESULT="', ','), '"/>', ''), 1, 1, '')

	IF ISNULL(@strMassage,'')<>''
	BEGIN
		SET @strBody='您好，您有未操作的第三方公司披露申请：<br/>'
		+@strMassage+'<br/>，请登陆DMS系统进行相应审批<br/> 链接：https://bscdealer.cn <br/><br/>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢';

		INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		SELECT NEWID(),'email','','jlli@fc-medical.cn',@strSubject,@strBody,'Winting',GETDATE(),NULL
	END


END




GO


