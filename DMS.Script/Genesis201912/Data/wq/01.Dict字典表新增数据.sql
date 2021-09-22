﻿--寄售合同申请
insert into Lafite_DICT (Id,PID,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,READONLY_FLAG,LEAF_FLAG,APP_ID,
SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
values(newid(),'CONST_TemplateId',1,'CONST_TemplateId','ConsignmentContract','16e435486a8777b68cb36b344f6a1611',1,0,0,'4028931b0f0fc135010f0fc1356a0001'
,10,0,'admin',getdate(),'admin',getdate())

--寄售合同终止
insert into Lafite_DICT (Id,PID,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,READONLY_FLAG,LEAF_FLAG,APP_ID,
SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
values(newid(),'CONST_TemplateId',1,'CONST_TemplateId','ConsignmentTermination','16e4549afafcccf209f73c543f4acc31',1,0,0,'4028931b0f0fc135010f0fc1356a0001'
,10,0,'admin',getdate(),'admin',getdate())

--退换货
insert into Lafite_DICT (Id,PID,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,READONLY_FLAG,LEAF_FLAG,APP_ID,
SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
values(newid(),'CONST_TemplateId',1,'CONST_TemplateId','DealerReturn','16e455b9bb876b819a77ff44b5d91ee6',1,0,0,'4028931b0f0fc135010f0fc1356a0001'
,10,0,'admin',getdate(),'admin',getdate())

--CFDA更新
insert into Lafite_DICT (Id,PID,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,READONLY_FLAG,LEAF_FLAG,APP_ID,
SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
values(newid(),'CONST_TemplateId',1,'CONST_TemplateId','DealerLicense','16e4559bb6a7e39f8d861df4c6cab35f',1,0,0,'4028931b0f0fc135010f0fc1356a0001'
,10,0,'admin',getdate(),'admin',getdate())

--寄售申请
insert into Lafite_DICT (Id,PID,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,READONLY_FLAG,LEAF_FLAG,APP_ID,
SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
values(newid(),'CONST_TemplateId',1,'CONST_TemplateId','Consignment','16e453424edf2d98e5e34b44505b0e0e',1,0,0,'4028931b0f0fc135010f0fc1356a0001'
,10,0,'admin',getdate(),'admin',getdate())

