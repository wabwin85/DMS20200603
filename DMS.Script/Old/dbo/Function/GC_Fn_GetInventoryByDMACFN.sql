DROP FUNCTION [dbo].[GC_Fn_GetInventoryByDMACFN]
GO

CREATE FUNCTION [dbo].[GC_Fn_GetInventoryByDMACFN] (@DMA_ID UNIQUEIDENTIFIER, @CFN_ID UNIQUEIDENTIFIER)
   RETURNS INTEGER
AS
   BEGIN
      DECLARE @INV_Qty   INTEGER
      SET @INV_Qty = 0
        SELECT @INV_Qty = sum (isnull (INV_Qty, 0))
          FROM (SELECT CFN.CFN_ID,
                       DM.DMA_ID,
                       PD.PMA_UPN AS PDUPN,
                       PD.PMA_Name AS PDName,
                       WH.WHM_Name AS WHName,
                       WH.WHM_Type,
                       INV.INV_OnHandQuantity AS INV_Qty
                  FROM CFN,
                       DealerMaster AS DM,
                       Product AS PD,
                       Warehouse AS WH,
                       Inventory INV
                 WHERE     PD.PMA_CFN_ID = CFN.CFN_ID
                       AND PD.PMA_ID = INV.INV_PMA_ID
                       AND DM.DMA_ID = WH.WHM_DMA_ID
                       AND INV.INV_WHM_ID = wH.WHM_ID
                       AND WH.WHM_Type <> 'SystemHold'
                       AND DM.DMA_ID = @DMA_ID
                       AND CFN.CFN_ID = @CFN_ID) AS InvertoryGroup
      GROUP BY CFN_ID, DMA_ID
      RETURN @INV_Qty
   END
GO


