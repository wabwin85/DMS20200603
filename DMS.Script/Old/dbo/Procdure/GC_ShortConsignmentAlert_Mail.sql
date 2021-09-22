DROP Procedure [dbo].[GC_ShortConsignmentAlert_Mail]
GO



CREATE Procedure [dbo].[GC_ShortConsignmentAlert_Mail]
as


	CREATE TABLE #TMPROW
	(
		ROWVALUE NVARCHAR(MAX)
	)
	DECLARE @iReturn NVARCHAR(MAX) 
	DECLARE @SQL NVARCHAR(MAX) 
	DECLARE @iColumnName NVARCHAR(100);
	DECLARE @iColumnString NVARCHAR(MAX);
	DECLARE @iColumnRow NVARCHAR(MAX);

	--���վ����̡���Ʒ�߱��� 
	declare @DealerCode nvarchar(200) 
	declare @UPN nvarchar(200) 
	declare @ShortUPN nvarchar(200) 
	declare @LotNumber nvarchar(200) 
	declare @QrCode nvarchar(200) 
	declare @OrderNo nvarchar(200) 
	declare @Days nvarchar(200) 
	
	declare @startdate nvarchar(20) 
	declare @middate nvarchar(20) 
	declare @enddate nvarchar(20) 
	select @startdate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,-13,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,-13,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,-13,getdate()))) + '��'
	select @middate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,2,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,2,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,2,getdate()))) + '��'
	select @enddate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,7,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,7,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,7,getdate()))) + '��'
	
	

	declare cur  cursor FOR select distinct DMA_SAP_Code from interface.V_I_QV_ShortConsignmentTracking_Alert where  [��������] between 13 and 19 and DMA_SAP_Code not in ('369307','342859','514724')
	OPEN cur
    	FETCH NEXT FROM cur INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	WHILE @@FETCH_STATUS = 0
    	BEGIN
		
		SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
		
		SET @iReturn += '<table class="gridtable">'
		
		SET @iReturn += '<tr>'
		SET @iColumnString = '''<tr>'''

		SET @iReturn += '<th>����������</th><th>UPN</th><th>�̱��</th><th>����</th><th>��ά��</th><th>���뵥��</th><th>��������</th>'
		SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����������]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),UPN),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[�̱��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��ά��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[���뵥��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��������]),'''')+''</td>'''
			
		SET @iReturn += '</tr>'
		SET @iColumnString += '+''</tr>'''
		
		SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM interface.V_I_QV_ShortConsignmentTracking_Alert WHERE [��������] between 13 and 19 and DMA_SAP_Code =''' + @DealerCode  + ''''
		print @SQL;
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
		
		
		--insert into [SM_SendMessage_TaskQueue]
		--select null,null,'24','00','POST','1','hyskele@163.com','SHORTCONSIGNMENT_ALERT',replace(replace(MMT_Body,'{#Day}',13),'{#CfnList}',@iReturn),null,null,null,null,null,null,null,'DMS',GETDATE(),'0',null,'DMS-'+Convert(nvarchar(40),newid())
		--from MailMessageTemplate,DealerMaster,Lafite_IDENTITY
		--where MMT_Code = 'EMAIL_SHORTCONSIGNMENT_ALERT13'
		--and DMA_SAP_Code +'_01' = IDENTITY_CODE
		--and DMA_SAP_Code =@DealerCode
		
		INSERT INTO MailMessageQueue
           SELECT newid(),'email','','Binyan.Zhu@bsci.com',MMT_Subject,
                   replace(replace(replace(replace(replace(replace(MMT_Body,'{#Day}',13),'{#CfnList}',@iReturn),'{#EndDate}',@enddate),'{#StartDate}',@startdate),'{#MidDate}',@middate),'{#Type}','15') AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4
            where  t2.DMA_SAP_Code = @DealerCode
				and t2.DMA_SAP_Code +'_01' = t4.IDENTITY_CODE
              and t3.MMT_Code='EMAIL_SHORTCONSIGNMENT_ALERT13'
		
    	DELETE FROM #TMPROW
    	
    	FETCH NEXT FROM cur INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	END

    	CLOSE cur
    	DEALLOCATE cur



------����20��
	select @startdate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,-20,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,-20,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,-20,getdate()))) + '��'
	select @enddate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,7,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,7,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,7,getdate()))) + '��'
	select @middate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,1,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,1,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,1,getdate()))) + '��'
	
	declare cur20  cursor FOR select distinct DMA_SAP_Code from interface.V_I_QV_ShortConsignmentTracking_Alert where  [��������] between 20 and 26 and DMA_SAP_Code not in ('369307','342859','514724')
	OPEN cur20
    	FETCH NEXT FROM cur20 INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	WHILE @@FETCH_STATUS = 0
    	BEGIN
		
		SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
		
		SET @iReturn += '<table class="gridtable">'
		
		SET @iReturn += '<tr>'
		SET @iColumnString = '''<tr>'''

		SET @iReturn += '<th>����������</th><th>UPN</th><th>�̱��</th><th>����</th><th>��ά��</th><th>���뵥��</th><th>��������</th>'
		SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����������]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),UPN),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[�̱��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��ά��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[���뵥��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��������]),'''')+''</td>'''
			
		SET @iReturn += '</tr>'
		SET @iColumnString += '+''</tr>'''
		
		SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM interface.V_I_QV_ShortConsignmentTracking_Alert WHERE [��������] between 20 and 26 and DMA_SAP_Code =''' + @DealerCode  + ''''
		
		EXEC(@SQL) 
	
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
		
		--insert into [SM_SendMessage_TaskQueue]
		--select null,null,'24','00','POST','1','hyskele@163.com','SHORTCONSIGNMENT_ALERT',replace(replace(MMT_Body,'{#Day}',20),'{#CfnList}',@iReturn),null,null,null,null,null,null,null,'DMS',GETDATE(),'0',null,'DMS-'+Convert(nvarchar(40),newid())
		--from MailMessageTemplate,DealerMaster,Lafite_IDENTITY
		--where MMT_Code = 'EMAIL_SHORTCONSIGNMENT_ALERT20'
		--and DMA_SAP_Code +'_01' = IDENTITY_CODE
		--and DMA_SAP_Code =@DealerCode
		INSERT INTO MailMessageQueue
           SELECT newid(),'email','','Binyan.Zhu@bsci.com',MMT_Subject,
                   replace(replace(replace(replace(MMT_Body,'{#Day}','20��û���ϱ�����'),'{#CfnList}',@iReturn),'{#MidDate}',@middate),'{#StartDate}',@startdate) AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4
            where  t2.DMA_SAP_Code = @DealerCode
				and t2.DMA_SAP_Code +'_01' = t4.IDENTITY_CODE
              and t3.MMT_Code='EMAIL_SHORTCONSIGNMENT_ALERT20'
    	
    	DELETE FROM #TMPROW
    	
    	FETCH NEXT FROM cur20 INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	END

    	CLOSE cur20
    	DEALLOCATE cur20
    	
    ------����27��
	declare cur27  cursor FOR select Distinct DMA_SAP_Code from interface.V_I_QV_ShortConsignmentTracking_Alert where  [��������] between 27 and 33 and DMA_SAP_Code not in ('369307','342859','514724')
	OPEN cur27
    	FETCH NEXT FROM cur27 INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	WHILE @@FETCH_STATUS = 0
    	BEGIN
		
		SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
		
		SET @iReturn += '<table class="gridtable">'
		
		SET @iReturn += '<tr>'
		SET @iColumnString = '''<tr>'''

		SET @iReturn += '<th>����������</th><th>UPN</th><th>�̱��</th><th>����</th><th>��ά��</th><th>���뵥��</th><th>��������</th>'
		SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����������]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),UPN),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[�̱��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��ά��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[���뵥��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��������]),'''')+''</td>'''
			
		SET @iReturn += '</tr>'
		SET @iColumnString += '+''</tr>'''
		
		SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM interface.V_I_QV_ShortConsignmentTracking_Alert WHERE [��������] between 27 and 33 and DMA_SAP_Code =''' + @DealerCode  + ''''
		
		EXEC(@SQL) 
	
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
		
		--insert into [SM_SendMessage_TaskQueue]
		--select null,null,'24','00','POST','1','hyskele@163.com','SHORTCONSIGNMENT_ALERT',replace(replace(MMT_Body,'{#Day}',27),'{#CfnList}',@iReturn),null,null,null,null,null,null,null,'DMS',GETDATE(),'0',null,'DMS-'+Convert(nvarchar(40),newid())
		--from MailMessageTemplate,DealerMaster,Lafite_IDENTITY
		--where MMT_Code = 'EMAIL_SHORTCONSIGNMENT_ALERT27'
		--and DMA_SAP_Code +'_01' = IDENTITY_CODE
		--and DMA_SAP_Code =@DealerCode
		
		INSERT INTO MailMessageQueue
           SELECT newid(),'email','','Binyan.Zhu@bsci.com',MMT_Subject,
                   replace(replace(replace(MMT_Body,'{#Day}',27),'{#CfnList}',@iReturn),'{#Type}','15+5+7') AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4
            where  t2.DMA_SAP_Code = @DealerCode
				and t2.DMA_SAP_Code +'_01' = t4.IDENTITY_CODE
              and t3.MMT_Code='EMAIL_SHORTCONSIGNMENT_ALERT27'
    	
    	DELETE FROM #TMPROW
    	
    	FETCH NEXT FROM cur27 INTO @DealerCode
    	END

    	CLOSE cur27
    	DEALLOCATE cur27
    	
	------����34��
	declare cur34  cursor FOR select Distinct DMA_SAP_Code from interface.V_I_QV_ShortConsignmentTracking_Alert where  [��������] >= 34 and DMA_SAP_Code not in ('369307','342859','514724')
	OPEN cur34
    	FETCH NEXT FROM cur34 INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	WHILE @@FETCH_STATUS = 0
    	BEGIN
		
		SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
		
		SET @iReturn += '<table class="gridtable">'
		
		SET @iReturn += '<tr>'
		SET @iColumnString = '''<tr>'''

		SET @iReturn += '<th>����������</th><th>UPN</th><th>�̱��</th><th>����</th><th>��ά��</th><th>���뵥��</th><th>��������</th>'
		SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����������]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),UPN),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[�̱��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��ά��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[���뵥��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��������]),'''')+''</td>'''
			
		SET @iReturn += '</tr>'
		SET @iColumnString += '+''</tr>'''
		
		SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM interface.V_I_QV_ShortConsignmentTracking_Alert WHERE [��������] >= 34 and DMA_SAP_Code =''' + @DealerCode  + ''''
		
		EXEC(@SQL) 
	
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
		
		--insert into [SM_SendMessage_TaskQueue]
		--select null,null,'24','00','POST','1','hyskele@163.com','SHORTCONSIGNMENT_ALERT',replace(replace(MMT_Body,'{#Day}',27),'{#CfnList}',@iReturn),null,null,null,null,null,null,null,'DMS',GETDATE(),'0',null,'DMS-'+Convert(nvarchar(40),newid())
		--from MailMessageTemplate,DealerMaster,Lafite_IDENTITY
		--where MMT_Code = 'EMAIL_SHORTCONSIGNMENT_ALERT27'
		--and DMA_SAP_Code +'_01' = IDENTITY_CODE
		--and DMA_SAP_Code =@DealerCode
		
		INSERT INTO MailMessageQueue
           SELECT newid(),'email','','Binyan.Zhu@bsci.com',MMT_Subject,
                   replace(replace(replace(MMT_Body,'{#Day}',34),'{#CfnList}',@iReturn),'{#Type}','15+5+7+7') AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4
            where  t2.DMA_SAP_Code = @DealerCode
				and t2.DMA_SAP_Code +'_01' = t4.IDENTITY_CODE
              and t3.MMT_Code='EMAIL_SHORTCONSIGNMENT_ALERT34'
    	
    	DELETE FROM #TMPROW
    	
    	FETCH NEXT FROM cur34 INTO @DealerCode
    	END

    	CLOSE cur34
    	DEALLOCATE cur34
    	
--LP----------------------------------------------------------------------
    select @startdate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,-88,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,-88,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,-13,getdate()))) + '��'
	select @middate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,2,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,2,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,2,getdate()))) + '��'
	select @enddate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,7,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,7,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,7,getdate()))) + '��'
	
	declare curLP  cursor FOR select distinct DMA_SAP_Code from interface.V_I_QV_ShortConsignmentTracking_Alert where  [��������] between 88 and 94 and DMA_SAP_Code in ('369307','342859')
	OPEN curLP
    	FETCH NEXT FROM curLP INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	WHILE @@FETCH_STATUS = 0
    	BEGIN
		
		SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
		
		SET @iReturn += '<table class="gridtable">'
		
		SET @iReturn += '<tr>'
		SET @iColumnString = '''<tr>'''

		SET @iReturn += '<th>����������</th><th>UPN</th><th>�̱��</th><th>����</th><th>��ά��</th><th>���뵥��</th><th>��������</th>'
		SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����������]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),UPN),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[�̱��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��ά��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[���뵥��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��������]),'''')+''</td>'''
			
		SET @iReturn += '</tr>'
		SET @iColumnString += '+''</tr>'''
		
		SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM interface.V_I_QV_ShortConsignmentTracking_Alert WHERE [��������] between 88 and 94 and DMA_SAP_Code =''' + @DealerCode  + ''''
		print @SQL;
		EXEC(@SQL) 
	
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
		
		
		--insert into [SM_SendMessage_TaskQueue]
		--select null,null,'24','00','POST','1','hyskele@163.com','SHORTCONSIGNMENT_ALERT',replace(replace(MMT_Body,'{#Day}',13),'{#CfnList}',@iReturn),null,null,null,null,null,null,null,'DMS',GETDATE(),'0',null,'DMS-'+Convert(nvarchar(40),newid())
		--from MailMessageTemplate,DealerMaster,Lafite_IDENTITY
		--where MMT_Code = 'EMAIL_SHORTCONSIGNMENT_ALERT13'
		--and DMA_SAP_Code +'_01' = IDENTITY_CODE
		--and DMA_SAP_Code =@DealerCode
		
		INSERT INTO MailMessageQueue
           SELECT newid(),'email','','Binyan.Zhu@bsci.com',MMT_Subject,
                   replace(replace(replace(replace(replace(replace(MMT_Body,'{#Day}',88),'{#CfnList}',@iReturn),'{#EndDate}',@enddate),'{#StartDate}',@startdate),'{#MidDate}',@middate),'{#Type}','90') AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4
            where  t2.DMA_SAP_Code = @DealerCode
				and t2.DMA_SAP_Code +'_01' = t4.IDENTITY_CODE
              and t3.MMT_Code='EMAIL_SHORTCONSIGNMENT_ALERT13'
		
    	DELETE FROM #TMPROW
    	
    	FETCH NEXT FROM curLP INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	END

    	CLOSE curLP
    	DEALLOCATE curLP



------����20��
	select @startdate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,-95,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,-95,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,-95,getdate()))) + '��'
	select @enddate = CONVERT(nvarchar(4),DATEPART(year, dateadd(day,1,getdate()))) + '��' + CONVERT(nvarchar(2),DATEPART(month, dateadd(day,1,getdate()))) + '��'+ CONVERT(nvarchar(2),DATEPART(day, dateadd(day,1,getdate()))) + '��'
	
	declare curLP20  cursor FOR select distinct DMA_SAP_Code from interface.V_I_QV_ShortConsignmentTracking_Alert where  [��������] between 95 and 101 and DMA_SAP_Code in ('369307','342859')
	OPEN curLP20
    	FETCH NEXT FROM curLP20 INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	WHILE @@FETCH_STATUS = 0
    	BEGIN
		
		SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
		
		SET @iReturn += '<table class="gridtable">'
		
		SET @iReturn += '<tr>'
		SET @iColumnString = '''<tr>'''

		SET @iReturn += '<th>����������</th><th>UPN</th><th>�̱��</th><th>����</th><th>��ά��</th><th>���뵥��</th><th>��������</th>'
		SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����������]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),UPN),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[�̱��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��ά��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[���뵥��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��������]),'''')+''</td>'''
			
		SET @iReturn += '</tr>'
		SET @iColumnString += '+''</tr>'''
		
		SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM interface.V_I_QV_ShortConsignmentTracking_Alert WHERE [��������] between 95 and 101 and DMA_SAP_Code =''' + @DealerCode  + ''''
		
		EXEC(@SQL) 
	
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
		
		--insert into [SM_SendMessage_TaskQueue]
		--select null,null,'24','00','POST','1','hyskele@163.com','SHORTCONSIGNMENT_ALERT',replace(replace(MMT_Body,'{#Day}',20),'{#CfnList}',@iReturn),null,null,null,null,null,null,null,'DMS',GETDATE(),'0',null,'DMS-'+Convert(nvarchar(40),newid())
		--from MailMessageTemplate,DealerMaster,Lafite_IDENTITY
		--where MMT_Code = 'EMAIL_SHORTCONSIGNMENT_ALERT20'
		--and DMA_SAP_Code +'_01' = IDENTITY_CODE
		--and DMA_SAP_Code =@DealerCode
		INSERT INTO MailMessageQueue
           SELECT newid(),'email','','Binyan.Zhu@bsci.com',MMT_Subject,
                   replace(replace(replace(replace(MMT_Body,'{#Day}','95��û��������'),'{#CfnList}',@iReturn),'{#MidDate}',@enddate),'{#StartDate}',@startdate) AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4
            where  t2.DMA_SAP_Code = @DealerCode
				and t2.DMA_SAP_Code +'_01' = t4.IDENTITY_CODE
              and t3.MMT_Code='EMAIL_SHORTCONSIGNMENT_ALERT20'
    	
    	DELETE FROM #TMPROW
    	
    	FETCH NEXT FROM curLP20 INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	END

    	CLOSE curLP20
    	DEALLOCATE curLP20
    	
    ------����27��
	declare curLP27  cursor FOR select Distinct DMA_SAP_Code from interface.V_I_QV_ShortConsignmentTracking_Alert where  [��������] between 102 and 108 and DMA_SAP_Code in ('369307','342859')
	OPEN curLP27
    	FETCH NEXT FROM curLP27 INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	WHILE @@FETCH_STATUS = 0
    	BEGIN
		
		SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
		
		SET @iReturn += '<table class="gridtable">'
		
		SET @iReturn += '<tr>'
		SET @iColumnString = '''<tr>'''

		SET @iReturn += '<th>����������</th><th>UPN</th><th>�̱��</th><th>����</th><th>��ά��</th><th>���뵥��</th><th>��������</th>'
		SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����������]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),UPN),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[�̱��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��ά��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[���뵥��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��������]),'''')+''</td>'''
			
		SET @iReturn += '</tr>'
		SET @iColumnString += '+''</tr>'''
		
		SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM interface.V_I_QV_ShortConsignmentTracking_Alert WHERE [��������] between 102 and 108 and DMA_SAP_Code =''' + @DealerCode  + ''''
		
		EXEC(@SQL) 
	
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
		
		--insert into [SM_SendMessage_TaskQueue]
		--select null,null,'24','00','POST','1','hyskele@163.com','SHORTCONSIGNMENT_ALERT',replace(replace(MMT_Body,'{#Day}',27),'{#CfnList}',@iReturn),null,null,null,null,null,null,null,'DMS',GETDATE(),'0',null,'DMS-'+Convert(nvarchar(40),newid())
		--from MailMessageTemplate,DealerMaster,Lafite_IDENTITY
		--where MMT_Code = 'EMAIL_SHORTCONSIGNMENT_ALERT27'
		--and DMA_SAP_Code +'_01' = IDENTITY_CODE
		--and DMA_SAP_Code =@DealerCode
		
		INSERT INTO MailMessageQueue
           SELECT newid(),'email','','Binyan.Zhu@bsci.com',MMT_Subject,
                   replace(replace(replace(MMT_Body,'{#Day}',102),'{#CfnList}',@iReturn),'{#Type}','90+5+7') AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4
            where  t2.DMA_SAP_Code = @DealerCode
				and t2.DMA_SAP_Code +'_01' = t4.IDENTITY_CODE
              and t3.MMT_Code='EMAIL_SHORTCONSIGNMENT_ALERT27'
    	
    	DELETE FROM #TMPROW
    	
    	FETCH NEXT FROM curLP27 INTO @DealerCode
    	END

    	CLOSE curLP27
    	DEALLOCATE curLP27
    	
	------����34��
	declare curLP34  cursor FOR select Distinct DMA_SAP_Code from interface.V_I_QV_ShortConsignmentTracking_Alert where  [��������] >= 109 and DMA_SAP_Code  in ('369307','342859')
	OPEN curLP34
    	FETCH NEXT FROM curLP34 INTO @DealerCode--,@UPN,@ShortUPN,@LotNumber,@QrCode,@OrderNo,@Days
    	WHILE @@FETCH_STATUS = 0
    	BEGIN
		
		SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
		
		SET @iReturn += '<table class="gridtable">'
		
		SET @iReturn += '<tr>'
		SET @iColumnString = '''<tr>'''

		SET @iReturn += '<th>����������</th><th>UPN</th><th>�̱��</th><th>����</th><th>��ά��</th><th>���뵥��</th><th>��������</th>'
		SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����������]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),UPN),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[�̱��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[����]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��ά��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[���뵥��]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[��������]),'''')+''</td>'''
			
		SET @iReturn += '</tr>'
		SET @iColumnString += '+''</tr>'''
		
		SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM interface.V_I_QV_ShortConsignmentTracking_Alert WHERE [��������] >= 109 and DMA_SAP_Code =''' + @DealerCode  + ''''
		
		EXEC(@SQL) 
	
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
		
		--insert into [SM_SendMessage_TaskQueue]
		--select null,null,'24','00','POST','1','hyskele@163.com','SHORTCONSIGNMENT_ALERT',replace(replace(MMT_Body,'{#Day}',27),'{#CfnList}',@iReturn),null,null,null,null,null,null,null,'DMS',GETDATE(),'0',null,'DMS-'+Convert(nvarchar(40),newid())
		--from MailMessageTemplate,DealerMaster,Lafite_IDENTITY
		--where MMT_Code = 'EMAIL_SHORTCONSIGNMENT_ALERT27'
		--and DMA_SAP_Code +'_01' = IDENTITY_CODE
		--and DMA_SAP_Code =@DealerCode
		
		INSERT INTO MailMessageQueue
           SELECT newid(),'email','','Binyan.Zhu@bsci.com',MMT_Subject,
                   replace(replace(replace(MMT_Body,'{#Day}',109),'{#CfnList}',@iReturn),'{#Type}','90+5+7+7') AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,Lafite_IDENTITY t4
            where  t2.DMA_SAP_Code = @DealerCode
				and t2.DMA_SAP_Code +'_01' = t4.IDENTITY_CODE
              and t3.MMT_Code='EMAIL_SHORTCONSIGNMENT_ALERT34'
    	
    	DELETE FROM #TMPROW
    	
    	FETCH NEXT FROM curLP34 INTO @DealerCode
    	END

    	CLOSE curLP34
    	DEALLOCATE curLP34
    	

GO


