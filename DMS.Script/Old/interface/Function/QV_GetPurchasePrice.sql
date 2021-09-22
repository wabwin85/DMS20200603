
DROP FUNCTION [interface].[QV_GetPurchasePrice] 
GO









CREATE FUNCTION [interface].[QV_GetPurchasePrice] (
   @DealerId     UNIQUEIDENTIFIER,
   @CFN_ID       UNIQUEIDENTIFIER)
   --@PurchaseOrder nvarchar(100))

    RETURNS DECIMAL (18, 6)
AS
   BEGIN
      DECLARE @rtn   DECIMAL (18, 6)
      Declare @OrderType nvarchar(50)
      Declare @DealerType nvarchar(50),@ParentId uniqueidentifier

		 --select top 1 @OrderType=POH_OrderType from PurchaseOrderHeader (nolock)
		 --where POH_DMA_ID=@DealerId  and POH_OrderNo=@PurchaseOrder
	     
		 select @DealerType=DMA_DealerType,@ParentId=DMA_Parent_DMA_ID  from DealerMaster(nolock)
		 where DMA_ID=@DealerId
		 
		 
		
		select top 1 @rtn=CFNP_Price from CFNPrice
		where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='Dealer'
		and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @ParentId
	
		 
         
		--if @OrderType='Normal' and @DealerType='T2'
		--select top 1 @rtn=CFNP_Price from CFNPrice
		--where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='Dealer'
		--and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @ParentId
		--else if @OrderType='Normal' and @DealerType<>'T2'
		--select top 1 @rtn=CFNP_Price from CFNPrice
		--where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='Dealer'
		--and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @DealerId

		--else if @DealerType='T2' and @OrderType <>'Normal'
		--select top 1 @rtn=CFNP_Price from CFNPrice
		--where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='DealerConsignment'
		--and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @ParentId

		--else 
		--select top 1 @rtn=CFNP_Price from CFNPrice
		--where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='DealerConsignment'
		--and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @DealerId

             
             
      RETURN @rtn;
   END






GO


