DROP proc [interface].[p_i_cr_Distributor]
GO




CREATE proc [interface].[p_i_cr_Distributor]
as

DELETE from interface.T_I_CR_Distributor

Insert into interface.T_I_CR_Distributor
SELECT DealerID=DMA_ID
      ,Name_CN=DMA_ChineseName
      ,Name_EN=DMA_EnglishName
      ,SAPID=DMA_SAP_Code
      ,[Status]=DMA_ActiveFlag
      ,ParentDealerID=case when DMA_DealerType='T2' then DMA_Parent_DMA_ID else null end
  FROM DealerMaster
  WHERE DMA_DeletedFlag = 0 AND DMA_HostCompanyFlag = 0
  



GO


