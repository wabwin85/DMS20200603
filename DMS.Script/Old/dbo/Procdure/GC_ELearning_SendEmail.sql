DROP Procedure [dbo].[GC_ELearning_SendEmail]
GO


/*
邮件提醒功能
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
		SET @MailSubject='经销商ELearning培训通知'
		IF @DealerType='T2' AND NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE  a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='已通过' AND TestName='代理商质量培训考试')
		BEGIN
			SET @MailBody='尊敬的经销商同事您好，<br/> 您今年的续约合同已经被申请，请及时进入经销商管理系统（DMS）完成“第三方合规知识培训”，若合同审批完，您还未完成培训，贵公司合同不能生效！ <br>备注：请尽量使用谷歌浏览器参加培训<br><br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
		END
		ELSE IF NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='已通过' AND TestName='第三方合规知识培训-测试试题')
		OR NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE  a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='已通过' AND TestName='代理商质量培训考试')
		BEGIN
			SET @MailBody='尊敬的经销商同事您好，<br/> 您今年的续约合同已经被申请，请及时进入经销商管理系统（DMS）完成“第三方合规知识培训”与“代理商质量培训考试”，若合同审批完，您还未完成培训，贵公司合同不能生效！<br>备注：请尽量使用谷歌浏览器参加培训<br><br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
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
		SET @MailSubject='经销商ELearning培训通知'
		IF @DealerType='T2' AND NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE  a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='已通过' AND TestName='代理商质量培训考试')
		BEGIN
			SET @MailBody='尊敬的经销商同事您好，<br/> 您今年的续约合同已经被申请，请及时进入经销商管理系统（DMS）完成“第三方合规知识培训”，若合同审批完，您还未完成培训，贵公司合同不能生效！<br>备注：请尽量使用谷歌浏览器参加培训<br<br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
		END
		ELSE IF NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='已通过' AND TestName='第三方合规知识培训-测试试题')
		OR NOT EXISTS (SELECT 1 FROM  interface.T_I_MDM_DeaelrTraining a WHERE  a.DealerId=@DealerId AND CONVERT(NVARCHAR(10),TestDate,120)>=DATEADD(DD,-60,GETDATE()) AND A.TestStatus='已通过' AND TestName='代理商质量培训考试')
		BEGIN
			SET @MailBody='尊敬的经销商同事您好，<br/> 您今年的续约合同已经被申请，请及时进入经销商管理系统（DMS）完成“第三方合规知识培训”与“代理商质量培训考试”，若合同审批完，您还未完成培训，贵公司合同不能生效！<br>备注：请尽量使用谷歌浏览器参加培训<br<br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
		END
		
		IF ISNULL(@MailBody,'')<>''
		BEGIN
			INSERT INTO MailMessageQueue (MMQ_ID,	MMQ_QueueNo,	MMQ_From,	MMQ_To,	MMQ_Subject,	MMQ_Body,	MMQ_Status,	MMQ_CreateDate,	MMQ_SendDate)
			VALUES(NEWID(),'email','',@MailAddress,@MailSubject,@MailBody,'Waiting',GETDATE(),NULL)
			
		END
	END
END



GO


