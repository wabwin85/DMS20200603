DROP FUNCTION [interface].[QV_GetReturnPurchasePrice]
GO




CREATE FUNCTION [interface].[QV_GetReturnPurchasePrice] (
   @DealerId     UNIQUEIDENTIFIER,
   @CfnId        UNIQUEIDENTIFIER,
   @PRH_Id UNIQUEIDENTIFIER )

   RETURNS DECIMAL (18, 6)
AS
   BEGIN
      DECLARE @RtnVal   DECIMAL (18, 6)
      Declare @PurchaseOrder nvarchar(50)
      
		 select @PurchaseOrder=PRH_PurchaseOrderNbr  from POReceiptHeader
		 where PRH_ID=@PRH_Id
		 
         select top 1 @RtnVal=POD_CFN_Price from PurchaseOrderHeader (nolock)
         left join PurchaseOrderDetail (nolock) on POH_ID=POD_POH_ID    
         where POH_DMA_ID=@DealerId and POD_CFN_ID=@CfnId
         and POH_OrderNo=@PurchaseOrder
             
             
      RETURN @RtnVal;
   END



GO


