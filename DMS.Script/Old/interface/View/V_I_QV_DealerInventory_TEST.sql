DROP VIEW [interface].[V_I_QV_DealerInventory_TEST]
GO



CREATE VIEW [interface].[V_I_QV_DealerInventory_TEST]
AS
SELECT newid() AS ID
	,DealerID
	,ParentDealerID
	,Dealer
	,WHM_Code
	,WHM_Type
	,UPN
	,LOT
	,EXPDate
	,sum(QTY) AS Qty
	,Convert(DECIMAL(18, 4), CASE WHEN sum(QTY) = 0 THEN 0 ELSE sum(PurchaseAmount) / sum(QTY) END) AS PurchasePrice
	,sum(PurchaseAmount) AS PurchaseAmount
	,InvDate
	,Month
	,Year
	,Division
	,DivisionID
	,Province
	,ProvinceID
	,Region
	,RegionID
	,InventoryStatus
	,SAPID
	,ParentSAPID
	,InventoryTypeID
	,ExpYear
	,ExpMonth
	,Aging
	,FormNbr,
	convert(decimal(18,6),sum(case when QRCode = 'NoQR' then Qty else 0 end)) AS NoQRQty,
	convert(decimal(18,6),sum(case when QRCode <> 'NoQR' then Qty else 0 end)) AS QRQty
FROM interface.T_I_QV_DealerInventory_MonthlyBackup WITH(NOLOCK)
WHERE bakdate = convert(NVARCHAR(8), getdate(), 112)
	AND Year=Year(GETDATE())
	AND Month=Month(GETDATE())
GROUP BY DealerID
	,ParentDealerID
	,Dealer
	,WHM_Code
	,WHM_Type
	,UPN
	,LOT
	,EXPDate
	,InvDate
	,Month
	,Year
	,Division
	,DivisionID
	,Province
	,ProvinceID
	,Region
	,RegionID
	,InventoryStatus
	,SAPID
	,ParentSAPID
	,InventoryTypeID
	,ExpYear
	,ExpMonth
	,Aging
	,FormNbr

	--SELECT newid() AS ID,DealerID,ParentDealerID,Dealer,WHM_Code,WHM_Type,UPN,LOT,EXPDate,sum(QTY) AS Qty,
	--       Convert(decimal(18,4),CASE WHEN sum(QTY) =0 then 0 else sum(PurchaseAmount)/sum(QTY) end ) AS PurchasePrice,
	--       sum(PurchaseAmount) AS PurchaseAmount,InvDate,Month,Year,Division,DivisionID,Province,ProvinceID,Region,RegionID,InventoryStatus,SAPID,ParentSAPID,InventoryTypeID,ExpYear,ExpMonth,Aging,FormNbr
	--  FROM [interface].[V_I_QV_DealerInventory_WithQR]
	-- GROUP BY DealerID,ParentDealerID,Dealer,WHM_Code,WHM_Type,UPN,LOT,EXPDate,InvDate,Month,Year,Division,DivisionID,Province,ProvinceID,Region,RegionID,InventoryStatus,SAPID,ParentSAPID,InventoryTypeID,ExpYear,ExpMonth,Aging,FormNbr


GO


