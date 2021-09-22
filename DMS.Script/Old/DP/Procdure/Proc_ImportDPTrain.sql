DROP PROCEDURE [DP].[Proc_ImportDPTrain]
GO


CREATE PROCEDURE [DP].[Proc_ImportDPTrain]
	@UserId UNIQUEIDENTIFIER,
	@IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
	DECLARE @ErrorCount INTEGER
	SET NOCOUNT ON
	
	BEGIN TRY
		BEGIN TRAN
		
		/*先将错误标志设为0*/
		UPDATE DP.DPTrainImport
		SET    ErrorFlag = 0
		WHERE  ImportUser = @UserId
		
		/*检查经销商是否存在*/
		UPDATE A
		SET    A.DealerId = B.DMA_ID
		FROM   DP.DPTrainImport A,
		       DBO.DealerMaster B
		WHERE  A.DealerCode = B.DMA_SAP_Code
		       AND ImportUser = @UserId
		
		UPDATE DP.DPTrainImport
		SET    ErrorDesc = ISNULL(ErrorDesc, '') + '经销商不存在;',
		       ErrorFlag = 1
		WHERE  DealerId IS NULL
		       AND ImportUser = @UserId
		
		/*检查是否存在错误*/
		SELECT @ErrorCount = COUNT(*)
		FROM   DP.DPTrainImport
		WHERE  ErrorFlag = 1
		       AND ImportUser = @UserId
		
		IF @ErrorCount > 0
		BEGIN
		    /*如果存在错误，则返回Error*/
		    SET @IsValid = 'Error'
		END
		ELSE
		BEGIN
		    /*如果不存在错误，则返回Success，并执行初始化库存的操作*/		
		    SET @IsValid = 'Success'
		    
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, 
		       Column5, Column6, Column7, Column8, Column9, Column10, Column11, 
		       Column12, Column13, Column14, IsAction, CreateBy, CreateDate)
		    SELECT NEWID(),
		           DealerId,
		           '00000004-0001-0001-0000-000000000000',
		           TrainDate,
		           TrainTime,
		           TrainDuration,
		           TrainType,
		           TrainOrg,
		           TrainProject,
		           TrainFunction,
		           TrainContent,
		           TrainTeacher,
		           TrainSales,
		           TrainPosition,
		           TrainPhone,
		           TrainHospCode,
		           TrainHospName,
		           1,
		           @UserId,
		           GETDATE()
		    FROM   DP.DPTrainImport
		    WHERE  ImportUser = @UserId
		    
		    /*删除上传数据*/
		    DELETE 
		    FROM   DP.DPTrainImport
		    WHERE  ImportUser = @UserId
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


