DROP FUNCTION [dbo].[Func_GetAttachmentHtml]
GO


CREATE FUNCTION [dbo].[Func_GetAttachmentHtml]
(
	@Files NVARCHAR(1000)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @returnValue NVARCHAR(MAX)
	SET @returnValue = '';
	
	DECLARE @FileId NVARCHAR(200) ;
	DECLARE @FileName NVARCHAR(200) ;
	
	DECLARE CUR_FILE CURSOR  
	FOR
	    SELECT AttId,
	           [FILENAME]
	    FROM   [Contract].Attachment
	    WHERE  AttId IN (SELECT *
	                     FROM   dbo.GC_Fn_SplitStringToTable(@Files, ','))
	
	OPEN CUR_FILE
	FETCH NEXT FROM CUR_FILE INTO @FileId,@FileName
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @returnValue += '<a href="' + dbo.Func_GetCode('CONST_CONTRACT_ContractBaseUrl', 'BaseUrl') + 'Contract/FileDownload.aspx?FileId=' + @FileId + '" target="_blank">' + @FileName + '</a><br/>';
	    
	    FETCH NEXT FROM CUR_FILE INTO @FileId,@FileName
	END
	CLOSE CUR_FILE
	DEALLOCATE CUR_FILE
	
	RETURN ISNULL(@returnValue, '')
END
GO


