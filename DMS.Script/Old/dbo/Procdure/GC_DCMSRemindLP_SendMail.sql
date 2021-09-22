DROP PROCEDURE [dbo].[GC_DCMSRemindLP_SendMail]
GO


CREATE PROCEDURE [dbo].[GC_DCMSRemindLP_SendMail]

AS
BEGIN 
	declare @LPSAPCode nvarchar(100);--�����̱��
	declare @CompanyName nvarchar(100);--��˾����	
	declare @ContractType nvarchar(100);--��ͬ����
	declare @CC_NameCN nvarchar(100);--��ͬ����
	declare @contractNO nvarchar(100);--��ͬ���
	declare @EName nvarchar(100);--������
	declare @RequestDate nvarchar(100);--��ͬ�ύʱ��
	declare @AgreementBegin nvarchar(100);--��ͬ��ʼʱ��
	declare @AgreementEnd nvarchar(100);--��ͬ��ֹʱ��
	declare @ContractStatus nvarchar(500);--��ͬ����״̬
	declare @PSAPCode nvarchar(100);
	declare @stringGKhtml nvarchar(max);--��ͬ����״̬
	declare @stringFChtml nvarchar(max);--��ͬ����״̬

	
	set @stringGKhtml='<style type="text/css">table.gridtable {width:100%; font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}td.title{background-color: #E8E8E8;font-weight:bold;}h4{}</style>'
	set @stringFChtml='<style type="text/css">table.gridtable {width:100%; font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}td.title{background-color: #E8E8E8;font-weight:bold;}</style>'
	set @stringGKhtml+='<table class="gridtable">'
	set @stringFChtml+='<table class="gridtable">'
	set @stringFChtml+='<tr><td>����������</td><td>��ͬ����</td><td>��ͬ����</td><td>��ͬ���</td><td>������</td><td>����ʱ��</td><td>��ͬ��ʼʱ��</td><td>��ͬ��ֹʱ��</td><td>����״̬</td></tr>'
	set @stringGKhtml+='<tr><td>����������</td><td>��ͬ����</td><td>��ͬ����</td><td>��ͬ���</td><td>������</td><td>����ʱ��</td><td>��ͬ��ʼʱ��</td><td>��ͬ��ֹʱ��</td><td>����״̬</td></tr>'

	select * into #tabTemp from (

		select 'Appointment' as ContractType,ContractStatus,a.ContractId,EId,EName,ContractNo,DepId,SUBDEPID,CompanyID,

		CompanyName,LPSAPCode,DealerType,RequestDate,AgreementBegin,AgreementEnd,case  when ContractStatus='Approved' then CONVERT(nvarchar(10),UpdateDate,120) else ''  end as UpdateDate

		from Contract.AppointmentMain a

		inner join Contract.AppointmentCandidate b on a.ContractId=b.ContractId

		inner join Contract.AppointmentProposals c on c.ContractId=a.ContractId

		where a.ContractStatus in ('Approved','InApproval')

		Union

		select 'Amendment' as ContractType,ContractStatus,a.ContractId,EId,EName,ContractNo,DepId,SUBDEPID,a.CompanyID,b.DMA_ChineseName,d.DMA_SAP_Code ,DealerType,RequestDate,AmendEffectiveDate,DealerEndDate,case  when ContractStatus='Approved' then CONVERT(nvarchar(10),UpdateDate,120) else ''  end as N'UpdateDate'

		from Contract.AmendmentMain a

		inner join DealerMaster b on a.CompanyID=b.DMA_ID

		inner join  DealerMaster d on d.DMA_ID=b.DMA_Parent_DMA_ID

		where a.ContractStatus in ('Approved','InApproval') and DealerType='T2'

		Union

		select 'Renewal' as ContractType,ContractStatus,a.ContractId,EId,EName,ContractNo,DepId,SUBDEPID,a.CompanyID,b.DMA_ChineseName,d.DMA_SAP_Code,DealerType,RequestDate,AgreementBegin,AgreementEnd,case  when ContractStatus='Approved' then CONVERT(nvarchar(10),UpdateDate,120) else ''  end as N'UpdateDate'

		from Contract.RenewalMain a

		inner join DealerMaster b on a.CompanyID=b.DMA_ID

		inner join  DealerMaster d on d.DMA_ID=b.DMA_Parent_DMA_ID

		inner join Contract.RenewalProposals c on c.ContractId=a.ContractId

		where a.ContractStatus in ('Approved','InApproval')) tab 
	where not exists (select 1 from interface.T_I_EW_ContractState c where c.ContractId=tab.ContractId and c.SynState=2)
	and DealerType='T2'
	
	--ѭ�����ʼ�
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
		SELECT  CompanyName,ContractType,b.CC_NameCN,contractNO,EName,convert(nvarchar(100),RequestDate,120),convert(nvarchar(100),AgreementBegin,120),convert(nvarchar(100),AgreementEnd ,120),
		
		case when ContractStatus='Approved' and convert(nvarchar(100),AgreementBegin,120)>= convert(nvarchar(100),getdate(),120) 
				then  '����������ͬ��ʼʱ��δ��' 
			when ContractStatus='Approved' and convert(nvarchar(100),AgreementBegin,120)< convert(nvarchar(100),getdate(),120) 
				then '��������δ��ɾ�������ѵ'
			else '������'END  as ContractStatus ,
		LPSAPCode FROM #tabTemp a inner  join interface.ClassificationContract b on a.SUBDEPID=b.CC_Code
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @CompanyName,@ContractType,@CC_NameCN,@contractNO,@EName,@RequestDate,@AgreementBegin ,@AgreementEnd ,@ContractStatus ,@LPSAPCode
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			if  @LPSAPCode='369307' OR @LPSAPCode='442091'
			begin
			
				set @stringFChtml+='<tr><td>'+@CompanyName+'</td><td>'+@ContractType+'</td><td>'+@CC_NameCN+'</td><td>'+@contractNO+'</td><td>'+@EName+'</td><td>'+@RequestDate+'</td><td>'+@AgreementBegin+'</td><td>'+@AgreementEnd+'</td><td>'+@ContractStatus+'</td><tr>'
			end
			else if @LPSAPCode='342859' OR @LPSAPCode='442090'
			begin
				set @stringGKhtml+='<tr><td>'+@CompanyName+'</td><td>'+@ContractType+'</td><td>'+@CC_NameCN+'</td><td>'+@contractNO+'</td><td>'+@EName+'</td><td>'+@RequestDate+'</td><td>'+@AgreementBegin+'</td><td>'+@AgreementEnd+'</td><td>'+@ContractStatus+'</td><tr>'
			
			end
			
    	FETCH NEXT FROM @PRODUCT_CUR INTO @CompanyName,@ContractType,@CC_NameCN,@contractNO,@EName,@RequestDate,@AgreementBegin ,@AgreementEnd ,@ContractStatus  ,@LPSAPCode
		END
        
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR; 
	set @stringFChtml+='</table>'
	set @stringGKhtml+='</table>'

	declare @subject nvarchar(max);
	declare @body nvarchar(max);
	declare @Prompt nvarchar(max);

	set @subject ='����������������������ͨ��δ��Ч��ͬ����֪ͨ'

	set @body='�𾴵�ƽ̨����Աͬ�£����ã�<br/>��ǰ�в��־����̺�ͬ���������л�����ͨ����δ��Ч״̬���뼰ʱ��ϵ����������ɾ�������ѵ����ϸ��Ϣ����:<br><br><br>'
	set @Prompt='<br>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'

	if exists(select 1 from #tabTemp where LPSAPCode in ('369307','442091'))	
	begin 
		insert into MailMessageQueue(MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		values (NEWID(),'email','','jlli@fc-medical.cn',@subject,@body+@stringFChtml+@Prompt,'Waiting',GETDATE(),null)
	end

	if exists(select 1 from #tabTemp where LPSAPCode in ('342859','442090'))
	begin
		insert into MailMessageQueue(MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		values (NEWID(),'email','','yhliu@heng-tai.com.cn',@subject,@body+@stringGKhtml+@Prompt,'Waiting', GETDATE(),null)
	end	
END


GO


