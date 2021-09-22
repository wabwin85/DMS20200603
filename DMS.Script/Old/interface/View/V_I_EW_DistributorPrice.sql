DROP VIEW [interface].[V_I_EW_DistributorPrice]
GO

CREATE VIEW [interface].[V_I_EW_DistributorPrice]
AS
   SELECT DISTINCT
          DealerMaster.DMA_SAP_Code AS CustomerSapCode,
          CFN.CFN_Property1 AS UPN,
          CFNPrice.CFNP_Price AS Price
     FROM CFNPrice(nolock)
          INNER JOIN CFN(nolock) ON CFNPrice.CFNP_CFN_ID = CFN.CFN_ID
          INNER JOIN DealerMaster(nolock)
             ON CFNPrice.CFNP_Group_ID = DealerMaster.DMA_ID
    WHERE CFNPrice.CFNP_PriceType = 'Dealer'
     and DealerMaster.DMA_DealerType in ('LP','T1')
GO


