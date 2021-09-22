DROP Procedure [dbo].[GC_Interface_DealerReturnConfirm]
GO



/*
平台退货确认数据处理
逻辑调整（Edit By SongWeiming on 2016-01-08）
1、二级经销商退换货申请，平台在确认时<IsConfirm>字段可以为空，不管填写是1或0，系统固定作为1处理（如果需要整单拒绝，则此单据包含的每一条明细数据的<Qty>为0）
2、级经销商退换货申请，平台在确认时<QRCode>字段不能修改（DMS中经销商在申请时是什么QR Code，则ERP在处理时，不能修改QR Code）
3、级经销商退换货申请，平台在确认时< WarehouseCode>字段不能修改（DMS中经销商在申请时是什么仓库，则ERP在处理时，不能修改仓库）
4、二级经销商退换货申请，平台在确认时明细行字段<Qty>只能为0或1（引入二维码后，此字段不再代表数量，而是代表审批是否通过，0代表审批拒绝、1代表审批通过）
5、二级经销商退换货申请，平台在确认时<UnitPrice>字段可以为空，如果填写了值，DMS也不会进行记录或处理（因为统一采用标准价格，或者根据二维码可以准确追踪到订单，获取订单价格）
6、二级经销商退换货申请，平台在确认时< IsEnd >字段可以为空，DMS不再进行处理，判断整张退货单是否结束，是根据退货单包含的每一条明细记录是否都已经确认过

*/
CREATE Procedure [dbo].[GC_Interface_DealerReturnConfirm]
	  @BatchNbr NVARCHAR(30),
	  @ClientID NVARCHAR(50),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(MAX) OUTPUT
AS
	DECLARE @SysUserId uniqueidentifier
	DECLARE @NormalWarehouse uniqueidentifier
	DECLARE @DealerId uniqueidentifier
	DECLARE @ConsignmengWarehouse uniqueidentifier
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	--经销商主键
	SELECT @DealerId = CLT_Corp_Id FROM Client WHERE CLT_ID = @ClientID
	--默认仓库主键
	SELECT @NormalWarehouse = WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = @DealerId AND WHM_Type = 'DefaultWH'
	SELECT @ConsignmengWarehouse = WHM_ID FROM Warehouse(nolock) WHERE WHM_DMA_ID = @DealerId AND WHM_Type = 'Borrow' AND WHM_ActiveFlag = 1
	
	update InterfaceDealerReturnConfirm set IDC_ErrorMsg = '' where IDC_BatchNbr = @BatchNbr
	--校验上传数据的正确性
	update IDC
	set IDC_ErrorMsg = '退货单未关联'
	FROM InterfaceDealerReturnConfirm IDC(nolock)
    LEFT OUTER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_Inv_Adj_Nbr = IDC.IDC_ReturnNo AND IAH.IAH_Reason in ('Return','Exchange') 
    LEFT OUTER JOIN DealerMaster DM(nolock) ON IAH_DMA_ID = DMA_ID AND DMA_Parent_DMA_ID = @DealerId
	WHERE IDC_BatchNbr = @BatchNbr
	and IAH_ID IS NULL
	
	update IDC
	set IDC_ErrorMsg = (case when IDC_ErrorMsg  = '' then '' else ',' end) + '退货单状态无效'
	FROM InterfaceDealerReturnConfirm IDC(nolock)
    LEFT OUTER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_Inv_Adj_Nbr = IDC.IDC_ReturnNo AND IAH.IAH_Reason in ('Return','Exchange')
    LEFT OUTER JOIN DealerMaster DM(nolock) ON IAH_DMA_ID = DMA_ID AND DMA_Parent_DMA_ID = @DealerId
	WHERE IDC_BatchNbr = @BatchNbr
	and IAH_ID IS NOT NULL
	and IAH_Status <> 'Submitted'

	update IDC
	set IDC_ErrorMsg = (case when IDC_ErrorMsg  = '' then '' else ',' end) + '产品型号不存在'
	from InterfaceDealerReturnConfirm IDC left join CFN c(nolock) on IDC_UPN = c.CFN_CustomerFaceNbr
	where c.CFN_ID is null
	--and IDC_IsConfirm = 1
	and IDC_BatchNbr = @BatchNbr

	
  --修改原有逻辑，现在需要使用InventoryAdjustLot表的isnull(IAL_QRLOT_ID,IAL_LOT_ID)的方式获取Lotmaster对应的Lotnumber，然后判断LotNumber是否在DMS的退货单明细中存在
  --Edit By Songweiming on 2016-01-08
  update IDC
	set IDC_ErrorMsg = (case when IDC_ErrorMsg  = '' then '' else ',' end) + '产品批号不存在'
	from InterfaceDealerReturnConfirm IDC inner join CFN c(nolock) on IDC_UPN = c.CFN_CustomerFaceNbr
	inner join Product pma(nolock) on c.CFN_ID = pma.PMA_CFN_ID
	left join LotMaster lm(nolock) on IDC_Lot = lm.LTM_LotNumber and pma.PMA_ID = lm.LTM_Product_PMA_ID
	where lm.LTM_ID is null
	--and IDC_IsConfirm = 1
	and IDC_BatchNbr = @BatchNbr
	
	--退货确认数量只能上传0或者1
	update InterfaceDealerReturnConfirm
	set IDC_ErrorMsg = (case when IDC_ErrorMsg  = '' then '' else ',' end) + '退货确认数量只能上传0或者1'
	where IDC_BatchNbr = @BatchNbr 
	and IDC_Qty not in (0,1)
	
	
	;WITH T AS (
     	select IDC_ReturnNo,IDC_UPN,IDC_Lot,COUNT(*) cnt from InterfaceDealerReturnConfirm(nolock)
		where IDC_BatchNbr = @BatchNbr
		group by IDC_ReturnNo,IDC_UPN,IDC_Lot
		HAVING COUNT(*) > 1
     	)
      UPDATE A SET A.IDC_ErrorMsg = (case when IDC_ErrorMsg  = '' then '' else ',' end) + '产品型号和批号上传重复，请检查'
      FROM InterfaceDealerReturnConfirm A,T
      WHERE A.IDC_ReturnNo = T.IDC_ReturnNo
      and A.IDC_UPN = T.IDC_UPN
      AND A.IDC_Lot = T.IDC_Lot
      AND A.IDC_BatchNbr = @BatchNbr
      

  --增加判断明细行是否已处理的校验(从Tmp_DealerReturnConfirm表获取是否已确认过的信息)  
   update IDC
    	set IDC_ErrorMsg = (case when IDC_ErrorMsg  = '' then '' else ',' end) + '此产品批号已确认过,不能重复确认'
     from InterfaceDealerReturnConfirm IDC 
          INNER JOIN Tmp_DealerReturnConfirm DRC(nolock) ON (IDC.IDC_ReturnNo = DRC.TDC_ReturnNo and IDC.IDC_UPN = DRC.TDC_UPN and IDC.IDC_Lot = DRC.TDC_Lot )        
    where IDC_BatchNbr = @BatchNbr

  
  --因为当前Qty字段不作为数量，而是作为是否确认，所以不需要判断库存是否够扣减
 

	declare @cnt int
	select @cnt = COUNT(*) from InterfaceDealerReturnConfirm(nolock) where IDC_ErrorMsg <> '' and IDC_BatchNbr = @BatchNbr
	print @cnt
	IF(@cnt > 0)
	BEGIN
		SET NOCOUNT OFF
		COMMIT TRAN
		SET @RtnVal = 'Success'
		SELECT @RtnMsg = ''
		--(SELECT DISTINCT RtnMsg = Replace(STUFF((   SELECT ';' + '行'+convert(nvarchar(10),IDC_LineNbr)+'出错:'+IDC_ErrorMsg	
          --FROM InterfaceDealerReturnConfirm T where T.IDC_ErrorMsg <> '' and T.IDC_BatchNbr = IDC.IDC_BatchNbr
          --order by IDC_LineNbr
           -- FOR XML PATH('')), 1, 1, ''),';',';')
           -- from InterfaceDealerReturnConfirm IDC WHERE IDC_BatchNbr = @BatchNbr)

		return
	END
	
	--从接口表中插入数据（根据退货单号查询二级经销商的退货单据）
	INSERT INTO AdjustConfirmation (AC_ID,AC_AdjustNo,AC_ConfirmDate,AC_IsConfirm,AC_Remark,AC_LineNbr,AC_FileName,
		AC_IAH_ID,AC_ProblemDescription,AC_HandleDate,AC_ImportDate,AC_ClientID,AC_BatchNbr,AC_TaxRate)
	SELECT IDC_ID,IDC_ReturnNo,IDC_ConfirmDate,IDC_IsConfirm,IDC_Remark,IDC_LineNbr,IDC_FileName,IAH_ID,
		CASE WHEN IAH_ID IS NULL THEN '退货单未关联'
			WHEN IAH_ID IS NOT NULL AND IAH_Status <> 'Submitted' THEN '退货单状态无效'
			ELSE NULL END,GETDATE(),GETDATE(),IDC_ClientID,IDC_BatchNbr, IDC_TaxRate
	FROM InterfaceDealerReturnConfirm I(nolock)
    LEFT OUTER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_Inv_Adj_Nbr = I.IDC_ReturnNo AND IAH.IAH_Reason in ('Return','Exchange')
    LEFT OUTER JOIN DealerMaster DM(nolock) ON IAH_DMA_ID = DMA_ID AND DMA_Parent_DMA_ID = @DealerId
	WHERE IDC_BatchNbr = @BatchNbr

	--AC_ProblemDescription为空的数据，即需要完成退货的单据
	--更新退货单的状态Cancelled  拒绝的直接修改状态，同意的需要根据ISEND和数量判断
	--UPDATE InventoryAdjustHeader SET IAH_Status = 'Reject' 
	--FROM AdjustConfirmation AC WHERE AC_ProblemDescription IS NULL 
	--AND InventoryAdjustHeader.IAH_ID = AC.AC_IAH_ID
	--AND AC_IsConfirm = 0
	--AND AC_BatchNbr = @BatchNbr
	


	--记录单据操作日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),AC_IAH_ID,@SysUserId,GETDATE(),(CASE WHEN AC_IsConfirm = 1 THEN 'Confirm' ELSE 'Cancel' END),NULL
	FROM AdjustConfirmation(nolock) WHERE AC_ProblemDescription IS NULL AND AC_BatchNbr = @BatchNbr

	--AC_IsConfirm=1完成退货操作
	--AC_IsConfirm=0取消退货操作
	
	--如果以后速度慢，可以将退货单表头、行和批次信息都先存入临时表
	--Inventory表，库存扣减
	
	--库存操作
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
	ITR_ReferenceID      uniqueidentifier,
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
	ITL_ReferenceID      uniqueidentifier,
	primary key (ITL_ID)
	)	
	
	
	/*--------------------------普通退货单拒绝处理逻辑-------------------------------*/
	--将确认退货的记录写入临时表 Qty = 0（代表拒绝） 普通退货才扣减库存
	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID,INV_WHM_IN_ID)
	SELECT A.QTY,NEWID(),A.WHM_ID,A.IAD_PMA_ID,IAL_WHM_ID
	FROM 
	(SELECT  WHM.WHM_ID,IAD_PMA_ID,sum(IAL_LotQty) AS QTY ,IAL.IAL_WHM_ID
	FROM InventoryAdjustHeader IAH(nolock) 
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN InventoryAdjustLot IAL(nolock) ON IAL.IAL_IAD_ID = IAD.IAD_ID --and ISNULL(ial_qrlotnumber,ial_lotnumber) = IDC_Lot
	INNER JOIN DealerMaster DMA(nolock) ON IAH.IAH_DMA_ID = DMA.DMA_ID
	INNER JOIN Warehouse WHM(nolock) ON WHM.WHM_DMA_ID = DMA.DMA_ID AND WHM.WHM_Type ='SystemHold'
	INNER JOIN Product P(nolock) ON IAD_PMA_ID = PMA_ID
	----INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND INV.INV_WHM_ID = WHM.WHM_ID
	----AND INV.INV_PMA_ID = IAD.IAD_PMA_ID
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo
	AND IDC_UPN = PMA_UPN AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 0 --退货数量为0代表拒绝，1代表同意
	WHERE IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr
	--and IAH_WarehouseType = 'Normal'
	GROUP BY WHM.WHM_ID,IAD_PMA_ID,IAL_WHM_ID) AS A
	
	--更新库存表，减少二级经销商库存(减少在途库)
	UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)-Convert(decimal(18,6),TMP.INV_OnHandQuantity)
	FROM #tmp_inventory AS TMP
	WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
	AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID
	
	--增加二级经销商库存(退货仓库) 存在的更新，不存在的新增
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
	SELECT NEWID(),A.LOT_LTM_ID,WHM_ID,A.IAD_PMA_ID,A.LOT_LotNumber,A.QTY,IAL_WHM_ID
	FROM 
	(
	SELECT IAD_PMA_ID,WHM2.WHM_ID,Lot.LOT_LTM_ID, lm.LTM_LotNumber AS LOT_LotNumber, SUM(IAL_LotQty) AS QTY,IAL.IAL_WHM_ID
	FROM InventoryAdjustHeader IAH(nolock) 
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN InventoryAdjustLot IAL(nolock) ON IAL.IAL_IAD_ID = IAD.IAD_ID 
	INNER JOIN DealerMaster DMA(nolock) ON IAH.IAH_DMA_ID = DMA.DMA_ID
	INNER JOIN Warehouse WHM2(nolock) ON WHM2.WHM_DMA_ID = DMA.DMA_ID AND WHM2.WHM_Type ='SystemHold'
	INNER JOIN Lot(nolock) ON  ISNULL(IAL_QRLOT_ID,IAL_LOT_ID) = LOT_ID
	INNER JOIN LotMaster LM(nolock) ON Lot.LOT_LTM_ID = LM.LTM_ID 
	INNER JOIN Product pma(nolock) on IAD_PMA_ID = pma.PMA_ID 
	--INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND INV.INV_WHM_ID = WHM_ID
	--AND INV.INV_PMA_ID = pma.PMA_ID
	--INNER JOIN Warehouse WHM on WHM.WHM_DMA_ID = DMA.DMA_ID and whm.WHM_Type in ('Normal','DefaultWH') and IAH_DMA_ID = WHM.WHM_DMA_ID
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo
	AND IDC_UPN = PMA_UPN AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 0
	WHERE  IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr
	--and IAH_WarehouseType = 'Normal'
	group by IAD_PMA_ID,WHM2.WHM_ID, Lot.LOT_LTM_ID, lm.LTM_LotNumber,IAH_WarehouseType,IAL_WHM_ID
	) AS A
	
	--更新关联库存主键-二级经销商
	UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
	FROM Inventory INV 
	WHERE INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
	AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID
	
	--更新批次表,减少二级经销商
	UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,2),Lot.LOT_OnHandQty)-Convert(decimal(18,2),TMP.LOT_OnHandQty)
	FROM #tmp_lot AS TMP
	WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID
	
	--更新关联库存主键-平台
	UPDATE tmp SET LOT_INV_ID = INV.INV_ID
	FROM Inventory INV ,#tmp_lot tmp
	WHERE INV.INV_PMA_ID = tmp.LOT_PMA_ID
	and tmp.LOT_WHM_IN_ID = INV.INV_WHM_ID

	--更新LP批次表，存在的更新，不存在的新增
	UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,2),Lot.LOT_OnHandQty)+Convert(decimal(18,2),TMP.LOT_OnHandQty)
	FROM #tmp_lot AS TMP
	WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

	INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
	SELECT LOT_ID, LOT_LTM_ID, Convert(decimal(18,2),LOT_OnHandQty), LOT_INV_ID 
	FROM #tmp_lot AS TMP
	WHERE NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)
	
	
	
	
	--Inventory操作日志，二级经销商出库
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT -IAL.IAL_LotQty,NEWID(),IAL.IAL_ID,'库存调整：退货',WHM_ID,IAD.IAD_PMA_ID,0,'库存调整类型：Return。从二级经销商在途仓库移出。'
	FROM InventoryAdjustLot IAL(nolock)
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Warehouse WHM(nolock) ON IAH_DMA_ID = WHM.WHM_DMA_ID AND WHM.WHM_Type ='SystemHold'
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo
    AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 0
	WHERE IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr
	--AND IAH_WarehouseType in ('Normal','DefaultWH')

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志，移出二级经销商仓库
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ReferenceID)
	SELECT -IAL.IAL_LotQty,NEWID(),Lot.LOT_LTM_ID,IAL.IAL_LotNumber,IAL.IAL_ID
	FROM InventoryAdjustLot IAL(nolock)
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Lot(nolock) ON Lot.LOT_ID = ISNULL(IAL_QRLOT_ID,IAL_LOT_ID)
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo
    AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 0
	WHERE IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr
	--AND IAH_WarehouseType in ('Normal','DefaultWH')

	UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
	FROM #tmp_invtrans a 
	WHERE a.ITR_ReferenceID = #tmp_invtranslot.ITL_ReferenceID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
	
	

	--清空日志数据
	DELETE FROM #tmp_invtrans
	DELETE FROM #tmp_invtranslot

	--Inventory操作日志，增加平台
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT IAL.IAL_LotQty,NEWID(),IAL.IAL_ID,'库存调整：退货',IAL_WHM_ID,IAD.IAD_PMA_ID,0,'库存调整类型：Return。移回二级经销商仓库。'
	FROM InventoryAdjustLot IAL(nolock)
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo
    AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 0
	WHERE IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志，移入平台仓库
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ReferenceID)
	SELECT IAL.IAL_LotQty,NEWID(),Lot.LOT_LTM_ID,IAL.IAL_LotNumber,IAL.IAL_ID
	FROM InventoryAdjustLot IAL(nolock)
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Lot(nolock) ON Lot.LOT_ID = ISNULL(IAL_QRLOT_ID,IAL_LOT_ID)
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo
    AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 0
	WHERE IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr

	UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
	FROM #tmp_invtrans a 
	WHERE a.ITR_ReferenceID = #tmp_invtranslot.ITL_ReferenceID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
	
	
	--清空日志数据
	DELETE FROM #tmp_invtrans
	DELETE FROM #tmp_invtranslot
	
	--清空库存临时表
	DELETE FROM #tmp_inventory
	DELETE FROM #tmp_lot
	
	--更新dbo.InventoryAdjustLot表，如果是拒绝，则将数量修改为0
	update IAL
	set IAL_LotQty = 0
	FROM InventoryAdjustHeader IAH(nolock) 
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN InventoryAdjustLot IAL ON IAL.IAL_IAD_ID = IAD.IAD_ID 
	INNER JOIN DealerMaster DMA(nolock) ON IAH.IAH_DMA_ID = DMA.DMA_ID
	INNER JOIN Warehouse WHM2(nolock) ON WHM2.WHM_DMA_ID = DMA.DMA_ID AND WHM2.WHM_Type ='SystemHold'
	INNER JOIN Lot(nolock) ON  ISNULL(IAL_QRLOT_ID,IAL_LOT_ID) = LOT_ID
	INNER JOIN LotMaster LM(nolock) ON Lot.LOT_LTM_ID = LM.LTM_ID 
	INNER JOIN Product pma(nolock) on IAD_PMA_ID = pma.PMA_ID 
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo
	AND IDC_UPN = PMA_UPN AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 0
	WHERE  IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr
	
	/*-----------------------------------退货单同意处理逻辑---------------------------------------------------*/
	
	--将确认退货的记录写入临时表 Qty = 1(Qty作为是否确认的标识，不作为数量)
	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID,INV_WHM_IN_ID)
		SELECT A.QTY,NEWID(),A.WHM_ID,A.PMA_ID,A.WHM_IN_ID
		FROM 
		(
		SELECT WHM2.WHM_ID, IAL.IAL_WHM_ID as WHM_IN_ID,
		PMA_ID, sum(IAL_LotQty) AS QTY 
		FROM InterfaceDealerReturnConfirm(nolock)
		INNER JOIN LotMaster LM(nolock) ON IDC_Lot = LM.LTM_LotNumber
		INNER JOIN Lot(nolock) ON Lot.LOT_LTM_ID = LM.LTM_ID
		--LEFT JOIN Warehouse WHM ON IDC_WarehouseCode = WHM.WHM_Code
		INNER JOIN CFN c(nolock) on IDC_UPN = c.CFN_CustomerFaceNbr
		INNER JOIN Product pma(nolock) on c.CFN_ID = pma.PMA_CFN_ID
		INNER JOIN InventoryAdjustHeader IAH(nolock) ON IDC_ReturnNo = IAH.IAH_Inv_Adj_Nbr
		INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAD.IAD_IAH_ID = IAH.IAH_ID AND pma.PMA_ID = IAD.IAD_PMA_ID
		INNER JOIN InventoryAdjustLot IAL(nolock) ON IAD.IAD_ID = IAL.IAL_IAD_ID and ISNULL(ial_qrlotnumber,ial_lotnumber) = IDC_Lot
		INNER JOIN DealerMaster DMA(nolock) ON IAH.IAH_DMA_ID = DMA.DMA_ID
		INNER JOIN Warehouse WHM2(nolock) ON WHM2.WHM_DMA_ID = DMA.DMA_ID AND WHM2.WHM_Type ='SystemHold'
		INNER JOIN Inventory INV(nolock) ON INV.INV_ID = Lot.LOT_INV_ID AND INV.INV_WHM_ID =  WHM2.WHM_ID 
		AND INV.INV_PMA_ID = pma.PMA_ID
		WHERE IDC_ErrorMsg = '' AND IDC_BatchNbr = @BatchNbr
		and IDC_Qty = 1
		GROUP BY IAL_WHM_ID,WHM2.WHM_ID,PMA_ID,IAH_WarehouseType) AS A
	
	--更新库存表，减少二级经销商库存(减少在途库)
	UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)-Convert(decimal(18,6),TMP.INV_OnHandQuantity)
	FROM #tmp_inventory AS TMP
	WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
	AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID
	
	--增加LP库存 存在的更新，不存在的新增
	UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)+Convert(decimal(18,6),TMP.INV_OnHandQuantity)
	--select *
	FROM #tmp_inventory AS TMP ,Warehouse wh 
	WHERE TMP.INV_WHM_IN_ID = WH.WHM_ID
	AND Inventory.INV_WHM_ID = (case when WHM_Type = 'Consignment' then @ConsignmengWarehouse else @NormalWarehouse end)
	AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID
	
	INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
	SELECT INV_OnHandQuantity, INV_ID, (case when WHM_Type = 'Consignment' then @ConsignmengWarehouse else @NormalWarehouse end), INV_PMA_ID
	FROM #tmp_inventory AS TMP	,Warehouse wh
	WHERE TMP.INV_WHM_IN_ID = WH.WHM_ID 
	AND NOT EXISTS (SELECT 1 FROM Inventory INV WHERE INV.INV_WHM_ID = (case when WHM_Type = 'Consignment' then @ConsignmengWarehouse else @NormalWarehouse end)
	AND INV.INV_PMA_ID = TMP.INV_PMA_ID)	

	--Lot表，库存扣减
	INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty,LOT_WHM_IN_ID)
	SELECT NEWID(),A.LOT_LTM_ID,WHM_ID,A.PMA_ID,A.LOT_LotNumber,A.QTY,WHM_IN_ID
	FROM 
	(
	SELECT PMA_ID,WHM2.WHM_ID,IAL.IAL_WHM_ID as WHM_IN_ID,--CASE WHEN IAH.IAH_WarehouseType= 'Normal' THEN WHM2.WHM_ID ELSE WHM.WHM_ID END AS WHM_IN_ID, 
	Lot.LOT_LTM_ID, lm.LTM_LotNumber AS LOT_LotNumber, SUM(IAL_LotQty) AS QTY
	FROM InterfaceDealerReturnConfirm(nolock)
	INNER JOIN LotMaster LM(nolock) ON IDC_Lot = LM.LTM_LotNumber
	INNER JOIN Lot(nolock) ON Lot.LOT_LTM_ID = LM.LTM_ID
	--LEFT JOIN Warehouse WHM ON IDC_WarehouseCode = WHM.WHM_Code
	INNER JOIN CFN c(nolock) on IDC_UPN = c.CFN_CustomerFaceNbr
	INNER JOIN Product pma(nolock) on c.CFN_ID = pma.PMA_CFN_ID
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IDC_ReturnNo = IAH.IAH_Inv_Adj_Nbr
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAD.IAD_IAH_ID = IAH.IAH_ID AND pma.PMA_ID = IAD.IAD_PMA_ID
	INNER JOIN InventoryAdjustLot IAL(nolock) ON IAD.IAD_ID = IAL.IAL_IAD_ID and ISNULL(ial_qrlotnumber,ial_lotnumber) = IDC_Lot
	INNER JOIN DealerMaster DMA(nolock) ON IAH.IAH_DMA_ID = DMA.DMA_ID
	INNER JOIN Warehouse WHM2(nolock) ON WHM2.WHM_DMA_ID = DMA.DMA_ID AND WHM2.WHM_Type ='SystemHold'
	INNER JOIN Inventory INV(nolock) ON INV.INV_ID = Lot.LOT_INV_ID AND INV.INV_WHM_ID = WHM2.WHM_ID 
	AND INV.INV_PMA_ID = pma.PMA_ID
	WHERE IDC_ErrorMsg  = '' AND IDC_BatchNbr = @BatchNbr	
	and IDC_Qty = 1
	group by PMA_ID,IAL.IAL_WHM_ID,WHM2.WHM_ID, Lot.LOT_LTM_ID, lm.LTM_LotNumber,IAH_WarehouseType
	) AS A
	
	--更新关联库存主键-二级经销商
	UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
	FROM Inventory INV 
	WHERE INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
	AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID
	
	--更新批次表,减少二级经销商
	UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,2),Lot.LOT_OnHandQty)-Convert(decimal(18,2),TMP.LOT_OnHandQty)
	FROM #tmp_lot AS TMP
	WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID
	
	--更新关联库存主键-平台
	UPDATE tmp SET LOT_INV_ID = INV.INV_ID
	FROM Inventory INV ,#tmp_lot tmp,Warehouse wh
	WHERE INV.INV_PMA_ID = tmp.LOT_PMA_ID
	and tmp.LOT_WHM_IN_ID = wh.WHM_ID
	AND INV.INV_WHM_ID = (case when  WHM_Type = 'Consignment' then @ConsignmengWarehouse else @NormalWarehouse end)

	--更新LP批次表，存在的更新，不存在的新增
	UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,2),Lot.LOT_OnHandQty)+Convert(decimal(18,2),TMP.LOT_OnHandQty)
	FROM #tmp_lot AS TMP
	WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

	INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
	SELECT LOT_ID, LOT_LTM_ID, convert(decimal(18,2),LOT_OnHandQty), LOT_INV_ID 
	FROM #tmp_lot AS TMP,Warehouse wh(nolock)
	WHERE TMP.LOT_WHM_ID = wh.WHM_ID
	AND NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)
	
	--Inventory操作日志，二级经销商出库
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT -IAL.IAL_LotQty,NEWID(),IAL.IAL_ID,'库存调整：退货',WHM_ID,IAD.IAD_PMA_ID,0,'库存调整类型：Return。从二级经销商在途仓库移出。'
	FROM InventoryAdjustLot IAL(nolock)
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 1
  inner join Warehouse whm(nolock) on whm.WHM_DMA_ID = iah.IAH_DMA_ID and WHM_Type='SystemHold'
	WHERE IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志，移出二级经销商仓库
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ReferenceID)
	SELECT -IAL.IAL_LotQty,NEWID(),Lot.LOT_LTM_ID,IAL.IAL_LotNumber,IAL.IAL_ID
	FROM InventoryAdjustLot IAL(nolock)
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Lot(nolock) ON Lot.LOT_ID = IAL.IAL_LOT_ID
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 1
	WHERE IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr

	UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
	FROM #tmp_invtrans a 
	WHERE a.ITR_ReferenceID = #tmp_invtranslot.ITL_ReferenceID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot

	--清空日志数据
	DELETE FROM #tmp_invtrans
	DELETE FROM #tmp_invtranslot

	--Inventory操作日志，增加平台
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT IAL.IAL_LotQty,NEWID(),IAL.IAL_ID,'库存调整：退货',(CASE WHEN WHM.WHM_Type = 'Consignment' then @ConsignmengWarehouse else @NormalWarehouse end),IAD.IAD_PMA_ID,0,'库存调整类型：Return。移回平台仓库。'
	FROM InventoryAdjustLot IAL(nolock)
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Warehouse WHM(nolock) ON IAL_WHM_ID = WHM.WHM_ID
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 1
	WHERE IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志，移入平台仓库
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ReferenceID)
	SELECT IAL.IAL_LotQty,NEWID(),Lot.LOT_LTM_ID,IAL.IAL_LotNumber,IAL.IAL_ID
	FROM InventoryAdjustLot IAL(nolock)
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Lot(nolock) ON Lot.LOT_ID = IAL.IAL_LOT_ID
	inner join InterfaceDealerReturnConfirm idc(nolock) on IAH_Inv_Adj_Nbr = IDC_ReturnNo AND isnull(IAL_QRLotNumber,IAL_LotNumber) = IDC_Lot and IDC_Qty = 1
	WHERE IDC_ErrorMsg  = '' AND IDC_BatchNbr=@BatchNbr

	UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
	FROM #tmp_invtrans a 
	WHERE a.ITR_ReferenceID = #tmp_invtranslot.ITL_ReferenceID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
	
	--更新InventoryAdjustHeader表的ApprovalDate字段
	Update IAH
	set IAH_ApprovalDate = GETDATE()
	from InventoryAdjustHeader IAH,AdjustConfirmation AC(nolock)
	where IAH.IAH_ID = AC.AC_IAH_ID
	AND AC.AC_BatchNbr = @BatchNbr 
	
	--将本次确认的退货数量写入临时表中
	insert into Tmp_DealerReturnConfirm(TDC_ID,TDC_IAH_ID,TDC_ReturnNo,TDC_UPN,TDC_Lot,TDC_Qty)
	select newid(),IAH_ID,IDC_ReturnNo,IDC_UPN,IDC_Lot,IDC_Qty
	from InterfaceDealerReturnConfirm(nolock) 
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IDC_ReturnNo = IAH.IAH_Inv_Adj_Nbr
	where IDC_BatchNbr = @BatchNbr
	--group by IAH_ID,IDC_ReturnNo,IDC_UPN,IDC_Lot
  
  
	--判断判断退货单中的明细是否和临时表一致，并且数量全部是0，如果是，则更新退货单状态为拒绝 否则更新退货单状态为完成
	UPDATE InventoryAdjustHeader SET IAH_Status = 'Reject' 
	--select *
	FROM InventoryAdjustHeader t1
	where IAH_Inv_Adj_Nbr in (select distinct IDC_ReturnNo from InterfaceDealerReturnConfirm(nolock) where IDC_BatchNbr = @BatchNbr)
	and IAH_Inv_Adj_Nbr not in (
	select IAH_Inv_Adj_Nbr
	FROM InventoryAdjustHeader iah(nolock)
	inner join InventoryAdjustDetail iad(nolock) on iah.IAH_ID = iad.IAD_IAH_ID
	inner join InventoryAdjustLot ial(nolock) on iad.IAD_ID = ial.IAL_IAD_ID
	inner join Product(nolock) on IAD_PMA_ID = PMA_ID
	left join Tmp_DealerReturnConfirm td(nolock) on PMA_UPN = TDC_UPN and ISNULL(IAL_QRLotNumber, IAL_LotNumber) = TDC_Lot and TDC_Qty = 0 and IAH_Inv_Adj_Nbr = TDC_ReturnNo
	WHERE IAH_Inv_Adj_Nbr  = t1.IAH_Inv_Adj_Nbr
	and TDC_ID is null
	)
	 
	UPDATE t1 SET IAH_Status = 'Accept' 
	--select *
	FROM InventoryAdjustHeader t1
	where IAH_Inv_Adj_Nbr in (select distinct IDC_ReturnNo from InterfaceDealerReturnConfirm(nolock) where IDC_BatchNbr = @BatchNbr)
	and IAH_Inv_Adj_Nbr not in (
	select IAH_Inv_Adj_Nbr
	FROM InventoryAdjustHeader iah(nolock)
	inner join InventoryAdjustDetail iad(nolock) on iah.IAH_ID = iad.IAD_IAH_ID
	inner join InventoryAdjustLot ial(nolock) on iad.IAD_ID = ial.IAL_IAD_ID
	inner join Product(nolock) on IAD_PMA_ID = PMA_ID
	left join Tmp_DealerReturnConfirm td(nolock) on PMA_UPN = TDC_UPN and ISNULL(IAL_QRLotNumber, IAL_LotNumber) = TDC_Lot and IAH_Inv_Adj_Nbr = TDC_ReturnNo --and TDC_Qty = 0
	WHERE IAH_Inv_Adj_Nbr  = t1.IAH_Inv_Adj_Nbr
	and TDC_ID is null
	)
	and IAH_Status <> 'Reject'

	
	--更新退货确认的价格
	update IAL
	set IAL_UnitPrice = IDC_UnitPrice
	FROM InterfaceDealerReturnConfirm(nolock)
	INNER JOIN InventoryAdjustHeader IAH(nolock) ON IDC_ReturnNo = IAH.IAH_Inv_Adj_Nbr
	INNER JOIN InventoryAdjustDetail IAD(nolock) ON IAH_ID = IAD_IAH_ID
	INNER JOIN InventoryAdjustLot IAL ON IAD_ID = IAL_IAD_ID
	INNER JOIN LotMaster LM(nolock) ON IDC_Lot = LM.LTM_LotNumber
	INNER JOIN Lot(nolock) ON Lot.LOT_LTM_ID = LM.LTM_ID AND LOT_ID = ISNULL(IAL_QRLOT_ID,IAL_LOT_ID)
	WHERE  IDC_BatchNbr =  @BatchNbr
	AND IDC_Qty = 1
	and IDC_ErrorMsg = ''	
	
	
	insert into ShipmentLPConfirmHeader 
	select NEWID(),IDC_ReturnNo,'',IDC_ConfirmDate,IDC_Remark,'00000000-0000-0000-0000-000000000000',GETDATE()
	from 
	(select distinct IDC_ReturnNo,max(IDC_ConfirmDate) as IDC_ConfirmDate,
		IDC_Remark=Replace(STUFF((SELECT distinct ';' +  Convert(nvarchar(20),IDC_Remark, 20)
                                                                   FROM InterfaceDealerReturnConfirm AS i2(nolock)
                                                                  WHERE i2.IDC_BatchNbr=  i1.IDC_BatchNbr
                                                                  and i2.IDC_ReturnNo = i1.IDC_ReturnNo
                                                                    FOR XML PATH('')), 1, 1, ''),';','<br/>')  
		from InterfaceDealerReturnConfirm i1(nolock)
		where isnull(IDC_ErrorMsg,'') = ''
		and IDC_Qty = 1
		and IDC_BatchNbr=@BatchNbr
		and Not exists (select 1 from 	ShipmentLPConfirmHeader where 	SCH_SalesNo = IDC_ReturnNo)
		group by IDC_ReturnNo,IDC_BatchNbr
	) tab
	
	--存在同产品和批号的，修改数量和价格
	update t1
	set t1.SCD_Qty = t1.SCD_Qty + t3.IDC_Qty,t1.SCD_UnitPrice = t3.IDC_UnitPrice,t1.SCD_TaxRate = t3.IDC_TaxRate
	from ShipmentLPConfirmDetail t1(nolock),ShipmentLPConfirmHeader t2(nolock),InterfaceDealerReturnConfirm t3(nolock)
	where t1.SCD_SCH_ID = t2.SCH_ID
	and t2.SCH_SalesNo = t3.IDC_ReturnNo
	and IDC_ErrorMsg = ''
	and IDC_Qty = 1
	and IDC_BatchNbr=@BatchNbr	
	and t1.SCD_UPN = t3.IDC_UPN
	and t1.SCD_Lot = t3.IDC_Lot
	--没有的则新增
	insert into ShipmentLPConfirmDetail(SCD_ID,SCD_SCH_ID,SCD_UPN,SCD_Lot,SCD_Qty,SCD_UnitPrice,SCD_TaxRate)	
	select NEWID(),SCH_ID,IDC_UPN,IDC_Lot,IDC_Qty,IDC_UnitPrice,IDC_TaxRate
	from 	ShipmentLPConfirmHeader(nolock),InterfaceDealerReturnConfirm(nolock)
	where SCH_SalesNo = IDC_ReturnNo
	and IDC_ErrorMsg = ''
	and IDC_Qty = 1
	and IDC_BatchNbr=@BatchNbr	
	and not exists (select 1 from ShipmentLPConfirmDetail where SCD_SCH_ID = SCH_ID and SCD_UPN = IDC_UPN and SCD_Lot = IDC_Lot)
	

									
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


