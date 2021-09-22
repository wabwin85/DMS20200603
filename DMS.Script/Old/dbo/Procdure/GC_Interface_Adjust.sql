DROP Procedure [dbo].[GC_Interface_Adjust]
GO

/*
其他出入库数据上传
*/
CREATE Procedure [dbo].[GC_Interface_Adjust]
	@BatchNbr NVARCHAR(30),
	@ClientID NVARCHAR(50),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @SysUserId uniqueidentifier
	DECLARE @SystemHoldWarehouse uniqueidentifier
	DECLARE @DefaultWarehouse uniqueidentifier
	DECLARE @DealerId uniqueidentifier
  DECLARE @ErrCnt   INT
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	--经销商主键
	SELECT @DealerId = CLT_Corp_Id FROM Client WHERE CLT_ID = @ClientID
		
	--平台在途库主键
	SELECT @SystemHoldWarehouse = WHM_ID FROM Warehouse WHERE WHM_DMA_ID = @DealerId AND WHM_Type = 'SystemHold'
	--平台默认库主键
	SELECT @DefaultWarehouse = WHM_ID FROM Warehouse WHERE WHM_DMA_ID = @DealerId AND WHM_Type = 'DefaultWH'

	--如果@ClientID不为空，表示从InterfaceAdjust中读取数据
	--产品授权暂不做检查,SNL_Authorized始终1
	INSERT INTO AdjustNote
	(
		ANL_ID,
		ANL_AdjustDate,
		ANL_ArticleNumber,
		ANL_LotNumber,
		ANL_ExpiredDate,
		ANL_LotQty,
		ANL_Remark,
		ANL_AdjustType,
		ANL_LineNbr,
		ANL_FileName,
		ANL_ImportDate,
		ANL_ClientID,
		ANL_BatchNbr,
		ANL_DMA_ID,
		ANL_WHM_ID,
		ANL_Authorized,
		ANL_ProblemDescription,
		ANL_HandleDate
	)
	SELECT 
		NEWID(),
		IIA_AdjustDate,
		IIA_ArticleNumber,
		IIA_LotNumber,
		IIA_ExpiredDate,
		IIA_LotQty,
		IIA_Remark,
		IIA_AdjustType,
		IIA_LineNbr,
		IIA_FileName,
		IIA_ImportDate,
		IIA_ClientID,
		IIA_BatchNbr,
		@DealerId,
		@DefaultWarehouse,
		1,
		NULL,
		GETDATE()
	FROM InterfaceAdjust
	WHERE IIA_BatchNbr = @BatchNbr

	--更新产品信息
	UPDATE AdjustNote 
	SET AdjustNote.ANL_CFN_ID = CFN.CFN_ID, 
	AdjustNote.ANL_PMA_ID = Product.PMA_ID,
	AdjustNote.ANL_BUM_ID = CFN.CFN_ProductLine_BUM_ID,
	AdjustNote.ANL_PCT_ID = CCF.ClassificationId,
	AdjustNote.ANL_HandleDate = GETDATE()
	FROM CFN
	INNER JOIN Product ON Product.PMA_CFN_ID = CFN.CFN_ID
	INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
	WHERE CFN.CFN_CustomerFaceNbr = AdjustNote.ANL_ArticleNumber
	AND AdjustNote.ANL_BatchNbr = @BatchNbr
	AND CCF.ClassificationId IN (SELECT ProducPctId FROM GC_FN_GetDealerAuthProductSub(AdjustNote.ANL_DMA_ID) WHERE ActiveFlag=1)

    --更新错误信息
	UPDATE AdjustNote SET ANL_ProblemDescription = (CASE WHEN ANL_ProblemDescription IS NULL THEN '' ELSE ANL_ProblemDescription + ',' END) + N'产品型号不存在'
	WHERE ANL_CFN_ID IS NULL AND AdjustNote.ANL_BatchNbr = @BatchNbr

	UPDATE AdjustNote SET ANL_ProblemDescription = (CASE WHEN ANL_ProblemDescription IS NULL THEN '' ELSE ANL_ProblemDescription + ',' END) + N'产品未关联产品线'
	WHERE ANL_CFN_ID IS NOT NULL AND ANL_BUM_ID IS NULL AND AdjustNote.ANL_BatchNbr = @BatchNbr

    
    
    --检查UPN + LOT组合是否存在
	Update AN set ANL_ProblemDescription = (CASE WHEN ANL_ProblemDescription IS NULL THEN '' ELSE ANL_ProblemDescription + ',' END) + N'UPN + LOT组合不存在'  
	--select * 
	from AdjustNote AN 
	where NOT EXISTS (select 1 from LotMaster LM, product P 
	                          where CASE WHEN charindex('@@',AN.ANL_LotNumber) > 0 
				                         THEN substring(AN.ANL_LotNumber,1,charindex('@@',AN.ANL_LotNumber)-1) + '@@NoQR' 
				                         ELSE AN.ANL_LotNumber + '@@NoQR'
				                         END  = LM.LTM_LotNumber and LM.LTM_Product_PMA_ID= P.PMA_ID and P.PMA_CFN_ID = AN.ANL_CFN_ID )
	  and NOT EXISTS (select 1 from LotMaster LM , product P 
	                          where AN.ANL_LotNumber = LM.LTM_LotNumber 
	                            and LM.LTM_Product_PMA_ID= P.PMA_ID and P.PMA_CFN_ID = AN.ANL_CFN_ID)
	  and AN.ANL_BatchNbr = @BatchNbr
	  and AN.ANL_AdjustType = 'IN'
	
	

	--如果包含错误信息，则不执行写Lotmaster的操作
	IF (SELECT COUNT(*) FROM AdjustNote WHERE ANL_BatchNbr = @BatchNbr AND ANL_ProblemDescription is not null) = 0
	BEGIN		
		--写入LotMaster
			CREATE TABLE #TmpLotMaster (
			[LTM_InitialQty] float NULL,
			[LTM_ExpiredDate] datetime NULL,
			[LTM_LotNumber] nvarchar(50) NOT NULL,
			[LTM_ID] uniqueidentifier NOT NULL,
			[LTM_CreatedDate] datetime NOT NULL,
			[LTM_PRL_ID] uniqueidentifier NULL,
			[LTM_Product_PMA_ID] uniqueidentifier NULL,
			[LTM_Type] nvarchar(30) NULL,
			[LTM_RelationID] uniqueidentifier NULL)

			insert into #TmpLotMaster
			select 1,null,t1.ANL_LotNumber,newid(),getdate(),null,t2.PMA_ID,null,null
			from AdjustNote t1, product t2
			 where t1.ANL_BatchNbr=@BatchNbr
			 and t1.ANL_ArticleNumber = t2.PMA_UPN
			 and t1.ANL_AdjustType = 'IN'
			 group by t2.PMA_ID,t1.ANL_LotNumber
			 
			 
			  
			 update TLM SET TLM.LTM_ExpiredDate = LM.LTM_ExpiredDate, TLM.LTM_Type = LM.LTM_Type			 
			 from #TmpLotMaster TLM, LotMaster LM
			 where TLM.LTM_Product_PMA_ID=LM.LTM_Product_PMA_ID
			 and  CASE WHEN charindex('@@',TLM.LTM_LotNumber) > 0 
						THEN substring(TLM.LTM_LotNumber,1,charindex('@@',TLM.LTM_LotNumber)-1) + '@@NoQR'
						ELSE TLM.LTM_LotNumber + '@@NoQR'
						END = LM.LTM_LotNumber

			insert into LotMaster            
			select * 
			from #TmpLotMaster TLM 
			where NOT EXISTS (select 1 from LotMaster LM where TLM.LTM_Product_PMA_ID = LM.LTM_Product_PMA_ID and TLM.LTM_LotNumber = LM.LTM_LotNumber)         
			
	END
	

	--根据物料主键和批次号更新批次号主键
	UPDATE AdjustNote
	SET AdjustNote.ANL_LTM_ID = LM.LTM_ID
	FROM LotMaster LM
	WHERE LM.LTM_LotNumber = AdjustNote.ANL_LotNumber
	AND LM.LTM_Product_PMA_ID = AdjustNote.ANL_PMA_ID
	AND AdjustNote.ANL_BatchNbr = @BatchNbr
	AND AdjustNote.ANL_PMA_ID IS NOT NULL
	

	--TODO：检查授权
	
	
	--产品批次号不存在
	UPDATE AdjustNote SET ANL_ProblemDescription = (CASE WHEN ANL_ProblemDescription IS NULL THEN '' ELSE ANL_ProblemDescription + ',' END) + N'产品批次号不存在'
	WHERE ANL_PMA_ID IS NOT NULL AND ANL_LTM_ID IS NULL AND AdjustNote.ANL_BatchNbr = @BatchNbr 

	--检查批次库存量是否足够
	SELECT ANL_WHM_ID,ANL_PMA_ID,ANL_LTM_ID,SUM(CASE ANL_AdjustType WHEN 'In' THEN -ANL_LotQty ELSE ANL_LotQty END) AS ANL_LotQty, 0 AS LOT_OnHandQty 
	INTO #tmp_lot_qty
	FROM AdjustNote
	WHERE ANL_ProblemDescription IS NULL AND ANL_BatchNbr = @BatchNbr
	GROUP BY ANL_WHM_ID,ANL_PMA_ID,ANL_LTM_ID
	--查询当前库存量
	SELECT INV.INV_WHM_ID, INV.INV_PMA_ID, Lot.LOT_LTM_ID, Lot.LOT_OnHandQty
	into #tmp_lot_cur
	FROM Lot
	INNER JOIN Inventory INV ON Lot.LOT_INV_ID = INV.INV_ID
	WHERE EXISTS (SELECT 1 FROM AdjustNote WHERE AdjustNote.ANL_PMA_ID = INV.INV_PMA_ID
	AND AdjustNote.ANL_WHM_ID = INV.INV_WHM_ID AND AdjustNote.ANL_LTM_ID = LOT.LOT_LTM_ID
	AND ANL_ProblemDescription IS NULL AND ANL_BatchNbr = @BatchNbr)
	--更新当前库存量
	UPDATE #tmp_lot_qty SET #tmp_lot_qty.LOT_OnHandQty = #tmp_lot_cur.LOT_OnHandQty
	FROM #tmp_lot_cur WHERE INV_WHM_ID = ANL_WHM_ID
	AND INV_PMA_ID = ANL_PMA_ID
	AND LOT_LTM_ID = ANL_LTM_ID
	
	/*
	UPDATE AdjustNote SET ANL_ProblemDescription = N'该批次产品在仓库中数量不足'
	FROM #tmp_lot_qty AS T
	WHERE AdjustNote.ANL_ProblemDescription IS NULL AND AdjustNote.ANL_BatchNbr = @BatchNbr
	AND T.ANL_WHM_ID = AdjustNote.ANL_WHM_ID
	AND T.ANL_PMA_ID = AdjustNote.ANL_PMA_ID 
	AND T.ANL_LTM_ID = AdjustNote.ANL_LTM_ID
	AND T.LOT_OnHandQty - T.ANL_LotQty < 0
    */
  SELECT @ErrCnt = count (*)
  FROM AdjustNote
  WHERE ANL_BatchNbr = @BatchNbr AND ANL_ProblemDescription IS NOT NULL

  IF (@ErrCnt = 0)
    BEGIN        

    	--DELETE FROM #tmp_lot_qty WHERE LOT_OnHandQty - ANL_LotQty < 0

    	--库存操作
    	/*库存临时表*/
    	create table #tmp_inventory(
    	INV_ID uniqueidentifier,
    	INV_WHM_ID uniqueidentifier,
    	INV_PMA_ID uniqueidentifier,
    	INV_OnHandQuantity float
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
    	primary key (LOT_ID)
    	)

    	--Inventory表
    	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
    	SELECT -A.QTY,NEWID(),A.ANL_WHM_ID,A.ANL_PMA_ID
    	FROM 
    	(SELECT ANL_WHM_ID,ANL_PMA_ID,SUM(ANL_LotQty) AS QTY 
    	FROM #tmp_lot_qty	
    	GROUP BY ANL_WHM_ID,ANL_PMA_ID) AS A

    	--更新库存表，存在的更新，不存在的新增
    	UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)+Convert(decimal(18,6),TMP.INV_OnHandQuantity)
    	FROM #tmp_inventory AS TMP
    	WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
    	AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

    	INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
    	SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID
    	FROM #tmp_inventory AS TMP	
    	WHERE NOT EXISTS (SELECT 1 FROM Inventory INV WHERE INV.INV_WHM_ID = TMP.INV_WHM_ID
    	AND INV.INV_PMA_ID = TMP.INV_PMA_ID)	

    	--Lot表
    	INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
    	SELECT NEWID(),A.ANL_LTM_ID,A.ANL_WHM_ID,A.ANL_PMA_ID,A.LTM_LotNumber,-A.QTY
    	FROM 
    	(SELECT ANL_WHM_ID,ANL_PMA_ID,ANL_LTM_ID,LM.LTM_LotNumber,SUM(ANL_LotQty) AS QTY 
    	FROM #tmp_lot_qty 
    	INNER JOIN LotMaster LM on LM.LTM_ID = ANL_LTM_ID
    	GROUP BY ANL_WHM_ID,ANL_PMA_ID,ANL_LTM_ID,LM.LTM_LotNumber) AS A
    	
    	--更新关联库存主键
    	UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
    	FROM Inventory INV 
    	WHERE INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
    	AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

    	--更新批次表，存在的更新，不存在的新增
    	UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,6),Lot.LOT_OnHandQty)+Convert(decimal(18,6),TMP.LOT_OnHandQty)
    	FROM #tmp_lot AS TMP
    	WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
    	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

    	INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
    	SELECT LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID 
    	FROM #tmp_lot AS TMP
    	WHERE NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
    	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)

    	--生成其他出入库单
    	--取得表头数据
    	select newid() as HeaderId,CONVERT(NVARCHAR(100),'') as OrderNo,ANL_DMA_ID as DmaId,
    	ANL_BUM_ID as BumId,ANL_Remark as Remark,ANL_AdjustDate as AdjustDate,ANL_AdjustType as AdjustType,
    	CONVERT(NVARCHAR(100),'') as BuName
    	into #tmp_header
    	from (select ANL_DMA_ID,ANL_BUM_ID,ANL_Remark,ANL_AdjustDate,ANL_AdjustType
    	FROM AdjustNote 
    	WHERE ANL_ProblemDescription IS NULL AND AdjustNote.ANL_BatchNbr = @BatchNbr
    	group by ANL_DMA_ID,ANL_BUM_ID,ANL_Remark,ANL_AdjustDate,ANL_AdjustType) as t

    	--更新BUNAME
    	UPDATE #tmp_header SET BuName = attribute_name
    	from Lafite_ATTRIBUTE where Id in (
    	select rootID from Cache_OrganizationUnits 
    	where attributeID = Convert(varchar(36),#tmp_header.BumId))
    	and ATTRIBUTE_TYPE = 'BU'

    	--取得行数据
    	select newid() as LineId, h.HeaderId,t.PmaId,t.Qty,t.LineNbr,
    	--冗余字段
    	t.DmaId,t.BumId,t.Remark,t.AdjustDate,t.AdjustType
    	INTO #tmp_line
    	from (select ANL_DMA_ID as DmaId,ANL_BUM_ID as BumId,
    	ANL_Remark as Remark,ANL_AdjustDate as AdjustDate,ANL_AdjustType as AdjustType,
    	ANL_PMA_ID as PmaId,sum(ANL_LotQty) as Qty,
    	row_number() OVER (PARTITION BY ANL_DMA_ID,ANL_BUM_ID,ANL_Remark,ANL_AdjustDate,ANL_AdjustType
    	ORDER BY ANL_DMA_ID,ANL_BUM_ID,ANL_Remark,ANL_AdjustDate,ANL_AdjustType,ANL_PMA_ID) LineNbr 
    	FROM AdjustNote 
    	WHERE ANL_ProblemDescription IS NULL AND AdjustNote.ANL_BatchNbr = @BatchNbr
    	group by ANL_DMA_ID,ANL_BUM_ID,ANL_Remark,ANL_AdjustDate,ANL_AdjustType,ANL_PMA_ID  
    	) as t
    	inner join #tmp_header h on h.DmaId = t.DmaId and h.BumId = t.BumId
    	and ISNULL(h.Remark,'') = ISNULL(t.Remark,'')
    	and h.AdjustDate = t.AdjustDate and h.AdjustType = t.AdjustType

    	--取得批次数据
    	select newid() as DetailId, l.LineId, Lot.LOT_ID as LotId, t.WhmId,t.LotQty,
    	t.LotNumber, t.LtmId, t.PmaId, t.ExpiredDate,t.AdjustType
    	into #tmp_detail
    	from (select ANL_DMA_ID as DmaId,ANL_BUM_ID as BumId,
    	ANL_Remark as Remark,ANL_AdjustDate as AdjustDate,ANL_AdjustType as AdjustType,
    	ANL_PMA_ID as PmaId,ANL_LTM_ID as LtmId,ANL_LotNumber as LotNumber,ANL_WHM_ID as WhmId,sum(ANL_LotQty) as LotQty,
    	max(ANL_ExpiredDate) as ExpiredDate
    	FROM AdjustNote 
    	WHERE ANL_ProblemDescription IS NULL AND AdjustNote.ANL_BatchNbr = @BatchNbr
    	group by ANL_DMA_ID,ANL_BUM_ID,ANL_Remark,ANL_AdjustDate,ANL_AdjustType,ANL_PMA_ID,ANL_LTM_ID,ANL_LotNumber,ANL_WHM_ID
    	) as t
    	INNER JOIN Lot ON Lot.LOT_LTM_ID = t.LtmId
    	INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND INV.INV_WHM_ID = t.WhmId
    	AND INV.INV_PMA_ID = t.PmaId
    	inner join #tmp_line l on l.DmaId = t.DmaId and l.BumId = t.BumId
    	and ISNULL(l.Remark,'') = ISNULL(t.Remark,'')
    	and l.AdjustDate = t.AdjustDate and l.AdjustType = t.AdjustType
    	and l.PmaId = t.PmaId

    	--生成借货出库单据号
    	DECLARE @m_DmaId uniqueidentifier
    	DECLARE @m_BuName nvarchar(20)
    	DECLARE @m_Id uniqueidentifier
    	DECLARE @m_OrderNo nvarchar(50)

    	DECLARE	curHandleOrderNo CURSOR 
    	FOR SELECT HeaderId,DmaId,BuName FROM #tmp_header

    	OPEN curHandleOrderNo
    	FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_BuName

    	WHILE @@FETCH_STATUS = 0
    	BEGIN
    		EXEC [GC_GetNextAutoNumber] @m_DmaId,'Next_AdjustNbr',@m_BuName, @m_OrderNo output
    		UPDATE #tmp_header SET OrderNo = @m_OrderNo WHERE HeaderId = @m_Id
    		FETCH NEXT FROM curHandleOrderNo INTO @m_Id,@m_DmaId,@m_BuName
    	END

    	CLOSE curHandleOrderNo
    	DEALLOCATE curHandleOrderNo

    	--插入借货出库单
    	INSERT INTO InventoryAdjustHeader
    	(
    		IAH_ID,
    		IAH_Reason,
    		IAH_Inv_Adj_Nbr,
    		IAH_DMA_ID,
    		IAH_ApprovalDate,
    		IAH_CreatedDate,
    		IAH_Approval_USR_UserID,
    		IAH_AuditorNotes,
    		IAH_UserDescription,
    		IAH_Status,
    		IAH_CreatedBy_USR_UserID,
    		IAH_Reverse_IAH_ID,
    		IAH_ProductLine_BUM_ID,
    		IAH_WarehouseType
    	)
    	select HeaderId,CASE AdjustType WHEN 'In' THEN 'StockIn' ELSE 'StockOut' END,OrderNo,
    	DmaId,null,GETDATE(),null,null,Remark,'Complete',@SysUserId,null,BumId,'Normal'
    	from #tmp_header

    	INSERT INTO InventoryAdjustDetail
    	(
    		IAD_Quantity,
    		IAD_ID,
    		IAD_PMA_ID,
    		IAD_IAH_ID,
    		IAD_LineNbr
    	)
    	select Qty,LineId,PmaId,HeaderId,LineNbr
    	from #tmp_line

    	INSERT INTO InventoryAdjustLot
    	(
    		IAL_IAD_ID,
    		IAL_ID,
    		IAL_LotQty,
    		IAL_LOT_ID,
    		IAL_WHM_ID,
    		IAL_LotNumber,
    		IAL_ExpiredDate
    	)
    	select LineId,DetailId,LotQty,LotId,WhmId,LotNumber,ExpiredDate
    	from #tmp_detail

    	--记录单据日志
    	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
    	SELECT NEWID(),HeaderId,@SysUserId,GETDATE(),'Generate',NULL
    	FROM #tmp_header

    	--记录库存日志
    	SELECT (CASE h.AdjustType WHEN 'In' THEN d.LotQty ELSE -d.LotQty END) as ITR_Quantity,
    	NEWID() as ITR_ID,d.DetailId as ITR_ReferenceID,(CASE h.AdjustType WHEN 'In' THEN '库存调整：其他入库' ELSE '库存调整：其他出库' END) as ITR_Type,
    	d.WhmId as ITR_WHM_ID,l.PmaId as ITR_PMA_ID,0 as ITR_UnitPrice,
    	'库存调整单：' + h.OrderNo + ' 行：' + Convert(nvarchar(20),l.LineNbr) as ITR_TransDescription
    	into #tmp_invtrans
    	from #tmp_detail d
    	inner join #tmp_line l on l.LineId = d.LineId
    	inner join #tmp_header h on h.HeaderId = l.HeaderId

    	select (CASE d.AdjustType WHEN 'In' THEN d.LotQty ELSE -d.LotQty END) as ITL_Quantity,
    	newid() as ITL_ID,t.ITR_ID as ITL_ITR_ID,
    	d.LtmId as ITL_LTM_ID,d.LotNumber as ITL_LotNumber
    	into #tmp_invtranslot
    	from #tmp_detail d
    	inner join #tmp_invtrans t on t.ITR_ReferenceID = d.DetailId

    	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
    	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

    	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
    	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
    END

COMMIT TRAN	
	
SET NOCOUNT OFF
return 1

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


