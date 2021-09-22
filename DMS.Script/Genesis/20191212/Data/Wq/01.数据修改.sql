update lafite_sitemap set Menutitle=' 经销商背景调查' where MenuType='menu' and Menutitle='经销商背调'



--新增承运商及运单编号
ALTER TABLE InterfaceShipment ADD [ISH_ExpressCompany] [nvarchar](200) NULL
ALTER TABLE InterfaceShipment ADD [ISH_ExpressNo] [nvarchar](200) NULL


--经销商背调报告信息增加是否有Regflag
ALTER table DealerMasterDD Add DMDD_IsHaveRedFlag bit null


--价格上传
ALTER TABLE CFNPriceImportInit ADD CFNPI_DealerType Nvarchar(50) NULL
ALTER TABLE CFNPrice ADD CFNP_DealerType Nvarchar(50) NULL
