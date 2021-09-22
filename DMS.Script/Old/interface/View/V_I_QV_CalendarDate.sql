
DROP VIEW [interface].[V_I_QV_CalendarDate]
GO

CREATE VIEW [interface].[V_I_QV_CalendarDate]
AS

SELECT CDD_Calendar
	,CDD_Date1
	,CDD_Date2
	,CDD_Date3
	,CDD_Date4
	,CDD_Date5
	,CDD_Date6
	,CDD_Date7
	,CDD_Date8
	,CDD_Date9
	,CDD_Date10
FROM dbo.CalendarDate
GO


