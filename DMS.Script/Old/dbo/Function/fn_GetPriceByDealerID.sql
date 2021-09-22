DROP FUNCTION [dbo].[fn_GetPriceByDealerID]
GO

/*
此函数取得的价格仅为产品标准价格，注意大多数报表金额都是根据这个函数计算得到
*/
CREATE FUNCTION [dbo].[fn_GetPriceByDealerID]
(
	@DealerID uniqueidentifier,
	@CFNID uniqueidentifier
)  
  RETURNS decimal
AS  
BEGIN

DECLARE @rtn decimal

select @rtn = CFNP_Price from dbo.CFNPrice where CFNP_CFN_ID = @CFNID and CFNP_PriceType = 'Base'

RETURN @rtn;

END
GO


