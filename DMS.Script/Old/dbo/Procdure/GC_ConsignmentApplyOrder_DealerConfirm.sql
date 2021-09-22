DROP Procedure [dbo].[GC_ConsignmentApplyOrder_DealerConfirm]
GO


/**
	短期寄售申请——转移。
	在EWF审批通过后，需要经销商做确认收货，从而生成收货单。
	收货单中的内容为这张短期寄售申请中的明细信息（必须包含UPN\批次号\二维码）
**/
CREATE Procedure [dbo].[GC_ConsignmentApplyOrder_DealerConfirm]
	@CAH_ID uniqueidentifier,
	@UserId uniqueidentifier,
	@RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
AS
    DECLARE @RecordCount INTEGER
		
SET NOCOUNT ON

BEGIN TRY
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	CREATE TABLE #TEMP
	(
		PoHeadId UNIQUEIDENTIFIER,
		PoLineId UNIQUEIDENTIFIER,
		PoLotId UNIQUEIDENTIFIER,
		DealerId UNIQUEIDENTIFIER,
		WarehouseId UNIQUEIDENTIFIER,
		PoOrderNo NVARCHAR(200),
		OrderId UNIQUEIDENTIFIER,
		OrderNo NVARCHAR(200),
		ProductLineId UNIQUEIDENTIFIER,
		CfnId UNIQUEIDENTIFIER,
		PmaId UNIQUEIDENTIFIER,
		LotNumber NVARCHAR(200),
		ExpiredDate DATETIME,
		Qty Decimal(18,6),
		Uom NVARCHAR(200),
		ConvertFactory Decimal(18,6),
		Price Decimal(18,6)
	)

	CREATE TABLE #POReceiptHeader_TEMP
	(
		[PRH_ID] [uniqueidentifier] NOT NULL,
		[PRH_PONumber] [nvarchar](30) NULL,
		[PRH_SAPShipmentID] [nvarchar](50) NULL,
		[PRH_Dealer_DMA_ID] [uniqueidentifier] NOT NULL,
		[PRH_ReceiptDate] [datetime] NULL,
		[PRH_SAPShipmentDate] [datetime] NULL,
		[PRH_Status] [nvarchar](50) NOT NULL,
		[PRH_Vendor_DMA_ID] [uniqueidentifier] NOT NULL,
		[PRH_Type] [nvarchar](50) NOT NULL,
		[PRH_ProductLine_BUM_ID] [uniqueidentifier] NULL,
		[PRH_PurchaseOrderNbr] [nvarchar](50) NULL,
		[PRH_Receipt_USR_UserID] [uniqueidentifier] NULL,
		[PRH_Carrier] [nvarchar](20) NULL,
		[PRH_TrackingNo] [nvarchar](100) NULL,
		[PRH_ShipType] [nvarchar](20) NULL,
		[PRH_Note] [nvarchar](20) NULL,
		[PRH_ArrivalDate] [datetime] NULL,
		[PRH_DeliveryDate] [datetime] NULL,
		[PRH_SapDeliveryDate] [datetime] NULL,
		[PRH_WHM_ID] [uniqueidentifier] NULL,
		[PRH_FromWHM_ID] [uniqueidentifier] NULL
	)

	CREATE TABLE #POReceipt_TEMP
	(
		[POR_ID] [uniqueidentifier] NOT NULL,
		[POR_SAPSOLine] [nvarchar](30) NULL,
		[POR_SAPSOID] [nvarchar](30) NULL,
		[POR_SAP_PMA_ID] [uniqueidentifier] NOT NULL,
		[POR_ReceiptQty] [float] NOT NULL,
		[POR_UnitPrice] [float] NULL,
		[POR_ConvertFactor] [float] NULL,
		[POR_PRH_ID] [uniqueidentifier] NOT NULL,
		[POR_ChangedUnitProduct_PMA_ID] [uniqueidentifier] NULL,
		[POR_LineNbr] [int] NULL
	)

	CREATE TABLE #POReceiptLot_TEMP
	(
		[PRL_POR_ID] [uniqueidentifier] NOT NULL,
		[PRL_ID] [uniqueidentifier] NOT NULL,
		[PRL_LotNumber] [nvarchar](50) NOT NULL,
		[PRL_ReceiptQty] [float] NOT NULL,
		[PRL_ExpiredDate] [datetime] NULL,
		[PRL_WHM_ID] [uniqueidentifier] NULL,
		[PRL_UnitPrice] [decimal](18, 2) NULL,
		[PRL_IsCalRebate] [bit] NULL
	)

	DECLARE @POReceiptNo NVARCHAR(100)
	DECLARE @PurchaseOrderNo NVARCHAR(100)
	DECLARE @BuName NVARCHAR(100)
	DECLARE @PurchaseOrderId uniqueidentifier
	DECLARE @WarehouseId uniqueidentifier
	DECLARE @ProductLineId uniqueidentifier
	DECLARE @DealerId uniqueidentifier
	DECLARE @Vender_DMA_ID uniqueidentifier
	
	SET @Vender_DMA_ID = 'FB62D945-C9D7-4B0F-8D26-4672D2C728B7'

	SELECT @PurchaseOrderNo = CAH_POH_OrderNo FROM ConsignmentApplyHeader 
	WHERE CAH_ID = @CAH_ID AND CAH_OrderStatus = 'Approved' AND CAH_ConsignmentFrom = 'Otherdealers'
	
	IF @PurchaseOrderNo IS NOT NULL
		BEGIN
			SELECT @DealerId = POH_DMA_ID,@PurchaseOrderId = POH_ID,@ProductLineId = POH_ProductLine_BUM_ID,@WarehouseId = POH_WHM_ID 
			FROM PurchaseOrderHeader 
			WHERE POH_OrderNo = @PurchaseOrderNo AND POH_CreateType = 'Manual' AND POH_OrderType IN ('Consignment','ZTKB')
	
			INSERT INTO #TEMP (DealerId,WarehouseId,OrderId,OrderNo,ProductLineId,CfnId,PmaId,LotNumber,Qty,Uom,Price)
			SELECT POH_DMA_ID,POH_WHM_ID,POH_ID,POH_OrderNo,POH_ProductLine_BUM_ID,POD_CFN_ID,PMA_ID,
			CASE WHEN CHARINDEX('@@',POD_LotNumber) > 0 THEN POD_LotNumber ELSE POD_LotNumber+'@@'+POD_QRCode END AS POD_LotNumber,
			POD_RequiredQty,POD_UOM,POD_CFN_Price 
			FROM PurchaseOrderHeader 
				INNER JOIN PurchaseOrderDetail ON POH_ID = POD_POH_ID
				INNER JOIN Product ON PMA_CFN_ID = POD_CFN_ID
				WHERE POH_OrderNo = @PurchaseOrderNo AND POH_CreateType = 'Manual' AND POH_OrderType IN ('Consignment','ZTKB')

			--获取BU信息
			SELECT @BuName = ATTRIBUTE_NAME FROM Lafite_ATTRIBUTE(nolock)
			WHERE Id IN (SELECT RootID FROM Cache_OrganizationUnits(nolock) 
									WHERE AttributeID = CONVERT (VARCHAR (36),@ProductLineId)
						)
				AND ATTRIBUTE_TYPE = 'BU'
	
			--得到DMS收货单号
			EXEC [GC_GetNextAutoNumber] @DealerId,'Next_POReceiptNbr',@BuName,@POReceiptNo OUTPUT

			UPDATE #TEMP SET PoOrderNo = @POReceiptNo

			--更新有效期
			UPDATE #TEMP SET ExpiredDate = LTM_ExpiredDate FROM LotMaster WHERE LTM_LotNumber = LotNumber

			--收货单主表
			INSERT INTO #POReceiptHeader_TEMP
			SELECT NEWID(),PoOrderNo,PoOrderNo,DealerId,NULL,GETDATE(),'Waiting',@Vender_DMA_ID,'PurchaseOrder',ProductLineId,OrderNo,NULL,NULL,NULL,'Normal',NULL,NULL,NULL,GETDATE(),WarehouseId,NULL
			FROM #TEMP
			GROUP BY PoOrderNo,PoOrderNo,DealerId,ProductLineId,OrderNo,WarehouseId

			UPDATE #TEMP SET PoHeadId = PRH_ID FROM #POReceiptHeader_TEMP WHERE PRH_PONumber = PoOrderNo

			--收货单Line表
			INSERT INTO #POReceipt_TEMP
			SELECT NEWID(),NULL,NULL,PmaId,SUM(Qty),NULL,NULL,PoHeadId,NULL,ROW_NUMBER () OVER (PARTITION BY PoHeadId ORDER BY Pmaid) FROM #TEMP
			GROUP BY PoHeadId,PmaId
	
			UPDATE #TEMP SET PoLineId = POR_ID FROM #POReceipt_TEMP WHERE POR_PRH_ID = PoHeadId AND POR_SAP_PMA_ID = PmaId

			--收货单Lot表
			INSERT INTO #POReceiptLot_TEMP
			SELECT PoLineId,NEWID(),LotNumber,Qty,ExpiredDate,WarehouseId,NULL,NULL FROM #TEMP
		END
	ELSE 
		BEGIN
			SET @RtnMsg = '未找到短期寄售申请单'
		END


BEGIN TRAN
	
	SELECT @RecordCount = COUNT(1) FROM #TEMP

	IF @RecordCount = 0
		BEGIN
			SET @RtnMsg = '未找到短期寄售申请单'
		END
	ELSE IF EXISTS (SELECT 1 FROM POReceiptHeader A WHERE EXISTS (SELECT 1 FROM #POReceiptHeader_TEMP B WHERE A.PRH_PurchaseOrderNbr = B.PRH_PurchaseOrderNbr))
		BEGIN
			SET @RtnMsg = '短期寄售申请单已经生成了对应的收货单！'
		END
	ELSE 
		BEGIN
			
			INSERT INTO POReceiptHeader
			   (PRH_ID
			   ,PRH_PONumber
			   ,PRH_SAPShipmentID
			   ,PRH_Dealer_DMA_ID
			   ,PRH_ReceiptDate
			   ,PRH_SAPShipmentDate
			   ,PRH_Status
			   ,PRH_Vendor_DMA_ID
			   ,PRH_Type
			   ,PRH_ProductLine_BUM_ID
			   ,PRH_PurchaseOrderNbr
			   ,PRH_Receipt_USR_UserID
			   ,PRH_Carrier
			   ,PRH_TrackingNo
			   ,PRH_ShipType
			   ,PRH_Note
			   ,PRH_ArrivalDate
			   ,PRH_DeliveryDate
			   ,PRH_SapDeliveryDate
			   ,PRH_WHM_ID
			   ,PRH_FromWHM_ID)
			SELECT PRH_ID
			   ,PRH_PONumber
			   ,PRH_SAPShipmentID
			   ,PRH_Dealer_DMA_ID
			   ,PRH_ReceiptDate
			   ,PRH_SAPShipmentDate
			   ,PRH_Status
			   ,PRH_Vendor_DMA_ID
			   ,PRH_Type
			   ,PRH_ProductLine_BUM_ID
			   ,PRH_PurchaseOrderNbr
			   ,PRH_Receipt_USR_UserID
			   ,PRH_Carrier
			   ,PRH_TrackingNo
			   ,PRH_ShipType
			   ,PRH_Note
			   ,PRH_ArrivalDate
			   ,PRH_DeliveryDate
			   ,PRH_SapDeliveryDate
			   ,PRH_WHM_ID
			   ,PRH_FromWHM_ID 
			FROM #POReceiptHeader_TEMP

			INSERT INTO POReceipt
			   (POR_ID
			   ,POR_SAPSOLine
			   ,POR_SAPSOID
			   ,POR_SAP_PMA_ID
			   ,POR_ReceiptQty
			   ,POR_UnitPrice
			   ,POR_ConvertFactor
			   ,POR_PRH_ID
			   ,POR_ChangedUnitProduct_PMA_ID
			   ,POR_LineNbr)
			SELECT POR_ID
			   ,POR_SAPSOLine
			   ,POR_SAPSOID
			   ,POR_SAP_PMA_ID
			   ,POR_ReceiptQty
			   ,POR_UnitPrice
			   ,POR_ConvertFactor
			   ,POR_PRH_ID
			   ,POR_ChangedUnitProduct_PMA_ID
			   ,POR_LineNbr
			FROM #POReceipt_TEMP

			INSERT INTO POReceiptLot
			   (PRL_POR_ID
			   ,PRL_ID
			   ,PRL_LotNumber
			   ,PRL_ReceiptQty
			   ,PRL_ExpiredDate
			   ,PRL_WHM_ID
			   ,PRL_UnitPrice
			   ,PRL_IsCalRebate)
			SELECT PRL_POR_ID
			   ,PRL_ID
			   ,PRL_LotNumber
			   ,PRL_ReceiptQty
			   ,PRL_ExpiredDate
			   ,PRL_WHM_ID
			   ,PRL_UnitPrice
			   ,PRL_IsCalRebate
			FROM #POReceiptLot_TEMP

			INSERT INTO PurchaseOrderLog
			SELECT NEWID(),PRH_ID,@UserId,GETDATE(),'Delivery','短期寄售产品转移确认' FROM #POReceiptHeader_TEMP

			UPDATE PurchaseOrderHeader SET POH_OrderStatus = 'Completed' FROM #POReceiptHeader_TEMP 
			WHERE PRH_PurchaseOrderNbr = POH_OrderNo
			AND POH_CreateType = 'Manual' 
			AND POH_OrderType IN ('Consignment','ZTKB')

			UPDATE PurchaseOrderDetail SET POD_ReceiptQty = POD_RequiredQty FROM #POReceiptHeader_TEMP 
			INNER JOIN PurchaseOrderHeader ON PRH_PurchaseOrderNbr = POH_OrderNo
			WHERE POH_CreateType = 'Manual' 
			AND POH_OrderType IN ('Consignment','ZTKB')
			AND POD_POH_ID = POH_ID

			INSERT INTO PurchaseOrderLog
			SELECT NEWID(),POH_ID,@UserId,GETDATE(),'Delivery','短期寄售产品转移确认' FROM PurchaseOrderHeader
			WHERE POH_CreateType = 'Manual' 
			AND POH_OrderType IN ('Consignment','ZTKB')
			AND EXISTS (SELECT 1 FROM #POReceiptHeader_TEMP WHERE PRH_PurchaseOrderNbr = POH_OrderNo)
			
			INSERT INTO DeliveryInterface
			([DI_ID]
			   ,[DI_BatchNbr]
			   ,[DI_RecordNbr]
			   ,[DI_SapDeliveryNo]
			   ,[DI_Status]
			   ,[DI_ProcessType]
			   ,[DI_FileName]
			   ,[DI_CreateUser]
			   ,[DI_CreateDate]
			   ,[DI_UpdateUser]
			   ,[DI_UpdateDate]
			   ,[DI_ClientID]
			)
			SELECT NEWID(),'','',PRH_SAPShipmentID,'Pending','System','','00000000-0000-0000-0000-000000000000',GETDATE(),NULL,NULL,CLT_ID FROM #POReceiptHeader_TEMP
			INNER JOIN Client ON PRH_Dealer_DMA_ID = CLT_Corp_Id
			WHERE CLT_ActiveFlag = 1
			AND CLT_DeletedFlag = 0
			
		END

	IF LEN(@RtnMsg) > 0
		SET @RtnVal = 'Error'
	ELSE 
		BEGIN
			--拼接警告信息
			SET @RtnVal = 'Success'
			SET @RtnMsg = '' 
		END
		
COMMIT TRAN

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
	SET @RtnMsg = @vError
    return -1
    
END CATCH

GO


