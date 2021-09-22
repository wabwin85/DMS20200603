DROP proc [interface].[P_I_MDM_HospitalMarketProperty]
GO

CREATE proc [interface].[P_I_MDM_HospitalMarketProperty]

as

--更新已存在的数据
	update interface.HospitalMarketProperty set
	MarketProperty=b.MarketProperty
	FROM
	interface.HospitalMarketProperty a inner join 
	interface.MDM_HospitalMarketProperty b on a.DMSCode=b.DMSCode and a.DivisionID=b.DivisionID
			 

--添加新的数据
	insert into interface.HospitalMarketProperty
	(DMSCode,DivisionID,MarketProperty,Marketlevel
	)
	select a.DMSCode,a.DivisionID,a.MarketProperty,-1
	from interface.MDM_HospitalMarketProperty a left join interface.HospitalMarketProperty b
	 on a.DMSCode=b.DMSCode and a.DivisionID=b.DivisionID where b.DMSCode is null

--删除不存在的数据
	delete interface.HospitalMarketProperty from interface.HospitalMarketProperty a left join 
	interface.MDM_HospitalMarketProperty b on a.DMSCode=b.DMSCode and a.DivisionID=b.DivisionID where b.DMSCode is null
GO


