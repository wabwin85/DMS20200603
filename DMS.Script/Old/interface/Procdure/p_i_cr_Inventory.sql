DROP PROCEDURE [interface].[p_i_cr_Inventory]
GO

CREATE PROCEDURE [interface].[p_i_cr_Inventory]
WITH EXEC AS CALLER
AS
delete from interface.T_I_CR_Inventory
where [Year]=DATEPART(year,getdate()) and [Month]=DATEPART(month,getdate())
  Insert into interface.T_I_CR_Inventory
   SELECT   DealerID=whm.WHM_DMA_ID
		  ,LocationID=WHM_ID  --库房编号
		  ,Nature=case when WHM_Hospital_HOS_ID IS NULL then 1 else 0 end
		  ,UPN=pma.PMA_UPN
		  ,LOT=LTM_LotNumber --批号
		  ,Expdate=LTM_ExpiredDate --有效期
		  ,Qty=lot.LOT_OnHandQty
		  ,PurchasePrice=Convert(money,[interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID,whm.WHM_DMA_ID,whm.WHM_Type)/1.17)
		  ,[Month]=DATEPART(month,getdate())
		  ,[Year]=DATEPART(year,getdate())
		  ,InvType=0
	  FROM Inventory inv(nolock)
	  inner join Warehouse whm(nolock) on inv.INV_WHM_ID=whm.WHM_ID
	  inner join Product pma(nolock) on pma.PMA_ID=inv.INV_PMA_ID
	  inner join CFN(nolock) on CFN.CFN_ID=pma.PMA_CFN_ID
	  inner join Lot(nolock) on Lot.LOT_INV_ID=inv.INV_ID  --关联条件
	  inner join LotMaster(nolock) on LotMaster.LTM_ID=lot.LOT_LTM_ID
	  where lot.LOT_OnHandQty>0 --and WHM_Type!='SystemHold'
	  
	  union all
	  
	  
 SELECT 
           distinct  
           DealerID=inv.DID_DMA_ID
		  ,LocationID=WHM_ID  --库房编号
		  ,Nature=case when WHM_Hospital_HOS_ID IS NULL then 1 else 0 end
		  ,UPN=pma.PMA_UPN
		  ,LOT=LTM_LotNumber --批号
		  ,Expdate=LTM_ExpiredDate --有效期
		  ,Qty=inv.DID_Qty
		  ,PurchasePrice=Convert(money,[interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID,inv.DID_DMA_ID,whm.WHM_Type)/1.17)
		  ,[Month]= SUBSTRING(DID_Period,5,2 )
		  ,[Year]=SUBSTRING(DID_Period,1,4)
		  ,InvType=1
	  FROM DealerInventoryData inv (nolock)
	  left join Warehouse (nolock) whm on inv.DID_WHM_ID=whm.WHM_ID
	  left join Product (nolock) pma on pma.PMA_ID=inv.DID_PMA_ID
	  left join CFN (nolock) on CFN.CFN_ID=pma.PMA_CFN_ID
	  left join Lot on Lot.LOT_LTM_ID=inv.DID_LTM_ID  --关联条件
	  left join LotMaster (nolock) on LotMaster.LTM_ID=inv.DID_LTM_ID
	  --left join Lot (nolock) on Lot.LOT_LTM_ID=LotMaster.LTM_ID
GO


