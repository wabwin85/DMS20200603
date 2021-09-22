DROP FUNCTION [dbo].[fn_GetPriceByDealerID]
GO

/*
�˺���ȡ�õļ۸��Ϊ��Ʒ��׼�۸�ע������������Ǹ��������������õ�
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


