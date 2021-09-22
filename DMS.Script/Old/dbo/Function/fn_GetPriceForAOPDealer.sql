DROP FUNCTION [dbo].[fn_GetPriceForAOPDealer]
GO


CREATE FUNCTION [dbo].[fn_GetPriceForAOPDealer]
(
	@DealerID uniqueidentifier,
	@CFNID uniqueidentifier,
  @OrderNo nvarchar(50)
)  
  RETURNS decimal
AS  
BEGIN
DECLARE @result decimal
/*根据订单号和CFNID，在订单明细表中查找是否有价格*/
select @result = pod.POD_CFN_Price
      from PurchaseOrderHeader poh,PurchaseOrderDetail pod
      where poh.POH_ID = pod.POD_POH_ID
      and poh.POH_OrderNo = @OrderNo
      and pod.POD_CFN_ID = @CFNID
      
/*如果明细表中没有价格，则通过经销商ID和产品ID去CFN_PRICE表中取价格*/      
if (isnull(@result,0)=0)
  BEGIN
    select @result = dbo.fn_GetPriceByDealerID(@DealerID,@CFNID)
    GOTO Cleanup
  END
  


Cleanup: 
	RETURN @result;
END
GO


