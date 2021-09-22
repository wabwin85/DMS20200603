DROP PROCEDURE [dbo].[GC_Interface_DeliveryConfirmation]
GO

/*
平台收货确认数据处理
*/
CREATE PROCEDURE [dbo].[GC_Interface_DeliveryConfirmation]
@BatchNbr nvarchar(30), @ClientID nvarchar(50), @RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(2000) OUTPUT
WITH EXEC AS CALLER
AS
DECLARE @SysUserId uniqueidentifier
	DECLARE @DealerId uniqueidentifier
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
  
  CREATE TABLE #DeliveryConfirm(
                [DC_ID] uniqueidentifier NOT NULL,
                [DC_SapDeliveryNo] nvarchar(50) NULL,
                [DC_ConfirmDate] datetime NULL,
                [DC_IsConfirm] bit NULL,
                [DC_Remark] nvarchar(200) NULL,
                [DC_LineNbr] int NOT NULL,
                [DC_FileName] nvarchar(200) NULL,
                [DC_PRH_ID] uniqueidentifier NULL,
                [DC_ProblemDescription] nvarchar(200) NULL,
                [DC_HandleDate] datetime NULL,
                [DC_ImportDate] datetime NOT NULL,
                [DC_ClientID] nvarchar(50) NOT NULL,
                [DC_BatchNbr] nvarchar(30) NULL,
                [DC_UPN] nvarchar(50) NULL,
                [DC_Lot] nvarchar(50) NULL,
                [DC_Qty] decimal(18, 2) NULL)
  
  
	--经销商主键
	SELECT @DealerId = CLT_Corp_Id FROM Client WHERE CLT_ID = @ClientID
	

	--从接口表中插入数据（根据发货单号查询LP自己的收货单据）
	INSERT INTO #DeliveryConfirm (DC_ID,DC_SapDeliveryNo,DC_ConfirmDate,DC_IsConfirm,DC_Remark,
		DC_UPN,DC_Lot,DC_Qty,DC_LineNbr,DC_FileName,
		DC_PRH_ID,DC_ProblemDescription,DC_HandleDate,DC_ImportDate,DC_ClientID,DC_BatchNbr)
	SELECT max(convert(nvarchar(50),IDC_ID)),IDC_SapDeliveryNo,IDC_ConfirmDate,1,IDC_Remark,IDC_UPN,IDC_Lot + '@@' + IDC_QRCode,sum(IDC_Qty),max(IDC_LineNbr),IDC_FileName,PRH_ID,
		   CASE WHEN PRH_ID IS NULL THEN Convert(nvarchar(100),isnull(IDC_sapDeliveryNo,'')) + '-发货单未关联'
			      WHEN PRH_ID IS NOT NULL AND PRH_STATUS <> 'Waiting' THEN Convert(nvarchar(100),isnull(IDC_sapDeliveryNo,'')) + '-发货单状态无效(不为待收货状态)'
			      ELSE NULL END,GETDATE(),GETDATE(),IDC_ClientID,IDC_BatchNbr
	FROM InterfaceDeliveryConfirmation I (nolock)
    LEFT OUTER JOIN POReceiptHeader PH (nolock) ON PH.PRH_SAPShipmentID = IDC_SapDeliveryNo AND PH.PRH_Dealer_DMA_ID = @DealerId
    AND PH.PRH_Type = 'PurchaseOrder' --and PRH_Status in ('Waiting','Complete')
	WHERE IDC_BatchNbr = @BatchNbr
	group by IDC_SapDeliveryNo,IDC_ConfirmDate,IDC_Remark,IDC_UPN,IDC_Lot,IDC_QRCode,IDC_FileName,PRH_ID,IDC_ClientID,IDC_BatchNbr,PRH_STATUS
	
	
  --对于发货日期在2月1日以前的发货单，先判断一下上传的二维码在SAP发货单明细中是否存在，如果不存在，则更新为“NoQR”
  UPDATE DC
     SET DC.DC_Lot = CASE WHEN charindex('@@',DC.DC_Lot) > 0 
                          THEN substring(DC.DC_Lot,1,charindex('@@',DC.DC_Lot)-1) +'@@NoQR'
                          ELSE DC.DC_Lot
                          END    
    FROM #DeliveryConfirm AS DC
    LEFT JOIN 
  	(select PRH_ID,PRL_LotNumber,PMA_UPN from POReceiptHeader(nolock) 
  	inner join POReceipt(nolock) on PRH_ID = POR_PRH_ID
  	inner join POReceiptLot(nolock) on POR_ID = PRL_POR_ID 
  	inner join Product(nolock) on POR_SAP_PMA_ID = PMA_ID
  	) prh on (prh.PRH_ID = DC_PRH_ID	AND prh.PMA_UPN= DC_UPN	AND PRL_LotNumber = DC_Lot)
  	where DC_ProblemDescription is null and DC_IsConfirm = 1
      AND prh.PRL_LotNumber IS NULL
      AND DC.DC_Lot IS NOT NULL
      AND exists (select 1 from POReceiptHeader PRH(nolock) where PRH.PRH_SAPShipmentDate < '2016-02-01 0:00:00' and PRH.PRH_ID = DC.DC_PRH_ID)
       
   
  INSERT INTO DeliveryConfirmation(DC_ID,DC_SapDeliveryNo,DC_ConfirmDate,DC_IsConfirm,DC_Remark,DC_UPN,DC_Lot,DC_Qty,DC_LineNbr,DC_FileName,DC_PRH_ID,DC_ProblemDescription,DC_HandleDate,DC_ImportDate,DC_ClientID,DC_BatchNbr)
  SELECT newid(),DC_SapDeliveryNo,DC_ConfirmDate,DC_IsConfirm,DC_Remark,DC_UPN,DC_Lot,sum(DC_QTY) AS QTY,ROW_NUMBER() OVER(ORDER BY DC_UPN,DC_LOT DESC),DC_FileName,DC_PRH_ID,DC_ProblemDescription,DC_HandleDate,DC_ImportDate,DC_ClientID,DC_BatchNbr
    FROM #DeliveryConfirm
   GROUP BY DC_SapDeliveryNo,DC_ConfirmDate,DC_IsConfirm,DC_Remark,DC_FileName,DC_PRH_ID,DC_ProblemDescription,DC_HandleDate,DC_ImportDate,DC_ClientID,DC_BatchNbr,DC_UPN,DC_Lot
    
  
  
  --校验上传的产品和批次(包括二维码)是否和收货单的一致
	update DC
	set DC_ProblemDescription = '发货单'+ Convert(nvarchar(100),isnull(DC_sapDeliveryNo,''))+ '，产品型号:' + isnull(DC_UPN,'') + '和批次:' + isnull(DC_Lot,'') +  '与收货单中的不一致'
	--set DC_ProblemDescription = '发货单'+ Convert(nvarchar(100),isnull(DC_sapDeliveryNo,''))+ '，产品型号和批次与收货单中的不一致'
	--select *
	from DeliveryConfirmation DC(nolock)
	left join 
	(select PRH_ID,PRL_LotNumber,PMA_UPN 
	from POReceiptHeader(nolock)
	inner join POReceipt(nolock) on PRH_ID = POR_PRH_ID
	inner join POReceiptLot(nolock) on POR_ID = PRL_POR_ID 
	inner join Product(nolock) on POR_SAP_PMA_ID = PMA_ID
	) prh on prh.PRH_ID = DC_PRH_ID
	and prh.PMA_UPN= DC_UPN 
	AND PRL_LotNumber = DC_Lot
	where DC_ProblemDescription is null and DC_IsConfirm = 1
	AND DC_BatchNbr = @BatchNbr
	AND (PRL_LotNumber IS NULL OR PMA_UPN IS NULL)
	
	--校验上传数量是否大于收货单据的数量
	update dc
	set dc.DC_ProblemDescription = '产品' + dc_upn +'的上传数量大于收货数量'
	from DeliveryConfirmation dc(nolock)
	left join 
	(
	select dcm_upn,dcm_lot,dcm_qty from DeliveryConfirmationMid(nolock)
	where DCM_PRH_ID in (select distinct DC_PRH_ID from DeliveryConfirmation(nolock)
	where DC_BatchNbr= @BatchNbr)
	) t1 on dc_upn = dcm_upn
	and dc_lot = dcm_lot
	left join
	(select PRH_ID,PMA_UPN,PRL_LotNumber,PRL_ReceiptQty from POReceiptHeader(nolock) 
	inner join POReceipt(nolock) on PRH_ID = POR_PRH_ID
	inner join POReceiptLot(nolock) on POR_ID = PRL_POR_ID 
	inner join Product(nolock) on POR_SAP_PMA_ID = PMA_ID
	where PRH_ID in (select distinct DC_PRH_ID from DeliveryConfirmation(nolock)
	where DC_BatchNbr= @BatchNbr)
	) t2
	on dc_upn = t2.PMA_UPN
	and dc_lot = t2.PRL_LotNumber
	AND DC_PRH_ID = t2.PRH_ID
	where DC_BatchNbr= @BatchNbr
	and DC_IsConfirm = 1
	and dc_qty + isnull(dcm_qty,0) > PRL_ReceiptQty
	and DC_ProblemDescription is null
  
  
	declare @cnt int;
	select @cnt = COUNT(*) from DeliveryConfirmation(nolock) where DC_ProblemDescription is not null
	and DC_BatchNbr = @BatchNbr
	
	IF (@cnt = 0)
	BEGIN

	--TODO: 判断单据批次行中，同一产品型号，同一批次号，有效期是否一致？！（这里应该在生成收货单据的时候判断）

	--DC_ProblemDescription为空的数据，即需要完成收货的单据
	--更新收货单的状态Cancelled和Complete（若是Cancelled状态则没有后续的处理，业务上应该不允许存在不确认收货的情况）
	UPDATE POReceiptHeader SET PRH_Status =  'Cancelled'
	FROM DeliveryConfirmation DC(nolock) WHERE DC_IsConfirm = 0 
	AND POReceiptHeader.PRH_ID = DC.DC_PRH_ID
	AND DC_BatchNbr = @BatchNbr

	--记录单据操作日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),TAB.DC_PRH_ID,@SysUserId,GETDATE(),(CASE WHEN TAB.DC_IsConfirm = 1 THEN 'Confirm' ELSE 'Cancel' END),'物流平台通过系统接口进行收货确认'
	  FROM (SELECT DC_PRH_ID,DC_IsConfirm
            FROM DeliveryConfirmation(nolock) 
           WHERE DC_ProblemDescription IS NULL 
             AND DC_BatchNbr = @BatchNbr
           GROUP BY DC_PRH_ID,DC_IsConfirm
          ) TAB

	--DC_IsConfirm=1完成收货操作，库存增加
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
	ITL_LotNumber        nvarchar(50)         collate Chinese_PRC_CI_AS
	primary key (ITL_ID)
	)	

	--如果以后速度慢，可以将收货单表头、行和批次信息都先存入临时表
	--LotMaster表，新增批次信息
	INSERT INTO LotMaster (LTM_ID, LTM_LotNumber, LTM_ExpiredDate, LTM_Product_PMA_ID, LTM_CreatedDate)
	SELECT NEWID(), T.LOTNUMBER, T.EXPIREDDATE, T.PMAID, GETDATE() FROM (
	SELECT DISTINCT PD.PRL_LotNumber AS LOTNUMBER,PD.PRL_ExpiredDate AS EXPIREDDATE,PL.POR_SAP_PMA_ID PMAID
	FROM POReceiptLot PD(nolock)
	INNER JOIN POReceipt PL(nolock) ON PL.POR_ID = PD.PRL_POR_ID
	INNER JOIN Product PMA(nolock) ON PL.POR_SAP_PMA_ID = PMA.PMA_ID
	WHERE exists (select 1 from DeliveryConfirmation DC(nolock)
	where DC_UPN = PMA.PMA_UPN AND DC_Lot = PD.PRL_LotNumber and PL.POR_PRH_ID = DC.DC_PRH_ID
	AND DC_ProblemDescription IS NULL AND DC_IsConfirm = 1 AND DC_BatchNbr = @BatchNbr)
	--PL.POR_PRH_ID IN (SELECT DC_PRH_ID FROM DeliveryConfirmation DC
	--WHERE DC_ProblemDescription IS NULL AND DC_IsConfirm = 1 AND DC_BatchNbr = @BatchNbr)	
	AND NOT EXISTS (SELECT 1 FROM LotMaster(nolock)
	WHERE LotMaster.LTM_LotNumber = PD.PRL_LotNumber
	AND LotMaster.LTM_Product_PMA_ID = PL.POR_SAP_PMA_ID)) AS T

	--Inventory表，新增仓库中没有的物料，更新仓库中存在的物料数量
	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
	SELECT T.QTY,NEWID(),T.WHMID,T.PMAID FROM
	(SELECT SUM(DC_Qty) AS QTY,PH.PRH_WHM_ID AS WHMID,PL.POR_SAP_PMA_ID AS PMAID
	FROM POReceipt PL(nolock)
	INNER JOIN POReceiptHeader PH(nolock) ON PH.PRH_ID = PL.POR_PRH_ID
	INNER JOIN Product PMA(nolock) ON PL.POR_SAP_PMA_ID = PMA.PMA_ID
	INNER JOIN DeliveryConfirmation(nolock) ON PH.PRH_ID = DC_PRH_ID AND DC_UPN = PMA.PMA_UPN
	WHERE DC_ProblemDescription IS NULL AND DC_IsConfirm = 1 AND DC_BatchNbr = @BatchNbr
	GROUP BY PH.PRH_WHM_ID,PL.POR_SAP_PMA_ID) as T
	
	UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)+Convert(decimal(18,6),TMP.INV_OnHandQuantity)
	FROM #tmp_inventory AS TMP
	WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
	AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

	INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
	SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID
	FROM #tmp_inventory AS TMP	
	WHERE NOT EXISTS (SELECT 1 FROM Inventory INV(nolock) WHERE INV.INV_WHM_ID = TMP.INV_WHM_ID
	AND INV.INV_PMA_ID = TMP.INV_PMA_ID)	

	--Lot表，新增批次库存
	INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
	SELECT NEWID(),LTMID,WHMID,PMAID,LOTNUMBER,QTY FROM (
	SELECT LM.LTM_ID AS LTMID,PH.PRH_WHM_ID AS WHMID,PL.POR_SAP_PMA_ID AS PMAID,PD.PRL_LotNumber AS LOTNUMBER,SUM(DC.DC_Qty) AS QTY
	FROM POReceiptLot PD(nolock)
	INNER JOIN POReceipt PL(nolock) ON PL.POR_ID = PD.PRL_POR_ID
	INNER JOIN POReceiptHeader PH(nolock) ON PH.PRH_ID = PL.POR_PRH_ID
	INNER JOIN LotMaster LM(nolock) ON LM.LTM_LotNumber = PD.PRL_LotNumber AND LM.LTM_Product_PMA_ID = PL.POR_SAP_PMA_ID
	inner join Product PMA(nolock) ON PL.POR_SAP_PMA_ID = PMA.PMA_ID
	INNER JOIN DeliveryConfirmation DC(nolock) ON DC.DC_PRH_ID =  PH.PRH_ID AND DC.DC_UPN = PMA.PMA_UPN AND DC.DC_Lot = PD.PRL_LotNumber
	WHERE DC_ProblemDescription IS NULL AND DC_IsConfirm = 1 AND DC_BatchNbr = @BatchNbr
	GROUP BY LM.LTM_ID,PH.PRH_WHM_ID,PL.POR_SAP_PMA_ID,PD.PRL_LotNumber) AS T

	--更新关联库存主键
	UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
	FROM Inventory INV(nolock)
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
	WHERE NOT EXISTS (SELECT 1 FROM Lot(nolock) WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
	AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)
	
	--Inventory操作日志
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT Qty,NEWID(),POR_ID,ITR_Type,PRH_WHM_ID,POR_SAP_PMA_ID,ITR_UnitPrice,ITR_TransDescription FROM (
	SELECT SUM(DC_Qty) AS Qty,PL.POR_ID,'采购入库' AS ITR_Type,PH.PRH_WHM_ID,PL.POR_SAP_PMA_ID,ISNULL(PL.POR_LineNbr,0) AS ITR_UnitPrice,
	'接收'+PH.PRH_PONumber + '-' + PH.PRH_SAPShipmentID +'的第'+CONVERT(NVARCHAR(50),PL.POR_LineNbr)+'行' AS ITR_TransDescription
  	FROM POReceipt PL(nolock)
	INNER JOIN POReceiptHeader PH(nolock) ON PH.PRH_ID = PL.POR_PRH_ID
	INNER JOIN Product PMA(nolock) ON PL.POR_SAP_PMA_ID = PMA.PMA_ID
	INNER JOIN DeliveryConfirmation(nolock) ON PH.PRH_ID = DC_PRH_ID AND DC_UPN = PMA.PMA_UPN
	WHERE DC_ProblemDescription IS NULL AND DC_IsConfirm = 1 AND DC_BatchNbr = @BatchNbr
	GROUP BY PL.POR_ID,PH.PRH_WHM_ID,PL.POR_SAP_PMA_ID,PH.PRH_PONumber,PRH_SAPShipmentID,PL.POR_LineNbr
	) TAB

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
	SELECT DC_Qty, NEWID(), LM.LTM_ID, LM.LTM_LotNumber, itr.ITR_ID
	FROM POReceiptLot PD(nolock)
	INNER JOIN POReceipt PL(nolock) ON PL.POR_ID = PD.PRL_POR_ID
	INNER JOIN LotMaster LM(nolock) ON LM.LTM_LotNumber = PD.PRL_LotNumber AND LM.LTM_Product_PMA_ID = PL.POR_SAP_PMA_ID
	inner join #tmp_invtrans itr on itr.ITR_ReferenceID = PL.POR_ID
	INNER JOIN Product PMA(nolock) ON PL.POR_SAP_PMA_ID = PMA.PMA_ID
	INNER JOIN DeliveryConfirmation(nolock) ON PD.PRL_LotNumber = DC_Lot AND PL.POR_PRH_ID = DC_PRH_ID AND DC_UPN = PMA.PMA_UPN
	WHERE DC_ProblemDescription IS NULL AND DC_IsConfirm = 1 AND DC_BatchNbr = @BatchNbr
	
	
	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot


	--写入部分收货表,存在的更新，不存在的新增
	update t1
	set t1.DCM_Qty = t1.DCM_Qty + t2.DC_Qty
	--select * 
	from DeliveryConfirmationMid t1(nolock),DeliveryConfirmation t2(nolock)
	where t1.DCM_PRH_ID = t2.DC_PRH_ID
	and t1.dcm_upn = t2.dc_upn
	and t1.dcm_lot = t2.dc_lot
	AND DC_ProblemDescription IS NULL AND DC_IsConfirm = 1 AND DC_BatchNbr = @BatchNbr
	
	insert into DeliveryConfirmationMid
	select NEWID(),DC_UPN,DC_Lot,DC_Qty,DC_PRH_ID,DC_ImportDate,DC_ClientID
	FROM DeliveryConfirmation dc(nolock)
	WHERE DC_IsConfirm = 1 AND DC_BatchNbr = @BatchNbr
	and not exists (select 1 from DeliveryConfirmationMid dcm(nolock) 
		where dc.DC_PRH_ID = dcm.DCM_PRH_ID and dc.DC_UPN = dcm.DCM_UPN and dc.DC_Lot = dcm.DCM_Lot)
	
	
	--校验部分收货表中的数量与收货单的数量是否相等，相等则修改收货单状态为Complete
	declare @cntQty int;
	declare @prhid uniqueidentifier;
	declare curCogs CURSOR
	for select distinct DC_PRH_ID from DeliveryConfirmation(nolock) where DC_BatchNbr = @BatchNbr
	OPEN curCogs
		FETCH NEXT FROM curCogs INTO @prhid

		WHILE @@FETCH_STATUS = 0
		BEGIN
			select @cntQty = SUM(dcm_qty)-ReceiptQty
			from DeliveryConfirmationMid dcm(nolock)
			inner join (select sum(PRL_ReceiptQty) as ReceiptQty ,PRH_ID
			from POReceiptHeader prh(nolock) 
			inner join POReceipt por(nolock) on por.POR_PRH_ID = prh.PRH_ID
			inner join POReceiptLot pol(nolock) on por.POR_ID = pol.PRL_POR_ID
			inner join Product(nolock) on POR_SAP_PMA_ID = PMA_ID
			where PRH_ID = @prhid
			group by PRH_ID
			) PO on dcm_prh_id = po.PRH_ID
			group by ReceiptQty
			
			if(@cntQty = 0)
			begin
				UPDATE POReceiptHeader SET PRH_Status =  'Complete'
				FROM DeliveryConfirmation DC(nolock) WHERE DC_IsConfirm = 1 
				AND POReceiptHeader.PRH_ID = DC.DC_PRH_ID
				AND DC_BatchNbr = @BatchNbr
				and DC_PRH_ID= @prhid
			end
		FETCH NEXT FROM curCogs INTO @prhid
		END

		CLOSE curCogs
		DEALLOCATE curCogs
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


