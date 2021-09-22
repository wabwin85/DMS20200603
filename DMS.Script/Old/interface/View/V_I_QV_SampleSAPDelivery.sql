DROP VIEW [interface].[V_I_QV_SampleSAPDelivery]
GO

CREATE VIEW [interface].[V_I_QV_SampleSAPDelivery]
AS
   SELECT D.DMA_SAP_Code AS SAPCode,
          P.PMA_UPN AS UPN,
          T.PRL_LotNumber AS LotNumber,
         
          --(SELECT ISNULL(SUM(POReceipt.POR_ReceiptQty),0)
          --FROM POReceipt WHERE POReceipt.POR_PRH_ID = POReceiptHeader.PRH_ID) AS Qty,
          T.PRL_ReceiptQty AS Qty,
          H.PRH_SAPShipmentID AS ShipmentNbr,
          H.PRH_PONumber AS ReceiptNbr,
          H.PRH_SAPShipmentDate AS DeliveryTime,
          H.PRH_ReceiptDate AS ReceiptTime,
          H.PRH_PurchaseOrderNbr AS OrderNumber,
          POH.POH_OrderType AS OrderType,
          (SELECT CAST (Value1 AS NVARCHAR (50))
             FROM Lafite_DICT
            WHERE     DICT_TYPE = 'CONST_Order_Type'
                  AND DICT_KEY = POH.POH_OrderType)
             AS OrderTypeName,
          cast (LD.VALUE1 AS NVARCHAR (50)) AS PoStatus,
          H.PRH_Type AS DeliveryType
     FROM POReceiptHeader_SAPNoQR AS H (NOLOCK) 
     LEFT JOIN DealerMaster AS D (NOLOCK) ON D.DMA_ID = H.PRH_Dealer_DMA_ID
     LEFT JOIN Lafite_DICT AS LD (NOLOCK) ON LD.DICT_KEY = H.PRH_Status AND LD.DICT_TYPE = 'CONST_Receipt_Status'
     LEFT JOIN POReceipt_SAPNoQR AS L(NOLOCK) ON L.POR_PRH_ID = H.PRH_ID
     LEFT JOIN POReceiptLot_SAPNoQR AS T(NOLOCK) ON T.PRL_POR_ID = L.POR_ID
     LEFT JOIN Product AS P(NOLOCK) ON L.POR_SAP_PMA_ID = P.PMA_ID
     LEFT JOIN purchaseorderHeader AS POH(NOLOCK) ON POH.POH_OrderNo = H.PRH_PurchaseOrderNbr AND poh.POH_CreateType NOT IN ('Temporary')
WHERE
 H.PRH_Status IN ('Complete', 'Waiting')
 AND exists (select 1 from SampleApplyHead b where b.ApplyNo=H.PRH_PurchaseOrderNbr)
GO


