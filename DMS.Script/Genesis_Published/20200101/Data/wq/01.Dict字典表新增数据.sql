--订单操作日志增加接口更新状态
insert into Lafite_DICT (Id,PID,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,READONLY_FLAG,LEAF_FLAG,APP_ID,
SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
values(newid(),'CONST_Order_OperType',1,'CONST_Order_OperType','UpdateOrderStatus','接口更新订单状态',1,0,0,'4028931b0f0fc135010f0fc1356a0001'
,10,0,'admin',getdate(),'admin',getdate())



--发货接口新增运输方式
Alter Table interfaceshipment ADD ISH_ShipType NVARCHAR(200) NULL

