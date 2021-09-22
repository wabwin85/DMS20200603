DROP view [dbo].[V_PurchaseOrderDetail_WechatQuery]
GO

CREATE view [dbo].[V_PurchaseOrderDetail_WechatQuery]
AS 
SELECT 
POH_ID as OrderId,
CFN_CustomerFaceNbr as UPN,
CFN_ChineseName as ProductCName,
CFN_EnglishName as ProductEName,
POD_UOM as UOM,
Convert(Decimal(18,2),POD_RequiredQty) as OrderQty,
Convert(Decimal(18,2),POD_ReceiptQty) as ReceiptQty,
Convert(Decimal(20,4),POD_CFN_Price) as UnitPriceVAT
FROM PurchaseOrderHeader(nolock),PurchaseOrderDetail(nolock),CFN(nolock)
WHERE POH_ID = POD_POH_ID
and POD_CFN_ID = CFN_ID
and POH_OrderStatus <> 'Draft'
and POH_SubmitDate> dateadd(month,-2,getdate())
GO


