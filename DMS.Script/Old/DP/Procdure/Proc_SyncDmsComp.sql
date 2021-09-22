DROP PROCEDURE [DP].[Proc_SyncDmsComp]
GO


CREATE PROCEDURE [DP].[Proc_SyncDmsComp]
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
		SET @ModleId = '00000003-0004-0005-0000-000000000000';
		
		DECLARE @Year NVARCHAR(10);
		DECLARE @YearPast NVARCHAR(10);
		SET @Year = CONVERT(NVARCHAR(10), DATEPART(YEAR, GETDATE()));
		SET @YearPast = CONVERT(NVARCHAR(10), DATEPART(YEAR, DATEADD(YEAR, -1, GETDATE())));
		
		PRINT GETDATE()
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId
		       AND Column1 IN (@Year, @YearPast);
		
		--Current Year
		BEGIN
			PRINT GETDATE()
		
			INSERT INTO DP.DealerMaster
			  (ID, DealerId, ModleID, Column1, IsAction, CreateBy, CreateDate, SortId)
			SELECT NEWID(),
			       A.DMA_ID ,
			       @ModleId,
			       @Year,
			       1,
			       '00000000-0000-0000-0000-000000000000',
			       GETDATE(),
			       1
			FROM dbo.DealerMaster A
			
			PRINT GETDATE()
		
			UPDATE A
			SET    A.Column2 = CASE 
			                        WHEN B.ID IS NULL THEN '·ñ'
			                        ELSE 'ÊÇ'
			                   END,
			       A.Column3 = (
			           SELECT ISNULL(SUM(CONVERT(INT, C.Column11)), 60)
			           FROM   DP.DealerMaster C
			           WHERE  A.DealerId = C.DealerId
			                  AND C.ModleID = '00000003-0004-0002-0000-000000000000'
			                  AND A.Column1 = C.Column1
			       ),
			       A.Column4 = ISNULL(B.Column6, '·ñ'),
			       A.Column5 = CASE 
			                        WHEN ISNULL(B.Column6, '·ñ') = '·ñ' THEN 40
			                        ELSE 60
			                   END
			FROM   DP.DealerMaster A
			       LEFT JOIN DP.DealerMaster B
			            ON  A.DealerId = B.DealerId
			            AND B.ModleID = '00000003-0004-0001-0000-000000000000'
			            AND A.Column1 = B.Column1
			WHERE  A.ModleID = @ModleId
			       AND A.Column1 = @Year;
			
			PRINT GETDATE()
		
			UPDATE A
			SET    A.Column6 = CASE 
			                        WHEN B.ID IS NULL THEN '·ñ'
			                        ELSE 'ÊÇ'
			                   END,
			       A.Column7 = (
			           SELECT ISNULL(C.Column5, '60')
			           FROM   DP.DealerMaster C
			           WHERE  A.DealerId = C.DealerId
			                  AND C.ModleID = '00000003-0004-0004-0000-000000000000'
			                  AND A.Column1 = C.Column1
			                  AND C.Column3 = '7'
			       ),
			       A.Column8 = ISNULL(B.Column6, '·ñ'),
			       A.Column9 = CASE 
			                        WHEN ISNULL(B.Column6, '·ñ') = '·ñ' THEN 40
			                        ELSE 60
			                   END
			FROM   DP.DealerMaster A
			       LEFT JOIN DP.DealerMaster B
			            ON  A.DealerId = B.DealerId
			            AND B.ModleID = '00000003-0004-0003-0000-000000000000'
			            AND A.Column1 = B.Column1
			WHERE  A.ModleID = @ModleId
			       AND A.Column1 = @Year;
			
			PRINT GETDATE()
		
			UPDATE A
			SET    A.Column10 = CONVERT(INT, A.Column3) + CONVERT(INT, A.Column5) + CONVERT(INT, A.Column7) + CONVERT(INT, A.Column9)
			FROM   DP.DealerMaster A
			WHERE  A.ModleID = @ModleId
			       AND A.Column1 = @Year;
			
			PRINT GETDATE()
		
			UPDATE A
			SET    A.Column11 = CASE 
			                         WHEN CONVERT(INT, A.Column10) < 80 THEN 'µÍ'
			                         WHEN CONVERT(INT, A.Column10) < 150 THEN 'ÖÐ'
			                         ELSE '¸ß'
			                    END
			FROM   DP.DealerMaster A
			WHERE  A.ModleID = @ModleId
			       AND A.Column1 = @Year;
		END
		
		--Past Year
		BEGIN
			PRINT GETDATE()
		
			INSERT INTO DP.DealerMaster
			  (ID, DealerId, ModleID, Column1, IsAction, CreateBy, CreateDate, SortId)
			SELECT NEWID(),
			       A.DMA_ID ,
			       @ModleId,
			       @YearPast,
			       1,
			       '00000000-0000-0000-0000-000000000000',
			       GETDATE(),
			       1
			FROM dbo.DealerMaster A
			
			PRINT GETDATE()
		
			UPDATE A
			SET    A.Column2 = CASE 
			                        WHEN B.ID IS NULL THEN '·ñ'
			                        ELSE 'ÊÇ'
			                   END,
			       A.Column3 = (
			           SELECT ISNULL(SUM(CONVERT(INT, C.Column11)), 60)
			           FROM   DP.DealerMaster C
			           WHERE  A.DealerId = C.DealerId
			                  AND C.ModleID = '00000003-0004-0002-0000-000000000000'
			                  AND A.Column1 = C.Column1
			       ),
			       A.Column4 = ISNULL(B.Column6, '·ñ'),
			       A.Column5 = CASE 
			                        WHEN ISNULL(B.Column6, '·ñ') = '·ñ' THEN 40
			                        ELSE 60
			                   END
			FROM   DP.DealerMaster A
			       LEFT JOIN DP.DealerMaster B
			            ON  A.DealerId = B.DealerId
			            AND B.ModleID = '00000003-0004-0001-0000-000000000000'
			            AND A.Column1 = B.Column1
			WHERE  A.ModleID = @ModleId
			       AND A.Column1 = @YearPast;
			
			PRINT GETDATE()
		
			UPDATE A
			SET    A.Column6 = CASE 
			                        WHEN B.ID IS NULL THEN '·ñ'
			                        ELSE 'ÊÇ'
			                   END,
			       A.Column7 = (
			           SELECT ISNULL(C.Column5, '60')
			           FROM   DP.DealerMaster C
			           WHERE  A.DealerId = C.DealerId
			                  AND C.ModleID = '00000003-0004-0004-0000-000000000000'
			                  AND A.Column1 = C.Column1
			                  AND C.Column3 = '7'
			       ),
			       A.Column8 = ISNULL(B.Column6, '·ñ'),
			       A.Column9 = CASE 
			                        WHEN ISNULL(B.Column6, '·ñ') = '·ñ' THEN 40
			                        ELSE 60
			                   END
			FROM   DP.DealerMaster A
			       LEFT JOIN DP.DealerMaster B
			            ON  A.DealerId = B.DealerId
			            AND B.ModleID = '00000003-0004-0003-0000-000000000000'
			            AND A.Column1 = B.Column1
			WHERE  A.ModleID = @ModleId
			       AND A.Column1 = @YearPast;
			
			PRINT GETDATE()
		
			UPDATE A
			SET    A.Column10 = CONVERT(INT, A.Column3) + CONVERT(INT, A.Column5) + CONVERT(INT, A.Column7) + CONVERT(INT, A.Column9)
			FROM   DP.DealerMaster A
			WHERE  A.ModleID = @ModleId
			       AND A.Column1 = @YearPast;
			
			PRINT GETDATE()
		
			UPDATE A
			SET    A.Column11 = CASE 
			                         WHEN CONVERT(INT, A.Column10) < 80 THEN 'µÍ'
			                         WHEN CONVERT(INT, A.Column10) < 150 THEN 'ÖÐ'
			                         ELSE '¸ß'
			                    END
			FROM   DP.DealerMaster A
			WHERE  A.ModleID = @ModleId
			       AND A.Column1 = @YearPast;
			       
			PRINT GETDATE()
		
		END
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsCompµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


