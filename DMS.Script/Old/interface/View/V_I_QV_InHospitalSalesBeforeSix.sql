DROP VIEW [interface].[V_I_QV_InHospitalSalesBeforeSix]
GO

CREATE VIEW [interface].[V_I_QV_InHospitalSalesBeforeSix]
AS
SELECT newid() AS ID
	,DealerID
	,ParentDealerID
	,UPN
	,LOT
	,ExpDate
	,Transaction_Date
	,Convert(DECIMAL(18, 6), CASE 
			WHEN sum(isnull(Qty, 0)) = 0
				THEN 0
			ELSE SUM(ISNULL(SellingAmount, 0)) / sum(isnull(Qty, 0))
			END) AS SellingPrice
	,SUM(isnull(Qty, 0)) AS Qty
	,Convert(DECIMAL(18, 6), SUM(isnull(SellingAmount, 0))) AS SellingAmount
	,Convert(DECIMAL(18, 6), CASE 
			WHEN sum(isnull(Qty, 0)) = 0
				THEN 0
			ELSE sum(isnull(PurchaseAmount, 0)) / sum(isnull(Qty, 0))
			END) AS purchasePrice
	,Convert(DECIMAL(18, 6), SUM(isnull(PurchaseAmount, 0))) AS PurchaseAmount
	,DMScode
	,Hospital
	,Year
	,Month
	,Division
	,DivisionID
	,Province
	,ProvinceID
	,Region
	,RegionID
	,SalesType
	,InvoiceDate
	,Invoice
	,SAPID
	,SubmitDate
	,ParentSAPID
	,SPH_ShipmentNbr
	,InventoryTypeID
	,SPH_Status
FROM [interface].[V_I_QV_InHospitalSalesBeforeSix_WithQR]
WHERE SubmitDate >= DATEADD(mm, DATEDIFF(mm, 0, getdate()), 0)
  and DATEDIFF(m,Transaction_Date,SubmitDate)=1
GROUP BY DealerID
	,ParentDealerID
	,UPN
	,LOT
	,ExpDate
	,Transaction_Date
	,DMScode
	,Hospital
	,Year
	,Month
	,Division
	,DivisionID
	,Province
	,ProvinceID
	,Region
	,RegionID
	,SalesType
	,InvoiceDate
	,Invoice
	,SAPID
	,SubmitDate
	,ParentSAPID
	,SPH_ShipmentNbr
	,InventoryTypeID
	,SPH_Status
GO


