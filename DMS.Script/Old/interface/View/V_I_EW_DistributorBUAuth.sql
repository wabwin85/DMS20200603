
DROP VIEW [interface].[V_I_EW_DistributorBUAuth]
GO

CREATE VIEW [interface].[V_I_EW_DistributorBUAuth]
AS
   SELECT DISTINCT dm.dma_chinesename,
                   dm.DMA_SAP_Code,
                   bu.ProductLineID AS ProductLineID,
                   bu.ProductLineName AS ProductLineName,
                   bu.DivisionName,
                   dcm.Division DivisionCode,
                   dm.DMA_DealerType,
                   dcm.MarketTypeName
     FROM V_DealerContractMaster dcm(nolock),
          dealermaster dm(nolock),
          V_DivisionProductLineRelation bu(nolock)
    WHERE     dcm.DMA_ID = dm.DMA_ID
          AND dcm.ActiveFlag = '1'
          AND CONVERT (NVARCHAR (10), dcm.Division) = bu.DivisionCode
          AND bu.IsEmerging = '0'
          AND LEN (dm.DMA_SAP_Code) < 7
          AND dm.DMA_DealerType <> 'T2'
          AND dcm.MarketType <> '1'
GO


