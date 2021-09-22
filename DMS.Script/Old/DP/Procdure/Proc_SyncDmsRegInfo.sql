DROP PROCEDURE [DP].[Proc_SyncDmsRegInfo]
GO


CREATE PROCEDURE [DP].[Proc_SyncDmsRegInfo]
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
		SET @ModleId = '00000001-0001-0003-0000-000000000000';
		DECLARE @HasDiff NVARCHAR(10);
		SET @HasDiff = 'FALSE';
		
		DECLARE @GeneralManager NVARCHAR(500);
		DECLARE @LegalPerson NVARCHAR(500);
		DECLARE @Bank NVARCHAR(500);
		DECLARE @RegMoney NVARCHAR(500);
		DECLARE @BankAccount NVARCHAR(500);
		DECLARE @TaxNo NVARCHAR(500);
		
		DECLARE @Version NVARCHAR(100);
		DECLARE @GeneralManagerOld NVARCHAR(500);
		DECLARE @LegalPersonOld NVARCHAR(500);
		DECLARE @BankOld NVARCHAR(500);
		DECLARE @RegMoneyOld NVARCHAR(500);
		DECLARE @BankAccountOld NVARCHAR(500);
		DECLARE @TaxNoOld NVARCHAR(500);
		
		SELECT @GeneralManager = DMA_GeneralManager,
		       @LegalPerson = DMA_LegalRep,
		       @Bank = DMA_Bank,
		       @RegMoney = DMA_RegisteredCapital,
		       @BankAccount = DMA_BankAccount,
		       @TaxNo = DMA_TaxNo
		FROM   dbo.DealerMaster A
		WHERE  A.DMA_ID = @DealerId;
		
		SET @GeneralManager = ISNULL(@GeneralManager, '');
		SET @LegalPerson = ISNULL(@LegalPerson, '');
		SET @Bank = ISNULL(@Bank, '');
		SET @RegMoney = ISNULL(@RegMoney, '');
		SET @BankAccount = ISNULL(@BankAccount, '');
		SET @TaxNo = ISNULL(@TaxNo, '');
		
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
		    SELECT @GeneralManagerOld = ISNULL(Column1, ''),
		           @LegalPersonOld = ISNULL(Column2, ''),
		           @BankOld = ISNULL(Column3, ''),
		           @RegMoneyOld = ISNULL(Column4, ''),
		           @BankAccountOld = ISNULL(Column5, ''),
		           @TaxNoOld = ISNULL(Column6, '')
		    FROM   DP.DealerMaster
		    WHERE  ModleID = @ModleId
		           AND DealerId = @DealerId
		           AND [Version] = @Version;
		    
		    IF @GeneralManagerOld <> @GeneralManager
		       OR @LegalPersonOld <> @LegalPerson
		       OR @BankOld <> @Bank
		       OR @RegMoneyOld <> @RegMoney
		       OR @BankAccountOld <> @BankAccount
		       OR @TaxNoOld <> @TaxNo
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
		       Column4, Column5, Column6, IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, @Version, @GeneralManager, @LegalPerson, @Bank, @RegMoney, 
		      @BankAccount, @TaxNo, 1, '00000000-0000-0000-0000-000000000000', 
		      GETDATE());
		END
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsRegInfoµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
		 
GO


