DROP Procedure [dbo].[GC_MailRemind]
GO


CREATE Procedure [dbo].[GC_MailRemind]
AS
BEGIN
	-------------------------------------------------------
	--1. ��������¶���ʼ�֪ͨ
	-------------------------------------------------------
	DECLARE @ID UNIQUEIDENTIFIER;
	DECLARE @strMassage NVARCHAR(max);
	DECLARE @strSubject NVARCHAR(max);
	DECLARE @strBody NVARCHAR(max);
	--1.1 T1�ʼ�֪ͨCO
	SET @strSubject='��������¶����֪ͨ';
	SELECT 
	@strMassage=STUFF(REPLACE(REPLACE((
		SELECT DISTINCT B.DMA_ChineseName +'('+B.DMA_SAP_Code+')' RESULT
		FROM ThirdPartyDisclosure A 
		INNER JOIN DealerMaster B ON A.TPD_DMA_ID=B.DMA_ID
		WHERE A.TPD_ApprovalStatus='������' AND TPD_Status=1 AND B.DMA_DealerType='T1'
					FOR XML AUTO
				), '<A RESULT="', ','), '"/>', ''), 1, 1, '')
	IF ISNULL(@strMassage,'')<>''
	BEGIN
		SET @strBody='���ã�����δ�����ĵ�������˾��¶���룺<br/>'
		+@strMassage+'<br/>�����½DMSϵͳ������Ӧ����<br/> ���ӣ�https://bscdealer.cn <br/><br/>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл';

		INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		SELECT NEWID(),'email','',MDA_MailAddress,@strSubject,@strBody,'Winting',GETDATE(),NULL FROM MailDeliveryAddress A WHERE A.MDA_ActiveFlag=1 AND A.MDA_MailType='DCMS' AND MDA_MailTo='CO'
	END

	--1.2 T2�ʼ�֪ͨƽ̨
	SET @strMassage='';
	SET @strBody='';
	SELECT 
	@strMassage=STUFF(REPLACE(REPLACE((
		SELECT DISTINCT B.DMA_ChineseName +'('+B.DMA_SAP_Code+')' RESULT
		FROM ThirdPartyDisclosure A 
		INNER JOIN DealerMaster B ON A.TPD_DMA_ID=B.DMA_ID
		WHERE A.TPD_ApprovalStatus='������' AND TPD_Status=1 AND B.DMA_DealerType='T2' AND B.DMA_Parent_DMA_ID IN ('84C83F71-93B4-4EFD-AB51-12354AFABAC3','A54ADD15-CB13-4850-9848-6DA4576207CB')
					FOR XML AUTO
				), '<A RESULT="', ','), '"/>', ''), 1, 1, '')

	IF ISNULL(@strMassage,'')<>''
	BEGIN
		SET @strBody='���ã�����δ�����ĵ�������˾��¶���룺<br/>'
		+@strMassage+'<br/>�����½DMSϵͳ������Ӧ����<br/> ���ӣ�https://bscdealer.cn <br/><br/>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл';

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
		WHERE A.TPD_ApprovalStatus='������' AND TPD_Status=1 AND B.DMA_DealerType='T2' AND B.DMA_Parent_DMA_ID IN ('A00FCD75-951D-4D91-8F24-A29900DA5E85','33029AF0-CFCF-495E-B057-550D16C41E4A')
					FOR XML AUTO
				), '<A RESULT="', ','), '"/>', ''), 1, 1, '')

	IF ISNULL(@strMassage,'')<>''
	BEGIN
		SET @strBody='���ã�����δ�����ĵ�������˾��¶���룺<br/>'
		+@strMassage+'<br/>�����½DMSϵͳ������Ӧ����<br/> ���ӣ�https://bscdealer.cn <br/><br/>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл';

		INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		SELECT NEWID(),'email','','jlli@fc-medical.cn',@strSubject,@strBody,'Winting',GETDATE(),NULL
	END


END




GO


