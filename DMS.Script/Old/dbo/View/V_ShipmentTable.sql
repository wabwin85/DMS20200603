DROP view [dbo].[V_ShipmentTable]
GO


create view [dbo].[V_ShipmentTable]
as 
SELECT SPH_ID as Id,
CFN_CustomerFaceNbr as '��Ʒ�ͺ�',
CFN_ChineseName as '��Ʒ������',
CFN_EnglishName as '��ƷӢ����',
SPL_ShipmentQty as '����'
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


