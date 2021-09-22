DROP view [interface].[V_I_QV_Product]
GO

CREATE view [interface].[V_I_QV_Product]

as 
select * from interface.T_I_QV_CFN
--	select 
--		 CFN_CustomerFaceNbr as UPN
--		,CFN_ChineseName as UPN_ChineseName
--		,CFN_EnglishName as UPN_EnglishName 
--		,CFN_Level5Code as Level5Code
--		,CFN_Level5Desc as Level5Desc
--		,CFN_Level4Code	as Level4Code
--		,CFN_Level4Desc	as Level4Desc
--		,CFN_Level3Code	as Level3Code
--		,CFN_Level3Desc	as Level3Desc
--		,CFN_Level2Code	as Level2Code
--		,CFN_Level2Desc	as Level2Desc
--		,CFN_Level1Code	as Level1Code
--		,CFN_Level1Desc	as Level1Desc
--		,CFN_ProductLine_BUM_ID	as ProductLine_ID
--		,p.DivisionID
--		,d.Division	 Division
--		,CFN_Description UPN_Description
--		,CFN_Property5 SFDA
--		,PMA_ConvertFactor Sheet
--		,1 ST
--		,0 AS MMPP
--        ,0 AS DChain
--        ,CFN_Property3 AS UOM
--	from CFN (nolock) t1
--	join Product (nolock) on CFN_ID=PMA_CFN_ID
--	left join interface.T_I_CR_Product p on p.UPN=t1.CFN_CustomerFaceNbr
--	left join interface.T_I_CR_Division d on p.DivisionID=d.DivisionID
GO


