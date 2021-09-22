DROP PROCEDURE [DP].[Proc_ImportDPPay]
GO


CREATE PROCEDURE [DP].[Proc_ImportDPPay]
	@UserId UNIQUEIDENTIFIER,
	@Version NVARCHAR(100),
	@IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
	DECLARE @ErrorCount INTEGER
	SET NOCOUNT ON
	
	BEGIN TRY
		BEGIN TRAN
		
		/*先将错误标志设为0*/
		UPDATE DP.DPPayImport
		SET    ErrorFlag = 0
		WHERE  ImportUser = @UserId
		
		/*检查经销商是否存在*/
		UPDATE A
		SET    A.DealerId = B.DMA_ID
		FROM   DP.DPPayImport A,
		       DBO.DealerMaster B
		WHERE  A.DealerCode = B.DMA_SAP_Code
		       AND ImportUser = @UserId
		
		UPDATE DP.DPPayImport
		SET    ErrorDesc = ISNULL(ErrorDesc, '') + '经销商不存在;',
		       ErrorFlag = 1
		WHERE  DealerId IS NULL
		       AND ImportUser = @UserId
		
		/*检查是否存在错误*/
		SELECT @ErrorCount = COUNT(*)
		FROM   DP.DPPayImport
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
		    
		    DECLARE @DealerId UNIQUEIDENTIFIER;
		    DECLARE @PayCredit NVARCHAR(100);
		    DECLARE @PayCycle NVARCHAR(100);
		    DECLARE @PayContact NVARCHAR(100);
		    DECLARE @PayDealerType NVARCHAR(100);
		    DECLARE @PayAmount NVARCHAR(100);
		    DECLARE @PayIn NVARCHAR(100);
		    DECLARE @Pay0 NVARCHAR(100);
		    DECLARE @Pay31 NVARCHAR(100);
		    DECLARE @Pay61 NVARCHAR(100);
		    DECLARE @Pay91 NVARCHAR(100);
		    DECLARE @Pay181 NVARCHAR(100);
		    DECLARE @Pay361 NVARCHAR(100);
		    
		    DECLARE CUR_CONDITION CURSOR  
		    FOR
		        SELECT DealerId,
		               PayCredit,
		               PayCycle,
		               PayContact,
		               PayDealerType,
		               PayAmount,
		               PayIn,
		               Pay0,
		               Pay31,
		               Pay61,
		               Pay91,
		               Pay181,
		               Pay361
		        FROM   DP.DPPayImport
		        WHERE  ImportUser = @UserId
		    
		    OPEN CUR_CONDITION
		    FETCH NEXT FROM CUR_CONDITION INTO @DealerId,@PayCredit,@PayCycle,@PayContact,
		    @PayDealerType,@PayAmount,@PayIn,@Pay0,@Pay31,@Pay61,@Pay91,@Pay181,
		    @Pay361
		    
		    WHILE @@FETCH_STATUS = 0
		    BEGIN
		        DELETE DP.DealerMaster
		        WHERE  ModleID = '00000004-0001-0004-0000-000000000000'
		               AND DealerId = @DealerId
		               AND [Version] = @Version;
		        
		        INSERT INTO DP.DealerMaster
		          (ID, DealerId, ModleID, [Version], Column1, Column2, Column3, 
		           Column4, Column5, Column6, Column7, Column8, Column9, 
		           Column10, Column11, Column12, IsAction, CreateBy, CreateDate)
		        VALUES
		          (NEWID(), @DealerId, '00000004-0001-0004-0000-000000000000', @Version, @PayCredit, @PayCycle, 
		          @PayContact, @PayDealerType, @PayAmount, @PayIn, @Pay0, @Pay31, 
		          @Pay61, @Pay91, @Pay181, @Pay361, 1, @UserId, GETDATE());
		        
		        FETCH NEXT FROM CUR_CONDITION INTO @DealerId,@PayCredit,@PayCycle,
		        @PayContact,
		        @PayDealerType,@PayAmount,@PayIn,@Pay0,@Pay31,@Pay61,@Pay91,@Pay181,
		        @Pay361
		    END
		    CLOSE CUR_CONDITION
		    DEALLOCATE CUR_CONDITION
		    
		    
		    /*删除上传数据*/
		    DELETE 
		    FROM   DP.DPPayImport
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


