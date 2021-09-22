DROP VIEW [interface].[V_I_CR_Inventory_Backup201410]
GO










CREATE VIEW [interface].[V_I_CR_Inventory_Backup201410]
AS
 SELECT 
    ID=Lot.LOT_ID,
   DealerID=whm.WHM_DMA_ID
		  ,LocationID=WHM_ID  --库房编号
		  ,Nature=case when WHM_Hospital_HOS_ID IS NULL then 1 else 0 end
		  ,UPN=pma.PMA_UPN
		  ,LOT=LTM_LotNumber --批号
		  ,Expdate=LTM_ExpiredDate --有效期
		  ,Qty=lot.LOT_OnHandQty
		  ,PurchasePrice=0
		  ,[Month]=DATEPART(month,getdate())
		  ,[Year]=DATEPART(year,getdate())
		  ,InvType=0
		  ,WHM_Type
      ,IsForReceipt = 0 
      ,WHM_Name
       ,PRH_Type=''   
	  FROM interface.InventoryDailyBackup(nolock) inv
	  inner join Warehouse whm on inv.INV_WHM_ID=whm.WHM_ID
	  inner join Product pma on pma.PMA_ID=inv.INV_PMA_ID
	  inner join CFN on CFN.CFN_ID=pma.PMA_CFN_ID
	  inner join interface.LotDailyBackup(nolock) AS Lot on Lot.LOT_INV_ID=inv.INV_ID  --关联条件
	  inner join LotMaster on LotMaster.LTM_ID=lot.LOT_LTM_ID
	  where lot.LOT_OnHandQty<>0 and WHM_Type!='SystemHold' and inv.INV_BAK_DATE='20141101' and lot.LOT_BAK_DATE=inv.INV_BAK_DATE
	
union all
	 SELECT
	 ID=L.PRL_ID,
	  DealerID=H.PRH_Dealer_DMA_ID,
       LocationID=H.PRH_WHM_ID,
       0 AS Nature,
       UPN=C.CFN_CustomerFaceNbr,
       LOT=L.PRL_LotNumber,
       Expdate=L.PRL_ExpiredDate,
       L.PRL_ReceiptQty-isnull(DC.DCM_Qty,0) as Qty,
       PurchasePrice=0,
       [Month] = DATEPART (month, getdate ()),
       [Year] = DATEPART (year, getdate ()),
       InvType = 0,
       WHM_Type=w.WHM_Type,
       IsForReceipt = 1,
       WHM_Name,
       PRH_Type
       
       
  FROM interface.POReceiptHeader_MonthlyBackup H
       left join interface.POReceipt_MonthlyBackup D on H.PRH_ID = D.POR_PRH_ID
       left join interface.POReceiptLot_MonthlyBackup L on D.POR_ID = L.PRL_POR_ID
       left join Product P on P.PMA_ID = D.POR_SAP_PMA_ID
       left join cfn C on C.CFN_ID = P.PMA_CFN_ID
       left join Warehouse W on H.PRH_WHM_ID = W.WHM_ID
       left join (select * from interface.T_I_CR_DeliveryConfirmationMid_MonthlyBackup where dcm_bak_date='20141101') AS DC on H.PRH_ID=DC.DCM_PRH_ID and c.CFN_CustomerFaceNbr=DC.DCM_UPN and L.PRL_LotNumber=DC.DCM_Lot      
       
 WHERE     
       L.PRL_ReceiptQty > 0
       --AND H.PRH_Type = 'PurchaseOrder'
       AND H.PRH_Status = 'Waiting'
       and H.PRH_BAK_DATE='20141101' and D.POR_BAK_DATE='20141101' and L.PRL_BAK_DATE = '20141101'
       and H.PRH_PurchaseOrderNbr not like 'CRA%' 
    
 UNION all
    
 select IAH_ID,
       IAH_DMA_ID,
       IAL_WHM_ID,
       0 As Nature,
       PMA_UPN,
       IAL_LotNumber,
       IAL_ExpiredDate,
       IAL_LOTQTY - sum(isnull(tdc_qty,0)) as Qty,
       PurchasePrice=CONVERT (MONEY,[interface].[fn_GetPurchasePriceForInventory] (PMA_CFN_ID,IAL_WHM_ID,IAH_WarehouseType)/ 1.17),
       [Month] = DATEPART (month, getdate ()),
       [Year] = DATEPART (year, getdate ()),
       InvType = 0,
       WHM_Type=(select WHM_Type from Warehouse where WHM_ID=IAL_WHM_ID),--IAH_WarehouseType,
       IsForReceipt = 2,
       WHM_Name,
       'GoodsReturn' AS PRH_Type
       
  from [interface].[InventoryAdjustHeader_MonthlyBackup]
       INNER JOIN  [interface].[InventoryAdjustDetail_MonthlyBackup] ON iah_id = iad_iah_id
       INNER JOIN  [interface].[InventoryAdjustLot_MonthlyBackup] ON iad_id = ial_iad_id
       INNER JOIN Product ON iad_pma_id = Pma_id
       LEFT JOIN  [interface].[Tmp_DealerReturnConfirm_MonthlyBackup] ON (iah_id = tdc_iah_id and pma_upn = tdc_upn and ial_lotnumber = tdc_lot and tdc_bak_date='20141101')
       INNER JOIN dealermaster ON iah_dma_id = dma_id
       LEFT JOIN Warehouse ON IAL_WHM_ID = WHM_ID
 where iah_status in ('Submitted','Submit')
	and IAH_Reason in ('Return','Exchange')
	and [interface].[InventoryAdjustHeader_MonthlyBackup].IAH_BAK_DATE='20141101'
	and [interface].[InventoryAdjustDetail_MonthlyBackup].IAD_BAK_DATE='20141101'
	and [interface].[InventoryAdjustLot_MonthlyBackup].IAL_BAK_DATE='20141101'
	
 group by IAH_ID,
          IAH_DMA_ID,
          IAL_WHM_ID, 
          PMA_UPN,
          IAL_LotNumber,
          IAL_ExpiredDate,
          PMA_CFN_ID,IAL_WHM_ID,IAH_WarehouseType,WHM_Name,IAL_LOTQTY
          
          
          






GO


