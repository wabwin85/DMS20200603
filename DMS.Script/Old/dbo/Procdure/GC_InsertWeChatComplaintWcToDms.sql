DROP Procedure [dbo].[GC_InsertWeChatComplaintWcToDms]
GO



/*
΢��Ͷ�߽�������ͬ��
*/
CREATE Procedure [dbo].[GC_InsertWeChatComplaintWcToDms]
	@Id NVARCHAR(36),	  
	@WdtId NVARCHAR(36), 
	@WupId NVARCHAR(36), 
	@Title NVARCHAR(200),
	@Body NVARCHAR(2000),
	@CreateDate NVARCHAR(200),
	@UserID NVARCHAR(36),
	@Status NVARCHAR(20),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @AnswerUserId UNIQUEIDENTIFIER
	DECLARE @DmaParId UNIQUEIDENTIFIER
	DECLARE @DmaDealerName NVARCHAR(400)
	DECLARE @EmailAddr NVARCHAR(400)
	DECLARE @EmailBody NVARCHAR(2000)
	DECLARE @TSName NVARCHAR(200)
	DECLARE @CheckId INT
	SELECT  @CheckId=COUNT(*) FROM WechatQuestion WHERE WQA_ID=@Id;
	IF(@CheckId=0)
	BEGIN
		SELECT @DmaParId=C.DMA_Parent_DMA_ID ,@DmaDealerName=b.BWU_DealerName FROM
		BusinessWechatUser b 
		INNER JOIN DealerMaster C ON C.DMA_ID=b.BWU_DealerId
		WHERE CONVERT(NVARCHAR(36),b.BWU_ID)=@UserID;
	
		SELECT @AnswerUserId=WRU_UserId ,@EmailAddr=WRU_Email
		FROM WechatReplyUser 
		WHERE CONVERT(NVARCHAR(36),WRU_WDT_ID)=@WdtId AND CONVERT(NVARCHAR(36),WRU_ProductLineID)=@WupId  AND WRU_Comp_To=@DmaParId;
		
		SELECT @TSName=WDT_NameCN FROM WechatComplaintType WHERE WDT_ID=@WdtId;
		
		INSERT INTO WechatQuestion 
		(WQA_ID,WQA_WDT_ID,WQA_WUP_ID,WQA_QuestionTitle,WQA_QuestionBody,WQA_CreateDate,WQA_UserID,WQA_AnswerUserId,WQA_Status,WQA_WC_DMS,WQA_DMS_WC)
		VALUES(@Id,@WdtId,@WupId,@Title,@Body,@CreateDate,@UserID,@AnswerUserId,'0','1','0');
		
		--���ʼ�
		IF(ISNULL(@EmailAddr,'')='')
		BEGIN
			SET @EmailAddr='373122322@qq.com'
		END
		SET @EmailBody='<b style=''font-weight:bold;font-size:14.0pt;''>���ã�</b><br><span style=''color:Red;''>'+@DmaDealerName+'</span> ���<span style=''color:Red;''>'+@TSName+'</span> ����ͨ��΢��ƽ̨����������һ��Ͷ�߽�����Ϣ������������ӣ����ɲ�����������������δ�ظ���������Ϣ��http://bscdealer.cn/WeChatComplaint.aspx?UserId=' + CONVERT (NVARCHAR(100),@AnswerUserId)+ ' <br>��ʿ�ٿ�ѧ��������΢�������Ŷ�<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��';
		INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
		VALUES(NEWID(),'email','',@EmailAddr,'����һ��������',@EmailBody,'Waiting',GETDATE(),NULL);
	END
	
	
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
END CATCH





GO


GC_ImportPOReceipt