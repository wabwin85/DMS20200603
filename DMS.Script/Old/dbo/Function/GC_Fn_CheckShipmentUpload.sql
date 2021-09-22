 DROP Function [dbo].[GC_Fn_CheckShipmentUpload]
GO

 CREATE Function [dbo].[GC_Fn_CheckShipmentUpload]
 (@SPHID uniqueidentifier)
 returns int
 as
 begin
	declare @STR int --1代表未上传附件
		--未上传发票
	IF((select COUNT(*) from Attachment	where AT_Main_ID = @SPHID) = 0)
	begin
		--二维码信息全
		IF((select COUNT(*) from ShipmentHeader
		inner join ShipmentLine on  SPH_ID = SPL_SPH_ID
		inner join ShipmentLot on SPL_ID = SLT_SPL_ID
		inner join DealerMaster on SPH_Dealer_DMA_ID = DMA_ID
		inner join Lot on SLT_LOT_ID = LOT_ID
		inner join LotMaster on LTM_ID = LOT_LTM_ID
		left join [QRcodeDB].[dbo].[stagehpsalesvalidate] on substring(LTM_LotNumber,charindex('@',LTM_LotNumber)+2,len(LTM_LotNumber)-charindex('@',LTM_LotNumber)+2) = qrcode
		and DMA_SAP_Code = dealercode
		where SPH_ID =@SPHID
		and id is null ) = 0)
		begin
			set @STR = 0
		end
		--二维码信息不全
		else
		begin
			set @STR = 1
		end
	end
	else
	begin
		set @STR = 0
	end
	
 return @STR
 end
 
GO


