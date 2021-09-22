--寄售申请
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Consignment/ConsignmentApplyHeaderList.aspx' WHERE MenuId=(
SELECT MenuId FROM dbo.Lafite_SiteMap  WHERE  MenuTitle LIKE '%经销商寄售申请%'
)
--经销商收货
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/POReceipt/POReceiptList.aspx ' WHERE MenuId=(
SELECT MenuId FROM dbo.Lafite_SiteMap  WHERE  MenuTitle LIKE '%经销商收货|Goods Receipt%'
)
--短期寄售授权

UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/MasterDatas/ConsignmentAuthorizationList.aspx ' WHERE MenuId=(
SELECT MenuId FROM dbo.Lafite_SiteMap  WHERE  MenuTitle LIKE '%短期寄售授权%'
)
--发货错误数据查询
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/POReceipt/DeliveryNoteList.aspx ' WHERE MenuId=(
SELECT MenuId FROM dbo.Lafite_SiteMap  WHERE  MenuTitle LIKE '%发货错误数据查询|Error Delivery Data Query%'
)
--短期寄售规则维护
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/MasterDatas/ConsignmentMasterList.aspx' WHERE MenuId=(
SELECT MenuId FROM dbo.Lafite_SiteMap  WHERE  MenuTitle LIKE '%短期寄售规则维护'
)
--经销商移库
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Transfer/TransferEditor.aspx' WHERE MenuId=(
SELECT MenuId FROM dbo.Lafite_SiteMap  WHERE  MenuTitle LIKE '%经销商移库|Stock Transfer'
)
--借货出库
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Transfer/TransferList.aspx' WHERE MenuId=(
SELECT MenuId FROM dbo.Lafite_SiteMap  WHERE  MenuTitle LIKE '%借货出库|Stock Borrow'
)
--退换货申请
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Inventory/InventoryReturn.aspx' WHERE MenuId=(
SELECT MenuId FROM dbo.Lafite_SiteMap  WHERE  MenuTitle LIKE '%退换货申请|Goods Return Apply'
)
--二级经销商订单申请
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Order/OrderApply.aspx' WHERE MenuId=(
SELECT MenuId FROM dbo.Lafite_SiteMap  WHERE  MenuTitle LIKE '%二级经销商订单申请|Order For Tier2'
)
--平台及一级经销商订单申请
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Order/OrderApplyLP.aspx'  WHERE MenuId=(
SELECT MenuId FROM dbo.Lafite_SiteMap  WHERE  MenuTitle LIKE '%平台及一级经销商订单申请|Order For Tier1&LP'
)

--库存查询
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Inventory/QueryInventoryPage.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%库存查询|Inventory%')
--仓库维护
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Inventory/WarehouseMaint.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%仓库维护|Warehouse%')
--经销商信息维护
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/MasterDatas/DealerMaintainList.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%经销商信息汇总维护%')
--医院信息维护
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/MasterDatas/HospitalList.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%医院信息维护%') 
--销售出库单
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Shipment/ShipmentList.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%销售出库单|In%') 
--销售打印设定
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Shipment/ShipmentPrintSetting.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%销售单打印设定|Sales%') 
--销售数据批量上传
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Shipment/ShipmentInitList.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%销售数据批量上传|In%') 
--退换货额度管理
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Inventory/ReturnPositionSearch.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%退货额度管理%') 
--期初库存导入
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/MasterDatas/InventoryInit.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%期初库存导入|Inv%') 

--新增分销出库开始

--插入SiteMap（菜单主表）
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'分销出库',(select menuid from lafite_sitemap where menutitle like '%销售管理|Sales%'),0,'~/Revolution/Pages/Transfer/TransferDistributionList.aspx',
1,'M2_TransferDistributionList',40,'admin',GetDate())

--插入Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='分销出库'),
'分销出库','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--插入STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','分销出库',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--插入STRATEGY及Resource关联表
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='分销出库'),
'Function',(select id from Lafite_Function where Function_Name='分销出库'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--插入角色(如需要:lafite_attribute  attribute_type:role   attribute_level:3

--插入STRATEGY及角色关联表
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='分销出库'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())

insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='LP销售管理' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='分销出库'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())

insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='一级销售管理' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='分销出库'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())


--新增分销出库结束

--平台接口日志查询
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/DataInterface/InterfaceLogList.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%平台接口日志查询%') 
--经销商信息披露
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Contract/ContractMain.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%经销商信息披露%') 
--冻结库解冻
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Transfer/TransferUnfreeze.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%冻结库解冻%') 
--二维码产品数据收集
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Inventory/InventoryQROperation.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%二维码产品数据收集%') 
--第三方信息披露查询
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Contract/ThirdPartyQueryForGenesis.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%第三方信息披露查询%') 
--经销商产品查询
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/DCM/DealerProductSearch.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%经销商产品查询|Product%') 
--经销商指标查询
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/AOP/DealerAOPSearch.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%经销商指标查询%')
--医院指标查询
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/AOP/HospitalAOPSearch.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%医院指标查询%')  
--平台下载接口装态调整
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/DataInterface/InterfaceDataList.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%平台下载接口状态调整%')  
--后台操作日志查询
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Log/Lafite_LogList.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%后台操作日志查询%')   
--经销商通告维护
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/DCM/BulletinManage.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%经销商通知和公告维护|Notification%') 


--插入SiteMap（菜单主表）
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url
	,IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'用户信息维护',(select menuid from lafite_sitemap where menutitle like '%信息维护|System%'),0,'~/Revolution/Pages/MasterDatas/UserList.aspx',
	1,'M2_MasterDatasUserList',60,'admin',GetDate())


--插入Resource
insert into Lafite_Function(Id,Function_Code
	,Function_Name,Function_Group,OPeration,[DESCRIPTION],Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date
	,Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='用户信息维护')
	,'用户信息维护','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate()
	,'admin',GetDate())

--插入STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,[Description],app_id,sort_col
	,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','用户信息维护',1,'','4028931b0f0fc135010f0fc1356a0001',0
	,0,'admin',GetDate(),'admin',GetDate())


--插入STRATEGY及Resource关联表
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='用户信息维护'),
'Function',(select id from Lafite_Function where Function_Name='用户信息维护'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='用户信息维护'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())  

--库存数据上传
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/Inventory/InventoryImport.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle LIKE '%库存数据上传|Inventory%') 
--产品分类
UPDATE   dbo.Lafite_SiteMap SET url='~/Revolution/Pages/MasterDatas/PartsClsfcList.aspx' WHERE MenuId=(SELECT MenuId FROM dbo.Lafite_SiteMap WHERE MenuTitle ='产品分类') 
