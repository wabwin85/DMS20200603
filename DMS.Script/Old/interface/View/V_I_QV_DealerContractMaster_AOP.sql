DROP VIEW [interface].[V_I_QV_DealerContractMaster_AOP]
GO



Create VIEW [interface].[V_I_QV_DealerContractMaster_AOP]
AS
SELECT DCM_ID ID,
       DCM_DMA_ID DMA_ID,
       DCM_DealerType DealerType,
       DCM_Division Division,
       DCM_CC_ID  CC_ID,
       DCM_MarketType MarketType,
       MarketTypeName MarketTypeName,
       DCM_ContractType ContractType,
       DCM_BSCEntity BSCEntity,
       DCM_Exclusiveness Exclusiveness,
       DCM_FirstContractDate FirstContractDate,
       DCM_EffectiveDate EffectiveDate,
       DCM_ExpirationDate ExpirationDate,
       DCM_TerminationDate TerminationDate,
       DCM_ExtensionDate ExtensionDate,
       DCM_ProductLine ProductLine,
       DCM_ProductLineRemark ProductLineRemark,
       DCM_Pricing Pricing,
       DCM_Pricing_Discount Pricing_Discount,
       DCM_Pricing_Discount_Remark Pricing_Discount_Remark,
       DCM_Pricing_Rebate Pricing_Rebate,
       DCM_Pricing_Rebate_Remark Pricing_Rebate_Remark,
       DCM_Credit_Limit Credit_Limit,
       DCM_Credit_Term Credit_Term,
       DCM_Payment_Term Payment_Term,
       DCM_Security_Deposit Security_Deposit,
       DCM_Guarantee Guarantee,
       DCM_GuaranteeRemark GuaranteeRemark,
       DCM_Attachment Attachment,
       DCM_Update_Date Update_Date,
	   MinDate ,
       CASE
          WHEN CONVERT (NVARCHAR (10), MinDate, 112) <
                  CONVERT (NVARCHAR (10), GETDATE (), 112)
          THEN
             0
          ELSE
             1
       END
          ActiveFlag,
		DCM_ThirdPartyUser AS ThirdPartyUser,
		DCM_ThirdPartyPosition AS ThirdPartyPosition,
		DCM_ThirdPartyDate AS ThirdPartyDate
  FROM (SELECT DCM_ID ,
       DCM_DMA_ID ,
       DCM_DealerType,
       DCM_Division,
       DCM_CC_ID,
       DCM_MarketType,
       MarketTypeName ,
       DCM_ContractType ,
       DCM_BSCEntity ,
       DCM_Exclusiveness ,
       DCM_FirstContractDate ,
       DCM_EffectiveDate ,
       DCM_ExpirationDate ,
       DCM_TerminationDate ,
       DCM_ExtensionDate,
       DCM_ProductLine ,
       DCM_ProductLineRemark ,
       DCM_Pricing ,
       DCM_Pricing_Discount ,
       DCM_Pricing_Discount_Remark ,
       DCM_Pricing_Rebate ,
       DCM_Pricing_Rebate_Remark ,
       DCM_Credit_Limit ,
       DCM_Credit_Term ,
       DCM_Payment_Term ,
       DCM_Security_Deposit ,
       DCM_Guarantee ,
       DCM_GuaranteeRemark ,
       DCM_Attachment ,
       DCM_Update_Date ,
	   CASE
          WHEN  DCM_ExtensionDate IS NULL
			  THEN
				MinDate
          WHEN
            CONVERT (NVARCHAR (10),DCM_ExtensionDate , 112) > CONVERT (NVARCHAR (10), MinDate,112)
			  THEN
				DCM_ExtensionDate 
		  ELSE
			MinDate END AS MinDate,
			DCM_ThirdPartyUser,
			DCM_ThirdPartyPosition,
			DCM_ThirdPartyDate
  FROM(SELECT DCM_ID,
               DCM_DMA_ID,
               DCM_DealerType,
               DCM_Division,
               DCM_CC_ID,
               DCM_MarketType,
               CASE ISNULL (DCM_MarketType, 0)
                  WHEN 0 THEN '普通市场'
                  WHEN 1 THEN '新兴市场'
               END
                  AS MarketTypeName,
               DCM_ContractType,
               DCM_BSCEntity,
               DCM_Exclusiveness,
               CASE 
               WHEN DCM_FristCooperationDate IS NULL AND DCM_FirstContractDate IS NOT NULL
				THEN DCM_FirstContractDate 
               WHEN DCM_FristCooperationDate IS NOT NULL AND  DCM_FirstContractDate  IS NULL
				THEN DCM_FristCooperationDate 
               WHEN DCM_FristCooperationDate IS NULL  AND DCM_FirstContractDate  IS NULL
				THEN DCM_EffectiveDate
               ELSE
				CASE WHEN CONVERT(NVARCHAR(10),DCM_FirstContractDate,112)>CONVERT(NVARCHAR(10),DCM_FristCooperationDate,112)
				THEN DCM_FristCooperationDate
				ELSE DCM_FirstContractDate
				END
			   End
			   AS  DCM_FirstContractDate
               ,
               --DCM_FirstContractDate,
               DCM_EffectiveDate,
               DCM_ExpirationDate,
               DCM_TerminationDate,
               DCM_ProductLine,
               DCM_ProductLineRemark,
               DCM_Pricing,
               DCM_Pricing_Discount,
               DCM_Pricing_Discount_Remark,
               DCM_Pricing_Rebate,
               DCM_Pricing_Rebate_Remark,
               DCM_Credit_Limit,
               DCM_Credit_Term,
               DCM_Payment_Term,
               DCM_Security_Deposit,
               DCM_Guarantee,
               DCM_GuaranteeRemark,
               DCM_Attachment,
               DCM_Delete_flag,
               DCM_Update_Date,
               CASE
                  WHEN CONVERT (NVARCHAR (10), DCM_ExpirationDate, 112) >
                          CONVERT (
                             NVARCHAR (10),
                             ISNULL (DCM_TerminationDate, DCM_ExpirationDate),
                             112)
                  THEN
                     DCM_TerminationDate
                  ELSE
                     DCM_ExpirationDate
               END
                  AS MinDate,
                  DCM_ExtensionDate,
                  DCM_ThirdPartyUser,
                  DCM_ThirdPartyPosition,
                  DCM_ThirdPartyDate
          FROM DealerContractMaster with(nolock) ) TAB) TAB2




GO


