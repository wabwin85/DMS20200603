DROP view [interface].[V_I_QV_ProductLine]
GO

Create view [interface].[V_I_QV_ProductLine]
as 
	select 
	ProductLine=PCT_Name
	,ProductLineID=PCT_ProductLine_BUM_ID
	,ProductLineID2=PCT_ID
	from PartsClassification

GO


