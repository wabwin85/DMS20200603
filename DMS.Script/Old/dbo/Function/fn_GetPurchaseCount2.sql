DROP FUNCTION [dbo].[fn_GetPurchaseCount2]
GO





create FUNCTION [dbo].[fn_GetPurchaseCount2] (
@DealerId uniqueidentifier,@ShipmentDate datetime )

   RETURNS  int
AS
   BEGIN
      DECLARE @IsPurchased  int
         select @IsPurchased=COUNT(POH_ID) from PurchaseOrderHeader
         where POH_OrderStatus not in ('Draft','Revoked','Revoking')
         and POH_DMA_ID=@DealerId and POH_SubmitDate<=@ShipmentDate
       if @IsPurchased>0
        set @IsPurchased=1
       else
       set @IsPurchased=0
             
      RETURN @IsPurchased;
   END




GO


