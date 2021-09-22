DROP view [interface].[V_I_QV_ProductShare] 
GO

create view [interface].[V_I_QV_ProductShare] AS
select C.CFN_CustomerFaceNbr AS UPN, C.CFN_ProductLine_BUM_ID AS ProductLineID, CS.CFNS_BUM_ID AS ShareProductLineID
from cfnshare AS CS , cfn AS C
where CFNS_BUM_ID not in ('dd1b6adf-3772-4e4a-b9cc-a2b900b5f935')
and CS.CFNS_CFN_ID=C.CFN_ID
GO


