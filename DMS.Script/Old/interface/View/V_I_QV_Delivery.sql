
DROP VIEW [interface].[V_I_QV_Delivery]
GO





CREATE VIEW [interface].[V_I_QV_Delivery]
AS
SELECT SAPCode
	,UPN
	,LotNumber
	,ShipmentNbr
	,ReceiptNbr
	,DeliveryTime
	,ReceiptTime
	,OrderNumber
	,OrderType
	,CAST(OrderTypeName AS NVARCHAR(50)) AS OrderTypeName
	,CAST(PoStatus AS  NVARCHAR(50)) AS PoStatus
	,DeliveryType
	,sum(Qty) AS Qty
FROM [interface].[V_I_QV_Delivery_WithQR]
WHERE deliverytime>=DATEADD(mm, DATEDIFF(mm, 0, getdate())-2, 0)
GROUP BY SAPCode
	,UPN
	,LotNumber
	,ShipmentNbr
	,ReceiptNbr
	,DeliveryTime
	,ReceiptTime
	,OrderNumber
	,OrderType
	,OrderTypeName
	,PoStatus
	,DeliveryType




GO


