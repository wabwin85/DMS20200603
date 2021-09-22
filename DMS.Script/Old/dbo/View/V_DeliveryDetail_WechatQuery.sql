DROP VIEW [dbo].[V_DeliveryDetail_WechatQuery]
GO

CREATE VIEW [dbo].[V_DeliveryDetail_WechatQuery]
AS
select PRH_SAPShipmentID,PRH_PurchaseOrderNbr,Status,PRH_SAPShipmentDate,PRH_TrackingNo,DMA_ChineseName,DeliveryFrom,CFN_CustomerFaceNbr,CFN_ChineseName,PRL_LotNumber,PRL_ExpiredDate,sum(PRL_ReceiptQty) AS PRL_ReceiptQty
FROM
(
select H.PRH_SAPShipmentID,H.PRH_PurchaseOrderNbr,Dic.VALUE1 AS Status, H.PRH_SAPShipmentDate,
H.PRH_TrackingNo, DM.DMA_ChineseName,DMParent.DMA_ChineseName As DeliveryFrom,
C.CFN_CustomerFaceNbr,C.CFN_ChineseName,
CASE WHEN charindex('@@',T.PRL_LotNumber) > 0 
            THEN substring(T.PRL_LotNumber,1,charindex('@@',T.PRL_LotNumber)-1) 
            ELSE T.PRL_LotNumber
            END AS PRL_LotNumber,
T.PRL_ExpiredDate, T.PRL_ReceiptQty
from POReceiptHeader H , POReceipt D, POReceiptLot T, DealerMaster DM, DealerMaster DMParent, CFN AS C, Product P, Lafite_DICT Dic
where H.PRH_ID = D.POR_PRH_ID
and D.POR_ID = T.PRL_POR_ID
and H.PRH_Dealer_DMA_ID = DM.DMA_ID
and H.PRH_Vendor_DMA_ID = DMParent.DMA_ID
and D.POR_SAP_PMA_ID = P.PMA_ID
and P.PMA_CFN_ID = C.CFN_ID
and H.PRH_Status = Dic.DICT_KEY
and Dic.DICT_TYPE='CONST_Receipt_Status'
and H.PRH_SAPShipmentDate > dateadd(month,-2,getdate())
) tab
group by PRH_SAPShipmentID,PRH_PurchaseOrderNbr,Status,PRH_SAPShipmentDate,PRH_TrackingNo,DMA_ChineseName,DeliveryFrom,CFN_CustomerFaceNbr,CFN_ChineseName,PRL_LotNumber,PRL_ExpiredDate
GO


