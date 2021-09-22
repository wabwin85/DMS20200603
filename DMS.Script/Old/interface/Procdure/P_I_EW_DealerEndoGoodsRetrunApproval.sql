DROP PROCEDURE [interface].[P_I_EW_DealerEndoGoodsRetrunApproval]
GO

CREATE PROCEDURE [interface].[P_I_EW_DealerEndoGoodsRetrunApproval]
@OrderNo nvarchar(50),
@Status nvarchar(50),
@DealerType nvarchar(20),
@ResultValue int = 0 OUTPUT
AS
SET NOCOUNT ON


BEGIN TRY
BEGIN TRAN

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
	
DECLARE @CentID nvarchar(50)

	   SELECT TOP 1 @CentID=client.CLT_ID FROM DealerMaster INNER JOIN client ON DealerMaster.DMA_Parent_DMA_ID=client.CLT_Corp_Id
	   INNER JOIN InventoryAdjustHeader ON InventoryAdjustHeader.IAH_DMA_ID=DealerMaster.DMA_ID
	   WHERE InventoryAdjustHeader.IAH_Inv_Adj_Nbr = @OrderNo and InventoryAdjustHeader.IAH_Reason in ('Return','Exchange')

SELECT top 1 @DealerType = t2.DMA_DealerType FROM InventoryAdjustHeader t1, DealerMaster t2
 where t1.IAH_Inv_Adj_Nbr = @OrderNo and IAH_Reason in ('Return','Exchange')
 and t1.IAH_DMA_ID = t2.DMA_ID

if(@DealerType='T2' or @DealerType='T1')
	BEGIN
	IF(@Status = 'Reject')
	begin

	/*--------------------------普通退货单拒绝处理逻辑-------------------------------*/
	--将确认退货的记录写入临时表  普通退货才扣减库存
	INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID,INV_WHM_IN_ID)
	SELECT A.QTY,NEWID(),A.WHM_ID,A.IAD_PMA_ID,IAL_WHM_ID
	FROM 
	(SELECT  WHM.WHM_ID,IAD_PMA_ID,sum(IAL_LotQty) AS QTY ,IAL.IAL_WHM_ID
	FROM InventoryAdjustHeader IAH 
	INNER JOIN InventoryAdjustDetail IAD ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN InventoryAdjustLot IAL ON IAL.IAL_IAD_ID = IAD.IAD_ID --and ISNULL(ial_qrlotnumber,ial_lotnumber) = IDC_Lot
	INNER JOIN DealerMaster DMA ON IAH.IAH_DMA_ID = DMA.DMA_ID
	INNER JOIN Warehouse WHM ON WHM.WHM_DMA_ID = DMA.DMA_ID AND WHM.WHM_Type ='SystemHold'
	INNER JOIN Product P ON IAD_PMA_ID = PMA_ID
	----INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND INV.INV_WHM_ID = WHM.WHM_ID
	----AND INV.INV_PMA_ID = IAD.IAD_PMA_ID
	where IAH.IAH_Inv_Adj_Nbr=@OrderNo
	
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
	FROM InventoryAdjustHeader IAH 
	INNER JOIN InventoryAdjustDetail IAD ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN InventoryAdjustLot IAL ON IAL.IAL_IAD_ID = IAD.IAD_ID 
	INNER JOIN DealerMaster DMA ON IAH.IAH_DMA_ID = DMA.DMA_ID
	INNER JOIN Warehouse WHM2 ON WHM2.WHM_DMA_ID = DMA.DMA_ID AND WHM2.WHM_Type ='SystemHold'
	INNER JOIN Lot ON  ISNULL(IAL_QRLOT_ID,IAL_LOT_ID) = LOT_ID
	INNER JOIN LotMaster LM ON Lot.LOT_LTM_ID = LM.LTM_ID 
	INNER JOIN Product pma on IAD_PMA_ID = pma.PMA_ID 
	--INNER JOIN Inventory INV ON INV.INV_ID = Lot.LOT_INV_ID AND INV.INV_WHM_ID = WHM_ID
	--AND INV.INV_PMA_ID = pma.PMA_ID
	--INNER JOIN Warehouse WHM on WHM.WHM_DMA_ID = DMA.DMA_ID and whm.WHM_Type in ('Normal','DefaultWH') and IAH_DMA_ID = WHM.WHM_DMA_ID
	
	WHERE  IAH_Inv_Adj_Nbr=@OrderNo
	--and IAH_WarehouseType = 'Normal'
	group by IAD_PMA_ID,WHM2.WHM_ID, Lot.LOT_LTM_ID, lm.LTM_LotNumber,IAH_WarehouseType,IAL_WHM_ID
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

	--更新dbo.InventoryAdjustLot表，如果是拒绝，则将数量修改为0
	update IAL
	set IAL_LotQty = 0
	FROM InventoryAdjustHeader IAH 
	INNER JOIN InventoryAdjustDetail IAD ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN InventoryAdjustLot IAL ON IAL.IAL_IAD_ID = IAD.IAD_ID 
	INNER JOIN DealerMaster DMA ON IAH.IAH_DMA_ID = DMA.DMA_ID
	INNER JOIN Warehouse WHM2 ON WHM2.WHM_DMA_ID = DMA.DMA_ID AND WHM2.WHM_Type ='SystemHold'
	INNER JOIN Lot ON  ISNULL(IAL_QRLOT_ID,IAL_LOT_ID) = LOT_ID
	INNER JOIN LotMaster LM ON Lot.LOT_LTM_ID = LM.LTM_ID 
	INNER JOIN Product pma on IAD_PMA_ID = pma.PMA_ID 
	
	WHERE  IAH_Inv_Adj_Nbr=@OrderNo


	--Inventory操作日志，二级经销商出库
	INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
	SELECT -IAL.IAL_LotQty,NEWID(),IAL.IAL_ID,'库存调整：退货',IAL_WHM_ID,IAD.IAD_PMA_ID,0,'库存调整类型：Return。从二级经销商在途仓库移出。'
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Warehouse WHM ON IAH_DMA_ID = WHM.WHM_DMA_ID AND WHM.WHM_Type ='SystemHold'
	
    
	WHERE IAH_Inv_Adj_Nbr=@OrderNo
	--AND IAH_WarehouseType in ('Normal','DefaultWH')

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志，移出二级经销商仓库
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ReferenceID)
	SELECT -IAL.IAL_LotQty,NEWID(),Lot.LOT_LTM_ID,IAL.IAL_LotNumber,IAL.IAL_ID
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Lot ON Lot.LOT_ID = ISNULL(IAL_QRLOT_ID,IAL_LOT_ID)
	
	WHERE IAH_Inv_Adj_Nbr=@OrderNo
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
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID

	WHERE IAH_Inv_Adj_Nbr=@OrderNo

	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
	SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

	--Lot操作日志，移入平台仓库
	INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ReferenceID)
	SELECT IAL.IAL_LotQty,NEWID(),Lot.LOT_LTM_ID,IAL.IAL_LotNumber,IAL.IAL_ID
	FROM InventoryAdjustLot IAL
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_ID = IAL.IAL_IAD_ID
	INNER JOIN InventoryAdjustHeader IAH ON IAH.IAH_ID = IAD.IAD_IAH_ID
	INNER JOIN Lot ON Lot.LOT_ID = ISNULL(IAL_QRLOT_ID,IAL_LOT_ID)

	WHERE IAH_Inv_Adj_Nbr=@OrderNo

	UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
	FROM #tmp_invtrans a 
	WHERE a.ITR_ReferenceID = #tmp_invtranslot.ITL_ReferenceID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
	SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
	--将该订单状态改为拒绝


	UPDATE InventoryAdjustHeader SET IAH_Status='Reject' WHERE IAH_Inv_Adj_Nbr=@OrderNo AND IAH_Reason in ('Return','Exchange')
	--写入日志
	INSERT INTO PurchaseOrderLog SELECT NEWID(),IAH_ID,'00000000-0000-0000-0000-000000000000',GETDATE(),'Reject', 'RSM审批拒绝' FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr=@OrderNo and IAH_Reason in ('Return','Exchange')
	end
	else 
	begin
	--将订单状态改为待批
	UPDATE InventoryAdjustHeader SET IAH_Status='Submitted' WHERE IAH_Inv_Adj_Nbr=@OrderNo AND IAH_Reason in ('Return','Exchange')
	--将审批通过的订单写入接口表
	INSERT INTO AdjustInterface SELECT NEWID(),'','',IAH_ID,IAH_Inv_Adj_Nbr,'Pending','Manual',NULL,IAH_CreatedBy_USR_UserID,GETDATE(),IAH_CreatedBy_USR_UserID,GETDATE(),@CentID FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr=@OrderNo and IAH_Reason in ('Return','Exchange')
	--写入日志
	INSERT INTO PurchaseOrderLog SELECT NEWID(),IAH_ID,'00000000-0000-0000-0000-000000000000',GETDATE(),'Approve','RSM审批确认' FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr=@OrderNo and IAH_Reason in ('Return','Exchange')
	end
	END  
   IF(@DealerType='T1')
      BEGIN
      INSERT INTO MailMessageQueue
		SELECT  newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#OrderNo}',IAH_Inv_Adj_Nbr),
					   replace(replace(replace(replace(MMT_Body,'{#UploadNo}',
					   IAH_Inv_Adj_Nbr),'{#Status}',@Status),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),
					   getdate(),20)) AS MMT_Body,
					   'Waiting',getdate(),null
				 from InventoryAdjustHeader t1, dealermaster t2, MailMessageTemplate t3,
					  (
						select t1.MDA_MailAddress from MailDeliveryAddress t1,dealermaster t2, client t3 , InventoryAdjustHeader t4
						where t1.MDA_MailType='Order' and t1.MDA_MailTo=t3.CLT_ID and t2.DMA_Parent_DMA_ID=t3.CLT_Corp_Id and t2.DMA_ID =t4.IAH_DMA_ID
						and t4.IAH_Inv_Adj_Nbr=@OrderNo and t1.MDA_ProductLineID=t4.IAH_ProductLine_BUM_ID
					  ) t4
				where IAH_Inv_Adj_Nbr=@OrderNo and t1.IAH_DMA_ID=t2.DMA_ID
				  and t3.MMT_Code='EMAIL_T1DEALEGOODSRETRUN_APPROVAL'
				  union
		     SELECT  newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#OrderNo}',IAH_Inv_Adj_Nbr),
					   replace(replace(replace(replace(MMT_Body,'{#UploadNo}',
					   IAH_Inv_Adj_Nbr),'{#Status}',@Status),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),
					   getdate(),20)) AS MMT_Body,
					   'Waiting',getdate(),null
				 from InventoryAdjustHeader t1, dealermaster t2, MailMessageTemplate t3,
					  (
						select t1.MDA_MailAddress from MailDeliveryAddress t1,InventoryAdjustHeader t4
						where t1.MDA_MailType='Order' and t1.MDA_MailTo = 'EAI'
						and t4.IAH_Inv_Adj_Nbr=@OrderNo and t1.MDA_ProductLineID=t4.IAH_ProductLine_BUM_ID
					  ) t4
				where IAH_Inv_Adj_Nbr=@OrderNo and t1.IAH_DMA_ID=t2.DMA_ID
				  and t3.MMT_Code='EMAIL_CSDEALERORDER_RSMAPPROVAL'
				  
      END
      ELSE IF(@DealerType='T2')
        BEGIN
      INSERT INTO MailMessageQueue
		SELECT  newid(),'email','',t4.MDA_MailAddress,replace(MMT_Subject,'{#OrderNo}',IAH_Inv_Adj_Nbr),
					   replace(replace(replace(replace(MMT_Body,'{#UploadNo}',
					   IAH_Inv_Adj_Nbr),'{#Status}',@Status),'{#DealerName}',t2.DMA_ChineseName),'{#SubmitDate}',convert(VARCHAR(30),
					   getdate(),20)) AS MMT_Body,
					   'Waiting',getdate(),null
				 from InventoryAdjustHeader t1, dealermaster t2, MailMessageTemplate t3,
					  (
						select t1.MDA_MailAddress from MailDeliveryAddress t1,dealermaster t2, client t3 , InventoryAdjustHeader t4
						where t1.MDA_MailType='Order' and t1.MDA_MailTo=t3.CLT_ID and t2.DMA_Parent_DMA_ID=t3.CLT_Corp_Id and t2.DMA_ID =t4.IAH_DMA_ID
						and t4.IAH_Inv_Adj_Nbr=@OrderNo and t1.MDA_ProductLineID=t4.IAH_ProductLine_BUM_ID
					  ) t4
				where IAH_Inv_Adj_Nbr=@OrderNo and t1.IAH_DMA_ID=t2.DMA_ID
				  and t3.MMT_Code='EMAIL_T2DEALEGOODSRETRUN_APPROVAL'
				  
      END
COMMIT TRAN
              
SET NOCOUNT OFF
SET @ResultValue = 0
return 0
END TRY
BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SELECT ERROR_MESSAGE()
    SET @ResultValue = -1
    return -1
    
END CATCH
GO


