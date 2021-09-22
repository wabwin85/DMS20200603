DROP procedure [dbo].[GC_SendSampleApplyMessage]
GO

CREATE procedure [dbo].[GC_SendSampleApplyMessage]
as
begin
	DECLARE @iReturn NVARCHAR(MAX) 
	DECLARE @SQL NVARCHAR(MAX) 
	DECLARE @iColumnString NVARCHAR(MAX);
	DECLARE @iColumnRow NVARCHAR(MAX);
	DECLARE @ApplyUserAccount NVARCHAR(500);
	DECLARE @UserName NVARCHAR(50);
	DECLARE @UserEmail NVARCHAR(50);
	DECLARE @ParentUserEmail NVARCHAR(500);
	DECLARE @AlertDays nvarchar(10);
	
	CREATE TABLE #TMPROW
	(
		ROWVALUE NVARCHAR(MAX)
	)
	
	--查找提示日期为30/55/60天的记录，获取HTML，写入邮件发送表
	DECLARE ListCursor CURSOR FOR 
		select  distinct ApplyUserAccount,UserName,UserEmail,AlertDays,ParentUserEmail = STUFF ((
			  SELECT distinct ',' + ParentUserEmail
				from [dbo].[V_NormalSample_DailyAlertDetail] t2
				where t1.UserName = t2.UserName 
					FOR XML PATH ( '' )), 1,  1, '' )
	    FROM [dbo].[V_NormalSample_DailyAlertDetail] T1
	OPEN ListCursor
	FETCH NEXT FROM ListCursor INTO @ApplyUserAccount,@UserName,@UserEmail,@AlertDays,@ParentUserEmail
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
	
	SET @iReturn += '<table class="gridtable">'
	SET @iReturn += '<tr><th>ApplyNo</th><th>UPN</th><th>Lot</th><th>Qty</th></tr>'
	SET @iColumnString = '''<tr>'''
	SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[ApplyNo]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[UPN]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[Lot]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[Qty]),'''')+''</td>'''	
	SET @iColumnString += '+''</tr>'''
	print @iReturn 
	print @iColumnString
	
	SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM dbo.V_NormalSample_DailyAlertDetail WHERE ApplyUserAccount='''+@ApplyUserAccount+''''
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
	
	IF (@AlertDays = '30')
	BEGIN
		insert into MailMessageQueue select NEWID(),'email','',@UserEmail,MMT_Subject,
        --insert into MailMessageQueue select NEWID(),'email','','weiming.sh@foxmail.com',MMT_Subject,
		replace(replace(replace(MMT_Body,'{#UserName}',@UserName),'{#Days}',30),'{#HTML}',@iReturn) AS MMT_Body,'Waiting',getdate(),null
		from MailMessageTemplate
		where MMT_Code='EMAIL_SAMPLE_TRACE_ALERT_30Days'
	END
    
    IF (@AlertDays = '55')
	BEGIN
		insert into MailMessageQueue select NEWID(),'email',isnull(@ParentUserEmail,''),@UserEmail,MMT_Subject,
        --insert into MailMessageQueue select NEWID(),'email','weiming.sh@gmail.com,songweiming@cnc.grapecity.com','weiming.sh@foxmail.com',MMT_Subject,
		replace(replace(replace(MMT_Body,'{#UserName}',@UserName),'{#Days}',55),'{#HTML}',@iReturn) AS MMT_Body,'Waiting',getdate(),null
		from MailMessageTemplate
		where MMT_Code='EMAIL_SAMPLE_TRACE_ALERT_55Days'
	END
	
	IF (@AlertDays = '60')
	BEGIN
		insert into MailMessageQueue select NEWID(),'email',isnull(@ParentUserEmail,''),@UserEmail,MMT_Subject,
        --insert into MailMessageQueue select NEWID(),'email','weiming.sh@gmail.com,songweiming@cnc.grapecity.com','weiming.sh@foxmail.com',MMT_Subject,
		replace(replace(replace(MMT_Body,'{#UserName}',@UserName),'{#Days}',60),'{#HTML}',@iReturn) AS MMT_Body,'Waiting',getdate(),null
		from MailMessageTemplate
		where MMT_Code='EMAIL_SAMPLE_TRACE_ALERT_60Days'
	END
	
	--将已有的内容清空
	SET @iReturn = ''
	SET @iColumnString = ''
	delete from #TMPROW
	
	FETCH NEXT FROM ListCursor INTO @ApplyUserAccount,@UserName,@UserEmail,@AlertDays,@ParentUserEmail
		
	END
	CLOSE ListCursor
	DEALLOCATE ListCursor

	----查找提示日期为30天的记录，获取HTML，写入邮件发送表
	--DECLARE ListCursor30 CURSOR FOR 
	--	select  distinct ApplyUserAccount,UserName,UserEmail,AlertDays,ParentUserEmail = STUFF ((
	--		  SELECT ',' + ParentUserEmail
	--			from [dbo].[V_NormalSample_DailyAlertDetail] t2
	--			where t1.UserName = t2.UserName 
	--				FOR XML PATH ( '' )), 1,  1, '' )
	--	FROM [dbo].[V_NormalSample_DailyAlertDetail] t1
	--	WHERE AlertDays = 30
	--OPEN ListCursor30
	--FETCH NEXT FROM ListCursor30 INTO @ApplyUserAccount,@UserName,@UserEmail,@ParentUserEmail
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
	
	--SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
	
	--SET @iReturn += '<table class="gridtable">'
	--SET @iReturn += '<tr><th>ApplyNo</th><th>UPN</th><th>Lot</th><th>Qty</th></tr>'
	--SET @iColumnString = '''<tr>'''
	--SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[ApplyNo]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[UPN]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[Lot]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[Qty]),'''')+''</td>'''	
	--SET @iColumnString += '+''</tr>'''
	--print @iReturn 
	--print @iColumnString
	
	--SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM dbo.V_NormalSample_DailyAlertDetail WHERE ApplyUserAccount='''+@ApplyUserAccount+''''
	--EXEC(@SQL) 
	 
	--DECLARE @iCURSOR_ROW30 CURSOR;
	--SET @iCURSOR_ROW30 = CURSOR FOR SELECT ROWVALUE FROM #TMPROW
	--OPEN @iCURSOR_ROW30 	
	--FETCH NEXT FROM @iCURSOR_ROW30 INTO @iColumnRow
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
	--	SET @iReturn += @iColumnRow
		
	--	FETCH NEXT FROM @iCURSOR_ROW30 INTO @iColumnRow
	--END	
	--CLOSE @iCURSOR_ROW30
	--DEALLOCATE @iCURSOR_ROW30
	--SET @iReturn += '</table>'
	
	--insert into MailMessageQueue select NEWID(),'email',@ParentUserEmail,@UserEmail,MMT_Subject,
	--replace(replace(replace(MMT_Body,'{#UserName}',@UserName),'{#Days}',30),'{#HTML}',@iReturn) AS MMT_Body,'Waiting',getdate(),null
	--from MailMessageTemplate
	--where MMT_Code='EMAIL_SAMPLE_TRACE_ALERT'
	
	----将已有的内容清空
	--SET @iReturn = ''
	--SET @iColumnString = ''
	--delete from #TMPROW
	
	--FETCH NEXT FROM ListCursor30 INTO @ApplyUserAccount,@UserName,@UserEmail
		
	--END
	--CLOSE ListCursor30
	--DEALLOCATE ListCursor30

end
GO


