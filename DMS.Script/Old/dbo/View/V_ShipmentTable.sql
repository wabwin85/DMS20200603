DROP view [dbo].[V_ShipmentTable]
GO


create view [dbo].[V_ShipmentTable]
as 
SELECT SPH_ID as Id,
CFN_CustomerFaceNbr as '产品型号',
CFN_ChineseName as '产品中文名',
CFN_EnglishName as '产品英文名',
SPL_ShipmentQty as '数量'
FROM ShipmentHeader,
ShipmentLine,
ShipmentLot,
Product,
CFN
WHERE SPH_ID = SPL_SPH_ID
and SPL_ID = SLT_SPL_ID
and SPL_Shipment_PMA_ID = PMA_ID
and PMA_CFN_ID = CFN_ID



GO


