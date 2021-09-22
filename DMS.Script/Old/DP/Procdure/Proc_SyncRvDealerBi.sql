DROP PROCEDURE [DP].[Proc_SyncRvDealerBi]
GO


CREATE PROCEDURE [DP].[Proc_SyncRvDealerBi]
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
		SET @ModleId = '00000001-0001-0008-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId;
		
		SELECT DISTINCT SAPID,
		       [Type],
		       [Year],
		       Qfrom,
		       QTo,Division,SubBUName,BI_Code,BI_Name,Remark,MarketType INTO #TMP
		FROM   interface.RV_Dealer_BIName
		
		INSERT INTO #TMP
		SELECT DISTINCT BI_Code,
		       [Type],
		       [Year],
		       Qfrom,
		       QTo,Division,SubBUName,SAPID,DealerName,Remark,MarketType
		FROM   interface.RV_Dealer_BIName A
		WHERE  NOT EXISTS (
		           SELECT 1
		           FROM   #TMP T
		           WHERE  A.BI_Code = T.SAPID
		                  AND A.SAPID = T.BI_Code
		                  AND A.[Type] = T.[Type]
		                  AND A.Division = T.Division
		                  AND A.SubBUName = T.SubBUName
		       )
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, Column9, 
		   Column10, Column11, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       B.DMA_ID,
		       @ModleId,
		       A.[Type],
		       A.[Year],
		       A.Qfrom,
		       A.QTo,
		       A.Division,
		       A.SubBUName,
		       A.BI_Code,
		       A.BI_Name,
		       A.Remark,
		       A.MarketType,
		       CONVERT(NVARCHAR(100), C.DMA_ID),
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(
		           ORDER BY A.[Year] DESC,
		           A.Qfrom DESC,
		           A.QTo DESC,
		           A.Division,
		           A.SubBUName,
		           A.BI_Code,
		           A.BI_Name
		       )
		FROM   #TMP A,
		       dbo.DealerMaster B,
		       dbo.DealerMaster C
		WHERE  A.SAPID = B.DMA_SAP_Code
		       AND A.BI_Code = C.DMA_SAP_Code;
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


