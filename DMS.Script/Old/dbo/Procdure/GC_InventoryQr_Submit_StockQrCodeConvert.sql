DROP Procedure [dbo].[GC_InventoryQr_Submit_StockQrCodeConvert]
GO


CREATE Procedure [dbo].[GC_InventoryQr_Submit_StockQrCodeConvert]
    @DealerId uniqueidentifier,
	@QrCode NVARCHAR(50),
	@LotNumber NVARCHAR(50),
	@Upn NVARCHAR(100),
	@User uniqueidentifier,
	@NewWhId uniqueidentifier,
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
	AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRAN
		SET @RtnVal = 'Success'
		SET @RtnMsg = ''
	   
		BEGIN
			--校验入库二维码是否存在
			IF NOT EXISTS(SELECT 1 FROM QRCodeMaster WHERE QRM_QRCode = @QrCode)
				BEGIN
					SET @RtnMsg='入库二维码不存在'
				END
			--校验该经销商是否已经使过入库的二维码
			IF EXISTS(SELECT 1 FROM Inventory 
								INNER JOIN Warehouse ON INV_WHM_ID = Warehouse.WHM_ID 
								INNER JOIN Product on INV_PMA_ID=Product.PMA_ID  
								INNER JOIN Lot ON LOT_INV_ID=INV_ID 
								INNER JOIN LotMaster ON LotMaster.LTM_ID=Lot.LOT_LTM_ID
							WHERE WHM_DMA_ID = @DealerId
								AND  CASE WHEN CHARINDEX('@@', LTM_LotNumber, 0) > 0 THEN SUBSTRING(LTM_LotNumber, CHARINDEX('@@', LTM_LotNumber, 0) + 2, LEN(LTM_LotNumber) 
									- CHARINDEX('@@', LTM_LotNumber, 0)) ELSE 'NoQR' END = @QrCode 
								AND @RtnMsg = '')
                BEGIN
                    SET @RtnMsg = '二维码已经做过销售或退货'
                END
		END
		
		IF LEN(@RtnMsg) > 0
			SET @RtnVal = 'Error'

   COMMIT TRAN

  SET NOCOUNT OFF
  RETURN 1

 END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    RETURN -1
    
END CATCH

GO


