USE [BSC_Prd]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--邮件提醒销售及CO，合并考核后未终止原来的经销商
Create PROCEDURE [Contract].[Proc_SendMailAssessment]
(
  @UserCode nvarchar(200), --申请人账号
  @DealerCodeMerge nvarchar(100),--被合并经销商
  @SbbuCode nvarchar(100) --合同分类
)
AS
BEGIN 	

declare @DealerName nvarchar(200);
declare @subject nvarchar(max);
declare @body nvarchar(max);
declare @productlinename nvarchar(100);--产品线名称
declare @sbbuname nvarchar(100)
declare @UserMail nvarchar(100)

select @DealerName=v.DMA_ChineseName from DealerMaster v where v.DMA_SAP_Code=@DealerCodeMerge

select @sbbuname=CC_NameCN,@productlinename=b.ProductLineName from interface.ClassificationContract a,V_DivisionProductLineRelation b 
where CC_Code=@SbbuCode and a.CC_Division=b.DivisionCode and b.IsEmerging='0'


set @subject='经销商合并终止申请提交通知'

set @body='尊敬的CO同事，您好：'
set @body +='<br> 经销商'+@DealerName+@productlinename +'-'+@sbbuname+'产品线合同已被合并。请及时通知销售申请该经销商对应SubBU的终止合同！<br>特此通知！<br><br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'


INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
SELECT NEWID(),'email','', m.MDA_MailAddress,@subject ,@body ,'Waiting', GETDATE(), null  
FROM  MailDeliveryAddress m 
WHERE MDA_MailTo='CO' and MDA_MailType='DCMS_BSC' AND MDA_ActiveFlag=1


SELECT @UserMail=b.Email FROM Lafite_IDENTITY A 
INNER JOIN INTERFACE.MDM_EmployeeMaster B ON A.IDENTITY_CODE=B.account
WHERE A.IDENTITY_CODE=@UserCode

	IF ISNULL(@UserMail,'')<>''
	BEGIN

		SET @body='';
		SET @body='尊敬的销售同事，您好：'
		SET @body +='<br> 经销商'+@DealerName+@productlinename +'-'+@sbbuname+'产品线合同已被合并。请及时申请该经销商对应SubBU的终止合同！<br>特此通知！<br><br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
		
		INSERT INTO MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		SELECT NEWID(),'email','', @UserMail,@subject ,@body ,'Waiting', GETDATE(), null  
	END

END


