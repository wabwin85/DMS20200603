DROP VIEW [interface].[V_I_QV_ScoreCard_KPI]
GO



CREATE VIEW [interface].[V_I_QV_ScoreCard_KPI]
AS
SELECT IT.ID,
IT.DMA_ID,
IT.BU,
IT.[Year],
IT.[Quarter],
esc.ESC_No,
IT.WeekUploadStaticValue ,
IT.WeekUploadStaticScore,
IT.WeekUploadStaticRemark,
IT.DIOHValue,
IT.DIOHScore,
DIOHRemark 
FROM Interface.T_I_QV_ScoreCard_KPI IT
INNER JOIN V_DivisionProductLineRelation VD
ON IT.BU = VD.DivisionName
INNER JOIN EndoScoreCard esc
on IT.DMA_ID = ESC.ESC_DMA_ID
AND IT.[Year] = esc.ESC_Year
AND IT.[Quarter] = esc.ESC_Quarter
AND VD.ProductLineID = esc.ESC_BUM_ID
GO


