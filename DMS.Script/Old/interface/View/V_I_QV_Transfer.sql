DROP VIEW [interface].[V_I_QV_Transfer]
GO






CREATE VIEW [interface].[V_I_QV_Transfer]
AS
--SELECT tab1.*
--	,isnull(tab2.DataSrc, 'DMS') AS QRSrc
--FROM (
--	SELECT t1.TRN_TransferNumber AS TransferNumber
--		,t1.TRN_TransferDate AS TransferDate
--		,t4.DMA_SAP_Code AS SAPID 
--		,FWH.WHM_Code AS FWHCode
--		,TWH.WHM_Code AS TWHCode
--		,t5.PMA_UPN AS UPN
--		,LM.LTM_LotNumber AS Lot
--		,LM.LTM_QrCode AS QRCode
--		,t3.TLT_TransferLotQty AS QTY
--	FROM [Transfer] t1
--		,TransferLine t2
--		,TransferLot t3
--		,DealerMaster t4
--		,product t5
--		,warehouse FWH
--		,warehouse TWH
--		,Lot LT
--		,V_LotMaster LM
--	WHERE t1.TRN_ID = t2.TRL_TRN_ID
--		AND t2.TRL_ID = t3.TLT_TRL_ID
--		AND t1.TRN_FromDealer_DMA_ID = t4.DMA_ID
--		AND t2.TRL_TransferPart_PMA_ID = t5.PMA_ID
--		AND t2.TRL_FromWarehouse_WHM_ID = FWH.WHM_ID
--		AND t2.TRL_ToWarehouse_WHM_ID = TWH.WHM_ID
--		AND isnull(t3.IAL_QRLOT_ID, t3.TLT_LOT_ID) = LT.LOT_ID
--		AND LT.LOT_LTM_ID = LM.LTM_ID
--		AND t1.TRN_Status = 'Complete'
--		AND t1.TRN_Type = 'Transfer'
--		AND t1.TRN_TransferDate > '2016-01-01'
--	) AS tab1
--LEFT JOIN (
--	SELECT QRC_QRCode
--		,isnull(QRC_BarCode2, 'FWRW') AS DataSrc
--	FROM interface.T_I_WC_DealerBarcodeQRcodeScan
--	WHERE QRC_BarCode1 IN ('移库')
--	) tab2 ON (tab1.QRCode = tab2.QRC_QRCode)

SELECT t1.TRN_TransferNumber AS TransferNumber
	,t1.TRN_TransferDate AS TransferDate
	,t4.DMA_SAP_Code AS SAPID
	,FWH.WHM_Code AS FWHCode
	,TWH.WHM_Code AS TWHCode
	,t5.PMA_UPN AS UPN
	,LM.LTM_LotNumber AS Lot
	,LM.LTM_QrCode AS QRCode
	,t3.TLT_TransferLotQty AS QTY
	,CASE 
		WHEN dbq.QRC_QRCode IS NOT NULL
			THEN isnull(dbq.QRC_BarCode2, 'FWRW')
		ELSE 'DMS'
		END AS QRSrc
FROM [Transfer] t1
INNER JOIN TransferLine t2 ON t1.TRN_ID = t2.TRL_TRN_ID
INNER JOIN TransferLot t3 ON t2.TRL_ID = t3.TLT_TRL_ID
INNER JOIN DealerMaster t4 ON t1.TRN_FromDealer_DMA_ID = t4.DMA_ID
INNER JOIN product t5 ON t2.TRL_TransferPart_PMA_ID = t5.PMA_ID
INNER JOIN warehouse FWH ON t2.TRL_FromWarehouse_WHM_ID = FWH.WHM_ID
INNER JOIN warehouse TWH ON t2.TRL_ToWarehouse_WHM_ID = TWH.WHM_ID
INNER JOIN Lot LT ON isnull(t3.IAL_QRLOT_ID, t3.TLT_LOT_ID) = LT.LOT_ID
INNER JOIN V_LotMaster LM ON LT.LOT_LTM_ID = LM.LTM_ID
LEFT JOIN interface.T_I_WC_DealerBarcodeQRcodeScan dbq ON LM.LTM_QrCode = dbq.QRC_QRCode
	AND dbq.QRC_BarCode1 IN ('移库')
WHERE t1.TRN_Status = 'Complete'
	AND t1.TRN_Type = 'Transfer'
	AND t1.TRN_TransferDate > '2016-01-01'
	AND ISNULL(t4.DMA_Taxpayer,'')<>'直销医院'



GO


