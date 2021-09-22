
DROP view [interface].[V_I_CR_DeliveryData]
GO



CREATE view [interface].[V_I_CR_DeliveryData]
      as
      SELECT
		  d.DMA_SAP_Code as SAPCode,
		  Product.PMA_UPN AS UPN,
		  POReceiptLot.PRL_LotNumber AS LotNumber,
		 (SELECT ISNULL(SUM(POReceipt.POR_ReceiptQty),0)
          FROM POReceipt WHERE POReceipt.POR_PRH_ID = POReceiptHeader.PRH_ID) AS Qty,
		  POReceiptHeader.PRH_SAPShipmentID  as ShipmentNbr,
		  POReceiptHeader.PRH_PONumber AS ReceiptNbr,
		  POReceiptHeader.PRH_SAPShipmentDate AS DeliveryTime,
		  POReceiptHeader.PRH_PurchaseOrderNbr AS OrderNumber,
		  POH.POH_OrderType AS OrderType,
		  (select Value1 from Lafite_DICT where DICT_TYPE = 'CONST_Order_Type' and DICT_KEY=POH.POH_OrderType)	AS 	  OrderTypeName,
		  ld.VALUE1 AS PoStatus
		  FROM
		  POReceiptHeader (nolock)
		  left join DealerMaster(nolock) d on d.DMA_ID=POReceiptHeader.PRH_Dealer_DMA_ID
		  left join Lafite_DICT(nolock) ld on  ld.DICT_KEY=PRH_Status and  ld.DICT_TYPE='CONST_Receipt_Status'
		  --left join DealerMaster(nolock) dm on dm.DMA_ID=PRH_Vendor_DMA_ID
		  left join POReceipt(nolock) on POR_PRH_ID = PRH_ID
		  left join POReceiptLot(nolock) ON POReceiptLot.PRL_POR_ID = POReceipt.POR_ID
		  left join Product(nolock) ON POReceipt.POR_SAP_PMA_ID = Product.PMA_ID
		  left join purchaseorderHeader(nolock) POH ON POH.POH_OrderNo =  POReceiptHeader.PRH_PurchaseOrderNbr
      where PRH_Type='PurchaseOrder' and PRH_Status in ('Complete','Waiting')


GO


