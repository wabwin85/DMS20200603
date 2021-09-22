DROP proc [dbo].[GC_Interface_PromotionRules]
GO


CREATE proc [dbo].[GC_Interface_PromotionRules]  ( @WFINSTANCEID nvarchar(200))
as

begin
declare @Bundle int
declare @Suit int
select @Bundle=ma.IsBundle,
       @Suit=ma.IsSuit from [interface].[Biz_Promotion_Main] ma where WFINSTANCEID=@WFINSTANCEID

Insert into interface.T_I_EW_PromotionRules
select NEWID() as PRID, * from
(select distinct case when FREEGTYPE=1 then '额度使用' when FREEGTYPE=2 then '即买即赠' end as 'PromotionType',
POLICYNO as 'PRCode',
PolicyContent as'Content',
ma.Division,
di.ProductLineName as ProductLine,
case when ma.IsBundle=1 and al.ProductLevel=1 then 'Level1' when ma.IsBundle=1 and al.ProductLevel=2 then 'Level2' 
     when ma.IsBundle=1 and al.ProductLevel=3 then 'Level3' when ma.IsBundle=1 and al.ProductLevel=4 then 'Level4' 
     when ma.IsBundle=1 and al.ProductLevel=5 then 'Level5' when ma.IsBundle=1 and al.ProductLevel=6 then 'Level6'
     else Null End as 'ProductLevel',
case when ma.IsBundle=1 then al.ProductCode 
     else Null end as 'LevelCode',  
case when ma.LADDERRULE=0 then li1.PurchaseQty when ma.LADDERRULE=1 then ma.PurchaseQty  
     when ma.LADDERRULE IS null  then ma.PurchaseQty
     end AS'PurchaseQty',
case when ma.LADDERRULE=0 then li1.FreeQty when ma.LADDERRULE=1 then ma.FreeQty 
     when ma.LADDERRULE IS null  then ma.FreeQty
     end AS'FreeQty',
case when one.HospitalType=0 then '无'   when one.HospitalType=1 then '全国' when one.HospitalType=2 then '省' 
     when one.HospitalType=3 then '城市' when one.HospitalType=4 then '医院' when one.HospitalType=5 then '首次上报用量时间的医院' 
     end as 'CustomerType',
one.Province as HospitalProvince,
one.HospitalCity as HospitalCity,
one.HospitalName as 'HospitalCode',
case when ma.DealerLevel='1' then 'T1' when ma.DealerLevel='2' then 'LP' else 'T1,LP'
     end as 'ToDealer',
ma.StartDate as 'BeginDate',
ma.EndDate,
case when one.SaleType=1 then '销售到医院' when one.SaleType=2 then '波科出货' when one.SaleType=3 then '平台销售到二级' 
     end as 'SalesType',
one.DealerImport as 'SpecificDealers',
case when ma.IndicatorsClaim=0 then 1 when ma.IndicatorsClaim=1 then 0
     when ma.IndicatorsClaim IS null then 0 end as 'IsAchIndicator',
case when one.ProductManager=1 then '批发' when one.ProductManager=2 then '寄售' 
     when one.ProductManager is null then '批发' end as 'ProductSales',
case when one.MarketType=1 then '红海' when one.MarketType=2 then '蓝海' 
     end as 'MarketType',
case when ma.COMPUTECYCLE=1 then '年' when ma.COMPUTECYCLE=3 then '季度' when ma.COMPUTECYCLE=4 then '月' 
     end as 'ComputeCycle',
ma.USEQTY,
case when ma.USERANGE=1 then '单个经销商' when ma.UseRange=2 then '所有经销商' end as 'USERANGE',
case when ma.ISSUIT=1 and fral.FREEGLEVEL=1 then 'Level1' when ma.ISSUIT=1 and fral.FREEGLEVEL=2 then 'Level2' 
     when ma.ISSUIT=1 and fral.FREEGLEVEL=3 then 'Level3' when ma.ISSUIT=1 and fral.FREEGLEVEL=4 then 'Level4' 
     when ma.ISSUIT=1 and fral.FREEGLEVEL=5 then 'Level5' when ma.ISSUIT=1 and fral.FREEGLEVEL=6 then 'Level6' 
     else null End as 'UseProductLevel',
case when ma.ISSUIT=1 then fral.FREEGCODE 
     else null end as 'UseLevelCode',
case when one.ISADDFREEG=0 then 1 when one.ISADDFREEG=1 then 0 
     when one.ISADDFREEG IS null then 0 end  as 'IsAddUp',
ma.RequestDate as 'CeateTime',
GETDATE() as 'UpdateTime',
convert(uniqueidentifier,di.ProductLineID) as ProductLineId,
ma.DealerImport as 'ToDealerList',
case when  one.ISADDUP =0 then 1 when  one.ISADDUP =1 then 0 
     when  one.ISADDUP  IS null then 0 end as 'IsAddLastCount',
case when  ma.LADDERRULE =0 then 1 when ma.LADDERRULE =1 then 0 
     when  ma.LADDERRULE is null then 0 end  as 'IsTiersRule',
li1.IndicatorsFrom/100.0 as 'IndicatorRateFrom',li1.IndicatorsTo/100.0 as 'IndicatorRateTo',
li2.PurchaseQty as 'PurchaseQty2',li2.FreeQty as 'FreeQty2',li2.IndicatorsFrom/100.0 as 'IndicatorRateFrom2',li2.IndicatorsTo/100.0 as 'IndicatorRateTo2',
li3.PurchaseQty as 'PurchaseQty3',li3.FreeQty as 'FreeQty3',li3.IndicatorsFrom/100.0 as 'IndicatorRateFrom3',li3.IndicatorsTo/100.0 as 'IndicatorRateTo3',
li4.PurchaseQty as 'PurchaseQty4',li4.FreeQty as 'FreeQty4',li4.IndicatorsFrom/100.0 as 'IndicatorRateFrom4',li4.IndicatorsTo/100.0 as 'IndicatorRateTo4',
li5.PurchaseQty as 'PurchaseQty5',li5.FreeQty as 'FreeQty5',li5.IndicatorsFrom/100.0 as 'IndicatorRateFrom5',li5.IndicatorsTo/100.0 as 'IndicatorRateTo5',
ma.POLICYName as 'PRName',
case when ma.IsBundle =0 then 1 when  ma.IsBundle =1 then 0 
     when ma.IsBundle IS NULL then 0 end as 'IsBundle',
case when ma.PURCHASEINDICATORS=0 then 1 when  ma.PURCHASEINDICATORS =1 then 0 
     when ma.PURCHASEINDICATORS IS NULL then 0 end  as 'IsAchSpecificInd',
case when ma.ISINTEGRAL=0 then 1 when  ma.ISINTEGRAL =1 then 0 
     when  ma.ISINTEGRAL IS NULL then 0  end as 'IsIntegral',
case when  ma.ISSUIT=0 then 1 when   ma.ISSUIT =1 then 0 
     when  ma.ISSUIT is  null then 0 end  as 'IsSuit'
from [interface].[Biz_Promotion_Main] ma
inner join V_DivisionProductLineRelation di on CONVERT(nvarchar(10),ma.ProductDivision)=di.DivisionCode
inner join [interface].[Biz_Promotion_ProductAll] al on ma.WFINSTANCEID=al.WFINSTANCEID
inner join [interface].[Biz_Promotion_FreeGRuleAll] fral on ma.WFINSTANCEID=fral.WFINSTANCEID
left join [interface].[BIZ_PROMOTION_FREEGRULEONE] one on ma.WFINSTANCEID=one.WFINSTANCEID
left join [interface].[Biz_Promotion_LadderList] li1 on ma.WFINSTANCEID=li1.WFINSTANCEID
left join [interface].[Biz_Promotion_LadderList] li2 on ma.WFINSTANCEID=li2.WFINSTANCEID
left join [interface].[Biz_Promotion_LadderList] li3 on ma.WFINSTANCEID=li3.WFINSTANCEID
left join [interface].[Biz_Promotion_LadderList] li4 on ma.WFINSTANCEID=li4.WFINSTANCEID
left join [interface].[Biz_Promotion_LadderList] li5 on ma.WFINSTANCEID=li5.WFINSTANCEID
where ma.WFINSTANCEID=@WFINSTANCEID and di.IsEmerging !=1 and
 li1.RowNum=1 and li2.RowNum=2 and li3.RowNum=3 and li4.RowNum=4 and li5.RowNum=5) as abc
 
 --是Bundle组合的时候,将产品信息数据传到DMS
 if(@Bundle=0)
 Insert into interface.T_I_EW_PromotionRules_Bundle
select ma.POLICYNO as 'PRCode',
case when al.ProductLevel=1 then 'Level1' when al.ProductLevel=2 then 'Level2' 
     when al.ProductLevel=3 then 'Level3' when al.ProductLevel=4 then 'Level4' 
     when al.ProductLevel=5 then 'Level5' when al.ProductLevel=6 then 'Level6' End as 'ProductLevel',
case when ma.IsBundle=1 then Null else al.ProductCode end as 'LevelCode',
case when ma.IsBundle=1 then Null else al.Qty end as 'Qty',
case when ma.IsBundle=1 then Null else al.RowNum end as 'Tiers',
ma.ProductLine as 'ProductLineId'
from [interface].[Biz_Promotion_Main] ma
inner join [interface].[BIZ_PROMOTION_PRODUCTALL] al on ma.WFINSTANCEID=al.WFINSTANCEID
where ma.WFINSTANCEID=@WFINSTANCEID


--是套装时,将赠品信息数据传到DMS
if(@Suit=0)
Insert into interface.T_I_EW_PromotionRules_Suit
select ma.POLICYNO as 'PRCode',
case when fral.FREEGLEVEL=1 then 'Level1' when  fral.FREEGLEVEL=2 then 'Level2' 
     when fral.FREEGLEVEL=3 then 'Level3' when  fral.FREEGLEVEL=4 then 'Level4' 
     when fral.FREEGLEVEL=5 then 'Level5' when  fral.FREEGLEVEL=6 then 'Level6' End as 'ProductLevel',
case when ma.IsSuit=1 then Null else fral.FreeGCode end as 'LevelCode',
case when ma.IsSuit=1 then Null else fral.Qty end as 'Qty',
ma.ProductLine as 'ProductLineId'
from [interface].[Biz_Promotion_Main] ma
inner join interface.BIZ_PROMOTION_FREEGRULEALL fral on ma.WFINSTANCEID=fral.WFINSTANCEID
where ma.WFINSTANCEID=@WFINSTANCEID
 

	
	
	

	end
	

GO


