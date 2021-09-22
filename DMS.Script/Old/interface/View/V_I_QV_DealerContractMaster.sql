DROP VIEW [interface].[V_I_QV_DealerContractMaster]
GO


CREATE VIEW [interface].[V_I_QV_DealerContractMaster]
AS

SELECT [DCM_ID]
      ,[DCM_DMA_ID]
      ,[DCM_DealerType]
      ,[DCM_Division]
      ,[DCM_MarketType]
      ,[DCM_ContractType]
      ,[DCM_BSCEntity]
      ,[DCM_Exclusiveness]
      ,[DCM_EffectiveDate]
      ,[DCM_ExpirationDate]
      ,[DCM_ProductLine]
      ,[DCM_ProductLineRemark]
      ,[DCM_Pricing]
      ,[DCM_Pricing_Discount]
      ,[DCM_Pricing_Discount_Remark]
      ,[DCM_Pricing_Rebate]
      ,[DCM_Pricing_Rebate_Remark]
      ,[DCM_Credit_Limit]
      ,[DCM_Credit_Term]
      ,[DCM_Payment_Term]
      ,[DCM_Security_Deposit]
      ,[DCM_Guarantee]
      ,[DCM_GuaranteeRemark]
      ,[DCM_Attachment]
      ,[DCM_Delete_flag]
      ,[DCM_Update_Date]
      ,[DCM_TerminationDate]
      ,[DCM_ActiveFlag]
      --, DCM.FirstContractDate AS [DCM_FirstContractDate]
      ,(select TOP 1 D.FirstContractDate from V_DealerContractMaster D WHERE D.DMA_ID=DCM.DMA_ID AND D.Division=DCM.Division ORDER BY D.FirstContractDate ASC) AS [DCM_FirstContractDate]
      ,[DCM_ExtensionDate]
      ,[CC_Code] AS SubBUCode
      ,[CC_NameCN] AS SubBUName
      ,DCM.MinDate AS Mindate
      ,DCM.ActiveFlag AS ActiveFlag
	  ,cfa.EID AS ApplicantID
	  ,DMA_SAP_Code AS SAPID
  FROM [dbo].[DealerContractMaster] a with(nolock)
  INNER JOIN V_DealerContractMaster DCM ON DCM.ID=A.DCM_ID
  LEFT JOIN interface.ClassificationContract b(nolock) on a.DCM_CC_ID=b.CC_ID
  LEFT JOIN dbo.DealerMaster DM ON a.[DCM_DMA_ID]=DM.DMA_ID
  LEFT JOIN [Contract].[Func_GetApplicant]() cfa on DM.DMA_SAP_Code=cfa.SAPID and [CC_Code]=cfa.SubDepID
  where ISNULL(DM.DMA_Taxpayer,'')<>'直销医院'

GO


