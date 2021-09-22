DROP PROCEDURE [Contract].[Proc_SendMailNotice]
GO


CREATE PROCEDURE [Contract].[Proc_SendMailNotice]
(
  @NewDealerName nvarchar(200), --经销商名称
  @Productline nvarchar(36), --经销商产品线
  @ParentSapCode nvarchar(100),--平台SAPcode
  @SbbuCode nvarchar(100) --合同分类
)
AS
BEGIN 	


declare @parentname nvarchar(100); --对应的经销商name
declare @subject nvarchar(max);
declare @body nvarchar(max);
declare @productlinename nvarchar(100);--产品线名称
declare @sbbuname nvarchar(100)

select @parentname=v.DMA_ChineseName from DealerMaster v where v.DMA_SAP_Code=@ParentSapCode

select @sbbuname=CC_NameCN from interface.ClassificationContract where CC_Code=@SbbuCode

select @productlinename= v.ProductLineName from  V_DivisionProductLineRelation v 
where v.DivisionCode =@Productline and v.IsEmerging=0

set @subject='二级经销商背景核查通知'

set @body='尊敬的'+@parentname+'商务同事，您好：'
set @body +='<br> 贵司所属新二级经销商'+@NewDealerName+@productlinename +'-'+@sbbuname+' 合同申请已提交。请及时做背景信息核查！<br>特此通知！<br><br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'


insert into MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
select NEWID(),'email','', m.MDA_MailAddress,@subject ,@body ,'Waiting', GETDATE(), null  from  MailDeliveryAddress m 
inner join  Client c on c.CLT_ID= m.MDA_MailTo
inner join DealerMaster d  on d.DMA_ID=c.CLT_Corp_Id 
where  d.DMA_SAP_Code=@ParentSapCode and m.MDA_MailType='DCMS_MailToLP'

END



GO


