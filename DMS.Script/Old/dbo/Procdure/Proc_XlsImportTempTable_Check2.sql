DROP PROCEDURE [dbo].[Proc_XlsImportTempTable_Check2]
GO


CREATE PROCEDURE [dbo].[Proc_XlsImportTempTable_Check2]
(
	@UserId UNIQUEIDENTIFIER,
	@ProcedureName NVARCHAR(200),	 
	@IsValid NVARCHAR(200) = 'Error' OUTPUT  
)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	
	SET @SQL = N'EXEC '+@ProcedureName+' '''+CONVERT(NVARCHAR(100),@UserId)+''',@IsValid OUTPUT' 
 	EXEC SP_EXECUTESQL @SQL,N'@IsValid NVARCHAR(200) output',@IsValid output
 	
END

GO


