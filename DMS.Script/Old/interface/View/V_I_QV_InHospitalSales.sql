DROP VIEW [interface].[V_I_QV_InHospitalSales]
GO



CREATE VIEW [interface].[V_I_QV_InHospitalSales]
AS
--	SELECT newid() AS ID,DealerID,ParentDealerID,UPN,LOT,ExpDate,Transaction_Date,
--         Convert(decimal(18,6),CASE WHEN sum(isnull(Qty,0)) = 0 THEN 0 ELSE SUM(ISNULL(SellingAmount,0))/sum(isnull(Qty,0)) END) AS SellingPrice,
--         SUM(isnull(Qty,0)) AS Qty,
--         Convert(decimal(18,6),SUM(isnull(SellingAmount,0))) AS SellingAmount,
--         Convert(decimal(18,6),CASE WHEN sum(isnull(Qty,0)) = 0 THEN 0 ELSE sum(isnull(PurchaseAmount,0))/sum(isnull(Qty,0)) END) AS purchasePrice,
--         Convert(decimal(18,6),SUM(isnull(PurchaseAmount,0))) AS PurchaseAmount,
--         DMScode,Hospital,Year,Month,Division,DivisionID,Province,ProvinceID,Region,RegionID,SalesType,InvoiceDate,Invoice,SAPID,SubmitDate,ParentSAPID,SPH_ShipmentNbr,AdjType,AdjReason,AdjAction,InputTime,SPH_UpdateDate,InvoiceFirstDate
--         
--  FROM [interface].[V_I_QV_InHospitalSales_WithQR]
--  GROUP BY DealerID,ParentDealerID,UPN,LOT,ExpDate,Transaction_Date,DMScode,Hospital,Year,Month,Division,DivisionID,Province,ProvinceID,Region,RegionID,SalesType,InvoiceDate,Invoice,SAPID,SubmitDate,ParentSAPID,SPH_ShipmentNbr,AdjType,AdjReason,AdjAction,InputTime,SPH_UpdateDate,InvoiceFirstDate
SELECT ID, DealerID, ParentDealerID, UPN, LOT, ExpDate, Transaction_Date, SellingPrice, Qty, SellingAmount, purchasePrice, PurchaseAmount, DMScode, Hospital, [Year], [Month], Division, DivisionID, Province, ProvinceID, Region, RegionID, SalesType, InvoiceDate, Invoice, SAPID, SubmitDate, ParentSAPID, SPH_ShipmentNbr, AdjType, AdjReason, AdjAction, InputTime, SPH_UpdateDate, InvoiceFirstDate
FROM archive.V_I_QV_InHospitalSales_DailyBackup
WHERE submitdate >= DATEADD(mm, DATEDIFF(mm, 0, getdate()) - 2, 0)


GO


