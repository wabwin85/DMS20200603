DROP VIEW [interface].[V_I_QV_InHospitalSales_WithQR_Optimize]
GO




CREATE VIEW [interface].[V_I_QV_InHospitalSales_WithQR_Optimize]
AS

--Update by Zengj3 on 2017-03-19
SELECT ID = SLT_ID
	,TransactionDate = SPH_ShipmentDate
	,SPH_ShipmentNbr AS ShipmentNumber
	,DealerCode = d.DMA_SAP_Code
	,HospitalCode = HOS_Key_Account
	,dv.DivisionCode
	,UPN = PMA_UPN
	,CASE WHEN charindex('@@', LTM_LotNumber) > 0 THEN substring(LTM_LotNumber, 1, charindex('@@', LTM_LotNumber) - 1) ELSE LTM_LotNumber END AS LOT
	,CASE WHEN charindex('@@', LTM_LotNumber) > 0 THEN substring(LTM_LotNumber, charindex('@@', LTM_LotNumber) + 2, len(LTM_LotNumber)) ELSE '' END AS QRCode
	,Qty = SLT_LotShippedQty
	,SellingPrice = SLT_UnitPrice
	,ExpDate = LTM_ExpiredDate
	,SalesType = SPH_Type
	,SubmitDate = SPH_SubmitDate
	,SPH_UpdateDate AS UpdateDate
	,SPH_InvoiceDate AS InvoiceDate
	,SPH_InvoiceFirstDate AS InvoiceFirstDate
	,REPLACE(SPH_InvoiceNo, '.', ';') AS InvoiceNumber
	,AdjType = CAST(ShipmentLot.AdjType AS NVARCHAR(500))
	,AdjReason = CAST(CASE WHEN ShipmentLot.AdjType IS NULL THEN NULL ELSE CASE WHEN ShipmentLot.AdjReason IS NULL THEN ShipmentHeader.SPH_NoteForPumpSerialNbr ELSE ShipmentLot.AdjReason END END AS NVARCHAR(500))
	,AdjAction = CASE WHEN ShipmentLot.AdjType IS NULL THEN NULL ELSE 'Add' END
	,InputTime = CASE WHEN ShipmentLot.AdjType IS NULL THEN NULL ELSE CASE WHEN ShipmentLot.InputTime IS NULL THEN ShipmentHeader.SPH_SubmitDate ELSE ShipmentLot.InputTime END END
	,OperType.OperType
	,CAST(NULL AS NVARCHAR(100))AS DataSrc
	,CASE WHEN OperType.OperType='Generate' THEN N'批量上传' ELSE N'手工录入' END AS QRSrc
FROM ShipmentHeader(NOLOCK)
INNER JOIN ShipmentLine(NOLOCK)
	ON ShipmentHeader.SPH_ID = ShipmentLine.SPL_SPH_ID
INNER JOIN ShipmentLot(NOLOCK) ShipmentLot
	ON ShipmentLine.SPL_ID = ShipmentLot.SLT_SPL_ID
INNER JOIN Product(NOLOCK)
	ON ShipmentLine.SPL_Shipment_PMA_ID = Product.PMA_ID
INNER JOIN Lot(NOLOCK)
	ON ISNULL(ShipmentLot.SLT_QRLOT_ID, ShipmentLot.SLT_LOT_ID) = Lot.LOT_ID
INNER JOIN LotMaster(NOLOCK)
	ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
INNER JOIN DealerMaster d(NOLOCK)
	ON SPH_Dealer_DMA_ID = d.DMA_ID
INNER JOIN Hospital(NOLOCK)
	ON HOS_ID = SPH_Hospital_HOS_ID
LEFT JOIN V_DivisionProductLineRelation(NOLOCK) dv
	ON SPH_ProductLine_BUM_ID = dv.ProductLineID
LEFT JOIN (
	SELECT POL_POH_ID AS SPH_ID
		,max(POL_OperType) AS OperType
	FROM PurchaseOrderLog(NOLOCK)
	WHERE POL_OperType IN ('Generate', 'CreateShipment', 'Submit')
	GROUP BY POL_POH_ID
	) OperType
	ON (ShipmentHeader.SPH_ID = OperType.SPH_ID)
WHERE SPH_Status = 'Complete' AND SPH_SubmitDate>=DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())-1, 0)



--Comment by Zengj3 on 2017-03-19
/*

SELECT 
	ID = SLT_ID
	,DealerID = SPH_Dealer_DMA_ID
	,ParentDealerID = d.DMA_Parent_DMA_ID
	,UPN = PMA_UPN
	--,V_LotMaster.LTM_LotNumber AS LOT
	--,V_LotMaster.LTM_QrCode AS QRCode
	--,LOT=LTM_LotNumber
	,CASE 
		WHEN charindex('@@', LTM_LotNumber) > 0
			THEN substring(LTM_LotNumber, 1, charindex('@@', LTM_LotNumber) - 1)
		ELSE LTM_LotNumber
		END AS LOT
	,CASE 
		WHEN charindex('@@', LTM_LotNumber) > 0
			THEN substring(LTM_LotNumber, charindex('@@', LTM_LotNumber) + 2, len(LTM_LotNumber))
		ELSE ''
		END AS QRCode
	,ExpDate = LTM_ExpiredDate
	,Transaction_Date = SPH_ShipmentDate
	,SellingPrice = SLT_UnitPrice
	,Qty = SLT_LotShippedQty
	,SellingAmount = SLT_UnitPrice * SLT_LotShippedQty
	,purchasePrice = interface.fn_GetPurchasePrice(CFN.CFN_ID, SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type) / 1.17
	,PurchaseAmount = interface.fn_GetPurchasePrice(CFN.CFN_ID, SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type) / 1.17 * SLT_LotShippedQty
	--,purchasePrice=ISNULL(interface.QV_GetHospitalPrice(DMA_SAP_Code,PMA_UPN,SPH_ShipmentDate),
	--interface.fn_GetPurchasePrice(CFN.CFN_ID,SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type)/1.17 )
	--,PurchaseAmount=ISNULL(interface.QV_GetHospitalPrice(DMA_SAP_Code,PMA_UPN,SPH_ShipmentDate),
	--interface.fn_GetPurchasePrice(CFN.CFN_ID,SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type)/1.17 )*SLT_LotShippedQty
	,DMScode = HOS_Key_Account
	,Hospital = HOS_HospitalName
	,DATEPART(YEAR, ShipmentHeader.SPH_ShipmentDate) AS [Year]
	,DATEPART(MONTH, ShipmentHeader.SPH_ShipmentDate) AS [Month]
	,V_DivisionProductLineRelation.DivisionName AS Division--Division
	,V_DivisionProductLineRelation.DivisionCode AS DivisionID -- b.DivisionID
	,Province = HOS_Province
	,ProvinceID = TER_ID
	,Region = ''
	,RegionID = ''
	,SalesType = SPH_Type
	,SPH_InvoiceDate AS InvoiceDate
	,REPLACE(SPH_InvoiceNo,'.',';') AS Invoice
	,SAPID = DMA_SAP_Code
	,SubmitDate = SPH_SubmitDate
	,ParentSAPID = (
		SELECT DMA_SAP_Code
		FROM DealerMaster b(NOLOCK)
		WHERE b.DMA_ID = d.DMA_Parent_DMA_ID
		)
	,SPH_ShipmentNbr
	,AdjType = CAST(ShipmentLot.AdjType AS NVARCHAR(500))
	,AdjReason =CAST( CASE 
		WHEN ShipmentLot.AdjType IS NULL
			THEN NULL
		ELSE CASE 
				WHEN ShipmentLot.AdjReason IS NULL
					THEN ShipmentHeader.SPH_NoteForPumpSerialNbr
				ELSE ShipmentLot.AdjReason
				END
		END AS NVARCHAR(500))
	,AdjAction =  CASE 
		WHEN ShipmentLot.AdjType IS NULL
			THEN NULL
		ELSE 'Add'--ShipmentLot.AdjAction
		END
	,InputTime = CASE 
		WHEN ShipmentLot.AdjType IS NULL
			THEN NULL
		ELSE CASE 
				WHEN ShipmentLot.InputTime IS NULL
					THEN ShipmentHeader.SPH_SubmitDate
				ELSE ShipmentLot.InputTime
				END
		END
	,SPH_UpdateDate
	,SPH_InvoiceFirstDate AS InvoiceFirstDate
	,OperType.OperType
	--,CAST(DataSrc.DataSrc AS NVARCHAR(50)) DataSrc
	--,CAST(CASE 
	--	WHEN OperType = 'Submit'
	--		THEN CASE 
	--				WHEN DataSrc = 'JY'
	--					THEN 'JY数据'
	--				WHEN DataSrc = 'FWRW'
	--					THEN '服务入微'
	--				ELSE '手工录入'
	--				END
	--	WHEN OperType = 'Generate'
	--		THEN '批量上传'
	--	WHEN OperType = 'CreateShipment'
	--		THEN CASE 
	--				WHEN DataSrc = 'JY'
	--					THEN 'JY数据'
	--				ELSE '服务入微'
	--				END
	--	ELSE '手工录入'
	--	END AS NVARCHAR(50)) AS QRSrc
--,HOS_City
FROM ShipmentHeader(NOLOCK)
INNER JOIN ShipmentLine(NOLOCK) ON ShipmentHeader.SPH_ID = ShipmentLine.SPL_SPH_ID
INNER JOIN ShipmentLot(NOLOCK) ShipmentLot ON ShipmentLine.SPL_ID = ShipmentLot.SLT_SPL_ID
INNER JOIN Product(NOLOCK) ON ShipmentLine.SPL_Shipment_PMA_ID = Product.PMA_ID
INNER JOIN CFN(NOLOCK) ON Product.PMA_CFN_ID = CFN.CFN_ID
INNER JOIN Lot(NOLOCK) ON ISNULL(ShipmentLot.SLT_QRLOT_ID, ShipmentLot.SLT_LOT_ID) = Lot.LOT_ID
INNER JOIN LotMaster(NOLOCK) ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
INNER JOIN DealerMaster d(NOLOCK) ON SPH_Dealer_DMA_ID = d.DMA_ID
INNER JOIN Hospital(NOLOCK) ON HOS_ID = SPH_Hospital_HOS_ID
INNER JOIN V_DivisionProductLineRelation(nolock) ON CFN.CFN_ProductLine_BUM_ID = V_DivisionProductLineRelation.ProductLineID
--INNER JOIN interface.T_I_CR_Product b(NOLOCK) ON b.UPN = PMA_UPN
--LEFT JOIN interface.T_I_CR_Division c(NOLOCK) ON c.DivisionID = b.DivisionID
LEFT JOIN Territory a(NOLOCK) ON HOS_Province = a.TER_Description AND a.TER_Type = 'Province'
LEFT JOIN Interface.Stage_V_InHospitalSalesOperType OperType ON (ShipmentHeader.SPH_ID = OperType.SPH_ID)
--LEFT JOIN (
--	SELECT  QRC_QRCode
--		,max(isnull(QRC_BarCode2, 'FWRW')) AS DataSrc
--	FROM interface.T_I_WC_DealerBarcodeQRcodeScan(nolock)
--	WHERE QRC_BarCode1 IN ('上报销量')
--	group by QRC_QRCode
--	) DataSrc ON (
--		DataSrc.QRC_QRCode = CASE 
--			WHEN charindex('@@', LTM_LotNumber) > 0
--				THEN substring(LTM_LotNumber, charindex('@@', LTM_LotNumber) + 2, len(LTM_LotNumber))
--			ELSE ''
--			END
--		)
WHERE SPH_Status = 'Complete'
--and SPH_SubmitDate>'2015-07-01'
	--SPH_Status IN ('Complete')
	--,'Reversed')
	--AND SPH_SubmitDate >= DATEADD(mm, DATEDIFF(mm, 0, getdate())-2, 0)


*/






GO


