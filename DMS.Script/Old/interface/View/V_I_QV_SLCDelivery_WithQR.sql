DROP view [interface].[V_I_QV_SLCDelivery_WithQR]
GO

create view [interface].[V_I_QV_SLCDelivery_WithQR]
AS
select DNB_DeliveryNoteNbr AS 'DeliveryNo',DNB_DeliveryDate AS 'DeliveryDate',
DNB_SoldToSAPCode AS 'SoldToSAPCod',DNB_SoldToName AS 'SoldToName',
DNB_ShipToSAPCode AS 'ShipToSAPCode',DNB_ShipToName AS 'ShipToName',
 DNB_UPN AS 'UPN',DNB_LotNumber AS 'LOT',DNB_QRCode AS 'QRCode',
 DNB_ExpiredDate AS 'ExpireDate',
 dnb_shipQty AS 'Qty',
 DNB_BoxNo AS 'BoxNo',
 dnb_note AS 'Remark',
DNB_OrderNo AS 'OrderNo',DNB_CreatedDate As 'createDate'
 from DeliveryNoteBSCSLC 
 where DNB_HandleDate>'2016-01-01 0:13:46'
and DNB_Status in ('UploadSuccess','GenerateSuccess')
GO


