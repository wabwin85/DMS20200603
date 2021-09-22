DROP view [interface].[V_I_QV_PurchasePrice]

GO







CREATE view [interface].[V_I_QV_PurchasePrice]

as 
		select 
			ID=CFNP_ID
			,UPN=CFN_CustomerFaceNbr
			,DealerID=CFNP_Group_ID
			,PriceTypeID
			,PriceType=CFNP_PriceType
			,PurchasePrice=CFNP_Price/1.17
			,CreateDate=CFNP_CreateDate
			,[Year]= YEAR(GETDATE())
			,[Month]=MONTH(GETDATE())
			,DMA_SAP_Code AS SAPID
	    from CFNPrice(nolock) 
		left join CFN(nolock) on CFN_ID=CFNP_CFN_ID
		left join interface.T_I_QV_PriceType(nolock)  on CFNP_PriceType=PriceType
		INNER JOIN dbo.DealerMaster(NOLOCK) dm ON CFNPrice.CFNP_Group_ID=dm.DMA_ID
        where CFNP_DeletedFlag=0 





GO


