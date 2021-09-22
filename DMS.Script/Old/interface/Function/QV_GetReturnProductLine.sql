DROP FUNCTION [interface].[QV_GetReturnProductLine] 
GO





Create FUNCTION [interface].[QV_GetReturnProductLine] (
   @DealerId     UNIQUEIDENTIFIER,
     @PRH_Id UNIQUEIDENTIFIER )

   RETURNS nvarchar(50)
AS
   BEGIN
      DECLARE @RtnVal   nvarchar(50)
      Declare @PurchaseOrder nvarchar(100)
      
        select @PurchaseOrder=PRH_PurchaseOrderNbr  from POReceiptHeader
		where PRH_ID=@PRH_Id

         select top 1 @RtnVal=ATTRIBUTE_NAME from PurchaseOrderHeader (nolock)
         --left join PurchaseOrderDetail (nolock) on POH_ID=POD_POH_ID 
         left join View_ProductLine on Id=POH_ProductLine_BUM_ID   
         where POH_DMA_ID=@DealerId 
         --and POD_CFN_ID=@CfnId
         and POH_OrderNo=@PurchaseOrder
             
             
      RETURN @RtnVal;
   END




GO


