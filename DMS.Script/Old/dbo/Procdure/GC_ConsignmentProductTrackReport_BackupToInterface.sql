DROP PROCEDURE [dbo].[GC_ConsignmentProductTrackReport_BackupToInterface]	
GO

CREATE PROCEDURE [dbo].[GC_ConsignmentProductTrackReport_BackupToInterface]	
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(2000)  OUTPUT
AS
SET NOCOUNT ON
BEGIN TRY
	DECLARE @UserId uniqueidentifier
	DECLARE @ProductLineId uniqueidentifier
	DECLARE @StartDate nvarchar(50)
	DECLARE @EndDate nvarchar(50)
	DECLARE @Upn nvarchar(10)
	DECLARE @LotNumber nvarchar(10)
	DECLARE @SysUserId uniqueidentifier
	DECLARE @DealerId uniqueidentifier
	DECLARE @UserType nvarchar(20)

  SET @UserId = 'c763e69b-616f-4246-8480-9df40126057c'
	SELECT @UserType = IDENTITY_TYPE ,@DealerId = Corp_ID FROM Lafite_IDENTITY WHERE Id = @UserId
  SET @StartDate = '2016-01-01'
  SELECT @EndDate = Convert(nvarchar(10),getdate(),120)
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
		DelayNumber INT,
		ExpiredDate DATETIME
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
		ClearBorrowDate DATETIME,
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
		WHERE CONVERT(NVARCHAR(20),CAH_SubmitDate,112) >= @StartDate
		AND CONVERT(NVARCHAR(20),CAH_SubmitDate,112) <=@EndDate
		AND ((@ProductLineId IS NULL) OR CAH_ProductLine_Id = @ProductLineId)
		AND (
				(@UserType = 'User' AND EXISTS
				   ( 
						  SELECT 1 FROM Cache_OrganizationUnits OU, Lafite_IDENTITY_MAP IM , Cache_SalesOfDealer SD
						  WHERE OU.AttributeId = IM.MAP_ID AND IM.MAP_TYPE='Organization' AND convert(varchar(36),SD.SalesID) = IM.IDENTITY_ID
								  AND SD.DealerID = CAH_DMA_ID AND SD.BUM_ID = CAH_ProductLine_Id
								  AND OU.AttributeId<>OU.RootId
								  AND OU.RootID IN (select MAP_ID from Lafite_IDENTITY_MAP OM where OM.MAP_TYPE='Organization'  AND OM.IDENTITY_ID = @UserId)
					)
				OR
					EXISTS
				   ( 
						  SELECT 1 from Cache_SalesOfDealer SD 
						  WHERE SD.SalesID = @UserId
								 AND SD.DealerID = CAH_DMA_ID AND SD.BUM_ID = CAH_ProductLine_Id
				   )
				)
				OR 
				(@UserType = 'Dealer' AND (CAH_DMA_ID = @DealerId OR @DealerId = 'FB62D945-C9D7-4B0F-8D26-4672D2C728B7'))
			)

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
			,PRL_ExpiredDate AS ExpiredDate
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
	
	--����ͬ�Ĳֿ��У���ͬ�Ĳ�Ʒ�ͺ���ͬ�����κţ�����һ����¼
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

	--�˻������������̵��˻����ݣ�IAL_PRH_ID��Ŷ��ڼ������뵥������
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
			WHERE EXISTS(SELECT 1 FROM #TEMP_1 WHERE CahId = IAL_PRH_ID)
				AND IAH_Reason = 'Transfer'
				AND IAH_Status = 'Accept'
				AND IAL_PRH_ID IS NOT NULL 
				AND IAL_DMA_ID IS NOT NULL
	
	--�˻���BSC���˻����ݣ�IAL_PRH_ID��ŷ�����������
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
	SELECT (SELECT DISTINCT CahId FROM #TEMP_1 INNER JOIN POReceiptHeader ON PRH_PurchaseOrderNbr LIKE '%' + PurchaseNo + '%'
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
				
	--�õ��������ݣ����ݶ��ڼ������뵥�ţ�
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
			,ClearBorrowDate
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
							--AND POD_ShipmentNbr = SPH_ShipmentNbr 
							AND (POD_LotNumber +'@@' + ISNULL(POD_QRCode,'NoQR')) = LTM_LotNumber
			WHERE SPH_Status = 'Complete'
				AND SLT_CAH_ID IS NOT NULL 
				AND SPH_Dealer_DMA_ID = DealerId
				AND DMA_DealerType = 'T1'
	
	--�õ���������(���ݶ�ά��)
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
			,ClearBorrowDate
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
							--AND POD_ShipmentNbr = SPH_ShipmentNbr 
							AND (POD_LotNumber +'@@' + ISNULL(POD_QRCode,'NoQR')) = LTM_LotNumber
			WHERE SPH_Status = 'Complete'
				AND SLT_CAH_ID IS NULL 
				AND DMA_DealerType = 'T1'
				AND SPH_Dealer_DMA_ID = DealerId
		
	--�õ���������(ƽ̨������T2����ָ�����Ŷ���)
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
			,ClearBorrowDate
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
	
	--�õ���������(ƽ̨������T2����ָ�����Ŷ���)
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
			,ClearBorrowDate
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
	  
  --�ϲ����۵���¼
	SELECT T.* INTO #ShipmentTemp FROM 
	(
	SELECT B.ShipmentLtmId,B.ShipmentDealerId,B.CahId AS ShipmentCahId,LEFT(ShipmentNos,LEN(ShipmentNos)-1) AS ShipmentNos,
	LEFT(ShipmentDates,LEN(ShipmentDates)-1) AS ShipmentDates,LEFT(ShipmentSubmitDates,LEN(ShipmentSubmitDates)-1) AS ShipmentSubmitDates,
	ClearBorrowQty,ShipmentQty,
	CASE WHEN B.ClearBorrowNos = NULL OR LEN(B.ClearBorrowNos) = 0 THEN '' ELSE LEFT(B.ClearBorrowNos,LEN(B.ClearBorrowNos)-1) END AS ClearBorrowNos,
	CASE WHEN B.ClearBorrowDates = NULL OR LEN(B.ClearBorrowDates) = 0 THEN '' ELSE LEFT(B.ClearBorrowDates,LEN(B.ClearBorrowDates)-1) END AS ClearBorrowDate
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
	(SELECT CONVERT(NVARCHAR(100),A.ClearBorrowDate,120)+',' FROM #ShipmentTable 
	  WHERE ShipmentLtmId = A.ShipmentLtmId AND ShipmentDealerId = A.ShipmentDealerId AND CahId = A.CahId
	  FOR XML PATH('') ) AS ClearBorrowDates
	FROM #ShipmentTable A 
	GROUP BY ShipmentLtmId,ShipmentDealerId,CahId,ClearBorrowNo,ClearBorrowDate
	) B  
	) T

	--�ϲ��˻�����¼
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

	SELECT A.*,B.*,C.*,D.ATTRIBUTE_NAME,D.DESCRIPTION,E.*,F.*,(POReceiptQty-ISNULL(ClearBorrowQty,0)-ISNULL(ReturnQty,0)-ISNULL(ComplainQty,0)) AS Qty,ISNULL(ClearBorrowQty,0)/ApplyQty AS ValidQty,DATEDIFF(DAY,GETDATE(),DATEADD(DAY,5,ExpirationDate)) AS OverdueDays,G.Region,G.ParentUser 
	,(CASE WHEN POReceiptDeliveryDate>ExpiredDate THEN '' ELSE CAST(DATEDIFF(MONTH,POReceiptDeliveryDate,ExpiredDate) AS NVARCHAR(200))+'Mths' END) AS Aging
	,CASE WHEN CHARINDEX('@@',A.LotNumber,0) > 0 THEN SUBSTRING(A.LotNumber,CHARINDEX('@@',A.LotNumber,0)+2,LEN(A.LotNumber)-CHARINDEX('@@',A.LotNumber,0)) ELSE 'NoQR' END AS CQRCode
	,CASE WHEN CHARINDEX('@@',A.LotNumber,0) > 0 THEN SUBSTRING(A.LotNumber,1,CHARINDEX('@@',A.LotNumber)-1) ELSE A.LotNumber END CLotNumber
	INTO #TEMP_2
	FROM #TEMP_1 A	
	INNER JOIN ConsignmentApplyHeader B ON CAH_ID = CahId
	INNER JOIN DealerMaster C ON DMA_ID = CAH_DMA_ID
	INNER JOIN VIEW_ProductLine D ON D.Id = CAH_ProductLine_Id
	LEFT JOIN #ShipmentTemp E ON LtmId = ShipmentLtmId AND DealerId = E.ShipmentDealerId AND CahId = E.ShipmentCahId
	LEFT JOIN #ReturnTemp F ON LotId = ReturnLotId AND DealerId = F.ReturnDealerId  AND CahId = F.ReturnCahId
	LEFT JOIN interface.T_I_QV_SalesRep G ON G.Name = B.CAH_SalesName AND G.Email = B.CAH_SalesEmail
	WHERE (ISNULL(@Upn,'')='' OR A.CfnCode LIKE '%'+ @Upn +'%')
	AND (ISNULL(@LotNumber,'')='' OR A.LotNumber LIKE '%'+ @LotNumber +'%')
	
  Print 'TEST001'
  INSERT INTO [interface].[T_I_QV_ShortConsignmentTrackingReport](Id, CahId, CahOrderNo, DealerId, ProduceLineId, CahSubmitDate, CfnId, PmaId, CfnChineseName, CfnEnglishName, CfnCode, CfnCode2, CfnUom, PORCfnId, PORPmaId, PORCfnChineseName, PORCfnEnglishName, PORCfnCode, PORCfnCode2, PORCfnUom, LotId, LtmId, LotNumber, ApplyQty, TotalQty, PurchaseId, PurchaseNo, PurchaseDate, PurchaseQty, POReceiptId, POReceiptNo, POReceiptSapNo, POReceiptDeliveryDate, POReceiptDate, POReceiptQty, ExpirationDate, ConsignmentDay, DelayNumber, ExpiredDate, ComplainNo, ComplainBscNo, ComplainDate, ComplainStatus, ComplainQty, CAH_ID, CAH_DMA_ID, CAH_ProductLine_Id, CAH_CM_ID, CAH_CM_ConsignmentName, CAH_CM_ConsignmentDay, CAH_CM_DelayNumber, CAH_CM_StartDate, CAH_CM_EndDate, CAH_CM_Type, CAH_CM_Remark, CAH_CM_ReturnTime, CAH_CM_DailyFines, CAH_CM_LowestMargin, CAH_CM_TotalAmount, CAH_CA_AuthStartDate, CAH_CA_AuthEndDate, CAH_OrderNo, CAH_OrderType, CAH_OrderStatus, CAH_ConsignmentFrom, CAH_ConsignmentId, CAH_SubmitDate, CAH_ApproveUser, CAH_ApproveDate, CAH_CreateUser, CAH_CreateDate, CAH_UpdateUser, CAH_UpdateDate, CAH_SalesName, CAH_SalesEmail, CAH_SalesPhone, CAH_Consignee, CAH_ShipToAddress, CAH_ConsigneePhone, CAH_Hospital_Id, CAH_Hospital_Name, CAH_Reason, CAH_Remark, CAH_From_DMA_ID, CAH_CAH_ID, CAH_Delay_OrderNo, CAH_Delay_OrderType, CAH_Delay_OrderStatus, CAH_Delay_DelayTime, CAH_Delay_SubmitUser, CAH_Delay_SubmitDate, CAH_Delay_ApproveUser, CAH_Delay_ApproveDate, CAH_ConsignmentStartDate, CAH_ConsignmenEndDate, CAH_POH_OrderNo, CAH_IAH_ID, CAH_RDD, DMA_ID, DMA_ChineseName, DMA_ChineseShortName, DMA_EnglishName, DMA_EnglishShortName, DMA_Nbr, DMA_SAP_Code, DMA_DealerType, DMA_CompanyType, DMA_CompanyGrade, DMA_FirstContractDate, DMA_RegisteredAddress, DMA_Address, DMA_ShipToAddress, DMA_PostalCode, DMA_Phone, DMA_Fax, DMA_ContactPerson, DMA_Email, DMA_GeneralManager, DMA_LegalRep, DMA_RegisteredCapital, DMA_Bank, DMA_BankAccount, DMA_TaxNo, DMA_License, DMA_LicenseLimit, DMA_Province, DMA_City, DMA_District, DMA_SalesMode, DMA_Taxpayer, DMA_Finance, DMA_Finance_Phone, DMA_Finance_Email, DMA_Payment, DMA_ShipToContact_CON_ID, DMA_BillToContact_CON_ID, DMA_EstablishDate, DMA_SystemStartDate, DMA_Certification, DMA_HostCompanyFlag, DMA_DealerOrderNbrName, DMA_SAPInvoiceToEmail, DMA_LastModifiedDate, DMA_LastModifiedBy_USR_UserID, DMA_ActiveFlag, DMA_DeletedFlag, DMA_DealerAuthentication, DMA_Parent_DMA_ID, DMA_Reason, DMA_FormeRname, DMA_OfficeNb, DMA_Purchase, DMA_PurchasePhone, DMA_PurchaseEMail, DMA_SystemOperator, DMA_SystemOperatorPhone, DMA_SystemOperatorEMail, DMA_ThirdPartyUser, DMA_ThirdPartyPosition, DMA_ThirdPartyDate, DMA_Business2, DMA_BusinessPhone2, DMA_BusinessEMail2, DMA_Address2, DMA_Phone2, DMA_Email2, DMA_OfficeNb2, DMA_ContactRemark, DMA_BusinessOfficeNb1, DMA_BusinessOfficeNb2, DMA_Business1, DMA_BusinessPhone1, DMA_BusinessEMail1, ATTRIBUTE_NAME, [DESCRIPTION], ShipmentLtmId, ShipmentDealerId, ShipmentCahId, ShipmentNos, ShipmentDates, ShipmentSubmitDates, ClearBorrowQty, ShipmentQty, ClearBorrowNos, ClearBorrowDate, ReturnLotId, ReturnDealerId, ReturnCahId, ReturnNos, ReturnDates, ReturnApprovelDates, ReturnQty, Qty, ValidQty, OverdueDays, Region, ParentUser, Aging, CQRCode, CLotNumber, REV1, REV2, REV3, REV4)
	SELECT Id, CahId, CahOrderNo, DealerId, ProduceLineId, CahSubmitDate, CfnId, PmaId, CfnChineseName, CfnEnglishName, CfnCode, CfnCode2, CfnUom, PORCfnId, PORPmaId, PORCfnChineseName, PORCfnEnglishName, PORCfnCode, PORCfnCode2, PORCfnUom, LotId, LtmId, LotNumber, ApplyQty, TotalQty, PurchaseId, PurchaseNo, PurchaseDate, PurchaseQty, POReceiptId, POReceiptNo, POReceiptSapNo, POReceiptDeliveryDate, POReceiptDate, POReceiptQty, ExpirationDate, ConsignmentDay, DelayNumber, ExpiredDate, ComplainNo, ComplainBscNo, ComplainDate, ComplainStatus, ComplainQty, CAH_ID, CAH_DMA_ID, CAH_ProductLine_Id, CAH_CM_ID, CAH_CM_ConsignmentName, CAH_CM_ConsignmentDay, CAH_CM_DelayNumber, CAH_CM_StartDate, CAH_CM_EndDate, CAH_CM_Type, CAH_CM_Remark, CAH_CM_ReturnTime, CAH_CM_DailyFines, CAH_CM_LowestMargin, CAH_CM_TotalAmount, CAH_CA_AuthStartDate, CAH_CA_AuthEndDate, CAH_OrderNo, CAH_OrderType, CAH_OrderStatus, CAH_ConsignmentFrom, CAH_ConsignmentId, CAH_SubmitDate, CAH_ApproveUser, CAH_ApproveDate, CAH_CreateUser, CAH_CreateDate, CAH_UpdateUser, CAH_UpdateDate, CAH_SalesName, CAH_SalesEmail, CAH_SalesPhone, CAH_Consignee, CAH_ShipToAddress, CAH_ConsigneePhone, CAH_Hospital_Id, CAH_Hospital_Name, CAH_Reason, CAH_Remark, CAH_From_DMA_ID, CAH_CAH_ID, CAH_Delay_OrderNo, CAH_Delay_OrderType, CAH_Delay_OrderStatus, CAH_Delay_DelayTime, CAH_Delay_SubmitUser, CAH_Delay_SubmitDate, CAH_Delay_ApproveUser, CAH_Delay_ApproveDate, CAH_ConsignmentStartDate, CAH_ConsignmenEndDate, CAH_POH_OrderNo, CAH_IAH_ID, CAH_RDD, DMA_ID, DMA_ChineseName, DMA_ChineseShortName, DMA_EnglishName, DMA_EnglishShortName, DMA_Nbr, DMA_SAP_Code, DMA_DealerType, DMA_CompanyType, DMA_CompanyGrade, DMA_FirstContractDate, DMA_RegisteredAddress, DMA_Address, DMA_ShipToAddress, DMA_PostalCode, DMA_Phone, DMA_Fax, DMA_ContactPerson, DMA_Email, DMA_GeneralManager, DMA_LegalRep, DMA_RegisteredCapital, DMA_Bank, DMA_BankAccount, DMA_TaxNo, DMA_License, DMA_LicenseLimit, DMA_Province, DMA_City, DMA_District, DMA_SalesMode, DMA_Taxpayer, DMA_Finance, DMA_Finance_Phone, DMA_Finance_Email, DMA_Payment, DMA_ShipToContact_CON_ID, DMA_BillToContact_CON_ID, DMA_EstablishDate, DMA_SystemStartDate, DMA_Certification, DMA_HostCompanyFlag, DMA_DealerOrderNbrName, DMA_SAPInvoiceToEmail, DMA_LastModifiedDate, DMA_LastModifiedBy_USR_UserID, DMA_ActiveFlag, DMA_DeletedFlag, DMA_DealerAuthentication, DMA_Parent_DMA_ID, DMA_Reason, DMA_FormeRname, DMA_OfficeNb, DMA_Purchase, DMA_PurchasePhone, DMA_PurchaseEMail, DMA_SystemOperator, DMA_SystemOperatorPhone, DMA_SystemOperatorEMail, DMA_ThirdPartyUser, DMA_ThirdPartyPosition, DMA_ThirdPartyDate, DMA_Business2, DMA_BusinessPhone2, DMA_BusinessEMail2, DMA_Address2, DMA_Phone2, DMA_Email2, DMA_OfficeNb2, DMA_ContactRemark, DMA_BusinessOfficeNb1, DMA_BusinessOfficeNb2, DMA_Business1, DMA_BusinessPhone1, DMA_BusinessEMail1, ATTRIBUTE_NAME, [DESCRIPTION], ShipmentLtmId, ShipmentDealerId, ShipmentCahId, ShipmentNos, ShipmentDates, ShipmentSubmitDates, ClearBorrowQty, ShipmentQty, ClearBorrowNos, ClearBorrowDate, ReturnLotId, ReturnDealerId, ReturnCahId, ReturnNos, ReturnDates, ReturnApprovelDates, ReturnQty, Qty, ValidQty, OverdueDays, Region, ParentUser, Aging, CQRCode, CLotNumber
  ,CASE WHEN Qty <=0 THEN '' ELSE (CASE WHEN OverdueDays> = 0 THEN '' ELSE OverdueDays*-1 END) END AS REV1	--��������
	,CASE WHEN (CASE WHEN Qty <=0 THEN '' ELSE CASE WHEN OverdueDays> = 0 THEN '' ELSE OverdueDays*-1 END END) = '' THEN '��' ELSE '��' END AS REV2	--�Ƿ�����
	,CASE WHEN Qty <=0 THEN '��' ELSE '��' END AS REV3	--�Ƿ����
	,CASE WHEN GETDATE() > ExpiredDate AND Qty > 0 THEN '��' ELSE '��' END AS REV4	--�Ƿ����
	FROM #TEMP_2
	--ORDER BY CfnCode,CfnCode2,LotNumber,POReceiptDeliveryDate
  
  Print 'TEST003'

SET NOCOUNT OFF
RETURN 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    Print 'TEST002'    
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
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH
GO


