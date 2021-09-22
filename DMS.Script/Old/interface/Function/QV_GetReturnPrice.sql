DROP Function [interface].[QV_GetReturnPrice]
GO













CREATE Function [interface].[QV_GetReturnPrice]
(@CFN_ID uniqueidentifier,
@DealerId uniqueidentifier)
returns Decimal(18,6)
as
Begin
DECLARE @rtn decimal(18,6)
--Declare @Type nvarchar(50) 
--select @Type=IAH_WarehouseType from InventoryAdjustHeader
--where IAH_Reason in ('Return','Exchange') and IAH_Status='Accept'
--and IAH_ApprovalDate>'2014-06-12'

--if @Type='Normal'
select @rtn=isnull(CFNP_Price,0) from CFNPrice
where  CFNP_CFN_ID=@CFN_ID and CFNP_Group_ID=@DealerId and CFNP_PriceType='Dealer'
--else
--select @rtn=isnull(CFNP_Price,0) from CFNPrice
--where  CFNP_CFN_ID=@CFN_ID and CFNP_Group_ID=@DealerId and CFNP_PriceType='DealerConsignment'

return @rtn
end












GO


