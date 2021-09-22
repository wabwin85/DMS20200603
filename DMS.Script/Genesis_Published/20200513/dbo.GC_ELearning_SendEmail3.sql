SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

/*
�ʼ����ѹ���
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
DECLARE @LPEmail NVARCHAR(200)=''
DECLARE @Parent_DMA_ID UNIQUEIDENTIFIER;

IF @ContractType = 'Renewal'
BEGIN
    SELECT @DealerSAPCode = DMA_SAP_Code,
           @MailAddress = ISNULL(ISNULL(B.DMA_Email, DMA_BusinessEMail1), ''),
           @DealerType = B.DMA_DealerType,
           @DealerId = B.DMA_ID,
		   @Parent_DMA_ID=B.DMA_Parent_DMA_ID
    FROM Contract.RenewalMain A
        INNER JOIN DealerMaster B
            ON A.CompanyID = B.DMA_ID
    WHERE A.ContractId = @ContractId;

	IF(@Parent_DMA_ID IS NOT NULL)
				BEGIN
					SELECT @LPEmail = EMail1 FROM Lafite_Identity WHERE Corp_id=@Parent_DMA_ID AND Identity_Code Like '%3'
					SET @LPEmail=ISNULL(@LPEmail,'')
				END

    --SET @MailWjLine
    --    = '<a target=''_blank'' href=''http://wechat.bostonscientific.cn/QN/QuestionnaireInfo/Default?t=1&sapid='
    --      + CONVERT(NVARCHAR(10), @DealerSAPCode) + '''>�ʾ����</a>';
    SET @MailWjLine = '';

    IF @MailAddress <> ''
    BEGIN
        SET @MailSubject = '����������֪ͨ - ��ѵ�͵���';
        IF dbo.FN_Contract_IsPassTraining(@ContractId,@DealerId,@DealerType)=0
        BEGIN
            --SET @MailBody='�𾴵ľ�����ͬ�����ã�<br/> ���������Լ��ͬ�Ѿ������룬�뼰ʱ���뾭���̹���ϵͳ��DMS����ɣ�<br/><br/>1. �������Ϲ�֪ʶ��ѵ <br/>2. �������������ѵ���� <br/>3. �����̵����ʾ���Ҫ��<font color="#FF0000"><b>ҵ������</b></font>������������ӣ�����ҳ�������д��<br/>'+@MailWjLine+'&nbsp;&nbsp;���ʾ�֧���ֻ�����д������ֱ���ֻ��򿪣����ƴ�����ת�����ֻ���<br/><br/>����ͬ�����꣬����δ�����ѵ�͵��У���˾��ͬ������Ч�� <br/><br/>��ע���뾡��ʹ�ùȸ�������μ���ѵ<br><br>����DMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'
            SET @MailBody
                = '�𾴵ľ�����ͬ�����ã�<br/> ��˾�¾����̺�ͬ�Ѿ������룬�뼰ʱ���뾭���̹���ϵͳ��DMS����ɣ�<br/><br/>1. �Ϲ���ѵ <br/>2. �ʾ���顣<br/><br/>����ͬ�����꣬����δ�����ѵ�͵��У���˾��ͬ������Ч�� <br/><br/>��ע���뾡��ʹ�ùȸ�������μ���ѵ<br><br>����DMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��';
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
            (NEWID(), 'email', '', @MailAddress+';'+'dms@bpmedtech.com'+';'+@LPEmail, @MailSubject, @MailBody, 'Waiting', GETDATE(), NULL);
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
            ON a.ContractId = b.ContractId
	WHERE A.ContractId = @ContractId;
    SELECT @DealerSAPCode = A.DMA_SAP_Code,
		   @Parent_DMA_ID=A.DMA_Parent_DMA_ID
    FROM DealerMaster A
    WHERE A.DMA_ID = @DealerId;

	IF(@Parent_DMA_ID IS NOT NULL)
				BEGIN
					SELECT @LPEmail = EMail1 FROM Lafite_Identity WHERE Corp_id=@Parent_DMA_ID AND Identity_Code Like '%3'
					SET @LPEmail=ISNULL(@LPEmail,'')
				END

    --SET @MailWjLine
    --    = '<a target=''_blank'' href=''http://wechat.bostonscientific.cn/QN/QuestionnaireInfo/Default?t=1&sapid='
    --      + CONVERT(NVARCHAR(10), @DealerSAPCode) + '''>�ʾ����</a>';
    SET @MailWjLine = '';

    IF @MailAddress <> ''
    BEGIN
        SET @MailSubject = '����������֪ͨ - ��ѵ�͵���';
        IF dbo.FN_Contract_IsPassTraining(@ContractId,@DealerId,@DealerType)=0
        BEGIN
            --SET @MailBody
            --    = '�𾴵ľ�����ͬ�����ã�<br/> ��˾�¾����̺�ͬ�Ѿ������룬�뼰ʱ���뾭���̹���ϵͳ��DMS����ɣ�<br/><br/>1. �������Ϲ�֪ʶ��ѵ <br/>2. �������������ѵ����<br/>3. �����̵����ʾ���Ҫ��<font color="#FF0000"><b>ҵ������</b></font>������������ӣ�����ҳ�������д��<br/>'
            --      + @MailWjLine
            --      + '&nbsp;&nbsp;���ʾ�֧���ֻ�����д������ֱ���ֻ��򿪣����ƴ�����ת�����ֻ���<br/><br/>����ͬ�����꣬����δ�����ѵ�͵��У���˾��ͬ������Ч�� <br/><br/>��ע���뾡��ʹ�ùȸ�������μ���ѵ<br><br>����DMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��';
            SET @MailBody
                = '�𾴵ľ�����ͬ�����ã�<br/> ��˾�¾����̺�ͬ�Ѿ������룬�뼰ʱ���뾭���̹���ϵͳ��DMS����ɣ�<br/><br/>1. �Ϲ���ѵ <br/>2. �ʾ���顣<br/><br/>����ͬ�����꣬����δ�����ѵ�͵��У���˾��ͬ������Ч�� <br/><br/>��ע���뾡��ʹ�ùȸ�������μ���ѵ<br><br����DMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��';
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
            (NEWID(), 'email', '', @MailAddress+';'+'dms@bpmedtech.com'+';'+@LPEmail, @MailSubject, @MailBody, 'Waiting', GETDATE(), NULL);

        END;
    END;
END;









GO

