DROP PROCEDURE [DP].[Proc_ImportDPDeepComp]
GO


CREATE PROCEDURE [DP].[Proc_ImportDPDeepComp]
	@UserId UNIQUEIDENTIFIER,
	@ImportType NVARCHAR(100),
	@IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
	DECLARE @ErrorCount INTEGER
	SET NOCOUNT ON
	
	BEGIN TRY
		BEGIN TRAN
		
		/*�Ƚ������־��Ϊ0*/
		UPDATE DP.DPImportHead
		SET    ErrorFlag = 0
		WHERE  ImportUser = @UserId
		       AND ImportType = @ImportType
		
		/*��龭�����Ƿ����*/
		UPDATE A
		SET    A.DealerId = B.DMA_ID
		FROM   DP.DPImportHead A,
		       DBO.DealerMaster B
		WHERE  A.DealerCode = B.DMA_SAP_Code
		       AND ImportUser = @UserId
		       AND ImportType = @ImportType
		
		UPDATE A
		SET    A.DealerId = B.DMA_ID
		FROM   DP.DPImportLine A,
		       DBO.DealerMaster B
		WHERE  A.DealerCode = B.DMA_SAP_Code
		       AND ImportUser = @UserId
		       AND ImportType = @ImportType
		
		UPDATE DP.DPImportHead
		SET    ErrorDesc = ISNULL(ErrorDesc, '') + '�����̲�����;',
		       ErrorFlag = 1
		WHERE  DealerId IS NULL
		       AND ImportUser = @UserId
		       AND ImportType = @ImportType
		
		UPDATE A
		SET    ErrorDesc = ISNULL(ErrorDesc, '') + '�����Ʊ�����ֻ���ұ������[BSCҵ��ռ��],[ǰ�ڹ�ͨ],[�ֳ�����],[���ʵ��],[��Ʒ���],[������˵��],[��������],[�Ϲ�����],[���ĸ���]',
		       ErrorFlag = 1
		FROM   DP.DPImportHead A
		WHERE  ImportUser = @UserId
		       AND ImportType = @ImportType
		       AND (
		               EXISTS (
		                   SELECT 1
		                   FROM   DP.DPImportLine B
		                   WHERE  A.HeadId = B.HeadId
		                          AND B.Column4 NOT IN ('BSCҵ��ռ��', 'ǰ�ڹ�ͨ', '�ֳ�����', '���ʵ��', '��Ʒ���', '������˵��', '��������', '�Ϲ�����', '���ĸ���')
		               )
		               OR NOT EXISTS (
		                      SELECT 1
		                      FROM   DP.DPImportLine B
		                      WHERE  A.HeadId = B.HeadId
		                             AND B.Column4 = 'BSCҵ��ռ��'
		                  )
		               OR NOT EXISTS (
		                      SELECT 1
		                      FROM   DP.DPImportLine B
		                      WHERE  A.HeadId = B.HeadId
		                             AND B.Column4 = 'ǰ�ڹ�ͨ'
		                  )
		               OR NOT EXISTS (
		                      SELECT 1
		                      FROM   DP.DPImportLine B
		                      WHERE  A.HeadId = B.HeadId
		                             AND B.Column4 = '�ֳ�����'
		                  )
		               OR NOT EXISTS (
		                      SELECT 1
		                      FROM   DP.DPImportLine B
		                      WHERE  A.HeadId = B.HeadId
		                             AND B.Column4 = '���ʵ��'
		                  )
		               OR NOT EXISTS (
		                      SELECT 1
		                      FROM   DP.DPImportLine B
		                      WHERE  A.HeadId = B.HeadId
		                             AND B.Column4 = '��Ʒ���'
		                  )
		               OR NOT EXISTS (
		                      SELECT 1
		                      FROM   DP.DPImportLine B
		                      WHERE  A.HeadId = B.HeadId
		                             AND B.Column4 = '������˵��'
		                  )
		               OR NOT EXISTS (
		                      SELECT 1
		                      FROM   DP.DPImportLine B
		                      WHERE  A.HeadId = B.HeadId
		                             AND B.Column4 = '��������'
		                  )
		               OR NOT EXISTS (
		                      SELECT 1
		                      FROM   DP.DPImportLine B
		                      WHERE  A.HeadId = B.HeadId
		                             AND B.Column4 = '�Ϲ�����'
		                  )
		               OR NOT EXISTS (
		                      SELECT 1
		                      FROM   DP.DPImportLine B
		                      WHERE  A.HeadId = B.HeadId
		                             AND B.Column4 = '���ĸ���'
		                  )
		           )
		
		/*����Ƿ���ڴ���*/
		SELECT @ErrorCount = COUNT(*)
		FROM   DP.DPImportHead
		WHERE  ErrorFlag = 1
		       AND ImportUser = @UserId
		       AND ImportType = @ImportType
		
		IF @ErrorCount > 0
		BEGIN
		    /*������ڴ����򷵻�Error*/
		    SET @IsValid = 'Error'
		END
		ELSE
		BEGIN
		    /*��������ڴ����򷵻�Success����ִ�г�ʼ�����Ĳ���*/		
		    SET @IsValid = 'Success'
		    
		    DELETE A
		    FROM   DP.DealerMaster A
		    WHERE  A.ModleID = '00000003-0004-0004-0000-000000000000'
		           AND EXISTS (
		                   SELECT 1
		                   FROM   DP.DPImportHead B
		                   WHERE  B.ImportUser = @UserId
		                          AND B.ImportType = @ImportType
		                          AND A.DealerId = B.DealerId
		                          AND A.Column1 = B.Column1
		               );
		    
		    DELETE A
		    FROM   DP.DealerMaster A
		    WHERE  A.ModleID = '00000003-0004-0003-0000-000000000000'
		           AND EXISTS (
		                   SELECT 1
		                   FROM   DP.DPImportHead B
		                   WHERE  B.ImportUser = @UserId
		                          AND B.ImportType = @ImportType
		                          AND A.DealerId = B.DealerId
		                          AND A.Column1 = B.Column1
		               );
		    
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, Column5, Column6, IsAction, CreateBy, CreateDate, SortId)
		    SELECT NEWID(),
		           DealerId,
		           '00000003-0004-0003-0000-000000000000',
		           Column1,
		           Column2,
		           Column3,
		           Column4,
		           Column5,
		           Column6,
		           1,
		           @UserId,
		           GETDATE(),
		           10000 -CONVERT(INT, Column1)
		    FROM   DP.DPImportHead
		    WHERE  ImportUser = @UserId
		           AND ImportType = @ImportType
		    
		    INSERT INTO DP.DealerMaster
		      (ID, DealerId, ModleID, Column1, Column2, Column3, Column4, Column5, IsAction, CreateBy, CreateDate, SortId)
		    SELECT NEWID(),
		           DealerId,
		           '00000003-0004-0004-0000-000000000000',
		           Column1,
		           Column2,
		           Column3,
		           Column4,
		           Column5,
		           1,
		           @UserId,
		           GETDATE(),
		           ROW_NUMBER() OVER(ORDER BY Column3)
		    FROM   DP.DPImportLine
		    WHERE  ImportUser = @UserId
		           AND ImportType = @ImportType
		    
		    /*ɾ���ϴ�����*/
		    DELETE 
		    FROM   DP.DPImportHead
		    WHERE  ImportUser = @UserId
		           AND ImportType = @ImportType
		    
		    DELETE 
		    FROM   DP.DPImportLine
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


