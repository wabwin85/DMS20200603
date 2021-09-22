DROP PROCEDURE [DP].[Proc_ImportDPAudit]
GO


CREATE PROCEDURE [DP].[Proc_ImportDPAudit]
	@UserId UNIQUEIDENTIFIER,
	@ImportType NVARCHAR(100),
	@IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
	DECLARE @ErrorCount INTEGER
	SET NOCOUNT ON
	
	BEGIN TRY
		BEGIN TRAN
		
		/*先将错误标志设为0*/
		UPDATE DP.DPImportHead
		SET    ErrorFlag = 0
		WHERE  ImportUser = @UserId
		       AND ImportType = @ImportType
		
		/*检查经销商是否存在*/
		UPDATE A
		SET    A.DealerId = B.DMA_ID
		FROM   DP.DPImportHead A,
		       DBO.DealerMaster B
		WHERE  A.DealerCode = B.DMA_SAP_Code
		       AND ImportUser = @UserId
		       AND ImportType = @ImportType
		
		UPDATE DP.DPImportHead
		SET    ErrorDesc = ISNULL(ErrorDesc, '') + '经销商不存在;',
		       ErrorFlag = 1
		WHERE  DealerId IS NULL
		       AND ImportUser = @UserId
		       AND ImportType = @ImportType
		
		/*检查是否存在错误*/
		SELECT @ErrorCount = COUNT(*)
		FROM   DP.DPImportHead
		WHERE  ErrorFlag = 1
		       AND ImportUser = @UserId
		       AND ImportType = @ImportType
		
		IF @ErrorCount > 0
		BEGIN
		    /*如果存在错误，则返回Error*/
		    SET @IsValid = 'Error'
		END
		ELSE
		BEGIN
		    /*如果不存在错误，则返回Success，并执行初始化库存的操作*/		
		    SET @IsValid = 'Success'
		    
		    DELETE A
		    FROM   DP.DealerMaster A
		    WHERE  A.ModleID = '00000004-0001-0003-0000-000000000000'
		           AND EXISTS (
		                   SELECT 1
		                   FROM   DP.DPImportHead B
		                   WHERE  B.ImportUser = @UserId
		                          AND B.ImportType = @ImportType
		                          AND A.DealerId = B.DealerId
		                          AND A.Column1 = B.Column1
		                          AND A.Column2 = B.Column2
		                          AND A.Column3 = B.Column3
		                          AND A.Column4 = B.Column4
		               );
		    
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, Column5, Column6, Column7, Column8, Column9, 
		       Column10, Column11, Column12, Column13, Column14, Column15, IsAction, CreateBy, CreateDate, SortId)
		    SELECT NEWID(),
		           DealerId,
		           '00000004-0001-0003-0000-000000000000',
		           Column1,
		           Column2,
		           Column3,
		           Column4,
		           Column5,
		           Column6,
		           Column7,
		           Column8,
		           Column9,
		           Column10,
		           Column11,
		           Column12,
		           Column13,
		           Column14,
		           Column15,
		           1,
		           @UserId,
		           GETDATE(),
		           10000 -CONVERT(INT, Column4)
		    FROM   DP.DPImportHead
		    WHERE  ImportUser = @UserId
		           AND ImportType = @ImportType
		    
		    /*删除上传数据*/
		    DELETE 
		    FROM   DP.DPImportHead
		    WHERE  ImportUser = @UserId
		           AND ImportType = @ImportType
		END 
		COMMIT TRAN
		
		SET NOCOUNT OFF
		RETURN 1
	END TRY
	
	BEGIN CATCH
		SET NOCOUNT OFF
		ROLLBACK TRAN
		SET @IsValid = 'Failure'
		RETURN -1
	END CATCH
GO


