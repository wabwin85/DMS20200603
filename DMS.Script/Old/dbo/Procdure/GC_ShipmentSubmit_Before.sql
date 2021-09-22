DROP PROCEDURE [dbo].[GC_ShipmentSubmit_Before]
GO

CREATE PROCEDURE [dbo].[GC_ShipmentSubmit_Before]
	@ShipmentHeadId uniqueidentifier,
	@HospitalId uniqueidentifier,
	@ProductLineId uniqueidentifier,
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
	
	SELECT @DealerId = SPH_Dealer_DMA_ID FROM ShipmentHeader WHERE SPH_ID = @ShipmentHeadId
	SELECT @DealerType = DMA_DealerType FROM DealerMaster WHERE DMA_ID = @DealerId
	
	IF @DealerType != 'T2'
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
		T_ProductId uniqueidentifier,
		T_UPN nvarchar(100),
		T_Unit nvarchar(100),
		T_ConvertFactor float,
		T_WarehouseId uniqueidentifier,
		T_WarehouseType nvarchar(50),
		T_WarehouseCode nvarchar(50),
	    T_QRCode nvarchar(50),
	    T_LotShipQty float
	)
	
	INSERT INTO #InventoryTemp
	SELECT Lot.LOT_ID AS LotId,
		Lot.LOT_LTM_ID AS LtmId,
		convert(decimal (18,6),Lot.LOT_OnHandQty) AS LotInvQty,
		LotMaster.LTM_LotNumber AS LotNumber,
		Product.PMA_ID AS ProductId,
		Product.PMA_UPN AS UPN,
		Product.PMA_UnitOfMeasure AS UnitOfMeasure,
		PMA_ConvertFactor as ConvertFactor,
		Warehouse.WHM_ID,
		Warehouse.WHM_Type,
		Warehouse.WHM_Code,
	    case when isnull(ShipmentLot.SLT_QRLotNumber,'') = '' then substring(SLT_QRLotNumber,CHARINDEX('@@',SLT_QRLotNumber,0)+2,LEN(SLT_QRLotNumber)-CHARINDEX('@@',SLT_QRLotNumber,0)) else substring(SLT_QRLotNumber,CHARINDEX('@@',SLT_QRLotNumber,0)+2,LEN(SLT_QRLotNumber)-CHARINDEX('@@',SLT_QRLotNumber,0)) end AS QRCode,
	    
	    ShipmentLot.SLT_LotShippedQty
	
		FROM Inventory
			INNER JOIN Lot ON Inventory.INV_ID = Lot.LOT_INV_ID
			INNER JOIN LotMaster ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
			INNER JOIN Product ON Inventory.INV_PMA_ID = Product.PMA_ID
			INNER JOIN CFN ON Product.PMA_CFN_ID = CFN.CFN_ID
			INNER JOIN Warehouse ON Inventory.INV_WHM_ID = Warehouse.WHM_ID
			INNER JOIN ShipmentLot ON ShipmentLot.SLT_LOT_ID=Lot.LOT_ID
		WHERE WHM_DMA_ID = @DealerId--'C501129C-3FF5-48D8-8DC2-E81462C74CEC'
			AND WHM_Type IN ('LP_Consignment','Consignment')
			AND LTM_ID IN (SELECT SPC_LTM_ID FROM ShipmentConsignment WHERE SPC_SPH_ID = @ShipmentHeadId)--'1F54058F-E146-4E6C-A616-BD53D4623F67'
			AND Lot.LOT_OnHandQty > 0
			AND (
				EXISTS (SELECT  1
				FROM    DealerAuthorizationTable AS DA
				INNER JOIN DealerContract AS DC ON DA.DAT_DCL_ID = DC.DCL_ID
				INNER JOIN HospitalList AS HL ON DA.DAT_ID = HL.HLA_DAT_ID
				INNER JOIN Cache_PartsClassificationRec AS CP ON CP.PCT_ProductLine_BUM_ID = DA.DAT_ProductLine_BUM_ID
				WHERE DC.DCL_DMA_ID = Warehouse.WHM_DMA_ID
				AND HL.HLA_HOS_ID = @HospitalId--'67E69180-45EB-43A4-9539-43E0311D7BFD'
				AND (
						(DA.DAT_PMA_ID = DA.DAT_ProductLine_BUM_ID
						AND DA.DAT_ProductLine_BUM_ID = CFN.CFN_ProductLine_BUM_ID)
					OR
						(DA.DAT_PMA_ID != DA.DAT_ProductLine_BUM_ID
						AND CP.PCT_ParentClassification_PCT_ID = DA.DAT_PMA_ID
						--AND CP.PCT_ID = CFN.CFN_ProductCatagory_PCT_ID
						AND CP.PCT_ID in 
							(select a.ClassificationId  from CfnClassification a where a.CfnCustomerFaceNbr=cfn.CFN_CustomerFaceNbr)
						)
					)
				)
				AND CFN.CFN_ProductLine_BUM_ID=@ProductLineId--'0F71530B-66D5-44AF-9CAB-AD65D5449C51'
			)
	
	DECLARE @TotShipQty int
	DECLARE @TotLotQty int
	
	SELECT @TotLotQty = SUM(T_Qty) FROM #InventoryTemp
	SELECT @TotShipQty = SUM(SPC_ShippedQty) FROM ShipmentConsignment WHERE SPC_SPH_ID = @ShipmentHeadId
	
	IF @TotShipQty > @TotLotQty
		BEGIN
			COMMIT TRAN
			SET @RtnVal = 'Failure'
			SET @RtnMsg = '���������������ڿ������'
			return -1
		END
	
	--ShipmentConsignment		���ۼ��۱�
	DECLARE @ShippedQty decimal(18,6)
	DECLARE @UnitPrice decimal(18,6)
	DECLARE @LtmId uniqueidentifier
	DECLARE @PmaId uniqueidentifier
	DECLARE @ShipmentDate datetime
	DECLARE @Remark nvarchar(100)
	
	DECLARE @LineId uniqueidentifier
	DECLARE @LotId uniqueidentifier
	DECLARE @Qty decimal(18,6)
	DECLARE @ProductId uniqueidentifier
	DECLARE @WarehouseId uniqueidentifier
	DECLARE @WarehouseType nvarchar(50)
	DECLARE	@WarehouseCode nvarchar(50)
	DECLARE @QRCode nvarchar(50)
	DECLARE @LotShipQty float
	DECLARE @Now_Qty decimal(18,6)
	DECLARE @T_Counter int
	
	SET @T_Counter = 1
	
	--Clear ShipmentLine && ShipmentLot
	DELETE ShipmentLot WHERE SLT_SPL_ID IN (SELECT SPL_ID FROM ShipmentLine WHERE SPL_SPH_ID = @ShipmentHeadId)
	DELETE ShipmentLine WHERE SPL_SPH_ID = @ShipmentHeadId
	
	DECLARE ShipmentConsignment_Cursor CURSOR
	FOR (SELECT SPC_LTM_ID AS LtmId,SPC_ShippedQty AS ShippedQty,LTM_Product_PMA_ID AS PmaId,SPC_UnitPrice AS UnitPrice,ShipmentDate,Remark FROM ShipmentConsignment,LotMaster WHERE SPC_LTM_ID = LTM_ID AND SPC_SPH_ID = @ShipmentHeadId) --�����Ҫ�ļ��Ϸŵ��α���
	OPEN ShipmentConsignment_Cursor; --����α���α�
	FETCH NEXT FROM ShipmentConsignment_Cursor INTO @LtmId,@ShippedQty,@PmaId,@UnitPrice,@ShipmentDate,@Remark; --����α��ȡ��һ������
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @LineId = NEWID()
			--Add ShipmentLine
			INSERT INTO ShipmentLine (SPL_ID,SPL_SPH_ID,SPL_Shipment_PMA_ID,SPL_ShipmentQty,SPL_UnitPrice,SPL_LineNbr)
			VALUES(@LineId,@ShipmentHeadId,@PmaId,@ShippedQty,NULL,@T_Counter)
			
			SET @Now_Qty = @ShippedQty
			DECLARE Lp_Inventory_Cursor CURSOR
			FOR (SELECT T_LotId,T_Qty,T_ProductId,T_WarehouseId,T_WarehouseType,T_WarehouseCode,T_QRCode, T_LotShipQty FROM #InventoryTemp WHERE T_WarehouseType = 'LP_Consignment' AND T_LtmId = @LtmId)
			OPEN Lp_Inventory_Cursor; --Lp����α���α�
			FETCH NEXT FROM Lp_Inventory_Cursor INTO @LotId,@Qty,@ProductId,@WarehouseId,@WarehouseType,@WarehouseCode,@QRCode, @LotShipQty; --Lp����α��ȡ��һ������
			WHILE @@FETCH_STATUS = 0
				BEGIN
					PRINT '@Now_Qty1=='+convert(nvarchar(50),@Now_Qty)
					--Add ShipmentLot
					IF @Now_Qty <= 0
						BEGIN
							--��������������ѭ��
							SET @Now_Qty = 0
							BREAK
						END
					ELSE IF @Now_Qty > @Qty  
						BEGIN
							--��������������ڿ������������ShipmentLot�󣬼���ѭ��
							INSERT INTO ShipmentLot (SLT_SPL_ID,SLT_LotShippedQty,SLT_LOT_ID,SLT_ID,SLT_WHM_ID,SLT_UnitPrice,ShipmentDate,Remark)
							VALUES (@LineId,@Qty,@LotId,NEWID(),@WarehouseId,@UnitPrice,@ShipmentDate,@Remark)
							
							--��������
							SET @Now_Qty = @Now_Qty - @Qty
						END
					ELSE 
						BEGIN
							--�����������С�ڿ������������ShipmentLot������ѭ��
							INSERT INTO ShipmentLot (SLT_SPL_ID,SLT_LotShippedQty,SLT_LOT_ID,SLT_ID,SLT_WHM_ID,SLT_UnitPrice,ShipmentDate,Remark)
							VALUES (@LineId,@Now_Qty,@LotId,NEWID(),@WarehouseId,@UnitPrice,@ShipmentDate,@Remark)
							
							--��������
							SET @Now_Qty = 0
							
							Break
						END
						--�������ҽԺ���Ҳֿ��Ų���NOQR��βʱ���ж�ά��У��
						IF(@WarehouseType<>'Normal' and (SELECT Upper(RIGHT(@WarehouseCode,4)))<>'NOQR')
					     BEGIN
					     IF((select count(*) as CNT from QRCodeMaster where QRM_Status = 1 and QRM_QRCode =@QRCode)>0 )
					     BEGIN
					      IF(@LotShipQty>1)
					      
			                SET @RtnMsg='����ά������β�Ʒ�������ô���һ'
			               
			              ELSE
			               SET @RtnMsg = '��ά����Ч'
					     END
					   END
					FETCH NEXT FROM Lp_Inventory_Cursor INTO @LotId,@Qty,@ProductId,@WarehouseId,@WarehouseType,@WarehouseCode,@QRCode,@LotShipQty; --Lp����α��ȡ��һ������
				END
			
			CLOSE Lp_Inventory_Cursor; --Bsc����α�ر��α�
			DEALLOCATE Lp_Inventory_Cursor; --Bsc����α��ͷ��α�
			IF LEN(@RtnMsg)>0 --�ж��Ƿ��д�����Ϣ
			BEGIN
			COMMIT TRAN
			SET @RtnVal = 'Failure'
			return -1
			END
			
			ELSE
			IF @Now_Qty > 0 
				BEGIN
					DECLARE Bsc_Inventory_Cursor CURSOR
					FOR (SELECT T_LotId,T_Qty,T_ProductId,T_WarehouseId FROM #InventoryTemp WHERE T_WarehouseType = 'Consignment' AND T_LtmId = @LtmId)
					OPEN Bsc_Inventory_Cursor; --Bsc����α���α�
					FETCH NEXT FROM Bsc_Inventory_Cursor INTO @LotId,@Qty,@ProductId,@WarehouseId; --Bsc����α��ȡ��һ������
					WHILE @@FETCH_STATUS = 0
						BEGIN
							PRINT '@Now_Qty2=='+convert(nvarchar(50),@Now_Qty)
							--Add ShipmentLot
							IF @Now_Qty <= 0
								BEGIN
									--��������������ѭ��
									SET @Now_Qty = 0
									BREAK
								END
							ELSE IF @Now_Qty > @Qty
								BEGIN
									--��������������ڿ������������ShipmentLot�󣬼���ѭ��
									INSERT INTO ShipmentLot (SLT_SPL_ID,SLT_LotShippedQty,SLT_LOT_ID,SLT_ID,SLT_WHM_ID,SLT_UnitPrice,ShipmentDate,Remark)
									VALUES (@LineId,@Qty,@LotId,NEWID(),@WarehouseId,@UnitPrice,@ShipmentDate,@Remark)
									
									--��������
									SET @Now_Qty = @Now_Qty - @Qty
								END
							ELSE
								BEGIN
									--�����������С�ڿ������������ShipmentLot������ѭ��
									INSERT INTO ShipmentLot (SLT_SPL_ID,SLT_LotShippedQty,SLT_LOT_ID,SLT_ID,SLT_WHM_ID,SLT_UnitPrice,ShipmentDate,Remark)
									VALUES (@LineId,@Now_Qty,@LotId,NEWID(),@WarehouseId,@UnitPrice,@ShipmentDate,@Remark)
									
									--��������
									SET @Now_Qty = 0
									
									Break
								END
							
							FETCH NEXT FROM Bsc_Inventory_Cursor INTO @LotId,@Qty,@ProductId,@WarehouseId; --Bsc����α��ȡ��һ������
						END
						
					CLOSE Bsc_Inventory_Cursor; --�ڲ��α�ر��α�
					DEALLOCATE Bsc_Inventory_Cursor; --�ڲ��α��ͷ��α�
					
				END
			
			SET @T_Counter = @T_Counter+1	--������+1
			
			FETCH NEXT FROM ShipmentConsignment_Cursor INTO @LtmId,@ShippedQty,@PmaId,@UnitPrice,@ShipmentDate,@Remark; --����α��ȡ��һ������
		END
	    
	CLOSE ShipmentConsignment_Cursor; --����α�ر��α�
	DEALLOCATE ShipmentConsignment_Cursor; --����α��ͷ��α�
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    
    --��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '1��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH

GO


