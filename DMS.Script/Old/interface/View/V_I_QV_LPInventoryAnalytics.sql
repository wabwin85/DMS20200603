
DROP VIEW [interface].[V_I_QV_LPInventoryAnalytics]
GO



CREATE VIEW [interface].[V_I_QV_LPInventoryAnalytics]
AS
SELECT LIA_ID
	,LIA_DivisionName
	,LIA_UPN
	,LIA_Month01
	,LIA_Month02
	,LIA_Month03
	,LIA_Month04
	,LIA_Month05
	,LIA_Month06
	,LIA_TotalSales
	,LIA_PercentCount
	,LIA_SumPercentCount
	,LIA_SABC
	,LIA_LBM
	,LIA_TotalCOGS
	,LIA_PercentCOGS
	,LIA_CumCOGS
	,LIA_COGSABC
	,LIA_Freq
	,LIA_FABC
	,LIA_RFABC
	,LIA_Type
	,dm.DMA_SAP_Code AS LIA_SAP_Code
	,LIA_LineNbr
	,LIA_CreateDate
FROM dbo.LPInventoryAnalytics li
INNER JOIN dbo.DealerMaster dm
	ON li.LIA_DMA_ID = dm.DMA_ID



GO


