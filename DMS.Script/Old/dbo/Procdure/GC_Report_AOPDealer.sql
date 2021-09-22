DROP PROCEDURE [dbo].[GC_Report_AOPDealer]
GO


CREATE PROCEDURE [dbo].[GC_Report_AOPDealer]
WITH 
EXECUTE AS CALLER
AS
declare @SqlString nvarchar(2000)
SET NOCOUNT ON

BEGIN TRY
	
BEGIN TRAN

/*清空表*/
set @SqlString = 'truncate table ReportAOPDealer'
exec sp_executesql @SqlString

/*取月AOP指标*/
insert into ReportAOPDealer(RAD_DMA_ID,RAD_BUM_ID,RAD_Period,RAD_Year,RAD_HalfYear,RAD_Quarter,RAD_Month,
RAD_MAOP,RAD_QAOP,RAD_HYAOP,RAD_YAOP,RAD_MAmount,RAD_QAmount,RAD_HYAmount,RAD_YAmount)
SELECT T.Dealer,T.ProductLine,'Q',T.[Year],T.HYear,T.Period,T.AOPD_Month,SUM(T.Amount),0,0,0,0,0,0,0 FROM
(SELECT AOPD_Dealer_DMA_ID AS Dealer, AOPD_ProductLine_BUM_ID AS ProductLine, 
AOPD_Year AS [Year], 
(CASE WHEN aopd_month IN ('01','02','03','04','05','06') THEN 'H1'
WHEN aopd_month IN ('07','08','09','10','11','12') THEN 'H2' END) AS HYear,
(CASE WHEN aopd_month IN ('01','02','03') THEN 'Q1'
WHEN aopd_month IN ('04','05','06') THEN 'Q2'
WHEN aopd_month IN ('07','08','09') THEN 'Q3'
WHEN aopd_month IN ('10','11','12') THEN 'Q4'
END) AS Period,AOPD_Month,AOPD_Amount AS Amount FROM AOPDealer) AS T
GROUP BY T.Dealer,T.ProductLine,T.[Year],T.HYear,T.Period,T.AOPD_Month
/*更新季AOP指标*/
update ReportAOPDealer set RAD_QAOP = 
(SELECT SUM(rpt.RAD_MAOP)
from ReportAOPDealer rpt where ReportAOPDealer.RAD_DMA_ID = rpt.RAD_DMA_ID
and ReportAOPDealer.RAD_BUM_ID = rpt.RAD_BUM_ID
and ReportAOPDealer.RAD_Quarter = rpt.RAD_Quarter
and ReportAOPDealer.RAD_Year = rpt.RAD_Year)
/*更新半年AOP指标*/
update ReportAOPDealer set RAD_HYAOP = 
(SELECT SUM(rpt.RAD_MAOP)
from ReportAOPDealer rpt where ReportAOPDealer.RAD_DMA_ID = rpt.RAD_DMA_ID
and ReportAOPDealer.RAD_BUM_ID = rpt.RAD_BUM_ID
and ReportAOPDealer.RAD_HalfYear = rpt.RAD_HalfYear
and ReportAOPDealer.RAD_Year = rpt.RAD_Year)
/*更新年AOP指标*/
update ReportAOPDealer set RAD_YAOP = 
(SELECT SUM(rpt.RAD_MAOP)
from ReportAOPDealer rpt where ReportAOPDealer.RAD_DMA_ID = rpt.RAD_DMA_ID
and ReportAOPDealer.RAD_BUM_ID = rpt.RAD_BUM_ID
and ReportAOPDealer.RAD_Year = rpt.RAD_Year)

/*BUY_IN金额*/
update ReportAOPDealer set RAD_MAmount = tab.ReachAmount
from
(select PRH_Dealer_DMA_ID,PRH_ProductLine_BUM_ID,[Year],Period,sum(tab.Amount) as ReachAmount  from (
select distinct  po.PRH_ID,  po.PRH_Dealer_DMA_ID,po.PRH_ProductLine_BUM_ID,
cop.COP_Year AS [Year],cop.COP_Period AS Period,
por.POR_ReceiptQty*dbo.fn_GetPriceForAOPDealer(PRH_Dealer_DMA_ID,CFN_ID,po.PRH_PurchaseOrderNbr) as Amount
 from POReceiptHeader po
inner join POReceipt por on por.POR_PRH_ID = po.PRH_ID
inner join Product p on por.POR_SAP_PMA_ID = p.PMA_ID
inner join CFN on p.PMA_CFN_ID = CFN.CFN_ID
inner join COP cop on CONVERT(varchar(100), po.PRH_SAPShipmentDate, 112) BETWEEN CONVERT(varchar(100), cop.COP_StartDate, 112) AND CONVERT(varchar(100), cop.COP_EndDate, 112) AND cop.COP_Type = 'M'
where po.PRH_Type='PurchaseOrder' 
) tab 
group by PRH_Dealer_DMA_ID,PRH_ProductLine_BUM_ID,[Year],Period) tab
where ReportAOPDealer.RAD_DMA_ID = tab.PRH_Dealer_DMA_ID
and ReportAOPDealer.RAD_Year = tab.[Year]
and ReportAOPDealer.RAD_BUM_ID = tab.PRH_ProductLine_BUM_ID
and ReportAOPDealer.RAD_Month = tab.Period


/*达成金额中扣除退货金额*/
update ReportAOPDealer set RAD_MAmount = RAD_MAmount-tab.ReturnAmount
from
(select IAH_DMA_ID,IAH_ProductLine_BUM_ID,[Year],Period,sum(tab.Amount) as ReturnAmount  from (
select IAH_DMA_ID,IAH_ProductLine_BUM_ID, cop.COP_Year AS [Year],cop.COP_Period AS Period,
ial.IAL_LotQty*dbo.fn_GetPriceForAOPDealer(PRH_Dealer_DMA_ID,CFN_ID,prh.PRH_PurchaseOrderNbr) as Amount
from InventoryAdjustHeader iah
inner join InventoryAdjustDetail iad on iad.IAD_IAH_ID = iah.IAH_ID
inner join InventoryAdjustLot ial on ial.IAL_IAD_ID = iad.IAD_ID
inner join Lot l on  ial.IAL_LOT_ID = l.LOT_ID
inner join LotMaster ltm on l.LOT_LTM_ID = ltm.LTM_ID
inner join POReceiptHeader prh on ltm.LTM_RelationID = prh.PRH_ID
inner join POReceipt por on por.POR_PRH_ID = prh.PRH_ID
inner join Product p on por.POR_SAP_PMA_ID = p.PMA_ID
inner join CFN on p.PMA_CFN_ID = CFN.CFN_ID
inner join COP cop on CONVERT(varchar(100), iah.IAH_ApprovalDate, 112) 
BETWEEN CONVERT(varchar(100), cop.COP_StartDate, 112) 
AND CONVERT(varchar(100), cop.COP_EndDate, 112) AND cop.COP_Type = 'M'
where iah.IAH_Reason = 'Return'
and iah.IAH_Status = 'Accept'
and prh.PRH_Type='PurchaseOrder' 
) tab 
group by IAH_DMA_ID,IAH_ProductLine_BUM_ID,[Year],Period) tab
where ReportAOPDealer.RAD_DMA_ID = tab.IAH_DMA_ID
and ReportAOPDealer.RAD_Year = tab.[Year]
and ReportAOPDealer.RAD_BUM_ID = tab.IAH_ProductLine_BUM_ID
and ReportAOPDealer.RAD_Month = tab.Period

/*更新季达成*/
update ReportAOPDealer set RAD_QAmount = 
(SELECT SUM(rpt.RAD_MAmount)
from ReportAOPDealer rpt where ReportAOPDealer.RAD_DMA_ID = rpt.RAD_DMA_ID
and ReportAOPDealer.RAD_BUM_ID = rpt.RAD_BUM_ID
and ReportAOPDealer.RAD_Quarter = rpt.RAD_Quarter
and ReportAOPDealer.RAD_Year = rpt.RAD_Year)

/*更新半年达成*/
update ReportAOPDealer set RAD_HYAmount = 
(SELECT SUM(rpt.RAD_MAmount)
from ReportAOPDealer rpt where ReportAOPDealer.RAD_DMA_ID = rpt.RAD_DMA_ID
and ReportAOPDealer.RAD_BUM_ID = rpt.RAD_BUM_ID
and ReportAOPDealer.RAD_HalfYear = rpt.RAD_HalfYear
and ReportAOPDealer.RAD_Year = rpt.RAD_Year)

/*更新年达成*/
update ReportAOPDealer set RAD_YAmount = 
(SELECT SUM(rpt.RAD_MAmount)
from ReportAOPDealer rpt where ReportAOPDealer.RAD_DMA_ID = rpt.RAD_DMA_ID
and ReportAOPDealer.RAD_BUM_ID = rpt.RAD_BUM_ID
and ReportAOPDealer.RAD_Year = rpt.RAD_Year)

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    return -1
    
END CATCH

GO


