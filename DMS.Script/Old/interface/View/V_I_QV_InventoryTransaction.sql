DROP VIEW [interface].[V_I_QV_InventoryTransaction]
GO






CREATE VIEW [interface].[V_I_QV_InventoryTransaction]
AS
SELECT DealerName
	,DealerCode
	,WarehouseName
	,WarehouseCode
	,WarehouseType
	,CAST(WarehouseTypeName AS NVARCHAR(50)) AS WarehouseTypeName
	,CAST(ProductLine AS NVARCHAR(50)) AS ProductLine
	,OperType
	,OperDate
	,UPN
	,LOT
	,SUM(Quantity) AS Quantity
	,Remark
	,ReferenceID
FROM [interface].[V_I_QV_InventoryTransaction_WithQR](nolock)
WHERE 1=1
	--AND CONVERT(NVARCHAR(6), OperDate, 112) = CONVERT(NVARCHAR(6), GETDATE(), 112)
	AND OperDate>=DATEADD(mm, DATEDIFF(mm, 0, getdate()), 0)
GROUP BY DealerName
	,DealerCode
	,WarehouseName
	,WarehouseCode
	,WarehouseType
	,WarehouseTypeName
	,ProductLine
	,OperType
	,OperDate
	,UPN
	,LOT
	,Remark
	,ReferenceID






GO


