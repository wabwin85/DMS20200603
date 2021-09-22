DROP view [dbo].[V_ShipmentFileUpload]
GO










CREATE view [dbo].[V_ShipmentFileUpload]
as 

--IC产品线 校验从2017-1-1到上季度最后一天是否上传过发票
select distinct SPH_Dealer_DMA_ID,SPH_ID,SPH_ShipmentNbr, LTM_LotNumber,SPH_ProductLine_BUM_ID,ProductLineName
from ShipmentHeader(NOLOCK)
inner join ShipmentLine(NOLOCK) on SPH_ID = SPL_SPH_ID
inner join shipmentlot(NOLOCK) on SPL_ID = SLT_SPL_ID
inner join DealerMaster(NOLOCK) on SPH_Dealer_DMA_ID = DMA_ID
inner join Lot(NOLOCK) on SLT_LOT_ID = LOT_ID
inner join LotMaster(NOLOCK) on LTM_ID = LOT_LTM_ID
inner join V_DivisionProductLineRelation(NOLOCK) on ProductLineID = SPH_ProductLine_BUM_ID
left join Attachment(NOLOCK) on SPH_ID = AT_Main_ID
left join BULimit(NOLOCK) on SPH_ProductLine_BUM_ID =ProductLine_BUM_ID and Limit_Type = 'ShipmentUpload'
where SPH_Status not in ('Reversed','Draft')
and convert(nvarchar(8),SPH_SubmitDate,112) between '20170101' and (select  
case when substring(convert(nvarchar(6),getdate(),112),5,2) in ('04','05','06') then convert(nvarchar(4),getdate(),112)+'0331' 
when substring(convert(nvarchar(6),getdate(),112),5,2) in ('07','08','09') then convert(nvarchar(4),getdate(),112)+'0331'
when substring(convert(nvarchar(6),getdate(),112),5,2) in ('10','11','12') then convert(nvarchar(4),getdate(),112)+'0630'
else convert(nvarchar(4),dateadd(year,-1,getdate()),112)+ '1231' end)
--没有上传附件，或者二维码信息不全，都需要限制报销量
and ( dbo.GC_Fn_CheckShipmentUpload(SPH_ID)=1)
and SPH_ShipmentNbr not like '%ADJ%'
and shipmentlot.AdjType is null 
and DealerMaster.DMA_ID not in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A','57DFF22F-EEF3-4BDB-973D-50756F142DFA','84C83F71-93B4-4EFD-AB51-12354AFABAC3','5DB1C4A8-1712-475A-B27C-A31C0106A256','B60C9C99-CFF3-4628-BEB4-A2E000FB1F47')
and DMA_Parent_DMA_ID not in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A')
and DMA_Taxpayer not in('直销医院')
and SPH_ProductLine_BUM_ID = '0f71530b-66d5-44af-9cab-ad65d5449c51'
UNION ALL
--非IC产品线的红海
select distinct SPH_Dealer_DMA_ID,SPH_ID,SPH_ShipmentNbr, LTM_LotNumber,SPH_ProductLine_BUM_ID,ProductLineName
from ShipmentHeader(NOLOCK)
inner join ShipmentLine(NOLOCK) on SPH_ID = SPL_SPH_ID
inner join shipmentlot(NOLOCK) on SPL_ID = SLT_SPL_ID
inner join DealerMaster(NOLOCK) on SPH_Dealer_DMA_ID = DMA_ID
inner join Lot(NOLOCK) on SLT_LOT_ID = LOT_ID
inner join LotMaster(NOLOCK) on LTM_ID = LOT_LTM_ID
inner join V_DivisionProductLineRelation(NOLOCK) on ProductLineID = SPH_ProductLine_BUM_ID
left join Attachment(NOLOCK) on SPH_ID = AT_Main_ID
left join BULimit(NOLOCK) on SPH_ProductLine_BUM_ID =ProductLine_BUM_ID and Limit_Type = 'ShipmentUpload'
where SPH_Status not in ('Reversed','Draft')
and SPH_SubmitDate >='2017-01-01'
and DATEDIFF(DAY,SPH_SubmitDate,GETDATE()) > CONVERT(int,isnull(Reason,90))
and (dbo.GC_Fn_CheckShipmentUpload(SPH_ID)=1)
and SPH_ShipmentNbr not like '%ADJ%'
and shipmentlot.AdjType is null 
and DealerMaster.DMA_ID not in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A','57DFF22F-EEF3-4BDB-973D-50756F142DFA','AE5CAF42-AFBC-498B-93B3-A2AE00A42B1F','B60C9C99-CFF3-4628-BEB4-A2E000FB1F47')
and DMA_Parent_DMA_ID not in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A')
and DMA_Taxpayer not in('直销医院')
and SPH_ProductLine_BUM_ID <> '0f71530b-66d5-44af-9cab-ad65d5449c51'
UNION ALL
select distinct SPH_Dealer_DMA_ID,SPH_ID,SPH_ShipmentNbr, LTM_LotNumber,SPH_ProductLine_BUM_ID,ProductLineName
from ShipmentHeader(NOLOCK)
inner join ShipmentLine(NOLOCK) on SPH_ID = SPL_SPH_ID
inner join shipmentlot(NOLOCK) on SPL_ID = SLT_SPL_ID
inner join DealerMaster(NOLOCK) on SPH_Dealer_DMA_ID = DMA_ID
inner join Lot(NOLOCK) on SLT_LOT_ID = LOT_ID
inner join LotMaster(NOLOCK) on LTM_ID = LOT_LTM_ID
inner join V_DivisionProductLineRelation(NOLOCK) on ProductLineID = SPH_ProductLine_BUM_ID
left join Attachment(NOLOCK) on SPH_ID = AT_Main_ID
--left join BULimit on SPH_ProductLine_BUM_ID =ProductLine_BUM_ID and Limit_Type = 'ShipmentUpload'
where SPH_Status not in ('Reversed','Draft')
and SPH_SubmitDate >='2017-01-01'
and DATEDIFF(DAY,SPH_SubmitDate ,GETDATE()) > 900
and (dbo.GC_Fn_CheckShipmentUpload(SPH_ID)=1)
and SPH_ShipmentNbr not like '%ADJ%'
and shipmentlot.AdjType is null 
and (DMA_ID  in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A')
or DMA_Parent_DMA_ID in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A'))
and DMA_Taxpayer not in('直销医院')
and DMA_ID <> '57DFF22F-EEF3-4BDB-973D-50756F142DFA'












GO






GO


