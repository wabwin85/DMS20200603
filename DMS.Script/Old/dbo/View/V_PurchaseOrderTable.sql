DROP view [dbo].[V_PurchaseOrderTable]
GO






CREATE view [dbo].[V_PurchaseOrderTable]
as 
SELECT 
POH_ID as Id,
CFN_CustomerFaceNbr as '��Ʒ�ͺ�',
CFN_ChineseName as '��Ʒ������',
CFN_EnglishName as '��ƷӢ����',
POD_UOM as '��λ',
Convert(Decimal(18,2),POD_RequiredQty) as '��������',
Convert(Decimal(18,2),POD_ReceiptQty) as '��������',
Convert(Decimal(20,4),POD_CFN_Price) as '��Ʒ����'
FROM PurchaseOrderHeader(nolock),PurchaseOrderDetail(nolock),CFN(nolock)
WHERE POH_ID = POD_POH_ID
and POD_CFN_ID = CFN_ID
and POH_OrderStatus <> 'Draft'





GO


