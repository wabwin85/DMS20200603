DROP view [dbo].[V_Shipment]
GO

create view [dbo].[V_Shipment]
as 
SELECT SPH_ID as Id,
d1.DMA_ChineseName as '����������',
d1.DMA_SAP_Code as '������SAP���',
View_ProductLine.ATTRIBUTE_NAME as '��Ʒ��',
SPH_ShipmentNbr as '���뵥��',
VALUE1 as '��������',
HOS_HospitalName as '����ҽԺ',
SPH_ShipmentDate as '����ʱ��'
FROM ShipmentHeader,
View_ProductLine,
DealerMaster d1,
Lafite_DICT,
Hospital
WHERE SPH_ProductLine_BUM_ID = View_ProductLine.Id
and SPH_Dealer_DMA_ID = d1.DMA_ID
and SPH_Type = DICT_KEY
and SPH_Hospital_HOS_ID = HOS_ID
and DICT_TYPE = 'Consts_ShipmentOrder_Type'
and SPH_Status <> 'Draft'


GO


