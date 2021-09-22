DROP FUNCTION [dbo].[GC_Fn_Report_OrderSalesDaySumTable]
GO


--日订单销售汇总报表
CREATE FUNCTION [dbo].[GC_Fn_Report_OrderSalesDaySumTable](
	@ProductLineId uniqueidentifier,
	@dt datetime,
	@DealerId uniqueidentifier
)
RETURNS @temp TABLE 
(
	 ProductLineBUMId uniqueidentifier NULL,	--产品线ID
	 ProductLineName Nvarchar(100) NULL,		--产品线名称
	 MonthSalesAmount decimal(18,6) NULL,		--月销售金额
	 DaySalesAmount decimal(18,6) NULL,			--日销售金额
	 InLibraries decimal(18,6) NULL,			--在库金额
	 NotInLibraries decimal(18,6) NULL,			--不在库金额
	 YearSalesAmount decimal(18,6) NULL			--年销售金额	  
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
    --新建临时表
    declare @t table(
		BUMId uniqueidentifier,
		CFNId uniqueidentifier,
		Qty decimal(18,6),
		Price decimal(18,6),		
		SAPShipmentDate datetime --发货日期
		)
	--临时表插入数据 查询出指定日期当年一月一日到指定日期的数据
	--出库单主表连接出库单明细表,连接Product表,根据Product表的PMA_ID和PMA_CFN_ID使出库单表和订单表关联	  
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

--年销售金额 指定日期当年一月一号到指定日期的销售金额
  insert into @temp 
	select BUMId,ProductLineName='',MonthSalesAmount=0,DaySalesAmount=0,InLibraries=0,NotInLibraries=0,sum(Qty*Price) as YearSalesAmount 
	from @t 
	group by BUMId
	
--月销售金额 指定日期当月一号到指定日期的销售金额
	update @temp set MonthSalesAmount=A.MonthSalesAmount 
	from (select BUMId,sum(Qty*Price) as MonthSalesAmount from @t where convert(char(10),SAPShipmentDate,120) >=CONVERT(char(8),@dt,120)+'01' and convert(char(10),SAPShipmentDate,120) <=convert(char(10),@dt,120) group by BUMId) A
	where ProductLineBUMId=A.BUMId
	
--日销售金额 指定日期当天的销售金额
	update @temp set DaySalesAmount=A.DaySalesAmount 
	from (select BUMId,sum(Qty*Price) as DaySalesAmount from @t where  CONVERT(char(10),SAPShipmentDate,120)=CONVERT(char(10),@dt,120) group by BUMId ) A
	where ProductLineBUMId=A.BUMId
	
--产品线名称
    update @temp set ProductLineName=ATTRIBUTE_NAME from dbo.Lafite_ATTRIBUTE where ATTRIBUTE_TYPE='Product_Line' and id=ProductLineBUMId

--在库金额 从订单反馈接口获取Article Number级别的First available date，若与查询日是同一天，则汇总计算其总金额
	update @temp set InLibraries=A.Amount
	from(select POC_BUM_ID, SUM(POC_Amount)AS Amount from PurchaseOrderConfirmation where  CONVERT(char(10),POC_FirstAvailableDate,120)=CONVERT(char(10),@dt,120) and POC_POD_ID is not null group by POC_BUM_ID ) A
    where  ProductLineBUMId=A.POC_BUM_ID 
    
--非在库金额 从订单反馈接口获取Article Number级别的First available date，若大于查询日，则汇总计算其总金额
	update @temp set NotInLibraries=A.Amount
	from(select POC_BUM_ID, SUM(POC_Amount)AS Amount from PurchaseOrderConfirmation where  CONVERT(char(10),POC_FirstAvailableDate,120)>CONVERT(char(10),@dt,120) and POC_POD_ID is not null group by POC_BUM_ID ) A
    where  ProductLineBUMId=A.POC_BUM_ID  
        
        RETURN
    END




GO


