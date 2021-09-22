DROP PROCEDURE [dbo].[GC_ShipmentAdjust_AddCfn]
GO



/*
销售调整添加产品
*/
CREATE PROCEDURE [dbo].[GC_ShipmentAdjust_AddCfn]
	@SphId					UNIQUEIDENTIFIER,
	@DealerId				UNIQUEIDENTIFIER,
	@HosId					UNIQUEIDENTIFIER,
	@LotIdString			NVARCHAR(MAX),
	@AddType				NVARCHAR(MAX),
	@RtnVal					NVARCHAR(20) OUTPUT,
	@RtnMsg					NVARCHAR(1000) OUTPUT
AS
	DECLARE @ErrorCount INTEGER
	DECLARE @SltId UNIQUEIDENTIFIER
	DECLARE @ShipPrice DECIMAL(18,6)
	DECLARE @ProductId UNIQUEIDENTIFIER

	DECLARE @ShipmentType NVARCHAR(200)

	SET  NOCOUNT ON

	BEGIN TRY
	BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''

	SELECT @ShipmentType = SPH_Type FROM ShipmentHeader WHERE SPH_ID = @SphId

	/*将传递进来的CFNID字符串转换成纵表*/
	DECLARE SltCursor CURSOR FOR SELECT A.VAL FROM dbo.GC_Fn_SplitStringToTable(@LotIdString,',') A
	
	OPEN SltCursor
		FETCH NEXT FROM SltCursor INTO @SltId
		WHILE @@FETCH_STATUS = 0
			BEGIN
				
				IF @AddType = 'Shipment'
					BEGIN
					
						IF NOT EXISTS (SELECT 1 FROM ShipmentAdjustLot WHERE SAL_SPH_ID = @SphId AND SAL_SLT_ID = @SltId  AND SAL_Type = @AddType)
							BEGIN
								INSERT INTO ShipmentAdjustLot
										   (SAL_ID
										   ,SAL_SPH_ID
										   ,SAL_Type
										   ,SAL_PMA_ID
										   ,SAL_CFN_ID
										   ,SAL_LTM_ID
										   ,SAL_SLT_ID
										   ,SAL_LOT_ID
										   ,SAL_ShipmentQty
										   ,SAL_ShipmentPrice)
										SELECT NEWID(),@SphId,@AddType,PMA_ID,CFN_ID,LTM_ID,SLT_ID,LOT_ID,SLT_LotShippedQty,SLT_UnitPrice
										FROM ShipmentLot 
										INNER JOIN Lot ON LOT_ID = ISNULL(SLT_QRLOT_ID,SLT_LOT_ID)
										INNER JOIN LotMaster ON LTM_ID = LOT_LTM_ID
										INNER JOIN Inventory ON INV_ID = LOT_INV_ID
										INNER JOIN Product ON PMA_ID = INV_PMA_ID
										INNER JOIN CFN ON CFN_ID = PMA_CFN_ID
										WHERE SLT_ID = @SltId
							END
					END
				ELSE IF @AddType = 'Inventory'
					BEGIN
						
						IF NOT EXISTS (SELECT 1 FROM ShipmentAdjustLot WHERE SAL_SPH_ID = @SphId AND SAL_LOT_ID = @SltId  AND SAL_Type = @AddType)
							BEGIN
								
								SET @ShipPrice = NULL

								--只有普通类型的销售单需要在系统中查询销售单价
								IF @ShipmentType = 'Hospital'
									BEGIN
										
										SELECT @ProductId = INV_PMA_ID FROM Lot INNER JOIN Inventory ON INV_ID = LOT_INV_ID WHERE LOT_ID = @SltId

										SELECT TOP 1 @ShipPrice = DPH_UnitPrice FROM DealerProductPriceHistory WHERE DPH_DMA_ID = @DealerId AND DPH_PMA_ID = @ProductId AND DPH_SLT_ID = @HosId ORDER BY DPH_CreateDate DESC

										IF @ShipPrice IS NULL
											BEGIN
										
												SELECT TOP 1 @ShipPrice = DPH_UnitPrice FROM DealerProductPriceHistory WHERE DPH_DMA_ID = @DealerId AND DPH_PMA_ID = @ProductId ORDER BY DPH_CreateDate DESC

											END
								
									END
								

								INSERT INTO ShipmentAdjustLot
										   (SAL_ID
										   ,SAL_SPH_ID
										   ,SAL_Type
										   ,SAL_PMA_ID
										   ,SAL_CFN_ID
										   ,SAL_LTM_ID
										   ,SAL_SLT_ID
										   ,SAL_LOT_ID
										   ,SAL_ShipmentQty
										   ,SAL_ShipmentPrice)
										SELECT NEWID(),@SphId,@AddType,PMA_ID,CFN_ID,LTM_ID,NULL,LOT_ID,1,NULL FROM Lot 
										INNER JOIN LotMaster ON LTM_ID = LOT_LTM_ID
										INNER JOIN Inventory ON INV_ID = LOT_INV_ID
										INNER JOIN Product ON PMA_ID = INV_PMA_ID
										INNER JOIN CFN ON CFN_ID = PMA_CFN_ID
										WHERE LOT_ID = @SltId
							END

					END
				

				FETCH NEXT FROM SltCursor INTO @SltId
			END

      CLOSE SltCursor
      DEALLOCATE SltCursor

      
      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
	SET  NOCOUNT OFF
	ROLLBACK TRAN
	SET @RtnVal = 'Failure'

	--记录错误日志开始
	DECLARE @error_line   INT
	DECLARE @error_number   INT
	DECLARE @error_message   NVARCHAR (256)
	DECLARE @vError   NVARCHAR (1000)
	SET @error_line = ERROR_LINE ()
	SET @error_number = ERROR_NUMBER ()
	SET @error_message = ERROR_MESSAGE ()
	SET @vError =
			'行'
		+ CONVERT (NVARCHAR (10), @error_line)
		+ '出错[错误号'
		+ CONVERT (NVARCHAR (10), @error_number)
		+ '],'
		+ @error_message
	SET @RtnMsg = @vError
	RETURN -1
   END CATCH


GO


