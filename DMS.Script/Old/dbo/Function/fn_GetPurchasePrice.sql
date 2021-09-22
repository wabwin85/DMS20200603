DROP FUNCTION [dbo].[fn_GetPurchasePrice]
GO



CREATE FUNCTION [dbo].[fn_GetPurchasePrice] (
   @DealerId     UNIQUEIDENTIFIER,
   @CfnId        UNIQUEIDENTIFIER,
   @PurchaseOrder nvarchar(100))

   RETURNS DECIMAL (18, 6)
AS
   BEGIN
      DECLARE @RtnVal   DECIMAL (18, 6)

         select top 1 @RtnVal=POD_CFN_Price from PurchaseOrderHeader (nolock)
         left join PurchaseOrderDetail (nolock) on POH_ID=POD_POH_ID    
         where POH_DMA_ID=@DealerId and POD_CFN_ID=@CfnId
         and POH_OrderNo=@PurchaseOrder
             
             
      RETURN @RtnVal;
   END


GO


