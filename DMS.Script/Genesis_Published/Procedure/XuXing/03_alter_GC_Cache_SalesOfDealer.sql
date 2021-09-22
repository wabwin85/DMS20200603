SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

ALTER PROCEDURE [dbo].[GC_Cache_SalesOfDealer] 
AS
BEGIN
SET NOCOUNT ON;

--根据岗位和医院关系，岗位和销售的关系，初始化销售和医院的数据信息
INSERT INTO dbo.SalesRepHospital
(
    SRN_HOS_ID,
    SRH_USR_UserID,
    SRH_ID,
    BUM_ID
)
SELECT HospitalID,IDENTITY_ID,NEWID(),ProductLineID FROM dbo.View_PositionSalesRepHospital

--added by bozhenfei on 20110506
--删除已逻辑删除的销售人员的医院关系
delete from SalesRepHospital where SRH_USR_UserID in (
select Id from Lafite_IDENTITY where IDENTITY_TYPE = 'User' and DELETE_FLAG = 1)
--added by bozhenfei on 20110630
--将删除用户的登录帐号加删除标识
/*
UPDATE Lafite_IDENTITY
SET IDENTITY_CODE = IDENTITY_CODE + '_Deleted',
LOWERED_IDENTITY_CODE = LOWERED_IDENTITY_CODE + '_deleted',
IDENTITY_NAME = IDENTITY_NAME + '_Deleted'
WHERE DELETE_FLAG = 1
*/

delete from [Cache_SalesOfDealer]
insert into [Cache_SalesOfDealer]
select newid() GID, * from dbo.View_SalesOfDealer

--维护SalesRepHospital --20131228
select HOS_ID ,ROW_NUMBER () over( order by HOS_ID ) as row
into #Hos
from Hospital
where HOS_DeletedFlag =0
and HOS_ID not in
(select SRN_HOS_ID from SalesRepHospital )

Declare @coun int
set  @coun =1
while @coun <=(select COUNT(*) from #Hos)
begin
insert into SalesRepHospital
select HOS_ID ,UserId ,NEWID (), BumId from [View_SalesReHospital],#Hos
where #HOS .row =@coun
set @coun =@coun +1
end
drop table #Hos


end

GO

