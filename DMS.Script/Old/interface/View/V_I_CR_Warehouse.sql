DROP view [interface].[V_I_CR_Warehouse]
GO

create view [interface].[V_I_CR_Warehouse] AS 
  SELECT [DealerID]=WHM_DMA_ID
      ,[WarehouseID]=WHM_ID
      ,[WarehouseName]=ISNULL(WHM_Name,'')
      ,[HospitalID]=WHM_Hospital_HOS_ID
  FROM dbo.Warehouse
  WHERE WHM_ActiveFlag = 1
GO


