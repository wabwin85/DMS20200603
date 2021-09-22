DROP PROCEDURE [DP].[Proc_SyncRvDealerQuota]
GO


CREATE PROCEDURE [DP].[Proc_SyncRvDealerQuota]
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
		SET @ModleId = '00000001-0003-0003-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId;
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, Column5, 
		   Column6, Column7, Column8, Column9, Column10, Column11, Column12, 
		   Column13, Column14, Column15, Column16, Column17, Column18, Column19, 
		   Column20, Column21, Column22, Column23, Column24, Column25, Column26, 
		   Column27, Column28, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       B.DMA_ID,
		       @ModleId,
		       A.[Year],
		       A.Division,
		       A.SubBUName,
		       A.RSM,
		       A.ZSM,
		       A.BICode,
		       A.BIName,
		       A.ParentSAPID,
		       A.ParentDealerName,
		       A.DealerType,
		       A.ContractStartDate,
		       A.ContractEndDate,
		       A.MarketType,
		       A.ContractStatus,
		       CONVERT(VARCHAR(100), CAST(A.Month1 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month2 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month3 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month4 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month5 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month6 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month7 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month8 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month9 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month10 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month11 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.Month12 AS MONEY), 1),
		       CONVERT(VARCHAR(100), CAST(A.YearTotal AS MONEY), 1),
		       A.Remark,
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER()OVER(
		           PARTITION BY B.DMA_ID ORDER BY A.[Year] DESC,
		           A.Division,
		           A.SubBUName
		       )
		FROM   interface.RV_DealerQuota A,
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
		SET @vError = 'DP.Proc_SyncRvDealerQuotaµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
    
GO


