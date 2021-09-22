
DROP PROCEDURE [DP].[Proc_SyncDmsBasicInfo]
GO

CREATE PROCEDURE [DP].[Proc_SyncDmsBasicInfo]
	@DealerId UNIQUEIDENTIFIER
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
		SET @ModleId = '00000001-0001-0001-0000-000000000000';
		DECLARE @HasDiff NVARCHAR(10);
		SET @HasDiff = 'FALSE';
		
		DECLARE @DealerNo NVARCHAR(2000);
		DECLARE @DealerNameCn NVARCHAR(2000);
		DECLARE @DealerNameEn NVARCHAR(2000);
		DECLARE @DealerNameEnShort NVARCHAR(2000);
		DECLARE @DealerCategory NVARCHAR(2000);
		DECLARE @DealerPlatform NVARCHAR(2000);
		DECLARE @FirstSign NVARCHAR(2000);
		DECLARE @DealerType NVARCHAR(2000);
		DECLARE @CurrentStatus NVARCHAR(2000);
		DECLARE @CompanyType NVARCHAR(2000);
		
		DECLARE @Version NVARCHAR(100);
		DECLARE @DealerNoOld NVARCHAR(2000);
		DECLARE @DealerNameCnOld NVARCHAR(2000);
		DECLARE @DealerNameEnOld NVARCHAR(2000);
		DECLARE @DealerNameEnShortOld NVARCHAR(2000);
		DECLARE @DealerCategoryOld NVARCHAR(2000);
		DECLARE @DealerPlatformOld NVARCHAR(2000);
		DECLARE @FirstSignOld NVARCHAR(2000);
		DECLARE @DealerTypeOld NVARCHAR(2000);
		DECLARE @CurrentStatusOld NVARCHAR(2000);
		DECLARE @CompanyTypeOld NVARCHAR(2000);
		
		SELECT @DealerNo = DMA_SAP_Code,
		       @DealerNameCn = DMA_ChineseName,
		       @DealerNameEn = DMA_EnglishName,
		       @DealerNameEnShort = DMA_EnglishShortName,
		       @DealerCategory = (
		           SELECT VALUE1
		           FROM   Lafite_DICT B
		           WHERE  A.DMA_DealerAuthentication = B.DICT_KEY
		                  AND B.DICT_TYPE = 'CONST_Dealer_Authentication'
		       ),
		       @DealerPlatform = (
		           SELECT DMA_ChineseName
		           FROM   dbo.DealerMaster B
		           WHERE  B.DMA_ID = A.DMA_Parent_DMA_ID
		       ),
		       @FirstSign = CONVERT(NVARCHAR(10), B.FirstContractDate, 121),
		       @DealerType = (
		           SELECT VALUE1
		           FROM   Lafite_DICT B
		           WHERE  A.DMA_DealerType = B.DICT_KEY
		                  AND B.DICT_TYPE = 'CONST_Dealer_Type'
		       ),
		       @CompanyType = DMA_CompanyType
		FROM   DBO.DealerMaster A
		       LEFT JOIN interface.RV_DealerContractMaster_Convert B
		            ON  A.DMA_SAP_Code = B.SAPID
		WHERE  A.DMA_ID = @DealerId;
		
		SET @CurrentStatus = CASE 
		                          WHEN EXISTS (
		                                   SELECT 1
		                                   FROM   V_DealerContractMaster
		                                   WHERE  CONVERT(NVARCHAR(10), GETDATE(), 121) >= CONVERT(NVARCHAR(10), EffectiveDate, 121)
		                                          AND CONVERT(NVARCHAR(10), GETDATE(), 121) <= CONVERT(NVARCHAR(10), ExpirationDate, 121)
	                                              AND ActiveFlag = 1
		                                          AND DMA_ID = @DealerId
		                               ) THEN '有效'
		                          ELSE '失效'
		                     END
		
		SET @DealerNo = ISNULL(@DealerNo, '');
		SET @DealerNameCn = ISNULL(@DealerNameCn, '');
		SET @DealerNameEn = ISNULL(@DealerNameEn, '');
		SET @DealerNameEnShort = ISNULL(@DealerNameEnShort, '');
		SET @DealerCategory = ISNULL(@DealerCategory, '');
		SET @DealerPlatform = ISNULL(@DealerPlatform, '');
		SET @FirstSign = ISNULL(@FirstSign, '');
		SET @DealerType = ISNULL(@DealerType, '');
		SET @CurrentStatus = ISNULL(@CurrentStatus, '');
		SET @CompanyType = ISNULL(@CompanyType, '');
		
		SELECT @Version = MAX([Version])
		FROM   DP.DealerMaster
		WHERE  ModleID = @ModleId
		       AND DealerId = @DealerId;
		
		IF ISNULL(@Version, '') = ''
		BEGIN
		    SET @HasDiff = 'TRUE';
		END
		ELSE
		BEGIN
		    SELECT @DealerNoOld = ISNULL(Column1, ''),
		           @DealerNameCnOld = ISNULL(Column2, ''),
		           @DealerNameEnOld = ISNULL(Column3, ''),
		           @DealerNameEnShortOld = ISNULL(Column4, ''),
		           @DealerCategoryOld = ISNULL(Column5, ''),
		           @DealerPlatformOld = ISNULL(Column6, ''),
		           @FirstSignOld = ISNULL(Column7, ''),
		           @DealerTypeOld = ISNULL(Column8, ''),
		           @CurrentStatusOld = ISNULL(Column9, ''),
		           @CompanyTypeOld = ISNULL(Column10, '')
		    FROM   DP.DealerMaster
		    WHERE  ModleID = @ModleId
		           AND DealerId = @DealerId
		           AND [Version] = @Version;
		    
		    IF @DealerNoOld <> @DealerNo
		       OR @DealerNameCnOld <> @DealerNameCn
		       OR @DealerNameEnOld <> @DealerNameEn
		       OR @DealerNameEnShortOld <> @DealerNameEnShort
		       OR @DealerCategoryOld <> @DealerCategory
		       OR @DealerPlatformOld <> @DealerPlatform
		       OR @FirstSignOld <> @FirstSign
		       OR @DealerTypeOld <> @DealerType
		       OR @CurrentStatusOld <> @CurrentStatus
		       OR @CompanyTypeOld <> @CompanyType
		    BEGIN
		        SET @HasDiff = 'TRUE';
		    END
		END
		
		IF @HasDiff = 'TRUE'
		BEGIN
		    SET @Version = CONVERT(NVARCHAR(4), YEAR(GETDATE()))
		        + RIGHT ('00' + CONVERT(NVARCHAR(2), MONTH(GETDATE())), 2)
		        + RIGHT ('00' + CONVERT(NVARCHAR(2), DAY(GETDATE())), 2)
		        + '-'
		        + RIGHT ('00' + CONVERT(NVARCHAR(2), DATEPART(hh, GETDATE())), 2)
		        + RIGHT ('00' + CONVERT(NVARCHAR(2), DATEPART(mi, GETDATE())), 2)
		        + RIGHT ('00' + CONVERT(NVARCHAR(2), DATEPART(ss, GETDATE())), 2)
		    
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, [Version], Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, 
		       Column9, Column10, IsAction, CreateBy, CreateDate)
		    VALUES
		      (NEWID(), @DealerId, @ModleId, @Version, @DealerNo, @DealerNameCn, @DealerNameEn, @DealerNameEnShort, @DealerCategory, @DealerPlatform, 
		      @FirstSign, @DealerType, @CurrentStatus, @CompanyType, 1, '00000000-0000-0000-0000-000000000000', GETDATE());
		END
		
		UPDATE DP.DealerMaster
		SET    Column11 = CASE 
		                       WHEN ISNULL(Column7, '') = '' THEN ''
		                       ELSE CONVERT(
		                                NVARCHAR(10),
		                                CONVERT(
		                                    DECIMAL(10, 1),
		                                    CONVERT(
		                                        DECIMAL(10, 1),
		                                        DATEDIFF(MONTH, CONVERT(DATETIME, Column7, 121), GETDATE())
		                                    ) / 12
		                                )
		                            )
		                  END
		WHERE  ModleID = @ModleId
		       AND DealerId = @DealerId;
	END TRY
	BEGIN CATCH
		SET @error_number = ERROR_NUMBER()
		SET @error_serverity = ERROR_SEVERITY()
		SET @error_state = ERROR_STATE()
		SET @error_message = ERROR_MESSAGE()
		SET @error_line = ERROR_LINE()
		SET @error_procedure = ERROR_PROCEDURE()
		SET @vError = 'DP.Proc_SyncDmsBasicInfo第' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + '行出错[错误号：' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']，' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


