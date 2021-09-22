DROP procedure [dbo].[GC_AutoFrozenLots]
GO

CREATE procedure [dbo].[GC_AutoFrozenLots]
as
begin
	/*库存临时表*/
	create table #tmp_inventory(
	INV_ID uniqueidentifier,
	INV_WHM_ID uniqueidentifier,
	INV_PMA_ID uniqueidentifier,
	INV_OnHandQuantity float,
	INV_WHM_IN_ID uniqueidentifier,
	primary key (INV_ID)
	)

	/*库存明细Lot临时表*/
	create table #tmp_lot(
	LOT_ID uniqueidentifier,
	LOT_LTM_ID uniqueidentifier,
	LOT_WHM_ID uniqueidentifier,
	LOT_PMA_ID uniqueidentifier,
	LOT_INV_ID uniqueidentifier,
	LOT_OnHandQty float,
	LOT_LotNumber nvarchar(50),
	LOT_WHM_IN_ID uniqueidentifier,
	primary key (LOT_ID)
	)
	
	/*库存日志临时表*/
	create table #tmp_invtrans(
	ITR_Quantity         float,
	ITR_ID               uniqueidentifier,
	ITR_ReferenceID      uniqueidentifier, --经销商ID
	ITR_Type             nvarchar(50)         collate Chinese_PRC_CI_AS,
	ITR_WHM_ID           uniqueidentifier,
	ITR_PMA_ID           uniqueidentifier,
	ITR_UnitPrice        float,
	ITR_TransDescription nvarchar(200)        collate Chinese_PRC_CI_AS,
	primary key (ITR_ID)
	)
	/*库存明细Lot日志临时表*/
	create table #tmp_invtranslot(
	ITL_Quantity         float,
	ITL_ID               uniqueidentifier,
	ITL_ITR_ID           uniqueidentifier,
	ITL_LTM_ID           uniqueidentifier,
	ITL_LotNumber        nvarchar(50)         collate Chinese_PRC_CI_AS,
	ITL_ReferenceID      uniqueidentifier,--经销商ID
	primary key (ITL_ID)
	)	
	
	create table #tmp_maillist(
	ML_ID uniqueidentifier,
	ML_DMA_Code			nvarchar(50)         collate Chinese_PRC_CI_AS,
	ML_UPN				nvarchar(50)         collate Chinese_PRC_CI_AS,
	ML_LotNumber        nvarchar(50)         collate Chinese_PRC_CI_AS,
	ML_WHM_Name			nvarchar(50)         collate Chinese_PRC_CI_AS,
	primary key (ML_ID)
	)
	
	
	--根据设定过的每个BU的冻结时间，
	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID,INV_WHM_IN_ID)
	SELECT A.QTY,NEWID(),A.WHM_ID,A.PMA_ID,INV_WHM_IN_ID
	FROM 
	(SELECT  WHM.WHM_ID,PMA_ID,sum(LOT_OnHandQty) AS QTY ,WHM2.WHM_ID AS INV_WHM_IN_ID
	FROM 
	Interface.v_I_QV_DealerInventory_WithQR isr 
	INNER JOIN Warehouse WHM ON WHM.WHM_Code = isr.WHM_Code AND WHM.WHM_Type IN ('Normal','DefaultWH')
	INNER JOIN DealerMaster DMA ON WHM.WHM_DMA_ID = DMA.DMA_ID
	INNER JOIN Product P ON isr.UPN = p.PMA_UPN
	INNER JOIN CFN ON PMA_CFN_ID = CFN_ID
	--INNER JOIN V_ProductClassificationStructure on CFN_ProductCatagory_PCT_ID = CA_ID and (CA_NameCN not like '%设备%' or CC_NameCN not like '%设备%')
	INNER JOIN Inventory ON INV_PMA_ID = p.PMA_ID AND INV_WHM_ID = WHM.WHM_ID
	INNER JOIN LotMaster lm ON  LTM_LotNumber = isr.LOT+'@@'+isr.QRCode
	INNER JOIN Lot ON LOT_LTM_ID = LTM_ID AND INV_ID = LOT_INV_ID 
	INNER JOIN Warehouse WHM2 ON WHM2.WHM_DMA_ID = WHM.WHM_DMA_ID AND WHM2.WHM_Type = 'Frozen'
	--INNER JOIN BULimit B ON B.ProductLine_BUM_ID = CFN_ProductLine_BUM_ID AND Limit_Type = 'Frozen'
	left join (select dma_id,ProductLineID,sum(case when activeFlag = 1 then 1 else 0 end) AS IsActive from V_DealerContractMaster,V_DivisionProductLineRelation
		where Division = DivisionCode group by dma_id,ProductLineID) AS ContractActivity
		on (isr.DealerID = ContractActivity.DMA_ID and CFN.CFN_ProductLine_BUM_ID = ContractActivity.ProductLineID)
	WHERE exists (select 1 from V_ProductClassificationStructure where CFN_ProductCatagory_PCT_ID = CA_ID and (CA_NameCN not like '%设备%' or CC_NameCN not like '%设备%'))
	AND LOT_OnHandQty > 0
	--and CFN_ProductLine_BUM_ID not in ('0f71530b-66d5-44af-9cab-ad65d5449c51','dd1b6adf-3772-4e4a-b9cc-a2b900b5f935')
	and ContractActivity.IsActive>0
	and ReceiptDays-22 >180
	--and DATEDIFF(DAY,ReceiptDate,'2016-12-31') > 180--CONVERT(int,Reason)
	and DMA.DMA_DealerType <>'LP'
	group by WHM.WHM_ID,PMA_ID,WHM2.WHM_ID 
	-- UNION
	-- SELECT  WHM.WHM_ID,isr.PMA_ID,sum(LOT_OnHandQty) AS QTY ,WHM2.WHM_ID AS INV_WHM_IN_ID
	--FROM 
	--Interface.Stage_V_Receipt_UPNLOT_MaxReceiptDate isr 
	--INNER JOIN Warehouse WHM ON WHM.WHM_DMA_ID = isr.WHM_ID AND WHM.WHM_Type IN ('DefaultWH')
	--INNER JOIN DealerMaster DMA ON WHM.WHM_DMA_ID = DMA.DMA_ID
	--INNER JOIN Product P ON isr.PMA_ID = p.PMA_ID
	--INNER JOIN CFN ON PMA_CFN_ID = CFN_ID
	----INNER JOIN V_ProductClassificationStructure on CFN_ProductCatagory_PCT_ID = CA_ID and (CA_NameCN not like '%设备%' or CC_NameCN not like '%设备%')
	--INNER JOIN Inventory ON INV_PMA_ID = isr.PMA_ID AND INV_WHM_ID = WHM.WHM_ID
	--INNER JOIN LotMaster lm ON  LTM_LotNumber = LotNumber
	--INNER JOIN Lot ON LOT_LTM_ID = LTM_ID AND INV_ID = LOT_INV_ID 
	--INNER JOIN Warehouse WHM2 ON WHM2.WHM_DMA_ID = WHM.WHM_DMA_ID AND WHM2.WHM_Type = 'Frozen'
	----INNER JOIN BULimit B ON B.ProductLine_BUM_ID = CFN_ProductLine_BUM_ID AND Limit_Type = 'Frozen'
	--WHERE exists (select 1 from V_ProductClassificationStructure where CFN_ProductCatagory_PCT_ID = CA_ID and (CA_NameCN not like '%设备%' or CC_NameCN not like '%设备%'))
	--AND LOT_OnHandQty > 0
	--and CFN_ProductLine_BUM_ID  in ('0f71530b-66d5-44af-9cab-ad65d5449c51','dd1b6adf-3772-4e4a-b9cc-a2b900b5f935')
	--and DATEDIFF(DAY,ReceiptDate,'2016-11-30') > 180--CONVERT(int,Reason)
	--and DMA.DMA_DealerType <>'LP'
	--and exists (select 1 from V_DealerContractMaster ,V_DivisionProductLineRelation 
	--	where  Division = DivisionCode and dma.DMA_ID = DMA_ID and ProductLineID=CFN_ProductLine_BUM_ID and ActiveFlag = 1)
	--	group by WHM.WHM_ID,isr.PMA_ID,WHM2.WHM_ID 
	) AS A
	
	
	
	--更新库存表，减少经销商库存(减少自有库)
	UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)-Convert(decimal(18,6),TMP.INV_OnHandQuantity)
	FROM #tmp_inventory AS TMP
	WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
	AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID
	
	--增加经销商库存(冻结仓库) 存在的更新，不存在的新增
	UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)+Convert(decimal(18,6),TMP.INV_OnHandQuantity)
	--select *
	FROM #tmp_inventory AS TMP  
	WHERE TMP.INV_WHM_IN_ID = Inventory.INV_WHM_ID
	AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID
	
	INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
	SELECT INV_OnHandQuantity, INV_ID, INV_WHM_IN_ID, INV_PMA_ID
	FROM #tmp_inventory AS TMP	
	WHERE  NOT EXISTS (SELECT 1 FROM Inventory INV WHERE INV.INV_WHM_ID = TMP.INV_WHM_IN_ID
		AND INV.INV_PMA_ID = TMP.INV_PMA_ID)	

	--Lot表，库存扣减
	INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty,LOT_WHM_IN_ID)
	SELECT NEWID(),A.LTM_ID,WHM_ID,A.PMA_ID,A.LOT_LotNumber,A.QTY,WHM_IN_ID
	FROM 
	(
	SELECT p.PMA_ID,WHM.WHM_ID,LTM_ID, lm.LTM_LotNumber AS LOT_LotNumber, sum(LOT_OnHandQty) as QTY,WHM2.WHM_ID AS WHM_IN_ID
	FROM 
	Interface.v_I_QV_DealerInventory_WithQR isr 
	INNER JOIN Warehouse WHM ON WHM.WHM_Code = isr.WHM_Code AND WHM.WHM_Type IN ('Normal','DefaultWH')
	INNER JOIN DealerMaster DMA ON WHM.WHM_DMA_ID = DMA.DMA_ID
	INNER JOIN Product P ON isr.UPN = p.PMA_UPN
	INNER JOIN CFN ON PMA_CFN_ID = CFN_ID
	--INNER JOIN V_ProductClassificationStructure on CFN_ProductCatagory_PCT_ID = CA_ID and (CA_NameCN not like '%设备%' or CC_NameCN not like '%设备%')
	INNER JOIN Inventory ON INV_PMA_ID = p.PMA_ID AND INV_WHM_ID = WHM.WHM_ID
	INNER JOIN LotMaster lm ON  LTM_LotNumber = isr.LOT+'@@'+isr.QRCode
	INNER JOIN Lot ON LOT_LTM_ID = LTM_ID AND INV_ID = LOT_INV_ID 
	INNER JOIN Warehouse WHM2 ON WHM2.WHM_DMA_ID = WHM.WHM_DMA_ID AND WHM2.WHM_Type = 'Frozen'
	--INNER JOIN BULimit B ON B.ProductLine_BUM_ID = CFN_ProductLine_BUM_ID AND Limit_Type = 'Frozen'
	left join (select dma_id,ProductLineID,sum(case when activeFlag = 1 then 1 else 0 end) AS IsActive from V_DealerContractMaster,V_DivisionProductLineRelation
		where Division = DivisionCode group by dma_id,ProductLineID) AS ContractActivity
		on (isr.DealerID = ContractActivity.DMA_ID and CFN.CFN_ProductLine_BUM_ID = ContractActivity.ProductLineID)
	WHERE exists (select 1 from V_ProductClassificationStructure where CFN_ProductCatagory_PCT_ID = CA_ID and (CA_NameCN not like '%设备%' or CC_NameCN not like '%设备%'))
	AND LOT_OnHandQty > 0
	--and CFN_ProductLine_BUM_ID not in ('0f71530b-66d5-44af-9cab-ad65d5449c51','dd1b6adf-3772-4e4a-b9cc-a2b900b5f935')
	and ContractActivity.IsActive>0
	and ReceiptDays-22 >180
	--and DATEDIFF(DAY,ReceiptDate,'2016-12-31') > 180--CONVERT(int,Reason)
	and DMA.DMA_DealerType <>'LP'
	GROUP BY p.PMA_ID,WHM.WHM_ID,LTM_ID, lm.LTM_LotNumber,WHM2.WHM_ID
	--UNION
	--SELECT p.PMA_ID,WHM.WHM_ID,LTM_ID, lm.LTM_LotNumber AS LOT_LotNumber, sum(LOT_OnHandQty) as QTY,WHM2.WHM_ID AS WHM_IN_ID
	--FROM 
	--Interface.Stage_V_Receipt_UPNLOT_MaxReceiptDate isr 
	--INNER JOIN Warehouse WHM ON WHM.WHM_DMA_ID = isr.WHM_ID AND WHM.WHM_Type IN ('DefaultWH')
	--INNER JOIN DealerMaster DMA ON WHM.WHM_DMA_ID = DMA.DMA_ID
	--INNER JOIN Product P ON isr.PMA_ID = p.PMA_ID
	--INNER JOIN CFN ON PMA_CFN_ID = CFN_ID
	--INNER JOIN Inventory ON INV_PMA_ID = p.PMA_ID AND INV_WHM_ID = WHM.WHM_ID
	--INNER JOIN LotMaster lm ON  LTM_LotNumber = isr.LotNumber
	--INNER JOIN Lot ON LOT_LTM_ID = LTM_ID AND INV_ID = LOT_INV_ID 
	--INNER JOIN Warehouse WHM2 ON WHM2.WHM_DMA_ID = DMA.DMA_ID AND WHM2.WHM_Type = 'Frozen'
	--INNER JOIN BULimit B ON B.ProductLine_BUM_ID = CFN_ProductLine_BUM_ID AND Limit_Type = 'Frozen'
	--WHERE DATEDIFF(DAY,ReceiptDate,'2016-11-30') > 180--CONVERT(int,Reason)
	--and exists (select 1 from V_ProductClassificationStructure where CFN_ProductCatagory_PCT_ID = CA_ID and (CA_NameCN not like '%设备%' or CC_NameCN not like '%设备%'))
	--AND LOT_OnHandQty > 0
	--and DMA.DMA_DealerType <>'LP'
	--and CFN_ProductLine_BUM_ID  in ('0f71530b-66d5-44af-9cab-ad65d5449c51','dd1b6adf-3772-4e4a-b9cc-a2b900b5f935')
	--and exists (select 1 from V_DealerContractMaster ,V_DivisionProductLineRelation 
	--	where  Division = DivisionCode and dma.DMA_ID = DMA_ID and ProductLineID=CFN_ProductLine_BUM_ID and ActiveFlag = 1)
	--GROUP BY p.PMA_ID,WHM.WHM_ID,LTM_ID, lm.LTM_LotNumber,WHM2.WHM_ID
	) AS A
	
	
	--更新关联库存主键-二级经销商
	UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
	FROM Inventory INV 
	WHERE INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
	AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID
	
	--更新批次表,减少二级经销商
	UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,6),Lot.LOT_OnHandQty)-Convert(decimal(18,6),TMP.LOT_OnHandQty)
	FROM #tmp_lot AS TMP
	WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID
	
	--更新关联库存主键-平台
	UPDATE tmp SET LOT_INV_ID = INV.INV_ID
	FROM Inventory INV ,#tmp_lot tmp
	WHERE INV.INV_PMA_ID = tmp.LOT_PMA_ID
	and tmp.LOT_WHM_IN_ID = INV.INV_WHM_ID

	--更新LP批次表，存在的更新，不存在的新增
	UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,6),Lot.LOT_OnHandQty)+Convert(decimal(18,6),TMP.LOT_OnHandQty)
	FROM #tmp_lot AS TMP
	WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

	INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
	SELECT LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID 
	FROM #tmp_lot AS TMP
	WHERE NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)
	
	
	
	
	--Inventory操作日志，经销商出库
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT -tmp.LOT_OnHandQty,NEWID(),WHM_DMA_ID,'库存调整：冻结',WHM_ID,tmp.LOT_PMA_ID,0,'库存调整类型：Frozen。从经销商自有仓库移出。'
	FROM #tmp_lot tmp
	INNER JOIN Warehouse ON tmp.LOT_WHM_ID = WHM_ID


	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志，移出经销商仓库
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ReferenceID)
	SELECT -tmp.LOT_OnHandQty,NEWID(),tmp.LOT_LTM_ID,tmp.LOT_LotNumber,WHM_DMA_ID
	FROM #tmp_lot tmp
	INNER JOIN Warehouse ON tmp.LOT_WHM_ID = WHM_ID

	UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
	FROM #tmp_invtrans a 
	WHERE a.ITR_ReferenceID = #tmp_invtranslot.ITL_ReferenceID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
	
	

	--清空日志数据
	DELETE FROM #tmp_invtrans
	DELETE FROM #tmp_invtranslot

	--Inventory操作日志，增加冻结
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT tmp.LOT_OnHandQty,NEWID(),WHM_DMA_ID,'库存调整：冻结',WHM_ID,tmp.LOT_PMA_ID,0,'库存调整类型：Frozen。移入经销商冻结仓库。'
	FROM #tmp_lot tmp
	INNER JOIN Warehouse ON tmp.LOT_WHM_IN_ID = WHM_ID

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志，移入平台仓库
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ReferenceID)
	SELECT tmp.LOT_OnHandQty,NEWID(),tmp.LOT_LTM_ID,tmp.LOT_LotNumber,WHM_DMA_ID
	FROM #tmp_lot tmp
	INNER JOIN Warehouse ON tmp.LOT_WHM_IN_ID = WHM_ID

	UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
	FROM #tmp_invtrans a 
	WHERE a.ITR_ReferenceID = #tmp_invtranslot.ITL_ReferenceID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
	
	
	----发送邮件
	--insert into #tmp_maillist
	--select NEWID(),DMA_SAP_Code,PMA_UPN,LOT_LotNumber,WHM_Name
	--from #tmp_lot t1,Warehouse t2,DealerMaster t3,Product t4
	--where t1.LOT_WHM_ID = t2.WHM_ID
	--and t2.WHM_DMA_ID = t3.DMA_ID
	--and t1.LOT_PMA_ID = t4.PMA_ID
	
	--CREATE TABLE #TMPROW
	--(
	--	ROWVALUE NVARCHAR(MAX)
	--)
	--DECLARE @iReturn NVARCHAR(MAX) 
	--DECLARE @SQL NVARCHAR(MAX) 
	--DECLARE @iColumnName NVARCHAR(100);
	--DECLARE @iColumnString NVARCHAR(MAX);
	--DECLARE @iColumnRow NVARCHAR(MAX);
	--DECLARE @DMA NVARCHAR(100);
	
	--DECLARE @iCURSOR_List CURSOR;
	--SET @iCURSOR_List = CURSOR FOR SELECT distinct ML_DMA_Code FROM #tmp_maillist
	--OPEN @iCURSOR_List 	
	--FETCH NEXT FROM @iCURSOR_List INTO @DMA
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
	
	--SET @iReturn = '<style type="text/css">table.gridtable {font-family: verdana,arial,sans-serif;font-size:11px;color:#333333;border-width: 1px;border-color: #666666;border-collapse: collapse;}table.gridtable th {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #dedede;}table.gridtable td {border-width: 1px;padding: 5px;border-style: solid;border-color: #666666;background-color: #ffffff;}</style>'
	
	--SET @iReturn += '<table class="gridtable">'
	
	--SET @iReturn += '<tr>'
	--SET @iColumnString = '''<tr>'''

	--SET @iReturn += '<th>仓库</th><th>UPN</th><th>批次</th>'
	--SET @iColumnString += '+''<td>''+ISNULL(CONVERT(NVARCHAR(MAX),[ML_WHM_Name]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[ML_UPN]),'''')+''</td><td>''+ISNULL(CONVERT(NVARCHAR(MAX),[ML_LotNumber]),'''')+''</td>'''
		
	--SET @iReturn += '</tr>'
	--SET @iColumnString += '+''</tr>'''


	
	--SET @SQL = 'INSERT INTO #TMPROW(ROWVALUE) SELECT '+@iColumnString+' FROM #tmp_maillist WHERE ML_DMA_Code =''' + @DMA + ''''
	--EXEC(@SQL) 
	 
	--DECLARE @iCURSOR_ROW CURSOR;
	--SET @iCURSOR_ROW = CURSOR FOR SELECT ROWVALUE FROM #TMPROW
	--OPEN @iCURSOR_ROW 	
	--FETCH NEXT FROM @iCURSOR_ROW INTO @iColumnRow
	--WHILE @@FETCH_STATUS = 0
	--BEGIN
	--	SET @iReturn += @iColumnRow
		
	--	FETCH NEXT FROM @iCURSOR_ROW INTO @iColumnRow
	--END	
	--CLOSE @iCURSOR_ROW
	--DEALLOCATE @iCURSOR_ROW
	--SET @iReturn += '</table>'
	
	
	
	--INSERT INTO MailMessageQueue
 --          SELECT newid(),'email','',DMA_Email,MMT_Subject,
 --                  replace(replace(MMT_Body,'{#CfnList}',@iReturn),'{#Month}',6) AS MMT_Body,
 --                  'Waiting',getdate(),null
 --            from dealermaster t2, MailMessageTemplate t3
 --           where t2.DMA_SAP_Code = @DMA
 --             and t3.MMT_Code='EMAIL_DEALER_FROZEN_ALERT'
         
 --   DELETE FROM #TMPROW
    
          
 --   FETCH NEXT FROM @iCURSOR_List INTO @DMA
	--END	
	--CLOSE @iCURSOR_List
	--DEALLOCATE @iCURSOR_List
end


GO


