DROP PROCEDURE [DP].[Proc_SyncDmsThirdCompany]
GO


CREATE PROCEDURE [DP].[Proc_SyncDmsThirdCompany]
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
		SET @ModleId = '00000001-0004-0001-0000-000000000000';
		
		DELETE DP.DealerMaster
		WHERE  ModleID = @ModleId;
		
		INSERT INTO DP.DealerMaster
		  (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, Column5, Column6, Column7, IsAction, CreateBy, CreateDate, SortId)
		SELECT NEWID(),
		       TPD_DMA_ID,
		       @ModleId,
		       B.HOS_HospitalName,
		       '',
		       --ProductNameString = STUFF(
		       --    (
		       --        SELECT ',' + tt1.DivisionName
		       --        FROM   (
		       --                   SELECT DISTINCT A.DMA_ID,
		       --                          C.ProductLineID,
		       --                          E.HLA_HOS_ID,
		       --                          c.DivisionName
		       --                   FROM   V_DealerContractMaster A
		       --                          INNER JOIN (
		       --                                   SELECT DISTINCT CC_ID,
		       --                                          CA_ID
		       --                                   FROM   V_ProductClassificationStructure
		       --                               ) B
		       --                               ON  A.CC_ID = B.CC_ID
		       --                          INNER JOIN V_DivisionProductLineRelation C
		       --                               ON  C.DivisionCode = CONVERT(NVARCHAR(10), A.Division)
		       --                               AND C.IsEmerging = '0'
		       --                          INNER JOIN DealerAuthorizationTable D
		       --                               ON  D.DAT_DMA_ID = A.DMA_ID
		       --                               AND D.DAT_ProductLine_BUM_ID = C.ProductLineID
		       --                               AND D.DAT_PMA_ID = B.CA_ID
		       --                          INNER JOIN HospitalList E
		       --                               ON  E.HLA_DAT_ID = D.DAT_ID
		       --                   WHERE  A.ActiveFlag = 1
		       --                          AND ISNULL(A.MarketType, 0) = 2
		       --                          AND A.DMA_ID = @DealerId
		       --                   UNION
		       --                   SELECT DISTINCT A.DMA_ID,
		       --                          C.ProductLineID,
		       --                          E.HLA_HOS_ID,
		       --                          c.DivisionName
		       --                   FROM   V_DealerContractMaster A
		       --                          INNER JOIN (
		       --                                   SELECT DISTINCT CC_ID,
		       --                                          CA_ID
		       --                                   FROM   V_ProductClassificationStructure
		       --                               ) B
		       --                               ON  A.CC_ID = B.CC_ID
		       --                          INNER JOIN V_DivisionProductLineRelation C
		       --                               ON  C.DivisionCode = CONVERT(NVARCHAR(10), A.Division)
		       --                               AND C.IsEmerging = '0'
		       --                          INNER JOIN DealerAuthorizationTable D
		       --                               ON  D.DAT_DMA_ID = A.DMA_ID
		       --                               AND D.DAT_ProductLine_BUM_ID = C.ProductLineID
		       --                               AND D.DAT_PMA_ID = B.CA_ID
		       --                          INNER JOIN HospitalList E
		       --                               ON  E.HLA_DAT_ID = D.DAT_ID
		       --                          INNER JOIN V_AllHospitalMarketProperty F
		       --                               ON  F.ProductLineID = C.ProductLineID
		       --                               AND F.Hos_Id = E.HLA_HOS_ID
		       --                               AND F.MarketProperty = ISNULL(A.MarketType, 0)
		       --                   WHERE  A.ActiveFlag = 1
		       --                          AND ISNULL(A.MarketType, 0) <> 2
		       --                          AND A.DMA_ID = @DealerId
		       --               ) tt1
		       --        WHERE  TPD.TPD_DMA_ID = tt1.DMA_ID
		       --               AND TPD.TPD_HOS_ID = tt1.HLA_HOS_ID
		       --                   FOR XML PATH('')
		       --    ),
		       --    1,
		       --    1,
		       --    ''
		       --),
		       TPD_CompanyName,
		       TPD_RSM,
		       TPD_CompanyName2,
		       TPD_RSM2,
		       CASE 
		            WHEN TPD_NotTP = '0' THEN '·ñ'
		            ELSE 'ÊÇ'
		       END AS NotTP,
		       1,
		       '00000000-0000-0000-0000-000000000000',
		       GETDATE(),
		       ROW_NUMBER() OVER(ORDER BY B.HOS_HospitalName DESC) AS [row_number]
		FROM   ThirdPartyDisclosure TPD
		       LEFT JOIN Hospital B
		            ON  TPD.TPD_HOS_ID = B.HOS_ID
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsThirdCompany' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


