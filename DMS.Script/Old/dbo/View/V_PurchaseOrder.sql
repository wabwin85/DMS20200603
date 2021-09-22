DROP view [dbo].[V_PurchaseOrder]
GO





CREATE view [dbo].[V_PurchaseOrder]
as
SELECT POH_ID as Id,
d1.DMA_ChineseName as '����������',
d1.DMA_SAP_Code as '������SAP���',
View_ProductLine.ATTRIBUTE_NAME as '��Ʒ��',
POH_OrderNo as '���뵥��',
VALUE1 as '��������',
POH_ContactPerson as '������ϵ��',
POH_Contact as '��ϵ��ʽ',
POH_ContactMobile as '�ֻ�����',
POH_Consignee as '�ջ���',
POH_ShipToAddress as '�ջ���ַ',
WHM_Name as '�ջ��ֿ�',
POH_ConsigneePhone as '�ջ��˵绰',
POH_RDD as '������������',
POH_TerritoryCode as '������',
POH_Remark as '��ע',
d2.DMA_ChineseName as '��������',
d2.DMA_SAP_Code as '��������SAP���',
(SELECT Convert(NVarchar, Cast(ISNULL (SUM (PurchaseOrderDetail.POD_Amount + PurchaseOrderDetail.POD_Tax), 0)As Money),1)
   FROM PurchaseOrderDetail(NOLOCK)
  WHERE PurchaseOrderDetail.POD_POH_ID = PurchaseOrderHeader.POH_ID) AS '�����ܽ��',
isnull((select top 1 POL_OperNote from PurchaseOrderLog 
  where POL_POH_ID= PurchaseOrderHeader.POH_ID and pol_operType='Confirm' 
    and pol_operDate =  (select max(pol_operDate) from PurchaseOrderLog where POL_POH_ID=PurchaseOrderHeader.POH_ID and pol_operType='Confirm' )),CASE WHEN d1.DMA_DealerType IN ('T1','T2') then '�������ύ����' else '' END) AS '������ǰ״̬'
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


