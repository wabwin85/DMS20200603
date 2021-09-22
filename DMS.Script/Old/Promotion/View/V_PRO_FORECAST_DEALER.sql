DROP VIEW [Promotion].[V_PRO_FORECAST_DEALER]
GO


CREATE VIEW [Promotion].[V_PRO_FORECAST_DEALER]
AS 
SELECT DLid,DealerId,BU,largessAmount Amount,CREATETIME DateStamp 
FROM Promotion.PRO_FORECAST_DEALER A WHERE largessAmount <>0

GO


