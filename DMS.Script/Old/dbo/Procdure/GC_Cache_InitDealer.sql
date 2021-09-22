DROP Procedure [dbo].[GC_Cache_InitDealer]
GO


/*
1 经销商默认仓库检查，若无默认仓库，则创建；经销商中间库（在途库）；LP还需建立默认的寄售库和借货库
2 经销商帐户信息初始化DealerShipTo,根据Lafite_IDENTITY的REV1为‘D’判断是否是默认帐户（首先得在Lafite_IDENTITY和Lafite_Membership维护好用户信息）
*/
CREATE Procedure [dbo].[GC_Cache_InitDealer]
AS

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

--经销商默认仓库（普通库）
insert into Warehouse (
   WHM_DMA_ID
  ,WHM_Name
  ,WHM_Province
  ,WHM_ID
  ,WHM_City
  ,WHM_Type
  ,WHM_CON_ID
  ,WHM_PostalCode
  ,WHM_Address
  ,WHM_HoldWarehouse
  ,WHM_Town
  ,WHM_District
  ,WHM_Phone
  ,WHM_Fax
  ,WHM_ActiveFlag
  ,WHM_Hospital_HOS_ID
) 
select DMA_ID,DMA_ChineseName+'主仓库','',newid(),'','DefaultWH',null,'',DMA_ShipToAddress,0,'','','','',1,null
from DealerMaster 
where DMA_ActiveFlag = 1 and DMA_DeletedFlag = 0 and DMA_HostCompanyFlag = 0
and not exists (select 1 from Warehouse 
where WHM_Type = 'DefaultWH' and WHM_DMA_ID = DMA_ID)

--经销商中间库（在途库）
insert into Warehouse (
   WHM_DMA_ID
  ,WHM_Name
  ,WHM_Province
  ,WHM_ID
  ,WHM_City
  ,WHM_Type
  ,WHM_CON_ID
  ,WHM_PostalCode
  ,WHM_Address
  ,WHM_HoldWarehouse
  ,WHM_Town
  ,WHM_District
  ,WHM_Phone
  ,WHM_Fax
  ,WHM_ActiveFlag
  ,WHM_Hospital_HOS_ID
) 
select DMA_ID,DMA_ChineseName+'在途库','',newid(),'','SystemHold',null,'','',1,'','','','',1,null
from DealerMaster 
where DMA_ActiveFlag = 1 and DMA_DeletedFlag = 0 and DMA_HostCompanyFlag = 0
and not exists (select 1 from Warehouse 
where WHM_Type = 'SystemHold' and WHM_DMA_ID = DMA_ID)

--LP默认寄售库
insert into Warehouse (
   WHM_DMA_ID
  ,WHM_Name
  ,WHM_Province
  ,WHM_ID
  ,WHM_City
  ,WHM_Type
  ,WHM_CON_ID
  ,WHM_PostalCode
  ,WHM_Address
  ,WHM_HoldWarehouse
  ,WHM_Town
  ,WHM_District
  ,WHM_Phone
  ,WHM_Fax
  ,WHM_ActiveFlag
  ,WHM_Hospital_HOS_ID
) 
select DMA_ID,DMA_ChineseName+'寄售库','',newid(),'','Consignment',null,'','',0,'','','','',1,null
from DealerMaster 
where DMA_ActiveFlag = 1 and DMA_DeletedFlag = 0 and DMA_HostCompanyFlag = 0 and DMA_DealerType = 'LP'
and not exists (select 1 from Warehouse 
where WHM_Type = 'Consignment' and WHM_DMA_ID = DMA_ID)

--LP默认借货库
insert into Warehouse (
   WHM_DMA_ID
  ,WHM_Name
  ,WHM_Province
  ,WHM_ID
  ,WHM_City
  ,WHM_Type
  ,WHM_CON_ID
  ,WHM_PostalCode
  ,WHM_Address
  ,WHM_HoldWarehouse
  ,WHM_Town
  ,WHM_District
  ,WHM_Phone
  ,WHM_Fax
  ,WHM_ActiveFlag
  ,WHM_Hospital_HOS_ID
) 
select DMA_ID,DMA_ChineseName+'借货库','',newid(),'','Borrow',null,'','',0,'','','','',1,null
from DealerMaster 
where DMA_ActiveFlag = 1 and DMA_DeletedFlag = 0 and DMA_HostCompanyFlag = 0 and DMA_DealerType = 'LP'
and not exists (select 1 from Warehouse 
where WHM_Type = 'Borrow' and WHM_DMA_ID = DMA_ID)

--一级默认借货库
insert into Warehouse (
   WHM_DMA_ID
  ,WHM_Name
  ,WHM_Province
  ,WHM_ID
  ,WHM_City
  ,WHM_Type
  ,WHM_CON_ID
  ,WHM_PostalCode
  ,WHM_Address
  ,WHM_HoldWarehouse
  ,WHM_Town
  ,WHM_District
  ,WHM_Phone
  ,WHM_Fax
  ,WHM_ActiveFlag
  ,WHM_Hospital_HOS_ID
) 
select DMA_ID,DMA_ChineseName+'借货库','',newid(),'','Borrow',null,'','',0,'','','','',1,null
from DealerMaster 
where DMA_ActiveFlag = 1 and DMA_DeletedFlag = 0 and DMA_HostCompanyFlag = 0 and DMA_DealerType = 'T1'
and not exists (select 1 from Warehouse 
where WHM_Type = 'Borrow' and WHM_DMA_ID = DMA_ID)

--经销商中间库（冻结库）
insert into Warehouse (
   WHM_DMA_ID
  ,WHM_Name
  ,WHM_Province
  ,WHM_ID
  ,WHM_City
  ,WHM_Type
  ,WHM_CON_ID
  ,WHM_PostalCode
  ,WHM_Address
  ,WHM_HoldWarehouse
  ,WHM_Town
  ,WHM_District
  ,WHM_Phone
  ,WHM_Fax
  ,WHM_ActiveFlag
  ,WHM_Hospital_HOS_ID
) 
select DMA_ID,DMA_ChineseName+'冻结库','',newid(),'','Frozen',null,'','',1,'','','','',1,null
from DealerMaster 
where DMA_ActiveFlag = 1 and DMA_DeletedFlag = 0 and DMA_HostCompanyFlag = 0
and not exists (select 1 from Warehouse 
where WHM_Type = 'Frozen' and WHM_DMA_ID = DMA_ID)


--新增经销商登录帐号
select newid() as Id, DMA_SAP_CODE+'_01' AS Identity_Code, '请在【个人信息管理】中维护登录人姓名' AS IDENTITY_NAME, DMA_ID as Corp_ID
INTO #TMP_DEALERUSER
from DealerMaster 
where DMA_ActiveFlag = 1 and DMA_DeletedFlag = 0 and DMA_HostCompanyFlag = 0
and not exists (select 1 from Lafite_IDENTITY where identity_type = 'Dealer' and Corp_ID = DMA_ID and DELETE_FLAG = 0)

INSERT INTO Lafite_IDENTITY(ID,IDENTITY_CODE,LOWERED_IDENTITY_CODE,IDENTITY_NAME,BOOLEAN_FLAG,IDENTITY_TYPE,CORP_ID,APP_ID,DELETE_FLAG,
CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE,REV1)
SELECT ID,IDENTITY_CODE,LOWER(IDENTITY_CODE),IDENTITY_NAME,1,'Dealer',CORP_ID,'4028931b0f0fc135010f0fc1356a0001',0,
'00000000-0000-0000-0000-000000000000',GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE(),'D' FROM #TMP_DEALERUSER

INSERT INTO Lafite_Membership(USERID,PASSWORD,PASSWORDFORMAT,PASSWORDSALT,APP_ID,ISAPPROVED,ISLOCKEDOUT,CREATEDATE,
FailedPasswordAnswerAttemptWindowStart,LastLoginDate,LastPasswordChangedDate,LastLockoutDate,FailedPasswordAttemptCount,
FailedPasswordAttemptWindowStart,FailedPasswordAnswerAttemptCount)
SELECT ID,'JwSWJpN51898uJjc7eriHZY/MSc=','1','rcmX5PF2DpzU5uP09ilGuA==','4028931b0f0fc135010f0fc1356a0001',1,0,GETDATE(),
GETDATE(),GETDATE(),GETDATE(),GETDATE(),0,GETDATE(),0
FROM #TMP_DEALERUSER

--经销商个人信息维护
insert into DealerShipTo (
   DST_ID
  ,DST_Dealer_User_ID
  ,DST_Dealer_DMA_ID
  ,DST_ContactPerson
  ,DST_Contact
  ,DST_ContactMobile
  ,DST_Email
  ,DST_Consignee
  ,DST_ShipToAddress
  ,DST_ConsigneePhone
  ,DST_ReceiveSMS
  ,DST_ReceiveEmail
  ,DST_IsDefault
) 
select newid(),Id,Corp_ID,null,null,null,null,null,null,null,0,0,0 
from Lafite_IDENTITY 
where IDENTITY_TYPE = 'Dealer' and DELETE_FLAG = 0
and not exists (select 1 from DealerShipTo
where DST_Dealer_DMA_ID = Corp_ID and DST_Dealer_User_ID = Id)

--经销商默认帐号维护
update DealerShipTo set DealerShipTo.DST_IsDefault = 
case when I.REV1 = 'D' then 1
 else 0 end     
from Lafite_IDENTITY as I
where I.IDENTITY_TYPE = 'Dealer' and I.DELETE_FLAG = 0 and I.Id = DealerShipTo.DST_Dealer_User_ID
and I.Corp_ID = DealerShipTo.DST_Dealer_DMA_ID
and exists (select 1 from DealerShipTo as D
where D.DST_Dealer_DMA_ID = I.Corp_ID and D.DST_Dealer_User_ID = I.Id)

--仓库Code的自动维护
declare @StartCode int
declare @NextCode int
select @StartCode = CAND_NextID - 1 from CodeAutoNbrData where CAND_ATO_Setting = 'Next_WarehouseNbr'
select @NextCode = @StartCode + count(1) + 1 from Warehouse where WHM_Code IS NULL

UPDATE Warehouse SET WHM_Code = 'WH' + REPLICATE('0',6-LEN(WHM_Number))+ CONVERT(NVARCHAR(50),WHM_Number)
FROM (
SELECT WHM_ID,@StartCode + ROW_NUMBER() OVER (ORDER BY DealerMaster.DMA_SAP_Code, Warehouse.WHM_Type) AS WHM_Number FROM Warehouse
INNER JOIN DealerMaster ON DealerMaster.DMA_ID = warehouse.WHM_DMA_ID
WHERE Warehouse.WHM_Code IS NULL
) AS T
WHERE T.WHM_ID = Warehouse.WHM_ID

UPDATE CodeAutoNbrData SET CAND_NextID = @NextCode WHERE CAND_ATO_Setting = 'Next_WarehouseNbr'

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    return -1
    
END CATCH

GO


