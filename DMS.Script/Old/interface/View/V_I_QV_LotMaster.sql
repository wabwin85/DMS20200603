DROP VIEW [interface].[V_I_QV_LotMaster]
GO


CREATE VIEW [interface].[V_I_QV_LotMaster]
AS
SELECT UPN
	,LOT
	,ExpDate
	,DOM
	,MIN(CreateDT) AS CreateDT
FROM [interface].[V_I_QV_LotMaster_WithQR]
GROUP BY UPN
	,LOT
	,ExpDate
	,DOM

GO


