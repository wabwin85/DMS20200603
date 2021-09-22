UPDATE dbo.Lafite_SiteMap SET IsEnabled=1 WHERE MenuId='204'
UPDATE dbo.Lafite_SiteMap SET IsEnabled=0 WHERE ParentId='204'

--插入SiteMap（菜单主表）
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'经销商采购指标报表',204,0,'~/Revolution/Pages/Report/DealerQuota.aspx',
1,'M2_DealerQuotaReport',40,'admin',GetDate())

--插入Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='经销商采购指标报表'),
'经销商采购指标报表','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--插入STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','经销商采购指标报表',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--插入STRATEGY及Resource关联表
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='经销商采购指标报表'),
'Function',(select id from Lafite_Function where Function_Name='经销商采购指标报表'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--插入角色(如需要:lafite_attribute  attribute_type:role   attribute_level:3

--插入STRATEGY及角色关联表
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='经销商采购指标报表'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='渠道管理员' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='经销商采购指标报表'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())

------------------------------------------------------------------------------------------


--插入SiteMap（菜单主表）
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'经销商医院指标报表',204,0,'~/Revolution/Pages/Report/DealerHospitalQuota.aspx',
1,'M2_DealerHospitalQuotaReport',40,'admin',GetDate())

--插入Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='经销商医院指标报表'),
'经销商医院指标报表','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--插入STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','经销商医院指标报表',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--插入STRATEGY及Resource关联表
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='经销商医院指标报表'),
'Function',(select id from Lafite_Function where Function_Name='经销商医院指标报表'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--插入角色(如需要:lafite_attribute  attribute_type:role   attribute_level:3

--插入STRATEGY及角色关联表
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='经销商医院指标报表'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='渠道管理员' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='经销商医院指标报表'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())


-----------------------------------------------------------------------------------

--蓝威正式
UPDATE dbo.Lafite_SiteMap SET IsEnabled=1 WHERE MenuTitle= '经销商合同报表'

--惠康正式

/*
--插入SiteMap（菜单主表）
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'经销商合同报表',204,0,'~/Revolution/Pages/Report/DealerHospitalQuota.aspx',
1,'M2_DealerHospitalQuotaReport',40,'admin',GetDate())

--插入Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='经销商合同报表'),
'经销商合同报表','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--插入STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','经销商合同报表',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--插入STRATEGY及Resource关联表
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='经销商合同报表'),
'Function',(select id from Lafite_Function where Function_Name='经销商合同报表'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--插入角色(如需要:lafite_attribute  attribute_type:role   attribute_level:3

--插入STRATEGY及角色关联表
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='经销商合同报表'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='渠道管理员' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='经销商合同报表'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())
*/