DROP view [interface].[V_I_QV_PromotionSummary] 
GO


CREATE view [interface].[V_I_QV_PromotionSummary] AS

SELECT PRCode,b.PRName,a.Division,dealerId,SAPCode,DealerName,a.SumAvaliableQty,a.AvaliableQty,a.UsedQty,IsActive FROM [interface].[T_I_QV_PromotionSummary] a
LEFT JOIN  PromotionPolicy b on a.PRCode=b.PMP_Code




GO


