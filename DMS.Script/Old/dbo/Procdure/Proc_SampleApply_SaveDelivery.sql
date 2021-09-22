DROP PROCEDURE [dbo].[Proc_SampleApply_SaveDelivery]
GO

CREATE PROCEDURE [dbo].[Proc_SampleApply_SaveDelivery]
AS
BEGIN
  BEGIN TRY
    BEGIN TRAN
	
	--获取测试样品SAP发货数据	
	SELECT A.PRH_ID,B.SampleApplyHeadId,B.ApplyNo
	INTO #TMP_SAMPLE
	FROM POReceiptHeader_SAPNoQR A, SampleApplyHead B
	WHERE A.PRH_PurchaseOrderNbr = B.ApplyNo
	AND A.PRH_Status = 'Waiting'
	AND A.PRH_InterfaceStatus = 'UploadSuccess'
	AND B.SampleType = '测试样品'

	SELECT B.PRH_ID,
	(SELECT A.PRH_SAPShipmentID AS DeliveryNo,CONVERT(NVARCHAR(19),A.PRH_SAPShipmentDate,121) AS DeliveryDate,A.PRH_PurchaseOrderNbr AS ApplyNo 
	FROM POReceiptHeader_SAPNoQR A 
	WHERE A.PRH_ID = B.PRH_ID 
	AND EXISTS (SELECT 1 FROM #TMP_SAMPLE S WHERE S.PRH_ID = A.PRH_ID)
	FOR XML PATH ('')) AS HEADER
	INTO #TMP_HEADER
	FROM POReceiptHeader_SAPNoQR B
	WHERE EXISTS (SELECT 1 FROM #TMP_SAMPLE S WHERE S.PRH_ID = B.PRH_ID)

	SELECT D.PRH_ID,
	(SELECT P.PMA_UPN AS UpnNo, C.PRL_LotNumber AS Lot, CONVERT(NVARCHAR(100),C.PRL_ReceiptQty) AS Qty, '' AS ExpDate, '' AS OrderNo, 'CS' AS Status
	FROM POReceiptHeader_SAPNoQR A, POReceipt_SAPNoQR B, POReceiptLot_SAPNoQR C, Product P
	WHERE A.PRH_ID = D.PRH_ID 
	AND A.PRH_ID = B.POR_PRH_ID
	AND B.POR_ID = C.PRL_POR_ID
	AND B.POR_SAP_PMA_ID = P.PMA_ID
	AND EXISTS (SELECT 1 FROM #TMP_SAMPLE S WHERE S.PRH_ID = A.PRH_ID)
	FOR XML PATH ('UpnItem')) AS DETAIL
	INTO #TMP_DETAIL
	FROM POReceiptHeader_SAPNoQR D
	WHERE EXISTS (SELECT 1 FROM #TMP_SAMPLE S WHERE S.PRH_ID = D.PRH_ID)

	INSERT INTO SampleSyncStack (SampleHeadId, ApplyType, SampleType, SyncType, SampleNo, SyncContent, SyncStatus, SyncErrCount, SyncMsg, CreateDate)
	SELECT C.SampleApplyHeadId, '申请单','测试样品','单据发货',C.ApplyNo,'<InterfaceDataSet><Record>' + A.HEADER + '<UpnList>' + B.DETAIL + '</UpnList></Record></InterfaceDataSet>','Wait', 0, '', GETDATE()
	FROM #TMP_HEADER A, #TMP_DETAIL B, #TMP_SAMPLE C
	WHERE A.PRH_ID = B.PRH_ID
	AND A.PRH_ID = C.PRH_ID

    UPDATE A SET A.PRH_Status = 'CS', A.PRH_InterfaceStatus = 'SAMPLE'
    FROM  POReceiptHeader_SAPNoQR A, #TMP_SAMPLE B
    WHERE A.PRH_ID = B.PRH_ID
    	
    COMMIT TRAN
    RETURN 1
  END TRY
  BEGIN CATCH
    ROLLBACK TRAN
    RETURN -1
  END CATCH
END
GO


