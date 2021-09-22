DROP view [dbo].[V_PurchaseOrderTable]
GO






CREATE view [dbo].[V_PurchaseOrderTable]
as 
SELECT 
POH_ID as Id,
CFN_CustomerFaceNbr as '产品型号',
CFN_ChineseName as '产品中文名',
CFN_EnglishName as '产品英文名',
POD_UOM as '单位',
Convert(Decimal(18,2),POD_RequiredQty) as '订单数量',
Convert(Decimal(18,2),POD_ReceiptQty) as '发货数量',
Convert(Decimal(20,4),POD_CFN_Price) as '产品单价'
FROM PurchaseOrderHeader(nolock),PurchaseOrderDetail(nolock),CFN(nolock)
WHERE POH_ID = POD_POH_ID
and POD_CFN_ID = CFN_ID
and POH_OrderStatus <> 'Draft'





GO


