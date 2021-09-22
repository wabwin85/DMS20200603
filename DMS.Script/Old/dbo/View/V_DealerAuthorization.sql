
DROP view [dbo].[V_DealerAuthorization]
GO










CREATE view [dbo].[V_DealerAuthorization]
as
	--select 
 --       DMA_ID,DMA_SAP_Code,DMA_ChineseName,DCL_StopDate,
 --       ATTRIBUTE_NAME as ProductLine,Id,DMA_DealerType
 --  from DealerAuthorizationTable (nolock ) dat 
	--	inner join DealerMaster ( nolock) dma on dma.DMA_ID =dat.DAT_DMA_ID
	--	inner join DealerContract dct on dat .DAT_DCL_ID =dct.DCL_ID
	--	left join View_ProductLine on Id=dat.DAT_ProductLine_BUM_ID
  --where 
  --      --DMA_ActiveFlag=1 and DMA_DeletedFlag=0 and 
	 --   DMA_Parent_DMA_ID='FB62D945-C9D7-4B0F-8D26-4672D2C728B7'
        --and DCL_StopDate>=GETDATE()
        
        	select distinct
        PRCode, DMA_ID,DMA_SAP_Code,
        Id as ProductLineId,DMA_DealerType
       ,ParentSAPID=(select DMA_SAP_Code from DealerMaster b(nolock) where b.DMA_ID=dma.DMA_Parent_DMA_ID)
       ,DMA_Parent_DMA_ID
       ,EndDate
       ,CreateTime=GETDATE()
       
   from DealerAuthorizationTable (nolock ) dat 
		inner join DealerMaster  ( nolock) dma on dma.DMA_ID =dat.DAT_DMA_ID 
		inner join DealerContract ( nolock) dct on dat .DAT_DCL_ID =dct.DCL_ID
		left join View_ProductLine on Id=dat.DAT_ProductLine_BUM_ID
		join interface.T_I_EW_PromotionRules(nolock) on ProductLineId=Id
   where dma.DMA_SAP_Code!='BSC'









GO


