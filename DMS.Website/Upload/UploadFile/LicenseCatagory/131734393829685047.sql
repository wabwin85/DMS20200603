select *,NEWID() as DAT_ID_New
into #temp
from DealerAuthorizationTable a 
where a.DAT_PMA_ID='C21A291C-1FEC-4BCE-AFAA-4EB92FC901B4' 
and GETDATE() between a.DAT_StartDate and a.DAT_EndDate
and a.DAT_Type='Normal'
and not exists (select 1 from 
				DealerAuthorizationTable b 
				where b.DAT_PMA_ID='90B1A3D7-C235-4194-B139-A54E01088C14' and b.DAT_DMA_ID=a.DAT_DMA_ID 
				and GETDATE() between b.DAT_StartDate and b.DAT_EndDate)


insert into DealerAuthorizationTable 
select '90B1A3D7-C235-4194-B139-A54E01088C14',a.DAT_ID_New,DAT_DCL_ID,DAT_DMA_ID,'8f15d92a-47e4-462f-a603-f61983d61b7b','1',null,null,
DAT_StartDate,DAT_EndDate,'Temp' from #temp a

insert into HospitalList
select a.DAT_ID_New,HLA_HOS_ID,NEWID(),HLA_Remark,HLA_HOS_Depart,	HLA_HOS_DepartType,	HLA_HOS_DepartRemark,HLA_StartDate,HLA_EndDate
from #temp a inner join HospitalList b on a.DAT_ID=b.HLA_DAT_ID

