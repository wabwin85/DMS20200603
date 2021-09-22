DROP view [interface].[V_I_QV_Lafite_ATTRIBUTE]
GO




CREATE view [interface].[V_I_QV_Lafite_ATTRIBUTE]
as

select ID,convert(nvarchar(100),ATTRIBUTE_Type) as ATTRIBUTE_Type, convert(nvarchar(100),ATTRIBUTE_NAME) as RoleName,convert(nvarchar(100),DESCRIPTION) as  RoleDesc,
BOOLEAN_FLAG,DELETE_FLAG
from BSC_Prd.dbo.Lafite_ATTRIBUTE 



GO


