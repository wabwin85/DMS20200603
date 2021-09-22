DROP View [interface].[V_I_QV_InventoryDailyBak_WithQR]
GO






CREATE View [interface].[V_I_QV_InventoryDailyBak_WithQR]

as

select 
t5.DMA_ID as DealerID
,T5.DMA_SAP_Code as SAPID
,t6.PMA_UPN as UPN
,convert(decimal(18,2),t2.LOT_OnHandQty) as QTY
,t4.WHM_Code
--,t3.LTM_LotNumber
,LOT = CASE WHEN charindex('@@',t3.LTM_LotNumber) > 0 
                  THEN substring(t3.LTM_LotNumber,1,charindex('@@',t3.LTM_LotNumber)-1) 
                  ELSE t3.LTM_LotNumber
                  END 
,QRCode = CASE WHEN charindex('@@',t3.LTM_LotNumber) > 0
                THEN substring(t3.LTM_LotNumber,charindex('@@',t3.LTM_LotNumber)+2,len(t3.LTM_LotNumber)) 
                ELSE ''
                END 
,t7.DivisionID
,INV_BAK_DATE as InventoryBakDate 
from interface.InventoryDailyBackup t1
, interface.LotDailyBackup t2
, LotMaster t3
, Warehouse t4
, DealerMaster t5
, Product t6
, interface.T_I_CR_Product t7
where t1.INV_ID=t2.LOT_INV_ID and t2.LOT_OnHandQty!=0
and t2.LOT_LTM_ID=t3.LTM_ID 
and t2.LOT_BAK_DATE=t1.INV_BAK_DATE
and t1.INV_WHM_ID=t4.WHM_ID
and t4.WHM_DMA_ID=t5.DMA_ID
and t1.INV_PMA_ID=t6.PMA_ID 
and t6.PMA_UPN=t7.UPN






GO


