DROP PROCEDURE [DP].[Proc_SyncDmsBasicAttr]
GO


CREATE PROCEDURE [DP].[Proc_SyncDmsBasicAttr]
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
		SET @ModleId = '00000001-0001-0009-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId;
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       DM.DMA_ID,
		       @ModleId,
		       DIC.VALUE1,
		       AT_Name,
		       '../../Download.aspx?FileId=' + CONVERT(NVARCHAR(50), AT_ID) + '&FileType=dcms'
		       AT_Url,
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(ORDER BY AT_Name)
		FROM   Attachment a
		       INNER JOIN Lafite_Identity li
		            ON  a.AT_UploadUser = li.Id
		       INNER JOIN dbo.Lafite_DICT DIC
		            ON  DIC.DICT_KEY = a.AT_Type
		       INNER JOIN dbo.DealerMaster DM
		            ON  DM.DMA_ID = A.AT_Main_ID
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsBasicAttrµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


