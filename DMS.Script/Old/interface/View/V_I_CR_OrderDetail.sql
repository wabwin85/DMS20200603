DROP VIEW [interface].[V_I_CR_OrderDetail]
GO

CREATE VIEW [interface].[V_I_CR_OrderDetail]
AS
select 
		DM.DMA_ChineseName as  ChineseName,
		dm.DMA_SAP_Code as SAPCode,
		(select ATTRIBUTE_NAME from dbo.Lafite_ATTRIBUTE where ATTRIBUTE_TYPE='Product_Line' and id=POH_ProductLine_BUM_ID) as ProductLineName,
		POH_OrderNo as OrderNo, --订单号
		POH_SubmitDate as SubmitDate,--订单日期
		POH_RDD as RDD,	  --期望到货日期
		(select VALUE1 from Lafite_DICT where DICT_TYPE = 'CONST_Order_Status' and DICT_KEY=POH_OrderStatus) as OrderStatus, --订单状态
		POH_SAP_ConfirmDate as ConfirmDate, --订单处理时间
		POH_Remark as Remark,  --订单备注
		POH_InvoiceComment as InvoiceComment, --发票备注
		CFN_CustomerFaceNbr as UPN, --产品编号
		CFN.CFN_ChineseName as CFNChineseName , --产品中文名称
		CFN.CFN_EnglishName as CFNEnglishName,--产品英文名称
    convert(int,POD_RequiredQty) as RequiredQty, --订购数量
		POD_Amount + POD_Tax as Amount, --订单金额小计
    convert(int,POD_ReceiptQty)  as ReceiptQty,--已发货数量
		POD_ReceiptQty * POD_CFN_Price  as ReceiptAmount --已发货金额	
	from dbo.PurchaseOrderHeader AS POH
	inner join DealerMaster DM on POH_DMA_ID=dm.DMA_ID
	left join PurchaseOrderDetail as POD on POH.POH_ID=POD.POD_POH_ID
	left join CFN on POD.POD_CFN_ID=CFN.CFN_ID
	where POH_OrderStatus <> 'Draft'
GO


