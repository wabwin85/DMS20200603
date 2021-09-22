DROP Function [dbo].[fn_GetCanShipFlag] 
GO


 
CREATE Function [dbo].[fn_GetCanShipFlag] 
	(@CFN_Property6 int,@LotNumber nvarchar(30),@UPN nvarchar(30),
	 @DmaId nvarchar(200)) 
	   
		returns  nvarchar(6)
as

Begin
    declare @EnabledFlag nvarchar(6) 
    If exists( select 1 from ShipmentHeader(Nolock)
      join ShipmentLine on SPH_ID=SPL_SPH_ID
      join ShipmentLot on SPL_ID=SLT_SPL_ID
      JOIN Product ON ShipmentLine.SPL_Shipment_PMA_ID = Product.PMA_ID
      JOIN Lot ON ShipmentLot.SLT_LOT_ID = Lot.LOT_ID
      JOIN LotMaster ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
      where LTM_LotNumber=@LotNumber and PMA_UPN=@UPN and @CFN_Property6=1
      and SPH_Dealer_DMA_ID=@DmaId and SPH_Status='Complete' and PMA_UPN not like '66%'
      )
      set @EnabledFlag='·ñ'
      else set @EnabledFlag='ÊÇ'
        return @EnabledFlag
End




GO


