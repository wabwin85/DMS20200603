DROP FUNCTION [dbo].[GC_Fn_Report_OrderSalesDaySumTable]
GO


--�ն������ۻ��ܱ���
CREATE FUNCTION [dbo].[GC_Fn_Report_OrderSalesDaySumTable](
	@ProductLineId uniqueidentifier,
	@dt datetime,
	@DealerId uniqueidentifier
)
RETURNS @temp TABLE 
(
	 ProductLineBUMId uniqueidentifier NULL,	--��Ʒ��ID
	 ProductLineName Nvarchar(100) NULL,		--��Ʒ������
	 MonthSalesAmount decimal(18,6) NULL,		--�����۽��
	 DaySalesAmount decimal(18,6) NULL,			--�����۽��
	 InLibraries decimal(18,6) NULL,			--�ڿ���
	 NotInLibraries decimal(18,6) NULL,			--���ڿ���
	 YearSalesAmount decimal(18,6) NULL			--�����۽��	  
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
    --�½���ʱ��
    declare @t table(
		BUMId uniqueidentifier,
		CFNId uniqueidentifier,
		Qty decimal(18,6),
		Price decimal(18,6),		
		SAPShipmentDate datetime --��������
		)
	--��ʱ��������� ��ѯ��ָ�����ڵ���һ��һ�յ�ָ�����ڵ�����
	--���ⵥ�������ӳ��ⵥ��ϸ��,����Product��,����Product���PMA_ID��PMA_CFN_IDʹ���ⵥ��Ͷ��������	  
  insert into @t 
	select PRH_ProductLine_BUM_ID,POD_CFN_ID,POR_ReceiptQty,POD_CFN_Price,PH.PRH_SAPShipmentDate 
	from POReceiptHeader PH
	inner join POReceipt PR on PH.PRH_ID=PR.POR_PRH_ID
	inner join Product pd on PR.POR_SAP_PMA_ID=pd.PMA_ID
	inner join PurchaseOrderHeader poh on PH.PRH_PurchaseOrderNbr=poh.POH_OrderNo 
	inner join PurchaseOrderDetail pod on poh.POH_ID=pod.POD_POH_ID and pd.PMA_CFN_ID=pod.POD_CFN_ID
	where PRH_Type='PurchaseOrder' 
	and convert(char(10),PRH_SAPShipmentDate,120) >= CONVERT(char(5),@dt,120)+'01-01'  
	and convert(char(10),PRH_SAPShipmentDate,120) <= convert(char(10),@dt,120)
	and (PH.PRH_ProductLine_BUM_ID=@ProductLineId or @ProductLineId is null)
	and poh.POH_DMA_ID = @DealerId
	--AND (dbo.GC_FilterByDealer(@UserId,poh.POH_DMA_ID,poh.POH_ProductLine_BUM_ID) = 1)

--�����۽�� ָ�����ڵ���һ��һ�ŵ�ָ�����ڵ����۽��
  insert into @temp 
	select BUMId,ProductLineName='',MonthSalesAmount=0,DaySalesAmount=0,InLibraries=0,NotInLibraries=0,sum(Qty*Price) as YearSalesAmount 
	from @t 
	group by BUMId
	
--�����۽�� ָ�����ڵ���һ�ŵ�ָ�����ڵ����۽��
	update @temp set MonthSalesAmount=A.MonthSalesAmount 
	from (select BUMId,sum(Qty*Price) as MonthSalesAmount from @t where convert(char(10),SAPShipmentDate,120) >=CONVERT(char(8),@dt,120)+'01' and convert(char(10),SAPShipmentDate,120) <=convert(char(10),@dt,120) group by BUMId) A
	where ProductLineBUMId=A.BUMId
	
--�����۽�� ָ�����ڵ�������۽��
	update @temp set DaySalesAmount=A.DaySalesAmount 
	from (select BUMId,sum(Qty*Price) as DaySalesAmount from @t where  CONVERT(char(10),SAPShipmentDate,120)=CONVERT(char(10),@dt,120) group by BUMId ) A
	where ProductLineBUMId=A.BUMId
	
--��Ʒ������
    update @temp set ProductLineName=ATTRIBUTE_NAME from dbo.Lafite_ATTRIBUTE where ATTRIBUTE_TYPE='Product_Line' and id=ProductLineBUMId

--�ڿ��� �Ӷ��������ӿڻ�ȡArticle Number�����First available date�������ѯ����ͬһ�죬����ܼ������ܽ��
	update @temp set InLibraries=A.Amount
	from(select POC_BUM_ID, SUM(POC_Amount)AS Amount from PurchaseOrderConfirmation where  CONVERT(char(10),POC_FirstAvailableDate,120)=CONVERT(char(10),@dt,120) and POC_POD_ID is not null group by POC_BUM_ID ) A
    where  ProductLineBUMId=A.POC_BUM_ID 
    
--���ڿ��� �Ӷ��������ӿڻ�ȡArticle Number�����First available date�������ڲ�ѯ�գ�����ܼ������ܽ��
	update @temp set NotInLibraries=A.Amount
	from(select POC_BUM_ID, SUM(POC_Amount)AS Amount from PurchaseOrderConfirmation where  CONVERT(char(10),POC_FirstAvailableDate,120)>CONVERT(char(10),@dt,120) and POC_POD_ID is not null group by POC_BUM_ID ) A
    where  ProductLineBUMId=A.POC_BUM_ID  
        
        RETURN
    END




GO


