UPDATE dbo.Lafite_SiteMap SET IsEnabled=1 WHERE MenuId='204'
UPDATE dbo.Lafite_SiteMap SET IsEnabled=0 WHERE ParentId='204'

--����SiteMap���˵�����
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'�����̲ɹ�ָ�걨��',204,0,'~/Revolution/Pages/Report/DealerQuota.aspx',
1,'M2_DealerQuotaReport',40,'admin',GetDate())

--����Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='�����̲ɹ�ָ�걨��'),
'�����̲ɹ�ָ�걨��','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--����STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','�����̲ɹ�ָ�걨��',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--����STRATEGY��Resource������
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='�����̲ɹ�ָ�걨��'),
'Function',(select id from Lafite_Function where Function_Name='�����̲ɹ�ָ�걨��'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--�����ɫ(����Ҫ:lafite_attribute  attribute_type:role   attribute_level:3

--����STRATEGY����ɫ������
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='�����̲ɹ�ָ�걨��'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='��������Ա' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='�����̲ɹ�ָ�걨��'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())

------------------------------------------------------------------------------------------


--����SiteMap���˵�����
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'������ҽԺָ�걨��',204,0,'~/Revolution/Pages/Report/DealerHospitalQuota.aspx',
1,'M2_DealerHospitalQuotaReport',40,'admin',GetDate())

--����Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='������ҽԺָ�걨��'),
'������ҽԺָ�걨��','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--����STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','������ҽԺָ�걨��',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--����STRATEGY��Resource������
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='������ҽԺָ�걨��'),
'Function',(select id from Lafite_Function where Function_Name='������ҽԺָ�걨��'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--�����ɫ(����Ҫ:lafite_attribute  attribute_type:role   attribute_level:3

--����STRATEGY����ɫ������
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='������ҽԺָ�걨��'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='��������Ա' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='������ҽԺָ�걨��'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())


-----------------------------------------------------------------------------------

--������ʽ
UPDATE dbo.Lafite_SiteMap SET IsEnabled=1 WHERE MenuTitle= '�����̺�ͬ����'

--�ݿ���ʽ

/*
--����SiteMap���˵�����
insert into lafite_sitemap(MenuType,MenuLevel,MenuTitle,ParentId,IsLinked,Url,
IsEnabled,PowerKey,OrderBy,LastUpdate,LastUpdateDate)
Values('Menu',2,'�����̺�ͬ����',204,0,'~/Revolution/Pages/Report/DealerHospitalQuota.aspx',
1,'M2_DealerHospitalQuotaReport',40,'admin',GetDate())

--����Resource
insert into Lafite_Function(Id,Function_Code,Function_Name,Function_Group,OPeration,
Description,Function_Type,BOOLEAN_Flag,APP_ID,DELETE_FLag,Create_User,Create_Date,
Last_Update_User,Last_Update_Date)
Values(newid(),(Select PowerKey From lafite_sitemap WHERE MenuType='Menu' AND MenuTitle='�����̺�ͬ����'),
'�����̺�ͬ����','',0,'','Menu',1,'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),
'admin',GetDate())

--����STRATEGY
insert into lafite_STRATEGY(Id,pid,level,strategy_name,boolean_flag,Description,
app_id,sort_col,DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),'','','�����̺�ͬ����',1,'','4028931b0f0fc135010f0fc1356a0001',0,
0,'admin',GetDate(),'admin',GetDate())

--����STRATEGY��Resource������
insert into Lafite_STRATEGY_MAP(id,STRATEGY_ID,MAP_Type,Map_ID,Permission,App_ID,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
Values(newid(),(Select id from lafite_STRATEGY where strategy_name='�����̺�ͬ����'),
'Function',(select id from Lafite_Function where Function_Name='�����̺�ͬ����'),0,
'4028931b0f0fc135010f0fc1356a0001',0,'admin',GetDate(),'admin',GetDate())

--�����ɫ(����Ҫ:lafite_attribute  attribute_type:role   attribute_level:3

--����STRATEGY����ɫ������
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='Administrators' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='�����̺�ͬ����'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())
insert into lafite_attribute_map(id,attribute_id,MAP_Type,Map_ID,app_id,sort_col,
DELETE_FLag,Create_User,Create_Date,Last_Update_User,Last_Update_Date)
values(newid(),(select id from lafite_attribute where attribute_name='��������Ա' and attribute_type='Role')
,'STRATEGY',(Select id from lafite_STRATEGY where strategy_name='�����̺�ͬ����'),
'4028931b0f0fc135010f0fc1356a0001',0,0,'admin',GetDate(),'admin',GetDate())
*/