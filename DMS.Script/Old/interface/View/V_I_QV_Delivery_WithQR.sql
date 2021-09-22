DROP VIEW [interface].[V_I_QV_Delivery_WithQR]
GO


CREATE VIEW [interface].[V_I_QV_Delivery_WithQR]
AS
SELECT d.DMA_SAP_Code AS SAPCode
	,Product.PMA_UPN AS UPN
	,wh.WHM_Code AS WHM_Code
	,
	--POReceiptLot.PRL_LotNumber AS LotNumber,
	CASE 
		WHEN charindex('@@', POReceiptLot.PRL_LotNumber) > 0
			THEN substring(POReceiptLot.PRL_LotNumber, 1, charindex('@@', POReceiptLot.PRL_LotNumber) - 1)
		ELSE POReceiptLot.PRL_LotNumber
		END AS LotNumber
	,CASE 
		WHEN charindex('@@', POReceiptLot.PRL_LotNumber) > 0
			THEN substring(POReceiptLot.PRL_LotNumber, charindex('@@', POReceiptLot.PRL_LotNumber) + 2, len(POReceiptLot.PRL_LotNumber))
		ELSE ''
		END AS QRCode
	,
	--(SELECT ISNULL(SUM(POReceipt.POR_ReceiptQty),0)
	--FROM POReceipt WHERE POReceipt.POR_PRH_ID = POReceiptHeader.PRH_ID) AS Qty,
	POReceiptLot.PRL_ReceiptQty AS Qty
	,POReceiptHeader.PRH_SAPShipmentID AS ShipmentNbr
	,POReceiptHeader.PRH_PONumber AS ReceiptNbr
	,POReceiptHeader.PRH_SAPShipmentDate AS DeliveryTime
	,POReceiptHeader.PRH_ReceiptDate AS ReceiptTime
	,POReceiptHeader.PRH_PurchaseOrderNbr AS OrderNumber
	,POH.POH_OrderType AS OrderType
	,CAST(LDT.Value1 AS NVARCHAR(50)) AS OrderTypeName
	--,(
	--	SELECT CAST(Value1 AS NVARCHAR(50))
	--	FROM Lafite_DICT
	--	WHERE DICT_TYPE = 'CONST_Order_Type' AND DICT_KEY = POH.POH_OrderType
	--	) AS OrderTypeName
	,cast(LDT.VALUE1 as nvarchar(50)) AS PoStatus
	,PRH_Type AS DeliveryType
FROM POReceiptHeader(NOLOCK)
LEFT JOIN DealerMaster(NOLOCK) d ON d.DMA_ID = POReceiptHeader.PRH_Dealer_DMA_ID
LEFT JOIN Lafite_DICT(NOLOCK) ld ON ld.DICT_KEY = PRH_Status AND ld.DICT_TYPE = 'CONST_Receipt_Status'
--left join DealerMaster(nolock) dm on dm.DMA_ID=PRH_Vendor_DMA_ID
LEFT JOIN POReceipt(NOLOCK) ON POR_PRH_ID = PRH_ID
LEFT JOIN POReceiptLot(NOLOCK) ON POReceiptLot.PRL_POR_ID = POReceipt.POR_ID
LEFT JOIN Product(NOLOCK) ON POReceipt.POR_SAP_PMA_ID = Product.PMA_ID
LEFT JOIN Warehouse wh on POReceiptHeader.PRH_WHM_ID=wh.WHM_ID
LEFT JOIN purchaseorderHeader(NOLOCK) POH ON POH.POH_OrderNo = POReceiptHeader.PRH_PurchaseOrderNbr AND poh.POH_CreateType NOT IN ('Temporary')
LEFT JOIN Lafite_DICT LDT ON LDT.DICT_TYPE = 'CONST_Order_Type' AND LDT.DICT_KEY = POH.POH_OrderType
WHERE
	--PRH_Type='Complain' 
	PRH_Status IN ('Complete', 'Waiting')
  AND ISNULL(d.DMA_Taxpayer,'')<>'直销医院'
	--AND POReceiptHeader.PRH_SAPShipmentDate>=DATEADD(mm, DATEDIFF(mm, 0, getdate())-2, 0)

GO


