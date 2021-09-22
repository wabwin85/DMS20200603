DROP VIEW [interface].[V_I_CR_Inventory_For_DIO_Test]
GO


CREATE VIEW [interface].[V_I_CR_Inventory_For_DIO_Test]
AS
 --SELECT 
 --   ID=Lot.LOT_ID,
 --  DealerID=whm.WHM_DMA_ID
	--	  ,LocationID=WHM_ID  --库房编号
	--	  ,Nature=case when WHM_Hospital_HOS_ID IS NULL then 1 else 0 end
	--	  ,UPN=pma.PMA_UPN
	--	  --,LOT=LTM_LotNumber --批号
 --     ,CASE WHEN charindex('@@',LTM_LotNumber) > 0 
 --           THEN substring(LTM_LotNumber,1,charindex('@@',LTM_LotNumber)-1) 
 --           ELSE LTM_LotNumber
 --           END AS LOT
 --     ,CASE WHEN charindex('@@',LTM_LotNumber) > 0
 --           THEN substring(LTM_LotNumber,charindex('@@',LTM_LotNumber)+2,len(LTM_LotNumber)) 
 --           ELSE ''
 --           END AS QRCode
	--	  ,Expdate=LTM_ExpiredDate --有效期
	--	  ,Qty=lot.LOT_OnHandQty
	--	  ,PurchasePrice=Convert(money,[interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID,whm.WHM_DMA_ID,whm.WHM_Type)/1.17)
	--	  ,[Month]=DATEPART(month,getdate())
	--	  ,[Year]=DATEPART(year,getdate())
	--	  ,InvType=0
	--	  ,WHM_Type
 --     ,IsForReceipt = 0 
 --     ,WHM_Name
 --     ,PRH_Type=''
 --     ,'' AS FormNbr   
	--  FROM Inventory inv(nolock)
	--  inner join Warehouse whm(nolock) on inv.INV_WHM_ID=whm.WHM_ID
	--  inner join Product pma(nolock) on pma.PMA_ID=inv.INV_PMA_ID
	--  inner join CFN(nolock) on CFN.CFN_ID=pma.PMA_CFN_ID
	--  inner join Lot(nolock) on Lot.LOT_INV_ID=inv.INV_ID  --关联条件
	--  inner join LotMaster(nolock) on LotMaster.LTM_ID=lot.LOT_LTM_ID
	--  where lot.LOT_OnHandQty<>0 and WHM_Type!='SystemHold'
	
SELECT 
    ID=Lot.LOT_ID,
   DealerID=whm.WHM_DMA_ID
		  ,LocationID=WHM.WHM_ID  --库房编号
		  ,Nature=case when WHM_Hospital_HOS_ID IS NULL then 1 else 0 end
		  ,UPN=pma.PMA_UPN
		  --,LOT=LTM_LotNumber --批号
      ,CASE WHEN charindex('@@',LTM_LotNumber) > 0 
            THEN substring(LTM_LotNumber,1,charindex('@@',LTM_LotNumber)-1) 
            ELSE LTM_LotNumber
            END AS LOT
      ,CASE WHEN charindex('@@',LTM_LotNumber) > 0
            THEN substring(LTM_LotNumber,charindex('@@',LTM_LotNumber)+2,len(LTM_LotNumber)) 
            ELSE ''
            END AS QRCode
		  ,Expdate=LTM_ExpiredDate --有效期
		  ,Qty=lot.LOT_OnHandQty
		  ,PurchasePrice=Convert(money,[interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID,whm.WHM_DMA_ID,whm.WHM_Type)/1.17)
		  ,[Month]=DATEPART(month,getdate())
		  ,[Year]=DATEPART(year,getdate())
		  ,InvType=0
		  ,WHM_Type
      ,IsForReceipt = 0 
      ,WHM_Name
      ,PRH_Type=''
      ,'' AS FormNbr 
      ,TransferDate
      ,ReceiptDate
	  FROM Inventory inv(nolock)
	  inner join Warehouse whm(nolock) on inv.INV_WHM_ID=whm.WHM_ID
	  inner join Product pma(nolock) on pma.PMA_ID=inv.INV_PMA_ID
	  inner join CFN(nolock) on CFN.CFN_ID=pma.PMA_CFN_ID
	  inner join Lot(nolock) on Lot.LOT_INV_ID=inv.INV_ID  --关联条件
	  inner join LotMaster(nolock) on LotMaster.LTM_ID=lot.LOT_LTM_ID
	  --left join V_Transfer_UPNLOT_MaxTransferDate VT 
	  left join Interface.Stage_V_Transfer_UPNLOT_MaxTransferDate VT 
	     on (VT.WHM_ID = WHM.WHM_ID AND
	         VT.PMA_ID = pma.PMA_ID AND
	         VT.LotNumber = LotMaster.LTM_LotNumber)	  
	  --left join V_Receipt_UPNLOT_MaxReceiptDate VR  
	  left join Interface.Stage_V_Receipt_UPNLOT_MaxReceiptDate VR 
	     ON (VR.WHM_ID = WHM.WHM_ID AND
	         VR.PMA_ID = pma.PMA_ID AND
	         VR.LotNumber = LotMaster.LTM_LotNumber)
	  where lot.LOT_OnHandQty<>0 and WHM_Type!='SystemHold'		  
union all
	 SELECT
	     ID=L.PRL_ID,
	     DealerID=H.PRH_Dealer_DMA_ID,
       LocationID=H.PRH_WHM_ID,
       0 AS Nature,
       UPN=C.CFN_CustomerFaceNbr,
       --LOT=L.PRL_LotNumber,
       CASE WHEN charindex('@@',L.PRL_LotNumber) > 0 
            THEN substring(L.PRL_LotNumber,1,charindex('@@',L.PRL_LotNumber)-1) 
            ELSE L.PRL_LotNumber
            END AS LOT,
       CASE WHEN charindex('@@',L.PRL_LotNumber) > 0
            THEN substring(L.PRL_LotNumber,charindex('@@',L.PRL_LotNumber)+2,len(L.PRL_LotNumber)) 
            ELSE ''
            END AS QRCode,
       Expdate=LM.LTM_ExpiredDate,
       --Expdate=L.PRL_ExpiredDate,
       L.PRL_ReceiptQty-isnull(DCM_Qty,0) as Qty,
       PurchasePrice=CONVERT (MONEY,[interface].[fn_GetPurchasePriceForInventory] (C.CFN_ID,H.PRH_Dealer_DMA_ID,W.WHM_Type)/ 1.17),
       [Month] = DATEPART (month, getdate ()),
       [Year] = DATEPART (year, getdate ()),
       InvType = 0,
       WHM_Type=w.WHM_Type,
       IsForReceipt = 1,
       WHM_Name,
       PRH_Type,
       H.PRH_SAPShipmentID,
       null,
       null       
  FROM POReceiptHeader H(nolock)
       left join POReceipt D(nolock) on H.PRH_ID = D.POR_PRH_ID
       left join POReceiptLot L(nolock) on D.POR_ID = L.PRL_POR_ID
       left join Product P(nolock) on P.PMA_ID = D.POR_SAP_PMA_ID
       left join cfn C(nolock) on C.CFN_ID = P.PMA_CFN_ID
       left join Warehouse W(nolock) on H.PRH_WHM_ID = W.WHM_ID
       left join DeliveryConfirmationMid(nolock) on (H.PRH_ID=DCM_PRH_ID and c.CFN_CustomerFaceNbr=DCM_UPN and L.PRL_LotNumber=DCM_Lot)
       left join LotMaster LM(nolock) on (LM.LTM_Product_PMA_ID = P.PMA_ID and LM.LTM_LotNumber=L.PRL_LotNumber )
       
 WHERE     
       L.PRL_ReceiptQty > 0
       --AND H.PRH_Type = 'PurchaseOrder'
       AND H.PRH_Status = 'Waiting'
       --AND H.PRH_PurchaseOrderNbr not like 'CRA%'
       
union all

select IAH_ID,
       IAH_DMA_ID,
       IAL_WHM_ID,
       0 As Nature,
       PMA_UPN,
       --IAL_LotNumber,
       CASE WHEN charindex('@@',LM.LTM_LotNumber) > 0 
              THEN substring(LM.LTM_LotNumber,1,charindex('@@',LM.LTM_LotNumber)-1) 
              ELSE LM.LTM_LotNumber
              END AS LOT,
       CASE WHEN charindex('@@',LM.LTM_LotNumber) > 0
              THEN substring(LM.LTM_LotNumber,charindex('@@',LM.LTM_LotNumber)+2,len(LM.LTM_LotNumber)) 
              ELSE ''
              END AS QRCode,
       --IAL_ExpiredDate,
       LM.LTM_ExpiredDate,
       IAL_LOTQTY - sum(isnull(tdc_qty,0)) as Qty,
       PurchasePrice=CONVERT (MONEY,[interface].[fn_GetPurchasePriceForInventory] (PMA_CFN_ID,IAL_WHM_ID,IAH_WarehouseType)/ 1.17),
       [Month] = DATEPART (month, getdate ()),
       [Year] = DATEPART (year, getdate ()),
       InvType = 0,
       WHM_Type=(select WHM_Type from Warehouse where WHM_ID=IAL_WHM_ID),--IAH_WarehouseType,
       IsForReceipt = 2,
       WHM_Name,
       'GoodsReturn' AS PRH_Type,
       InventoryAdjustHeader.IAH_Inv_Adj_Nbr,
       null,
       null
  from InventoryAdjustHeader(nolock)
       INNER JOIN InventoryAdjustDetail(nolock) ON iah_id = iad_iah_id
       INNER JOIN InventoryAdjustLot(nolock) ON iad_id = ial_iad_id
       INNER JOIN Product(nolock) ON iad_pma_id = Pma_id
       LEFT JOIN  Tmp_DealerReturnConfirm(nolock) ON (iah_id = tdc_iah_id and pma_upn = tdc_upn and ial_lotnumber = tdc_lot)
       INNER JOIN dealermaster(nolock) ON iah_dma_id = dma_id
       LEFT JOIN  Warehouse(nolock) ON IAL_WHM_ID = WHM_ID
       left join LotMaster LM(nolock) on (LM.LTM_Product_PMA_ID = Product.PMA_ID and LM.LTM_LotNumber = ISNULL(InventoryAdjustLot.IAL_QRLotNumber,InventoryAdjustLot.IAL_LotNumber))
 where iah_status in ('Submitted','Submit')
	and IAH_Reason in ('Return','Exchange')
	--因为二维码功能调整，之前T2寄售退货是不扣减库存的，现在是扣减库存移到在途库，所以需要统计Pending Return
  --and not exists (select * from DealerMaster AS dm where dm.DMA_DealerType='T2' and InventoryAdjustHeader.IAH_DMA_ID=dm.DMA_ID and InventoryAdjustHeader.IAH_WarehouseType='Consignment')
 group by IAH_ID,
          IAH_DMA_ID,
          IAL_WHM_ID, 
          PMA_UPN,
          --IAL_LotNumber,
          LM.LTM_LotNumber,
          --IAL_ExpiredDate,
          LM.LTM_ExpiredDate,
          PMA_CFN_ID,IAL_WHM_ID,IAH_WarehouseType,WHM_Name,IAL_LOTQTY,
          IAH_Inv_Adj_Nbr
union all
select DC_ID,
       DC_CorpId,
       DealerComplain.WHM_ID,
       0 As Nature,
       UPN,
       CASE WHEN charindex('@@',DealerComplain.Lot) > 0 
              THEN substring(DealerComplain.Lot,1,charindex('@@',DealerComplain.Lot)-1) 
              ELSE DealerComplain.Lot
              END AS LOT,
       CASE WHEN charindex('@@',DealerComplain.Lot) > 0
              THEN substring(DealerComplain.Lot,charindex('@@',DealerComplain.Lot)+2,len(DealerComplain.Lot)) 
              ELSE ''
              END AS QRCode,
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
       DC_ComplainNbr,
       null,
       null
       --select *
 from DealerComplain(nolock)       
 inner join CFN(nolock) on UPN = CFN_CustomerFaceNbr
 inner join LotMaster(nolock) on Lot = LTM_LotNumber
 inner join DealerMaster(nolock) on DC_CorpId = DMA_ID
 left join Warehouse(nolock)  on DealerComplain.WHM_ID = Warehouse.WHM_ID
where DC_Status in ('OutOfStock','Submit','Accept','Confirmed','DealerCompleted','SampleReceived')
and DealerComplain.WHM_ID <> '00000000-0000-0000-0000-000000000000'--排除销售到医院的数据
and DC_CreatedDate > '2015-05-25 0:00:00' 
union all
 select DC_ID,
       DC_CorpId,
       WHMID,
       0 As Nature,
       Serial,
       --DealerComplainCRM.Lot,
       CASE WHEN charindex('@@',DealerComplainCRM.Lot) > 0 
              THEN substring(DealerComplainCRM.Lot,1,charindex('@@',DealerComplainCRM.Lot)-1) 
              ELSE DealerComplainCRM.Lot
              END AS LOT,
       CASE WHEN charindex('@@',DealerComplainCRM.Lot) > 0
              THEN substring(DealerComplainCRM.Lot,charindex('@@',DealerComplainCRM.Lot)+2,len(DealerComplainCRM.Lot)) 
              ELSE ''
              END AS QRCode,
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
       DC_ComplainNbr,
       null,
       null
 from DealerComplainCRM(nolock)       
 inner join CFN(nolock) on Serial = CFN_CustomerFaceNbr
 inner join LotMaster(nolock) on Lot = LTM_LotNumber
 inner join DealerMaster(nolock) on DC_CorpId = DMA_ID
 left join Warehouse(nolock)  on WHMID = WHM_ID
where DC_Status in ('OutOfStock','Submit','Accept','Confirmed','DealerCompleted','SampleReceived')
and WHMID <> '00000000-0000-0000-0000-000000000000'--排除销售到医院的数据
and DC_CreatedDate > '2015-05-25 0:00:00' 

union all

select H.SPH_ID, 
       H.SPH_Dealer_DMA_ID,
       T.SLT_WHM_ID,
       0 As Nature,
       P.PMA_UPN,
       --M.LTM_LotNumber,
       CASE WHEN charindex('@@',M.LTM_LotNumber) > 0 
              THEN substring(M.LTM_LotNumber,1,charindex('@@',M.LTM_LotNumber)-1) 
              ELSE M.LTM_LotNumber
              END AS LOT,
       CASE WHEN charindex('@@',M.LTM_LotNumber) > 0
              THEN substring(M.LTM_LotNumber,charindex('@@',M.LTM_LotNumber)+2,len(M.LTM_LotNumber)) 
              ELSE ''
              END AS QRCode,
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
       H.SPH_ShipmentNbr,
       null,
       null       
from  ShipmentHeader H(nolock), ShipmentLine L(nolock), ShipmentLot T(nolock),product P(nolock),LotMaster M(nolock), Lot LT(nolock),warehouse W(nolock),DealerMaster D(nolock)
where H.SPH_ID = L.SPL_SPH_ID and L.SPL_ID = T.SLT_SPL_ID and W.WHM_ID = T.SLT_WHM_ID
  and L.SPL_Shipment_PMA_ID = P.PMA_ID 
  and ISNULL(T.SLT_QRLOT_ID,T.SLT_LOT_ID) = LT.LOT_ID 
  and LT.LOT_LTM_ID = M.LTM_ID
  and H.SPH_Status='Complete' and W.WHM_Type in ('Borrow','LP_Consignment','Consignment')
  and H.SPH_ShipmentDate > '2015-01-01 0:00:00'
  and H.SPH_Dealer_DMA_ID = D.DMA_ID--in (select DMA_ID from DealerMaster where DMA_DealerType='T2')
  and D.DMA_DealerType='T2'
  and not exists
  (
    select 1 from ShipmentLPConfirmHeader t1(nolock),ShipmentLPConfirmDetail t2(nolock)
    where t1.SCH_ID = t2.SCD_SCH_ID
    and t1.SCH_SalesNo = H.SPH_ShipmentNbr and  t2.SCD_UPN = P.PMA_UPN and t2.SCD_Lot = M.LTM_LotNumber
  
  )
 
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


