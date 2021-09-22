--插入SiteMap（菜单主表）
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'教程维护',(select menuid from lafite_sitemap where menutitle like '%信息维护|System%'),0,'~/Revolution/Pages/MasterDatas/OperationManualManage.aspx',
1,'M2_OperationManualManage',90,'admin',GetDate())

--插入Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='教程维护'),
'教程维护','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--插入STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','教程维护',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--插入STRATEGY及Resource关联表
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='教程维护'),
'Function',(select id from Lafite_Function where Function_Name='教程维护'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--插入角色(如需要:lafite_attribute  attribute_type:role   attribute_level:3

--插入STRATEGY及角色关联表
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='教程维护'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())