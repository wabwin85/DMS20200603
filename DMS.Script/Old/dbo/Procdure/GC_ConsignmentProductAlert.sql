DROP PROCEDURE [dbo].[GC_ConsignmentProductAlert]
GO

/*
* 短期寄售产品过期提醒
*/
CREATE PROCEDURE [dbo].[GC_ConsignmentProductAlert]
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(2000)  OUTPUT
AS
SET NOCOUNT ON
BEGIN TRY

BEGIN TRAN
	
	
	DECLARE @SysUserId uniqueidentifier
	DECLARE @DealerId uniqueidentifier
	DECLARE @UserType nvarchar(20)

	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	CREATE TABLE #TEMP
	(
		Id UNIQUEIDENTIFIER,
		CahId UNIQUEIDENTIFIER,
		CahOrderNo NVARCHAR(100),
		DealerId UNIQUEIDENTIFIER,
		ProduceLineId UNIQUEIDENTIFIER,
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
		ApplyQty DECIMAL(18,6),
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
					,DealerId		--UNIQUEIDENTIFIER,
					,ProduceLineId	--UNIQUEIDENTIFIER,
					,CahSubmitDate	--DATETIME,
					,CfnId			--UNIQUEIDENTIFIER,
					,PmaId			--UNIQUEIDENTIFIER,
					,CfnChineseName	--NVARCHAR(200),
					,CfnEnglishName	--NVARCHAR(200),
					,CfnCode			--NVARCHAR(100),
					,CfnCode2		--NVARCHAR(100),
					,CfnUom			--NVARCHAR(100),
					,ConsignmentDay	--INT,
					,ApplyQty
					)
	SELECT	NEWID()
			,CAH_ID
			,CAH_OrderNo
			,CAH_DMA_ID
			,CAH_ProductLine_Id
			,CAH_SubmitDate
			,CFN_ID
			,PMA_ID
			,CFN_ChineseName
			,CFN_EnglishName
			,CFN_CustomerFaceNbr
			,CFN_Property1
			,CFN_Property3 
			,CAH_CM_ConsignmentDay
			,CAD_Qty
		FROM ConsignmentApplyHeader 
		INNER JOIN ConsignmentApplyDetails ON CAH_ID = CAD_CAH_ID
		INNER JOIN CFN ON CFN_ID = CAD_CFN_ID
		INNER JOIN Product ON PMA_CFN_ID = CFN_ID
		WHERE CAH_OrderStatus = 'Approved'
		
	UPDATE #TEMP SET PurchaseId = POH_ID
						,PurchaseNo = POH_OrderNo
						,PurchaseDate = POH_SubmitDate
						,PurchaseQty = POD_RequiredQty
					FROM PurchaseOrderHeader
						INNER JOIN PurchaseOrderDetail ON POH_ID = POD_POH_ID
					WHERE POD_ShipmentNbr = #TEMP.CahOrderNo
						AND POD_CFN_ID = CfnId
	
	SELECT NEWID() AS Id,* INTO #TEMP_1 FROM 
	(SELECT DISTINCT CahId
			,CahOrderNo
			,DealerId
			,ProduceLineId
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
			,ApplyQty
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
				INNER JOIN POReceiptHeader ON PRH_PurchaseOrderNbr LIKE '%' +  PurchaseNo + '%'
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
	SELECT IAL_PRH_ID
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
			WHERE IAH_Reason = 'Transfer'
				AND IAH_Status = 'Accept'
				AND IAL_PRH_ID IS NOT NULL 
				AND IAL_DMA_ID IS NOT NULL
				
	
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
	SELECT (SELECT TOP 1 CahId FROM #TEMP_1 INNER JOIN POReceiptHeader ON PRH_PurchaseOrderNbr LIKE '%' + PurchaseNo + '%'
				WHERE PRH_ID = IAL_PRH_ID) AS CahId
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
				AND EXISTS(SELECT 1 FROM #TEMP_1 
									INNER JOIN POReceiptHeader ON PRH_PurchaseOrderNbr LIKE '%' + PurchaseNo + '%'
								WHERE PRH_ID = IAL_PRH_ID AND DealerId = IAH_DMA_ID
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
	SELECT SLT_CAH_ID
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
				INNER JOIN #TEMP_1 ON CahId = SLT_CAH_ID AND LotNumber = LTM_LotNumber
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
				AND SLT_CAH_ID IS NOT NULL 
				AND SPH_Dealer_DMA_ID = DealerId
				AND DMA_DealerType = 'T1'
				
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
	SELECT CahId
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
				INNER JOIN #TEMP_1 ON LotNumber = LTM_LotNumber
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
				AND SPH_Dealer_DMA_ID = DealerId
		
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
	SELECT CahId
		,POH_ID
		,POH_DMA_ID
		,POD_ShipmentNbr
		,SPH_SubmitDate
		,SPH_ShipmentDate
		,SPL_Shipment_PMA_ID
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
	SELECT CahId
		,POH_ID
		,POH_DMA_ID
		,POD_ShipmentNbr
		,PRH_SapDeliveryDate
		,PRH_ReceiptDate
		,PORPmaId
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
	AND A.WHM_DMA_ID = DealerId
	
	UPDATE #TEMP_1 SET DelayNumber = ISNULL(CAH_CM_DelayNumber,0)-ISNULL(CAH_Delay_DelayTime,0) FROM ConsignmentApplyHeader WHERE CAH_ID = CahId

	UPDATE #TEMP_1 SET ExpirationDate = CONVERT(NVARCHAR(10),DATEADD(DAY,ISNULL(ConsignmentDay,0)*(ISNULL(DelayNumber,0)+1),POReceiptDeliveryDate),120)

	SELECT A.*,B.*,C.*,D.ATTRIBUTE_NAME,D.DESCRIPTION,E.*,F.*,(POReceiptQty-ISNULL(ClearBorrowQty,0)-ISNULL(ReturnQty,0)-ISNULL(ComplainQty,0)) AS Qty,DATEDIFF(DAY,GETDATE(),DATEADD(DAY,5,ExpirationDate)) AS OverdueDays,
	(SELECT EMAIL1 FROM Lafite_IDENTITY WHERE Id = CAH_CreateUser) AS DealerEmail
	INTO #TEMP_2
	FROM #TEMP_1 A
	INNER JOIN ConsignmentApplyHeader B ON CAH_ID = CahId
	INNER JOIN DealerMaster C ON DMA_ID = CAH_DMA_ID
	INNER JOIN VIEW_ProductLine D ON D.Id = CAH_ProductLine_Id
	LEFT JOIN #ShipmentTemp E ON LtmId = ShipmentLtmId AND DealerId = E.ShipmentDealerId AND CahId = E.ShipmentCahId
	LEFT JOIN #ReturnTemp F ON LotId = ReturnLotId AND DealerId = F.ReturnDealerId  AND CahId = F.ReturnCahId
	ORDER BY CfnCode,CfnCode2,LotNumber,POReceiptDeliveryDate
	
	CREATE TABLE #EmailTemp
	(
		DealerId UNIQUEIDENTIFIER,
		DealerName NVARCHAR(200),
		ProductLineId UNIQUEIDENTIFIER,
		Email NVARCHAR(200),
		MailCode NVARCHAR(200),
		ApplyNo NVARCHAR(200),
		ApplyDate NVARCHAR(200),
		OrderNo NVARCHAR(200),
		OrderDate NVARCHAR(200),
		ReceiptDate NVARCHAR(200),
		UPN NVARCHAR(200),
		LotNumber NVARCHAR(200),
		Qty NVARCHAR(200)
	)
	CREATE TABLE #EmailTemp_2
	(
		DealerId UNIQUEIDENTIFIER,
		DealerName NVARCHAR(200),
		ProductLineId UNIQUEIDENTIFIER,
		Email NVARCHAR(200),
		MailCode NVARCHAR(200),
		MailMessage NVARCHAR(MAX)
	)
	CREATE TABLE #EmailTemp_3
	(
		DealerId UNIQUEIDENTIFIER,
		DealerName NVARCHAR(200),
		ApplyNo NVARCHAR(200),
		SaleName NVARCHAR(200),
		SaleEmail NVARCHAR(200),
		MailCode NVARCHAR(200),
		MailMessage NVARCHAR(MAX)
	)

--select DMA_ID,t.CahOrderNo,t.DMA_ChineseName,CfnCode,LotNumber,Qty into #TEMP_3 from 
--(
--SELECT DMA_ID,DMA_ChineseName,CAH_ProductLine_Id,ExpirationDate,CahOrderNo,CahSubmitDate,PurchaseNo,PurchaseDate,POReceiptDeliveryDate,CfnCode,LotNumber,Qty,CASE WHEN Qty > 0 THEN OverdueDays ELSE 0 END AS OverdueDays,DealerEmail 
--FROM #TEMP_2
--WHERE Qty <> 0
--AND LotNumber NOT LIKE '%NoQR%'
--) t
--order by t.OverdueDays


--SELECT *,(SELECT SUM(LOT_OnHandQty) AS InvQty FROM LotMaster 
--INNER JOIN Lot ON LOT_LTM_ID = LTM_ID 
--INNER JOIN Inventory ON INV_ID = LOT_INV_ID
--INNER JOIN Warehouse ON WHM_ID = INV_WHM_ID AND WHM_DMA_ID = DMA_ID
--WHERE LTM_LotNumber = LotNumber ) as InvQty INTO #TEMP_5  FROM #TEMP_3 

--SELECT * FROM #ReturnTable WHERE ReturnLotNumber = '18390261@@875076364111552'

--select * from #TEMP_5 WHERE InvQty <> Qty

	INSERT INTO #EmailTemp
	SELECT DMA_ID,DMA_ChineseName,CAH_ProductLine_Id,DealerEmail,'EMAIL_CONSIGNMENT_BEFORE_ALTER',CahOrderNo,CONVERT(NVARCHAR(10),CahSubmitDate,120),PurchaseNo,CONVERT(NVARCHAR(10),PurchaseDate,120),CONVERT(NVARCHAR(10),POReceiptDeliveryDate,120),CfnCode,LotNumber,Qty FROM 
	(
	SELECT DMA_ID,DMA_ChineseName,CAH_ProductLine_Id,ExpirationDate,CahOrderNo,CahSubmitDate,PurchaseNo,PurchaseDate,POReceiptDeliveryDate,CfnCode,LotNumber,Qty,CASE WHEN Qty > 0 THEN OverdueDays ELSE 0 END AS OverdueDays,DealerEmail FROM #TEMP_2
	) T
	WHERE Qty > 0
	AND OverdueDays = 5
	GROUP BY DMA_ID,DMA_ChineseName,CAH_ProductLine_Id,DealerEmail,CahOrderNo,CahSubmitDate,PurchaseNo,PurchaseDate,POReceiptDeliveryDate,CfnCode,LotNumber,Qty

	INSERT INTO #EmailTemp
	SELECT DMA_ID,DMA_ChineseName,CAH_ProductLine_Id,DealerEmail,'EMAIL_CONSIGNMENT_BEFORE_ALTER',CahOrderNo,CONVERT(NVARCHAR(10),CahSubmitDate,120),PurchaseNo,CONVERT(NVARCHAR(10),PurchaseDate,120),CONVERT(NVARCHAR(10),POReceiptDeliveryDate,120),CfnCode,LotNumber,Qty FROM 
	(
	SELECT DMA_ID,DMA_ChineseName,CAH_ProductLine_Id,ExpirationDate,CahOrderNo,CahSubmitDate,PurchaseNo,PurchaseDate,POReceiptDeliveryDate,CfnCode,LotNumber,Qty,CASE WHEN Qty > 0 THEN OverdueDays ELSE 0 END AS OverdueDays,DealerEmail FROM #TEMP_2
	) T
	WHERE Qty > 0
	AND OverdueDays = 0
	GROUP BY DMA_ID,DMA_ChineseName,CAH_ProductLine_Id,DealerEmail,CahOrderNo,CahSubmitDate,PurchaseNo,PurchaseDate,POReceiptDeliveryDate,CfnCode,LotNumber,Qty

	INSERT INTO #EmailTemp
	SELECT DMA_ID,DMA_ChineseName,CAH_ProductLine_Id,DealerEmail,'EMAIL_CONSIGNMENT_BEFORE_ALTER',CahOrderNo,CONVERT(NVARCHAR(10),CahSubmitDate,120),PurchaseNo,CONVERT(NVARCHAR(10),PurchaseDate,120),CONVERT(NVARCHAR(10),POReceiptDeliveryDate,120),CfnCode,LotNumber,Qty FROM 
	(
	SELECT DMA_ID,DMA_ChineseName,CAH_ProductLine_Id,ExpirationDate,CahOrderNo,CahSubmitDate,PurchaseNo,PurchaseDate,POReceiptDeliveryDate,CfnCode,LotNumber,Qty,CASE WHEN Qty > 0 THEN OverdueDays ELSE 0 END AS OverdueDays,DealerEmail FROM #TEMP_2
	) T
	WHERE Qty > 0
	AND OverdueDays = -5
	GROUP BY DMA_ID,DMA_ChineseName,CAH_ProductLine_Id,DealerEmail,CahOrderNo,CahSubmitDate,PurchaseNo,PurchaseDate,POReceiptDeliveryDate,CfnCode,LotNumber,Qty

	DECLARE @EailMessage NVARCHAR(MAX)
	DECLARE @E_DealerId uniqueidentifier
	DECLARE @E_ProductLineId uniqueidentifier
	DECLARE @M_DealerName NVARCHAR(200)
	DECLARE @M_Email NVARCHAR(200)
	DECLARE @M_MailCode NVARCHAR(200)
	DECLARE @M_ApplyNo NVARCHAR(200)

	DECLARE @E_DealerName NVARCHAR(200)
	DECLARE @E_ApplyNo NVARCHAR(200)
	DECLARE @E_ApplyDate NVARCHAR(200)
	DECLARE @E_OrderNo NVARCHAR(200)
	DECLARE @E_OrderDate NVARCHAR(200)
	DECLARE @E_ReceiptDate NVARCHAR(200)
	DECLARE @E_UPN NVARCHAR(200)
	DECLARE @E_LotNumber NVARCHAR(200)
	DECLARE @E_Qty NVARCHAR(200)
	DECLARE @E_QrCode NVARCHAR(200)
		
	DECLARE EmailCursor CURSOR FOR SELECT DealerId,ProductLineId,DealerName,Email,MailCode FROM #EmailTemp GROUP BY DealerId,ProductLineId,DealerName,Email,MailCode

	OPEN EmailCursor 
		FETCH NEXT FROM EmailCursor INTO @E_DealerId,@E_ProductLineId,@M_DealerName,@M_Email,@M_MailCode
		WHILE @@FETCH_STATUS = 0
			BEGIN
				
				--清空
				SET @EailMessage = N'<table border=''1px'' cellspacing=''0'' cellpadding=''1'' style=''paddin:5px;'' ><tr style=''background-color: #dedede;''><td>经销商</td><td>申请单号</td><td>申请日期</td><td>订单号</td><td>订单日期</td><td>发货日期</td><td>UPN</td><td>批次号</td><td>二维码</td><td>数量</td></tr>'
				DECLARE RecordCursor CURSOR FOR SELECT ISNULL(DealerName,''),ISNULL(ApplyNo,''),ISNULL(ApplyDate,''),ISNULL(OrderNo,''),ISNULL(OrderDate,''),ISNULL(ReceiptDate,''),ISNULL(UPN,''),ISNULL(LotNumber,''),ISNULL(Qty,'') FROM #EmailTemp WHERE DealerId = @E_DealerId

				OPEN RecordCursor
					FETCH NEXT FROM RecordCursor INTO @E_DealerName,@E_ApplyNo,@E_ApplyDate,@E_OrderNo,@E_OrderDate,@E_ReceiptDate,@E_UPN,@E_LotNumber,@E_Qty
					WHILE @@FETCH_STATUS = 0
						BEGIN

							SET @E_QrCode = CASE WHEN charindex('@@',@E_LotNumber,0) > 0 THEN substring(@E_LotNumber,CHARINDEX('@@',@E_LotNumber,0)+2,LEN(@E_LotNumber)-CHARINDEX('@@',@E_LotNumber,0)) ELSE 'NoQr' END 					
							SET @E_LotNumber = CASE WHEN charindex('@@',@E_LotNumber,0) > 0 THEN substring(@E_LotNumber,1,charindex('@@',@E_LotNumber)-1) ELSE @E_LotNumber END 
		
							SET @EailMessage = @EailMessage + '<tr><td>'+@E_DealerName+'</td><td>'+@E_ApplyNo+'</td><td>'+@E_ApplyDate+'</td><td>'+@E_OrderNo+'</td><td>'+@E_OrderDate+'</td><td>'+@E_ReceiptDate+'</td><td>'+@E_UPN+'</td><td>'+@E_LotNumber+'</td><td>'+@E_QrCode+'</td><td>'+@E_Qty+'</td></tr>'

							FETCH NEXT FROM RecordCursor INTO @E_DealerName,@E_ApplyNo,@E_ApplyDate,@E_OrderNo,@E_OrderDate,@E_ReceiptDate,@E_UPN,@E_LotNumber,@E_Qty
						END
					CLOSE RecordCursor
					DEALLOCATE RecordCursor

				SET @EailMessage = @EailMessage+'</table>'

				INSERT INTO #EmailTemp_2
				VALUES (@E_DealerId,@M_DealerName,@E_ProductLineId,@M_Email,@M_MailCode,@EailMessage)

				FETCH NEXT FROM EmailCursor INTO @E_DealerId,@E_ProductLineId,@M_DealerName,@M_Email,@M_MailCode
			END
		CLOSE EmailCursor
		DEALLOCATE EmailCursor
		
	
	SET @EailMessage = ''
		
	DECLARE SaleEmailCursor CURSOR FOR SELECT DealerId,ProductLineId,DealerName,ApplyNo,Email,MailCode FROM #EmailTemp GROUP BY DealerId,ProductLineId,DealerName,ApplyNo,Email,MailCode
	
	OPEN SaleEmailCursor 
		FETCH NEXT FROM SaleEmailCursor INTO @E_DealerId,@E_ProductLineId,@M_DealerName,@M_ApplyNo,@M_Email,@M_MailCode
		WHILE @@FETCH_STATUS = 0
			BEGIN
				
				--清空
				SET @EailMessage = N'<table border=''1px'' cellspacing=''0'' cellpadding=''1'' style=''paddin:5px;'' ><tr style=''background-color: #dedede;''><td>经销商</td><td>申请单号</td><td>申请日期</td><td>订单号</td><td>订单日期</td><td>发货日期</td><td>UPN</td><td>批次号</td><td>二维码</td><td>数量</td></tr>'
				DECLARE SaleRecordCursor CURSOR FOR SELECT ISNULL(DealerName,''),ISNULL(ApplyNo,''),ISNULL(ApplyDate,''),ISNULL(OrderNo,''),ISNULL(OrderDate,''),ISNULL(ReceiptDate,''),ISNULL(UPN,''),ISNULL(LotNumber,''),ISNULL(Qty,'') FROM #EmailTemp WHERE DealerId = @E_DealerId

				OPEN SaleRecordCursor
					FETCH NEXT FROM SaleRecordCursor INTO @E_DealerName,@E_ApplyNo,@E_ApplyDate,@E_OrderNo,@E_OrderDate,@E_ReceiptDate,@E_UPN,@E_LotNumber,@E_Qty
					WHILE @@FETCH_STATUS = 0
						BEGIN

							SET @E_QrCode = CASE WHEN charindex('@@',@E_LotNumber,0) > 0 THEN substring(@E_LotNumber,CHARINDEX('@@',@E_LotNumber,0)+2,LEN(@E_LotNumber)-CHARINDEX('@@',@E_LotNumber,0)) ELSE 'NoQr' END 					
							SET @E_LotNumber = CASE WHEN charindex('@@',@E_LotNumber,0) > 0 THEN substring(@E_LotNumber,1,charindex('@@',@E_LotNumber)-1) ELSE @E_LotNumber END 
		
							SET @EailMessage = @EailMessage + '<tr><td>'+@E_DealerName+'</td><td>'+@E_ApplyNo+'</td><td>'+@E_ApplyDate+'</td><td>'+@E_OrderNo+'</td><td>'+@E_OrderDate+'</td><td>'+@E_ReceiptDate+'</td><td>'+@E_UPN+'</td><td>'+@E_LotNumber+'</td><td>'+@E_QrCode+'</td><td>'+@E_Qty+'</td></tr>'

							FETCH NEXT FROM SaleRecordCursor INTO @E_DealerName,@E_ApplyNo,@E_ApplyDate,@E_OrderNo,@E_OrderDate,@E_ReceiptDate,@E_UPN,@E_LotNumber,@E_Qty
						END
					CLOSE SaleRecordCursor
					DEALLOCATE SaleRecordCursor

				SET @EailMessage = @EailMessage+'</table>'

				INSERT INTO #EmailTemp_3
				VALUES (@E_DealerId,@M_DealerName,@M_ApplyNo,'',NULL,@M_MailCode,@EailMessage)

				FETCH NEXT FROM SaleEmailCursor INTO @E_DealerId,@E_ProductLineId,@M_DealerName,@M_ApplyNo,@M_Email,@M_MailCode
			END
		CLOSE SaleEmailCursor
		DEALLOCATE SaleEmailCursor
	
	UPDATE #EmailTemp_3 SET SaleName = CAH_SalesName,SaleEmail = CAH_SalesEmail FROM ConsignmentApplyHeader WHERE CAH_OrderNo = ApplyNo
	
	
	--寄售产品过期前5天的邮件提醒不用给CS
	INSERT INTO #EmailTemp_2
	SELECT DealerId,DealerName,ProductLineId,MDA_MailAddress,MailCode,MailMessage FROM #EmailTemp_2 INNER JOIN MailDeliveryAddress
	ON MDA_ProductLineID = ProductLineId 
	WHERE MDA_MailType = 'Order' AND MDA_MailTo = 'EAI' AND MDA_ActiveFlag = 1
	AND MailCode IN ('EMAIL_CONSIGNMENT_NOW_ALTER','EMAIL_CONSIGNMENT_AFTER_ALTER')
	GROUP BY DealerId,DealerName,ProductLineId,MDA_MailAddress,MailCode,MailMessage
	
	--经销商邮件
	INSERT INTO MailMessageQueue
	SELECT NEWID(),'email','',Email,MMT_Subject,REPLACE(REPLACE(MMT_Body,'{#DealerName}',DealerName),'{#ProductList}',MailMessage),'Waiting',GETDATE(),null FROM #EmailTemp_2 
	INNER JOIN MailMessageTemplate ON MMT_Code = MailCode
	WHERE Email IS NOT NULL AND Email <> ''
	
	--销售邮件
	INSERT INTO MailMessageQueue
	SELECT NEWID(),'email','',SaleEmail,MMT_Subject,REPLACE(REPLACE(MMT_Body,'{#DealerName}',DealerName),'{#ProductList}',MailMessage),'Waiting',GETDATE(),null FROM #EmailTemp_3
	INNER JOIN MailMessageTemplate ON MMT_Code = MailCode
	WHERE SaleEmail IS NOT NULL AND SaleEmail <> ''
	

	--DELETE FROM MailMessageTemplate WHERE MMT_Code = 'EMAIL_CONSIGNMENT_BEFORE_ALTER'
	--DELETE FROM MailMessageTemplate WHERE MMT_Code = 'EMAIL_CONSIGNMENT_NOW_ALTER'
	--DELETE FROM MailMessageTemplate WHERE MMT_Code = 'EMAIL_CONSIGNMENT_AFTER_ALTER'

	--INSERT INTO MailMessageTemplate
	--SELECT NEWID(),'EMAIL_CONSIGNMENT_BEFORE_ALTER','短期寄售产品过期提醒','尊敬的经销商伙伴：{#DealerName}您好！<br><br>贵司申请的短期寄售产品即将过期，请尽快在DMS中提交销售信息或者申请退货，避免因此而产生的滞纳金。<br>{#ProductList}<br>http://bscdealer.cn <br><br>波士顿科学<br>------------------------------------------------------------------ <br>此邮件为系统自动发送，请勿回复！谢谢！'

	--INSERT INTO MailMessageTemplate
	--SELECT NEWID(),'EMAIL_CONSIGNMENT_NOW_ALTER','短期寄售产品过期提醒','尊敬的经销商伙伴：{#DealerName}您好！<br><br>贵司申请的短期寄售产品今日过期，请在DMS中提交销售信息或者申请退货，避免因此而产生的滞纳金。<br>{#ProductList}<br>http://bscdealer.cn <br><br>波士顿科学<br>------------------------------------------------------------------ <br>此邮件为系统自动发送，请勿回复！谢谢！'

	--INSERT INTO MailMessageTemplate
	--SELECT NEWID(),'EMAIL_CONSIGNMENT_AFTER_ALTER','短期寄售产品过期提醒','尊敬的经销商伙伴：{#DealerName}您好！<br><br>贵司申请的短期寄售产品已经过期。<br>{#ProductList}<br>http://bscdealer.cn <br><br>波士顿科学<br>------------------------------------------------------------------ <br>此邮件为系统自动发送，请勿回复！谢谢！'


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


