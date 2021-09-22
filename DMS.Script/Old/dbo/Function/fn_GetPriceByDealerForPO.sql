DROP FUNCTION [dbo].[fn_GetPriceByDealerForPO]
GO

CREATE FUNCTION [dbo].[fn_GetPriceByDealerForPO]
(
	@DealerId uniqueidentifier,
	@CfnId uniqueidentifier
)  
  RETURNS decimal(18,6)
AS  
BEGIN
DECLARE @RtnVal decimal(18,6)

	select @RtnVal = CFNP_Price from dbo.CFNPrice 
	where CFNP_CFN_ID = @CfnId and CFNP_PriceType = 'Dealer' and CFNP_Group_ID = @DealerId
	AND CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 AND CFNP_Price > 0

	IF (@RtnVal IS NULL)
		BEGIN
			select @RtnVal = CFNP_Price from dbo.CFNPrice 
			where CFNP_CFN_ID = @CfnId and CFNP_PriceType = 'Base'
			AND CFNP_DeletedFlag = 0 AND CFNP_CanOrder = 1 AND CFNP_Price > 0
		END
		
	RETURN @RtnVal;
END
GO


