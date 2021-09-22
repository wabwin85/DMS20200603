DROP view [interface].[V_I_EW_Promotion_Indicator]
GO



    CREATE view [interface].[V_I_EW_Promotion_Indicator]
    as
	select 
		d.DivisionName,AOPICH_DMA_ID,d.ProductLineID,
		MarketProperty=case MarketProperty when 0 then 'ºìº£' when 1 then 'À¶º£'
		 else '' end,
		AOPICH_Year,
		Quarter=case AOPICH_Month when 1 then 3
		                          when 2 then 3
		                          when 4 then 6
		                          when 5 then 6
		                          when 7 then 9
		                          when 8 then 9
		                          when 10 then 12
		                          when 11 then 12
		                          else AOPICH_Month end,
		AOPICH_Month,sum(AOPICH_Unit) as AOPICH_Unit
	from   AOPICDealerHospital a
	left join V_DivisionProductLineRelation d on AOPICH_ProductLine_ID=ProductLineID 
	and d.IsEmerging=0
	left join V_AllHospitalMarketProperty h on Hos_Id=AOPICH_Hospital_ID
	 and a.AOPICH_ProductLine_ID=h.ProductLineID
	 --where MarketProperty<>0
	group by d.DivisionName,AOPICH_DMA_ID,d.ProductLineID,AOPICH_Year,AOPICH_Month,MarketProperty



GO


