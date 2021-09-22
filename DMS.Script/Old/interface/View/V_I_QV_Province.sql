DROP view [interface].[V_I_QV_Province]
GO

CREATE view [interface].[V_I_QV_Province]
as
select
Id=Territory.TER_ID,
ProvinceID=Territory.TER_ID,
Name_CN=TER_Description,
Name_EN=TER_EName,
status=1
from Territory
where TER_Type='Province'
GO


