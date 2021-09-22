DROP proc [interface].[p_i_cr_Warehouse]
GO

CREATE proc [interface].[p_i_cr_Warehouse]
as

DELETE from interface.T_I_CR_Warehouse

Insert into interface.T_I_CR_Warehouse
SELECT [DealerID]=WHM_DMA_ID
      ,[WarehouseID]=WHM_ID
      ,[WarehouseName]=ISNULL(WHM_Name,'')
      ,[HospitalID]=WHM_Hospital_HOS_ID
  FROM dbo.Warehouse
  WHERE WHM_ActiveFlag = 1
GO


