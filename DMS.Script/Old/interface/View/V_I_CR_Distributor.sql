DROP view [interface].[V_I_CR_Distributor]
GO



CREATE view [interface].[V_I_CR_Distributor] AS
SELECT DealerID=DMA_ID
      ,Name_CN=DMA_ChineseName
      ,Name_EN=DMA_EnglishName
      ,SAPID=DMA_SAP_Code
      ,[Status]=DMA_ActiveFlag
      ,ParentDealerID=case when DMA_DealerType='T2' then DMA_Parent_DMA_ID else null end
      ,IsPurchased=[dbo].[fn_GetPurchaseCount](DMA_ID)
  FROM DealerMaster
  
  --WHERE DMA_DeletedFlag = 0 AND DMA_HostCompanyFlag = 0


GO


