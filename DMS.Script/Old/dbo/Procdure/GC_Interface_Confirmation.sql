DROP  Procedure [dbo].[GC_Interface_Confirmation]
GO

/*
���������ӿڴ���
*/
CREATE Procedure [dbo].[GC_Interface_Confirmation]
    @RtnVal NVARCHAR(20) OUTPUT
AS

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	--RAISERROR ('Job id 1 expects the default level of 10.', 16, 1)
	--���������ӿ���ÿ���ṩ���������Ķ���������жϷ����ӿ��������Ƿ����Ѵ��ڵĶ����Ų��滻
	--�Ƿ���Ҫ����SAP�����ţ��ٴθ��µĶ�������SAP�������Ƿ��ı䣿
	--����Flag��ʶ�ж��Ƿ���Ҫ����
	--modified@20110708 ���нӿ����ݶ���Ҫ����
	DELETE FROM PurchaseOrderConfirmation
	WHERE EXISTS (SELECT 1 FROM InterfaceConfirmation WHERE ICO_OrderNo = POC_OrderNo
	AND ICO_Dealer_SapCode = POC_Dealer_SapCode AND ICO_SAP_OrderNo = POC_SAP_OrderNo
	--AND ICO_Flag IS NULL
	)
	
	--���ӿڱ��е����ݲ��뵽������¼���У�ֻ��ҪFlag��ʶΪ��Ҫ���µļ�¼
	--modified@20110708 ���нӿ����ݶ���Ҫ����
	INSERT INTO PurchaseOrderConfirmation (POC_ID,POC_OrderNo,POC_SAP_OrderNo,POC_Dealer_SapCode,
	POC_SAP_CreateDate,POC_ArticleNumber,POC_OrderNum,POC_Price,POC_Amount,POC_Tax,POC_FirstAvailableDate,
	POC_Flag,POC_LineNbr,POC_FileName,POC_ImportDate)
	SELECT NEWID(),ICO_OrderNo,ICO_SAP_OrderNo,ICO_Dealer_SapCode,ICO_SAP_CreateDate,ICO_ArticleNumber,
	ICO_OrderNum,ICO_Amount/ICO_OrderNum,ICO_Amount,ICO_Tax,ICO_FirstAvailableDate,ICO_Flag,ICO_LineNbr,ICO_FileName,ICO_ImportDate
	FROM InterfaceConfirmation 
	--WHERE ICO_Flag IS NULL
	
	--��δ���µ������ķ������ݵĴ�����Ϣ����Ʒ�ߡ���Ʒ�������Ȩ������ʼ��
	UPDATE PurchaseOrderConfirmation
		SET POC_ProblemDescription = NULL,POC_Authorized = 0,
			POC_BUM_ID = NULL,POC_PCT_ID = NULL
	WHERE POC_POD_ID IS NULL
	
	--����������
	UPDATE PurchaseOrderConfirmation SET POC_POH_ID = POH_ID
	FROM PurchaseOrderHeader WHERE POH_OrderNo = POC_OrderNo
	AND POC_POH_ID IS NULL AND POC_POD_ID IS NULL
	
	--��龭����
	UPDATE PurchaseOrderConfirmation SET POC_DMA_ID = DMA_ID
	FROM DealerMaster WHERE DMA_SAP_Code = POC_Dealer_SapCode
	AND POC_DMA_ID IS NULL AND POC_POD_ID IS NULL
	
	--����Ʒ�ͺ�
	UPDATE PurchaseOrderConfirmation SET POC_CFN_ID = CFN_ID
	FROM CFN WHERE CFN_CustomerFaceNbr = POC_ArticleNumber
	AND POC_CFN_ID IS NULL AND POC_POD_ID IS NULL
	
	--����Ʒ�ߺͲ�Ʒ���ࣨ��������һ��һ��д����Ϊ���ܲ�Ʒ�ߺͷ��෢���˱����
	UPDATE  A
		SET A.POC_BUM_ID = CFN_ProductLine_BUM_ID,
			A.POC_PCT_ID = ccf.ClassificationId
	FROM PurchaseOrderConfirmation A
	INNER JOIN CFN  ON CFN.CFN_ID = a.POC_CFN_ID
	INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
	AND CCF.ClassificationId IN (SELECT ProducPctId from GC_FN_GetDealerAuthProductSub(A.POC_DMA_ID))
	WHERE CFN_ID = POC_CFN_ID
	AND POC_CFN_ID IS NOT NULL AND POC_POD_ID IS NULL
	
	--����Ʒ��������Ȩ
	UPDATE PurchaseOrderConfirmation 
		SET POC_Authorized = DBO.GC_Fn_CFN_CheckDealerAuth(POC_DMA_ID,POC_CFN_ID)
	WHERE POC_DMA_ID IS NOT NULL AND POC_CFN_ID IS NOT NULL
	AND POC_POD_ID IS NULL
	
	--���´�����Ϣ
	UPDATE PurchaseOrderConfirmation SET POC_ProblemDescription = N'�����̲�����'
	WHERE POC_DMA_ID IS NULL AND POC_POD_ID IS NULL
	
	UPDATE PurchaseOrderConfirmation 
		SET POC_ProblemDescription = (CASE WHEN POC_ProblemDescription IS NULL THEN N'��Ʒ�ͺŲ�����'
											ELSE POC_ProblemDescription + N',��Ʒ�ͺŲ�����' END)
	WHERE POC_CFN_ID IS NULL AND POC_POD_ID IS NULL

	UPDATE PurchaseOrderConfirmation 
		SET POC_ProblemDescription = (CASE WHEN POC_ProblemDescription IS NULL THEN N'��Ʒ��δ����'
											ELSE POC_ProblemDescription + N',��Ʒ��δ����' END)
	WHERE POC_CFN_ID IS NOT NULL AND POC_BUM_ID IS NULL AND POC_POD_ID IS NULL
	
	UPDATE PurchaseOrderConfirmation 
		SET POC_ProblemDescription = (CASE WHEN POC_ProblemDescription IS NULL THEN N'��������������'
											ELSE POC_ProblemDescription + N',��������������' END)
	WHERE POC_POH_ID IS NULL AND POC_POD_ID IS NULL

	UPDATE PurchaseOrderConfirmation SET POC_ProblemDescription = N'δ����Ȩ'
	WHERE POC_Authorized = 0 AND POC_POD_ID IS NULL
	
	--�������µĶ�����ϸ���뵽��ʱ��
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
	--������ϸ���Ƿ����ԭʼ������������DetailId
	INSERT INTO #TMP_ORDER (ConfirmationId,HeaderId,DetailId,CfnId,Price,RequiredQty,Amount,Tax,ReceiptQty,SapOrderNo,SapCreateDate,Flag)
	SELECT POC_ID,POC_POH_ID,NEWID(),POC_CFN_ID,POC_Price,POC_OrderNum,POC_Amount,POC_Tax,0,POC_SAP_OrderNo,POC_SAP_CreateDate,POC_Flag 
	FROM PurchaseOrderConfirmation WHERE POC_ProblemDescription IS NULL
	AND POC_POD_ID IS NULL
	
	--���ݶ�����ͷ����ϸ����ʷ��
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
	
	--���¶�����ͷ����ϸ
	--�����Ѵ���ԭʼ��������ϸ��
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
	
	--���벻����ԭʼ��������ϸ��
	INSERT INTO PurchaseOrderDetail (POD_ID,POD_POH_ID,POD_CFN_ID,POD_CFN_Price,POD_RequiredQty,
	POD_Amount,POD_Tax,POD_ReceiptQty)
	SELECT DetailId,HeaderId,CfnId,Price,RequiredQty,Amount,Tax,ReceiptQty FROM #TMP_ORDER AS TMP
	WHERE NOT EXISTS (SELECT 1 FROM PurchaseOrderDetail AS D
	WHERE D.POD_POH_ID = TMP.HeaderId
	AND D.POD_CFN_ID = TMP.CfnId)
	
	--ɾ���������ڽӿ��е�ԭʼ������ϸ��
	DELETE FROM PurchaseOrderDetail
	WHERE NOT EXISTS (SELECT 1 FROM #TMP_ORDER AS TMP
	WHERE TMP.HeaderId = PurchaseOrderDetail.POD_POH_ID
	AND TMP.CfnId = PurchaseOrderDetail.POD_CFN_ID)
	AND PurchaseOrderDetail.POD_POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)
	
	--���¹���������ϸ�����ֶ�	
	UPDATE #TMP_ORDER 
		SET DetailId = D.POD_ID,
			ReceiptQty = D.POD_ReceiptQty
	FROM PurchaseOrderDetail AS D
	WHERE D.POD_CFN_ID = #TMP_ORDER.CfnId
	AND D.POD_POH_ID = #TMP_ORDER.HeaderId
	AND EXISTS (SELECT 1 FROM #TMP_ORDER AS TMP
	WHERE TMP.HeaderId = D.POD_POH_ID AND TMP.CfnId = D.POD_CFN_ID)
	
	--��Щ����ȡ����������Ҫɾ��Flag��Ϊ�յ�����,Ҫ����һ��֮������ԭ����Ҫ��֤#TMP_ORDER.DetailId����ֵ
	DELETE FROM PurchaseOrderDetail
	WHERE EXISTS (SELECT 1 FROM #TMP_ORDER AS TMP
	WHERE TMP.HeaderId = PurchaseOrderDetail.POD_POH_ID
	AND TMP.CfnId = PurchaseOrderDetail.POD_CFN_ID
	AND TMP.Flag IS NOT NULL)
	AND PurchaseOrderDetail.POD_POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER WHERE Flag IS NULL)

	--���¶�����ͷ�����Ϣ
	--����ԭʼ״̬Ϊ�����ɽӿڵĶ���״̬Ϊ�ѽ���SAP
	UPDATE PurchaseOrderHeader SET POH_OrderStatus = 'Confirmed'
	WHERE POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)
	AND POH_OrderStatus = 'Uploaded'
	
	--����SAP������Ϣ,������ȡ���Ķ���
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
	
	--������ȡ���Ķ�������������ϸ�ı�־��Ϊɾ������ö���ȡ��
	--Updated by Yangshaowei,����ö���Ϊȡ��������״̬��Ϊ��Rejected �Ѿܾ��������ǡ�����ɡ�
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
	
	--���¶��������ӿڹ���������ϸ������
	UPDATE PurchaseOrderConfirmation
		SET POC_POD_ID = TMP.DetailId
	FROM #TMP_ORDER AS TMP
	WHERE TMP.ConfirmationId = PurchaseOrderConfirmation.POC_ID
	AND EXISTS (SELECT 1 FROM PurchaseOrderConfirmation AS C
	WHERE C.POC_ID = TMP.ConfirmationId)
	
	--�����з�����Ϣ�Ķ������ż��ʼ��������
	INSERT INTO MailMessageProcess (MMP_ID,MMP_Code,MMP_ProcessId,MMP_Status,MMP_CreateDate)
	SELECT NEWID(),'EMAIL_ORDER_CONFIRMED',T.HeaderId,'Waiting',GETDATE()
	FROM (SELECT DISTINCT HeaderId FROM #TMP_ORDER) AS T

	INSERT INTO ShortMessageProcess (SMP_ID,SMP_Code,SMP_ProcessId,SMP_Status,SMP_CreateDate)
	SELECT NEWID(),'SMS_ORDER_CONFIRMED',T.HeaderId,'Waiting',GETDATE()
	FROM (SELECT DISTINCT HeaderId FROM #TMP_ORDER) AS T
	
	--�����з�����Ϣ�Ķ�����־,������ȡ���Ķ���
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),T.HeaderId,'b3c064c1-902e-44c1-8a5a-b0bc569cd80f',GETDATE(),'Confirm',NULL
	FROM (SELECT DISTINCT HeaderId FROM #TMP_ORDER WHERE Flag IS NULL) AS T

	--����ȡ���Ķ�������־
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	SELECT NEWID(),T.HeaderId,'b3c064c1-902e-44c1-8a5a-b0bc569cd80f',GETDATE(),'Confirm','����ȡ��'
	FROM (SELECT DISTINCT HeaderId FROM #TMP_ORDER WHERE HeaderId NOT IN 
	(SELECT DISTINCT HeaderId FROM #TMP_ORDER WHERE Flag IS NULL)) AS T

	/*
	--����������Ϣ���ı䶩��״̬Ϊ����ɵĶ������ż��ʼ��������
	INSERT INTO ShortMessageProcess (SMP_ID,SMP_Code,SMP_ProcessId,SMP_Status)
	SELECT NEWID(),'EMAIL_ORDER_COMPLETED',T.HeaderId,'Waiting'
	FROM (SELECT POH_ID AS HeaderId FROM PurchaseOrderHeader 
	WHERE POH_OrderStatus = 'Completed'
	AND POH_ID IN (SELECT DISTINCT HeaderId FROM #TMP_ORDER)) AS T
	*/
COMMIT TRAN

	--��¼�ɹ���־
	exec dbo.GC_Interface_Log 'Confirmation','Success',''

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
	
	--��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	exec dbo.GC_Interface_Log 'Confirmation','Failure',@vError

    return -1
    
END CATCH
GO


