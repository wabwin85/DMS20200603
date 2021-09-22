DROP PROCEDURE [DP].[Proc_SyncUserDealerMapping]
GO


CREATE PROCEDURE [DP].[Proc_SyncUserDealerMapping]
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
		BEGIN TRAN
		
		CREATE TABLE #DealerUser
		(
			UserAccount  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
			RightId      INT,
			SapCode      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
			DealerId     UNIQUEIDENTIFIER
		)
		
		CREATE TABLE #BscUser
		(
			UserAccount  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
			RightId      INT
		)
		
		DELETE DP.UserDealerMapping;
		
		--Dealer User
		BEGIN
			INSERT INTO #DealerUser
			SELECT DISTINCT A.IDENTITY_CODE,
			       D.RightId,
			       E.DMA_SAP_Code,
			       E.DMA_ID
			FROM   Lafite_IDENTITY A
			       INNER JOIN Lafite_IDENTITY_MAP B
			            ON  A.Id = B.IDENTITY_ID
			                AND B.MAP_TYPE = 'Role'
			       INNER JOIN Lafite_ATTRIBUTE C
			            ON  B.MAP_ID = C.Id
			                AND C.ATTRIBUTE_TYPE = 'Role'
			       INNER JOIN DP.RoleRight D
			            ON  C.ATTRIBUTE_NAME = D.RoleName
			       INNER JOIN dbo.DealerMaster E
			            ON  A.Corp_ID = E.DMA_ID
			WHERE  A.IDENTITY_TYPE = 'Dealer'
			
			INSERT INTO DP.UserDealerMapping
			SELECT DISTINCT A.UserAccount,
			       B.SAPID,
			       B.DivisionID,
			       B.SubBUCode
			FROM   #DealerUser A
			       INNER JOIN interface.RV_DealerKPI_Score_Summary B
			            ON  A.SapCode = B.SAPID
			WHERE  A.RightId = 5
			       AND NOT EXISTS (
			               SELECT 1
			               FROM   DP.UserDealerMapping T
			               WHERE  T.UserAccount = A.UserAccount
			                      AND T.SapCode = B.SAPID
			                      AND T.Division = B.DivisionID
			                      AND T.SubBu = B.SubBUCode
			           )
			
			INSERT INTO DP.UserDealerMapping
			SELECT DISTINCT A.UserAccount,
			       C.SAPID,
			       C.DivisionID,
			       C.SubBUCode
			FROM   #DealerUser A
			       INNER JOIN dbo.DealerMaster B
			            ON  A.DealerId = B.DMA_Parent_DMA_ID
			       INNER JOIN interface.RV_DealerKPI_Score_Summary C
			            ON  B.DMA_SAP_Code = C.SAPID
			WHERE  A.RightId = 4
			       AND NOT EXISTS (
			               SELECT 1
			               FROM   DP.UserDealerMapping T
			               WHERE  T.UserAccount = A.UserAccount
			                      AND T.SapCode = C.SAPID
			                      AND T.Division = C.DivisionID
			                      AND T.SubBu = C.SubBUCode
			           )
		END
		
		--BSC User
		BEGIN
			INSERT INTO #BscUser
			SELECT DISTINCT A.IDENTITY_CODE,
			       D.RightId
			FROM   Lafite_IDENTITY A
			       INNER JOIN Lafite_IDENTITY_MAP B
			            ON  A.Id = B.IDENTITY_ID
			                AND B.MAP_TYPE = 'Role'
			       INNER JOIN Lafite_ATTRIBUTE C
			            ON  B.MAP_ID = C.Id
			                AND C.ATTRIBUTE_TYPE = 'Role'
			       INNER JOIN DP.RoleRight D
			            ON  C.ATTRIBUTE_NAME = D.RoleName
			WHERE  A.IDENTITY_TYPE = 'User'
			
			INSERT INTO DP.UserDealerMapping
			SELECT DISTINCT A.UserAccount,
			       C.SAPID,
			       C.DivisionID,
			       C.SubBUCode
			FROM   #BscUser A
			       INNER JOIN INTERFACE.RV_SalesOrganize B
			            ON  A.UserAccount = B.SalesEmail
			                OR A.UserAccount = B.ZSMEmail
			                OR A.UserAccount = B.RSMEmail
			                OR A.UserAccount = B.NSMEmail
			                OR A.UserAccount = B.BUMEmail
			                OR A.UserAccount = B.NCMEmail
			       INNER JOIN INTERFACE.RV_DealerKPI_Score_Warning C
			            ON  B.ProductLineID = C.SalesOrgLineID
			WHERE  A.RightId = 3
			       AND NOT EXISTS (
			               SELECT 1
			               FROM   DP.UserDealerMapping T
			               WHERE  T.UserAccount = A.UserAccount
			                      AND T.SapCode = C.SAPID
			                      AND T.Division = C.DivisionID
			                      AND T.SubBu = C.SubBUCode
			           )
			
			INSERT INTO DP.UserDealerMapping
			SELECT DISTINCT A.UserAccount,
			       C.SAPID,
			       C.DivisionID,
			       C.SubBUCode
			FROM   #BscUser A
			       INNER JOIN DP.SalesDivisionRelation B
			            ON  A.UserAccount = B.UserAccount
			       INNER JOIN INTERFACE.RV_DealerKPI_Score_Summary C
			            ON  B.Division = C.DivisionID
			WHERE  A.RightId = 2
			       AND NOT EXISTS (
			               SELECT 1
			               FROM   DP.UserDealerMapping T
			               WHERE  T.UserAccount = A.UserAccount
			                      AND T.SapCode = C.SAPID
			                      AND T.Division = C.DivisionID
			                      AND T.SubBu = C.SubBUCode
			           )
			
			INSERT INTO DP.UserDealerMapping
			SELECT DISTINCT A.UserAccount,
			       B.SAPID,
			       B.DivisionID,
			       B.SubBUCode
			FROM   #BscUser A
			       INNER JOIN interface.RV_DealerKPI_Score_Summary B
			            ON  1 = 1
			WHERE  A.RightId = 1
			       AND NOT EXISTS (
			               SELECT 1
			               FROM   DP.UserDealerMapping T
			               WHERE  T.UserAccount = A.UserAccount
			                      AND T.SapCode = B.SAPID
			                      AND T.Division = B.DivisionID
			                      AND T.SubBu = B.SubBUCode
			           )
		END
		
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncUserDealerMappingµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (
		    NEWID(),
		    GETDATE(),
		    @vError
		  );
	END CATCH
END
GO


