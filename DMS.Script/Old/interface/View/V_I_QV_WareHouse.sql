DROP view [interface].[V_I_QV_WareHouse]
GO



CREATE view [interface].[V_I_QV_WareHouse]

as

select WHM_ID,
	WHM_Code,
	WHM_Name,
	WHM_Type,
	VALUE1 as WHM_TypeName,
	WHM_DMA_ID as DealerID,
	HOS_Key_Account as DMSCode,
	WHM_Address,
	WHM_Province,
	WHM_City,
	WHM_District,
	WHM_Town,
	WHM_PostalCode,
	WHM_Phone,
	WHM_Fax,
	WHM_ActiveFlag,
	WHM_HoldWarehouse,
	DMA_SAP_Code AS SAPID
from Warehouse
left join Hospital on WHM_Hospital_HOS_ID=HOS_Id
left join Lafite_DICT on DICT_TYPE = 'MS_WarehouseType' AND DICT_KEY = Warehouse.WHM_Type
LEFT JOIN DealerMaster on WHM_DMA_ID=DMA_ID


 


GO


