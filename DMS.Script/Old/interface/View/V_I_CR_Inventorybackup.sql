DROP VIEW [interface].[V_I_CR_Inventorybackup]
GO


CREATE VIEW [interface].[V_I_CR_Inventorybackup]
AS
 SELECT 
    ID=LOT_ID,
   DealerID=whm.WHM_DMA_ID
		  ,LocationID=WHM_ID  --库房编号
		  ,Nature=case when WHM_Hospital_HOS_ID IS NULL then 1 else 0 end
		  ,UPN=pma.PMA_UPN
		  ,LOT=LTM_LotNumber --批号
		  ,Expdate=LTM_ExpiredDate --有效期
		  ,Qty=LOT_OnHandQty
		  ,PurchasePrice=Convert(money,[interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID,whm.WHM_DMA_ID,whm.WHM_Type)/1.17)
		  ,[Month]=DATEPART(month,getdate())
		  ,[Year]=DATEPART(year,getdate())
		  ,InvType=0
		  ,WHM_Type
      ,IsForReceipt = 0 
      ,WHM_Name
       ,PRH_Type=''   
	  FROM interface.InventoryDailyBackup inv
	  inner join Warehouse whm on inv.INV_WHM_ID=whm.WHM_ID
	  inner join Product pma on pma.PMA_ID=inv.INV_PMA_ID
	  inner join CFN on CFN.CFN_ID=pma.PMA_CFN_ID
	  inner join interface.LotDailyBackup on LOT_INV_ID=inv.INV_ID  --关联条件
	  inner join LotMaster on LotMaster.LTM_ID=LOT_LTM_ID
	  where 
	  LOT_OnHandQty<>0 and 
	  WHM_Type!='SystemHold'
	  and INV_BAK_DATE='20140831'
	  and LOT_BAK_DATE='20140831'
	  
union all
	 SELECT
	 ID=L.PRL_ID,
	  DealerID=H.PRH_Dealer_DMA_ID,
       LocationID=H.PRH_WHM_ID,
       0 AS Nature,
       UPN=C.CFN_CustomerFaceNbr,
       LOT=L.PRL_LotNumber,
       Expdate=L.PRL_ExpiredDate,
       L.PRL_ReceiptQty-isnull(DCM_Qty,0) as Qty,
       PurchasePrice=CONVERT (MONEY,[interface].[fn_GetPurchasePriceForInventory] (C.CFN_ID,H.PRH_Dealer_DMA_ID,W.WHM_Type)/ 1.17),
       [Month] = DATEPART (month, getdate ()),
       [Year] = DATEPART (year, getdate ()),
       InvType = 0,
       WHM_Type=w.WHM_Type,
       IsForReceipt = 1,
       WHM_Name,
       PRH_Type
       
       
  FROM POReceiptHeader H
       left join POReceipt D on H.PRH_ID = D.POR_PRH_ID
       left join POReceiptLot L on D.POR_ID = L.PRL_POR_ID
       left join Product P on P.PMA_ID = D.POR_SAP_PMA_ID
       left join cfn C on C.CFN_ID = P.PMA_CFN_ID
       left join Warehouse W on H.PRH_WHM_ID = W.WHM_ID
       left join DeliveryConfirmationMid on H.PRH_ID=DCM_PRH_ID
       and c.CFN_CustomerFaceNbr=DCM_UPN and L.PRL_LotNumber=DCM_Lot
       
 WHERE     
       L.PRL_ReceiptQty > 0
       --AND H.PRH_Type = 'PurchaseOrder'
       AND H.PRH_Status = 'Waiting'
 --      union all  
	  
 --SELECT 
 --          distinct  
 --          DealerID=inv.DID_DMA_ID
	--	  ,LocationID=WHM_ID  --库房编号
	--	  ,Nature=case when WHM_Hospital_HOS_ID IS NULL then 1 else 0 end
	--	  ,UPN=pma.PMA_UPN
	--	  ,LOT=LTM_LotNumber --批号
	--	  ,Expdate=LTM_ExpiredDate --有效期
	--	  ,Qty=inv.DID_Qty
	--	  ,PurchasePrice=Convert(money,[interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID,inv.DID_DMA_ID,whm.WHM_Type)/1.17)
	--	  ,[Month]= SUBSTRING(DID_Period,5,2 )
	--	  ,[Year]=SUBSTRING(DID_Period,1,4)
	--	  ,InvType=1
	--	  ,WHM_Type=whm.WHM_Type
 --     ,IsForReceipt = 0
 --      ,WHM_Name
 --      ,PRH_Type=''   
	--  FROM DealerInventoryData inv (nolock)
	--  left join Warehouse (nolock) whm on inv.DID_WHM_ID=whm.WHM_ID
	--  left join Product (nolock) pma on pma.PMA_ID=inv.DID_PMA_ID
	--  left join CFN (nolock) on CFN.CFN_ID=pma.PMA_CFN_ID
	--  left join Lot on Lot.LOT_LTM_ID=inv.DID_LTM_ID  --关联条件
	--  left join LotMaster (nolock) on LotMaster.LTM_ID=inv.DID_LTM_ID













GO


