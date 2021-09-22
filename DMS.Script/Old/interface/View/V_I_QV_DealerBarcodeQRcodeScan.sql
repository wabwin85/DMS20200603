DROP VIEW [interface].[V_I_QV_DealerBarcodeQRcodeScan]
GO


CREATE VIEW [interface].[V_I_QV_DealerBarcodeQRcodeScan]
AS
SELECT dm.DMA_SAP_Code as QRC_SAP_Code
	,QRC_BarCode1
	,QRC_BarCode2
	,QRC_QRCode
	,QRC_UPN
	,QRC_LOT
	,QRC_Remark
	,QRC_RemarkDate
	,QRC_CreateDate
	,QRC_CreateUserName
	,QRC_Status
FROM [interface].[T_I_WC_DealerBarcodeQRcodeScan] wc
INNER JOIN dbo.DealerMaster dm
	ON wc.QRC_DMA_ID=dm.DMA_ID

GO


