DROP  Procedure [dbo].[GC_Interface_Confirmation]
GO

/*
订单反馈接口处理
*/
CREATE Procedure [dbo].[GC_Interface_Confirmation]
    @RtnVal NVARCHAR(20) OUTPUT
AS

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	--RAISERROR ('Job id 1 expects the default level of 10.', 16, 1)
	--订单反馈接口中每次提供的是完整的订单，因此判断反馈接口数据中是否有已存在的订单号并替换
	--是否需要关联SAP订单号，再次更新的订单它的SAP订单号是否会改变？
	--根据Flag标识判断是否需要更新
	--modified@20110708 所有接口数据都需要导入
	DELETE FROM PurchaseOrderConfirmation
	WHERE EXISTS (SELECT 1 FROM InterfaceConfirmation WHERE ICO_OrderNo = POC_OrderNo
	AND ICO_Dealer_SapCode = POC_Dealer_SapCode AND ICO_SAP_OrderNo = POC_SAP_OrderNo
	--AND ICO_Flag IS NULL
	)
	
	--将接口表中的数据插入到反馈记录表中，只需要Flag标识为需要更新的记录
	--modified@20110708 所有接口数据都需要导入
	INSERT INTO PurchaseOrderConfirmation (POC_ID,POC_OrderNo,POC_SAP_OrderNo,POC_Dealer_SapCode,
	POC_SAP_CreateDate,POC_ArticleNumber,POC_OrderNum,POC_Price,POC_Amount,POC_Tax,POC_FirstAvailableDate,
	POC_Flag,POC_LineNbr,POC_FileName,POC_ImportDate)
	SELECT NEWID(),ICO_OrderNo,ICO_SAP_OrderNo,ICO_Dealer_SapCode,ICO_SAP_CreateDate,ICO_ArticleNumber,
	ICO_OrderNum,ICO_Amount/ICO_OrderNum,ICO_Amount,ICO_Tax,ICO_FirstAvailableDate,ICO_Flag,ICO_LineNbr,ICO_FileName,ICO_ImportDate
	FROM InterfaceConfirmation 
	--WHERE ICO_Flag IS NULL
	
	--将未更新到订单的反馈数据的错误信息、产品线、产品分类和授权等做初始化
	UPDATE PurchaseOrderConfirmation
		SET POC_ProblemDescription = NULL,POC_Authorized = 0,
			POC_BUM_ID = NULL,POC_PCT_ID = NULL
	WHERE POC_POD_ID IS NULL
	
	--检查关联订单
	UPDATE PurchaseOrderConfirmation SET POC_POH_ID = POH_ID
	FROM PurchaseOrderHeader WHERE POH_OrderNo = POC_OrderNo
	AND POC_POH_ID IS NULL AND POC_POD_ID IS NULL
	
	--检查经销商
	UPDATE PurchaseOrderConfirmation SET POC_DMA_ID = DMA_ID
	FROM DealerMaster WHERE DMA_SAP_Code = POC_Dealer_SapCode
	AND POC_DMA_ID IS NULL AND POC_POD_ID IS NULL
	
	--检查产品型号
	UPDATE PurchaseOrderConfirmation SET POC_CFN_ID = CFN_ID
	FROM CFN WHERE CFN_CustomerFaceNbr = POC_ArticleNumber
	AND POC_CFN_ID IS NULL AND POC_POD_ID IS NULL
	
	--检查产品线和产品分类（不能与上一步一起写，因为可能产品线和分类发生了变更）
	UPDATE  A
		SET A.POC_BUM_ID = CFN_ProductLine_BUM_ID,
			A.POC_PCT_ID = ccf.ClassificationId
	FROM PurchaseOrderConfirmation A
	INNER JOIN CFN  ON CFN.CFN_ID = a.POC_CFN_ID
	INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
	AND CCF.ClassificationId IN (SELECT ProducPctId from GC_FN_GetDealerAuthProductSub(A.POC_DMA_ID))
	WHERE CFN_ID = POC_CFN_ID
	AND POC_CFN_ID IS NOT NULL AND POC_POD_ID IS NULL
	
	--检查产品经销商授权
	UPDATE PurchaseOrderConfirmation 
		SET POC_Authorized = DBO.GC_Fn_CFN_CheckDealerAuth(POC_DMA_ID,POC_CFN_ID)
	WHERE POC_DMA_ID IS NOT NULL AND POC_CFN_ID IS NOT NULL
	AND POC_POD_ID IS NULL
	
	--更新错误信息
	UPDATE PurchaseOrderConfirmation SET POC_ProblemDescription = N'经销商不存在'
	WHERE POC_DMA_ID IS NULL AND POC_POD_ID IS NULL
	
	UPDATE PurchaseOrderConfirmation 
		SET POC_ProblemDescription = (CASE WHEN POC_ProblemDescription IS NULL THEN N'产品型号不存在'
											ELSE POC_ProblemDescription + N',产品型号不存在' END)
	WHERE POC_CFN_ID IS NULL AND POC_POD_ID IS NULL

	UPDATE PurchaseOrderConfirmation 
		SET POC_ProblemDescription = (CASE WHEN POC_ProblemDescription IS NULL THEN N'产品线未关联'
											ELSE POC_ProblemDescription + N',产品线未关联' END)
	WHERE POC_CFN_ID IS NOT NULL AND POC_BUM_ID IS NULL AND POC_POD_ID IS NULL
	
	UPDATE PurchaseOrderConfirmation 
		SET POC_ProblemDescription = (CASE WHEN POC_ProblemDescription IS NULL THEN N'关联订单不存在'
											ELSE POC_ProblemDescription + N',关联订单不存在' END)
	WHERE POC_POH_ID IS NULL AND POC_POD_ID IS NULL

	UPDATE PurchaseOrderConfirmation SET POC_ProblemDescription = N'未做授权'
	WHERE POC_Authorized = 0 AND POC_POD_ID IS NULL
	
	--将待更新的订单明细插入到临时表
	CREATE TABLE #TMP_ORDER(
		ConfirmationId uniqueidentifier,
		HeaderId uniqueidentifier,
		DetailId uniqueidentifier,
		CfnId uniqueidentifier,
		Price decimal(18,6),
		RequiredQty decimal(18,6),
		Amount decimal(18,6),
		Tax decimal(18,6),
		ReceiptQty decimal(18,6),	
		SapOrderNo nvarchar(50),
		SapCreateDate datetime,
		Flag nvarchar(20)
	)
	--不论明细行是否存在原始订单，先生成DetailId
	INSERT INTO #TMP_ORDER (ConfirmationId,HeaderId,DetailId,CfnId,Price,RequiredQty,Amount,Tax,ReceiptQty,SapOrderNo,SapCreateDate,Flag)
	SELECT POC_ID,POC_POH_ID,NEWID(),POC_CFN_ID,POC_Price,POC_OrderNum,POC_Amount,POC_Tax,0,POC_SAP_OrderNo,POC_SAP_CreateDate,POC_Flag 
	FROM PurchaseOrderConfirmation WHERE POC_ProblemDescription IS NULL
	AND POC_POD_ID IS NULL
	
	--备份订单表头和明细到历史表
	INSERT INTO PurchaseOrderHeaderHistory (
	   POH_ID
	  ,POH_OrderNo
	  ,POH_ProductLine_BUM_ID
	  ,POH_DMA_ID
	  ,POH_VendorID
	  ,POH_TerritoryCode
	  ,POH_RDD
	  ,POH_ContactPerson
	  ,POH_Contact
	  ,POH_ContactMobile
	  ,POH_Consignee
	  ,POH_ShipToAddress
	  ,POH_ConsigneePhone
	  ,POH_Remark
	  ,POH_InvoiceComment
	  ,POH_CreateType
	  ,POH_CreateUser
	  ,POH_CreateDate
	  ,POH_UpdateUser
	  ,POH_UpdateDate
	  ,POH_SubmitUser
	  ,POH_SubmitDate
	  ,POH_LastBrowseUser
	  ,POH_LastBrowseDate
	  ,POH_OrderStatus
	  ,POH_LatestAuditDate
	  ,POH_IsLocked
	  ,POH_SAP_OrderNo
	  ,POH_SAP_ConfirmDate
	  ,POH_Version
	  ,POH_VersionDate
	)
	SELECT
	   POH_ID
	  ,POH_OrderNo
	  ,POH_ProductLine_BUM_ID
	  ,POH_DMA_ID
	  ,POH_VendorID
	  ,POH_TerritoryCode
	  ,POH_RDD
	  ,POH_ContactPerson
	  ,POH_Contact
	  ,POH_ContactMobile
	  ,POH_Consignee
	  ,POH_ShipToAddress
	  ,POH_ConsigneePhone
	  ,POH_Remark
	  ,POH_InvoiceComment
	  ,POH_CreateType
	  ,POH_CreateUser
	  ,POH_CreateDate
	  ,POH_UpdateUser
	  ,POH_UpdateDate
	  ,POH_SubmitUser
	  ,POH_SubmitDate
	  ,POH_LastBrowseUser
	  ,POH_LastBrowseDate
	  ,POH_OrderStatus
	  ,POH_LatestAuditDate
	  ,POH_IsLocked
	  ,POH_SAP_OrderNo
	  ,POH_SAP_ConfirmDate
	  ,POH_LastVersion + 1
	  ,GETDATE()
	FROM PurchaseOrderHeader WHERE POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)
	
	INSERT INTO PurchaseOrderDetailHistory (
	   POD_ID
	  ,POD_POH_ID
	  ,POD_CFN_ID
	  ,POD_CFN_Price
	  ,POD_UOM
	  ,POD_RequiredQty
	  ,POD_Amount
	  ,POD_Tax
	  ,POD_ReceiptQty
	  ,POD_Status
	  ,POD_Version
	  ,POD_VersionDate
	) 
	SELECT
	   D.POD_ID
	  ,D.POD_POH_ID
	  ,D.POD_CFN_ID
	  ,D.POD_CFN_Price
	  ,D.POD_UOM
	  ,D.POD_RequiredQty
	  ,D.POD_Amount
	  ,D.POD_Tax
	  ,D.POD_ReceiptQty
	  ,D.POD_Status
	  ,H.POH_LastVersion + 1
	  ,GETDATE()
	FROM PurchaseOrderDetail AS D 
	INNER JOIN PurchaseOrderHeader AS H ON H.POH_ID = D.POD_POH_ID
	WHERE H.POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)
	
	--更新订单表头和明细
	--更新已存在原始订单的明细行
	UPDATE PurchaseOrderDetail 
		SET POD_CFN_Price = TMP.Price,
			POD_RequiredQty = TMP.RequiredQty,
			POD_Amount = TMP.Amount,
			POD_Tax = TMP.Tax
	FROM #TMP_ORDER AS TMP
	WHERE TMP.HeaderId = PurchaseOrderDetail.POD_POH_ID
	AND TMP.CfnId = PurchaseOrderDetail.POD_CFN_ID
	AND EXISTS (SELECT 1 FROM PurchaseOrderDetail AS D
	WHERE D.POD_POH_ID = TMP.HeaderId
	AND D.POD_CFN_ID = TMP.CfnId)
	
	--插入不存在原始订单的明细行
	INSERT INTO PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,
	POD_Amount,POD_Tax,POD_ReceiptQty)
	SELECT DetailId,HeaderId,CfnId,Price,RequiredQty,Amount,Tax,ReceiptQty FROM #TMP_ORDER AS TMP
	WHERE NOT EXISTS (SELECT 1 FROM PurchaseOrderDetail AS D
	WHERE D.POD_POH_ID = TMP.HeaderId
	AND D.POD_CFN_ID = TMP.CfnId)
	
	--删除不存在于接口中的原始订单明细行
	DELETE FROM PurchaseOrderDetail
	WHERE NOT EXISTS (SELECT 1 FROM #TMP_ORDER AS TMP
	WHERE TMP.HeaderId = PurchaseOrderDetail.POD_POH_ID
	AND TMP.CfnId = PurchaseOrderDetail.POD_CFN_ID)
	AND PurchaseOrderDetail.POD_POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)
	
	--更新关联订单明细主键字段	
	UPDATE #TMP_ORDER 
		SET DetailId = D.POD_ID,
			ReceiptQty = D.POD_ReceiptQty
	FROM PurchaseOrderDetail AS D
	WHERE D.POD_CFN_ID = #TMP_ORDER.CfnId
	AND D.POD_POH_ID = #TMP_ORDER.HeaderId
	AND EXISTS (SELECT 1 FROM #TMP_ORDER AS TMP
	WHERE TMP.HeaderId = D.POD_POH_ID AND TMP.CfnId = D.POD_CFN_ID)
	
	--那些不是取消订单的需要删除Flag不为空的数据,要在上一步之后做，原因是要保证#TMP_ORDER.DetailId都有值
	DELETE FROM PurchaseOrderDetail
	WHERE EXISTS (SELECT 1 FROM #TMP_ORDER AS TMP
	WHERE TMP.HeaderId = PurchaseOrderDetail.POD_POH_ID
	AND TMP.CfnId = PurchaseOrderDetail.POD_CFN_ID
	AND TMP.Flag IS NOT NULL)
	AND PurchaseOrderDetail.POD_POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER WHERE Flag IS NULL)

	--更新订单表头相关信息
	--更新原始状态为已生成接口的订单状态为已进入SAP
	UPDATE PurchaseOrderHeader SET POH_OrderStatus = 'Confirmed'
	WHERE POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)
	AND POH_OrderStatus = 'Uploaded'
	
	--更新SAP订单信息,不包含取消的订单
	UPDATE PurchaseOrderHeader
		SET POH_SAP_OrderNo = TMP.SapOrderNo,
			POH_SAP_ConfirmDate = TMP.SapCreateDate,
			POH_OrderStatus = (CASE WHEN POH_OrderStatus = 'Confirmed' AND TMP.RequiredQty <= TMP.ReceiptQty THEN 'Completed'
									WHEN POH_OrderStatus = 'Confirmed' AND TMP.RequiredQty > TMP.ReceiptQty AND TMP.ReceiptQty > 0 THEN 'Delivering'
									WHEN POH_OrderStatus = 'Completed' AND TMP.RequiredQty > TMP.ReceiptQty AND TMP.ReceiptQty > 0 THEN 'Delivering'
									WHEN POH_OrderStatus = 'Completed' AND TMP.RequiredQty > TMP.ReceiptQty AND TMP.ReceiptQty = 0 THEN 'Confirmed'
									WHEN POH_OrderStatus = 'Delivering' AND TMP.RequiredQty <= TMP.ReceiptQty THEN 'Completed'
									WHEN POH_OrderStatus = 'Delivering' AND TMP.RequiredQty > TMP.ReceiptQty AND TMP.ReceiptQty = 0 THEN 'Confirmed'
									ELSE POH_OrderStatus END),
			POH_LastVersion = POH_LastVersion + 1
	FROM (SELECT HeaderId,MAX(SapOrderNo) AS SapOrderNo,MAX(SapCreateDate) AS SapCreateDate,
	SUM(RequiredQty) AS RequiredQty,SUM(ReceiptQty) AS ReceiptQty
	FROM #TMP_ORDER WHERE Flag IS NULL GROUP BY HeaderId) AS TMP
	WHERE TMP.HeaderId = PurchaseOrderHeader.POH_ID
	AND EXISTS (SELECT 1 FROM PurchaseOrderHeader AS H WHERE H.POH_ID = TMP.HeaderId)
	
	--更新已取消的订单，若所有明细的标志都为删除，则该订单取消
	--Updated by Yangshaowei,如果该订单为取消，则将其状态置为“Rejected 已拒绝”，而非“已完成”
	UPDATE PurchaseOrderHeader
		SET POH_SAP_OrderNo = TMP.SapOrderNo,
			POH_SAP_ConfirmDate = TMP.SapCreateDate,
			--POH_OrderStatus = 'Completed',
			POH_OrderStatus = 'Rejected',
			POH_LastVersion = POH_LastVersion + 1
	FROM (SELECT HeaderId,MAX(SapOrderNo) AS SapOrderNo,MAX(SapCreateDate) AS SapCreateDate,
	SUM(RequiredQty) AS RequiredQty,SUM(ReceiptQty) AS ReceiptQty
	FROM #TMP_ORDER WHERE HeaderId NOT IN 
	(SELECT DISTINCT HeaderId FROM #TMP_ORDER WHERE Flag IS NULL)
	GROUP BY HeaderId) AS TMP
	WHERE TMP.HeaderId = PurchaseOrderHeader.POH_ID
	AND EXISTS (SELECT 1 FROM PurchaseOrderHeader AS H WHERE H.POH_ID = TMP.HeaderId)
	
	--更新订单反馈接口关联订单明细行主键
	UPDATE PurchaseOrderConfirmation
		SET POC_POD_ID = TMP.DetailId
	FROM #TMP_ORDER AS TMP
	WHERE TMP.ConfirmationId = PurchaseOrderConfirmation.POC_ID
	AND EXISTS (SELECT 1 FROM PurchaseOrderConfirmation AS C
	WHERE C.POC_ID = TMP.ConfirmationId)
	
	--处理有反馈信息的订单短信及邮件到处理表
	INSERT INTO MailMessageProcess (MMP_ID,MMP_Code,MMP_ProcessId,MMP_Status,MMP_CreateDate)
	SELECT NEWID(),'EMAIL_ORDER_CONFIRMED',T.HeaderId,'Waiting',GETDATE()
	FROM (SELECT DISTINCT HeaderId FROM #TMP_ORDER) AS T

	INSERT INTO ShortMessageProcess (SMP_ID,SMP_Code,SMP_ProcessId,SMP_Status,SMP_CreateDate)
	SELECT NEWID(),'SMS_ORDER_CONFIRMED',T.HeaderId,'Waiting',GETDATE()
	FROM (SELECT DISTINCT HeaderId FROM #TMP_ORDER) AS T
	
	--处理有反馈信息的订单日志,不包含取消的订单
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),T.HeaderId,'b3c064c1-902e-44c1-8a5a-b0bc569cd80f',GETDATE(),'Confirm',NULL
	FROM (SELECT DISTINCT HeaderId FROM #TMP_ORDER WHERE Flag IS NULL) AS T

	--处理取消的订单的日志
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),T.HeaderId,'b3c064c1-902e-44c1-8a5a-b0bc569cd80f',GETDATE(),'Confirm','订单取消'
	FROM (SELECT DISTINCT HeaderId FROM #TMP_ORDER WHERE HeaderId NOT IN 
	(SELECT DISTINCT HeaderId FROM #TMP_ORDER WHERE Flag IS NULL)) AS T

	/*
	--处理因反馈信息而改变订单状态为已完成的订单短信及邮件到处理表
	INSERT INTO ShortMessageProcess (SMP_ID,SMP_Code,SMP_ProcessId,SMP_Status)
	SELECT NEWID(),'EMAIL_ORDER_COMPLETED',T.HeaderId,'Waiting'
	FROM (SELECT POH_ID AS HeaderId FROM PurchaseOrderHeader 
	WHERE POH_OrderStatus = 'Completed'
	AND POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)) AS T
	*/
COMMIT TRAN

	--记录成功日志
	exec dbo.GC_Interface_Log 'Confirmation','Success',''

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
	
	--记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	exec dbo.GC_Interface_Log 'Confirmation','Failure',@vError

    return -1
    
END CATCH
GO


