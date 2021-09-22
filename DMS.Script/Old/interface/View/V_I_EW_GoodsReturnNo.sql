DROP view [interface].[V_I_EW_GoodsReturnNo]
GO

create view [interface].[V_I_EW_GoodsReturnNo]
as
select distinct a.ReturnNo
from interface.fn_I_EW_GoodsReturn() a
WHERE EXISTS (SELECT 1 FROM DealerMaster b WHERE b.DMA_ID = a.DMA_ID AND b.DMA_DealerType IN ('LP','T1'))

GO


