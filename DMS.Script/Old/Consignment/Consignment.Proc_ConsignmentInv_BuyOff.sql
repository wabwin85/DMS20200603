USE [BSC_DMS180515]
GO
/****** Object:  StoredProcedure [Consignment].[Proc_ConsignmentInv_BuyOff]    Script Date: 2018/9/28 10:42:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
1. 功能名称：业务过程中生成寄售买断单据
2. 更能描述：
	所有寄售销售业务都会生成寄售买断单据，具体业务如下：
	a. 寄售产品报销量:T1、T2、LP寄售产品报销量后系统自动生成寄售买断单据。LP、T1 单据自动审批完成状态。
		T2单据平台只能做价格确认，不能审批拒绝。
		单据类型为"销售出库"--完成寄售买断后单据创建后，需要调整销售单仓库类型到“经销商主仓库”。
		仓库转换 LP_Consignment、Consignment、Borrow ——》 DefaultWH
	ShipmentHeader [寄售产品销售单]、[借货产品销售单]  -->[SalesOut]

	b. 平台对波科寄售产品做销售发货：自动生成审批完成的寄售买断单据。
	POReceiptHeader LP->L2[采购入库] -->[SalesOut]
	[Borrow]

	c. 系统自动生成的强制寄售买断：强制寄售买断需要走Mflow审批。强制寄售买断按照现有规则生成。
	InventoryAdjuestHeader	--> [ForceCTOS]

	
3. 参数描述：
	@BillType 功能类型：（销售单，平台寄售发货，强制寄售买断）
	@BillNo 功能单据编号
	@RtnVal 执行状态：Success、Failure
	@RtnMsg 错误描述
*/
ALTER PROCEDURE [Consignment].[Proc_ConsignmentInv_BuyOff](
    @BillType NVARCHAR(100)-- （寄售销售单买断：Shipment_Consignment、平台寄售发货：POReceipt_Consignment、寄售买断：Purchase_Consignment）
    ,@BillNo  NVARCHAR(100)
    ,@RtnVal NVARCHAR(20) OUTPUT
	,@RtnMsg NVARCHAR(1000) OUTPUT
)
AS
SET NOCOUNT ON

BEGIN TRY


	SET @RtnVal = 'Success';
	SET @RtnMsg = '';
	
	--经销商ID
	DECLARE @DMA_ID UNIQUEIDENTIFIER;
	--产品线ID
	DECLARE @PRODUCTLINE_ID UNIQUEIDENTIFIER;
	--BU ID
	DECLARE @BU_NAME NVARCHAR(20);
	--NUMBER SETTING
	DECLARE @NUMBER_SETTING NVARCHAR(60);
	--Number
	DECLARE @NEXT_NUMBER NVARCHAR(50);
	DECLARE @IAH_ID UNIQUEIDENTIFIER;
	DECLARE @SPH_ID UNIQUEIDENTIFIER;
	DECLARE @PRH_ID UNIQUEIDENTIFIER;
	DECLARE @BUSINESS_NO NVARCHAR(50);
	DECLARE @REVERSE_IAH_ID UNIQUEIDENTIFIER;
	DECLARE @OPERATION_USER UNIQUEIDENTIFIER;
	DECLARE @OPERATION_TIME DATETIME;
	DECLARE @DEFAULT_WAREHOURE_ID UNIQUEIDENTIFIER;
	DECLARE @WAREHOUSE_TYPE NVARCHAR(50);


	--创建【寄售买断单据】主键
	SET @IAH_ID = NEWID();

	SET @NUMBER_SETTING = 'Next_ConsignToSellNbr';

	SET @OPERATION_USER = '00000000-0000-0000-0000-000000000000';

	SET @OPERATION_TIME = GETDATE();

	SET @BUSINESS_NO = ISNULL(@BillNo,'');
		
	--1、寄售销售单买断
	--根据【销售单号】找到销售单号，生成对应的【寄售买断单据】，需要改变原始【销售单】的仓库、库存、批次信息
	IF @BillType = 'Shipment_Consignment'
	BEGIN

		SELECT @DMA_ID = SPH_Dealer_DMA_ID 
			,@PRODUCTLINE_ID = SPH_ProductLine_BUM_ID 
			,@SPH_ID = SPH_ID 
			FROM ShipmentHeader 
			WHERE SPH_ShipmentNbr = @BUSINESS_NO 
			AND SPH_Type IN ('Borrow','Consignment')

		--判断【销售出库单】是否存在
		IF @SPH_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '销售出库单不存在！'	

			RETURN;
			
		END

		SELECT @DEFAULT_WAREHOURE_ID = WHM_ID FROM Warehouse WHERE WHM_Type = 'DefaultWH' AND WHM_DMA_ID = @DMA_ID

		IF @DEFAULT_WAREHOURE_ID IS NULL
		BEGIN
			
			SET @RtnVal = 'Error'
			SET @RtnMsg = '经销商没有主仓库'

			RETURN;
		END

		SELECT @REVERSE_IAH_ID =  IAH_ID FROM InventoryAdjustHeader 
		WHERE IAH_Reverse_IAH_ID = @SPH_ID

		--判断【发货单】是否已经做过买断
		IF @REVERSE_IAH_ID IS NOT NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '销售出单已存在对应的寄售买断单'

			RETURN;
			
		END

		--判断【销售出库单】是否发货经销商是否存在
		IF @DMA_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '销售出库单没有发货经销商信息！'

			RETURN;
			
		END

		--判断【销售出库单】是否产品线是否存在
		IF @PRODUCTLINE_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '销售出库单没有产品线信息！'

			RETURN;
			
		END

		/****************自动生成【销售出库单】单据***************/

		--根据产品线获取对应的BU
		SELECT @BU_NAME = A.ATTRIBUTE_NAME FROM Lafite_ATTRIBUTE A
		INNER JOIN Cache_OrganizationUnits B ON A.Id = B.RootID
		WHERE B.AttributeID = @PRODUCTLINE_ID
		AND ATTRIBUTE_TYPE = 'BU'

		EXEC dbo.GC_GetNextAutoNumber @DMA_ID,@NUMBER_SETTING,@BU_NAME,@NEXT_NUMBER OUTPUT

		BEGIN TRAN

		--更新InventoryAdjustHeader
		INSERT INTO [dbo].[InventoryAdjustHeader]
			   ([IAH_ID]
			   ,[IAH_Reason]
			   ,[IAH_Inv_Adj_Nbr]
			   ,[IAH_DMA_ID]
			   ,[IAH_ApprovalDate]
			   ,[IAH_CreatedDate]
			   ,[IAH_Approval_USR_UserID]
			   ,[IAH_AuditorNotes]
			   ,[IAH_UserDescription]
			   ,[IAH_Status]
			   ,[IAH_CreatedBy_USR_UserID]
			   ,[IAH_Reverse_IAH_ID]
			   ,[IAH_ProductLine_BUM_ID]
			   ,[IAH_WarehouseType]
			   ,[IAH_RSM]
			   ,[IAH_ApplyType]
			   ,[RetrunReason]
			   ,[SaleRep])
		 VALUES (@IAH_ID
				,'SalesOut'
				,@Next_Number
				,@DMA_ID
				,@OPERATION_TIME
				,@OPERATION_TIME
				,@OPERATION_USER
				,'系统自动审批通过'
				,'根据['+ @BUSINESS_NO +']系统自动生成'
				,'Accept'
				,@OPERATION_USER
				,@SPH_ID
				,@PRODUCTLINE_ID
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				)

		SELECT SPL_ShipmentQty
			,NEWID() AS IAD_ID
			,SPL_Shipment_PMA_ID
			,@IAH_ID AS IAH_ID
			,SPL_LineNbr 
			,SPL_ID 
			,SPL_SPH_ID
			INTO #InventoryAdjustDetail_Shipment_TEMP
		FROM ShipmentHeader A 
		INNER JOIN ShipmentLine B ON A.SPH_ID = B.SPL_SPH_ID
		WHERE A.SPH_ID = @SPH_ID

		--更新InventoryAdjustDetails
		INSERT INTO [dbo].[InventoryAdjustDetail]
           ([IAD_Quantity]
           ,[IAD_ID]
           ,[IAD_PMA_ID]
           ,[IAD_IAH_ID]
           ,[IAD_LineNbr])
		SELECT SPL_ShipmentQty 
			,IAD_ID
			,SPL_Shipment_PMA_ID
			,IAH_ID
			,SPL_LineNbr
		FROM #InventoryAdjustDetail_Shipment_TEMP

		--更新InventoryAdjustLot
		INSERT INTO [dbo].[InventoryAdjustLot]
           ([IAL_IAD_ID]
           ,[IAL_ID]
           ,[IAL_LotQty]
           ,[IAL_LOT_ID]
           ,[IAL_WHM_ID]
           ,[IAL_LotNumber]
           ,[IAL_ExpiredDate]
           ,[IAL_PRH_ID]
           ,[IAL_UnitPrice]
           ,[IAL_DMA_ID]
           ,[IAL_QRLOT_ID]
           ,[IAL_QRLotNumber])
		SELECT IAD_ID
			,NEWID()
			,SLT_LotShippedQty
			,C.SLT_LOT_ID	--销售的Lot_Id
			,C.SLT_WHM_ID	--销售的仓库ID
			,E.LTM_LotNumber
			,E.LTM_ExpiredDate
			,NULL
			,SLT_UnitPrice
			,NULL
			,NULL
			,NULL
		FROM ShipmentHeader A
		INNER JOIN #InventoryAdjustDetail_Shipment_TEMP B ON A.SPH_ID = B.SPL_SPH_ID
		INNER JOIN ShipmentLot C ON B.SPL_ID = C.SLT_SPL_ID
		INNER JOIN Lot D ON C.SLT_LOT_ID = D.LOT_ID
		INNER JOIN LotMaster E ON D.LOT_LTM_ID = E.LTM_ID
		WHERE A.SPH_ID = @SPH_ID

		--新增操作日志
		INSERT INTO PurchaseOrderLog(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
		VALUES (NEWID(),@IAH_ID,@OPERATION_USER,@OPERATION_TIME,'自动创建','系统自动生成买断单据')

		/****************更新原始销售欧丹中的仓库信息（改变为DefaultWH）***************/
		UPDATE C SET C.SLT_WHM_ID = @DEFAULT_WAREHOURE_ID
		FROM ShipmentHeader A
		INNER JOIN ShipmentLine B ON A.SPH_ID = B.SPL_SPH_ID
		INNER JOIN ShipmentLot C ON B.SPL_ID = C.SLT_SPL_ID
		WHERE A.SPH_ID = @SPH_ID

		SELECT A.SPH_Dealer_DMA_ID AS DealerId
			,C.SLT_WHM_ID AS WarehoureId
			,B.SPL_Shipment_PMA_ID AS ProductId
			,NEWID() AS InventoryId
			,NEWID() AS LotId 
			,C.SLT_LOT_ID AS Old_LotId
			,D.LOT_LTM_ID AS LotMasterId
			INTO #ReceiptInventory_Shipment_TEMP
		FROM ShipmentHeader A
		INNER JOIN ShipmentLine B ON A.SPH_ID = B.SPL_SPH_ID
		INNER JOIN ShipmentLot C ON B.SPL_ID = C.SLT_SPL_ID
		INNER JOIN Lot D ON C.SLT_LOT_ID = D.LOT_ID
		WHERE A.SPH_ID = @SPH_ID
		GROUP BY A.SPH_Dealer_DMA_ID,C.SLT_WHM_ID,B.SPL_Shipment_PMA_ID,C.SLT_LOT_ID,D.LOT_LTM_ID
		
		--根据仓库ID+产品ID获取唯一的INVENTORY ID
		UPDATE #ReceiptInventory_Shipment_TEMP SET InventoryId = INV_ID FROM Inventory
		WHERE INV_WHM_ID = WarehoureId
		AND INV_PMA_ID = ProductId

		--如果没有新增
		INSERT INTO Inventory(INV_OnHandQuantity,INV_ID,INV_WHM_ID,INV_PMA_ID)
		SELECT 0,InventoryId,WarehoureId,ProductId FROM #ReceiptInventory_Shipment_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Inventory WHERE INV_ID = InventoryId)

		--根据InventoryId + LotMasterId获取LotId
		UPDATE #ReceiptInventory_Shipment_TEMP SET LotId = LOT_ID FROM Lot
		WHERE LOT_INV_ID = InventoryId
		AND LotMasterId = LOT_LTM_ID

		--如果没有新增
		INSERT INTO LOT (LOT_ID,LOT_INV_ID,LOT_LTM_ID,LOT_OnHandQty)
		SELECT LotId,InventoryId,LotMasterId,0 FROM #ReceiptInventory_Shipment_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Lot WHERE LOT_ID = LotId)

		--将原始销售单中的LotId替换成新仓库对应的LotId，并且更新WHM_ID
		UPDATE C SET C.SLT_LOT_ID = D.LotId
		FROM ShipmentHeader A
		INNER JOIN ShipmentLine B ON A.SPH_ID = B.SPL_SPH_ID
		INNER JOIN ShipmentLot C ON B.SPL_ID = C.SLT_SPL_ID
		INNER JOIN #ReceiptInventory_Shipment_TEMP D ON C.SLT_LOT_ID = D.Old_LotId
		WHERE A.SPH_ID = @SPH_ID

		--更新单据类型为普通销售单
		UPDATE A SET A.SPH_Type='Hospital' FROM ShipmentHeader A WHERE A.SPH_ID = @SPH_ID  AND A.SPH_Type IN ('Borrow','Consignment')
		 
		COMMIT TRAN

	END


	--2、平台寄售发货
	--根据【发货单号】找到发货单号，生成对应的【寄售买断单据】，不需要改变原始【发货单】的仓库、库存、批次信息
	IF @BillType = 'POReceipt_Consignment'
	BEGIN
		
		SELECT @DMA_ID = PRH_Vendor_DMA_ID 
			,@PRODUCTLINE_ID = PRH_ProductLine_BUM_ID 
			,@PRH_ID = PRH_ID 
			,@WAREHOUSE_TYPE = (SELECT WHM_Type FROM Warehouse WHERE WHM_ID = PRH_FromWHM_ID)
			FROM POReceiptHeader 
			WHERE PRH_PONumber = @BUSINESS_NO 
			AND PRH_Type = 'PurchaseOrder'
		
		--判断【发货单】是否存在
		IF @PRH_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '平台寄售发货单不存在'

			RETURN;
			
		END

		--判断仓库类型是否是【Borrow】
		IF @WAREHOUSE_TYPE <> 'Borrow'
		BEGIN
			
			--只操作仓库类型为Borrow的发货单
			RETURN;
		END

		SELECT @DEFAULT_WAREHOURE_ID = WHM_ID FROM Warehouse WHERE WHM_Type = 'DefaultWH' AND WHM_DMA_ID = @DMA_ID

		IF @DEFAULT_WAREHOURE_ID IS NULL
		BEGIN
			
			SET @RtnVal = 'Error'
			SET @RtnMsg = '经销商没有主仓库'

			RETURN;
		END

		SELECT @REVERSE_IAH_ID =  IAH_ID FROM InventoryAdjustHeader 
		WHERE IAH_Reverse_IAH_ID = @PRH_ID

		--判断【发货单】是否已经做过买断
		IF @REVERSE_IAH_ID IS NOT NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '平台寄售发货单已存在对应的寄售买断单'

			RETURN;
			
		END

		--判断【发货单】是否发货经销商是否存在
		IF @DMA_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '平台寄售发货单没有发货经销商信息！'

			RETURN;
			
		END

		--判断【发货单】是否产品线是否存在
		IF @PRODUCTLINE_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '平台寄售发货单没有产品线信息！'

			RETURN;
			
		END
		
		/****************自动生成[平台买断]单据***************/

		--根据产品线获取对应的BU
		SELECT @BU_NAME = A.ATTRIBUTE_NAME FROM Lafite_ATTRIBUTE A
		INNER JOIN Cache_OrganizationUnits B ON A.Id = B.RootID
		WHERE B.AttributeID = @PRODUCTLINE_ID
		AND ATTRIBUTE_TYPE = 'BU'

		EXEC dbo.GC_GetNextAutoNumber @DMA_ID,@NUMBER_SETTING,@BU_NAME,@NEXT_NUMBER OUTPUT
		
		BEGIN TRAN

		--更新InventoryAdjustHeader
		INSERT INTO [dbo].[InventoryAdjustHeader]
			   ([IAH_ID]
			   ,[IAH_Reason]
			   ,[IAH_Inv_Adj_Nbr]
			   ,[IAH_DMA_ID]
			   ,[IAH_ApprovalDate]
			   ,[IAH_CreatedDate]
			   ,[IAH_Approval_USR_UserID]
			   ,[IAH_AuditorNotes]
			   ,[IAH_UserDescription]
			   ,[IAH_Status]
			   ,[IAH_CreatedBy_USR_UserID]
			   ,[IAH_Reverse_IAH_ID]
			   ,[IAH_ProductLine_BUM_ID]
			   ,[IAH_WarehouseType]
			   ,[IAH_RSM]
			   ,[IAH_ApplyType]
			   ,[RetrunReason]
			   ,[SaleRep])
		 VALUES (@IAH_ID
				,'SalesOut'
				,@Next_Number
				,@DMA_ID
				,@OPERATION_TIME
				,@OPERATION_TIME
				,@OPERATION_USER
				,'系统自动审批通过'
				,'根据['+ @BUSINESS_NO +']系统自动生成'
				,'Accept'
				,@OPERATION_USER
				,@PRH_ID
				,@PRODUCTLINE_ID
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				)

		SELECT POR_ReceiptQty
			,NEWID() AS IAD_ID
			,POR_SAP_PMA_ID
			,@IAH_ID AS IAH_ID
			,POR_LineNbr 
			,POR_ID 
			,POR_PRH_ID
			INTO #InventoryAdjustDetail_TEMP
		FROM POReceiptHeader A 
		INNER JOIN POReceipt B ON A.PRH_ID = B.POR_PRH_ID
		WHERE A.PRH_ID = @PRH_ID

		--更新InventoryAdjustDetails
		INSERT INTO [dbo].[InventoryAdjustDetail]
           ([IAD_Quantity]
           ,[IAD_ID]
           ,[IAD_PMA_ID]
           ,[IAD_IAH_ID]
           ,[IAD_LineNbr])
		SELECT POR_ReceiptQty 
			,IAD_ID
			,POR_SAP_PMA_ID
			,IAH_ID
			,POR_LineNbr
		FROM #InventoryAdjustDetail_TEMP
		
		SELECT A.PRH_Vendor_DMA_ID AS DealerId
			,A.PRH_FromWHM_ID AS WarehoureId
			,B.POR_SAP_PMA_ID AS ProductId
			,C.PRL_LotNumber AS LotNumber
			,NEWID() AS InventoryId
			,NEWID() AS LotId 
			,D.LTM_ID AS LotMasterId
			INTO #AdjustInventory_TEMP
		FROM POReceiptHeader A
		INNER JOIN POReceipt B ON A.PRH_ID = B.POR_PRH_ID
		INNER JOIN POReceiptLot C ON B.POR_ID = C.PRL_POR_ID
		INNER JOIN LotMaster D ON C.PRL_LotNumber = D.LTM_LotNumber
		WHERE A.PRH_ID = @PRH_ID
		GROUP BY A.PRH_Vendor_DMA_ID,A.PRH_FromWHM_ID,B.POR_SAP_PMA_ID,C.PRL_LotNumber,D.LTM_ID
		
		--根据仓库ID+产品ID获取唯一的INVENTORY ID
		UPDATE #AdjustInventory_TEMP SET InventoryId = INV_ID FROM Inventory
		WHERE INV_WHM_ID = WarehoureId
		AND INV_PMA_ID = ProductId

		--如果没有新增
		INSERT INTO Inventory(INV_OnHandQuantity,INV_ID,INV_WHM_ID,INV_PMA_ID)
		SELECT 0,InventoryId,WarehoureId,ProductId FROM #AdjustInventory_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Inventory WHERE INV_ID = InventoryId)

		--根据InventoryId + LotMasterId获取LotId
		UPDATE #AdjustInventory_TEMP SET LotId = LOT_ID FROM Lot
		WHERE LOT_INV_ID = InventoryId
		AND LotMasterId = LOT_LTM_ID

		--如果没有新增
		INSERT INTO LOT (LOT_ID,LOT_INV_ID,LOT_LTM_ID,LOT_OnHandQty)
		SELECT LotId,InventoryId,LotMasterId,0 FROM #AdjustInventory_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Lot WHERE LOT_ID = LotId)

		--更新InventoryAdjustLot
		INSERT INTO [dbo].[InventoryAdjustLot]
           ([IAL_IAD_ID]
           ,[IAL_ID]
           ,[IAL_LotQty]
           ,[IAL_LOT_ID]
           ,[IAL_WHM_ID]
           ,[IAL_LotNumber]
           ,[IAL_ExpiredDate]
           ,[IAL_PRH_ID]
           ,[IAL_UnitPrice]
           ,[IAL_DMA_ID]
           ,[IAL_QRLOT_ID]
           ,[IAL_QRLotNumber])
		SELECT IAD_ID
			,NEWID()
			,PRL_ReceiptQty
			,D.LotId		--出货方的Lot_Id
			,PRH_FromWHM_ID	--出货方的仓库ID
			,PRL_LotNumber
			,PRL_ExpiredDate
			,NULL
			,PRL_UnitPrice
			,NULL
			,NULL
			,NULL
		FROM POReceiptHeader A
		INNER JOIN #InventoryAdjustDetail_TEMP B ON A.PRH_ID = B.POR_PRH_ID
		INNER JOIN POReceiptLot C ON B.POR_ID = C.PRL_POR_ID
		INNER JOIN #AdjustInventory_TEMP D ON B.POR_SAP_PMA_ID = D.ProductId AND C.PRL_LotNumber = D.LotNumber
		WHERE A.PRH_ID = @PRH_ID

		--新增操作日志
		INSERT INTO PurchaseOrderLog(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
		VALUES (NEWID(),@IAH_ID,@OPERATION_USER,@OPERATION_TIME,'自动创建','系统自动生成买断单据')

		/****************更新原始发货单中的仓库信息（由Borrow改变为DefaultWH）***************/
		UPDATE POReceiptHeader SET PRH_FromWHM_ID = @DEFAULT_WAREHOURE_ID,PRH_Note = '平台寄售发货自动买断切换仓库到主仓库' WHERE PRH_ID = @PRH_ID

		UPDATE C SET C.PRL_WHM_ID = @DEFAULT_WAREHOURE_ID 
		FROM POReceiptHeader A
		INNER JOIN POReceipt B ON A.PRH_ID = POR_PRH_ID
		INNER JOIN POReceiptLot C ON B.POR_ID = PRL_POR_ID
		WHERE A.PRH_ID = @PRH_ID
				
		SELECT A.PRH_Vendor_DMA_ID AS DealerId
			,A.PRH_FromWHM_ID AS WarehoureId
			,B.POR_SAP_PMA_ID AS ProductId
			,C.PRL_LotNumber AS LotNumber
			,NEWID() AS InventoryId
			,NEWID() AS LotId 
			,D.LTM_ID AS LotMasterId
			INTO #ReceiptInventory_TEMP
		FROM POReceiptHeader A
		INNER JOIN POReceipt B ON A.PRH_ID = B.POR_PRH_ID
		INNER JOIN POReceiptLot C ON B.POR_ID = C.PRL_POR_ID
		INNER JOIN LotMaster D ON C.PRL_LotNumber = D.LTM_LotNumber
		WHERE A.PRH_ID = @PRH_ID
		GROUP BY A.PRH_Vendor_DMA_ID,A.PRH_FromWHM_ID,B.POR_SAP_PMA_ID,C.PRL_LotNumber,D.LTM_ID
		
		--根据仓库ID+产品ID获取唯一的INVENTORY ID
		UPDATE #ReceiptInventory_TEMP SET InventoryId = INV_ID FROM Inventory
		WHERE INV_WHM_ID = WarehoureId
		AND INV_PMA_ID = ProductId

		--如果没有新增
		INSERT INTO Inventory(INV_OnHandQuantity,INV_ID,INV_WHM_ID,INV_PMA_ID)
		SELECT 0,InventoryId,WarehoureId,ProductId FROM #ReceiptInventory_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Inventory WHERE INV_ID = InventoryId)

		--根据InventoryId + LotMasterId获取LotId
		UPDATE #ReceiptInventory_TEMP SET LotId = LOT_ID FROM Lot
		WHERE LOT_INV_ID = InventoryId
		AND LotMasterId = LOT_LTM_ID

		--如果没有新增
		INSERT INTO LOT (LOT_ID,LOT_INV_ID,LOT_LTM_ID,LOT_OnHandQty)
		SELECT LotId,InventoryId,LotMasterId,0 FROM #ReceiptInventory_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Lot WHERE LOT_ID = LotId)

		
		COMMIT TRAN

	END


	--3、系统自动生成的强制寄售买断 【调用移库PROD】
	IF @BillType = 'Purchase_Consignment'
	BEGIN

		--调用【其他存储过程】
		RETURN ;
	END

	--在AdjustInterface接口表中新增数据
	IF @BillType = 'Shipment_Consignment' --OR @BillType = 'POReceipt_Consignment' 
	BEGIN

		INSERT INTO dbo.AdjustInterface
			   (AI_ID
			   ,AI_BatchNbr
			   ,AI_RecordNbr
			   ,AI_IAH_ID
			   ,AI_IAH_AdjustNo
			   ,AI_Status
			   ,AI_ProcessType
			   ,AI_FileName
			   ,AI_CreateUser
			   ,AI_CreateDate
			   ,AI_UpdateUser
			   ,AI_UpdateDate
			   ,AI_ClientID)
		SELECT NEWID()
			,''
			,''
			,@IAH_ID
			,@BUSINESS_NO
			,'Pending'
			,'Manual'
			,NULL
			,@OPERATION_USER
			,@OPERATION_TIME
			,@OPERATION_USER
			,@OPERATION_TIME
			,CLT_ID
		FROM Client
		WHERE CLT_ActiveFlag = 1
		AND CLT_DeletedFlag = 0
		AND (CLT_Corp_Id = @DMA_ID OR CLT_Corp_Id IN (SELECT DMA_Parent_DMA_ID FROM DealerMaster WHERE DMA_ID=@DMA_ID))

	END
													


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
