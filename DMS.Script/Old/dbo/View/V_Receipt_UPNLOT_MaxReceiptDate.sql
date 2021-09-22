DROP view [dbo].[V_Receipt_UPNLOT_MaxReceiptDate]
GO

create view [dbo].[V_Receipt_UPNLOT_MaxReceiptDate] as 
select PRH_WHM_ID AS WHM_ID, POR_SAP_PMA_ID AS PMA_ID, PRL_LotNumber AS LotNumber,max(ReceiptDate) aS ReceiptDate
from 
(
select H.PRH_Dealer_DMA_ID , L.POR_SAP_PMA_ID , H.PRH_WHM_ID,T.PRL_LotNumber,
isnull(PRH_ReceiptDate,(select max(POL_OperDate) from purchaseorderlog where pol_poh_id=H. PRH_ID and POL_OperType='Confirm')) AS ReceiptDate

from POReceiptHeader H(NOLOCK), POReceipt L(NOLOCK),  POReceiptLot T(NOLOCK)
where H.PRH_ID = L.POR_PRH_ID and L.POR_ID = T.PRL_POR_ID
and H.PRH_Status = 'Complete'
) tab
group BY POR_SAP_PMA_ID , PRH_WHM_ID,PRL_LotNumber
GO


