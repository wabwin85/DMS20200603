DROP view [interface].[V_I_QV_DealerInvTransfer_WithQR]
GO






CREATE view [interface].[V_I_QV_DealerInvTransfer_WithQR]
as 
select DM.DMA_SAP_CODE ,DM.DMA_ChineseName,  t1.TRN_FromDealer_DMA_ID AS DMA_ID,t1.TRN_TransferDate AS TransferDate,t1.TRN_TransferNumber AS Nbr,t1.TRN_Type As [Type],
t2.TRL_TransferPart_PMA_ID AS PMA_ID,
wf.WHM_Code FromWHMCode,wf.WHM_Name FromWarehouse,
wt.WHM_Code ToWHMCode,wt.WHM_Name ToWarehouse,
t3.TLT_TransferLotQty AS Qty,t6.PMA_UPN AS UPN,
    CASE 
		WHEN charindex('@@', LTM_LotNumber) > 0
			THEN substring(LTM_LotNumber, 1, charindex('@@', LTM_LotNumber) - 1)
		ELSE LTM_LotNumber
		END AS LOT
	,CASE 
		WHEN charindex('@@', LTM_LotNumber) > 0
			THEN substring(LTM_LotNumber, charindex('@@', LTM_LotNumber) + 2, len(LTM_LotNumber))
		ELSE ''
		END AS QRCode
,CAST(DataSrc.DataSrc AS NVARCHAR(50)) DataSrc
	,CAST(CASE 
		WHEN OperType = 'Submit'
			THEN CASE 
					WHEN DataSrc = 'JY'
						THEN 'JY数据'
					WHEN DataSrc = 'FWRW'
						THEN '服务入微'
					ELSE '手工录入'
					END
		WHEN OperType = 'Generate'
			THEN '批量上传'
		WHEN OperType = 'CreateShipment'
			THEN CASE 
					WHEN DataSrc = 'JY'
						THEN 'JY数据'
					ELSE '服务入微'
					END
		ELSE '手工录入'
		END AS NVARCHAR(50)) AS QRSrc
,t5.LTM_ExpiredDate as ExpDate
from Transfer t1 inner join  
TransferLine t2(nolock) on (t1.TRN_ID =t2.TRL_TRN_ID) 
inner join TransferLot t3(nolock) on (t2.TRL_ID =t3.TLT_TRL_ID)
INNER join lot t4(nolock) on (t4.LOT_ID =  isnull(t3.IAL_QRLOT_ID,t3.TLT_LOT_ID))
INNER JOIN LotMaster t5 (NOLOCK) ON t4.LOT_LTM_ID = t5.LTM_ID
inner join product t6(nolock) on (t6.PMA_ID = t2.TRL_TransferPart_PMA_ID)
inner join warehouse wf(nolock) on (wf.WHM_ID = t2.TRL_FromWarehouse_WHM_ID)
inner join warehouse wt(nolock) on (wt.WHM_ID = t2.TRL_ToWarehouse_WHM_ID)
inner join DealerMaster DM(nolock) on (DM.DMA_ID = t1.TRN_FromDealer_DMA_ID )
LEFT JOIN Interface.Stage_V_DealerInvTransferOperType OperType ON (t1.TRN_ID = OperType.TRN_ID)
LEFT JOIN Interface.Stage_V_DealerInvTransferDataSrc DataSrc ON (
		DataSrc.QRC_QRCode = CASE 
			WHEN charindex('@@', t5.LTM_LotNumber) > 0
				THEN substring(t5.LTM_LotNumber, charindex('@@', t5.LTM_LotNumber) + 2, len(t5.LTM_LotNumber))
			ELSE ''
			END
		)
where TRN_Type='Transfer'
and TRN_Status='Complete'
and TRN_TransferDate>'2016-01-01'
and ISNULL(DM.DMA_Taxpayer,'')<>'直销医院'





GO


