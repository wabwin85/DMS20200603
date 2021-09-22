DROP view [dbo].[V_PurchaseOrder]
GO





CREATE view [dbo].[V_PurchaseOrder]
as
SELECT POH_ID as Id,
d1.DMA_ChineseName as '经销商名称',
d1.DMA_SAP_Code as '经销商SAP编号',
View_ProductLine.ATTRIBUTE_NAME as '产品线',
POH_OrderNo as '申请单号',
VALUE1 as '单据类型',
POH_ContactPerson as '订单联系人',
POH_Contact as '联系方式',
POH_ContactMobile as '手机号码',
POH_Consignee as '收货人',
POH_ShipToAddress as '收货地址',
WHM_Name as '收货仓库',
POH_ConsigneePhone as '收货人电话',
POH_RDD as '期望到货日期',
POH_TerritoryCode as '承运商',
POH_Remark as '备注',
d2.DMA_ChineseName as '订单对象',
d2.DMA_SAP_Code as '订单对象SAP编号',
(SELECT Convert(NVarchar, Cast(ISNULL (SUM (PurchaseOrderDetail.POD_Amount + PurchaseOrderDetail.POD_Tax), 0)As Money),1)
   FROM PurchaseOrderDetail(NOLOCK)
  WHERE PurchaseOrderDetail.POD_POH_ID = PurchaseOrderHeader.POH_ID) AS '订单总金额',
isnull((select top 1 POL_OperNote from PurchaseOrderLog 
  where POL_POH_ID= PurchaseOrderHeader.POH_ID and pol_operType='Confirm' 
    and pol_operDate =  (select max(pol_operDate) from PurchaseOrderLog where POL_POH_ID=PurchaseOrderHeader.POH_ID and pol_operType='Confirm' )),CASE WHEN d1.DMA_DealerType IN ('T1','T2') then '经销商提交订单' else '' END) AS '订单当前状态'
FROM PurchaseOrderHeader(nolock),
View_ProductLine,
DealerMaster d1(nolock),
Lafite_DICT(nolock),
Warehouse(nolock),
DealerMaster d2(nolock)
WHERE POH_ProductLine_BUM_ID = View_ProductLine.Id
and POH_DMA_ID = d1.DMA_ID
and POH_OrderType = DICT_KEY
and DICT_TYPE = 'CONST_Order_Type'
and POH_WHM_ID = WHM_ID
and POH_VendorID = d2.DMA_ID
and POH_OrderStatus <> 'Draft'






GO


