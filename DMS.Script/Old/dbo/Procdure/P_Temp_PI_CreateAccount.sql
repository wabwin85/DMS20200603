DROP Procedure [dbo].[P_Temp_PI_CreateAccount]
GO


CREATE Procedure [dbo].[P_Temp_PI_CreateAccount]
@BlueAccount NVARCHAR(100),
@DealerType NVARCHAR(50),
@LPAccount NVARCHAR(100)
	 
AS

	DECLARE @DEALERNAME NVARCHAR(200)
	DECLARE @SAPCode NVARCHAR(200)
	DECLARE @DealerID uniqueidentifier

SET NOCOUNT ON
BEGIN  
	
	SELECT @DEALERNAME=DMA_ChineseName FROM DealerMaster A WHERE A.DMA_SAP_Code=@BlueAccount
	IF not EXISTS(SELECT 1 FROM DealerMaster a inner join DealerMaster b on a.DMA_Parent_DMA_ID=b.DMA_ID WHERE a.DMA_ChineseName =@DEALERNAME AND a.DMA_DealerType=@DealerType and b.DMA_SAP_Code=@LPAccount and a.DMA_ActiveFlag=1)
	BEGIN
		IF @DealerType='T2'
		BEGIN
			IF(@LPAccount IS NOT NULL)
			BEGIN
				DECLARE @Parent_DMA_ID uniqueidentifier
				SELECT @Parent_DMA_ID=DMA_ID FROM DealerMaster WHERE DMA_SAP_CODE=@LPAccount;
				--DRM要求这样修改
				SELECT @SAPCode=MAX(DealerMaster.DMA_SAP_Code)+1 FROM DealerMaster WHERE DealerMaster.DMA_DealerType='T2' AND DMA_Parent_DMA_ID=@Parent_DMA_ID;
				IF @Parent_DMA_ID='A00FCD75-951D-4D91-8F24-A29900DA5E85'
				BEGIN
					IF @SAPCode='3000' 
					BEGIN
						--方程由2开头转到6开头
						SET @SAPCode='6000'
					END
				END
				IF @Parent_DMA_ID='84C83F71-93B4-4EFD-AB51-12354AFABAC3'
				BEGIN
					IF	@SAPCode='4000'
					BEGIN
						--国科由3开头转到7开头
						SET @SAPCode='7000'
					END
				END
			END
		END
		ELSE 
		BEGIN
			select @SAPCode=REPLACE(REPLACE(REPLACE(CONVERT(varchar,GETDATE(),120),'-',''),' ',''),':','');
		END
		
		set @DealerID=NEWID();
		
		insert into DealerMaster
			  (DMA_ID,DMA_SAP_Code,DMA_ChineseName,DMA_ChineseShortName,DMA_EnglishName,DMA_EnglishShortName,DMA_ActiveFlag,DMA_DealerType,DMA_HostCompanyFlag,DMA_Email
			  ,DMA_CompanyType,DMA_Phone,DMA_ContactPerson,DMA_Address)
		SELECT @DealerID, @SAPCode,DMA_ChineseName,DMA_ChineseName+'-'+@SAPCode, DMA_EnglishName, null,1, @DealerType,'0',DMA_Email
			   ,DMA_CompanyType,DMA_Phone,DMA_ContactPerson,DMA_Address
		FROM DealerMaster
		WHERE DMA_SAP_Code=@BlueAccount
		--一级
		update DealerMaster set DealerMaster.DMA_Parent_DMA_ID = 'FB62D945-C9D7-4B0F-8D26-4672D2C728B7'
		where DealerMaster.DMA_DealerType in ('LP','T1')
		and DealerMaster.DMA_ID=@DealerID;
		--二级（所属一级）
		IF(@Parent_DMA_ID IS NOT NULL)
		BEGIN
			UPDATE  DealerMaster SET DMA_Parent_DMA_ID=@Parent_DMA_ID
			WHERE DealerMaster.DMA_ID=@DealerID;
		END
		
		DECLARE @IDENTITY_ID uniqueidentifier
		DECLARE @IDENTITY_ID_ADMIN uniqueidentifier
		SET @IDENTITY_ID=NEWID();
		SET @IDENTITY_ID_ADMIN=NEWID();
		INSERT INTO Lafite_IDENTITY 
				(Id,IDENTITY_CODE,LOWERED_IDENTITY_CODE,IDENTITY_NAME,
				BOOLEAN_FLAG,IDENTITY_TYPE,LastActivityDate,Corp_ID,APP_ID,DELETE_FLAG,
				CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
			VALUES(@IDENTITY_ID,@SAPCode+'_01',@SAPCode+'_01',@DealerName,
				1,'Dealer',getdate(),@DealerID,'4028931b0f0fc135010f0fc1356a0001',0,
				'00000000-0000-0000-0000-000000000000',GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE());

		INSERT INTO Lafite_IDENTITY 
				(Id,IDENTITY_CODE,LOWERED_IDENTITY_CODE,IDENTITY_NAME,
				BOOLEAN_FLAG,IDENTITY_TYPE,LastActivityDate,Corp_ID,APP_ID,DELETE_FLAG,
				CREATE_USER,CREATE_DATE,LAST_UPDATE_USER,LAST_UPDATE_DATE)
			VALUES(@IDENTITY_ID_ADMIN,@SAPCode+'_99',@SAPCode+'_99',@DealerName,
				1,'Dealer',GETDATE(),@DealerID,'4028931b0f0fc135010f0fc1356a0001',0,
				'00000000-0000-0000-0000-000000000000',GETDATE(),'00000000-0000-0000-0000-000000000000',GETDATE());
				
		INSERT INTO dbo.Lafite_Membership
		values(@IDENTITY_ID,'JwSWJpN51898uJjc7eriHZY/MSc=','1','rcmX5PF2DpzU5uP09ilGuA==',
		null,'','',null,null,'4028931b0f0fc135010f0fc1356a0001',1,0,GETDATE(),GETDATE(),'j3Mj1nPQ5V3HA5wvn6CvSvMq0qY=',GETDATE(),GETDATE(),0,GETDATE(),'0',GETDATE(),null)

		INSERT INTO dbo.Lafite_Membership
		values(@IDENTITY_ID_ADMIN,'JwSWJpN51898uJjc7eriHZY/MSc=','1','rcmX5PF2DpzU5uP09ilGuA==',
		null,'','',null,null,'4028931b0f0fc135010f0fc1356a0001',1,0,GETDATE(),GETDATE(),'j3Mj1nPQ5V3HA5wvn6CvSvMq0qY=',GETDATE(),GETDATE(),0,GETDATE(),'0',GETDATE(),null)

		EXEC [dbo].[GC_OpenAccountPermissions_New] @DealerID
	END
	else 
	begin
		SELECT @SAPCode=a.DMA_SAP_Code FROM DealerMaster a inner join DealerMaster b on a.DMA_Parent_DMA_ID=b.DMA_ID WHERE a.DMA_ChineseName =@DEALERNAME AND a.DMA_DealerType=@DealerType and b.DMA_SAP_Code=@LPAccount and a.DMA_ActiveFlag=1
	end
	
	update Temp_BlueAndRed set RedAccount=@SAPCode where BlueAccount=@BlueAccount and LPAccount=@LPAccount
END
GO


