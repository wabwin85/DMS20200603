DROP VIEW [interface].[V_I_EW_CRMDataForComplain]
GO


CREATE VIEW [interface].[V_I_EW_CRMDataForComplain]
AS
--SELECT WHM_Name,WHM_ID,whm_type,DMA_CODE,DMA_ID,DMA_ChineseName,PMA_ID,PMA_UPN,LTM_LotNumber,ConvertFactor,FactorNumber,LTM_ExpiredDate,sum(isnull(LOT_OnHandQty,0)) AS LOT_OnHandQty
--FROM [interface].[V_I_EW_CRMDataForComplain_WithQR]
--GROUP BY WHM_Name,WHM_ID,whm_type,DMA_CODE,DMA_ID,DMA_ChineseName,PMA_ID,PMA_UPN,LTM_LotNumber,ConvertFactor,FactorNumber,LTM_ExpiredDate
SELECT WHM_Name
	,WHM_ID
	,whm_type
	,dma_sap_code AS DMA_CODE
	,DMA_ID
	,DMA_ChineseName
	,PMA_ID
	,PMA_UPN
	,LTM_LotNumber
	,LOT_OnHandQty
	,Convert(NVARCHAR(10), isnull([Product].PMA_ConvertFactor, 0)) AS ConvertFactor
	,Convert(NVARCHAR(10), CASE WHEN isnull([Product].PMA_ConvertFactor, 0) = 0 THEN 1 ELSE Convert(DECIMAL(18, 2), 1 / isnull([Product].PMA_ConvertFactor, 0)) END) AS FactorNumber
	,LTM_ExpiredDate
FROM DealerMaster(NOLOCK)
	,Warehouse(NOLOCK)
	,Inventory(NOLOCK)
	,Product(NOLOCK)
	,Lot(NOLOCK)
	,LotMaster(NOLOCK)
	,CFN(NOLOCK)
	,View_ProductLine(NOLOCK)
WHERE DMA_ID = WHM_DMA_ID
	AND WHM_ID = INV_WHM_ID
	AND INV_PMA_ID = PMA_ID
	AND INV_ID = LOT_INV_ID
	AND LOT_LTM_ID = LTM_ID
	AND LOT_OnHandQty <> 0
	AND CFN_ID = PMA_CFN_ID
	AND CFN_ProductLine_BUM_ID = View_ProductLine.Id
	AND WHM_Type <> 'SystemHold'
	AND CFN_ProductLine_BUM_ID = '97a4e135-74c7-4802-af23-9d6d00fcb2cc'

UNION ALL

SELECT DISTINCT '销售到医院' AS WHM_Name
	,'00000000-0000-0000-0000-000000000000' AS WHM_ID
	,'Hospital' AS whm_type
	,dma_sap_code AS DMA_CODE
	,DMA_ID
	,DMA_ChineseName
	,PMA_ID
	,PMA_UPN
	,LTM_LotNumber
	,LOT_OnHandQty
	,Convert(NVARCHAR(10), isnull([Product].PMA_ConvertFactor, 0)) AS ConvertFactor
	,Convert(NVARCHAR(10), CASE WHEN isnull([Product].PMA_ConvertFactor, 0) = 0 THEN 1 ELSE Convert(DECIMAL(18, 2), 1 / isnull([Product].PMA_ConvertFactor, 0)) END) AS FactorNumber
	,LTM_ExpiredDate
FROM ShipmentHeader(NOLOCK)
INNER JOIN ShipmentLine(NOLOCK)
	ON SPH_ID = SPL_SPH_ID
INNER JOIN ShipmentLot(NOLOCK)
	ON SPL_ID = SLT_SPL_ID
INNER JOIN Lot(NOLOCK)
	ON LOT_ID = ISNULL(SLT_QRLOT_ID, SLT_LOT_ID) --SLT_LOT_ID
INNER JOIN LotMaster(NOLOCK)
	ON LTM_ID = LOT_LTM_ID
INNER JOIN Product(NOLOCK)
	ON PMA_ID = SPL_Shipment_PMA_ID
INNER JOIN CFN(NOLOCK)
	ON PMA_CFN_ID = CFN_ID
INNER JOIN DealerMaster(NOLOCK)
	ON SPH_Dealer_DMA_ID = DMA_ID
INNER JOIN View_ProductLine(NOLOCK)
	ON CFN_ProductLine_BUM_ID = View_ProductLine.Id
WHERE CFN_ProductLine_BUM_ID = '97a4e135-74c7-4802-af23-9d6d00fcb2cc'

GO


