 DROP view [interface].[V_I_CR_Inventory20131231]
GO

 create view [interface].[V_I_CR_Inventory20131231]
 as
 SELECT   

           DealerID=whm.WHM_DMA_ID
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
		  ,WHM_Type
      ,IsForReceipt = 0      
	  FROM interface.InventoryDailyBackup inv (nolock)
	  inner join Warehouse (nolock) whm on inv.INV_WHM_ID=whm.WHM_ID
	  inner join Product (nolock) pma on pma.PMA_ID=inv.INV_PMA_ID
	  inner join CFN  (nolock) on CFN.CFN_ID=pma.PMA_CFN_ID
	  inner join interface.LotDailyBackup (nolock) lot on Lot.LOT_INV_ID=inv.INV_ID  --关联条件
	  inner join LotMaster (nolock) on LotMaster.LTM_ID=lot.LOT_LTM_ID
	  where 
	  INV_BAK_DATE = '20140101'
	  and LOT_BAK_DATE = '20140101'
	  --and lot.LOT_OnHandQty>0 
	  --and WHM_Type='SystemHold'
GO


