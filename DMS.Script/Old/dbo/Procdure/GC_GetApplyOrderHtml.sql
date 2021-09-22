DROP PROCEDURE [dbo].[GC_GetApplyOrderHtml]
GO

/*
* 获得申请单的Html记录
*/
CREATE PROCEDURE [dbo].[GC_GetApplyOrderHtml]
	@KeyId uniqueidentifier,
	@MainKeyColumn NVARCHAR(100),
	@MainTableName NVARCHAR(100),
	@DetailKeyColumn NVARCHAR(100),
	@DetailTableName NVARCHAR(100),
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(MAX) OUTPUT
AS
SET NOCOUNT ON
BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	DECLARE @MainRtnMsg nvarchar(MAX)
	DECLARE @DetailRtnMsg nvarchar(MAX)
	
	
	EXEC dbo.Proc_getHtmlForm @KeyId,@MainKeyColumn,@MainTableName,@MainRtnMsg OUTPUT  
	EXEC dbo.Proc_getHtmlTable @KeyId,@DetailKeyColumn,@DetailTableName,@DetailRtnMsg OUTPUT  

	SET @RtnMsg = @MainRtnMsg+'<br />'+@DetailRtnMsg
	SELECT @RtnMsg AS HtmlStr
	
COMMIT TRAN

SET NOCOUNT OFF
RETURN 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH
GO


