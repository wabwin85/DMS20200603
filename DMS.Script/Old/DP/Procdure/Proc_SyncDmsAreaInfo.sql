DROP PROCEDURE [DP].[Proc_SyncDmsAreaInfo]
GO


CREATE PROCEDURE [DP].[Proc_SyncDmsAreaInfo]
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
		SET @ModleId = '00000001-0001-0002-0000-000000000000';
		DECLARE @HasDiff NVARCHAR(10);
		SET @HasDiff = 'FALSE';
		
		DECLARE @Province NVARCHAR(500);
		DECLARE @City NVARCHAR(500);
		DECLARE @ZipCode NVARCHAR(500);
		DECLARE @Email NVARCHAR(500);
		DECLARE @County NVARCHAR(500);
		DECLARE @CompanyAddress NVARCHAR(500);
		DECLARE @Phone NVARCHAR(500);
		DECLARE @Fax NVARCHAR(500);
		DECLARE @RegAddress NVARCHAR(500);
		DECLARE @WarehouseAddress NVARCHAR(500);
		
		DECLARE @Version NVARCHAR(100);
		DECLARE @ProvinceOld NVARCHAR(500);
		DECLARE @CityOld NVARCHAR(500);
		DECLARE @ZipCodeOld NVARCHAR(500);
		DECLARE @EmailOld NVARCHAR(500);
		DECLARE @CountyOld NVARCHAR(500);
		DECLARE @CompanyAddressOld NVARCHAR(500);
		DECLARE @PhoneOld NVARCHAR(500);
		DECLARE @FaxOld NVARCHAR(500);
		DECLARE @RegAddressOld NVARCHAR(500);
		DECLARE @WarehouseAddressOld NVARCHAR(500);
		
		SELECT @Province = DMA_Province,
		       @City = DMA_City,
		       @ZipCode = DMA_PostalCode,
		       @Email = DMA_Email,
		       @County = DMA_District,
		       @CompanyAddress = DMA_Address,
		       @Phone = DMA_Phone,
		       @Fax = DMA_Fax,
		       @RegAddress = DMA_RegisteredAddress,
		       @WarehouseAddress = DMA_ShipToAddress
		FROM   dbo.DealerMaster A
		WHERE  A.DMA_ID = @DealerId;
		
		SET @Province = ISNULL(@Province, '');
		SET @City = ISNULL(@City, '');
		SET @ZipCode = ISNULL(@ZipCode, '');
		SET @Email = ISNULL(@Email, '');
		SET @County = ISNULL(@County, '');
		SET @CompanyAddress = ISNULL(@CompanyAddress, '');
		SET @Phone = ISNULL(@Phone, '');
		SET @Fax = ISNULL(@Fax, '');
		SET @RegAddress = ISNULL(@RegAddress, '');
		SET @WarehouseAddress = ISNULL(@WarehouseAddress, '');
		
		SELECT @Version = MAX([Version])
		FROM   DP.DealerMaster
		WHERE  ModleID = @ModleId
		       AND DealerId = @DealerId;
		
		IF ISNULL(@Version, '') = ''
		BEGIN
		    SET @HasDiff = 'TRUE';
		END
		ELSE
		BEGIN
		    SELECT @ProvinceOld = ISNULL(Column1, ''),
		           @CityOld = ISNULL(Column2, ''),
		           @ZipCodeOld = ISNULL(Column3, ''),
		           @EmailOld = ISNULL(Column4, ''),
		           @CountyOld = ISNULL(Column5, ''),
		           @CompanyAddressOld = ISNULL(Column6, ''),
		           @PhoneOld = ISNULL(Column7, ''),
		           @FaxOld = ISNULL(Column8, ''),
		           @RegAddressOld = ISNULL(Column9, ''),
		           @WarehouseAddressOld = ISNULL(Column10, '')
		    FROM   DP.DealerMaster
		    WHERE  ModleID = @ModleId
		           AND DealerId = @DealerId
		           AND [Version] = @Version;
		    
		    IF @ProvinceOld <> @Province
		       OR @CityOld <> @City
		       OR @ZipCodeOld <> @ZipCode
		       OR @EmailOld <> @Email
		       OR @CountyOld <> @County
		       OR @CompanyAddressOld <> @CompanyAddress
		       OR @PhoneOld <> @Phone
		       OR @FaxOld <> @Fax
		       OR @RegAddressOld <> @RegAddress
		       OR @WarehouseAddressOld <> @WarehouseAddress
		    BEGIN
		        SET @HasDiff = 'TRUE';
		    END
		END
		
		IF @HasDiff = 'TRUE'
		BEGIN
		    SET @Version = CONVERT(NVARCHAR(4), YEAR(GETDATE()))
		        + RIGHT ('00' + CONVERT(NVARCHAR(2), MONTH(GETDATE())), 2)
		        + RIGHT ('00' + CONVERT(NVARCHAR(2), DAY(GETDATE())), 2)
		        + '-'
		        + RIGHT ('00' + CONVERT(NVARCHAR(2), DATEPART(hh, GETDATE())), 2)
		        + RIGHT ('00' + CONVERT(NVARCHAR(2), DATEPART(mi, GETDATE())), 2)
		        + RIGHT ('00' + CONVERT(NVARCHAR(2), DATEPART(ss, GETDATE())), 2)
		    
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, [Version], Column1, Column2, Column3, 
		       Column4, Column5, Column6, Column7, Column8, Column9, Column10, 
		       IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, @Version, @Province, @City, @ZipCode, @Email, @County, @CompanyAddress, 
		      @Phone, @Fax, @RegAddress, @WarehouseAddress, 1, 
		      '00000000-0000-0000-0000-000000000000', GETDATE());
		END
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsAreaInfoµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


