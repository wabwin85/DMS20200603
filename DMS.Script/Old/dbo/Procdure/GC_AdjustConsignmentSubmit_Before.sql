DROP PROCEDURE [dbo].[GC_AdjustConsignmentSubmit_Before]
GO




CREATE PROCEDURE [dbo].[GC_AdjustConsignmentSubmit_Before]
	@AdjustHeadId uniqueidentifier,
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg nvarchar(MAX) OUTPUT 
as	
SET NOCOUNT ON
BEGIN TRY

BEGIN TRAN
	DECLARE @SysUserId uniqueidentifier
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	DECLARE @DealerId uniqueidentifier
	DECLARE @DealerType NVARCHAR(50)
	DECLARE @AdjustType NVARCHAR(50)
	DECLARE @ReturnType NVARCHAR(50)
	
	SELECT @DealerId = IAH_DMA_ID,@AdjustType = IAH_Reason,@ReturnType = IAH_WarehouseType FROM InventoryAdjustHeader WHERE IAH_ID = @AdjustHeadId
	SELECT @DealerType = DMA_DealerType FROM DealerMaster WHERE DMA_ID = @DealerId
	
	IF ((@DealerType = 'T2' AND @AdjustType = 'Return' AND @ReturnType != 'Consignment')
	     or (@DealerType = 'T2' AND @AdjustType = 'Exchange' AND @ReturnType != 'Consignment'))
		BEGIN
			COMMIT TRAN
			RETURN 1
		END
		
	 
	CREATE TABLE #InventoryTemp
	(
		T_LotId uniqueidentifier,
		T_LtmId uniqueidentifier,
		T_Qty decimal(18,6),
		T_LotNumber nvarchar(50),
		T_ExpiredDate datetime,
		T_ProductId uniqueidentifier,
		T_UPN nvarchar(100),
		T_Unit nvarchar(100),
		T_ConvertFactor float,
		T_WarehouseId uniqueidentifier,
		T_WarehouseType nvarchar(50),
	)
	
	INSERT INTO #InventoryTemp
	SELECT Lot.LOT_ID AS LotId,
		Lot.LOT_LTM_ID AS LtmId,
		convert(decimal (18,6),Lot.LOT_OnHandQty) AS LotInvQty,
		LotMaster.LTM_LotNumber AS LotNumber,
		LotMaster.LTM_ExpiredDate AS T_ExpiredDate,
		Product.PMA_ID AS ProductId,
		Product.PMA_UPN AS UPN,
		Product.PMA_UnitOfMeasure AS UnitOfMeasure,
		PMA_ConvertFactor as ConvertFactor,
		Warehouse.WHM_ID,
		Warehouse.WHM_Type
		FROM Inventory
			INNER JOIN Lot ON Inventory.INV_ID = Lot.LOT_INV_ID
			INNER JOIN LotMaster ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
			INNER JOIN Product ON Inventory.INV_PMA_ID = Product.PMA_ID
			INNER JOIN CFN ON Product.PMA_CFN_ID = CFN.CFN_ID
			INNER JOIN Warehouse ON Inventory.INV_WHM_ID = Warehouse.WHM_ID
		WHERE WHM_DMA_ID = @DealerId--@DealerId''C501129C-3FF5-48D8-8DC2-E81462C74CEC'
			AND WHM_Type IN ('LP_Borrow','Borrow')
			AND LTM_ID IN (SELECT IAC_LTM_ID FROM InventoryAdjustConsignment WHERE IAC_IAH_ID = @AdjustHeadId)--'@AdjustHeadId1F54058F-E146-4E6C-A616-BD53D4623F67'
			AND Lot.LOT_OnHandQty > 0
	
	DECLARE @TotShipQty int
	DECLARE @TotLotQty int
	
	SELECT @TotLotQty = SUM(T_Qty) FROM #InventoryTemp
	SELECT @TotShipQty = SUM(IAC_ShippedQty) FROM InventoryAdjustConsignment WHERE IAC_IAH_ID = @AdjustHeadId
	
	IF @TotShipQty > @TotLotQty
		BEGIN
			COMMIT TRAN
			SET @RtnVal = 'Failure'
			SET @RtnMsg = '寄售退货数量大于库存数量'
			return -1
		END
	
	--InventoryAdjustConsignment		退货寄售表
	DECLARE @ShippedQty decimal(18,6)
	DECLARE @PurchaseOrderId uniqueidentifier
	DECLARE @LtmId uniqueidentifier
	DECLARE @PmaId uniqueidentifier
	DECLARE @DmaId uniqueidentifier
	
	DECLARE @LineId uniqueidentifier
	DECLARE @LotId uniqueidentifier
	DECLARE @Qty decimal(18,6)
	DECLARE @ProductId uniqueidentifier
	DECLARE @WarehouseId uniqueidentifier
	DECLARE @LotNumber nvarchar(100)
	DECLARE @ExpiredDate datetime
	
	DECLARE @Now_Qty decimal(18,6)
	DECLARE @T_Counter int
	SET @T_Counter = 1
	
	--Clear ShipmentLine && ShipmentLot
	DELETE InventoryAdjustLot WHERE IAL_IAD_ID IN (SELECT IAD_ID FROM InventoryAdjustDetail WHERE IAD_IAH_ID = @AdjustHeadId)
	DELETE InventoryAdjustDetail WHERE IAD_IAH_ID = @AdjustHeadId
	
	DECLARE AdjustConsignment_Cursor CURSOR
	FOR (SELECT IAC_LTM_ID AS LtmId,IAC_ShippedQty AS ShippedQty,LTM_Product_PMA_ID AS PmaId,IAC_PRH_ID AS PrhId,IAC_DMA_ID AS DmaId FROM InventoryAdjustConsignment,LotMaster WHERE IAC_LTM_ID = LTM_ID AND IAC_IAH_ID = @AdjustHeadId) --查出需要的集合放到游标中
	OPEN AdjustConsignment_Cursor; --外层游标打开游标
	FETCH NEXT FROM AdjustConsignment_Cursor INTO @LtmId,@ShippedQty,@PmaId,@PurchaseOrderId,@DmaId; --外层游标读取第一行数据
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @LineId = NEWID()
			--Add InventoryAdjustDetail
			INSERT INTO InventoryAdjustDetail (IAD_Quantity,IAD_ID,IAD_PMA_ID,IAD_IAH_ID,IAD_LineNbr)
			VALUES(@ShippedQty,@LineId,@PmaId,@AdjustHeadId,@T_Counter)
			
			SET @Now_Qty = @ShippedQty
			DECLARE Lp_Inventory_Cursor CURSOR
			FOR (SELECT T_LotId,T_Qty,T_ProductId,T_WarehouseId,T_LotNumber,T_ExpiredDate FROM #InventoryTemp WHERE T_WarehouseType = 'LP_Borrow' AND T_LtmId = @LtmId)
			OPEN Lp_Inventory_Cursor; --Lp库存游标打开游标
			FETCH NEXT FROM Lp_Inventory_Cursor INTO @LotId,@Qty,@ProductId,@WarehouseId,@LotNumber,@ExpiredDate; --Lp库存游标读取第一行数据
			WHILE @@FETCH_STATUS = 0
				BEGIN
					PRINT '@Now_Qty1=='+convert(nvarchar(50),@Now_Qty)
					--Add InventoryAdjustLot
					IF @Now_Qty <= 0
						BEGIN
							--更新数量、跳出循环
							SET @Now_Qty = 0
							BREAK
						END
					ELSE IF @Now_Qty > @Qty  
						BEGIN
							SELECT* FROM InventoryAdjustLot
							--如果寄售数量大于库存数量，插入InventoryAdjustLot后，继续循环
							INSERT INTO InventoryAdjustLot (IAL_IAD_ID,IAL_ID,IAL_LotQty,IAL_LOT_ID,IAL_WHM_ID,IAL_LotNumber,IAL_ExpiredDate,IAL_PRH_ID,IAL_DMA_ID)
							VALUES (@LineId,NEWID(),@Qty,@LotId,@WarehouseId,@LotNumber,@ExpiredDate,@PurchaseOrderId,@DmaId)
							
							--更新数量
							SET @Now_Qty = @Now_Qty - @Qty
						END
					ELSE 
						BEGIN
							--如果寄售数量小于库存数量，插入InventoryAdjustLot后跳出循环
							INSERT INTO InventoryAdjustLot (IAL_IAD_ID,IAL_ID,IAL_LotQty,IAL_LOT_ID,IAL_WHM_ID,IAL_LotNumber,IAL_ExpiredDate,IAL_PRH_ID,IAL_DMA_ID)
							VALUES (@LineId,NEWID(),@Now_Qty,@LotId,@WarehouseId,@LotNumber,@ExpiredDate,@PurchaseOrderId,@DmaId)
							
							--更新数量
							SET @Now_Qty = 0
							
							Break
						END
					
					FETCH NEXT FROM Lp_Inventory_Cursor INTO @LotId,@Qty,@ProductId,@WarehouseId,@LotNumber,@ExpiredDate; --Lp库存游标读取下一行数据
				END
			
			CLOSE Lp_Inventory_Cursor; --Bsc库存游标关闭游标
			DEALLOCATE Lp_Inventory_Cursor; --Bsc库存游标释放游标
			
			IF @Now_Qty > 0 
				BEGIN
					DECLARE Bsc_Inventory_Cursor CURSOR
					FOR (SELECT T_LotId,T_Qty,T_ProductId,T_WarehouseId,T_LotNumber,T_ExpiredDate FROM #InventoryTemp WHERE T_WarehouseType = 'Borrow' AND T_LtmId = @LtmId)
					OPEN Bsc_Inventory_Cursor; --Bsc库存游标打开游标
					FETCH NEXT FROM Bsc_Inventory_Cursor INTO @LotId,@Qty,@ProductId,@WarehouseId,@LotNumber,@ExpiredDate; --Bsc库存游标读取第一行数据
					WHILE @@FETCH_STATUS = 0
						BEGIN
							PRINT '@Now_Qty2=='+convert(nvarchar(50),@Now_Qty)
							--Add InventoryAdjustLot
							IF @Now_Qty <= 0
								BEGIN
									--更新数量、跳出循环
									SET @Now_Qty = 0
									BREAK
								END
							ELSE IF @Now_Qty > @Qty
								BEGIN
									--如果寄售数量大于库存数量，插入InventoryAdjustLot后，继续循环
									INSERT INTO InventoryAdjustLot (IAL_IAD_ID,IAL_ID,IAL_LotQty,IAL_LOT_ID,IAL_WHM_ID,IAL_LotNumber,IAL_ExpiredDate,IAL_PRH_ID,IAL_DMA_ID)
									VALUES (@LineId,NEWID(),@Qty,@LotId,@WarehouseId,@LotNumber,@ExpiredDate,@PurchaseOrderId,@DmaId)
									
									--更新数量
									SET @Now_Qty = @Now_Qty - @Qty
								END
							ELSE
								BEGIN
									--如果寄售数量小于库存数量，插入InventoryAdjustLot后跳出循环
									INSERT INTO InventoryAdjustLot (IAL_IAD_ID,IAL_ID,IAL_LotQty,IAL_LOT_ID,IAL_WHM_ID,IAL_LotNumber,IAL_ExpiredDate,IAL_PRH_ID,IAL_DMA_ID)
									VALUES (@LineId,NEWID(),@Now_Qty,@LotId,@WarehouseId,@LotNumber,@ExpiredDate,@PurchaseOrderId,@DmaId)
									
									--更新数量
									SET @Now_Qty = 0
									
									Break
								END
							
							FETCH NEXT FROM Bsc_Inventory_Cursor INTO @LotId,@Qty,@ProductId,@WarehouseId,@LotNumber,@ExpiredDate; --Bsc库存游标读取下一行数据
						END
					    
					CLOSE Bsc_Inventory_Cursor; --内层游标关闭游标
					DEALLOCATE Bsc_Inventory_Cursor; --内层游标释放游标
				END
			
			SET @T_Counter = @T_Counter+1	--计数器+1
			
			FETCH NEXT FROM AdjustConsignment_Cursor INTO @LtmId,@ShippedQty,@PmaId,@PurchaseOrderId,@DmaId; --外层游标读取下一行数据
		END
	    
	CLOSE AdjustConsignment_Cursor; --外层游标关闭游标
	DEALLOCATE AdjustConsignment_Cursor; --外层游标释放游标
	
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
	set @vError = '1行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH




GO


