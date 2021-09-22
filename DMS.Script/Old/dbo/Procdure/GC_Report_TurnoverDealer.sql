DROP Procedure [dbo].[GC_Report_TurnoverDealer]
GO


create Procedure [dbo].[GC_Report_TurnoverDealer]
AS
BEGIN

	SET NOCOUNT ON;
  DECLARE @minMonth nvarchar(10);
  DECLARE @maxMonth nvarchar(10);
  DECLARE @year nvarchar(10);
  DECLARE @start datetime;
  DECLARE @end datetime;
  
/*清空本年度历史记录*/
select @year = convert(varchar(4),getdate(),112)

DELETE FROM ReportTurnoverDealer WHERE RTD_Year = @year;

/*年度销售金额*/
insert into ReportTurnoverDealer (RTD_ID,RTD_Year,RTD_DMA_ID,RTD_BUM_ID,RTD_SalesAmount)
select newid(),tab.years,tab.SPH_Dealer_DMA_ID,tab.SPH_ProductLine_BUM_ID,
sum(Amount*dbo.fn_GetPriceByDealerID(SPH_Dealer_DMA_ID,tab.CFN_ID)) as amount 
from (
select convert(varchar(4),sph.SPH_ShipmentDate,112) as years,sph.SPH_Dealer_DMA_ID,sph.SPH_ProductLine_BUM_ID,
spl.SPL_ShipmentQty as Amount,CFN_ID
from ShipmentHeader sph,ShipmentLine spl,Product p,CFN cfn
where spl.SPL_SPH_ID = sph.SPH_ID
and spl.SPL_Shipment_PMA_ID = p.PMA_ID
and p.PMA_CFN_ID = cfn.CFN_ID
and sph.SPH_Status = 'Complete'
AND convert(varchar(4),sph.SPH_ShipmentDate,112) = @year
) tab
group by tab.years,tab.SPH_Dealer_DMA_ID,tab.SPH_ProductLine_BUM_ID

/*年度手术台数*/
update ReportTurnoverDealer set RTD_ShipmentOpeartion = tab.cnt
from
(select sph.SPH_Dealer_DMA_ID,sph.SPH_ProductLine_BUM_ID,count(*) as cnt,
convert(varchar(4),sph.SPH_ShipmentDate,112) as years
from ShipmentHeader sph
where sph.SPH_Status = 'Complete'
AND convert(varchar(4),sph.SPH_ShipmentDate,112) = @year
group by SPH_Dealer_DMA_ID,sph.SPH_ProductLine_BUM_ID,sph.SPH_ShipmentDate) tab
where ReportTurnoverDealer.RTD_DMA_ID = tab.SPH_Dealer_DMA_ID
and ReportTurnoverDealer.RTD_BUM_ID = tab.SPH_ProductLine_BUM_ID
and ReportTurnoverDealer.RTD_Year = tab.years

/*平均库存金额*/

/*取得当年的最早记录月份*/
select @minMonth = min(substring(RIH_Period,5,2)) from ReportInventoryHistory
where substring(RIH_Period,1,4) = @year
/*取得当年的最晚记录月份*/
select @maxMonth = max(substring(RIH_Period,5,2)) from ReportInventoryHistory
where substring(RIH_Period,1,4) = @year

update ReportTurnoverDealer set RTD_InvAmount_Start = tab1.FAmount
from 
( 
/*获取最早月份的历史库存金额*/
select RIH_DMA_ID,RIH_BUM_ID,substring(RIH_Period,1,4) as Period,sum(RIH_Amount) as FAmount 
from ReportInventoryHistory
where substring(RIH_Period,1,4) = @year
and substring(RIH_Period,5,2)= @minMonth
and RIH_Amount <> 0 
and RIH_Amount is not null
group by RIH_DMA_ID,RIH_BUM_ID,RIH_Period) tab1
where ReportTurnoverDealer.RTD_DMA_ID = tab1.RIH_DMA_ID
and ReportTurnoverDealer.RTD_BUM_ID = tab1.RIH_BUM_ID
and ReportTurnoverDealer.RTD_Year = @year

update ReportTurnoverDealer set RTD_InvAmount_End = tab2.LAmount
from 
/*获取最晚月份的历史库存金额*/
(select RIH_DMA_ID,RIH_BUM_ID,substring(RIH_Period,1,4) as Period,sum(RIH_Amount) as LAmount 
from ReportInventoryHistory
where substring(RIH_Period,1,4) = @year
and substring(RIH_Period,5,2)= @maxMonth
and RIH_Amount <> 0 
and RIH_Amount is not null
group by RIH_DMA_ID,RIH_BUM_ID,RIH_Period
) tab2
where ReportTurnoverDealer.RTD_DMA_ID = tab2.RIH_DMA_ID
and ReportTurnoverDealer.RTD_BUM_ID = tab2.RIH_BUM_ID
and ReportTurnoverDealer.RTD_Year = @year



    
end

GO


