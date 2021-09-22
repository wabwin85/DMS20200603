
DROP PROCEDURE [DP].[Proc_SyncRvDealerLevel]
GO


CREATE PROCEDURE [DP].[Proc_SyncRvDealerLevel]
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
		SET @ModleId = '00000004-0001-0005-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId;
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, Column5, Column6, IsAction, CreateBy, CreateDate, 
		   SortId)
		SELECT NEWID(),
		       B.DMA_ID,
		       @ModleId,
		       A.[Year],
		       A.QFrom,
		       A.QTo,
		       A.Division,
		       A.SubBUName,
		       A.DealerLevel,
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(
		           ORDER BY A.[Year] DESC,
		           A.QFrom DESC,
		           A.QTo DESC,
		           A.Division,
		           A.SubBUName,
		           A.DealerLevel
		       )
		FROM   interface.RV_DealerLevel A,
		       dbo.DealerMaster B
		WHERE  A.SAPID = B.DMA_SAP_Code;
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncRvDealerLevel' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
    
GO


