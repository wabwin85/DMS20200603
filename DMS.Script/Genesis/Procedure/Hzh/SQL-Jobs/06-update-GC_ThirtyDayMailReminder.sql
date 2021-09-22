SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
ALTER Procedure [dbo].[GC_ThirtyDayMailReminder]
AS
declare @DMA_ChineseShortName nvarchar(100)
declare @HOS_HospitalName nvarchar(100)
declare @TDL_ProductNameString nvarchar(100)
declare @TDL_CompanyName nvarchar(100)
declare @Dma_Id nvarchar(100)
declare @subject nvarchar(max)
declare @body nvarchar(max)
declare @toemail nvarchar(100)

begin


select @Dma_Id=t.TDL_DMA_ID,@DMA_ChineseShortName=d.DMA_ChineseShortName,@HOS_HospitalName=h.HOS_HospitalName ,@TDL_ProductNameString=t.TDL_ProductNameString,@TDL_CompanyName=t.TDL_CompanyName 
from ThirdPartyDisclosureList t  inner join DealerMaster  d on d.DMA_ID=t.TDL_ID
inner join Hospital h on h.HOS_ID=t.TDL_HOS_ID
where t.TDL_EndDate >= GETDATE() and DATEDIFF ( DD,GETDATE(),t.TDL_EndDate)<=30 and t.TDL_ApprovalStatus='披露申请审批通过'


select @toemail=d.DMA_Email from DealerMaster d where d.DMA_ID=@Dma_Id
set @subject='经销商第三方披露预警'

set @body='尊敬的管理人员，您好：'
set @body +='<br> 贵司的第三方披露，披露产品线：'+ @TDL_ProductNameString+',医院:'+@HOS_HospitalName+ '第三方公司名称:'+@TDL_CompanyName+' 该披露即将到期， 请核查并及时续约！<br>蓝威DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'

insert into MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
values (NEWID(),'email','', @toemail,@subject ,@body ,'Waiting', GETDATE(), null ) 


END

GO

