DROP view [dbo].[V_Delivery_WechatQuery]
GO

Create view [dbo].[V_Delivery_WechatQuery] AS
select PRH_SAPShipmentID,PRH_PurchaseOrderNbr,Status,PRH_SAPShipmentDate,DMA_ChineseName,DeliveryFrom,PRH_TrackingNo,sum(isnull(PRL_ReceiptQty,0)) AS TotalQty
from V_DeliveryDetail_WechatQuery 
group  by PRH_SAPShipmentID,PRH_PurchaseOrderNbr,Status,PRH_SAPShipmentDate,DMA_ChineseName,DeliveryFrom,PRH_TrackingNo
GO


