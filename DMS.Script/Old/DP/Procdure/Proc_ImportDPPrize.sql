DROP PROCEDURE [DP].[Proc_ImportDPPrize]
GO


CREATE PROCEDURE [DP].[Proc_ImportDPPrize]
	@UserId UNIQUEIDENTIFIER,
	@IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
	DECLARE @ErrorCount INTEGER
	SET NOCOUNT ON
	
	BEGIN TRY
		BEGIN TRAN
		
		/*�Ƚ������־��Ϊ0*/
		UPDATE DP.DPPrizeImport
		SET    ErrorFlag = 0
		WHERE  ImportUser = @UserId
		
		/*��龭�����Ƿ����*/
		UPDATE A
		SET    A.DealerId = B.DMA_ID
		FROM   DP.DPPrizeImport A,
		       DBO.DealerMaster B
		WHERE  A.DealerCode = B.DMA_SAP_Code
		       AND ImportUser = @UserId
		
		UPDATE DP.DPPrizeImport
		SET    ErrorDesc = ISNULL(ErrorDesc, '') + '�����̲�����;',
		       ErrorFlag = 1
		WHERE  DealerId IS NULL
		       AND ImportUser = @UserId
		
		/*����Ƿ���ڴ���*/
		SELECT @ErrorCount = COUNT(*)
		FROM   DP.DPPrizeImport
		WHERE  ErrorFlag = 1
		       AND ImportUser = @UserId
		
		IF @ErrorCount > 0
		BEGIN
		    /*������ڴ����򷵻�Error*/
		    SET @IsValid = 'Error'
		END
		ELSE
		BEGIN
		    /*��������ڴ����򷵻�Success����ִ�г�ʼ�����Ĳ���*/		
		    SET @IsValid = 'Success'
		    
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, IsAction, CreateBy, CreateDate)
		    SELECT NEWID(),
		           DealerId,
		           '00000004-0001-0002-0000-000000000000',
		           PrizeName,
		           PrizeYear,
		           PrizeLevel,
		           PrizeReason,
		           1,
		           @UserId,
		           GETDATE()
		    FROM   DP.DPPrizeImport A
		    WHERE  ImportUser = @UserId
		           AND NOT EXISTS (
		                   SELECT 1
		                   FROM   DP.DealerMaster B
		                   WHERE  B.ModleID = '00000004-0001-0002-0000-000000000000'
		                          AND A.DealerId = B.DealerId
		                          AND ISNULL(A.PrizeName, '') = ISNULL(B.Column1, '')
		                          AND ISNULL(A.PrizeYear, '') = ISNULL(B.Column2, '')
		                          AND ISNULL(A.PrizeLevel, '') = ISNULL(B.Column3, '')
		                          AND ISNULL(A.PrizeReason, '') = ISNULL(B.Column4, '')
		               )
		    
		    /*ɾ���ϴ�����*/
		    DELETE 
		    FROM   DP.DPPrizeImport
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


