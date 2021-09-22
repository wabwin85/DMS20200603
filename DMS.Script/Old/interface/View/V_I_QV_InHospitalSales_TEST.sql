
DROP VIEW [interface].[V_I_QV_InHospitalSales_TEST]
GO




CREATE VIEW [interface].[V_I_QV_InHospitalSales_TEST]
AS
SELECT ID, DealerID, ParentDealerID, UPN, LOT, ExpDate, Transaction_Date, SellingPrice, Qty, SellingAmount, purchasePrice, PurchaseAmount, DMScode, Hospital, [Year], [Month], Division, DivisionID, Province, ProvinceID, Region, RegionID, SalesType, InvoiceDate, Invoice, SAPID, SubmitDate, ParentSAPID, SPH_ShipmentNbr, AdjType, AdjReason, AdjAction, InputTime, SPH_UpdateDate, InvoiceFirstDate, 
       NoQRQty,Qty-NoQRqty AS QRQty 
FROM archive.V_I_QV_InHospitalSales_DailyBackup
WHERE submitdate >= DATEADD(mm, DATEDIFF(mm, 0, getdate()) - 2, 0)



GO


