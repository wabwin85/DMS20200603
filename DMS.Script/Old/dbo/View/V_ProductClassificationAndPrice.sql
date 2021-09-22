DROP VIEW [dbo].[V_ProductClassificationAndPrice]
GO






CREATE VIEW [dbo].[V_ProductClassificationAndPrice]
AS
SELECT PCT_ID ID,PCT_ProductLine_ID as ProductLine_ID,PCT_Code Code,PCT_NameCN NameCN,PCT_NameEN NameEN, PC.PCP_ID as PriceID,PC.PCP_Year AS PriceYear,PC.PCP_Price as PriceAmount,PC.PCP_Rebate as PriceRebate,PC.PCP_Rv1 as PriceRv1,PC.PCP_Rv2 PriceRv2,PC.PCP_Rv3 PriceRv3,PCT_ParentClassification_PCT_ID ParentClassification_PCT_ID,	PCT_Active Active,	PCT_Rv1 Rv1,	PCT_Rv2 Rv2,PCT_Rv3 Rv3
FROM ProductClassification P(nolock)
LEFT JOIN ProductClassificationPrice PC(nolock) ON P.PCT_ID=PC.PCP_PCT_ID



GO


