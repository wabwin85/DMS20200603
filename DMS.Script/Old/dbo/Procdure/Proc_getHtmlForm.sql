DROP PROCEDURE [dbo].[Proc_getHtmlForm]
GO



/**********************************************
 功能:传入Id,生成HTML的FORM表单
 作者：Grapecity
 最后更新时间： 2015-11-23
 更新记录说明：
 1.创建 2015-11-23
**********************************************/
CREATE PROCEDURE [dbo].[Proc_getHtmlForm](
	@KEYID NVARCHAR(100),	--主键ID
	@KEYCOLUMN NVARCHAR(100), --主键字段名
	@TABLENAME NVARCHAR(100),	--表名
	@iReturn NVARCHAR(MAX) = '' output 
	)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	DECLARE @iColumnName NVARCHAR(100);
	DECLARE @iColumnValue NVARCHAR(MAX);
	Declare @Count int ;
	
	SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
	
	SET @iReturn += '<table class="gridtable">'
	set @Count=0;
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT NAME FROM SYSCOLUMNS WHERE ID=OBJECT_ID(@TABLENAME) AND UPPER(NAME) <> UPPER(@KEYCOLUMN) ORDER BY COLORDER
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @iColumnName
	WHILE @@FETCH_STATUS = 0
	BEGIN

	    set @Count=@Count+1
		SET @SQL = 'SELECT TOP 1 @iColumnValue = ISNULL(CONVERT(NVARCHAR(Max),['+@iColumnName+']),'''') FROM '+@TABLENAME+' WHERE ['+@KEYCOLUMN+']='''+@KEYID+''''
		EXEC SP_EXECUTESQL @SQL,N'@iColumnValue NVARCHAR(MAX) output',@iColumnValue output
		--if (len(@iColumnValue)>20)
		  -- SET @iColumnValue = substring(@iColumnValue,1,20) + '<br/>' + substring(@iColumnValue,21,len(@iColumnValue)-20)
		
		if(@Count % 2=0)		  
		  SET @iReturn += '<th align="left">'+@iColumnName+'</th><td width="300px">'+@iColumnValue+'</td></tr>'
		else
		  SET @iReturn += '<tr><th align="left">'+@iColumnName+'</th><td width="300px">'+@iColumnValue+'</td>'
		FETCH NEXT FROM @iCURSOR INTO @iColumnName
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR

	if(@Count % 2=1)
	begin
		SET @iReturn += '<th align="left"></th><td width="300px"></td></tr>'
	end

	SET @iReturn += '</table>'
	--select  @iReturn;

	RETURN 
END


GO


