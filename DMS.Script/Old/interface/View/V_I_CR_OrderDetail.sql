DROP VIEW [interface].[V_I_CR_OrderDetail]
GO

CREATE VIEW [interface].[V_I_CR_OrderDetail]
AS
select 
		DM.DMA_ChineseName as  ChineseName,
		dm.DMA_SAP_Code as SAPCode,
		(select ATTRIBUTE_NAME from dbo.Lafite_ATTRIBUTE where ATTRIBUTE_TYPE='Product_Line' and id=POH_ProductLine_BUM_ID) as ProductLineName,
		POH_OrderNo as OrderNo, --������
		POH_SubmitDate as SubmitDate,--��������
		POH_RDD as RDD,	  --������������
		(select VALUE1 from Lafite_DICT where DICT_TYPE = 'CONST_Order_Status' and DICT_KEY=POH_OrderStatus) as OrderStatus, --����״̬
		POH_SAP_ConfirmDate as ConfirmDate, --��������ʱ��
		POH_Remark as Remark,  --������ע
		POH_InvoiceComment as InvoiceComment, --��Ʊ��ע
		CFN_CustomerFaceNbr as UPN, --��Ʒ���
		CFN.CFN_ChineseName as CFNChineseName , --��Ʒ��������
		CFN.CFN_EnglishName as CFNEnglishName,--��ƷӢ������
    convert(int,POD_RequiredQty) as RequiredQty, --��������
		POD_Amount + POD_Tax as Amount, --�������С��
    convert(int,POD_ReceiptQty)  as ReceiptQty,--�ѷ�������
		POD_ReceiptQty * POD_CFN_Price  as ReceiptAmount --�ѷ������	
	from dbo.PurchaseOrderHeader AS POH
	inner join DealerMaster DM on POH_DMA_ID=dm.DMA_ID
	left join PurchaseOrderDetail as POD on POH.POH_ID=POD.POD_POH_ID
	left join CFN on POD.POD_CFN_ID=CFN.CFN_ID
	where POH_OrderStatus <> 'Draft'
GO


