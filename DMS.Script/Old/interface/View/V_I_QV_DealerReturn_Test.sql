DROP VIEW [interface].[V_I_QV_DealerReturn_Test]
GO

CREATE VIEW [interface].[V_I_QV_DealerReturn_Test]
AS
SELECT DM.DMA_SAP_Code AS SAPID
	,D.DMA_SAP_Code AS ParentSAPID
	,VD.DivisionCode AS DivisionID
	,IAH.IAH_Inv_Adj_Nbr AS NBR
	,IAH.IAH_ApprovalDate AS ApprovalDate
	,IAH.IAH_CreatedDate AS CreatedDate
	,IAH.IAH_Reason AS Reason
	,IAH.IAH_Status AS Status
	,IAL.IAL_LotQty AS QTY
	,P.PMA_UPN AS UPN
	,CASE 
		WHEN CHARINDEX('@@',isnull(IAL_QRLotNumber,IAL.IAL_LotNumber)) > 0
			THEN SUBSTRING(isnull(IAL_QRLotNumber,IAL.IAL_LotNumber), 1, CHARINDEX('@@', isnull(IAL_QRLotNumber,IAL.IAL_LotNumber)) - 1)
		ELSE isnull(IAL_QRLotNumber,IAL.IAL_LotNumber)
		END AS LOT
	,CASE 
		WHEN CHARINDEX('@@', isnull(IAL_QRLotNumber,IAL.IAL_LotNumber)) > 0
			THEN SUBSTRING(isnull(IAL_QRLotNumber,IAL.IAL_LotNumber), CHARINDEX('@@', isnull(IAL_QRLotNumber,IAL.IAL_LotNumber)) + 2, LEN(isnull(IAL_QRLotNumber,IAL.IAL_LotNumber)))
		ELSE 'NoQR'
		END AS QRCode
	,IAL.IAL_ExpiredDate AS EXPDate
 
FROM InventoryAdjustHeader IAH
INNER JOIN InventoryAdjustDetail IAD ON IAH.IAH_ID = IAD.IAD_IAH_ID
INNER JOIN InventoryAdjustLot IAL ON IAL.IAL_IAD_ID = IAD.IAD_ID
LEFT JOIN DealerMaster DM ON IAH.IAH_DMA_ID = DM.DMA_ID
LEFT JOIN DealerMaster D ON D.DMA_ID = DM.DMA_Parent_DMA_ID
LEFT JOIN Product P ON IAD.IAD_PMA_ID = P.PMA_ID
LEFT JOIN V_DivisionProductLineRelation VD ON IAH.IAH_ProductLine_BUM_ID = VD.ProductLineID
WHERE IAH_Reason IN (
		'Return'
		,'Exchange'		
		)
	AND IAH_Status IN (
		'Accept'
		,'Complete'
		,'EWFApprove',
    'InWorkflow',
    'Submitted'
		)
GO


