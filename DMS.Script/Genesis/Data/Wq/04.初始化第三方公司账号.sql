--初始化第三方账号
DECLARE @IDENTITY_ID uniqueidentifier;
SET @IDENTITY_ID=NEWID();
INSERT INTO Lafite_IDENTITY 
			(Id,IDENTITY_CODE,LOWERED_IDENTITY_CODE,IDENTITY_NAME,
			BOOLEAN_FLAG,IDENTITY_TYPE,LastActivityDate,Corp_ID,APP_ID,DELETE_FLAG,
			CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE,PHONE,EMAIL1)
		VALUES(@IDENTITY_ID,'UploadDDUser_01','uploaddduser_01','背调专用账户',
			1,'User',getdate(),null,'4028931b0f0fc135010f0fc1356a0001',0,
			'00000000-0000-0000-0000-000000000000',GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE(),'18266666666','123@qq.com');
				
							
INSERT INTO dbo.Lafite_Membership
values(@IDENTITY_ID,'uP+EbopPTG0B39oyAiK4xObGIpI=','1','0CUL9PVxpraROvtfgwOTnQ==',
null,'','',null,null,'4028931b0f0fc135010f0fc1356a0001',1,0,GETDATE(),GETDATE(),'j3Mj1nPQ5V3HA5wvn6CvSvMq0qY=',GETDATE(),GETDATE(),0,GETDATE(),'0',GETDATE(),null)
							
--分配权限（不分一二级）
insert into [dbo].[Lafite_IDENTITY_MAP]([Id],[IDENTITY_ID],[MAP_TYPE],[MAP_ID],[APP_ID],[DELETE_FLAG],[CREATE_USER],[CREATE_DATE],[LAST_UPDATE_USER],[LAST_UPDATE_DATE]) 
values (NEWID(),@IDENTITY_ID,'Role',(select id from lafite_attribute where attribute_name='第三方账号' and attribute_type='Role'),'4028931b0f0fc135010f0fc1356a0001','0','Administrator',GETDATE(),'Administrator',GETDATE());
				