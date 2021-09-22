DROP VIEW [dbo].[V_ConsignmentApply]
GO




CREATE VIEW [dbo].[V_ConsignmentApply]
AS
	SELECT CAH_ID AS 'Id',
	A.DMA_ChineseName AS '经销商名称',
	A.DMA_SAP_Code AS '经销商SAP编号',
	B.ATTRIBUTE_NAME AS '产品线',
	(SELECT VALUE1 FROM Lafite_DICT(nolock) WHERE DICT_TYPE = 'ConsignmentApply_Order_Type' AND DICT_KEY = CAH_OrderType ) AS '单据类型',
	CAH_OrderNo AS '申请单号',
	CONVERT(NVARCHAR(20),CAH_SubmitDate,120) AS '提交时间',
	(SELECT VALUE1 FROM Lafite_DICT(nolock) WHERE DICT_TYPE = 'ConsignmentApply_Order_Status' AND DICT_KEY = CAH_OrderStatus ) AS '单据状态',
	(SELECT VALUE1 FROM Lafite_DICT(nolock) WHERE DICT_TYPE = 'Product_source' AND DICT_KEY = CAH_ConsignmentFrom ) AS '产品来源',
	C.DMA_ChineseName AS '来源经销商名称',
	C.DMA_SAP_Code AS '来源经销商SAP编号',
	CAH_Hospital_Name AS '医院',
	CAH_CM_ConsignmentName AS '寄售规则',
	CAH_Reason AS '寄售原因',
	CAH_Remark AS '备注说明',
	CAH_SalesName AS '波科销售姓名',
	CAH_SalesEmail AS '波科销售邮箱',
	CAH_SalesPhone AS '波科销售电话',
	CAH_Consignee AS '收货人',
	CAH_ShipToAddress AS '收货地址',
	CAH_ConsigneePhone AS '收货人电话',
	CAH_CM_ConsignmentDay AS '寄售天数',
	CAH_CM_Type AS '近效期类型',
	CAH_CM_ConsignmentDay AS '可延期次数',
	CAH_CM_ReturnTime AS '退货期限',
	CONVERT(NVARCHAR(10),CAH_CM_StartDate,120) AS '时间期限-起始',
	CONVERT(NVARCHAR(10),CAH_CM_EndDate,120) AS '时间期限-截止',
	CAH_CM_DailyFines AS '滞纳金每日金额',
	CAH_CM_LowestMargin AS '最低保证金金额',
	CAH_CM_TotalAmount AS '总量控制金额'
	FROM ConsignmentApplyHeader(nolock)
	INNER JOIN DealerMaster A ON A.DMA_ID = CAH_DMA_ID
	INNER JOIN View_ProductLine B ON B.Id = CAH_ProductLine_Id
	LEFT JOIN DealerMaster C ON C.DMA_ID = CAH_ConsignmentId
	LEFT JOIN Lafite_IDENTITY D ON D.Id = CAH_CreateUser
		



GO


