DROP view [dbo].[View_ReportAOPDealer] 
GO



CREATE view [dbo].[View_ReportAOPDealer] as
select distinct tab.*,rpt.Q01,rpt.Q02,rpt.Q03,rpt.Q04,
rpt.QR01,rpt.QR02,rpt.QR03,rpt.QR04,
HY01,HYAOP01,HY02,HYAOP02,
case when AOPMAmount01 = 0 then '0.00' else cast(MAmount01/AOPMAmount01 as money) end as Mper01 ,
case when AOPMAmount02 = 0 then '0.00' else cast(MAmount02/AOPMAmount02 as money) end as Mper02,
case when AOPMAmount03 = 0 then '0.00' else cast(MAmount03/AOPMAmount03 as money) end as Mper03,
case when AOPMAmount04 = 0 then '0.00' else cast(MAmount04/AOPMAmount04 as money) end as Mper04,
case when AOPMAmount05 = 0 then '0.00' else cast(MAmount05/AOPMAmount05 as money) end as Mper05,
case when AOPMAmount06 = 0 then '0.00' else cast(MAmount06/AOPMAmount06 as money) end as Mper06,
case when AOPMAmount07 = 0 then '0.00' else cast(MAmount07/AOPMAmount07 as money) end as Mper07,
case when AOPMAmount08 = 0 then '0.00' else cast(MAmount08/AOPMAmount08 as money) end as Mper08,
case when AOPMAmount09 = 0 then '0.00' else cast(MAmount09/AOPMAmount09 as money) end as Mper09,
case when AOPMAmount10 = 0 then '0.00' else cast(MAmount10/AOPMAmount10 as money) end as Mper10,
case when AOPMAmount11 = 0 then '0.00' else cast(MAmount11/AOPMAmount11 as money) end as Mper11,
case when AOPMAmount12 = 0 then '0.00' else cast(MAmount12/AOPMAmount12 as money) end as Mper12,
case when Q01 = 0 then '0.00' else cast(QR01/Q01 as money) end as Qper01,
case when Q02 = 0 then '0.00' else cast(QR02/Q02 as money) end as Qper02,
case when Q03 = 0 then '0.00' else cast(QR03/Q03 as money) end as Qper03,
case when Q04 = 0 then '0.00' else cast(QR04/Q04 as money) end as Qper04,
case when HYAOP01 = 0 then '0.00' else cast(HY01/HYAOP01 as money) end as HYper01,
case when HYAOP02 = 0 then '0.00' else cast(HY02/HYAOP02 as money) end as HYper02,
case when RAD_YAOP = 0 then '0.00' else cast(RAD_YAmount/RAD_YAOP as money) end as Yper
from (
select distinct ra.RAD_DMA_ID,ra.RAD_BUM_ID,dma.DMA_ChineseName,dma.DMA_SAP_Code,vp.ATTRIBUTE_NAME,ra.RAD_Year,
sum(case when ra.RAD_Month = '01' then ra.RAD_MAmount else '0.00' end) as MAmount01,
sum(case when ra.RAD_Month = '01' then ra.RAD_MAOP else '0.00' end) as AOPMAmount01,
sum(case when ra.RAD_Month = '02' then ra.RAD_MAmount else '0.00' end) as MAmount02,
sum(case when ra.RAD_Month = '02' then ra.RAD_MAOP else '0.00' end) as AOPMAmount02,
sum(case when ra.RAD_Month = '03' then ra.RAD_MAmount else '0.00' end) as MAmount03,
sum(case when ra.RAD_Month = '03' then ra.RAD_MAOP else '0.00' end) as AOPMAmount03,
sum(case when ra.RAD_Month = '04' then ra.RAD_MAmount else '0.00' end) as MAmount04,
sum(case when ra.RAD_Month = '04' then ra.RAD_MAOP else '0.00' end) as AOPMAmount04,
sum(case when ra.RAD_Month = '05' then ra.RAD_MAmount else '0.00' end) as MAmount05,
sum(case when ra.RAD_Month = '05' then ra.RAD_MAOP else '0.00' end) as AOPMAmount05,
sum(case when ra.RAD_Month = '06' then ra.RAD_MAmount else '0.00' end) as MAmount06,
sum(case when ra.RAD_Month = '06' then ra.RAD_MAOP else '0.00' end) as AOPMAmount06,
sum(case when ra.RAD_Month = '07' then ra.RAD_MAmount else '0.00' end) as MAmount07,
sum(case when ra.RAD_Month = '07' then ra.RAD_MAOP else '0.00' end) as AOPMAmount07,
sum(case when ra.RAD_Month = '08' then ra.RAD_MAmount else '0.00' end) as MAmount08,
sum(case when ra.RAD_Month = '08' then ra.RAD_MAOP else '0.00' end) as AOPMAmount08,
sum(case when ra.RAD_Month = '09' then ra.RAD_MAmount else '0.00' end) as MAmount09,
sum(case when ra.RAD_Month = '09' then ra.RAD_MAOP else '0.00' end) as AOPMAmount09,
sum(case when ra.RAD_Month = '10' then ra.RAD_MAmount else '0.00' end) as MAmount10,
sum(case when ra.RAD_Month = '10' then ra.RAD_MAOP else '0.00' end) as AOPMAmount10,
sum(case when ra.RAD_Month = '11' then ra.RAD_MAmount else '0.00' end) as MAmount11,
sum(case when ra.RAD_Month = '11' then ra.RAD_MAOP else '0.00' end) as AOPMAmount11,
sum(case when ra.RAD_Month = '12' then ra.RAD_MAmount else '0.00' end) as MAmount12,
sum(case when ra.RAD_Month = '12' then ra.RAD_MAOP else '0.00' end) as AOPMAmount12,
ra.RAD_YAOP,ra.RAD_YAmount
from reportAOPDealer ra,dbo.DealerMaster dma,
View_ProductLine vp
where RA.RAD_DMA_ID = dma.DMA_ID
and ra.RAD_BUM_ID = vp.Id
group by ra.RAD_DMA_ID,ra.RAD_BUM_ID,DMA_ChineseName,dma.DMA_SAP_Code,
ATTRIBUTE_NAME,RAD_Year,ra.RAD_YAOP,ra.RAD_YAmount

) tab left join (
select RAD_DMA_ID,RAD_BUM_ID,RAD_Year,
sum(Q01) as Q01,sum(QR01) as QR01,sum(Q02) as Q02,sum(QR02) as QR02,
sum(Q03) as Q03,sum(QR03) as QR03,sum(Q04) as Q04,sum(QR04) as QR04
from (
  select distinct RAD_DMA_ID,RAD_BUM_ID,RAD_Year,
  case when ra.RAD_Quarter = 'Q1' then ra.RAD_QAmount else '0.00' end as QR01,
  case when ra.RAD_Quarter = 'Q1' then ra.RAD_QAOP else '0.00' end as Q01,
  case when ra.RAD_Quarter = 'Q2' then ra.RAD_QAmount else '0.00' end as QR02,
  case when ra.RAD_Quarter = 'Q2' then ra.RAD_QAOP else '0.00' end as Q02,
  case when ra.RAD_Quarter = 'Q3' then ra.RAD_QAmount else '0.00' end as QR03,
  case when ra.RAD_Quarter = 'Q3' then ra.RAD_QAOP else '0.00' end as Q03,
  case when ra.RAD_Quarter = 'Q4' then ra.RAD_QAmount else '0.00' end as QR04,
  case when ra.RAD_Quarter = 'Q4' then ra.RAD_QAOP else '0.00' end as Q04
  from ReportAOPDealer ra(nolock)
  ) tab
group by RAD_DMA_ID,RAD_BUM_ID,RAD_Year
) rpt
on tab.RAD_DMA_ID = rpt.RAD_DMA_ID
and tab.RAD_BUM_ID = rpt.RAD_BUM_ID
and tab.RAD_Year = rpt.RAD_Year
left join 
(
select RAD_DMA_ID,RAD_BUM_ID,RAD_Year,
sum(HYAOP01) as HYAOP01,sum(HY01) as HY01,
sum(HYAOP02) as HYAOP02,sum(HY02) as HY02
from (
  select distinct RAD_DMA_ID,RAD_BUM_ID,RAD_Year,
  case when ra.RAD_HalfYear = 'H1' then ra.RAD_HYAmount else '0.00' end as HY01,
  case when ra.RAD_HalfYear = 'H1' then ra.RAD_HYAOP else '0.00' end as HYAOP01,
  case when ra.RAD_HalfYear = 'H2' then ra.RAD_HYAmount else '0.00' end as HY02,
  case when ra.RAD_HalfYear = 'H2' then ra.RAD_HYAOP else '0.00' end as HYAOP02
  from ReportAOPDealer ra(nolock)
  ) tab
group by RAD_DMA_ID,RAD_BUM_ID,RAD_Year
) HalfYear
ON tab.RAD_DMA_ID = HalfYear.RAD_DMA_ID
and tab.RAD_BUM_ID = HalfYear.RAD_BUM_ID
and tab.RAD_Year = HalfYear.RAD_Year


GO


