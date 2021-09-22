DROP view [interface].[V_I_EW_GoodsReturn]
GO

CREATE view [interface].[V_I_EW_GoodsReturn]
as
select a.ReturnNo,
a.ReturnDate,
a.SapCode,
a.DealerName,
a.ParentCode,
a.ParentName,
a.Remark,
a.WarehouseCode,
a.WarehouseName,
a.UPN,
a.Description,
a.Lot,
a.ExpDate,
a.UnitPrice,
a.Qty,
a.UnitPrice*a.Qty as Amount,
a.LastMonthSales,
a.ThisMonthReturned,
a.DistributorLevel ,
a.toSapCode,
a.ToDealerName 
from interface.fn_I_EW_GoodsReturn() a
WHERE EXISTS (SELECT 1 FROM DealerMaster b WHERE b.DMA_ID = a.DMA_ID AND b.DMA_DealerType IN ('LP','T1'))

GO


