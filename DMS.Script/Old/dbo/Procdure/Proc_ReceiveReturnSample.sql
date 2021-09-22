DROP PROCEDURE [dbo].[Proc_ReceiveReturnSample]
GO

CREATE PROCEDURE [dbo].[Proc_ReceiveReturnSample](@ReturnNo NVARCHAR(100), @ReceiveUser UNIQUEIDENTIFIER)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
		DECLARE @SampleHeadId UNIQUEIDENTIFIER;
		DECLARE @ReceiveUserName NVARCHAR(100);
		DECLARE @SyncContent NVARCHAR(MAX);
		
		SET @SyncContent = '';
		
		SELECT @ReceiveUserName = IDENTITY_NAME
		FROM   Lafite_IDENTITY
		WHERE  Id = @ReceiveUser
		
		SELECT @SampleHeadId = SampleReturnHeadId
		FROM   SampleReturnHead
		WHERE  ReturnNo = @ReturnNo
		
		UPDATE SampleReturnHead
		SET    ReturnStatus = 'Receive',
		       UpdateDate = GETDATE()
		WHERE  ReturnNo = @ReturnNo
		
		INSERT INTO ScoreCardLog
		  (SCL_ID, SCL_ESC_ID, SCL_OperUser, SCL_OperDate, SCL_OperType, SCL_OperNote)
		VALUES
		  (NEWID(), @SampleHeadId, @ReceiveUserName, GETDATE(), '确认收货', '')
		
		SET @SyncContent += '<InterfaceDataSet><Record><ApplyType>SampleReturn</ApplyType>';
		SET @SyncContent += '<ApplyNo>' + @ReturnNo + '</ApplyNo>';
		SET @SyncContent += '<UserName>' + @ReceiveUserName + '</UserName>';
		SET @SyncContent += '<ApproveDate>' + CONVERT(NVARCHAR(19), GETDATE(), 121) + '</ApproveDate>';
		SET @SyncContent += '<Remark><![CDATA['']]></Remark>';
		SET @SyncContent += '<Status>Receive</Status>';
		SET @SyncContent += '</Record></InterfaceDataSet>';
		
		INSERT INTO SampleSyncStack
		  (SampleHeadId, ApplyType, SampleType, SyncType, SampleNo, SyncContent, SyncStatus, SyncErrCount, SyncMsg, CreateDate)
		VALUES
		  (@SampleHeadId, '退货单', '测试样品', '单据状态', @ReturnNo, @SyncContent, 'Wait', 0, '', GETDATE())
		
		COMMIT TRAN
		RETURN 1
	END TRY
	
	BEGIN CATCH
		ROLLBACK TRAN
		RETURN -1
	END CATCH
END
GO


