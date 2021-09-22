DROP PROCEDURE [dbo].[GC_GetConsignmentDelayApplyOrderHtml]
GO

/*
* 获得申请单的Html记录
*/
CREATE PROCEDURE [dbo].[GC_GetConsignmentDelayApplyOrderHtml]
	@KeyId uniqueidentifier,
	@MainKeyColumn NVARCHAR(100),
	@MainTableName NVARCHAR(100),
	@DetailKeyColumn NVARCHAR(100),
	@DetailTableName NVARCHAR(100),
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(1000) OUTPUT
AS
SET NOCOUNT ON
BEGIN TRY

	SET @RtnVal = 'Success'
	DECLARE @MainRtnMsg nvarchar(MAX)
	DECLARE @DetailRtnMsg nvarchar(MAX)
	
	DECLARE @DealerId uniqueidentifier
	
	SELECT @DealerId = CAH_DMA_ID FROM ConsignmentApplyHeader WHERE CAH_ID = @KeyId

	CREATE TABLE #TEMP
	(
		Id UNIQUEIDENTIFIER,
		CahId UNIQUEIDENTIFIER,
		CahOrderNo NVARCHAR(100),
		CahSubmitDate DATETIME,
		CfnId UNIQUEIDENTIFIER,
		PmaId UNIQUEIDENTIFIER,
		CfnChineseName NVARCHAR(200),
		CfnEnglishName NVARCHAR(200),
		CfnCode NVARCHAR(100),
		CfnCode2 NVARCHAR(100),
		CfnUom NVARCHAR(100),
		LotId UNIQUEIDENTIFIER,
		LtmId UNIQUEIDENTIFIER,
		LotNumber NVARCHAR(100),
		TotalQty DECIMAL(18,6),
		PurchaseId UNIQUEIDENTIFIER,
		PurchaseNo NVARCHAR(100),
		PurchaseDate DATETIME,
		PurchaseQty DECIMAL(18,6),
		POReceiptId UNIQUEIDENTIFIER,
		POReceiptNo NVARCHAR(100),
		POReceiptSapNo NVARCHAR(100),
		POReceiptDeliveryDate DATETIME,
		POReceiptDate DATETIME,
		POReceiptQty DECIMAL(18,6),
		ExpirationDate DATETIME,
		ConsignmentDay INT,
		DelayNumber INT
	)

	CREATE TABLE #ReturnTable
	(
		CahId UNIQUEIDENTIFIER,
		ReturnId UNIQUEIDENTIFIER,
		ReturnDealerId UNIQUEIDENTIFIER,
		ReturnNo NVARCHAR(200),
		ReturnDate DATETIME,
		ReturnApprovelDate DATETIME,
		ReturnPmaId UNIQUEIDENTIFIER,
		ReturnLotId UNIQUEIDENTIFIER,
		ReturnLotNumber NVARCHAR(200),
		ReturnQty DECIMAL(18,6)
	)

	CREATE TABLE #ShipmentTable
	(
		CahId UNIQUEIDENTIFIER,
		ShipmentId UNIQUEIDENTIFIER,
		ShipmentDealerId UNIQUEIDENTIFIER,
		ShipmentNo NVARCHAR(200),
		ShipmentDate DATETIME,
		ShipmentSubmitDate DATETIME,
		ShipmentPmaId UNIQUEIDENTIFIER,
		ShipmentLotId UNIQUEIDENTIFIER,
		ShipmentLtmId UNIQUEIDENTIFIER,
		ShipmentLotNumber NVARCHAR(200),
		ShipmentQty DECIMAL(18,6),
		ClearBorrowNo NVARCHAR(200),
		ClearBorrowDates DATETIME,
		ClearBorrowQty DECIMAL(18,6)
	)

	INSERT INTO #TEMP(Id			--UNIQUEIDENTIFIER
					,CahId			--UNIQUEIDENTIFIER
					,CahOrderNo		--NVARCHAR(100),
					,CahSubmitDate	--DATETIME,
					,CfnId			--UNIQUEIDENTIFIER,
					,PmaId			--UNIQUEIDENTIFIER,
					,CfnChineseName	--NVARCHAR(200),
					,CfnEnglishName	--NVARCHAR(200),
					,CfnCode			--NVARCHAR(100),
					,CfnCode2		--NVARCHAR(100),
					,CfnUom			--NVARCHAR(100),
					,ConsignmentDay	--INT,
					)
	SELECT	NEWID()
			,CAH_ID
			,CAH_OrderNo
			,CAH_SubmitDate
			,CFN_ID
			,PMA_ID
			,CFN_ChineseName
			,CFN_EnglishName
			,CFN_CustomerFaceNbr
			,CFN_Property1
			,CFN_Property3 
			,CAH_CM_ConsignmentDay
		FROM ConsignmentApplyHeader 
		INNER JOIN ConsignmentApplyDetails ON CAH_ID = CAD_CAH_ID
		INNER JOIN CFN ON CFN_ID = CAD_CFN_ID
		INNER JOIN Product ON PMA_CFN_ID = CFN_ID
		WHERE CAH_ID = @KeyId

	UPDATE #TEMP SET PurchaseId = POH_ID
						,PurchaseNo = POH_OrderNo
						,PurchaseDate = POH_SubmitDate
						,PurchaseQty = POD_RequiredQty
					FROM PurchaseOrderHeader
						INNER JOIN PurchaseOrderDetail ON POH_ID = POD_POH_ID
					WHERE POD_ShipmentNbr = #TEMP.CahOrderNo
						AND POD_CFN_ID = CfnId

	SELECT NEWID() AS Id,* INTO #TEMP_1 FROM 
	(
	SELECT DISTINCT CahId
			,CahOrderNo
			,CahSubmitDate
			,CfnId
			,PmaId
			,CfnChineseName
			,CfnEnglishName
			,CfnCode
			,CfnCode2
			,CfnUom
			,B.CFN_ID AS PORCfnId
			,A.PMA_ID AS PORPmaId
			,B.CFN_ChineseName AS PORCfnChineseName
			,B.CFN_EnglishName AS PORCfnEnglishName
			,B.CFN_CustomerFaceNbr AS PORCfnCode
			,B.CFN_Property1 AS PORCfnCode2
			,B.CFN_Property3 AS PORCfnUom
			,LotId
			,LtmId
			,PRL_LotNumber AS LotNumber
			,TotalQty
			,PurchaseId
			,PurchaseNo
			,PurchaseDate
			,PurchaseQty
			,PRH_ID AS POReceiptId
			,PRH_PONumber AS POReceiptNo
			,PRH_SAPShipmentID AS POReceiptSapNo
			,PRH_SAPShipmentDate AS POReceiptDeliveryDate
			,PRH_ReceiptDate AS POReceiptDate
			,PRL_ReceiptQty AS POReceiptQty
			,ExpirationDate
			,ConsignmentDay
			,DelayNumber
			,CAST('' AS NVARCHAR(200)) AS ComplainNo
			,CAST('' AS NVARCHAR(200)) AS ComplainBscNo
			,CAST(NULL AS DATETIME) AS ComplainDate
			,CAST('' AS NVARCHAR(200)) AS ComplainStatus
			,CAST(NULL AS DECIMAL(18,6)) AS ComplainQty --INTO #TEMP_1 
			FROM #TEMP 
				INNER JOIN POReceiptHeader ON PRH_PurchaseOrderNbr LIKE '%'+PurchaseNo+'%' 
				INNER JOIN POReceipt ON PRH_ID = POR_PRH_ID --AND PmaId = POR_SAP_PMA_ID
				INNER JOIN POReceiptLot ON POR_ID = PRL_POR_ID
				INNER JOIN Product A ON A.PMA_ID = POR_SAP_PMA_ID
				INNER JOIN CFN B ON B.CFN_ID = A.PMA_CFN_ID
				INNER JOIN CFN C ON C.CFN_ID = CfnId
			WHERE PRH_Status <> 'Cancelled' 
				AND PRH_Type = 'PurchaseOrder'
				AND B.CFN_Property1 = C.CFN_Property1
	) T

	--在相同的仓库中，相同的产品型号相同的批次号，仅有一条记录
	UPDATE #TEMP_1 SET LotId = LOT_ID,LtmId = LTM_ID,TotalQty = LOT_OnHandQty FROM 
	(
	SELECT LOT_ID,LTM_ID,INV_ID,PRH_ID,PRH_WHM_ID,PORPmaId,LotNumber,LOT_OnHandQty FROM #TEMP_1 
	INNER JOIN POReceiptHeader ON PRH_ID = POReceiptId
	INNER JOIN Inventory ON INV_WHM_ID = PRH_WHM_ID AND PORPmaId = INV_PMA_ID
	INNER JOIN Lot ON LOT_INV_ID = INV_ID
	INNER JOIN LotMaster ON LTM_ID = LOT_LTM_ID AND LTM_LotNumber = LotNumber
	) T WHERE T.PORPmaId = #TEMP_1.PORPmaId
	AND T.LotNumber = #TEMP_1.LotNumber
	AND T.PRH_ID = #TEMP_1.POReceiptId

	--退货给其他经销商的退货数据（IAL_PRH_ID存放短期寄售申请单主键）
	INSERT INTO #ReturnTable 
			(CahId
			,ReturnId
			,ReturnDealerId
			,ReturnNo
			,ReturnDate
			,ReturnApprovelDate
			,ReturnPmaId
			,ReturnLotId
			,ReturnLotNumber
			,ReturnQty
			)
	SELECT @KeyId
		,IAH_ID
		,IAH_DMA_ID
		,IAH_Inv_Adj_Nbr
		,IAH_CreatedDate
		,IAH_ApprovalDate
		,IAD_PMA_ID
		,IAL_LOT_ID
		,IAL_LotNumber
		,IAL_LotQty 
	FROM InventoryAdjustHeader
				INNER JOIN InventoryAdjustDetail ON IAH_ID = IAD_IAH_ID 
				INNER JOIN InventoryAdjustLot ON IAD_ID = IAL_IAD_ID
			WHERE IAL_PRH_ID = @KeyId 
				AND IAH_Reason = 'Transfer'
				AND IAH_Status = 'Accept'
				AND IAL_PRH_ID IS NOT NULL 
				AND IAL_DMA_ID IS NOT NULL
				AND IAH_DMA_ID = @DealerId
	
	--退货给BSC的退货数据（IAL_PRH_ID存放发货单主键）
	INSERT INTO #ReturnTable 
			(CahId
			,ReturnId
			,ReturnDealerId
			,ReturnNo
			,ReturnDate
			,ReturnApprovelDate
			,ReturnPmaId
			,ReturnLotId
			,ReturnLotNumber
			,ReturnQty
			)
	SELECT @KeyId
		,IAH_ID
		,IAH_DMA_ID
		,IAH_Inv_Adj_Nbr
		,IAH_CreatedDate
		,IAH_ApprovalDate
		,IAD_PMA_ID
		,IAL_LOT_ID
		,IAL_LotNumber
		,IAL_LotQty 
	FROM InventoryAdjustHeader
				INNER JOIN InventoryAdjustDetail ON IAH_ID = IAD_IAH_ID 
				INNER JOIN InventoryAdjustLot ON IAD_ID = IAL_IAD_ID
			WHERE IAH_Reason IN ('Return','Exchange')
				AND IAH_Status = 'Accept'
				AND IAL_PRH_ID IS NOT NULL
				AND EXISTS(SELECT 1 FROM ConsignmentApplyHeader 
									INNER JOIN POReceiptHeader ON PRH_PurchaseOrderNbr LIKE '%' + CAH_POH_OrderNo + '%'  
								WHERE CAH_ID = @KeyId
									AND PRH_ID = IAL_PRH_ID
									AND CAH_DMA_ID = @DealerId
							)
				
	--得到销售数据
	INSERT INTO #ShipmentTable
			(CahId
			,ShipmentId
			,ShipmentDealerId
			,ShipmentNo
			,ShipmentDate
			,ShipmentSubmitDate
			,ShipmentPmaId
			,ShipmentLotId
			,ShipmentLtmId
			,ShipmentLotNumber
			,ShipmentQty
			,ClearBorrowNo
			,ClearBorrowDates
			,ClearBorrowQty
			)
	SELECT @KeyId
		,SPH_ID
		,SPH_Dealer_DMA_ID
		,SPH_ShipmentNbr
		,SPH_ShipmentDate
		,SPH_SubmitDate
		,SPL_Shipment_PMA_ID
		,SLT_LOT_ID
		,LTM_ID
		,LTM_LotNumber
		,SLT_LotShippedQty
		,POH_OrderNo
		,ISNULL((SELECT MAX(POL_OperDate) FROM PurchaseOrderLog WHERE POL_POH_ID = POH_ID AND POL_OperType = 'Confirm'),POH_SubmitDate)
		,POD_RequiredQty
	FROM ShipmentHeader
				INNER JOIN ShipmentLine ON SPH_ID = SPL_SPH_ID
				INNER JOIN ShipmentLot ON SPL_ID = SLT_SPL_ID
				INNER JOIN Lot ON LOT_ID = SLT_LOT_ID
				INNER JOIN LotMaster ON LTM_ID = LOT_LTM_ID
				INNER JOIN DealerMaster ON DMA_ID = SPH_Dealer_DMA_ID
				INNER JOIN Inventory ON INV_ID = LOT_INV_ID
				INNER JOIN Product ON PMA_ID = INV_PMA_ID
				LEFT JOIN 
						(
							SELECT * FROM PurchaseOrderHeader
								INNER JOIN PurchaseOrderDetail ON POH_ID = POD_POH_ID
							WHERE POH_OrderType = 'ClearBorrowManual' 
								AND POH_OrderStatus = 'Completed' 
								AND POH_CreateType = 'Manual'
						 ) T ON POD_CFN_ID = PMA_CFN_ID 
							AND POD_ShipmentNbr = SPH_ShipmentNbr 
							AND (POD_LotNumber +'@@' + ISNULL(POD_QRCode,'NoQR')) = LTM_LotNumber
			WHERE SLT_CAH_ID = @KeyId
				AND SPH_Status = 'Complete'
				AND SLT_CAH_ID IS NOT NULL 
				AND SPH_Dealer_DMA_ID = @DealerId
				AND DMA_DealerType = 'T1'
				AND EXISTS (SELECT 1 FROM #TEMP_1 WHERE LotNumber = LTM_LotNumber)

	--得到销售数据(根据二维码)
	INSERT INTO #ShipmentTable
			(CahId
			,ShipmentId
			,ShipmentDealerId
			,ShipmentNo
			,ShipmentDate
			,ShipmentSubmitDate
			,ShipmentPmaId
			,ShipmentLotId
			,ShipmentLtmId
			,ShipmentLotNumber
			,ShipmentQty
			,ClearBorrowNo
			,ClearBorrowDates
			,ClearBorrowQty
			)
	SELECT @KeyId
		,SPH_ID
		,SPH_Dealer_DMA_ID
		,SPH_ShipmentNbr
		,SPH_ShipmentDate
		,SPH_SubmitDate
		,SPL_Shipment_PMA_ID
		,SLT_LOT_ID
		,LTM_ID
		,LTM_LotNumber
		,SLT_LotShippedQty
		,POH_OrderNo
		,ISNULL((SELECT MAX(POL_OperDate) FROM PurchaseOrderLog WHERE POL_POH_ID = POH_ID AND POL_OperType = 'Confirm'),POH_SubmitDate)
		,POD_RequiredQty
	FROM ShipmentHeader
				INNER JOIN ShipmentLine ON SPH_ID = SPL_SPH_ID
				INNER JOIN ShipmentLot ON SPL_ID = SLT_SPL_ID
				INNER JOIN Lot ON LOT_ID = SLT_LOT_ID
				INNER JOIN LotMaster ON LTM_ID = LOT_LTM_ID
				INNER JOIN DealerMaster ON DMA_ID = SPH_Dealer_DMA_ID
				INNER JOIN Inventory ON INV_ID = LOT_INV_ID
				INNER JOIN Product ON PMA_ID = INV_PMA_ID
				LEFT JOIN 
						(
							SELECT * FROM PurchaseOrderHeader
								INNER JOIN PurchaseOrderDetail ON POH_ID = POD_POH_ID
							WHERE POH_OrderType = 'ClearBorrowManual' 
								AND POH_OrderStatus = 'Completed' 
								AND POH_CreateType = 'Manual'
						 ) T ON POD_CFN_ID = PMA_CFN_ID 
							AND POD_ShipmentNbr = SPH_ShipmentNbr 
							AND (POD_LotNumber +'@@' + ISNULL(POD_QRCode,'NoQR')) = LTM_LotNumber
			WHERE SPH_Status = 'Complete'
				AND SLT_CAH_ID IS NULL 
				AND DMA_DealerType = 'T1'
				AND SPH_Dealer_DMA_ID = @DealerId
				AND EXISTS (SELECT 1 FROM #TEMP_1 WHERE LotNumber = LTM_LotNumber)

	--得到销售数据(平台分销给T2，清指定批号订单)
	INSERT INTO #ShipmentTable
			(CahId
			,ShipmentId
			,ShipmentDealerId
			,ShipmentNo
			,ShipmentDate
			,ShipmentSubmitDate
			,ShipmentPmaId
			,ShipmentLotId
			,ShipmentLtmId
			,ShipmentLotNumber
			,ShipmentQty
			,ClearBorrowNo
			,ClearBorrowDates
			,ClearBorrowQty
			)
	SELECT @KeyId
		,POH_ID
		,POH_DMA_ID
		,POD_ShipmentNbr
		,SPH_SubmitDate
		,SPH_ShipmentDate
		,POH_DMA_ID
		,SLT_LOT_ID
		,LTM_ID
		,LTM_LotNumber
		,SLT_LotShippedQty
		,POH_OrderNo
		,ISNULL((SELECT MAX(POL_OperDate) FROM PurchaseOrderLog WHERE POL_POH_ID = POH_ID AND POL_OperType = 'Confirm'),POH_SubmitDate)
		,POD_RequiredQty
	FROM PurchaseOrderHeader
				INNER JOIN PurchaseOrderDetail ON POH_ID = POD_POH_ID
				INNER JOIN #TEMP_1 ON POD_CFN_ID = PORCfnId AND (POD_LotNumber +'@@' + ISNULL(POD_QRCode,'NoQR')) = LotNumber
				INNER JOIN ShipmentHeader ON SPH_ShipmentNbr = POD_ShipmentNbr
				INNER JOIN ShipmentLine ON SPH_ID = SPL_SPH_ID --AND SPL_Shipment_PMA_ID = PORPmaId
				INNER JOIN ShipmentLot ON SPL_ID = SLT_SPL_ID
				INNER JOIN Lot ON LOT_ID = SLT_LOT_ID
				INNER JOIN LotMaster ON LTM_ID = LOT_LTM_ID AND LotNumber = LTM_LotNumber
				INNER JOIN DealerMaster ON DMA_ID = POH_DMA_ID
			WHERE POH_OrderType = 'ClearBorrowManual'
				AND DMA_DealerType = 'LP'
				AND POH_CreateType = 'Manual'
				AND POH_OrderStatus = 'Completed'

	--得到销售数据(平台分销给T2，清指定批号订单)
	INSERT INTO #ShipmentTable
			(CahId
			,ShipmentId
			,ShipmentDealerId
			,ShipmentNo
			,ShipmentDate
			,ShipmentSubmitDate
			,ShipmentPmaId
			,ShipmentLotId
			,ShipmentLtmId
			,ShipmentLotNumber
			,ShipmentQty
			,ClearBorrowNo
			,ClearBorrowDates
			,ClearBorrowQty
			)
	SELECT @KeyId
		,POH_ID
		,POH_DMA_ID
		,POD_ShipmentNbr
		,PRH_SapDeliveryDate
		,PRH_ReceiptDate
		,POH_DMA_ID
		,(SELECT TOP 1 LOT_ID FROM Lot 
				INNER JOIN Inventory ON INV_ID = LOT_INV_ID
			WHERE LOT_LTM_ID = LTM_ID 
				AND INV_PMA_ID = PORPmaId
				AND INV_WHM_ID = PRL_WHM_ID 
		)
		,LTM_ID
		,LTM_LotNumber
		,PRL_ReceiptQty
		,POH_OrderNo
		,ISNULL((SELECT MAX(POL_OperDate) FROM PurchaseOrderLog WHERE POL_POH_ID = POH_ID AND POL_OperType = 'Confirm'),POH_SubmitDate)
		,POD_RequiredQty
	FROM PurchaseOrderHeader
				INNER JOIN PurchaseOrderDetail ON POH_ID = POD_POH_ID
				INNER JOIN #TEMP_1 ON POD_CFN_ID = PORCfnId AND (POD_LotNumber +'@@' + ISNULL(POD_QRCode,'NoQR')) = LotNumber
				INNER JOIN POReceiptHeader ON PRH_SAPShipmentID = POD_ShipmentNbr
				INNER JOIN POReceipt ON PRH_ID = POR_PRH_ID --AND SPL_Shipment_PMA_ID = PORPmaId
				INNER JOIN POReceiptLot ON POR_ID = PRL_POR_ID
				INNER JOIN LotMaster ON LotNumber = LTM_LotNumber AND PRL_LotNumber = LTM_LotNumber
				INNER JOIN DealerMaster ON DMA_ID = POH_DMA_ID
			WHERE POH_OrderType = 'ClearBorrowManual'
				AND DMA_DealerType = 'LP'
				AND POH_CreateType = 'Manual'
				AND POH_OrderStatus = 'Completed'

	--合并销售单记录
	SELECT T.* INTO #ShipmentTemp FROM 
	(
	SELECT B.ShipmentLtmId,B.ShipmentDealerId,B.CahId AS ShipmentCahId,LEFT(ShipmentNos,LEN(ShipmentNos)-1) AS ShipmentNos,
	LEFT(ShipmentDates,LEN(ShipmentDates)-1) AS ShipmentDates,LEFT(ShipmentSubmitDates,LEN(ShipmentSubmitDates)-1) AS ShipmentSubmitDates,
	ClearBorrowQty,ShipmentQty,
	CASE WHEN B.ClearBorrowNos = NULL OR LEN(B.ClearBorrowNos) = 0 THEN '' ELSE LEFT(B.ClearBorrowNos,LEN(B.ClearBorrowNos)-1) END AS ClearBorrowNos,
	CASE WHEN B.ClearBorrowDates = NULL OR LEN(B.ClearBorrowDates) = 0 THEN '' ELSE LEFT(B.ClearBorrowDates,LEN(B.ClearBorrowDates)-1) END AS ClearBorrowDates
	FROM (
	SELECT ShipmentLtmId,ShipmentDealerId,CahId,SUM(ShipmentQty) AS ShipmentQty,SUM(A.ClearBorrowQty) AS ClearBorrowQty,
	(SELECT ShipmentNo+',' FROM #ShipmentTable 
	  WHERE ShipmentLtmId = A.ShipmentLtmId AND ShipmentDealerId = A.ShipmentDealerId AND CahId = A.CahId
	  FOR XML PATH('') ) AS ShipmentNos,
	(SELECT CONVERT(NVARCHAR(100),ShipmentDate,120)+',' FROM #ShipmentTable 
	  WHERE ShipmentLtmId = A.ShipmentLtmId AND ShipmentDealerId = A.ShipmentDealerId AND CahId = A.CahId
	  FOR XML PATH('') ) AS ShipmentDates,
	(SELECT CONVERT(NVARCHAR(100),ShipmentSubmitDate,120)+',' FROM #ShipmentTable 
	  WHERE ShipmentLtmId = A.ShipmentLtmId AND ShipmentDealerId = A.ShipmentDealerId AND CahId = A.CahId
	  FOR XML PATH('') ) AS ShipmentSubmitDates,
	(SELECT A.ClearBorrowNo+',' FROM #ShipmentTable 
	  WHERE ShipmentLtmId = A.ShipmentLtmId AND ShipmentDealerId = A.ShipmentDealerId AND CahId = A.CahId
	  FOR XML PATH('') ) AS ClearBorrowNos,
	(SELECT CONVERT(NVARCHAR(100),A.ClearBorrowDates,120)+',' FROM #ShipmentTable 
	  WHERE ShipmentLtmId = A.ShipmentLtmId AND ShipmentDealerId = A.ShipmentDealerId AND CahId = A.CahId
	  FOR XML PATH('') ) AS ClearBorrowDates
	FROM #ShipmentTable A 
	GROUP BY ShipmentLtmId,ShipmentDealerId,CahId,ClearBorrowNo,ClearBorrowDates
	) B  
	) T

	--合并退货单记录
	SELECT T.* INTO #ReturnTemp FROM
	(
	SELECT B.ReturnLotId,B.ReturnDealerId,B.CahId AS ReturnCahId,LEFT(ReturnNos,LEN(ReturnNos)-1) AS ReturnNos,
	LEFT(ReturnDates,LEN(ReturnDates)-1) AS ReturnDates,LEFT(ReturnApprovelDates,LEN(ReturnApprovelDates)-1) AS ReturnApprovelDates,
	ReturnQty FROM (
	SELECT ReturnLotId,ReturnDealerId,CahId,SUM(ReturnQty) AS ReturnQty,
	(SELECT ReturnNo+',' FROM #ReturnTable 
	  WHERE ReturnLotId = A.ReturnLotId AND ReturnDealerId = A.ReturnDealerId AND CahId = A.CahId
	  FOR XML PATH('') ) AS ReturnNos,
	(SELECT CONVERT(NVARCHAR(100),ReturnDate,120)+',' FROM #ReturnTable 
	  WHERE ReturnLotId=A.ReturnLotId  AND ReturnDealerId = A.ReturnDealerId AND CahId = A.CahId
	  FOR XML PATH('') ) AS ReturnDates,
	(SELECT CONVERT(NVARCHAR(100),ReturnApprovelDate,120)+',' FROM #ReturnTable 
	  WHERE ReturnLotId=A.ReturnLotId  AND ReturnDealerId = A.ReturnDealerId AND CahId = A.CahId
	  FOR XML PATH('') ) AS ReturnApprovelDates
	FROM #ReturnTable A 
	GROUP BY ReturnLotId,ReturnDealerId,CahId
	) B  
	) T
	
	UPDATE #TEMP_1 SET 
		ComplainNo = ISNULL(A.ComplainNbr,'')
		,ComplainBscNo = ISNULL(A.BscComplainNo,'')
		,ComplainDate = A.ComplainDate
		,ComplainStatus = ISNULL(A.ComplainStatus,'')
		,ComplainQty = A.ComplainQty
		FROM V_ComplainList A
	WHERE (A.ComplainLOT+'@@'+A.ComplainQRCode) = LotNumber
	AND A.WHM_DMA_ID = @DealerId
		
	UPDATE #TEMP_1 SET DelayNumber = ISNULL(CAH_CM_DelayNumber,0)-ISNULL(CAH_Delay_DelayTime,0) FROM ConsignmentApplyHeader WHERE CAH_ID = CahId

	UPDATE #TEMP_1 SET ExpirationDate = DATEADD(DAY,ISNULL(ConsignmentDay,0)*(ISNULL(DelayNumber,0)+1),POReceiptDeliveryDate) 

	--SELECT *,(POReceiptQty-ISNULL(ShipmentQty,0)-ISNULL(ReturnQty,0)) AS Qty FROM #TEMP_1 
	--LEFT JOIN #ShipmentTemp ON LotId = ShipmentLotId
	--LEFT JOIN #ReturnTemp ON LotId = ReturnLotId
	--ORDER BY CfnCode,CfnCode2,LotNumber,POReceiptDeliveryDate

BEGIN TRAN
	INSERT INTO ConsignmentProductTrackTemp
           ([Id]
           ,[产品型号]
           ,[短编号]
           ,[批次号]
		   ,[二维码]
           ,[订单号]
           ,[订单日期]
           ,[发货单号]
           ,[发货日期]
           ,[发货数量]
           ,[退货单号]
           ,[退货日期]
           ,[退货数量]
           ,[销售单号]
           ,[销售日期]
           ,[销售数量]
           ,[清指定批号订单号]
           ,[清指定批号完成日期]
           ,[清指定批号数量]
		   ,[投诉单号]
           ,[投诉日期]
           ,[投诉数量]
           ,[当前库存])
	SELECT CahId AS Id,
		CfnCode AS '产品型号',
		CfnCode2 AS '短编号',
		CASE WHEN CHARINDEX('@@',LotNumber) > 0 THEN substring(LotNumber,1,CHARINDEX('@@',LotNumber)-1) ELSE LotNumber END AS '批次号',
		CASE WHEN CHARINDEX('@@',LotNumber) > 0 THEN substring(LotNumber,CHARINDEX('@@',LotNumber)+2,LEN(LotNumber)-CHARINDEX('@@',LotNumber)) ELSE 'NoQR' END AS '二维码',
		PurchaseNo AS '订单号',
		CONVERT(NVARCHAR(10),PurchaseDate,120) AS '订单日期',
		POReceiptNo AS '发货单号',
		CONVERT(NVARCHAR(10),POReceiptDeliveryDate,120) AS '发货日期',
		POReceiptQty AS '发货数量',
		ReturnNos AS '退货单号',
		ReturnDates AS '退货日期',
		ReturnQty AS '退货数量',
		ShipmentNos AS '销售单号',
		ShipmentDates AS '销售日期',
		ShipmentQty AS '销售数量',
		ClearBorrowNos AS '清指定批号订单号',
		ClearBorrowDates AS '清指定批号完成日期',
		ClearBorrowQty AS '清指定批号数量',
		ComplainNo AS '投诉单号',
		CONVERT(NVARCHAR(100),ComplainDate,120) AS '投诉日期',
		ComplainQty AS '投诉数量',
		(POReceiptQty-ISNULL(ClearBorrowQty,0)-ISNULL(ReturnQty,0)-ISNULL(ComplainQty,0)) AS '当前库存' FROM #TEMP_1 
	LEFT JOIN #ShipmentTemp ON LtmId = ShipmentLtmId AND @DealerId = ShipmentDealerId AND CahId = ShipmentCahId
	LEFT JOIN #ReturnTemp ON LotId = ReturnLotId AND @DealerId = ReturnDealerId AND CahId = ReturnCahId
	ORDER BY CfnCode,CfnCode2,LotNumber,POReceiptDeliveryDate

	EXEC dbo.Proc_getHtmlForm @KeyId,@MainKeyColumn,@MainTableName,@MainRtnMsg OUTPUT
	EXEC dbo.Proc_getHtmlTable @KeyId,'Id','ConsignmentProductTrackTemp',@DetailRtnMsg OUTPUT  
	
	DELETE FROM ConsignmentProductTrackTemp WHERE Id = @KeyId

	SELECT @MainRtnMsg+'<br />'+@DetailRtnMsg AS HtmlStr
COMMIT TRAN

SET NOCOUNT OFF
RETURN 1

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
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH
GO


