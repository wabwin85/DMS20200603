DROP PROCEDURE [Contract].[Proc_SaveAttachment]
GO


CREATE PROCEDURE [Contract].[Proc_SaveAttachment]
(
    @FileName  NVARCHAR(255),
    @FileUrl   NVARCHAR(500),
    @UserId    UNIQUEIDENTIFIER
)
AS
BEGIN TRY
	INSERT INTO [Contract].Attachment
	  ([FileName], FileUrl, CreateUser, CreateDate)
	VALUES
	  (@FileName, @FileUrl, @UserId, GETDATE())
	
	SELECT SCOPE_IDENTITY() AttId;
END TRY
BEGIN CATCH
	--ROLLBACK TRAN
	DECLARE @error_number INT
	DECLARE @error_serverity INT
	DECLARE @error_state INT
	DECLARE @error_message NVARCHAR(256)
	DECLARE @error_line INT
	DECLARE @error_procedure NVARCHAR(256)
	DECLARE @vError NVARCHAR(1000)
	DECLARE @vSyncTime DATETIME	
	SET @error_number = ERROR_NUMBER()
	SET @error_serverity = ERROR_SEVERITY()
	SET @error_state = ERROR_STATE()
	SET @error_message = ERROR_MESSAGE()
	SET @error_line = ERROR_LINE()
	SET @error_procedure = ERROR_PROCEDURE()
	SET @vError = ISNULL(@error_procedure, '') + 'µÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, ''))
	    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, ''))
	    + ']£¬' + ISNULL(@error_message, '')
	
	RAISERROR(@vError, @error_serverity, @error_state)
END CATCH

GO


