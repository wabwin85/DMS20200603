DROP Function [interface].[fn_GetPurchasePrice]
GO







CREATE Function [interface].[fn_GetPurchasePrice]
(@CFN_ID uniqueidentifier,
@DealerId uniqueidentifier,
 @SPH_Type nvarchar(50))
returns Decimal(18,6)
as
Begin
DECLARE @rtn decimal(18,6)
Declare @DealerType nvarchar(50),@ParentId uniqueidentifier
select @DealerType=DMA_DealerType,@ParentId=DMA_Parent_DMA_ID  from DealerMaster(nolock)
where
DMA_ID=@DealerId
 --DMA_DeletedFlag=0 and DMA_ActiveFlag=1 and @DealerId=DMA_ID

if @SPH_Type='Hospital' and @DealerType='T2'
select top 1 @rtn=CFNP_Price from CFNPrice
where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='Dealer'
and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @ParentId

else if @SPH_Type='Hospital' and @DealerType<>'T2'
select top 1 @rtn=CFNP_Price from CFNPrice
where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='Dealer'
and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @DealerId

--if @SPH_Type='1' and @DealerType='T2'
--select top 1 @rtn=CFNP_Price from CFNPrice
--where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='Dealer'
--and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @ParentId
--if @SPH_Type='1' and @DealerType<>'T2'
--select top 1 @rtn=CFNP_Price from CFNPrice
--where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='Dealer'
--and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @DealerId

else if @SPH_Type <>'Hospital' and @DealerType='T2'
select top 1 @rtn=CFNP_Price from CFNPrice
where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='DealerConsignment'
and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @ParentId

else
select top 1 @rtn=CFNP_Price from CFNPrice
where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType='DealerConsignment'
and CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 and CFNP_Group_ID = @DealerId


return @rtn
end






GO


