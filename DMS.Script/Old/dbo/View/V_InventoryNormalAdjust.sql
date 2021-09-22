DROP view [dbo].[V_InventoryNormalAdjust]
GO


CREATE view [dbo].[V_InventoryNormalAdjust]
as
select dbo.InventoryAdjustHeader.IAH_ID as Id,
 d1.DMA_ChineseName AS '经销商名称', 
 d1.DMA_SAP_Code AS '经销商SAP编号', 
 dbo.View_ProductLine.ATTRIBUTE_NAME AS '产品线',
 dbo.InventoryAdjustHeader.IAH_Inv_Adj_Nbr AS '申请单号', 
 dbo.Lafite_DICT.VALUE1 AS '单据类型',
  (SELECT SUM(ISNULL(InventoryAdjustLot.IAL_LotQty,0))  FROM InventoryAdjustDetail INNER JOIN InventoryAdjustLot
      ON InventoryAdjustDetail.IAD_ID=InventoryAdjustLot.IAL_IAD_ID
      where InventoryAdjustDetail.IAD_IAH_ID=dbo.InventoryAdjustHeader.IAH_ID) AS '退货总数量',
    (SELECT  CONVERT(decimal(18,2) ,SUM(ISNULL(InventoryAdjustLot.IAL_UnitPrice,0)*ISNULL(InventoryAdjustLot.IAL_LotQty,0)))  FROM InventoryAdjustDetail INNER JOIN InventoryAdjustLot
      ON InventoryAdjustDetail.IAD_ID=InventoryAdjustLot.IAL_IAD_ID
      where InventoryAdjustDetail.IAD_IAH_ID=dbo.InventoryAdjustHeader.IAH_ID) AS '含税总金额', 
        (SELECT CONVERT(decimal(18,2) ,SUM(ISNULL(InventoryAdjustLot.IAL_UnitPrice,0)*ISNULL(InventoryAdjustLot.IAL_LotQty,0))/1.17) FROM InventoryAdjustDetail INNER JOIN InventoryAdjustLot
      ON InventoryAdjustDetail.IAD_ID=InventoryAdjustLot.IAL_IAD_ID
      where InventoryAdjustDetail.IAD_IAH_ID=dbo.InventoryAdjustHeader.IAH_ID) AS '不含税总金额' ,
      DT.VALUE1 AS '退货类型',
      DTR.VALUE1 as '退货原因',
      dbo.InventoryAdjustHeader.IAH_UserDescription AS '备注'
  FROM         dbo.InventoryAdjustHeader INNER JOIN
               dbo.View_ProductLine ON dbo.InventoryAdjustHeader.IAH_ProductLine_BUM_ID = dbo.View_ProductLine.Id 
               INNER JOIN dbo.DealerMaster AS d1 ON dbo.InventoryAdjustHeader.IAH_DMA_ID = d1.DMA_ID INNER JOIN
               dbo.Lafite_DICT ON dbo.InventoryAdjustHeader.IAH_Reason = dbo.Lafite_DICT.DICT_KEY 
                LEFT JOIN dbo.Lafite_DICT DT ON  dbo.InventoryAdjustHeader.IAH_ApplyType= DT.DICT_KEY
                AND DT.DICT_TYPE='CONST_AdjustRenturn_Type'
                LEFT JOIN dbo.Lafite_DICT DTR ON  dbo.InventoryAdjustHeader.RetrunReason= DTR.DICT_KEY
                AND DTR.DICT_TYPE='CONST_AdjustRenturn_Reason'
WHERE     (dbo.Lafite_DICT.DICT_TYPE = 'CONST_AdjustQty_Type') AND (dbo.InventoryAdjustHeader.IAH_Status <> 'Draft')

GO


