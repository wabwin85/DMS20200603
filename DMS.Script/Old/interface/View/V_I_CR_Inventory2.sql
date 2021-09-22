DROP VIEW [interface].[V_I_CR_Inventory2]
GO


CREATE VIEW [interface].[V_I_CR_Inventory2]
AS
 
	 SELECT
	 ID=L.PRL_ID,
	  DealerID=H.PRH_Dealer_DMA_ID,
       LocationID=H.PRH_WHM_ID,
       0 AS Nature,
       UPN=C.CFN_CustomerFaceNbr,
       LOT=L.PRL_LotNumber,
       Expdate=L.PRL_ExpiredDate,
       L.PRL_ReceiptQty-isnull(DCM_Qty,0) as Qty,
       PurchasePrice=CONVERT (MONEY,[interface].[fn_GetPurchasePriceForInventory] (C.CFN_ID,H.PRH_Dealer_DMA_ID,W.WHM_Type)/ 1.17),
       [Month] = DATEPART (month, getdate ()),
       [Year] = DATEPART (year, getdate ()),
       InvType = 0,
       WHM_Type=w.WHM_Type,
       IsForReceipt = 1,
       WHM_Name,
       PRH_Type
       
       
  FROM DMS_BAK.dbo.POReceiptHeader H
       left join DMS_BAK.dbo.POReceipt D on H.PRH_ID = D.POR_PRH_ID
       left join DMS_BAK.dbo.POReceiptLot L on D.POR_ID = L.PRL_POR_ID
       left join DMS_BAK.dbo.Product P on P.PMA_ID = D.POR_SAP_PMA_ID
       left join DMS_BAK.dbo.cfn C on C.CFN_ID = P.PMA_CFN_ID
       left join DMS_BAK.dbo.Warehouse W on H.PRH_WHM_ID = W.WHM_ID
       left join DMS_BAK.dbo.DeliveryConfirmationMid on H.PRH_ID=DCM_PRH_ID
       and c.CFN_CustomerFaceNbr=DCM_UPN and L.PRL_LotNumber=DCM_Lot
       
 WHERE     
       L.PRL_ReceiptQty > 0
       --AND H.PRH_Type = 'PurchaseOrder'
       AND H.PRH_Status = 'Waiting'

GO


