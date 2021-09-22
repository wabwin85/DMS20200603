DROP view [interface].[V_I_QV_Division]
GO

create view [interface].[V_I_QV_Division]
as
select 
a.Division ,
DivisionID,
Name_CN,
ShortName=DIV
from interface.T_I_QV_Division a
left join interface.T_I_CR_Division b on a.Division=b.Division


GO


