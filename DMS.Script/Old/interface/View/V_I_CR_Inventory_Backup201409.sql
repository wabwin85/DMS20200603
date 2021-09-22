
DROP VIEW [interface].[V_I_CR_Inventory_Backup201409]
GO







CREATE VIEW [interface].[V_I_CR_Inventory_Backup201409]
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
	  where lot.LOT_OnHandQty<>0 and WHM_Type!='SystemHold' and inv.INV_BAK_DATE='20141001' and lot.LOT_BAK_DATE=inv.INV_BAK_DATE
	
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
       left join (select * from interface.T_I_CR_DeliveryConfirmationMid_MonthlyBackup where dcm_bak_date='20141001') AS DC on H.PRH_ID=DC.DCM_PRH_ID and c.CFN_CustomerFaceNbr=DC.DCM_UPN and L.PRL_LotNumber=DC.DCM_Lot      
       
 WHERE     
       L.PRL_ReceiptQty > 0
       --AND H.PRH_Type = 'PurchaseOrder'
       AND H.PRH_Status = 'Waiting'
       and H.PRH_BAK_DATE='20141001' and D.POR_BAK_DATE='20141001' and L.PRL_BAK_DATE = '20141001'
       and H.PRH_PurchaseOrderNbr not like 'CRA%' 
    
      
 



GO


