DROP PROCEDURE [dbo].[Proc_XlsImportTempTable_GetErrorList]
GO



CREATE PROCEDURE [dbo].[Proc_XlsImportTempTable_GetErrorList]
(
	@UserId UNIQUEIDENTIFIER,
	@TableName NVARCHAR(200) 
)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	
	SET @SQL = 'SELECT *,ROW_NUMBER () OVER (ORDER BY II_LineNbr) AS row_number FROM '+ @TableName +' WHERE II_ErrorFlag=1 AND II_User = '''+ CONVERT(NVARCHAR(100),@UserId) +''' '
	EXECUTE (@SQL)
END

GO


