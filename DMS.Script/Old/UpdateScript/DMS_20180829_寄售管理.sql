CREATE SCHEMA Consignment
GO
--寄售合同主表
create table Consignment.ContractHeader (
   CCH_ID               uniqueidentifier     not null,
   CCH_DMA_ID           uniqueidentifier     null,
   CCH_No               varchar(50)          null,
   CCH_Name             nvarchar(200)        null,
   CCH_ProductLine_BUM_ID uniqueidentifier     null,
   CCH_Status           varchar(50)          null,
   CCH_ConsignmentDay   int                  null,
   CCH_DelayNumber      int                  null,
   CCH_BeginDate        datetime             null,
   CCH_EndDate          datetime             null,
   CCH_IsFixedMoney     bit                  null,
   CCH_IsFixedQty       bit                  null,
   CCH_IsKB             bit                  null,
   CCH_IsUseDiscount    bit                  null,
   CCH_Remark           nvarchar(Max)        null,
   CCH_CreateUser       uniqueidentifier     null,
   CCH_CreateDate       datetime             null,
   constraint PK_CONTRACTHEADER primary key (CCH_ID)
)
go
--寄售合同明细表
create table Consignment.ContractDetail (
   CCD_ID               uniqueidentifier     not null,
   CCD_CCH_ID           uniqueidentifier     not null,
   CCD_CfnShortNumber   varchar(100)         null,
   CCD_CfnType          varchar(100)         null,
   CCD_Remark           nvarchar(Max)        null,
   constraint PK_CONTRACTDETAIL primary key (CCD_ID)
)
go

--log
create table Consignment.ConsignmentOperLog (
   LogId                uniqueidentifier     not null,
   MainId               uniqueidentifier     null,
   OperUser             varchar(50)          null,
   OperUserEN           varchar(50)          null,
   OperDate             datetime             null,
   OperType             varchar(20)          null,
   OperNote             varchar(2000)        null,
   OperRole             varchar(100)         null,
   constraint PK_CONSIGNMENTOPERLOG primary key (LogId)
)
go

--合同申请
insert into AutoNumber (ATO_Setting,ATO_ParentTable,ATO_ParentField,ATO_DefaultNextID,ATO_DefaultPrefix)values('ContractHeader','','',1,'CASTC')
--合同终止
insert into AutoNumber (ATO_Setting,ATO_ParentTable,ATO_ParentField,ATO_DefaultNextID,ATO_DefaultPrefix)values('ConsignmentTermination','','',1,'CST')
--寄售转移
insert into AutoNumber (ATO_Setting,ATO_ParentTable,ATO_ParentField,ATO_DefaultNextID,ATO_DefaultPrefix)values('ConsignTrnsfer','','',1,'CSTT')

insert into Lafite_DICTTYPE 
select 'Consignment_ContractHeader_Status','ContractHeader','ContractHeader',0,'4028931b0f0fc135010f0fc1356a0001',0

insert into Lafite_DICT
select NEWID(),null,1,'Consignment_ContractHeader_Status','Draft','草稿',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',0,0,'mmbo',GETDATE(),'mmbo',GETDATE()

insert into Lafite_DICT
select NEWID(),null,1,'Consignment_ContractHeader_Status','InApproval','审批中',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',1,0,'mmbo',GETDATE(),'mmbo',GETDATE()

insert into Lafite_DICT
select NEWID(),null,1,'Consignment_ContractHeader_Status','Completed','审批完成',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',2,0,'mmbo',GETDATE(),'mmbo',GETDATE()
insert into Lafite_DICT
select NEWID(),null,1,'Consignment_ContractHeader_Status','Deny','审批拒绝',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',3,0,'mmbo',GETDATE(),'mmbo',GETDATE()


insert into Lafite_DICTTYPE 
select 'Consignment_ConsignmentTermination_Status','ConsignmentTermination','ConsignmentTermination',0,'4028931b0f0fc135010f0fc1356a0001',0
insert into Lafite_DICT
select NEWID(),null,1,'Consignment_ConsignmentTermination_Status','Termination','合同终止',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',0,0,'mmbo',GETDATE(),'mmbo',GETDATE()
insert into Lafite_DICT
select NEWID(),null,1,'Consignment_ConsignmentTermination_Status','Draft','草稿',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',1,0,'mmbo',GETDATE(),'mmbo',GETDATE()
insert into Lafite_DICT
select NEWID(),null,1,'Consignment_ConsignmentTermination_Status','InApproval','审批中',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',2,0,'mmbo',GETDATE(),'mmbo',GETDATE()
insert into Lafite_DICT
select NEWID(),null,1,'Consignment_ConsignmentTermination_Status','Approved','审批完成',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',3,0,'mmbo',GETDATE(),'mmbo',GETDATE()
insert into Lafite_DICT
select NEWID(),null,1,'Consignment_ConsignmentTermination_Status','Deny','审批拒绝',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',4,0,'mmbo',GETDATE(),'mmbo',GETDATE()

insert into Lafite_DICT
select NEWID(),null,1,'CONST_AdjustQty_Type','ForceCTOS','强制寄售买断',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',7,0,'mmbo',GETDATE(),'mmbo',GETDATE()

insert into Lafite_DICT
select NEWID(),null,1,'CONST_AdjustQty_Type','SalesOut','销售出库',null,null,1,0,0,null,null,null,null,'4028931b0f0fc135010f0fc1356a0001',8,0,'mmbo',GETDATE(),'mmbo',GETDATE()

UPDATE lafite_dict  set  REV1='CONST' where dict_type='CONST_AdjustQty_Type'   and  DICT_KEY in ('CTOS','ForceCTOS','SalesOut')

--寄售买断添加销售人员
alter table InventoryAdjustHeader add SaleRep nvarchar(50)
alter table InventoryAdjustLot add IAL_Remark nvarchar(500)
--寄售买断CTOS类型名称修改
update Lafite_DICT set VALUE1='经销商申请买断' where id='04EC3E32-1C45-440D-8BEF-3276C8C3348B'

--寄售转移状态
DELETE Lafite_DICT WHERE DICT_TYPE = 'Consignment_ConsignTransfer_Status';
DELETE Lafite_DICTTYPE WHERE DICT_TYPE = 'Consignment_ConsignTransfer_Status';
INSERT INTO Lafite_DICTTYPE (DICT_TYPE,DICT_TYPE_NAME,DESCRIPTION,SORT_COL,APP_ID,SYS_FLAG) 
VALUES ('Consignment_ConsignTransfer_Status','寄售转移状态','',0,'4028931b0f0fc135010f0fc1356a0001',0);
INSERT INTO dbo.Lafite_DICT (Id,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,APP_ID,SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
VALUES (newid(),1,'Consignment_ConsignTransfer_Status','Draft','草稿',1,'4028931b0f0fc135010f0fc1356a0001',1,0,'mmbo',getdate(),'mmbo',getdate());
INSERT INTO dbo.Lafite_DICT (Id,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,APP_ID,SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
VALUES (newid(),1,'Consignment_ConsignTransfer_Status','Confirming','待确认',1,'4028931b0f0fc135010f0fc1356a0001',2,0,'mmbo',getdate(),'mmbo',getdate());
INSERT INTO dbo.Lafite_DICT (Id,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,APP_ID,SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
VALUES (newid(),1,'Consignment_ConsignTransfer_Status','InApproval','审批中',1,'4028931b0f0fc135010f0fc1356a0001',3,0,'mmbo',getdate(),'mmbo',getdate());
INSERT INTO dbo.Lafite_DICT (Id,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,APP_ID,SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
VALUES (newid(),1,'Consignment_ConsignTransfer_Status','Completed','审批通过',1,'4028931b0f0fc135010f0fc1356a0001',4,0,'mmbo',getdate(),'mmbo',getdate());
INSERT INTO dbo.Lafite_DICT (Id,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,APP_ID,SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
VALUES (newid(),1,'Consignment_ConsignTransfer_Status','Deny','审批拒绝',1,'4028931b0f0fc135010f0fc1356a0001',5,0,'mmbo',getdate(),'mmbo',getdate());



CREATE TABLE Platform_SystemManual
(
	ManualId    INT,
	ManualName  NVARCHAR(100),
	ManualUrl   NVARCHAR(500),
	ManualType  NVARCHAR(10),
	IsActive    BIT,
	PRIMARY KEY(ManualId)
)
GO

INSERT INTO Platform_SystemManual VALUES (100,'DMS操作流程图','https://bscdealer.cn/resources/images/DMSProcess.jpg', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (200,'T1订单详情','http://mudu.tv/show/videolink2/360848/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (300,'T2订单申请','http://mudu.tv/show/videolink2/360852/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (400,'仓库维护','http://mudu.tv/show/videolink2/360853/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (500,'借货出库','http://mudu.tv/show/videolink2/360854/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (600,'经销商产品查询','http://mudu.tv/show/videolink2/360864/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (700,'经销商合同','http://mudu.tv/show/videolink2/360866/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (800,'经销商合同（CO）','http://mudu.tv/show/videolink2/360865/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (900,'经销商库存调整报表','http://mudu.tv/show/videolink2/360849/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (1000,'经销商收货数据报表','http://mudu.tv/show/videolink2/360850/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (1100,'经销商销售报表','http://mudu.tv/show/videolink2/360851/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (1200,'经销商信息汇总维护','http://mudu.tv/show/videolink2/360870/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (1300,'经销商信息披露','http://mudu.tv/show/videolink2/360871/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (1400,'经销商指标查询','http://mudu.tv/show/videolink2/360867/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (1500,'库存查询','http://mudu.tv/show/videolink2/360858/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (1600,'批量上传销量','http://mudu.tv/show/videolink2/360863/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (1700,'其他出库','http://mudu.tv/show/videolink2/360856/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (1800,'收货','http://mudu.tv/show/videolink2/360860/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (1900,'投诉退换货','http://mudu.tv/show/videolink2/360859/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (2000,'退换货申请','http://mudu.tv/show/videolink2/360861/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (2100,'微信用户查询','http://mudu.tv/show/videolink2/360868/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (2200,'销售出库单','http://mudu.tv/show/videolink2/360862/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (2300,'医院指标查询','http://mudu.tv/show/videolink2/360869/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (2400,'如何扫码移库','http://mudu.tv/show/videolink2/361336/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (2500,'如何上传二维码照片作为支持件','http://mudu.tv/show/videolink2/361335/origin', 'Dealer', 1);
INSERT INTO Platform_SystemManual VALUES (2600,'二级经销商采购预测','http://mudu.tv/show/videolink2/220260/origin', 'Dealer', 1);

--寄售申请主表增加字段
ALTER TABLE ConsignmentApplyHeader ADD CAH_IsFixedMoney BIT NULL
ALTER TABLE ConsignmentApplyHeader ADD CAH_IsFixedQty BIT NULL
ALTER TABLE ConsignmentApplyHeader ADD CAH_IsKB BIT NULL
ALTER TABLE ConsignmentApplyHeader ADD CAH_IsUseDiscount BIT NULL

--寄售转移申请主表
create table Consignment.TransferHeader (
   TH_ID                uniqueidentifier     not null,
   TH_DMA_ID_To         uniqueidentifier     null,--移入经销商ID
   TH_DMA_ID_From       uniqueidentifier     null,--移出经销商ID
   TH_No                varchar(50)          null,--申请单号
   TH_ProductLine_BUM_ID uniqueidentifier     null,--产品线
   TH_CCH_ID            uniqueidentifier     null,--寄售合同ID
   TH_Status            varchar(50)          null,--申请状态
   TH_HospitalId        uniqueidentifier     null,--医院
   TH_Remark            nvarchar(Max)        null,--寄售原因
   TH_SalesAccount      varchar(50)          null,--波科销售
   TH_CreateUser        uniqueidentifier     null,--提交人
   TH_CreateDate        datetime             null,--提交时间
   constraint PK_TRANSFERHEADER primary key (TH_ID)
)
go

--寄售转移申请明细表
create table Consignment.TransferDetail (
   TD_ID                uniqueidentifier     not null,
   TD_TH_ID             uniqueidentifier     not null,--主表ID
   TD_CFN_ID            uniqueidentifier     null,--产品ID
   TD_UOM               nvarchar(100)        null,--单位
   TD_QTY               decimal(18,6)        null,--申请数量
   TD_CFN_Price         decimal(18,6)        null,--单价
   TD_Amount            decimal(18,6)        null,--金额
   constraint PK_TRANSFERTDETAIL primary key (TD_ID)
)
go

--寄售转移申请确认表
create table Consignment.TransferConfirm (
   TC_ID                uniqueidentifier     not null,
   TC_TD_ID             uniqueidentifier     not null,--寄售转移申请明细表ID
   TC_WHM_ID            uniqueidentifier     null,--移出仓位
   TC_PMA_ID            uniqueidentifier     null,--确认产品ID
   TC_LOT_ID            uniqueidentifier     null,--批次/二维码信息
   TC_QTY               decimal(18,6)        null,--确认转移数量
   TC_ConfirmUser       uniqueidentifier     null,--确认人
   TC_ConfirmDate       datetime             null,--确认时间
   constraint PK_TRANSFERTCONFIRM primary key (TC_ID)
)
go
