DROP VIEW [interface].[V_I_QV_BscQRDelivery]
GO

CREATE VIEW [interface].[V_I_QV_BscQRDelivery]
AS
select DNB_DeliveryNoteNbr AS DeliveryNoteNbr, DNB_DeliveryDate AS DeliveryDate,DNB_SoldToSAPCode AS SoldToSAPCode,DNB_SoldToName AS SoldToName,
DNB_ShipToSAPCode AS ShipToSAPCode,DNB_ShipToName AS ShipToName,DNB_UPN AS UPN,DNB_LotNumber AS Lot, DNB_QRCode AS QRCode,DNB_ShipQty AS Qty,DNB_ExpiredDate AS ExpiredDate,
DNB_OrderNo AS OrderNo,DNB_SapDeliveryLineNbr AS LineNbr,DNB_CreatedDate AS CreatedDate,DNB_DMA_ID AS DMA_ID
  from DeliveryNoteBSCSLC (nolock)
  where DNB_Status in ('UploadSuccess','GenerateSuccess')
GO


