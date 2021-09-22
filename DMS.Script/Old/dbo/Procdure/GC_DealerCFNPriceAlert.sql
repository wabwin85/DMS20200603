DROP procedure [dbo].[GC_DealerCFNPriceAlert]
GO

create procedure [dbo].[GC_DealerCFNPriceAlert]
as

begin

create table #tmp_DMA_Price
(
	DMA_ChineseName nvarchar(100) null,
	CFN_CustomerFaceNbr nvarchar(100) null,
	DMA_SAP_Code nvarchar(100) null,
	CFNCount nvarchar(20) null
)

insert into #tmp_DMA_Price
select distinct d1.DMA_ChineseName,ProductLineName,d2.DMA_SAP_Code ,COUNT(CFN_CustomerFaceNbr) as Cnt
from DealerMaster d1,DealerAuthorizationTable,CFN,DealerMaster d2,V_DivisionProductLineRelation
where d1.DMA_ID = DAT_DMA_ID
and DAT_ProductLine_BUM_ID = CFN_ProductLine_BUM_ID
and CFN_Property4 = 1
and d1.DMA_Parent_DMA_ID = d2.DMA_ID
and DAT_ProductLine_BUM_ID = ProductLineID
and exists (select 1 from CFNPrice where CFNP_Group_ID = d2.DMA_ID and CFNP_CFN_ID = CFN_ID)
and Not exists (select 1 from CFNPrice where CFNP_Group_ID = d1.DMA_ID and CFNP_CFN_ID = CFN_ID)
--and CFN_CustomerFaceNbr like'60P%'
--and d2.DMA_SAP_Code = '369307'
group by d1.DMA_ChineseName,ProductLineName,d2.DMA_SAP_Code

	CREATE TABLE #TMPROW
	(
		ROWVALUE NVARCHAR(MAX)
	)
	DECLARE @iReturn NVARCHAR(MAX) 
	DECLARE @SQL NVARCHAR(MAX) 
	DECLARE @iColumnName NVARCHAR(100);
	DECLARE @iColumnString NVARCHAR(MAX);
	DECLARE @iColumnRow NVARCHAR(MAX);
	DECLARE @ParentDMA NVARCHAR(100);
	
	DECLARE @iCURSOR_List CURSOR;
	SET @iCURSOR_List = CURSOR FOR SELECT distinct DMA_SAP_Code FROM #tmp_DMA_Price
	OPEN @iCURSOR_List 	
	FETCH NEXT FROM @iCURSOR_List INTO @ParentDMA
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
	SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
	
	SET @iReturn += '<table class="gridtable">'
	
	SET @iReturn += '<tr>'
	SET @iColumnString = '''<tr>'''

	SET @iReturn += '<th>二级经销商名称</th><th>产品线</th><th>UPN数量</th>'
	SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[DMA_ChineseName]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[CFN_CustomerFaceNbr]),'''')+''</td><td>''+[CFNCount]+''</td>'''
		
	SET @iReturn += '</tr>'
	SET @iColumnString += '+''</tr>'''


	
	SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM #tmp_DMA_Price WHERE DMA_SAP_Code =''' + @ParentDMA + ''''
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
	
	
	
	INSERT INTO MailMessageQueue
           SELECT newid(),'email','',t4.MDA_MailAddress,MMT_Subject,
                   replace(MMT_Body,'{#CfnList}',@iReturn) AS MMT_Body,
                   'Waiting',getdate(),null
             from dealermaster t2, MailMessageTemplate t3,MailDeliveryAddress t4,client t5
            where MDA_MailType='CfnPrice'
				and t2.DMA_SAP_Code = @ParentDMA
				and t2.DMA_ID = t5.CLT_Corp_Id
               and t4.MDA_MailTo=t5.CLT_ID 
              and t3.MMT_Code='EMAIL_DEALER_CFNPRICE_ALERT'
     
    DELETE FROM #TMPROW
              
    FETCH NEXT FROM @iCURSOR_List INTO @ParentDMA
	END	
	CLOSE @iCURSOR_List
	DEALLOCATE @iCURSOR_List
	
end



GO


