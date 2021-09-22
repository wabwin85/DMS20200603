DROP PROCEDURE [DP].[Proc_SyncDmsContact]
GO


CREATE PROCEDURE [DP].[Proc_SyncDmsContact]
	@DealerId UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @error_number INT
	DECLARE @error_serverity INT
	DECLARE @error_state INT
	DECLARE @error_message NVARCHAR(256)
	DECLARE @error_line INT
	DECLARE @error_procedure NVARCHAR(256)
	DECLARE @vError NVARCHAR(1000)
	
	BEGIN TRY
		DECLARE @ModleId UNIQUEIDENTIFIER;
		SET @ModleId = '00000001-0001-0004-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  DealerId = @DealerId
		       AND ModleID = @ModleId;
		
		IF EXISTS (
		       SELECT 1
		       FROM   dbo.DealerMaster
		       WHERE  DMA_ID = @DealerId
		              AND ISNULL(DMA_ContactPerson, '') != ''
		              AND ISNULL(DMA_Phone, '') != ''
		              AND ISNULL(DMA_Email, '') != ''
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT NEWID(),
		           @DealerId,
		           @ModleId,
		           '法人',
		           ISNULL(DMA_ContactPerson, ''),
		           ISNULL(DMA_Phone, ''),
		           ISNULL(DMA_Email, ''),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   dbo.DealerMaster
		    WHERE  DMA_ID = @DealerId
		END
		
		IF EXISTS (
		       SELECT 1
		       FROM   dbo.DealerMaster
		       WHERE  DMA_ID = @DealerId
		              AND ISNULL(DMA_Finance, '') != ''
		              AND ISNULL(DMA_Finance_Phone, '') != ''
		              AND ISNULL(DMA_Finance_Email, '') != ''
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT NEWID(),
		           @DealerId,
		           @ModleId,
		           '财务',
		           ISNULL(DMA_Finance, ''),
		           ISNULL(DMA_Finance_Phone, ''),
		           ISNULL(DMA_Finance_Email, ''),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   dbo.DealerMaster
		    WHERE  DMA_ID = @DealerId
		END
		
		IF EXISTS (
		       SELECT 1
		       FROM   dbo.DealerMaster
		       WHERE  DMA_ID = @DealerId
		              AND ISNULL(DMA_Business1, '') != ''
		              AND ISNULL(DMA_BusinessPhone1, '') != ''
		              AND ISNULL(DMA_BusinessEmail1, '') != ''
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT NEWID(),
		           @DealerId,
		           @ModleId,
		           '商务',
		           ISNULL(DMA_Business1, ''),
		           ISNULL(DMA_BusinessPhone1, ''),
		           ISNULL(DMA_BusinessEmail1, ''),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   dbo.DealerMaster
		    WHERE  DMA_ID = @DealerId
		END
		
		IF EXISTS (
		       SELECT 1
		       FROM   dbo.DealerMaster
		       WHERE  DMA_ID = @DealerId
		              AND ISNULL(DMA_Business2, '') != ''
		              AND ISNULL(DMA_BusinessPhone2, '') != ''
		              AND ISNULL(DMA_BusinessEmail2, '') != ''
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT NEWID(),
		           @DealerId,
		           @ModleId,
		           '商务',
		           ISNULL(DMA_Business2, ''),
		           ISNULL(DMA_BusinessPhone2, ''),
		           ISNULL(DMA_BusinessEmail2, ''),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   dbo.DealerMaster
		    WHERE  DMA_ID = @DealerId
		END
		
		IF EXISTS (
		       SELECT 1
		       FROM   dbo.DealerMaster
		       WHERE  DMA_ID = @DealerId
		              AND ISNULL(DMA_Purchase, '') != ''
		              AND ISNULL(DMA_PurchasePhone, '') != ''
		              AND ISNULL(DMA_PurchaseEmail, '') != ''
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT NEWID(),
		           @DealerId,
		           @ModleId,
		           '采购',
		           ISNULL(DMA_Purchase, ''),
		           ISNULL(DMA_PurchasePhone, ''),
		           ISNULL(DMA_PurchaseEmail, ''),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   dbo.DealerMaster
		    WHERE  DMA_ID = @DealerId
		END
		
		IF EXISTS (
		       SELECT 1
		       FROM   dbo.DealerMaster
		       WHERE  DMA_ID = @DealerId
		              AND ISNULL(DMA_SystemOperator, '') != ''
		              AND ISNULL(DMA_SystemOperatorPhone, '') != ''
		              AND ISNULL(DMA_SystemOperatorEmail, '') != ''
		   )
		BEGIN
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       IsAction, CreateBy, CreateDate)
		    SELECT NEWID(),
		           @DealerId,
		           @ModleId,
		           '数据',
		           ISNULL(DMA_SystemOperator, ''),
		           ISNULL(DMA_SystemOperatorPhone, ''),
		           ISNULL(DMA_SystemOperatorEmail, ''),
		           1,
		           '00000000-0000-0000-0000-000000000000',
		           GETDATE()
		    FROM   dbo.DealerMaster
		    WHERE  DMA_ID = @DealerId
		END
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, IsAction, 
		   CreateBy, CreateDate)
		SELECT NEWID(),
		       @DealerId,
		       @ModleId,
		       '管理',
		       ISNULL(BWU_UserName, ''),
		       ISNULL(BWU_Phone, ''),
		       ISNULL(BWU_Email, ''),
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE()
		FROM   dbo.BusinessWechatUser
		WHERE  BWU_DealerId = @DealerId
		       AND BWU_Post = 'Admin'
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, IsAction, 
		   CreateBy, CreateDate)
		SELECT NEWID(),
		       @DealerId,
		       @ModleId,
		       '其他',
		       ISNULL(BWU_UserName, ''),
		       ISNULL(BWU_Phone, ''),
		       ISNULL(BWU_Email, ''),
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE()
		FROM   dbo.BusinessWechatUser
		WHERE  BWU_DealerId = @DealerId
		       AND BWU_Post = 'Other'
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, IsAction, 
		   CreateBy, CreateDate)
		SELECT NEWID(),
		       @DealerId,
		       @ModleId,
		       '数据',
		       ISNULL(BWU_UserName, ''),
		       ISNULL(BWU_Phone, ''),
		       ISNULL(BWU_Email, ''),
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE()
		FROM   dbo.BusinessWechatUser
		WHERE  BWU_DealerId = @DealerId
		       AND BWU_Post = 'Data'
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, IsAction, 
		   CreateBy, CreateDate)
		SELECT NEWID(),
		       @DealerId,
		       @ModleId,
		       '采购',
		       ISNULL(BWU_UserName, ''),
		       ISNULL(BWU_Phone, ''),
		       ISNULL(BWU_Email, ''),
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE()
		FROM   dbo.BusinessWechatUser
		WHERE  BWU_DealerId = @DealerId
		       AND BWU_Post = 'Purchase'
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, IsAction, 
		   CreateBy, CreateDate)
		SELECT NEWID(),
		       @DealerId,
		       @ModleId,
		       '销售',
		       ISNULL(BWU_UserName, ''),
		       ISNULL(BWU_Phone, ''),
		       ISNULL(BWU_Email, ''),
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE()
		FROM   dbo.BusinessWechatUser
		WHERE  BWU_DealerId = @DealerId
		       AND BWU_Post = 'Sales'
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsContact第' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + '行出错[错误号：' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']，' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


