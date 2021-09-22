
DROP VIEW [Promotion].[V_PRO_FORECAST]
GO



CREATE VIEW [Promotion].[V_PRO_FORECAST]
AS 
SELECT DLid,DealerId,BU,largessAmount Amount,CREATETIME DateStamp 
FROM Promotion.PRO_FORECAST A WHERE largessAmount <>0
GO


