DROP view [dbo].[V_Transfer_UPNLOT_MaxTransferDate]
GO

CREATE view [dbo].[V_Transfer_UPNLOT_MaxTransferDate] as 
select L.TRL_ToWarehouse_WHM_ID AS WHM_ID, L.TRL_TransferPart_PMA_ID AS PMA_ID,LM.LTM_LotNumber AS LotNumber,max(TF.TRN_TransferDate) AS TransferDate
from [Transfer] TF(NOLOCK), TransferLine L(NOLOCK), TransferLot T(NOLOCK), Lot LT(NOLOCK), LotMaster LM(NOLOCK)
where TF.TRN_ID = L.TRL_TRN_ID and L.TRL_ID=T.TLT_TRL_ID
and ISNULL(T.IAL_QRLOT_ID, T.TLT_LOT_ID) = LT.LOT_ID
and LT.LOT_LTM_ID = LM.LTM_ID
and TF.TRN_Type in ('Transfer','TransferConsignment')
group by L.TRL_TransferPart_PMA_ID,L.TRL_ToWarehouse_WHM_ID,LM.LTM_LotNumber
GO


