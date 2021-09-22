DROP view [interface].[V_I_CR_DealerPrice]
GO


CREATE view [interface].[V_I_CR_DealerPrice]
as

SELECT DealerMaster.DMA_SAP_Code AS SAPID, 
CFN.CFN_CustomerFaceNbr AS UPN,
CFN.CFN_ChineseName AS ChineseName,
CFN.CFN_Property3 AS UOM,
CFNPrice.CFNP_Price AS Price,
CFNP_PriceType
FROM CFNPrice
INNER JOIN CFN ON CFN.CFN_ID = CFNPrice.CFNP_CFN_ID
INNER JOIN DealerMaster ON DealerMaster.DMA_ID = CFNPrice.CFNP_Group_ID
WHERE
-- CFNPrice.CFNP_PriceType = 'Dealer'
--and CFNP_CanOrder=1 and 
CFNP_DeletedFlag=0

GO


