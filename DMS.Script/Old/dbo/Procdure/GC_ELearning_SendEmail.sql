DROP Procedure [dbo].[GC_ELearning_SendEmail]
GO


/*
�ʼ����ѹ���
*/
CREATE Procedure [dbo].[GC_ELearning_SendEmail]
    @ContractId NVARCHAR(36),
    @ContractType NVARCHAR(50)
AS

DECLARE @MailSubject NVARCHAR(200)
DECLARE @MailBody NVARCHAR(Max)
DECLARE @MailAddress NVARCHAR(500)
DECLARE @DealerType NVARCHAR(50)
DECLARE @DealerId uniqueidentifier

IF @ContractType='Renewal'
BEGIN
	SELECT @MailAddress=ISNULL(ISNULL(B.DMA_Email,DMA_BusinessEMail1),''),@DealerType=b.DMA_DealerType,@DealerId=b.DMA_ID FROM Contract.RenewalMain A INNER JOIN DealerMaster B ON A.CompanyID=b.DMA_ID WHERE A.ContractId=@ContractId
	
	IF @MailAddress<>'' 
	BEGIN
		SET @MailSubject='������ELearning��ѵ֪ͨ'
		IF @DealerType='T2' AND NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE  a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='��ͨ��' AND TestName='������������ѵ����')
		BEGIN
			SET @MailBody='�𾴵ľ�����ͬ�����ã�<br/> ���������Լ��ͬ�Ѿ������룬�뼰ʱ���뾭���̹���ϵͳ��DMS����ɡ��������Ϲ�֪ʶ��ѵ��������ͬ�����꣬����δ�����ѵ����˾��ͬ������Ч�� <br>��ע���뾡��ʹ�ùȸ�������μ���ѵ<br><br>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'
		END
		ELSE IF NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='��ͨ��' AND TestName='�������Ϲ�֪ʶ��ѵ-��������')
		OR NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE  a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='��ͨ��' AND TestName='������������ѵ����')
		BEGIN
			SET @MailBody='�𾴵ľ�����ͬ�����ã�<br/> ���������Լ��ͬ�Ѿ������룬�뼰ʱ���뾭���̹���ϵͳ��DMS����ɡ��������Ϲ�֪ʶ��ѵ���롰������������ѵ���ԡ�������ͬ�����꣬����δ�����ѵ����˾��ͬ������Ч��<br>��ע���뾡��ʹ�ùȸ�������μ���ѵ<br><br>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'
		END
		
		IF ISNULL(@MailBody,'')<>''
		BEGIN
			INSERT INTO MailMessageQueue (MMQ_ID,	MMQ_QueueNo,	MMQ_From,	MMQ_To,	MMQ_Subject,	MMQ_Body,	MMQ_Status,	MMQ_CreateDate,	MMQ_SendDate)
			VALUES(NEWID(),'email','',@MailAddress,@MailSubject,@MailBody,'Waiting',GETDATE(),NULL)
		END
	END
END
IF @ContractType='Appointment'
BEGIN
	SELECT @DealerId=CompanyID,@MailAddress=EMail,@DealerType=DealerType FROM Contract.AppointmentMain a inner join Contract.AppointmentCandidate b ON A.ContractId=B.ContractId
	IF @MailAddress<>'' 
	BEGIN
		SET @MailSubject='������ELearning��ѵ֪ͨ'
		IF @DealerType='T2' AND NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE  a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='��ͨ��' AND TestName='������������ѵ����')
		BEGIN
			SET @MailBody='�𾴵ľ�����ͬ�����ã�<br/> ���������Լ��ͬ�Ѿ������룬�뼰ʱ���뾭���̹���ϵͳ��DMS����ɡ��������Ϲ�֪ʶ��ѵ��������ͬ�����꣬����δ�����ѵ����˾��ͬ������Ч��<br>��ע���뾡��ʹ�ùȸ�������μ���ѵ<br<br>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'
		END
		ELSE IF NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='��ͨ��' AND TestName='�������Ϲ�֪ʶ��ѵ-��������')
		OR NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE  a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='��ͨ��' AND TestName='������������ѵ����')
		BEGIN
			SET @MailBody='�𾴵ľ�����ͬ�����ã�<br/> ���������Լ��ͬ�Ѿ������룬�뼰ʱ���뾭���̹���ϵͳ��DMS����ɡ��������Ϲ�֪ʶ��ѵ���롰������������ѵ���ԡ�������ͬ�����꣬����δ�����ѵ����˾��ͬ������Ч��<br>��ע���뾡��ʹ�ùȸ�������μ���ѵ<br<br>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'
		END
		
		IF ISNULL(@MailBody,'')<>''
		BEGIN
			INSERT INTO MailMessageQueue (MMQ_ID,	MMQ_QueueNo,	MMQ_From,	MMQ_To,	MMQ_Subject,	MMQ_Body,	MMQ_Status,	MMQ_CreateDate,	MMQ_SendDate)
			VALUES(NEWID(),'email','',@MailAddress,@MailSubject,@MailBody,'Waiting',GETDATE(),NULL)
			
		END
	END
END



GO


