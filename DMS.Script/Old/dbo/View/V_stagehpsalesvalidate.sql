DROP view [dbo].[V_stagehpsalesvalidate]
GO

create view [dbo].[V_stagehpsalesvalidate]
as
--没有上传过附件，并且二维码不完全
select distinct SPH_ShipmentNbr,SPH_Dealer_DMA_ID,SPH_ProductLine_BUM_ID from ShipmentHeader
inner join ShipmentLine on SPH_ID = SPL_SPH_ID
inner join ShipmentLot on SPL_ID = SLT_SPL_ID
inner join Lot on SLT_LOT_ID = LOT_ID
inner join LotMaster on LOT_LTM_ID = LTM_ID
inner join DealerMaster on SPH_Dealer_DMA_ID = DMA_ID
left join Attachment on SPH_ID = AT_Main_ID
left join [QRcodeDB].[dbo].[stagehpsalesvalidate]  on substring(LTM_LotNumber,charindex('@',LTM_LotNumber)+2,len(LTM_LotNumber)-charindex('@',LTM_LotNumber)+2) = qrcode
and DMA_SAP_Code = dealercode
where AT_ID is null
and id is null 

GO


