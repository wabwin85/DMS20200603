DROP view [interface].[V_I_QV_City]
GO

Create view [interface].[V_I_QV_City]
as
select 
CityID=Territory.TER_ID,
Name_CN=TER_Description,
Name_EN=TER_EName,
ProvinceID=TER_ParentId,
status=1
from Territory
where TER_Type='City'
GO


