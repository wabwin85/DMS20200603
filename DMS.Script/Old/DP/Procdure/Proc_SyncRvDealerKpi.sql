DROP PROCEDURE [DP].[Proc_SyncRvDealerKpi]
GO


CREATE PROCEDURE [DP].[Proc_SyncRvDealerKpi]
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
		DECLARE @Modle1Id UNIQUEIDENTIFIER;
		SET @Modle1Id = '00000002-0002-0001-0000-000000000000';
		DECLARE @Modle2Id UNIQUEIDENTIFIER;
		SET @Modle2Id = '00000002-0002-0002-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @Modle1Id;
		DELETE DP.DealerMaster
		WHERE  ModleID = @Modle2Id;
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, Column9, 
		   Column10, Column11, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       B.DMA_ID,
		       @Modle1Id,
		       A.[Year],
		       A.[Quarter],
		       A.[Month],
		       A.DivisionID,
		       A.Division,
		       A.SubBUCode,
		       A.SubBUName,
		       A.BICode,
		       A.BIName,
		       A.DealerType,
		       A.TotalScore,
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(
		           PARTITION BY B.DMA_ID ORDER BY A.[Year] DESC,
		           A.[Quarter] DESC,
		           A.[Month] DESC,
		           A.Division,
		           A.SubBUName
		       )
		FROM   interface.RV_DealerKPI_Score_Summary A,
		       dbo.DealerMaster B
		WHERE  A.SAPID = B.DMA_SAP_Code
		       AND A.[Month] IN ('3', '6', '9', '12');
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, Column9, 
		   Column10, Column11, Column12, Column13, Column14, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       B.DMA_ID,
		       @Modle2Id,
		       A.[Year],
		       A.[Quarter],
		       A.[Month],
		       A.DivisionID,
		       A.Division,
		       A.SubBUCode,
		       A.SubBUName,
		       A.BICode,
		       A.BIName,
		       A.DealerType,
		       A.KPICategory,
		       A.ScoreRemark,
		       A.FullScore,
		       A.FinalScore,
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(
		           PARTITION BY B.DMA_ID ORDER BY A.[Year] DESC,
		           A.[Quarter] DESC,
		           A.[Month] DESC,
		           A.Division,
		           A.SubBUName,
		           A.KPICode
		       )
		FROM   interface.RV_DealerKPI_Score_Detail A,
		       dbo.DealerMaster B
		WHERE  A.SAPID = B.DMA_SAP_Code
		       AND A.[Month] IN ('3', '6', '9', '12');
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncRvDealerKpiµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


