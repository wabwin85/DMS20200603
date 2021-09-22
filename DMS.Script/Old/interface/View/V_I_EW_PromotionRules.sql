DROP view [interface].[V_I_EW_PromotionRules]
GO



CREATE view [interface].[V_I_EW_PromotionRules]
as
select PRCode, PurchaseQty ,
FreeQty ,
IndicatorRateFrom,
IndicatorRateTo,Tiers=1 from interface.T_I_EW_PromotionRules
union all
select PRCode, PurchaseQty2 ,
FreeQty2 ,
IndicatorRateFrom2,
IndicatorRateTo2,Tiers=2 from interface.T_I_EW_PromotionRules
union all
select PRCode, PurchaseQty3 ,
FreeQty3 ,
IndicatorRateFrom3,
IndicatorRateTo3,Tiers=3 from interface.T_I_EW_PromotionRules
union all
select PRCode, PurchaseQty4 ,
FreeQty4 ,
IndicatorRateFrom4,
IndicatorRateTo4,Tiers=4 from interface.T_I_EW_PromotionRules
union all
select PRCode, PurchaseQty5 ,
FreeQty5 ,
IndicatorRateFrom5,
IndicatorRateTo5,Tiers=5 from interface.T_I_EW_PromotionRules


GO


