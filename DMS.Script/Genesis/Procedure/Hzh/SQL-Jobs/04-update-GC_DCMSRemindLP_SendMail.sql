SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[GC_DCMSRemindLP_SendMail]

AS
BEGIN 
	declare @LPSAPCode nvarchar(100);--经销商编号
	declare @CompanyName nvarchar(100);--公司名称	
	declare @ContractType nvarchar(100);--合同类型
	declare @CC_NameCN nvarchar(100);--合同名称
	declare @contractNO nvarchar(100);--合同编号
	declare @EName nvarchar(100);--申请人
	declare @RequestDate nvarchar(100);--合同提交时间
	declare @AgreementBegin nvarchar(100);--合同开始时间
	declare @AgreementEnd nvarchar(100);--合同终止时间
	declare @ContractStatus nvarchar(500);--合同审批状态
	declare @PSAPCode nvarchar(100);
	declare @stringGKhtml nvarchar(max);--合同审批状态
	declare @stringFChtml nvarchar(max);--合同审批状态

	
	set @stringGKhtml='<style type="text/css">table.gridtable {width:100%; font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}td.title{background-color: #E8E8E8;font-weight:bold;}h4{}</style>'
	set @stringFChtml='<style type="text/css">table.gridtable {width:100%; font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;}td.title{background-color: #E8E8E8;font-weight:bold;}</style>'
	set @stringGKhtml+='<table class="gridtable">'
	set @stringFChtml+='<table class="gridtable">'
	set @stringFChtml+='<tr><td>经销商名称</td><td>合同类型</td><td>合同分类</td><td>合同编号</td><td>申请人</td><td>申请时间</td><td>合同开始时间</td><td>合同终止时间</td><td>审批状态</td></tr>'
	set @stringGKhtml+='<tr><td>经销商名称</td><td>合同类型</td><td>合同分类</td><td>合同编号</td><td>申请人</td><td>申请时间</td><td>合同开始时间</td><td>合同终止时间</td><td>审批状态</td></tr>'

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
	
	--循环发邮件
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
		SELECT  CompanyName,ContractType,b.CC_NameCN,contractNO,EName,convert(nvarchar(100),RequestDate,120),convert(nvarchar(100),AgreementBegin,120),convert(nvarchar(100),AgreementEnd ,120),
		
		case when ContractStatus='Approved' and convert(nvarchar(100),AgreementBegin,120)>= convert(nvarchar(100),getdate(),120) 
				then  '已审批，合同起始时间未到' 
			when ContractStatus='Approved' and convert(nvarchar(100),AgreementBegin,120)< convert(nvarchar(100),getdate(),120) 
				then '已审批，未完成经销商培训'
			else '审批中'END  as ContractStatus ,
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

	set @subject ='二级经销商审批中与审批通过未生效合同汇总通知'

	set @body='尊敬的平台管理员同事，您好！<br/>当前有部分经销商合同处于审批中或审批通过但未生效状态，请及时联系所属二级完成经销商培训。详细信息如下:<br><br><br>'
	set @Prompt='<br>蓝威DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'

	if exists(select 1 from #tabTemp where LPSAPCode in ('369307','442091'))	
	begin --jlli@fc-medical.cn
		insert into MailMessageQueue(MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		values (NEWID(),'email','','aaron.ma@gmedtech.com',@subject,@body+@stringFChtml+@Prompt,'Waiting',GETDATE(),null)
	end

	if exists(select 1 from #tabTemp where LPSAPCode in ('342859','442090'))
	BEGIN--yhliu@heng-tai.com.cn
		insert into MailMessageQueue(MMQ_ID,MMQ_QueueNo,MMQ_From,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate,MMQ_SendDate)
		values (NEWID(),'email','','aaron.ma@gmedtech.com',@subject,@body+@stringGKhtml+@Prompt,'Waiting', GETDATE(),null)
	end	
END


GO

