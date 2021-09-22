DROP view [interface].[V_I_DPS_DealerContractStatus]
GO

create view [interface].[V_I_DPS_DealerContractStatus] AS 
    select 'Appointment' as ContractType,ContractStatus,a.ContractId,EId,EName,ContractNo,DepId,SUBDEPID,CompanyID,  

		CompanyName,LPSAPCode,DealerType,RequestDate,AgreementBegin,AgreementEnd,case  when ContractStatus='Approved' then CONVERT(nvarchar(10),UpdateDate,120) else ''  end as UpdateDate

		from Contract.AppointmentMain a

		inner join Contract.AppointmentCandidate b on a.ContractId=b.ContractId

		inner join Contract.AppointmentProposals c on c.ContractId=a.ContractId

		where a.ContractStatus in ('Approved','InApproval') and DealerType='T1'

		Union

		select 'Amendment' as ContractType,ContractStatus,a.ContractId,EId,EName,ContractNo,DepId,SUBDEPID,a.CompanyID,b.DMA_ChineseName,d.DMA_SAP_Code ,DealerType,RequestDate,AmendEffectiveDate,DealerEndDate,case  when ContractStatus='Approved' then CONVERT(nvarchar(10),UpdateDate,120) else ''  end as N'UpdateDate'

		from Contract.AmendmentMain a

		inner join DealerMaster b on a.CompanyID=b.DMA_ID

		inner join  DealerMaster d on d.DMA_ID=b.DMA_Parent_DMA_ID

		where a.ContractStatus in ('Approved','InApproval') and DealerType='T1'

		Union

		select 'Renewal' as ContractType,ContractStatus,a.ContractId,EId,EName,ContractNo,DepId,SUBDEPID,a.CompanyID,b.DMA_ChineseName,d.DMA_SAP_Code,DealerType,RequestDate,AgreementBegin,AgreementEnd,case  when ContractStatus='Approved' then CONVERT(nvarchar(10),UpdateDate,120) else ''  end as N'UpdateDate'

		from Contract.RenewalMain a

		inner join DealerMaster b on a.CompanyID=b.DMA_ID

		inner join  DealerMaster d on d.DMA_ID=b.DMA_Parent_DMA_ID

		inner join Contract.RenewalProposals c on c.ContractId=a.ContractId

		where a.ContractStatus in ('Approved','InApproval') and DealerType='T1'
GO


