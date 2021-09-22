DROP PROCEDURE [dbo].[GC_OpenAccountPermissions_New]
GO

/*
���ྭ����ҳ��Ȩ��
*/
CREATE PROCEDURE [dbo].[GC_OpenAccountPermissions_New]
@DealerId nvarchar(36)

AS BEGIN 
DECLARE @DealerName NVARCHAR(500)
DECLARE @DealerType NVARCHAR(100)
DECLARE @CheckDefaultWH INT
DECLARE @WHCode NVARCHAR(100)


	
		SELECT @DealerType=DMA_DealerType,@DealerName=DMA_ChineseName FROM DealerMaster WHERE DMA_ID=@DealerId;
		
		--3.1 ɾ��ԭ��Ȩ��
		DELETE dbo.Lafite_IDENTITY_MAP WHERE Lafite_IDENTITY_MAP.Id IN (
		SELECT MAP.Id FROM dbo.Lafite_IDENTITY IDENT INNER JOIN dbo.Lafite_IDENTITY_MAP MAP ON IDENT.Id=MAP.IDENTITY_ID  WHERE IDENT.Corp_ID=@DealerId)
		
		--3.2��������Ȩ��
		IF (@DealerType='T1')
		BEGIN
			DECLARE @T1Copy uniqueidentifier;
			select top 1 @T1Copy=  id From Lafite_IDENTITY 
			WHERE Corp_ID in (select top 1 DMA_ID from DealerMaster where DMA_ActiveFlag='1' and DMA_DeletedFlag='0' and DMA_DealerType='T1')
			order by IDENTITY_CODE asc;
			
			insert into Lafite_IDENTITY_MAP
				select newid(),a.Id,
				b.MAP_TYPE, b.MAP_ID, b.APP_ID, b.DELETE_FLAG, b.CREATE_USER, 
				b.CREATE_DATE, b.LAST_UPDATE_USER, b.LAST_UPDATE_DATE
				from Lafite_IDENTITY a,
				(select MAP_TYPE, MAP_ID, APP_ID, DELETE_FLAG, CREATE_USER, CREATE_DATE, LAST_UPDATE_USER, LAST_UPDATE_DATE 
				from Lafite_IDENTITY_MAP where MAP_TYPE = 'Role' and IDENTITY_ID = @T1Copy
				) b
				where a.IDENTITY_TYPE = 'Dealer'
				and a.Corp_ID =@DealerId
		END
		ELSE IF(@DealerType='T2')
		BEGIN
			DECLARE @T2Copy uniqueidentifier;
			select top 1 @T2Copy=  id From Lafite_IDENTITY 
			WHERE Corp_ID in (select top 1 DMA_ID from DealerMaster where DMA_ActiveFlag='1' and DMA_DeletedFlag='0' and DMA_DealerType='T2')
			order by IDENTITY_CODE asc;
			
			insert into Lafite_IDENTITY_MAP
				select newid(),a.Id,
				b.MAP_TYPE, b.MAP_ID, b.APP_ID, b.DELETE_FLAG, b.CREATE_USER, 
				b.CREATE_DATE, b.LAST_UPDATE_USER, b.LAST_UPDATE_DATE
				from Lafite_IDENTITY a,
				(select MAP_TYPE, MAP_ID, APP_ID, DELETE_FLAG, CREATE_USER, CREATE_DATE, LAST_UPDATE_USER, LAST_UPDATE_DATE 
				from Lafite_IDENTITY_MAP where MAP_TYPE = 'Role' and IDENTITY_ID = @T2Copy
				) b
				where a.IDENTITY_TYPE = 'Dealer'
				and a.Corp_ID =@DealerId
		END
		ELSE IF(@DealerType='LP')
		BEGIN
			
			DECLARE @LPCopy uniqueidentifier;
			select top 1 @LPCopy=  id From Lafite_IDENTITY 
			WHERE Corp_ID in (select top 1 DMA_ID from DealerMaster where DMA_ActiveFlag='1' and DMA_DeletedFlag='0' and DMA_DealerType='LP')
			order by IDENTITY_CODE asc;
			
			insert into Lafite_IDENTITY_MAP
				select newid(),a.Id,
				b.MAP_TYPE, b.MAP_ID, b.APP_ID, b.DELETE_FLAG, b.CREATE_USER, 
				b.CREATE_DATE, b.LAST_UPDATE_USER, b.LAST_UPDATE_DATE
				from Lafite_IDENTITY a,
				(select MAP_TYPE, MAP_ID, APP_ID, DELETE_FLAG, CREATE_USER, CREATE_DATE, LAST_UPDATE_USER, LAST_UPDATE_DATE 
				from Lafite_IDENTITY_MAP where MAP_TYPE = 'Role' and IDENTITY_ID = @LPCopy
				) b
				where a.IDENTITY_TYPE = 'Dealer'
				and a.Corp_ID =@DealerId
		END
		
		--ά�����������ֿ�
		SELECT @CheckDefaultWH=COUNT(*) FROM Warehouse a WHERE WHM_DMA_ID=@DealerId and WHM_Type='DefaultWH'
		IF @CheckDefaultWH=0
		BEGIN
			SET @WHCode=N''
			EXEC dbo.GC_GetNextAutoNumberForCode @Setting=N'Next_WarehouseNbr',@NextAutoNbr=@WHCode OUTPUT
			INSERT INTO  Warehouse
			(WHM_DMA_ID,WHM_Name,WHM_Province,WHM_ID,WHM_City,WHM_Type,WHM_CON_ID,WHM_PostalCode,WHM_Address,WHM_HoldWarehouse,WHM_Town,WHM_District,WHM_Phone,WHM_Fax,WHM_ActiveFlag,WHM_Hospital_HOS_ID,WHM_Code)
			values(@DealerId,@DealerName+'���ֿ�','',NEWID(),'','DefaultWH',null,'','','0','','','','','1',null,@WHCode)
		END
end
GO


