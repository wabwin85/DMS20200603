
DROP VIEW [interface].[V_I_QV_OrderDetail_Tmp]
GO

CREATE VIEW [interface].[V_I_QV_OrderDetail_Tmp]
AS
SELECT Div.DivisionCode AS DivisionID
	,Div.DivisionName AS Division
	,dm.DMA_SAP_Code AS SAPID
	,DM.DMA_ChineseName AS DealerName
	,POH_OrderNo AS OrderNo
	,--订单号
	(
		SELECT CAST(VALUE1 AS NVARCHAR(50))
		FROM Lafite_DICT(NOLOCK)
		WHERE DICT_TYPE = 'CONST_Order_Type' AND DICT_KEY = POH.POH_OrderType
		) AS OrderType
	,(
		SELECT LI.IDENTITY_CODE
		FROM Lafite_IDENTITY AS LI(NOLOCK)
		WHERE LI.Id = POH.POH_SubmitUser
		) AS CreateByID
	,(
		SELECT LI.IDENTITY_NAME
		FROM Lafite_IDENTITY AS LI(NOLOCK)
		WHERE LI.Id = POH.POH_SubmitUser
		) AS CreateBy
	,POH_SubmitDate AS OrderDate
	,--订单日期
	POH_RDD AS RequestDeliveryDate
	,--期望到货日期
	(
		SELECT CAST(VALUE1 AS NVARCHAR(50))
		FROM Lafite_DICT(NOLOCK)
		WHERE DICT_TYPE = 'CONST_Order_Status' AND DICT_KEY = POH_OrderStatus
		) AS OrderStatus
	,--订单状态
	(
		SELECT min(POL_OperDate)
		FROM PurchaseOrderLog(NOLOCK)
		WHERE POL_POH_ID = POH.POH_ID AND POL_OperType = 'Confirm' AND POL_OperDate >= POH.POH_SubmitDate
		) AS ProcessDate
	,--订单处理时间(订单确认时间)
	POH_Remark AS OrderRemark
	,--订单备注
	InvoiceRemark = STUFF((
			SELECT ',' + IV.ID733
			FROM interface.T_I_IF_Invoice IV
			WHERE IV.OrderNo = POH.POH_OrderNo
			FOR XML PATH('')
			), 1, 1, '')
	,--发票备注
	CFN_CustomerFaceNbr AS UPN
	,--产品编号
	CFN.CFN_ChineseName AS UPN_Description_ZH
	,--产品中文名称
	CFN.CFN_EnglishName AS UPN_Description_EN
	,--产品英文名称
	Convert(DECIMAL(18, 6), isnull(sum(POD_RequiredQty), 0)) AS Qty
	,--订购数量
	Convert(DECIMAL(18, 6), isnull(sum(POD_Amount + POD_Tax), 0)) AS Amount
	,--订单金额小计
	Convert(DECIMAL(18, 6), isnull(sum(POD_ReceiptQty), 0)) AS DeliveryQTY
	,--已发货数量
	Convert(DECIMAL(18, 6), isnull(sum(POD_ReceiptQty * POD_CFN_Price), 0)) AS DeliveryAmount
	,--已发货金额
	CASE WHEN CHARINDEX('付款',poh_salesAccount,0 )>0 THEN null ELSE POH.POH_SalesAccount END AS SalesAccount
FROM dbo.PurchaseOrderHeader AS POH(NOLOCK)
INNER JOIN DealerMaster DM(NOLOCK)
	ON POH_DMA_ID = dm.DMA_ID
LEFT JOIN V_DivisionProductLineRelation Div(NOLOCK)
	ON Div.ProductLineID = POH.POH_ProductLine_BUM_ID
INNER JOIN PurchaseOrderDetail AS POD(NOLOCK)
	ON POH.POH_ID = POD.POD_POH_ID
LEFT JOIN CFN(NOLOCK)
	ON POD.POD_CFN_ID = CFN.CFN_ID
WHERE POH_OrderStatus <> 'Draft' AND poh.POH_CreateType <> 'Temporary'
	--AND POH_SubmitDate>= DATEADD(mm, DATEDIFF(mm, 0, getdate())-2, 0)
GROUP BY POH.POH_ID
	,DM.DMA_ChineseName
	,dm.DMA_SAP_Code
	,POH_ProductLine_BUM_ID
	,POH_OrderNo
	,--订单号
	POH_SubmitDate
	,--订单日期
	POH_RDD
	,--期望到货日期
	POH_OrderStatus
	,POH_SAP_ConfirmDate
	,--订单处理时间
	POH_Remark
	,--订单备注
	POH_InvoiceComment
	,--发票备注
	CFN_CustomerFaceNbr
	,--产品编号
	CFN.CFN_ChineseName
	,--产品中文名称
	CFN.CFN_EnglishName
	,--产品英文名称
	Div.DivisionCode
	,Div.DivisionName
	,POH_OrderType
	,DM.DMA_Parent_DMA_ID
	,POD.POD_CFN_ID
	,POH_SubmitUser
	,POH.POH_SalesAccount
GO


