DROP PROCEDURE [dbo].[Proc_getTempdbHtmlTable]
GO




/**********************************************
 功能:传入Id,生成HTML的TABLE
 作者：Grapecity
 最后更新时间： 2015-11-23
 更新记录说明：
 1.创建 2015-11-23
**********************************************/
CREATE PROCEDURE [dbo].[Proc_getTempdbHtmlTable](
	@KEYID NVARCHAR(100),	--主键ID
	@KEYCOLUMN NVARCHAR(100), --主键字段名
	@TABLENAME NVARCHAR(100),	--表名
	@iReturn NVARCHAR(MAX) = '' output 
	)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX) 
	DECLARE @iColumnName NVARCHAR(100);
	DECLARE @iColumnString NVARCHAR(MAX);
	DECLARE @iColumnRow NVARCHAR(MAX);
	
	SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
	
	SET @iReturn += '<table class="gridtable">'
	
	SET @iReturn += '<tr>'
	SET @iColumnString = '''<tr>'''
	
	DECLARE @iCURSOR CURSOR;
	SET @iCURSOR = CURSOR FOR SELECT NAME FROM SYSCOLUMNS WHERE ID=OBJECT_ID(@TABLENAME) AND UPPER(NAME) <> UPPER(@KEYCOLUMN) ORDER BY COLORDER
	OPEN @iCURSOR 	
	FETCH NEXT FROM @iCURSOR INTO @iColumnName
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @iReturn += '<th>'+@iColumnName+'</th>'
		SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR,['+@iColumnName+']),'''')+''</td>'''
		
		FETCH NEXT FROM @iCURSOR INTO @iColumnName
	END	
	CLOSE @iCURSOR
	DEALLOCATE @iCURSOR
	SET @iReturn += '</tr>'
	SET @iColumnString += '+''</tr>'''
	
	CREATE TABLE #TMPROW
	(
		ROWVALUE NVARCHAR(MAX)
	)
	
	SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM '+@TABLENAME+' WHERE '+@KEYCOLUMN+'='''+@KEYID+''''
	EXEC(@SQL) 
	 
	DECLARE @iCURSOR_ROW CURSOR;
	SET @iCURSOR_ROW = CURSOR FOR SELECT ROWVALUE FROM #TMPROW
	OPEN @iCURSOR_ROW 	
	FETCH NEXT FROM @iCURSOR_ROW INTO @iColumnRow
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @iReturn += @iColumnRow
		
		FETCH NEXT FROM @iCURSOR_ROW INTO @iColumnRow
	END	
	CLOSE @iCURSOR_ROW
	DEALLOCATE @iCURSOR_ROW
	SET @iReturn += '</table>'
	--select  @iReturn;

	RETURN 
END




GO


