DROP PROCEDURE [DP].[Proc_Backup]

GO


CREATE PROCEDURE [DP].[Proc_Backup]
AS
BEGIN
	EXEC DP.Proc_BackupFeedback;
END
GO


