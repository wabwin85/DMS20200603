DROP VIEW [interface].[V_I_QV_OrderDetail]
GO


CREATE VIEW [interface].[V_I_QV_OrderDetail]
AS
SELECT DM.DMA_ChineseName AS ChineseName
	,dm.DMA_SAP_Code AS SAPCode
	,(
		SELECT ATTRIBUTE_NAME
		FROM dbo.Lafite_ATTRIBUTE(NOLOCK)
		WHERE ATTRIBUTE_TYPE = 'Product_Line' AND id = POH_ProductLine_BUM_ID
		) AS ProductLineName
	,POH_OrderNo AS OrderNo
	,--������
	POH_SubmitDate AS SubmitDate
	,--��������
	POH_RDD AS RDD
	,--������������
	POH_OrderStatus
	,(
		SELECT VALUE1
		FROM Lafite_DICT(NOLOCK)
		WHERE DICT_TYPE = 'CONST_Order_Status' AND DICT_KEY = POH_OrderStatus
		) AS OrderStatus
	,--����״̬
	(
		SELECT min(POL_OperDate)
		FROM PurchaseOrderLog(NOLOCK)
		WHERE POL_POH_ID = POH.POH_ID AND POL_OperType = 'Confirm' AND POL_OperDate >= POH.POH_SubmitDate
		) AS ConfirmDate
	,--��������ʱ��
	POH_Remark AS Remark
	,--������ע
	InvoiceComment = STUFF((
			SELECT ',' + IV.ID733
			FROM interface.T_I_IF_Invoice IV
			WHERE IV.OrderNo = POH.POH_OrderNo
			FOR XML PATH('')
			), 1, 1, '')
	,--��Ʊ��ע
	CFN_CustomerFaceNbr AS UPN
	,--��Ʒ���
	CFN.CFN_ChineseName AS CFNChineseName
	,--��Ʒ��������
	CFN.CFN_EnglishName AS CFNEnglishName
	,--��ƷӢ������
	Convert(DECIMAL(18, 6), isnull(sum(POD_RequiredQty), 0)) AS RequiredQty
	,--��������
	Convert(DECIMAL(18, 6), isnull(sum(POD_Amount + POD_Tax), 0)) AS Amount
	,--�������С��
	Convert(DECIMAL(18, 6), isnull(sum(POD_ReceiptQty), 0)) AS ReceiptQty
	,--�ѷ�������
	Convert(DECIMAL(18, 6), isnull(sum(POD_ReceiptQty * POD_CFN_Price), 0)) AS ReceiptAmount --�ѷ������	
	,Division = Division
	,DivisionId = c.DivisionID
	,POH_OrderType
	,POH_OrderTypeName = (
		SELECT VALUE1
		FROM Lafite_DICT(NOLOCK)
		WHERE DICT_TYPE = 'CONST_Order_Type' AND DICT_KEY = POH_OrderType
		)
	,ParentSAPID = (
		SELECT DMA_SAP_Code
		FROM DealerMaster(NOLOCK) b
		WHERE b.DMA_ID = DM.DMA_Parent_DMA_ID
		)
	--,DMA_Parent_DMA_ID
	,ParentName = (
		SELECT DMA_ChineseName
		FROM DealerMaster b(NOLOCK)
		WHERE b.DMA_ID = DM.DMA_Parent_DMA_ID
		)
	,ShipmentDate = (
		SELECT max(PRH_SAPShipmentDate)
		FROM POReceiptHeader(NOLOCK)
		WHERE PRH_PurchaseOrderNbr = POH_OrderNo
		)
	,(
		SELECT Convert(DECIMAL(18, 6), isnull(sum(isnull(T2.POR_ReceiptQty, 0)), 0))
		FROM POReceiptHeader AS T1(NOLOCK)
			,POReceipt T2(NOLOCK)
			,(
				SELECT MIN(convert(NVARCHAR(10), PRH_SapDeliveryDate, 112)) AS PRH_SapDeliveryDate
					,PRH.PRH_PurchaseOrderNbr
				FROM POReceiptHeader PRH(NOLOCK)
				WHERE PRH.PRH_PurchaseOrderNbr = POH.POH_OrderNo AND PRH.PRH_Status IN ('Complete', 'Waiting')
				GROUP BY PRH.PRH_PurchaseOrderNbr
				) T3
			,Product AS T4
		WHERE T1.PRH_ID = T2.POR_PRH_ID AND convert(NVARCHAR(10), t1.PRH_SapDeliveryDate, 112) = t3.PRH_SapDeliveryDate AND t1.PRH_PurchaseOrderNbr = t3.PRH_PurchaseOrderNbr AND T4.PMA_ID = T2.POR_SAP_PMA_ID AND POD.POD_CFN_ID = T4.PMA_CFN_ID AND T1.PRH_Status IN ('Complete', 'Waiting')
		) AS FirstReceiptQty
	,Convert(DECIMAL(18, 6), 0.00) AS FirstReceiptAmount
FROM dbo.PurchaseOrderHeader AS POH(NOLOCK)
INNER JOIN DealerMaster DM(NOLOCK) ON POH_DMA_ID = dm.DMA_ID
LEFT JOIN PurchaseOrderDetail AS POD(NOLOCK) ON POH.POH_ID = POD.POD_POH_ID
LEFT JOIN CFN(NOLOCK) ON POD.POD_CFN_ID = CFN.CFN_ID
LEFT JOIN interface.T_I_CR_Product(NOLOCK) b ON b.UPN = CFN_CustomerFaceNbr
LEFT JOIN interface.T_I_CR_Division(NOLOCK) c ON c.DivisionID = b.DivisionID
WHERE POH_OrderStatus <> 'Draft' AND POH_CreateType <> 'Temporary'
and ISNULL(DM.DMA_Taxpayer,'')<>'ֱ��ҽԺ'
GROUP BY POH.POH_ID
	,DM.DMA_ChineseName
	,dm.DMA_SAP_Code
	,POH_ProductLine_BUM_ID
	,POH_OrderNo
	,--������
	POH_SubmitDate
	,--��������
	POH_RDD
	,--������������
	POH_OrderStatus
	,POH_SAP_ConfirmDate
	,--��������ʱ��
	POH_Remark
	,--������ע
	POH_InvoiceComment
	,--��Ʊ��ע
	CFN_CustomerFaceNbr
	,--��Ʒ���
	CFN.CFN_ChineseName
	,--��Ʒ��������
	CFN.CFN_EnglishName
	,--��ƷӢ������
	Division
	,c.DivisionID
	,POH_OrderType
	,DM.DMA_Parent_DMA_ID
	,POD.POD_CFN_ID

GO


