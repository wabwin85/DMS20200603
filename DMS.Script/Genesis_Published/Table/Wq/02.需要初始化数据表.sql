Update lafite_dict set value1='http://47.102.205.10/' where dict_type='CONST_CONTRACT_ContractBaseUrl' and dict_key='BaseUrl'
表CFNPrice 索引修改，之前唯一索引现在不唯一

SubBuParam
update [Contract].SubBuParam set IsLP=1

---

--区域经理
insert MDM_Manager values('51-2','123101','北区 吴梦迪','NCM',1)
insert MDM_Manager values('51-2','123102','北区 吴梦迪','RSM',1)
insert MDM_Manager values('61-2','123103','北区 吴梦迪','NCM',1)
insert MDM_Manager values('61-2','123104','北区 吴梦迪','RSM',1)
insert MDM_Manager values('71-2','123105','北区 吴梦迪','NCM',1)
insert MDM_Manager values('71-2','123106','北区 吴梦迪','RSM',1)

--
insert into [Contract].SubBuParam
select CC_Code,2,'Month',1,0,0,1,0
 FROM interface.ClassificationContract
 where not EXISTS(SELECT 1 from [Contract].SubBuParam where subdepid=CC_Code)


update interface.[HospitalMarketProperty] set MarketProperty=2


interface.MDM_EmployeeMaster  

t_DivisionProductLineRelation

interface.MDM_Department









---


INSERT INTO interface.MDM_EmployeeMaster(EID,account,Name,eName,DepID,DepCode,Email,Mobile,status)
select REV1,IDENTITY_CODE,IDENTITY_NAME,IDENTITY_CODE,5,'',EMAIL1,PHONE,1 from Lafite_IDENTITY
where IDENTITY_CODE in(
'liweizhi','lewenqian','wangwenting','wangjun','zhangman','zhaoxiaoyu','jiangling','zhanghao')

INSERT INTO interface.MDM_EmployeeMaster(EID,account,Name,eName,DepID,DepCode,Email,Mobile,status)
select REV1,IDENTITY_CODE,IDENTITY_NAME,IDENTITY_CODE,17,'IC',EMAIL1,PHONE,1 from Lafite_IDENTITY
where IDENTITY_CODE in(
'houzhe','songfang','xiayun','liangjuanjuan','liujuanjuan','zhangyukai')

INSERT INTO interface.MDM_EmployeeMaster(EID,account,Name,eName,DepID,DepCode,Email,Mobile,status)
select REV1,IDENTITY_CODE,IDENTITY_NAME,IDENTITY_CODE,18,'Endo',EMAIL1,PHONE,1 from Lafite_IDENTITY
where IDENTITY_CODE in(
'fanghua','hanwenliang','lipenghua','wangziyan')

INSERT INTO interface.MDM_EmployeeMaster(EID,account,Name,eName,DepID,DepCode,Email,Mobile,status)
select REV1,IDENTITY_CODE,IDENTITY_NAME,IDENTITY_CODE,51,'Ritchey',EMAIL1,PHONE,1 from Lafite_IDENTITY
where IDENTITY_CODE in(
'guoxiaoming','zhangkunpeng','jinzhimin','shenwei','zhudelong','yaoyilin','miaoruojing')