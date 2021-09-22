DROP VIEW [interface].[V_I_QV_LotMaster_WithQR]
GO



CREATE VIEW [interface].[V_I_QV_LotMaster_WithQR]
AS
SELECT b.PMA_UPN AS UPN
	,CASE WHEN charindex('@@', LTM_LotNumber) > 0 THEN substring(LTM_LotNumber, 1, charindex('@@', LTM_LotNumber) - 1) ELSE LTM_LotNumber END AS LOT
	,CASE WHEN charindex('@@', LTM_LotNumber) > 0 THEN substring(LTM_LotNumber, charindex('@@', LTM_LotNumber) + 2, len(LTM_LotNumber)) ELSE '' END AS QRCode
	,convert(DATE, a.LTM_ExpiredDate) AS ExpDate
	,LTM_Type AS DOM
	,a.LTM_CreatedDate AS CreateDT
	,DataSrc AS DataSrc
	,CASE DataSrc WHEN 'JY' THEN N'JY数据' WHEN 'FWRW' THEN N'服务入微' ELSE N'手工录入' END AS QRSrc
FROM LotMaster a(NOLOCK)
INNER JOIN Product b(NOLOCK)
	ON a.LTM_Product_PMA_ID = b.pma_id
LEFT JOIN (
	SELECT QRC_QRCode
		,max(isnull(QRC_BarCode2, 'FWRW')) AS DataSrc
	FROM interface.T_I_WC_DealerBarcodeQRcodeScan(NOLOCK)
	WHERE QRC_BarCode1 IN (N'上报销量')
	GROUP BY QRC_QRCode
	) DataSrc
	ON DataSrc.QRC_QRCode = substring(LTM_LotNumber, charindex('@@', LTM_LotNumber) + 2, len(LTM_LotNumber)) AND LTM_LotNumber LIKE '%@@%'
WHERE LTM_CreatedDate>=DATEADD(YEAR,DATEDIFF(YEAR,0,GETDATE())-1, 0)



GO


