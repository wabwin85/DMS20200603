DROP VIEW [interface].[V_I_QV_PRO_FORECAST_DEALER]
GO



CREATE VIEW [interface].[V_I_QV_PRO_FORECAST_DEALER]
AS 
SELECT DLid,dm.DMA_SAP_Code AS SAPID
	,BU,largessAmount Amount,CREATETIME DateStamp 
FROM Promotion.PRO_FORECAST_DEALER A 
INNER JOIN dbo.DealerMaster dm
	ON a.DEALERID=dm.DMA_ID
WHERE largessAmount <>0


GO


