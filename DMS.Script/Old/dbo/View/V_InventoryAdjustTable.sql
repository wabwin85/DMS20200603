
DROP view [dbo].[V_InventoryAdjustTable]
GO


CREATE view [dbo].[V_InventoryAdjustTable]
as
select InventoryAdjustHeader.IAH_ID as Id,
           dbo.CFN.CFN_CustomerFaceNbr AS '��Ʒ�ͺ�',
           dbo.CFN.CFN_ChineseName AS '��Ʒ������', 
           dbo.CFN.CFN_EnglishName AS '��ƷӢ����',  
           V_LotMaster.LTM_LotNumber AS '����',         
           dbo.Product.PMA_UnitOfMeasure AS '��λ',
           sum(dbo.InventoryAdjustLot.IAL_LotQty) AS '����'
           --dbo.InventoryAdjustLot.IAL_UnitPrice AS '��Ʒ����'
           from InventoryAdjustHeader inner join InventoryAdjustDetail
           on InventoryAdjustHeader.IAH_ID=InventoryAdjustDetail.IAD_IAH_ID
               inner join InventoryAdjustLot on InventoryAdjustDetail.IAD_ID=InventoryAdjustLot.IAL_IAD_ID
               inner join Product on InventoryAdjustDetail.IAD_PMA_ID=Product.PMA_ID
               inner join CFN on Product.PMA_CFN_ID=CFN.CFN_ID
               inner join Lot on Lot.LOT_ID = InventoryAdjustLot.IAL_LOT_ID
               inner join V_LotMaster ON LTM_ID = Lot.LOT_LTM_ID
               where  (dbo.InventoryAdjustHeader.IAH_Status <> 'Draft')
           group by InventoryAdjustHeader.IAH_ID,dbo.CFN.CFN_CustomerFaceNbr,dbo.CFN.CFN_ChineseName,dbo.CFN.CFN_EnglishName,dbo.Product.PMA_UnitOfMeasure,V_LotMaster.LTM_LotNumber



GO


