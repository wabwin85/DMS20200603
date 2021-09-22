DROP PROC [interface].[P_Stage_I_QV_V_AllHospitalMarketProperty]
GO

CREATE PROC [interface].[P_Stage_I_QV_V_AllHospitalMarketProperty]
AS
BEGIN

TRUNCATE TABLE interface.Stage_V_AllHospitalMarketProperty

INSERT INTO interface.Stage_V_AllHospitalMarketProperty(
	Hos_Id
	, Hos_Name
	, Hos_Code
	, ProductLineID
	, ProductLineName
	, DivisionCode
	, DivisionName
	, MarketProperty
	, MarketName
	, HosRelation
	)
SELECT Hos_Id
	, Hos_Name
	, Hos_Code
	, ProductLineID
	, ProductLineName
	, DivisionCode
	, DivisionName
	, MarketProperty
	, MarketName
	, HosRelation
FROM V_AllHospitalMarketProperty

END
GO


