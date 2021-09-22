DROP view [interface].[V_I_CR_InventoryAdjustStatistics]
GO




--其他出入库月统计
CREATE view [interface].[V_I_CR_InventoryAdjustStatistics]
as
     
          select 
			  DMA_SAP_Code,
			  DMA_ChineseName,
			  DMA_DealerType,
			  convert(nvarchar(7),IAH_CreatedDate,121) as IAHMonth,
			  isnull(SUM(InventoryAdjustDetail.IAD_Quantity),0) as AdjustQty
          from InventoryAdjustHeader
          left join InventoryAdjustDetail on IAD_IAH_ID = InventoryAdjustHeader.IAH_ID
          left join DealerMaster on IAH_DMA_ID=DMA_ID
            WHERE 
           IAH_WarehouseType = 'Normal' and
          IAH_Status = 'Submit'
            AND IAH_Reason <> 'Return'
          group by DMA_SAP_Code,DMA_ChineseName,DMA_DealerType,
          convert(nvarchar(7),IAH_CreatedDate,121) 
      




GO


