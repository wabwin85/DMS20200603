DROP Proc [dbo].[GC_UpdateBullet]
GO







CREATE Proc [dbo].[GC_UpdateBullet]
as

------二级经销商DMS使用相关材料
Insert into BulletinDetail
select NEWID(),'11D929E0-FD93-4C93-B629-67D8FC96EBC8',DMA_ID,0,'00000000-0000-0000-0000-000000000000',
NULL,0,'00000000-0000-0000-0000-000000000000',Null
from DealerMaster
where DMA_DealerType in ('T2','LP') and DMA_DeletedFlag=0
and  not exists (select BUD_Dealer_DMA_ID from BulletinDetail where BUD_BUM_ID='11D929E0-FD93-4C93-B629-67D8FC96EBC8'
and BUD_Dealer_DMA_ID=DMA_ID) 

-----DMS系统功能更新列表-截止2013.12.13
Insert into BulletinDetail
select NEWID(),'AFF212FD-B892-4C80-9A94-347DF271EB56',DMA_ID,0,'00000000-0000-0000-0000-000000000000',
NULL,0,'00000000-0000-0000-0000-000000000000',Null
from DealerMaster
where  DMA_DeletedFlag=0
and  not exists (select BUD_Dealer_DMA_ID from BulletinDetail where BUD_BUM_ID='AFF212FD-B892-4C80-9A94-347DF271EB56'
and BUD_Dealer_DMA_ID=DMA_ID) 

-----DMS系统功能更新-V20140121
Insert into BulletinDetail
select NEWID(),'E6458EC0-74A2-4B11-BF5F-72DF1AE60A79',DMA_ID,0,'00000000-0000-0000-0000-000000000000',
NULL,0,'00000000-0000-0000-0000-000000000000',Null
from DealerMaster
where  DMA_DeletedFlag=0
and  not exists (select BUD_Dealer_DMA_ID from BulletinDetail where BUD_BUM_ID='E6458EC0-74A2-4B11-BF5F-72DF1AE60A79'
and BUD_Dealer_DMA_ID=DMA_ID) 


-----DMS系统功能更新-如何准确上报本月销量？
Insert into BulletinDetail
select NEWID(),'A1C4B5AC-F878-4B70-8232-98F4C636B87A',DMA_ID,0,'00000000-0000-0000-0000-000000000000',
NULL,0,'00000000-0000-0000-0000-000000000000',Null
from DealerMaster
where  DMA_DeletedFlag=0
and  not exists (select BUD_Dealer_DMA_ID from BulletinDetail where BUD_BUM_ID='A1C4B5AC-F878-4B70-8232-98F4C636B87A'
and BUD_Dealer_DMA_ID=DMA_ID) 

-----一级经销商及物流平台DMS系统使用相关资料
Insert into BulletinDetail
select NEWID(),'CD05523B-564E-4637-992E-CCADA75ED5E8',DMA_ID,0,'00000000-0000-0000-0000-000000000000',
NULL,0,'00000000-0000-0000-0000-000000000000',Null
from DealerMaster
where  DMA_DeletedFlag=0 and DMA_DealerType in ('T1','LP')
and  not exists (select BUD_Dealer_DMA_ID from BulletinDetail where BUD_BUM_ID='CD05523B-564E-4637-992E-CCADA75ED5E8'
and BUD_Dealer_DMA_ID=DMA_ID) 


-------请各位二级经销商对系统中的库存数据进行确认
--Insert into BulletinDetail
--select NEWID(),'6FEB7E63-A34B-4833-9F91-7B7642DFB51D',DMA_ID,0,'00000000-0000-0000-0000-000000000000',
--NULL,0,'00000000-0000-0000-0000-000000000000',Null
--from DealerMaster
--where  DMA_DeletedFlag=0 and DMA_DealerType in ('T2','LP')
--and  not exists (select BUD_Dealer_DMA_ID from BulletinDetail where BUD_BUM_ID='6FEB7E63-A34B-4833-9F91-7B7642DFB51D'
--and BUD_Dealer_DMA_ID=DMA_ID)

--Endo考卷
--Insert into BulletinDetail
--select NEWID(),'86696B21-3FAE-4048-B4D5-760AA90DD08F',DMA_ID,0,'00000000-0000-0000-0000-000000000000',
--NULL,0,'00000000-0000-0000-0000-000000000000',Null
--from DealerMaster b
--join  DealerAuthorizationTable(nolock ) a on a. DAT_DMA_ID =b . DMA_ID
--left join DealerContract dc on a .DAT_DCL_ID =dc .DCL_ID
--left join PartsClassification c
--on a .DAT_PMA_ID = c. PCT_ID or a.DAT_PMA_ID =c .PCT_ProductLine_BUM_ID
--where DMA_DealerType in ('T2','T1','LP') and DMA_DeletedFlag=0 and DMA_ActiveFlag=1
--and PCT_Name='内窥镜介入'
--and  not exists (select BUD_Dealer_DMA_ID from BulletinDetail where BUD_BUM_ID='86696B21-3FAE-4048-B4D5-760AA90DD08F'
--and BUD_Dealer_DMA_ID=DMA_ID) 


--Endo考卷2
Insert into BulletinDetail
select NEWID(),'7F7641B5-5819-4A4F-B5DC-54CFC318F3FB',DMA_ID,0,'00000000-0000-0000-0000-000000000000',
NULL,0,'00000000-0000-0000-0000-000000000000',Null
from DealerMaster b
join  DealerAuthorizationTable(nolock ) a on a. DAT_DMA_ID =b . DMA_ID
left join DealerContract dc on a .DAT_DCL_ID =dc .DCL_ID
left join PartsClassification c
on a .DAT_PMA_ID = c. PCT_ID or a.DAT_PMA_ID =c .PCT_ProductLine_BUM_ID
where DMA_DealerType in ('T2','T1','LP') and DMA_DeletedFlag=0 and DMA_ActiveFlag=1
and PCT_Name='内窥镜介入'
and  not exists (select BUD_Dealer_DMA_ID from BulletinDetail where BUD_BUM_ID='7F7641B5-5819-4A4F-B5DC-54CFC318F3FB'
and BUD_Dealer_DMA_ID=DMA_ID) 

--Endo订货手册
Insert into BulletinDetail
select NEWID(),'9584B4B1-0E66-49F2-ADA6-985FC564E773',DMA_ID,0,'00000000-0000-0000-0000-000000000000',
NULL,0,'00000000-0000-0000-0000-000000000000',Null
from DealerMaster b
join  DealerAuthorizationTable(nolock ) a on a. DAT_DMA_ID =b . DMA_ID
left join DealerContract dc on a .DAT_DCL_ID =dc .DCL_ID
left join PartsClassification c
on a .DAT_PMA_ID = c. PCT_ID or a.DAT_PMA_ID =c .PCT_ProductLine_BUM_ID
where DMA_DealerType in ('T2','T1','LP') and DMA_DeletedFlag=0 and DMA_ActiveFlag=1
and PCT_Name='内窥镜介入'
and  not exists (select BUD_Dealer_DMA_ID from BulletinDetail where BUD_BUM_ID='9584B4B1-0E66-49F2-ADA6-985FC564E773'
and BUD_Dealer_DMA_ID=DMA_ID) 

--二级寄售库存调整通知
--Insert into BulletinDetail
--select NEWID(),'05DBCBAE-040E-4346-9A93-D2E1326894E8',DMA_ID,0,'00000000-0000-0000-0000-000000000000',
--NULL,0,'00000000-0000-0000-0000-000000000000',Null
--from DealerMaster b
----join  DealerAuthorizationTable(nolock ) a on a. DAT_DMA_ID =b . DMA_ID
----left join DealerContract dc on a .DAT_DCL_ID =dc .DCL_ID
----left join PartsClassification c
----on a .DAT_PMA_ID = c. PCT_ID or a.DAT_PMA_ID =c .PCT_ProductLine_BUM_ID
--where DMA_DealerType in ('T2') and DMA_DeletedFlag=0 and DMA_ActiveFlag=1
--and DMA_Parent_DMA_ID like '8%'
--and  not exists (select BUD_Dealer_DMA_ID from BulletinDetail where BUD_BUM_ID='05DBCBAE-040E-4346-9A93-D2E1326894E8'
--and BUD_Dealer_DMA_ID=DMA_ID) 





GO


