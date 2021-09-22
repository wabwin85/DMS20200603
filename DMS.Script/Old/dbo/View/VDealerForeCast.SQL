DROP view [dbo].[VDealerForeCast]
GO



/*==============================================================*/
/* View: VDealerForeCast                                        */
/*==============================================================*/
create view [dbo].[VDealerForeCast] as
select DFC_Dealer_DMA_ID,DFC_ProductLine_BUM_ID,DFC_Year,
sum(case when DFC_Quarter='Q1' then DFC_Amount else 0 end) as DFC_Amount_1,
sum(case when DFC_Quarter='Q2' then DFC_Amount else 0 end) as DFC_Amount_2,
sum(case when DFC_Quarter='Q3' then DFC_Amount else 0 end) as DFC_Amount_3,
sum(case when DFC_Quarter='Q4' then DFC_Amount else 0 end) as DFC_Amount_4
from DealerForeCast
group by DFC_Dealer_DMA_ID,DFC_ProductLine_BUM_ID,DFC_Year

GO


