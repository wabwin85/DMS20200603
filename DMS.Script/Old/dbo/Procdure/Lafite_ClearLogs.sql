DROP PROCEDURE [dbo].[Lafite_ClearLogs]
GO

CREATE PROCEDURE [dbo].[Lafite_ClearLogs]
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Lafite_CategoryLog
	DELETE FROM [Lafite_Log]
    DELETE FROM Lafite_Category
END

GO


