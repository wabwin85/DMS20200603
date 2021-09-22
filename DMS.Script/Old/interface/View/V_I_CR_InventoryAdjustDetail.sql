DROP VIEW [interface].[V_I_CR_InventoryAdjustDetail]
GO




CREATE VIEW [interface].[V_I_CR_InventoryAdjustDetail]
AS
SELECT DMA_ChineseName,
         DMA_EnglishName,
         DMA_SAP_Code,
         IAH_Inv_Adj_Nbr,
         CONVERT (VARCHAR (10), IAH_ApprovalDate, 120) AS IAH_ApprovalDate,
         Lafite_DICT.VALUE1 AS AdjustTypeName,
         View_ProductLine.Attribute_Name AS ProductLineName,
         CFN_CustomerFaceNbr AS UPN,
         CFN_ChineseName,         
         IAL_LotNumber  LTM_LotNumber,
         CASE WHEN CFN_Property6 = '1' THEN CONVERT (VARCHAR (10), IAL_ExpiredDate, 120)
         WHEN CFN_Property6 = '0' THEN CONVERT (NVARCHAR (7), IAL_ExpiredDate, 120) END AS LTM_ExpiredDate,
         IAL_LotQty
         --,InventoryAdjustHeader.IAH_UserDescription
    FROM InventoryAdjustHeader
         INNER JOIN InventoryAdjustDetail
            ON InventoryAdjustDetail.IAD_IAH_ID = InventoryAdjustHeader.IAH_ID
         INNER JOIN InventoryAdjustLot
            ON InventoryAdjustLot.IAL_IAD_ID = InventoryAdjustDetail.IAD_ID
         INNER JOIN DealerMaster
            ON DealerMaster.DMA_ID = InventoryAdjustHeader.IAH_DMA_ID
         INNER JOIN Lafite_DICT
            ON DICT_TYPE = 'CONST_AdjustQty_Type' AND DICT_KEY = InventoryAdjustHeader.IAH_Reason
         INNER JOIN Product
            ON Product.PMA_ID = InventoryAdjustDetail.IAD_PMA_ID
         INNER JOIN CFN
            ON CFN.CFN_ID = Product.PMA_CFN_ID
         INNER JOIN View_ProductLine
            ON View_ProductLine.Id = InventoryAdjustHeader.IAH_ProductLine_BUM_ID
         --INNER JOIN Lot
         --   ON Lot.LOT_ID = InventoryAdjustLot.IAL_LOT_ID
         --INNER JOIN LotMaster
         --   ON LotMaster.LTM_ID = Lot.LOT_LTM_ID
   WHERE     (IAH_Status = 'Submit' OR IAH_Status = 'Accept')



GO


