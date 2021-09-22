DROP Procedure [dbo].[GC_Interface_Transfer_Out]
GO


/*
借货数据上传子过程-生成借出单
*/
CREATE Procedure [dbo].[GC_Interface_Transfer_Out]
	@BatchNbr NVARCHAR(30)
AS
	DECLARE @SysUserId uniqueidentifier

	SET @SysUserId = '00000000-0000-0000-0000-000000000000'

	--生成平台借货出库单
	--取得表头数据
	select newid() as HeaderId,CONVERT(NVARCHAR(100),'') as OrderNo,TNL_FromDealer_DMA_ID as FromDmaId,TNL_ToDealer_DMA_ID as ToDmaId,
	TNL_BUM_ID as BumId,ISNULL(TNL_Remark,'') + CASE WHEN TNL_FileName IS NULL THEN '' ELSE ';平台借货单号：'+ TNL_FileName END as Remark,TNL_TransferDate as TransferDate,CONVERT(NVARCHAR(100),'') as BuName
	into #tmp_header
	from (select TNL_FromDealer_DMA_ID,TNL_ToDealer_DMA_ID,TNL_BUM_ID,TNL_Remark,TNL_TransferDate,TNL_FileName
	FROM TransferNote 
	WHERE TNL_ProblemDescription IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr
	AND TNL_TransferType = 'Out'
	group by TNL_FromDealer_DMA_ID,TNL_ToDealer_DMA_ID,TNL_BUM_ID,TNL_Remark,TNL_TransferDate,TNL_FileName) as t

	--更新BUNAME
	UPDATE #tmp_header SET BuName = attribute_name
	from Lafite_ATTRIBUTE where Id in (
	select rootID from Cache_OrganizationUnits 
	where attributeID = Convert(varchar(36),#tmp_header.BumId))
	and ATTRIBUTE_TYPE = 'BU'

	--取得行数据
  select newid() as LineId, h.HeaderId,t.PmaId,t.FromWhmId,t.ToWhmId,t.TransferQty,t.LineNbr,
	--冗余字段
	t.FromDmaId,t.ToDmaId,t.BumId,t.Remark,t.TransferDate
	INTO #tmp_line
	from (select TNL_FromDealer_DMA_ID as FromDmaId,TNL_ToDealer_DMA_ID as ToDmaId,TNL_BUM_ID as BumId,
	ISNULL(TNL_Remark,'') + CASE WHEN TNL_FileName IS NULL THEN '' ELSE ';平台借货单号：'+ TNL_FileName END as Remark,TNL_TransferDate as TransferDate,TNL_PMA_ID as PmaId,TNL_FromWarehouse_WHM_ID as FromWhmId,
	TNL_ToWarehouse_WHM_ID as ToWhmId,sum(TNL_LotTransferQty) as TransferQty,
	row_number() OVER (PARTITION BY TNL_FromDealer_DMA_ID,TNL_ToDealer_DMA_ID,TNL_BUM_ID,TNL_Remark,TNL_TransferDate
	ORDER BY TNL_FromDealer_DMA_ID,TNL_ToDealer_DMA_ID,TNL_BUM_ID,TNL_Remark,TNL_TransferDate,TNL_PMA_ID,
	TNL_FromWarehouse_WHM_ID,TNL_ToWarehouse_WHM_ID) LineNbr 
	FROM TransferNote 
	WHERE TNL_ProblemDescription IS NULL AND TransferNote.TNL_BatchNbr = @BatchNbr
	AND TNL_TransferType = 'Out'
	group by TNL_FromDealer_DMA_ID ,TNL_ToDealer_DMA_ID ,TNL_BUM_ID ,
	TNL_Remark ,TNL_TransferDate ,TNL_PMA_ID ,TNL_FromWarehouse_WHM_ID ,
	TNL_ToWarehouse_WHM_ID,TNL_FileName 
	) as t
	inner join #tmp_header h on h.FromDmaId = t.FromDmaId
	and h.ToDmaId = t.ToDmaId and h.BumId = t.BumId
	and ISNULL(h.Remark,'') = ISNULL(t.Remark,'')
	and h.TransferDate = t.TransferDate
  
	--取得批次数据
  select newid() as DetailId, l.LineId, Lot.LOT_ID as LotId, a.TNL_FromWarehouse_WHM_ID as WhmId,a.TNL_LotTransferQty as LotTransferQty,
	a.TNL_LotNumber as LotNumber, a.TNL_LTM_ID as LtmId, a.TNL_PMA_ID as PmaId,TNL_UnitPrice AS UnitPrice  
	into #tmp_detail
	from TransferNote a
	INNER JOIN Lot ON Lot.LOT_LTM_ID = a.TNL_LTM_ID
	INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND INV.INV_WHM_ID = a.TNL_FromWarehouse_WHM_ID
	AND INV.INV_PMA_ID = a.TNL_PMA_ID
	inner join #tmp_line l on l.FromDmaId = a.TNL_FromDealer_DMA_ID
	and l.ToDmaId = a.TNL_ToDealer_DMA_ID and l.BumId = a.TNL_BUM_ID
	and ISNULL(l.Remark,'') = ISNULL(a.TNL_Remark,'') + CASE WHEN a.TNL_FileName IS NULL THEN '' ELSE ';平台借货单号：'+ a.TNL_FileName END
	and l.TransferDate = a.TNL_TransferDate
	and l.PmaId = a.TNL_PMA_ID and l.FromWhmId = a.TNL_FromWarehouse_WHM_ID
	and l.ToWhmId = TNL_ToWarehouse_WHM_ID
	WHERE a.TNL_ProblemDescription IS NULL AND a.TNL_BatchNbr = @BatchNbr
	AND a.TNL_TransferType = 'Out'
  

	--生成借货出库单据号
	DECLARE @m_FromDmaId uniqueidentifier
	DECLARE @m_ToDmaId uniqueidentifier
	DECLARE @m_BuName nvarchar(20)
	DECLARE @m_Id uniqueidentifier
	DECLARE @m_OrderNo nvarchar(50)

	DECLARE	curHandleOrderNo CURSOR 
	FOR SELECT HeaderId,FromDmaId,ToDmaId,BuName FROM #tmp_header

	OPEN curHandleOrderNo
	FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_FromDmaId,@m_ToDmaId,@m_BuName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC [GC_GetNextAutoNumber] @m_FromDmaId,'Next_RentNbr',@m_BuName, @m_OrderNo output
		UPDATE #tmp_header SET OrderNo = @m_OrderNo WHERE HeaderId = @m_Id
		FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_FromDmaId,@m_ToDmaId,@m_BuName
	END

	CLOSE curHandleOrderNo
	DEALLOCATE curHandleOrderNo

	--插入借货出库单
	INSERT INTO [Transfer]
	(
		TRN_ID,
		TRN_TransferNumber,
		TRN_FromDealer_DMA_ID,
		TRN_Status,
		TRN_ToDealer_DMA_ID,
		TRN_Type,
		TRN_Description,
		TRN_Reverse_TRN_ID,
		TRN_TransferDate,
		TRN_ProductLine_BUM_ID,
		TRN_Transfer_USR_UserID
	)
	select HeaderId,OrderNo,FromDmaId,'Complete',ToDmaId,'Rent',Remark,null,TransferDate,BumId,@SysUserId
	from #tmp_header

	INSERT INTO TransferLine
	(
		TRL_TRN_ID,
		TRL_TransferPart_PMA_ID,
		TRL_ID,
		TRL_FromWarehouse_WHM_ID,
		TRL_ToWarehouse_WHM_ID,
		TRL_TransferQty,
		TRL_LineNbr
	)
	select HeaderId,PmaId,LineId,FromWhmId,ToWhmId,TransferQty,LineNbr
	from #tmp_line

	INSERT INTO TransferLot
	(
		TLT_TRL_ID,
		TLT_LOT_ID,
		TLT_ID,
		TLT_TransferLotQty,
		TLT_UnitPrice
	)
	select LineId,LotId,DetailId,LotTransferQty,UnitPrice
	from #tmp_detail

	--记录单据日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),HeaderId,@SysUserId,GETDATE(),'Generate',NULL
	FROM #tmp_header

	--记录库存日志
	SELECT -l.TransferQty as ITR_Quantity,
	NEWID() as ITR_ID,l.LineId as ITR_ReferenceID,'借货出库' as ITR_Type,
	l.FromWhmId as ITR_WHM_ID,l.PmaId as ITR_PMA_ID,0 as ITR_UnitPrice,
	'借货出库单：' + h.OrderNo + ' 行：' + Convert(nvarchar(20),l.LineNbr) + '移出' as ITR_TransDescription
	into #tmp_invtrans
	from #tmp_line l
	inner join #tmp_header h on h.HeaderId = l.HeaderId

	select -d.LotTransferQty as ITL_Quantity,
	newid() as ITL_ID,t.ITR_ID as ITL_ITR_ID,
	d.LtmId as ITL_LTM_ID,d.LotNumber as ITL_LotNumber
	into #tmp_invtranslot
	from #tmp_detail d
	inner join #tmp_invtrans t on t.ITR_ReferenceID = d.LineId

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
  
  
  --写入接口表
  INSERT INTO LPRentInterface
  (LRI_ID, LRI_BatchNbr, LRI_RecordNbr, LRI_TranferID, LRI_TransferNo, LRI_Status, LRI_ProcessType, LRI_FileName, LRI_CreateUser, LRI_CreateDate, LRI_UpdateUser, LRI_UpdateDate, LRI_ClientID) 
  SELECT newid(),'',1,t1.HeaderId,t1.OrderNo, 'Pending','Manual',null,'00000000-0000-0000-0000-000000000000',getdate(),null,null,t2.CLT_ID 
    FROM #tmp_header t1, Client t2
   where t1.ToDmaId = t2.CLT_Corp_Id
      
    

GO


