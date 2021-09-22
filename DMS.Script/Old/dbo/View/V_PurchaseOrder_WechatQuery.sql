
DROP view [dbo].[V_PurchaseOrder_WechatQuery]
GO

CREATE view [dbo].[V_PurchaseOrder_WechatQuery]
as
SELECT POH_ID as OrderId,
d1.DMA_ID AS DealerID,
d1.DMA_ChineseName as DealerName,
d1.DMA_SAP_Code as DealerCode,
View_ProductLine.ATTRIBUTE_NAME as ProductLine,
POH_OrderNo as OrderNo,
Convert(nvarchar(20),POH_SubmitDate,120) AS SubmitDate,
VALUE1 as OrderType,
(SELECT VALUE1
   FROM Lafite_DICT DIC(NOLOCK)
  WHERE DIC.DICT_TYPE = 'CONST_Order_Status' and DIC.DICT_KEY = POH_OrderStatus) AS OrderStatus,
(SELECT Convert(NVarchar, Cast(ISNULL (SUM (PurchaseOrderDetail.POD_Amount + PurchaseOrderDetail.POD_Tax), 0)As Money),1)
   FROM PurchaseOrderDetail(NOLOCK)
  WHERE PurchaseOrderDetail.POD_POH_ID = PurchaseOrderHeader.POH_ID) AS OrderAmountVAT,
(SELECT Convert(NVarchar, CAST(ISNULL (SUM (PurchaseOrderDetail.POD_RequiredQty ), 0)As INT),1)
   FROM PurchaseOrderDetail(NOLOCK)
  WHERE PurchaseOrderDetail.POD_POH_ID = PurchaseOrderHeader.POH_ID) AS OrderQty

FROM PurchaseOrderHeader(nolock),
View_ProductLine,
DealerMaster d1(nolock),
Lafite_DICT(nolock),
Warehouse(nolock)
WHERE POH_ProductLine_BUM_ID = View_ProductLine.Id
and POH_DMA_ID = d1.DMA_ID
and POH_OrderType = DICT_KEY
and DICT_TYPE = 'CONST_Order_Type'
and POH_WHM_ID = WHM_ID
and POH_CreateType<>'Temporary'
and POH_OrderStatus <> 'Draft'
and POH_SubmitDate> dateadd(month,-2,getdate())
GO


