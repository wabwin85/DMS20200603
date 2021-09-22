DROP view [interface].[V_I_EW_DealerLastedMaintainedPrice]
GO


CREATE view [interface].[V_I_EW_DealerLastedMaintainedPrice] AS 
select tab1.CustomerSapCode,tab1.UPN,max(tab1.NewPrice ) AS UnitPrice
from interface.T_I_EW_DistributorPrice tab1(NOLOCK),
(select CustomerSapCode, UPN, max( ValidTo) AS ValidTo
from interface.T_I_EW_DistributorPrice(NOLOCK)
where Type = 2 OR SubtType in (112,122)
group by CustomerSapCode, UPN
) tab2
where tab1.CustomerSapCode=tab2.CustomerSapCode
and tab1.UPN = tab2.UPN
and tab1.ValidTo =tab2.ValidTo
and (Type = 2 OR SubtType in (112,122))
group by tab1.CustomerSapCode,tab1.UPN

GO


