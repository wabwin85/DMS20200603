DROP view [interface].[V_I_QV_Lafite_SiteMap]
GO





CREATE view [interface].[V_I_QV_Lafite_SiteMap]
as

select MenuId,convert(nvarchar(100),MenuType) as MenuType,MenuLevel,convert(nvarchar(100),MenuTitle) as MenuTitle ,ParentId,PowerKey,IsEnabled,OrderBy
 from BSC_Prd.dbo.Lafite_SiteMap




GO


