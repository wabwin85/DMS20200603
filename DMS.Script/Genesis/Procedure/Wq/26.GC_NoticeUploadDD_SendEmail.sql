
/****** Object:  StoredProcedure [dbo].[GC_NoticeUploadDD_SendEmail]    Script Date: 2019/11/26 17:09:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
邮件提醒功能
*/
ALTER PROCEDURE [dbo].[GC_NoticeUploadDD_SendEmail]
    @ContractId NVARCHAR(36),
    @ContractType NVARCHAR(50)
AS
DECLARE @MailSubject NVARCHAR(200);
DECLARE @MailBody NVARCHAR(MAX);
DECLARE @MailAddress NVARCHAR(500);
DECLARE @DealerType NVARCHAR(50);
DECLARE @DealerId UNIQUEIDENTIFIER;
DECLARE @DealerSAPCode NVARCHAR(50);
DECLARE @DealerName NVARCHAR(200);
DECLARE @DDEndDate DateTime;
--SELECT @MailAddress = EMAIL1+';' 
--	FROM Lafite_IDENTITY lid
--	INNER JOIN Lafite_IDENTITY_MAP lim ON lid.Id=lim.IDENTITY_ID
--	INNER JOIN lafite_attribute lab ON lim.MAP_ID = lab.ID
--	WHERE lab.attribute_name='第三方账号' and lab.attribute_type='Role'

IF @ContractType = 'Renewal'
BEGIN
    SELECT @DealerSAPCode = DMA_SAP_Code,
           @DealerName = B.DMA_ChineseName,
           @DealerType = B.DMA_DealerType,
           @DealerId = B.DMA_ID
    FROM Contract.RenewalMain A
        INNER JOIN DealerMaster B
            ON A.CompanyID = B.DMA_ID
    WHERE A.ContractId = @ContractId;

	SELECT TOP 1 @DDEndDate=DMDD_EndDate FROM DealerMasterDD WHERE DMDD_DealerID=@DealerId ORDER BY DMDD_UpdateDate DESC

    IF @MailAddress <> '' AND @MailAddress <> ';'
    BEGIN
        SET @MailSubject = '蓝威经销商背调通知 - ' + @DealerName;
		--最新的背调的过期时间>=当前时间+13个月 发送邮件
        IF @DDEndDate IS NULL OR dateadd(m,13,GetDate())>@DDEndDate
        BEGIN
            --SET @MailBody='尊敬的经销商同事您好，<br/> 您今年的续约合同已经被申请，请及时进入经销商管理系统（DMS）完成：<br/><br/>1. 第三方合规知识培训 <br/>2. 渠道管理规则培训考试 <br/>3. 经销商调研问卷：需要由<font color="#FF0000"><b>业务负责人</b></font>，点击以下链接，进入页面进行填写。<br/>'+@MailWjLine+'&nbsp;&nbsp;（问卷支持手机端填写，可以直接手机打开，或复制此链接转发至手机）<br/><br/>若合同审批完，您还未完成培训和调研，贵公司合同不能生效！ <br/><br/>备注：请尽量使用谷歌浏览器参加培训<br><br>蓝威DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
            SET @MailBody
                = '尊敬的用户您好，<br/> 经销商合同续约申请总经理审批已通过，请及时开展背景调查，并进入经销商管理系统（DMS）完成背调报告上传！ <br/><br/>备注：请尽量使用谷歌浏览器<br><br>蓝威DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！';
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
            SELECT NEWID(), 'email', '', EMAIL1, @MailSubject, @MailBody, 'Waiting', GETDATE(), NULL
			FROM Lafite_IDENTITY lid
			INNER JOIN Lafite_IDENTITY_MAP lim ON lid.Id=lim.IDENTITY_ID
			INNER JOIN lafite_attribute lab ON lim.MAP_ID = lab.ID
			WHERE lab.attribute_name='第三方账号' and lab.attribute_type='Role'
        END;
    END;
END;
IF @ContractType = 'Appointment'
BEGIN
    SELECT @DealerId = CompanyID,
           --@MailAddress = EMail,
           @DealerType = DealerType
    FROM Contract.AppointmentMain a
        INNER JOIN Contract.AppointmentCandidate b
            ON a.ContractId = b.ContractId;

    SELECT @DealerSAPCode = A.DMA_SAP_Code,
	@DealerName = A.DMA_ChineseName
    FROM DealerMaster A
    WHERE A.DMA_ID = @DealerId;

	SELECT TOP 1 @DDEndDate=DMDD_EndDate FROM DealerMasterDD WHERE DMDD_DealerID=@DealerId ORDER BY DMDD_UpdateDate DESC


    IF @MailAddress <> '' AND @MailAddress <> ';'
    BEGIN
        SET @MailSubject = '蓝威经销商背调通知 - ' + @DealerName;
        IF @DDEndDate IS NULL OR dateadd(m,13,GetDate())>@DDEndDate
        BEGIN
            --SET @MailBody
            --    = '尊敬的经销商同事您好，<br/> 贵司新经销商合同已经被申请，请及时进入经销商管理系统（DMS）完成：<br/><br/>1. 第三方合规知识培训 <br/>2. 渠道管理规则培训考试<br/>3. 经销商调研问卷：需要由<font color="#FF0000"><b>业务负责人</b></font>，点击以下链接，进入页面进行填写。<br/>'
            --      + @MailWjLine
            --      + '&nbsp;&nbsp;（问卷支持手机端填写，可以直接手机打开，或复制此链接转发至手机）<br/><br/>若合同审批完，您还未完成培训和调研，贵公司合同不能生效！ <br/><br/>备注：请尽量使用谷歌浏览器参加培训<br><br>蓝威DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！';
            SET @MailBody
                = '尊敬的用户您好，<br/> 新经销商合同申请总经理审批已通过，请及时开展背景调查，并进入经销商管理系统（DMS）完成背调报告上传！ <br/><br/>备注：请尽量使用谷歌浏览器<br><br>蓝威DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！';
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
            SELECT NEWID(), 'email', '', EMAIL1, @MailSubject, @MailBody, 'Waiting', GETDATE(), NULL
			FROM Lafite_IDENTITY lid
			INNER JOIN Lafite_IDENTITY_MAP lim ON lid.Id=lim.IDENTITY_ID
			INNER JOIN lafite_attribute lab ON lim.MAP_ID = lab.ID
			WHERE lab.attribute_name='第三方账号' and lab.attribute_type='Role'

        END;
    END;
END;







