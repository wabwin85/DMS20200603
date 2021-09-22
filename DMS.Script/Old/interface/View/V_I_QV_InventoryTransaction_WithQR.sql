DROP VIEW [interface].[V_I_QV_InventoryTransaction_WithQR]
GO









CREATE VIEW [interface].[V_I_QV_InventoryTransaction_WithQR]
AS
SELECT DealerMaster.DMA_ChineseName AS 'DealerName'
	,DealerMaster.DMA_SAP_Code AS 'DealerCode'
	,Warehouse.WHM_Name AS 'WarehouseName'
	,Warehouse.WHM_Code AS 'WarehouseCode'
	,Warehouse.WHM_Type AS 'WarehouseType'
	,cast(dt.VALUE1 as nvarchar(50))  AS 'WarehouseTypeName'
	--,(
	--	SELECT cast(VALUE1 as nvarchar(50))
	--	FROM Lafite_DICT
	--	WHERE DICT_TYPE = 'MS_WarehouseType'
	--		AND DICT_KEY = Warehouse.WHM_Type
	--	) AS 'WarehouseTypeName'
	--,(
	--	SELECT cast(T2.ATTRIBUTE_NAME as nvarchar(50))
	--	FROM cfn t1
	--		,Lafite_ATTRIBUTE T2
	--	WHERE t1.CFN_ID = Product.PMA_CFN_ID
	--		AND t1.CFN_ProductLine_BUM_ID = t2.id
	--	) AS 'ProductLine'
	,InventoryTransaction.ITR_Type AS 'OperType'
	,InventoryTransaction.ITR_TransactionDate AS 'OperDate'
	,Product.PMA_UPN AS 'UPN'
	,
	--InventoryTransactionLot.ITL_LotNumber AS 'Lot',
	CASE WHEN charindex('@@', InventoryTransactionLot.ITL_LotNumber) > 0 THEN substring(InventoryTransactionLot.ITL_LotNumber, 1, charindex('@@', InventoryTransactionLot.ITL_LotNumber) - 1) ELSE InventoryTransactionLot.ITL_LotNumber END AS LOT
	,CASE WHEN charindex('@@', InventoryTransactionLot.ITL_LotNumber) > 0 THEN substring(InventoryTransactionLot.ITL_LotNumber, charindex('@@', InventoryTransactionLot.ITL_LotNumber) + 2, len(InventoryTransactionLot.ITL_LotNumber)) ELSE '' END AS QRCode
	,
	--Warehouse.WHM_Name,
	InventoryTransactionLot.ITL_Quantity AS 'Quantity'
	,InventoryTransaction.ITR_TransDescription AS 'Remark'
	,ITR_ReferenceID AS 'ReferenceID'
FROM InventoryTransaction(NOLOCK)
INNER JOIN InventoryTransactionLot(NOLOCK)
	ON InventoryTransaction.ITR_ID = InventoryTransactionLot.ITL_ITR_ID
INNER JOIN Warehouse(NOLOCK)
	ON Warehouse.WHM_ID = InventoryTransaction.ITR_WHM_ID
LEFT JOIN  Lafite_DICT DT
	ON DT.DICT_TYPE = 'MS_WarehouseType'
	AND DT.DICT_KEY = Warehouse.WHM_Type			
INNER JOIN Product(NOLOCK)
	ON Product.PMA_ID = InventoryTransaction.ITR_PMA_ID
INNER JOIN DealerMaster(NOLOCK)
	ON DMA_ID = WHM_DMA_ID
WHERE 1 = 1 AND ISNULL(DMA_Taxpayer,'')<>'直销医院'
	--AND CONVERT(NVARCHAR(6), InventoryTransaction.ITR_TransactionDate, 112) = CONVERT(NVARCHAR(6), GETDATE(), 112)
	AND InventoryTransaction.ITR_TransactionDate >= DATEADD(mm, DATEDIFF(mm, 0, getdate())-1, 0)
	


GO


