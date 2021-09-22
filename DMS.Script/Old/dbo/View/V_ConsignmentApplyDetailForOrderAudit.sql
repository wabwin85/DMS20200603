DROP view [dbo].[V_ConsignmentApplyDetailForOrderAudit]
GO

create view [dbo].[V_ConsignmentApplyDetailForOrderAudit] AS
select C.CFN_CustomerFaceNbr As UPN, C.CFN_ChineseName, C.CFN_EnglishName, convert(int, D.CAD_Qty) AS Qty,H.CAH_CM_Type, H.CAH_CM_DelayNumber AS CanDelayNum, H.CAH_CM_ConsignmentDay,H.CAH_CM_ConsignmentName,H.CAH_OrderNo
from ConsignmentApplyHeader H(nolock) , ConsignmentApplyDetails D(nolock), CFN C(nolock)
where H.CAH_ID=D.CAD_CAH_ID and D.CAD_CFN_ID = C.CFN_ID
GO


