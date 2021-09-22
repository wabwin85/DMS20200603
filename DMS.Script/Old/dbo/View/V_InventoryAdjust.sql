DROP view [dbo].[V_InventoryAdjust]
GO



CREATE view [dbo].[V_InventoryAdjust]
as
select dbo.InventoryAdjustHeader.IAH_ID as Id,
 d1.DMA_ChineseName AS '����������', 
 d1.DMA_SAP_Code AS '������SAP���', 
 dbo.View_ProductLine.ATTRIBUTE_NAME AS '��Ʒ��',
 dbo.InventoryAdjustHeader.IAH_Inv_Adj_Nbr AS '���뵥��', 
 dbo.Lafite_DICT.VALUE1 AS '��������',
 DT.VALUE1 AS '�˻�����',
      DTR.VALUE1 as '�˻�ԭ��'
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


