DROP Procedure [dbo].[GC_GetCfnPriceHistory]
GO

CREATE Procedure [dbo].[GC_GetCfnPriceHistory]
    @DealerId uniqueidentifier,
	@HospId uniqueidentifier,
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
	AS
	SET NOCOUNT ON
	BEGIN TRY
		BEGIN TRAN
		SET @RtnVal = 'Success'
		SET @RtnMsg = ''
	BEGIN
	
	--���۸���Ϊ��
	UPDATE InventoryQROperation SET IO_ShipmentPrice=NULL
	WHERE IO_DMA_Id=@DealerId AND IO_OperationType='Shipment'
	
	--���ݲ�Ʒ�������̣�ҽԺ���¼۸�
	UPDATE InventoryQROperation SET IO_ShipmentPrice=(SELECT TOP 1 DPH_UnitPrice FROM DealerProductPriceHistory
	WHERE DealerProductPriceHistory.DPH_PMA_ID=InventoryQROperation.IO_PMA_ID AND DealerProductPriceHistory.DPH_DMA_ID=@DealerId AND DealerProductPriceHistory.DPH_SLT_ID=@HospId
	ORDER BY DealerProductPriceHistory.DPH_CreateDate DESC)

	--������ݲ�Ʒ�������̣�ҽԺû�ҵ���Ʒ�۸����վ����̲�Ʒ���¼۸�
	UPDATE InventoryQROperation SET IO_ShipmentPrice=(SELECT TOP 1 DPH_UnitPrice FROM DealerProductPriceHistory
	WHERE DealerProductPriceHistory.DPH_PMA_ID=InventoryQROperation.IO_PMA_ID AND DealerProductPriceHistory.DPH_DMA_ID=@DealerId
	ORDER BY DealerProductPriceHistory.DPH_CreateDate DESC)
	WHERE InventoryQROperation.IO_ShipmentPrice IS NULL
		
   COMMIT TRAN

  SET NOCOUNT OFF
  RETURN 1
  END
 END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    RETURN -1
    
END CATCH
GO


