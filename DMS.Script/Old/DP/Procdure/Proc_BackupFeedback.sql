DROP PROCEDURE [DP].[Proc_BackupFeedback]
GO


CREATE PROCEDURE [DP].[Proc_BackupFeedback]
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
		
		DECLARE @BackupDate DATETIME;
		SET @BackupDate = GETDATE();
		
		INSERT INTO DP.BscFeedback_Bak
		  (FeedbackId, Bu, SubBu, [Year], [Quarter], SapCode, BscFeedStatus, CurrentProposal, FeedbackCode, ProposalTime, BackupDate)
		SELECT FeedbackId,
		       Bu,
		       SubBu,
		       [Year],
		       [Quarter],
		       SapCode,
		       BscFeedStatus,
		       CurrentProposal,
		       FeedbackCode,
		       ProposalTime,
		       @BackupDate
		FROM   DP.BscFeedback
		
		INSERT INTO DP.BscFeedbackProposal_Bak
		  (ProposalId, FeedbackCode, HospitalCode, ProposalType, ProposalRole, ProposalUser, ProposalContent, ProposalRemark, ProposalTime, BackupDate)
		SELECT ProposalId,
		       FeedbackCode,
		       HospitalCode,
		       ProposalType,
		       ProposalRole,
		       ProposalUser,
		       ProposalContent,
		       ProposalRemark,
		       ProposalTime,
		       @BackupDate
		FROM   DP.BscFeedbackProposal
		
		DELETE DP.BscFeedback_Bak
		WHERE  BackupDate < @BackupDate -7
		
		DELETE DP.BscFeedbackProposal_Bak
		WHERE  BackupDate < @BackupDate -7
		
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
		SET @vError = 'DP.Proc_BackupFeedbackµÚ' + CONVERT(NVARCHAR(10), ISNULL(@error_line, 0))
		    + 'ÐÐ³ö´í[´íÎóºÅ£º' + CONVERT(NVARCHAR(10), ISNULL(@error_number, 0))
		    + ']£¬' + ISNULL(@error_message, '')
		
		INSERT INTO DP.SyncLog
		VALUES
		  (NEWID(), GETDATE(), @vError);
	END CATCH
END
GO


