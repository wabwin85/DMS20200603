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
/*���ݶ����ź�CFNID���ڶ�����ϸ���в����Ƿ��м۸�*/
select @result = pod.POD_CFN_Price
      from PurchaseOrderHeader poh,PurchaseOrderDetail pod
      where poh.POH_ID = pod.POD_POH_ID
      and poh.POH_OrderNo = @OrderNo
      and pod.POD_CFN_ID = @CFNID
      
/*�����ϸ����û�м۸���ͨ��������ID�Ͳ�ƷIDȥCFN_PRICE����ȡ�۸�*/      
if (isnull(@result,0)=0)
  BEGIN
    select @result = dbo.fn_GetPriceByDealerID(@DealerID,@CFNID)
    GOTO Cleanup
  END
  


Cleanup: 
	RETURN @result;
END
GO


