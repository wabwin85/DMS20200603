DROP view [dbo].[V_Shipment]
GO

create view [dbo].[V_Shipment]
as 
SELECT SPH_ID as Id,
d1.DMA_ChineseName as '经销商名称',
d1.DMA_SAP_Code as '经销商SAP编号',
View_ProductLine.ATTRIBUTE_NAME as '产品线',
SPH_ShipmentNbr as '申请单号',
VALUE1 as '单据类型',
HOS_HospitalName as '销售医院',
SPH_ShipmentDate as '销售时间'
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


