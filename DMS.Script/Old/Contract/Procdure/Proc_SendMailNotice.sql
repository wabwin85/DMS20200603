DROP PROCEDURE [Contract].[Proc_SendMailNotice]
GO


CREATE PROCEDURE [Contract].[Proc_SendMailNotice]
(
  @NewDealerName nvarchar(200), --����������
  @Productline nvarchar(36), --�����̲�Ʒ��
  @ParentSapCode nvarchar(100),--ƽ̨SAPcode
  @SbbuCode nvarchar(100) --��ͬ����
)
AS
BEGIN 	


declare @parentname nvarchar(100); --��Ӧ�ľ�����name
declare @subject nvarchar(max);
declare @body nvarchar(max);
declare @productlinename nvarchar(100);--��Ʒ������
declare @sbbuname nvarchar(100)

select @parentname=v.DMA_ChineseName from DealerMaster v where v.DMA_SAP_Code=@ParentSapCode

select @sbbuname=CC_NameCN from interface.ClassificationContract where CC_Code=@SbbuCode

select @productlinename= v.ProductLineName from  V_DivisionProductLineRelation v 
where v.DivisionCode =@Productline and v.IsEmerging=0

set @subject='���������̱����˲�֪ͨ'

set @body='�𾴵�'+@parentname+'����ͬ�£����ã�'
set @body +='<br> ��˾�����¶���������'+@NewDealerName+@productlinename +'-'+@sbbuname+' ��ͬ�������ύ���뼰ʱ��������Ϣ�˲飡<br>�ش�֪ͨ��<br><br>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'


insert into MailMessageQueue (MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
select NEWID(),'email','', m.MDA_MailAddress,@subject ,@body ,'Waiting', GETDATE(), null  from  MailDeliveryAddress m 
inner join  Client c on c.CLT_ID= m.MDA_MailTo
inner join DealerMaster d  on d.DMA_ID=c.CLT_Corp_Id 
where  d.DMA_SAP_Code=@ParentSapCode and m.MDA_MailType='DCMS_MailToLP'

END



GO


