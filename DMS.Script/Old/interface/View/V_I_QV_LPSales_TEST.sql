DROP view [interface].[V_I_QV_LPSales_TEST]
GO





CREATE view [interface].[V_I_QV_LPSales_TEST]
as

--SELECT newid() AS ID,UPN,LOT,Expdate,
--       Convert(decimal(18,6),CASE WHEN sum(isnull(Qty,0)) = 0 THEN 0 ELSE sum(isnull(PurchaseAmount,0))/sum(isnull(Qty,0)) END) AS purchasePrice,
--       Convert(decimal(18,6),CASE WHEN sum(isnull(Qty,0)) = 0 THEN 0 ELSE SUM(ISNULL(SellingAmount,0))/sum(isnull(Qty,0)) END) AS SellingPrice,
--       SUM(isnull(Qty,0)) AS Qty,
--       Convert(decimal(18,6),SUM(isnull(SellingAmount,0))) AS SellingAmount,
--       Convert(decimal(18,6),SUM(isnull(PurchaseAmount,0))) AS PurchaseAmount,
--       Transaction_Date,DealerID,Dealer,DealerLevel,Year,Month,Division,Divisionid,Province,ProvinceID,Region,RegionID,ParentDealerID,SAPID,ParentSAPID,Selltype,
--ProductLine,InputTime,NBR,Staus,interfaceUploadDate 
--  FROM [interface].[V_I_QV_LPSales_WithQR]
--GROUP BY UPN,LOT,Expdate,Transaction_Date,DealerID,Dealer,DealerLevel,Year,Month,Division,Divisionid,Province,ProvinceID,Region,RegionID,ParentDealerID,SAPID,ParentSAPID,Selltype,
--ProductLine,InputTime,NBR,Staus,interfaceUploadDate


SELECT ID, UPN, LOT, Expdate, purchasePrice, SellingPrice, Qty, SellingAmount, PurchaseAmount, Transaction_Date, DealerID, Dealer, DealerLevel, [Year], [Month], Division, Divisionid, Province, ProvinceID, Region, RegionID, ParentDealerID, SAPID, ParentSAPID, Selltype, ProductLine, InputTime, NBR, Staus, interfaceUploadDate, NoQRQty,Qty-NoQRqty AS QRQty  FROM archive.V_I_QV_LPSales_DailyBackup







































































GO


