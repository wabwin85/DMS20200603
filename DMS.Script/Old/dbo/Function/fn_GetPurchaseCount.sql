
DROP FUNCTION [dbo].[fn_GetPurchaseCount]
GO




CREATE FUNCTION [dbo].[fn_GetPurchaseCount] (
@DealerId uniqueidentifier )

   RETURNS  int
AS
   BEGIN
      DECLARE @IsPurchased  int
         select @IsPurchased=COUNT(POH_ID) from PurchaseOrderHeader
         where POH_OrderStatus not in ('Draft','Revoked','Revoking')
         and POH_DMA_ID=@DealerId
       if @IsPurchased>0
        set @IsPurchased=1
       else
       set @IsPurchased=0
             
      RETURN @IsPurchased;
   END



GO


