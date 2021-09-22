SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

/*
邮件提醒功能
*/
ALTER PROCEDURE [dbo].[GC_ELearning_SendEmail]
    @ContractId NVARCHAR(36),
    @ContractType NVARCHAR(50)
AS
DECLARE @MailSubject NVARCHAR(200);
DECLARE @MailBody NVARCHAR(MAX);
DECLARE @MailAddress NVARCHAR(500);
DECLARE @DealerType NVARCHAR(50);
DECLARE @DealerId UNIQUEIDENTIFIER;
DECLARE @DealerSAPCode NVARCHAR(50);
DECLARE @MailWjLine NVARCHAR(200);

IF @ContractType = 'Renewal'
BEGIN
    SELECT @DealerSAPCode = DMA_SAP_Code,
           @MailAddress = ISNULL(ISNULL(B.DMA_Email, DMA_BusinessEMail1), ''),
           @DealerType = B.DMA_DealerType,
           @DealerId = B.DMA_ID
    FROM Contract.RenewalMain A
        INNER JOIN DealerMaster B
            ON A.CompanyID = B.DMA_ID
    WHERE A.ContractId = @ContractId;
    --SET @MailWjLine
    --    = '<a target=''_blank'' href=''http://wechat.bostonscientific.cn/QN/QuestionnaireInfo/Default?t=1&sapid='
    --      + CONVERT(NVARCHAR(10), @DealerSAPCode) + '''>问卷调研</a>';
    SET @MailWjLine = '';

    IF @MailAddress <> ''
    BEGIN
        SET @MailSubject = '蓝威经销商通知 - 培训和调研';
        IF dbo.FN_Contract_IsPassTraining(@DealerId,@DealerType)=0
        BEGIN
            --SET @MailBody='尊敬的经销商同事您好，<br/> 您今年的续约合同已经被申请，请及时进入经销商管理系统（DMS）完成：<br/><br/>1. 第三方合规知识培训 <br/>2. 渠道管理规则培训考试 <br/>3. 经销商调研问卷：需要由<font color="#FF0000"><b>业务负责人</b></font>，点击以下链接，进入页面进行填写。<br/>'+@MailWjLine+'&nbsp;&nbsp;（问卷支持手机端填写，可以直接手机打开，或复制此链接转发至手机）<br/><br/>若合同审批完，您还未完成培训和调研，贵公司合同不能生效！ <br/><br/>备注：请尽量使用谷歌浏览器参加培训<br><br>蓝威DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
            SET @MailBody
                = '尊敬的经销商同事您好，<br/> 贵司新经销商合同已经被申请，请及时进入经销商管理系统（DMS）完成：<br/><br/>1. 合规培训 <br/>2. 质量培训<br/>3. 问卷调查。<br/><br/>若合同审批完，您还未完成培训和调研，贵公司合同不能生效！ <br/><br/>备注：请尽量使用谷歌浏览器参加培训<br><br>蓝威DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！';
        END;

        IF ISNULL(@MailBody, '') <> ''
        BEGIN
            INSERT INTO MailMessageQueue
            (
                MMQ_ID,
                MMQ_QueueNo,
                MMQ_From,
                MMQ_To,
                MMQ_Subject,
                MMQ_Body,
                MMQ_Status,
                MMQ_CreateDate,
                MMQ_SendDate
            )
            VALUES
            (NEWID(), 'email', '', @MailAddress, @MailSubject, @MailBody, 'Waiting', GETDATE(), NULL);
        END;
    END;
END;
IF @ContractType = 'Appointment'
BEGIN
    SELECT @DealerId = CompanyID,
           @MailAddress = EMail,
           @DealerType = DealerType
    FROM Contract.AppointmentMain a
        INNER JOIN Contract.AppointmentCandidate b
            ON a.ContractId = b.ContractId;

    SELECT @DealerSAPCode = A.DMA_SAP_Code
    FROM DealerMaster A
    WHERE A.DMA_ID = @DealerId;
    --SET @MailWjLine
    --    = '<a target=''_blank'' href=''http://wechat.bostonscientific.cn/QN/QuestionnaireInfo/Default?t=1&sapid='
    --      + CONVERT(NVARCHAR(10), @DealerSAPCode) + '''>问卷调研</a>';
    SET @MailWjLine = '';

    IF @MailAddress <> ''
    BEGIN
        SET @MailSubject = '蓝威经销商通知 - 培训和调研';
        IF dbo.FN_Contract_IsPassTraining(@DealerId,@DealerType)=0
        BEGIN
            --SET @MailBody
            --    = '尊敬的经销商同事您好，<br/> 贵司新经销商合同已经被申请，请及时进入经销商管理系统（DMS）完成：<br/><br/>1. 第三方合规知识培训 <br/>2. 渠道管理规则培训考试<br/>3. 经销商调研问卷：需要由<font color="#FF0000"><b>业务负责人</b></font>，点击以下链接，进入页面进行填写。<br/>'
            --      + @MailWjLine
            --      + '&nbsp;&nbsp;（问卷支持手机端填写，可以直接手机打开，或复制此链接转发至手机）<br/><br/>若合同审批完，您还未完成培训和调研，贵公司合同不能生效！ <br/><br/>备注：请尽量使用谷歌浏览器参加培训<br><br>蓝威DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！';
            SET @MailBody
                = '尊敬的经销商同事您好，<br/> 贵司新经销商合同已经被申请，请及时进入经销商管理系统（DMS）完成：<br/><br/>1. 合规培训 <br/>2. 质量培训<br/>3. 问卷调查。<br/><br/>若合同审批完，您还未完成培训和调研，贵公司合同不能生效！ <br/><br/>备注：请尽量使用谷歌浏览器参加培训<br><br>蓝威DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！';
        END;

        IF ISNULL(@MailBody, '') <> ''
        BEGIN
            INSERT INTO MailMessageQueue
            (
                MMQ_ID,
                MMQ_QueueNo,
                MMQ_From,
                MMQ_To,
                MMQ_Subject,
                MMQ_Body,
                MMQ_Status,
                MMQ_CreateDate,
                MMQ_SendDate
            )
            VALUES
            (NEWID(), 'email', '', @MailAddress, @MailSubject, @MailBody, 'Waiting', GETDATE(), NULL);

        END;
    END;
END;






GO

