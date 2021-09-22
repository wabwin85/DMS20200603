DROP VIEW [interface].[V_I_CR_Inventory_Backup]
GO





















CREATE VIEW [interface].[V_I_CR_Inventory_Backup]
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
       ,'' AS FormNbr   
      
	  FROM interface.InventoryDailyBackup(nolock) inv
	  inner join Warehouse whm on inv.INV_WHM_ID=whm.WHM_ID
	  inner join Product pma on pma.PMA_ID=inv.INV_PMA_ID
	  inner join CFN on CFN.CFN_ID=pma.PMA_CFN_ID
	  inner join interface.LotDailyBackup(nolock) AS Lot on Lot.LOT_INV_ID=inv.INV_ID  --关联条件
	  inner join LotMaster on LotMaster.LTM_ID=lot.LOT_LTM_ID
	  where lot.LOT_OnHandQty<>0 and WHM_Type!='SystemHold' and inv.INV_BAK_DATE='20150701' and lot.LOT_BAK_DATE=inv.INV_BAK_DATE
	
union all
     
     
	 SELECT
	 ID=L.PRL_ID,
	  DealerID=H.PRH_Dealer_DMA_ID,
       LocationID=H.PRH_WHM_ID,
       0 AS Nature,
       UPN=C.CFN_CustomerFaceNbr,
       LOT=L.PRL_LotNumber,
       Expdate=LM.LTM_ExpiredDate,
       --Expdate=L.PRL_ExpiredDate,
       L.PRL_ReceiptQty-isnull(DC.DCM_Qty,0) as Qty,
       PurchasePrice=0,
       [Month] = DATEPART (month, getdate ()),
       [Year] = DATEPART (year, getdate ()),
       InvType = 0,
       WHM_Type=w.WHM_Type,
       IsForReceipt = 1,
       WHM_Name,
       PRH_Type,
       H.PRH_SAPShipmentID 
  FROM interface.POReceiptHeader_MonthlyBackup H
       left join interface.POReceipt_MonthlyBackup D on H.PRH_ID = D.POR_PRH_ID
       left join interface.POReceiptLot_MonthlyBackup L on D.POR_ID = L.PRL_POR_ID
       left join Product P on P.PMA_ID = D.POR_SAP_PMA_ID
       left join cfn C on C.CFN_ID = P.PMA_CFN_ID
       left join Warehouse W on H.PRH_WHM_ID = W.WHM_ID
       left join (select * from interface.T_I_CR_DeliveryConfirmationMid_MonthlyBackup where dcm_bak_date='20150701') AS DC on H.PRH_ID=DC.DCM_PRH_ID and c.CFN_CustomerFaceNbr=DC.DCM_UPN and L.PRL_LotNumber=DC.DCM_Lot      
       left join LotMaster LM on (LM.LTM_Product_PMA_ID = P.PMA_ID and LM.LTM_LotNumber=L.PRL_LotNumber )
 WHERE     
       L.PRL_ReceiptQty > 0
       --AND H.PRH_Type = 'PurchaseOrder'
       AND H.PRH_Status = 'Waiting'
       and H.PRH_BAK_DATE='20150701' and D.POR_BAK_DATE='20150701' and L.PRL_BAK_DATE = '20150701'
       --and H.PRH_PurchaseOrderNbr not like 'CRA%'   
       
         
 --UNION all    
 --select IAH_ID,
 --      IAH_DMA_ID,
 --      IAL_WHM_ID,
 --      0 As Nature,
 --      PMA_UPN,
 --      IAL_LotNumber,
 --      --IAL_ExpiredDate,
 --      LM.LTM_ExpiredDate,
 --      IAL_LOTQTY - sum(isnull(tdc_qty,0)) as Qty,
 --      PurchasePrice=CONVERT (MONEY,[interface].[fn_GetPurchasePriceForInventory] (PMA_CFN_ID,IAL_WHM_ID,IAH_WarehouseType)/ 1.17),
 --      [Month] = DATEPART (month, getdate ()),
 --      [Year] = DATEPART (year, getdate ()),
 --      InvType = 0,
 --      WHM_Type=(select WHM_Type from Warehouse where WHM_ID=IAL_WHM_ID),--IAH_WarehouseType,
 --      IsForReceipt = 2,
 --      WHM_Name,
 --      'GoodsReturn' AS PRH_Type,
 --      [interface].[InventoryAdjustHeader_MonthlyBackup].IAH_Inv_Adj_Nbr 
 -- from [interface].[InventoryAdjustHeader_MonthlyBackup]
 --      INNER JOIN  [interface].[InventoryAdjustDetail_MonthlyBackup] ON iah_id = iad_iah_id
 --      INNER JOIN  [interface].[InventoryAdjustLot_MonthlyBackup] ON iad_id = ial_iad_id
 --      INNER JOIN Product ON iad_pma_id = Pma_id
 --      LEFT JOIN  [interface].[Tmp_DealerReturnConfirm_MonthlyBackup] ON (iah_id = tdc_iah_id and pma_upn = tdc_upn and ial_lotnumber = tdc_lot and tdc_bak_date='20150701')
 --      INNER JOIN dealermaster ON iah_dma_id = dma_id
 --      LEFT JOIN Warehouse ON IAL_WHM_ID = WHM_ID
 --      left join LotMaster LM on (LM.LTM_Product_PMA_ID = Product.PMA_ID and LM.LTM_LotNumber=[interface].[InventoryAdjustLot_MonthlyBackup].IAL_LotNumber )
 --where iah_status in ('Submitted','Submit')
	--and IAH_Reason in ('Return','Exchange')
	--and not exists (select * from DealerMaster AS dm where dm.DMA_DealerType='T2' and [interface].[InventoryAdjustHeader_MonthlyBackup].IAH_DMA_ID=dm.DMA_ID and [interface].[InventoryAdjustHeader_MonthlyBackup].IAH_WarehouseType='Consignment')
	--and [interface].[InventoryAdjustHeader_MonthlyBackup].IAH_BAK_DATE='20150701'
	--and [interface].[InventoryAdjustDetail_MonthlyBackup].IAD_BAK_DATE='20150701'
	--and [interface].[InventoryAdjustLot_MonthlyBackup].IAL_BAK_DATE='20150701'	
 --group by IAH_ID,
 --         IAH_DMA_ID,
 --         IAL_WHM_ID, 
 --         PMA_UPN,
 --         IAL_LotNumber,
 --         --IAL_ExpiredDate,
 --         LM.LTM_ExpiredDate,
 --         PMA_CFN_ID,IAL_WHM_ID,IAH_WarehouseType,
 --         WHM_Name,IAL_LOTQTY,
 --         IAH_Inv_Adj_Nbr

union all

select DC_ID,
       DC_CorpId,
       DealerComplain.WHM_ID,
       0 As Nature,
       UPN,
       DealerComplain.Lot,
       --IAL_ExpiredDate,
       LTM_ExpiredDate,
       UPNQUANTITY as Qty,
       PurchasePrice= 0,
	  [Month] = DATEPART (month, getdate ()),
       [Year] = DATEPART (year, getdate ()),
       InvType = 0,
       WHM_Type=(select WHM_Type from Warehouse where WHM_ID=DealerComplain.WHM_ID),--IAH_WarehouseType,
       IsForReceipt = 3,
       WHM_Name,
       'Complain' AS PRH_Type,
       DC_ComplainNbr
       --select *
 from DealerComplain       
 inner join CFN on UPN = CFN_CustomerFaceNbr
 inner join LotMaster on Lot = LTM_LotNumber
 inner join DealerMaster on DC_CorpId = DMA_ID
 left join Warehouse  on DealerComplain.WHM_ID = Warehouse.WHM_ID
where DC_Status in ('OutOfStock','Submit','Accept','Confirmed','DealerCompleted','SampleReceived')
and DealerComplain.WHM_ID <> '00000000-0000-0000-0000-000000000000'--排除销售到医院的数据
and DC_CreatedDate > '2015-05-25 0:00:00' 
union all
 select DC_ID,
       DC_CorpId,
       WHMID,
       0 As Nature,
       Serial,
       DealerComplainCRM.Lot,
       --IAL_ExpiredDate,
       LTM_ExpiredDate,
       1 as Qty,
       PurchasePrice= 0,
	  [Month] = DATEPART (month, getdate ()),
       [Year] = DATEPART (year, getdate ()),
       InvType = 0,
       WHM_Type=(select WHM_Type from Warehouse where WHM_ID=WHMID),--IAH_WarehouseType,
       IsForReceipt = 3,
       WHM_Name,
       'Complain' AS PRH_Type,
       DC_ComplainNbr
 from DealerComplainCRM       
 inner join CFN on Serial = CFN_CustomerFaceNbr
 inner join LotMaster on Lot = LTM_LotNumber
 inner join DealerMaster on DC_CorpId = DMA_ID
 left join Warehouse  on WHMID = WHM_ID
where DC_Status in ('OutOfStock','Submit','Accept','Confirmed','DealerCompleted','SampleReceived')
and WHMID <> '00000000-0000-0000-0000-000000000000'--排除销售到医院的数据
and DC_CreatedDate > '2015-05-25 0:00:00' 

union all

select H.SPH_ID, 
       H.SPH_Dealer_DMA_ID,
       T.SLT_WHM_ID,
       0 As Nature,
       P.PMA_UPN,
       M.LTM_LotNumber,
       M.LTM_ExpiredDate,
       T.SLT_LotShippedQty,
       PurchasePrice= 0,
       [Month] = DATEPART (month, getdate ()),
       [Year] = DATEPART (year, getdate ()),
       InvType = 0,
       W.WHM_Type,
       IsForReceipt = 4,
       W.WHM_Name,
       'Sales' AS PRH_Type,
       H.SPH_ShipmentNbr
      
from  ShipmentHeader H, ShipmentLine L, ShipmentLot T,product P,LotMaster M, Lot LT,warehouse W
where H.SPH_ID = L.SPL_SPH_ID and L.SPL_ID = T.SLT_SPL_ID and W.WHM_ID = T.SLT_WHM_ID
  and L.SPL_Shipment_PMA_ID = P.PMA_ID and T.SLT_LOT_ID = LT.LOT_ID and LT.LOT_LTM_ID = M.LTM_ID
  and H.SPH_Status='Complete' and W.WHM_Type in ('Borrow','LP_Consignment','Consignment')
  and H.SPH_ShipmentDate > '2015-01-01 0:00:00'
  and H.SPH_Dealer_DMA_ID in (select DMA_ID from DealerMaster where DMA_DealerType='T2')
  and not exists
  (
    select * from ShipmentLPConfirmHeader t1,ShipmentLPConfirmDetail t2
    where t1.SCH_ID = t2.SCD_SCH_ID
    and t1.SCH_SalesNo = H.SPH_ShipmentNbr and  t2.SCD_UPN = P.PMA_UPN and t2.SCD_Lot = M.LTM_LotNumber
  
  )          
          
          
















GO


