DROP VIEW [interface].[V_I_QV_DealerPrice]
GO


CREATE VIEW [interface].[V_I_QV_DealerPrice]
AS 
SELECT pr.CFNP_ID as PriceID
	,dm.DMA_SAP_Code AS SAPID
	,pd.CFN_CustomerFaceNbr AS UPN
	,pr.CFNP_ValidDateFrom AS ValidFrom
	,pr.CFNP_ValidDateTo AS ValidTo
	,pr.CFNP_Price as Price
	,pr.CFNP_Currency as Currency
	,pr.CFNP_UOM as UOM
	,pr.CFNP_CreateDate AS CreateDate
FROM bsc_prd.dbo.CFNPrice pr
INNER JOIN dbo.CFN pd
	ON pr.CFNP_CFN_ID = pd.CFN_ID
INNER JOIN dbo.DealerMaster dm
	ON pr.CFNP_Group_ID = dm.DMA_ID
WHERE CFNP_PriceType = 'Dealer'
GO


