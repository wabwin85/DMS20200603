DROP FUNCTION [dbo].[fn_GetPurchaseProductLine]
GO




CREATE FUNCTION [dbo].[fn_GetPurchaseProductLine] (
   @DealerId     UNIQUEIDENTIFIER,
   --@CfnId        UNIQUEIDENTIFIER,
   @PurchaseOrder nvarchar(100))

   RETURNS nvarchar(50)
AS
   BEGIN
      DECLARE @RtnVal   nvarchar(50)

         select top 1 @RtnVal=ATTRIBUTE_NAME from PurchaseOrderHeader (nolock)
         --left join PurchaseOrderDetail (nolock) on POH_ID=POD_POH_ID 
         left join View_ProductLine on Id=POH_ProductLine_BUM_ID   
         where POH_DMA_ID=@DealerId 
         --and POD_CFN_ID=@CfnId
         and POH_OrderNo=@PurchaseOrder
             
             
      RETURN @RtnVal;
   END



GO


