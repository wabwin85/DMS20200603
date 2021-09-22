DROP PROCEDURE [DP].[Proc_SyncRvDealerRef]
GO


CREATE PROCEDURE [DP].[Proc_SyncRvDealerRef]
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
		SET @ModleId = '00000001-0001-0007-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId;
		
		SELECT DISTINCT SAPID,
		       DealerName,
		       Reason,
		       RefSAPID,
		       RefDealerName INTO #TMP
		FROM   interface.RV_DealerMaster_Ref
		
		INSERT INTO #TMP
		SELECT DISTINCT RefSAPID,
		       RefDealerName,
		       Reason,
		       SAPID,
		       DealerName
		FROM   interface.RV_DealerMaster_Ref A
		WHERE  NOT EXISTS (
		           SELECT 1
		           FROM   #TMP T
		           WHERE  A.RefSAPID = T.SAPID
		                  AND A.SAPID = T.RefSAPID
		                  AND A.Reason = T.Reason
		       )
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       B.DMA_ID,
		       @ModleId,
		       A.Reason,
		       A.RefSAPID,
		       A.RefDealerName,
		       CONVERT(NVARCHAR(100), C.DMA_ID),
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(ORDER BY A.RefDealerName)
		FROM   #TMP A,
		       dbo.DealerMaster B,
		       dbo.DealerMaster C
		WHERE  A.SAPID = B.DMA_SAP_Code
		       AND A.RefSAPID = C.DMA_SAP_Code;
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncRvDealerRefµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
    
GO


