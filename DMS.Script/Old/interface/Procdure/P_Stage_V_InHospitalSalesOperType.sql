DROP PROC [interface].[P_Stage_V_InHospitalSalesOperType]
GO

CREATE PROC [interface].[P_Stage_V_InHospitalSalesOperType]

AS


TRUNCATE TABLE Interface.Stage_V_InHospitalSalesOperType


INSERT INTO Interface.Stage_V_InHospitalSalesOperType
SELECT t1.SPH_ID
	,max(t2.POL_OperType) AS OperType
FROM ShipmentHeader t1(NOLOCK)
	,PurchaseOrderLog t2(NOLOCK)
WHERE t1.SPH_ID = t2.POL_POH_ID
	AND t2.POL_OperType IN (
		'Generate'
		,'CreateShipment'
		,'Submit'
		)
GROUP BY t1.SPH_ID


TRUNCATE TABLE [interface].[Stage_V_LPSalesImportDate]

INSERT INTO [interface].[Stage_V_LPSalesImportDate]
SELECT SCH_SalesNo,max(SCH_ImportDate) from ShipmentLPConfirmHeader
group BY SCH_SalesNo

GO


