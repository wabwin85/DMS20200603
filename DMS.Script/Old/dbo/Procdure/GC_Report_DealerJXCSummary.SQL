DROP procedure [dbo].[GC_Report_DealerJXCSummary]
GO


CREATE procedure [dbo].[GC_Report_DealerJXCSummary]
as 
begin
 /*清除当年的数据*/
delete from ReportDealerJXCSummary where RDS_Years = convert(nvarchar(4),getdate(),112);
/*将查询结果插入到表ReportDealerJXCSummary中*/
insert into ReportDealerJXCSummary  
/*将记录中月份不同但年度相同的12条记录汇总成一条，以横向排列*/
select COP_Year,DMA_ID,DMA_ChineseName,DMA_EnglishName,
DMA_SAP_Code,Attribute_Name,Id,
sum(order01) as order01,sum(PurchaseOrder01) as PurchaseOrder01,sum(Sales01) as Sales01,
sum(Operation01) as Operation01,sum(Inventory01) as Inventory01,
sum(order02) as order02,sum(PurchaseOrder02) as PurchaseOrder02,sum(Sales02) as Sales02,
sum(Operation02) as Operation02,sum(Inventory02) as Inventory02,
sum(order03) as order03,sum(PurchaseOrder03) as PurchaseOrder03,sum(Sales03) as Sales03,
sum(Operation03) as Operation03,sum(Inventory03) as Inventory03,
sum(order04) as order04,sum(PurchaseOrder04) as PurchaseOrder04,sum(Sales04) as Sales04,
sum(Operation04) as Operation04,sum(Inventory04) as Inventory04,
sum(order05) as order05,sum(PurchaseOrder05) as PurchaseOrder05,sum(Sales05) as Sales05,
sum(Operation05) as Operation05,sum(Inventory05) as Inventory05,
sum(order06) as order06,sum(PurchaseOrder06) as PurchaseOrder06,sum(Sales06) as Sales06,
sum(Operation06) as Operation06,sum(Inventory06) as Inventory06,
sum(order07) as order07,sum(PurchaseOrder07) as PurchaseOrder07,sum(Sales07) as Sales07,
sum(Operation07) as Operation07,sum(Inventory07) as Inventory07,
sum(order08) as order08,sum(PurchaseOrder08) as PurchaseOrder08,sum(Sales08) as Sales08,
sum(Operation08) as Operation08,sum(Inventory08) as Inventory08,
sum(order09) as order09,sum(PurchaseOrder09) as PurchaseOrder09,sum(Sales09) as Sales09,
sum(Operation09) as Operation09,sum(Inventory09) as Inventory09,
sum(order10) as order10,sum(PurchaseOrder10) as PurchaseOrder10,sum(Sales10) as Sales10,
sum(Operation10) as Operation10,sum(Inventory10) as Inventory10,
sum(order11) as order11,sum(PurchaseOrder11) as PurchaseOrder11,sum(Sales11) as Sales11,
sum(Operation11) as Operation11,sum(Inventory11) as Inventory11,
sum(order12) as order12,sum(PurchaseOrder12) as PurchaseOrder12,sum(Sales12) as Sales12,
sum(Operation12) as Operation12,sum(Inventory12) as Inventory12,
0 as YOrder,0 as YPurchaseOrder,0 as YSales,0 as YOperation,0 as YInventory
from (
/*将各部分的金额根据月份横向排列*/
select COP_Year,DMA_ID,DMA_ChineseName,DMA_EnglishName,
DMA_SAP_Code,Attribute_Name,Id,
case when COP_Period = '01' then [order] else '' end as 'order01',
case when COP_Period = '01' then PurchaseOrder else '' end as 'PurchaseOrder01',
case when COP_Period = '01' then Sales else '' end as 'Sales01',
case when COP_Period = '01' then Operation else '' end as 'Operation01',
case when COP_Period = '01' then Inventory else '' end as 'Inventory01',
case when COP_Period = '02' then [order] else '' end as 'order02',
case when COP_Period = '02' then PurchaseOrder else '' end as 'PurchaseOrder02',
case when COP_Period = '02' then Sales else '' end as 'Sales02',
case when COP_Period = '02' then Operation else '' end as 'Operation02',
case when COP_Period = '02' then Inventory else '' end as 'Inventory02',
case when COP_Period = '03' then [order] else '' end as 'order03',
case when COP_Period = '03' then PurchaseOrder else '' end as 'PurchaseOrder03',
case when COP_Period = '03' then Sales else '' end as 'Sales03',
case when COP_Period = '03' then Operation else '' end as 'Operation03',
case when COP_Period = '03' then Inventory else '' end as 'Inventory03',
case when COP_Period = '04' then [order] else '' end as 'order04',
case when COP_Period = '04' then PurchaseOrder else '' end as 'PurchaseOrder04',
case when COP_Period = '04' then Sales else '' end as 'Sales04',
case when COP_Period = '04' then Operation else '' end as 'Operation04',
case when COP_Period = '04' then Inventory else '' end as 'Inventory04',
case when COP_Period = '05' then [order] else '' end as 'order05',
case when COP_Period = '05' then PurchaseOrder else '' end as 'PurchaseOrder05',
case when COP_Period = '05' then Sales else '' end as 'Sales05',
case when COP_Period = '05' then Operation else '' end as 'Operation05',
case when COP_Period = '05' then Inventory else '' end as 'Inventory05',
case when COP_Period = '06' then [order] else '' end as 'order06',
case when COP_Period = '06' then PurchaseOrder else '' end as 'PurchaseOrder06',
case when COP_Period = '06' then Sales else '' end as 'Sales06',
case when COP_Period = '06' then Operation else '' end as 'Operation06',
case when COP_Period = '06' then Inventory else '' end as 'Inventory06',
case when COP_Period = '07' then [order] else '' end as 'order07',
case when COP_Period = '07' then PurchaseOrder else '' end as 'PurchaseOrder07',
case when COP_Period = '07' then Sales else '' end as 'Sales07',
case when COP_Period = '07' then Operation else '' end as 'Operation07',
case when COP_Period = '07' then Inventory else '' end as 'Inventory07',
case when COP_Period = '08' then [order] else '' end as 'order08',
case when COP_Period = '08' then PurchaseOrder else '' end as 'PurchaseOrder08',
case when COP_Period = '08' then Sales else '' end as 'Sales08',
case when COP_Period = '08' then Operation else '' end as 'Operation08',
case when COP_Period = '08' then Inventory else '' end as 'Inventory08',
case when COP_Period = '09' then [order] else '' end as 'order09',
case when COP_Period = '09' then PurchaseOrder else '' end as 'PurchaseOrder09',
case when COP_Period = '09' then Sales else '' end as 'Sales09',
case when COP_Period = '09' then Operation else '' end as 'Operation09',
case when COP_Period = '09' then Inventory else '' end as 'Inventory09',
case when COP_Period = '10' then [order] else '' end as 'order10',
case when COP_Period = '10' then PurchaseOrder else '' end as 'PurchaseOrder10',
case when COP_Period = '10' then Sales else '' end as 'Sales10',
case when COP_Period = '10' then Operation else '' end as 'Operation10',
case when COP_Period = '10' then Inventory else '' end as 'Inventory10',
case when COP_Period = '11' then [order] else '' end as 'order11',
case when COP_Period = '11' then PurchaseOrder else '' end as 'PurchaseOrder11',
case when COP_Period = '11' then Sales else '' end as 'Sales11',
case when COP_Period = '11' then Operation else '' end as 'Operation11',
case when COP_Period = '11' then Inventory else '' end as 'Inventory11',
case when COP_Period = '12' then [order] else '' end as 'order12',
case when COP_Period = '12' then PurchaseOrder else '' end as 'PurchaseOrder12',
case when COP_Period = '12' then Sales else '' end as 'Sales12',
case when COP_Period = '12' then Operation else '' end as 'Operation12',
case when COP_Period = '12' then Inventory else '' end as 'Inventory12'
from
(
/*由于各部分的记录条数存在不同，故将各部分的记录UNION起来，根据类别横向排列*/
select COP_Year,COP_Period,dm.DMA_ID,dm.DMA_ChineseName,dm.DMA_EnglishName,
dm.DMA_SAP_Code,vp.Attribute_Name,vp.Id,
sum(case when types = 'order' then Amount else '' end) as 'order',
sum(case when types = 'PurchaseOrder' then Amount else '' end) as 'PurchaseOrder',
sum(case when types = 'Sales' then Amount else '' end) as 'Sales',
sum(case when types = 'Operation' then Amount else '' end) as 'Operation',
sum(case when types = 'Inventory' then Amount else '' end) as 'Inventory'
from (
/*取出经销商根据产品线，年度，月度划分的订单金额*/
select c.COP_Year,c.COP_Period,poh.POH_DMA_ID,
poh.POH_ProductLine_BUM_ID,sum(isnull(POD_Amount,0)) as Amount,'order' as types
from PurchaseOrderHeader poh,PurchaseOrderdetail pod,COP c
where poh.POH_ID = pod.POD_POH_ID
and CONVERT(varchar(100), poh.POH_SubmitDate, 112) BETWEEN CONVERT(varchar(100), c.COP_StartDate, 112) AND CONVERT(varchar(100), c.COP_EndDate, 112) AND c.COP_Type = 'M'
and poh.POH_OrderStatus in('Confirmed','Delivering','Completed')
group by poh.POH_DMA_ID,poh.POH_ProductLine_BUM_ID,c.COP_Year,
c.COP_Period
union
/*取出经销商根据产品线，年度，月度划分的发货金额*/
select [Year],Period,PRH_Dealer_DMA_ID,PRH_ProductLine_BUM_ID,
sum(isnull(tab.Amount,0)) as ReachAmount,'PurchaseOrder'  as types
from (
select po.PRH_ID,por.POR_PRH_ID,  po.PRH_Dealer_DMA_ID,po.PRH_ProductLine_BUM_ID,
cop.COP_Year AS [Year],cop.COP_Period AS Period,
por.POR_ReceiptQty*dbo.fn_GetPriceForAOPDealer(PRH_Dealer_DMA_ID,CFN_ID,po.PRH_PurchaseOrderNbr) as Amount
 from POReceiptHeader po
inner join POReceipt por on por.POR_PRH_ID = po.PRH_ID
inner join Product p on por.POR_SAP_PMA_ID = p.PMA_ID
inner join CFN on p.PMA_CFN_ID = CFN.CFN_ID
inner join COP cop on CONVERT(varchar(100), po.PRH_SAPShipmentDate, 112) BETWEEN CONVERT(varchar(100), cop.COP_StartDate, 112) AND CONVERT(varchar(100), cop.COP_EndDate, 112) AND cop.COP_Type = 'M'
where po.PRH_Type='PurchaseOrder' 
) tab 
group by PRH_Dealer_DMA_ID,PRH_ProductLine_BUM_ID,[Year],Period
union
/*取出经销商根据产品线，年度，月度划分的销售金额*/
select COP.COP_Year,COP.COP_Period,sph.SPH_Dealer_DMA_ID,sph.SPH_ProductLine_BUM_ID,
isnull(sum(spl.SPL_ShipmentQty*dbo.fn_GetPriceByDealerID(SPH_Dealer_DMA_ID,CFN_ID)),0) as Amount,'Sales' as Sales
from ShipmentHeader sph,ShipmentLine spl,ShipmentLot slt,Product p,CFN cfn,COP
where spl.SPL_SPH_ID = sph.SPH_ID
and slt.SLT_SPL_ID = spl.SPL_ID
and spl.SPL_Shipment_PMA_ID = p.PMA_ID
and p.PMA_CFN_ID = cfn.CFN_ID
and CONVERT(varchar(100), sph.SPH_ShipmentDate, 112) BETWEEN CONVERT(varchar(100), COP.COP_StartDate, 112) AND CONVERT(varchar(100), COP.COP_EndDate, 112) AND COP.COP_Type = 'M'
and sph.SPH_Status = 'Complete'
group by sph.SPH_Dealer_DMA_ID,sph.SPH_ProductLine_BUM_ID,COP.COP_Year,COP.COP_Period
union
/*取出经销商根据产品线，年度，月度划分的手术台数*/
select COP.COP_Year,COP.COP_Period,
SPH_Dealer_DMA_ID,SPH_ProductLine_BUM_ID,count(*) cnt,'Operation' as types
from ShipmentHeader,COP
where SPH_Status = 'Complete'
and CONVERT(varchar(100), SPH_ShipmentDate, 112) BETWEEN CONVERT(varchar(100), COP_StartDate, 112) AND CONVERT(varchar(100), COP_EndDate, 112) AND COP_Type = 'M'
group by COP_Year,COP_Period,SPH_Dealer_DMA_ID,SPH_ProductLine_BUM_ID
union
/*取出经销商根据产品线，年度，月度划分的历史库存金额*/
select cop_year,cop_period,
rih_dma_id,cfn.CFN_ProductLine_BUM_ID,sum(isnull(rih_amount,0)) as amount,'Inventory' as types from ReportInventoryHistory rih,COP,Product pro,CFN cfn
where CONVERT(varchar(100), dateadd(mm,-1,rih_createdate), 112) BETWEEN CONVERT(varchar(100), COP_StartDate, 112) AND CONVERT(varchar(100), COP_EndDate, 112) AND COP_Type = 'M'
and pro.PMA_ID = rih.RIH_PMA_ID and cfn.CFN_ID = pro.PMA_CFN_ID
group by cop_year,cop_period,rih_dma_id,cfn.CFN_ProductLine_BUM_ID
union
/*根据经销商，产品线，年度，月度汇总*/
select 
    substring(convert(varchar(6),getdate(),112),1,4) as FYYear,
    substring(convert(varchar(6),getdate(),112),5,2) as FYMonth,
    DMA_ID,CFN_ProductLine_BUM_ID,
    sum(isnull(Amount,0)) as Amount,'Inventory' as types
    from 
    (
    /*取出当月的库存金额*/
      select dm.DMA_ID, CFN_ID,
          CFN.CFN_ProductLine_BUM_ID,
          INV_OnHandQuantity*dbo.fn_GetPriceByDealerID(dm.DMA_ID,CFN.CFN_ID) as Amount
      from inventory inv,Warehouse wh,DealerMaster dm,
      product p,cfn
      where inv.INV_WHM_ID = wh.WHM_ID
      and wh.WHM_DMA_ID = dm.DMA_ID
      and inv.INV_PMA_ID = p.PMA_ID
      and p.PMA_CFN_ID = CFN.CFN_ID
    ) tab
    group by DMA_ID,
    CFN_ProductLine_BUM_ID
) tab,DealerMaster dm,view_ProductLine vp
where tab.POH_DMA_ID = dm.DMA_ID
and tab.POH_ProductLine_BUM_ID = vp.Id
group by COP_Year,COP_Period,DMA_ID,dm.DMA_ChineseName,dm.DMA_EnglishName,
dm.DMA_SAP_Code,vp.Attribute_Name,vp.Id
) tab2
) tab3
where COP_Year = convert(nvarchar(4),getdate(),112)
group by
COP_Year,DMA_ID,DMA_ChineseName,DMA_EnglishName,
DMA_SAP_Code,Attribute_Name,Id

--汇总年订单金额
update ReportDealerJXCSummary
set YOrder = order01+order02+order03+order04+order05+order06+order07+order08+order09+order10+order11+order12
where RDS_Years = convert(nvarchar(4),getdate(),112)

--汇总年发货金额
update ReportDealerJXCSummary
set YPurchaseOrder = PurchaseOrder01+PurchaseOrder02+PurchaseOrder03+PurchaseOrder04+
    PurchaseOrder05+PurchaseOrder06+PurchaseOrder07+PurchaseOrder08+
    PurchaseOrder09+PurchaseOrder10+PurchaseOrder11+PurchaseOrder12
where RDS_Years = convert(nvarchar(4),getdate(),112)


--汇总年销售金额
update ReportDealerJXCSummary
set YSales = Sales01+Sales02+Sales03+Sales04+Sales05+Sales06+Sales07+Sales08+Sales09+Sales10+Sales11+Sales12
where RDS_Years = convert(nvarchar(4),getdate(),112)

--汇总年报台数
update ReportDealerJXCSummary
set YOperation = Operation01+Operation02+Operation03+Operation04+Operation05+Operation06+
Operation07+Operation08+Operation09+Operation10+Operation11+Operation12
where RDS_Years = convert(nvarchar(4),getdate(),112)




end




GO


