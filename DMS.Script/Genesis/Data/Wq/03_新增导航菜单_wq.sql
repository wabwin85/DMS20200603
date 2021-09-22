--插入SiteMap（菜单主表）
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'寄售总量规则维护',333,0,'~/Revolution/Pages/Consign/ConsignCountManage.aspx',
1,'M2_ConsignCountManage',40,'admin',GetDate())

--插入Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='寄售总量规则维护'),
'寄售总量规则维护','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--插入STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','寄售总量规则维护',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--插入STRATEGY及Resource关联表
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='寄售总量规则维护'),
'Function',(select id from Lafite_Function where Function_Name='寄售总量规则维护'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--插入角色(如需要:lafite_attribute  attribute_type:role   attribute_level:3

--插入STRATEGY及角色关联表
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='寄售总量规则维护'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())

insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='经销商短期寄售管理员' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='寄售总量规则维护'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())




--插入SiteMap（菜单主表）  价格规则维护
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'产品价格维护',68,0,'~/Revolution/Pages/MasterDatas/OrderDealerPrice.aspx',
1,'M2_CFNPriceManage',40,'admin',GetDate())

--插入Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='产品价格维护'),
'产品价格维护','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--插入STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','产品价格维护',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--插入STRATEGY及Resource关联表
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='产品价格维护'),
'Function',(select id from Lafite_Function where Function_Name='产品价格维护'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--插入角色(如需要:lafite_attribute  attribute_type:role   attribute_level:3

--插入STRATEGY及角色关联表
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='产品价格维护'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())




--插入SiteMap（菜单主表）  寄售组套维护
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'寄售组套维护',68,0,'~/Revolution/Pages/MasterDatas/ConsignmentCfnSetList.aspx',
1,'M2_ConsignmentCfnSet',40,'admin',GetDate())

--插入Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='寄售组套维护'),
'寄售组套维护','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--插入STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','寄售组套维护',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--插入STRATEGY及Resource关联表
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='寄售组套维护'),
'Function',(select id from Lafite_Function where Function_Name='寄售组套维护'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--插入角色(如需要:lafite_attribute  attribute_type:role   attribute_level:3

--插入STRATEGY及角色关联表
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='寄售组套维护'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())



--插入SiteMap（菜单主表）  上传背调报告
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'经销商背调',68,0,'~/Revolution/Pages/MasterDatas/DealerMaintainListForDD.aspx',
1,'M2_UploadDDReport',40,'admin',GetDate())
--插入Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='经销商背调'),
'经销商背调','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--插入STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','经销商背调',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--插入STRATEGY及Resource关联表
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='经销商背调'),
'Function',(select id from Lafite_Function where Function_Name='经销商背调'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--插入角色(如需要:lafite_attribute  attribute_type:role   attribute_level:3
insert into lafite_attribute(id,ATTRIBUTE_NAME,ATTRIBUTE_TYPE,BOOLEAN_FLAG,DESCRIPTION,ATTRIBUTE_LEVEL,APP_ID
,SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
VALUES(newid(),'第三方账号','Role',1,'第三方账号，用以上传背调报告',3,'4028931b0f0fc135010f0fc1356a0001'
,0,0,'admin',GetDate(),'admin',GetDate())

--插入STRATEGY及角色关联表
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='第三方账号' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='经销商背调'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())
--插入STRATEGY及角色关联表
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='第三方账号' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='信息维护'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())


				
