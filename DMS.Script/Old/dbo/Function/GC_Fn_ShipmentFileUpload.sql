DROP function [dbo].[GC_Fn_ShipmentFileUpload]
GO



CREATE function [dbo].[GC_Fn_ShipmentFileUpload]
(
@DMA_ID UNIQUEIDENTIFIER
)
RETURNS @tbReturn TABLE 
(
		cnt int
)
	WITH
	EXECUTE AS CALLER
AS

    BEGIN
insert into @tbReturn
select count(*) from (
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
when substring(convert(nvarchar(6),getdate(),112),5,2) in ('10','11','12') then convert(nvarchar(4),getdate(),112)+'0930'
else convert(nvarchar(4),dateadd(year,-1,getdate()),112)+ '1231' end)
--没有上传附件，或者二维码信息不全，都需要限制报销量
and (AT_ID is null or exists (select 1 from dbo.V_stagehpsalesvalidate v where v.SPH_ShipmentNbr = ShipmentHeader.SPH_ShipmentNbr
and DealerMaster.DMA_ID = v.SPH_Dealer_DMA_ID))
and SPH_ShipmentNbr not like '%ADJ%'
and shipmentlot.AdjType is null 
and DealerMaster.DMA_ID not in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A','57DFF22F-EEF3-4BDB-973D-50756F142DFA','84C83F71-93B4-4EFD-AB51-12354AFABAC3')
and DMA_Parent_DMA_ID not in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A')
and SPH_ProductLine_BUM_ID = '0f71530b-66d5-44af-9cab-ad65d5449c51'
and DMA_Taxpayer not in('直销医院')
and DealerMaster.DMA_ID = @DMA_ID
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
and (AT_ID is null or exists (select 1 from dbo.V_stagehpsalesvalidate v where v.SPH_ShipmentNbr = ShipmentHeader.SPH_ShipmentNbr
and DealerMaster.DMA_ID = v.SPH_Dealer_DMA_ID))
and SPH_ShipmentNbr not like '%ADJ%'
and shipmentlot.AdjType is null 
and DealerMaster.DMA_ID not in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A','57DFF22F-EEF3-4BDB-973D-50756F142DFA','84C83F71-93B4-4EFD-AB51-12354AFABAC3')
and DMA_Parent_DMA_ID not in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A')
and SPH_ProductLine_BUM_ID <> '0f71530b-66d5-44af-9cab-ad65d5449c51'
and DMA_Taxpayer not in('直销医院')
and DealerMaster.DMA_ID = @DMA_ID
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
where SPH_Status not in ('Reversed','Draft')
and SPH_SubmitDate >='2017-01-01'
and DATEDIFF(DAY,SPH_SubmitDate ,GETDATE()) > 0
and (AT_ID is null or exists (select 1 from dbo.V_stagehpsalesvalidate v where v.SPH_ShipmentNbr = ShipmentHeader.SPH_ShipmentNbr
and DealerMaster.DMA_ID = v.SPH_Dealer_DMA_ID))
and SPH_ShipmentNbr not like '%ADJ%'
and shipmentlot.AdjType is null 
and (DMA_ID  in ('33029AF0-CFCF-495E-B057-550D16C41E4A')
or DMA_Parent_DMA_ID in ('A54ADD15-CB13-4850-9848-6DA4576207CB','33029AF0-CFCF-495E-B057-550D16C41E4A'))
and DMA_ID <> '57DFF22F-EEF3-4BDB-973D-50756F142DFA'
and DMA_Taxpayer not in('直销医院')
and DealerMaster.DMA_ID = @DMA_ID
) tab

Return
end


GO


