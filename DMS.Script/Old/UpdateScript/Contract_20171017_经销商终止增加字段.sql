ALTER TABLE [Contract].TerminationHandover ADD FollowUp INT;
ALTER TABLE [Contract].TerminationHandover ADD FollowUpRemark NVARCHAR(250);
ALTER TABLE [Contract].TerminationHandover ADD FieldOperation INT;
ALTER TABLE [Contract].TerminationHandover ADD FieldOperationRemark NVARCHAR(250);
ALTER TABLE [Contract].TerminationHandover ADD AdverseEvent INT;
ALTER TABLE [Contract].TerminationHandover ADD AdverseEventRemark NVARCHAR(250);
ALTER TABLE [Contract].TerminationHandover ADD SubmitImplant INT;
ALTER TABLE [Contract].TerminationHandover ADD SubmitImplantRemark DATETIME;
ALTER TABLE [Contract].TerminationHandover ADD InventoryDispose NVARCHAR(20);
ALTER TABLE [Contract].TerminationHandover ADD InventoryDisposeRemark1 NVARCHAR(250);
ALTER TABLE [Contract].TerminationHandover ADD InventoryDisposeRemark2 NVARCHAR(250);

--代理商库存产品处置情况
DELETE Lafite_DICT WHERE DICT_TYPE = 'CONST_CONTRACT_InventoryDispose';
DELETE Lafite_DICTTYPE WHERE DICT_TYPE = 'CONST_CONTRACT_InventoryDispose';
INSERT INTO Lafite_DICTTYPE (DICT_TYPE,DICT_TYPE_NAME,DESCRIPTION,SORT_COL,APP_ID,SYS_FLAG) 
VALUES ('CONST_CONTRACT_InventoryDispose','代理商库存产品处置情况','',0,'4028931b0f0fc135010f0fc1356a0001',0);
INSERT INTO dbo.Lafite_DICT (Id,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,APP_ID,SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
VALUES (newid(),1,'CONST_CONTRACT_InventoryDispose','BSC','退回波科',1,'4028931b0f0fc135010f0fc1356a0001',1,0,'mmbo',getdate(),'mmbo',getdate());
INSERT INTO dbo.Lafite_DICT (Id,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,APP_ID,SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
VALUES (newid(),1,'CONST_CONTRACT_InventoryDispose','Dealer','转移给其他代理商',1,'4028931b0f0fc135010f0fc1356a0001',2,0,'mmbo',getdate(),'mmbo',getdate());
INSERT INTO dbo.Lafite_DICT (Id,DICT_LEVEL,DICT_TYPE,DICT_KEY,VALUE1,ACTIVE_FLAG,APP_ID,SORT_COL,DELETE_FLAG,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
VALUES (newid(),1,'CONST_CONTRACT_InventoryDispose','Other','其他',1,'4028931b0f0fc135010f0fc1356a0001',3,0,'mmbo',getdate(),'mmbo',getdate());

--[Workflow].[Proc_Contract_Termination_GetHtmlData]