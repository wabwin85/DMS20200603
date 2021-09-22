DROP procedure [dbo].[GC_GetDealerInventoryReceiptDate]
GO


create procedure [dbo].[GC_GetDealerInventoryReceiptDate]
as
-----------------------
--60天内的收货，且表中不存在的
-----------------------
insert into DealerInventory_ReceiptDate
select NEWID(),PRH_Dealer_DMA_ID, DMA_Parent_DMA_ID,PRH_WHM_ID,PMA_UPN,substring(PRL_LotNumber,0,CHARINDEX('@@',PRL_LotNumber)),
substring(PRL_LotNumber,CHARINDEX('@@',PRL_LotNumber)+2,LEN(PRL_LotNumber)),PRL_ReceiptQty,DivisionName,DivisionCode,null,PRH_ReceiptDate
--select *
from POReceiptHeader(nolock),POReceipt(nolock),POReceiptLot(nolock),DealerMaster(nolock),Product(nolock),CFN(nolock),V_DivisionProductLineRelation
where PRH_ID = POR_PRH_ID
and POR_ID = PRL_POR_ID
and PRH_Dealer_DMA_ID = DMA_ID
and POR_SAP_PMA_ID = PMA_ID
and PMA_CFN_ID = CFN_ID
and CFN_ProductLine_BUM_ID = ProductLineID
and PRH_ReceiptDate>dateadd(d,-60,getdate())
and not exists 
(select 1 from DealerInventory_ReceiptDate AS RD where RD.DealerID = PRH_Dealer_DMA_ID and RD.WHMID =PRH_WHM_ID and RD.LOT = substring(PRL_LotNumber,0,CHARINDEX('@@',PRL_LotNumber))
and QRCode = substring(PRL_LotNumber,CHARINDEX('@@',PRL_LotNumber)+2,LEN(PRL_LotNumber)) and PRH_ReceiptDate = ReceiptDate)

-----------------------
--60天内的移库，且表中不存在的
-----------------------

insert into DealerInventory_ReceiptDate
select NEWID(),TRN_ToDealer_DMA_ID, DMA_Parent_DMA_ID,TRL_ToWarehouse_WHM_ID,PMA_UPN,substring(LTM_LotNumber,0,CHARINDEX('@@',LTM_LotNumber)),
substring(LTM_LotNumber,CHARINDEX('@@',LTM_LotNumber)+2,LEN(LTM_LotNumber)),TLT_TransferLotQty,DivisionName,DivisionCode,TRN_TransferDate,TRN_TransferDate
--select COUNT(*)
from transfer(NOLOCK),TransferLine(NOLOCK),TransferLot(NOLOCK),DealerMaster(NOLOCK),LOT(NOLOCK),LotMaster(NOLOCK),Product(NOLOCK),CFN(NOLOCK),V_DivisionProductLineRelation
where TRN_ID = TRL_TRN_ID
and TRL_ID = TLT_TRL_ID
and TRN_ToDealer_DMA_ID = DMA_ID
and TRL_TransferPart_PMA_ID = PMA_ID
and PMA_CFN_ID = CFN_ID
and CFN_ProductLine_BUM_ID = ProductLineID
AND TLT_LOT_ID = LOT_ID
AND LOT_LTM_ID = LTM_ID
and TRN_TransferDate>dateadd(d,-60,getdate())
--and convert(nvarchar(10),TRN_TransferDate,120) = convert(nvarchar(10),GETDATE(),120)
and not exists 
(select 1 from DealerInventory_ReceiptDate AS RD where RD.DealerID = TRN_ToDealer_DMA_ID and RD.WHMID =TRL_ToWarehouse_WHM_ID and RD.LOT = substring(LTM_LotNumber,0,CHARINDEX('@@',LTM_LotNumber))
and QRCode = substring(LTM_LotNumber,CHARINDEX('@@',LTM_LotNumber)+2,LEN(LTM_LotNumber)) and TRN_TransferDate = ReceiptDate)

GO