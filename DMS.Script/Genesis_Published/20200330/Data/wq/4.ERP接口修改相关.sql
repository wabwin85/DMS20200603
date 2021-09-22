﻿ALTER TABLE InterfaceShipment ADD ISH_ERPLineNbr [NVARCHAR](50) NULL
ALTER TABLE InterfaceShipment ADD ISH_ERPAmount [DECIMAL](18, 6) NULL
ALTER TABLE InterfaceShipment ADD ISH_ERPTaxRate [DECIMAL](6, 2) NULL
ALTER TABLE InterfaceShipment ADD ISH_ERPNbr [NVARCHAR](50) NULL

ALTER TABLE POReceiptLot ADD PRL_ERPLineNbr [NVARCHAR](50) NULL
ALTER TABLE POReceiptLot ADD PRL_ERPAmount [DECIMAL](18, 6) NULL
ALTER TABLE POReceiptLot ADD PRL_ERPTaxRate [DECIMAL](6, 2) NULL
ALTER TABLE POReceiptLot ADD PRL_ERPNbr [NVARCHAR](50) NULL


ALTER TABLE dbo.InventoryAdjustLot ADD IAL_ERPLineNbr [NVARCHAR](50) NULL
ALTER TABLE dbo.InventoryAdjustLot ADD IAL_ERPNbr [NVARCHAR](50) NULL


--字典表新增进入ERP状态
insert into Lafite_DICT (Id,PID,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,READONLY_FLAG,LEAF_FLAG,APP_ID,
SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
values(newid(),'CONST_AdjustQty_Status',1,'CONST_AdjustQty_Status','INERP','已进入ERP',1,0,0,'4028931b0f0fc135010f0fc1356a0001'
,10,0,'admin',getdate(),'admin',getdate())