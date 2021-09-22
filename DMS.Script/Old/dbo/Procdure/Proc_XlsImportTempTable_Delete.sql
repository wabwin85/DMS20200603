DROP PROCEDURE [dbo].[Proc_XlsImportTempTable_Delete]
GO


CREATE PROCEDURE [dbo].[Proc_XlsImportTempTable_Delete]
(
	@UserId UNIQUEIDENTIFIER,
	@TableName NVARCHAR(200) 
)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	
	SET @SQL = 'DELETE FROM '+ @TableName +' WHERE II_User = '''+ CONVERT(NVARCHAR(100),@UserId) +''' '
	EXECUTE (@SQL)
END

GO


