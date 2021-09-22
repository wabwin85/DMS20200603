USE [BSC_DMS180515]
GO
/****** Object:  StoredProcedure [Consignment].[Proc_ConsignmentInv_BuyOff]    Script Date: 2018/9/28 10:42:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
1. �������ƣ�ҵ����������ɼ�����ϵ���
2. ����������
	���м�������ҵ�񶼻����ɼ�����ϵ��ݣ�����ҵ�����£�
	a. ���۲�Ʒ������:T1��T2��LP���۲�Ʒ��������ϵͳ�Զ����ɼ�����ϵ��ݡ�LP��T1 �����Զ��������״̬��
		T2����ƽֻ̨�����۸�ȷ�ϣ����������ܾ���
		��������Ϊ"���۳���"--��ɼ�����Ϻ󵥾ݴ�������Ҫ�������۵��ֿ����͵������������ֿ⡱��
		�ֿ�ת�� LP_Consignment��Consignment��Borrow ������ DefaultWH
	ShipmentHeader [���۲�Ʒ���۵�]��[�����Ʒ���۵�]  -->[SalesOut]

	b. ƽ̨�Բ��Ƽ��۲�Ʒ�����۷������Զ�����������ɵļ�����ϵ��ݡ�
	POReceiptHeader LP->L2[�ɹ����] -->[SalesOut]
	[Borrow]

	c. ϵͳ�Զ����ɵ�ǿ�Ƽ�����ϣ�ǿ�Ƽ��������Ҫ��Mflow������ǿ�Ƽ�����ϰ������й������ɡ�
	InventoryAdjuestHeader	--> [ForceCTOS]

	
3. ����������
	@BillType �������ͣ������۵���ƽ̨���۷�����ǿ�Ƽ�����ϣ�
	@BillNo ���ܵ��ݱ��
	@RtnVal ִ��״̬��Success��Failure
	@RtnMsg ��������
*/
ALTER PROCEDURE [Consignment].[Proc_ConsignmentInv_BuyOff](
    @BillType NVARCHAR(100)-- ���������۵���ϣ�Shipment_Consignment��ƽ̨���۷�����POReceipt_Consignment��������ϣ�Purchase_Consignment��
    ,@BillNo  NVARCHAR(100)
    ,@RtnVal NVARCHAR(20) OUTPUT
	,@RtnMsg NVARCHAR(1000) OUTPUT
)
AS
SET NOCOUNT ON

BEGIN TRY


	SET @RtnVal = 'Success';
	SET @RtnMsg = '';
	
	--������ID
	DECLARE @DMA_ID UNIQUEIDENTIFIER;
	--��Ʒ��ID
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


	--������������ϵ��ݡ�����
	SET @IAH_ID = NEWID();

	SET @NUMBER_SETTING = 'Next_ConsignToSellNbr';

	SET @OPERATION_USER = '00000000-0000-0000-0000-000000000000';

	SET @OPERATION_TIME = GETDATE();

	SET @BUSINESS_NO = ISNULL(@BillNo,'');
		
	--1���������۵����
	--���ݡ����۵��š��ҵ����۵��ţ����ɶ�Ӧ�ġ�������ϵ��ݡ�����Ҫ�ı�ԭʼ�����۵����Ĳֿ⡢��桢������Ϣ
	IF @BillType = 'Shipment_Consignment'
	BEGIN

		SELECT @DMA_ID = SPH_Dealer_DMA_ID 
			,@PRODUCTLINE_ID = SPH_ProductLine_BUM_ID 
			,@SPH_ID = SPH_ID 
			FROM ShipmentHeader 
			WHERE SPH_ShipmentNbr = @BUSINESS_NO 
			AND SPH_Type IN ('Borrow','Consignment')

		--�жϡ����۳��ⵥ���Ƿ����
		IF @SPH_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '���۳��ⵥ�����ڣ�'	

			RETURN;
			
		END

		SELECT @DEFAULT_WAREHOURE_ID = WHM_ID FROM Warehouse WHERE WHM_Type = 'DefaultWH' AND WHM_DMA_ID = @DMA_ID

		IF @DEFAULT_WAREHOURE_ID IS NULL
		BEGIN
			
			SET @RtnVal = 'Error'
			SET @RtnMsg = '������û�����ֿ�'

			RETURN;
		END

		SELECT @REVERSE_IAH_ID =  IAH_ID FROM InventoryAdjustHeader 
		WHERE IAH_Reverse_IAH_ID = @SPH_ID

		--�жϡ����������Ƿ��Ѿ��������
		IF @REVERSE_IAH_ID IS NOT NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '���۳����Ѵ��ڶ�Ӧ�ļ�����ϵ�'

			RETURN;
			
		END

		--�жϡ����۳��ⵥ���Ƿ񷢻��������Ƿ����
		IF @DMA_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '���۳��ⵥû�з�����������Ϣ��'

			RETURN;
			
		END

		--�жϡ����۳��ⵥ���Ƿ��Ʒ���Ƿ����
		IF @PRODUCTLINE_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = '���۳��ⵥû�в�Ʒ����Ϣ��'

			RETURN;
			
		END

		/****************�Զ����ɡ����۳��ⵥ������***************/

		--���ݲ�Ʒ�߻�ȡ��Ӧ��BU
		SELECT @BU_NAME = A.ATTRIBUTE_NAME FROM Lafite_ATTRIBUTE A
		INNER JOIN Cache_OrganizationUnits B ON A.Id = B.RootID
		WHERE B.AttributeID = @PRODUCTLINE_ID
		AND ATTRIBUTE_TYPE = 'BU'

		EXEC dbo.GC_GetNextAutoNumber @DMA_ID,@NUMBER_SETTING,@BU_NAME,@NEXT_NUMBER OUTPUT

		BEGIN TRAN

		--����InventoryAdjustHeader
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
				,'ϵͳ�Զ�����ͨ��'
				,'����['+ @BUSINESS_NO +']ϵͳ�Զ�����'
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

		--����InventoryAdjustDetails
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

		--����InventoryAdjustLot
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
			,C.SLT_LOT_ID	--���۵�Lot_Id
			,C.SLT_WHM_ID	--���۵Ĳֿ�ID
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

		--����������־
		INSERT INTO PurchaseOrderLog(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
		VALUES (NEWID(),@IAH_ID,@OPERATION_USER,@OPERATION_TIME,'�Զ�����','ϵͳ�Զ�������ϵ���')

		/****************����ԭʼ����ŷ���еĲֿ���Ϣ���ı�ΪDefaultWH��***************/
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
		
		--���ݲֿ�ID+��ƷID��ȡΨһ��INVENTORY ID
		UPDATE #ReceiptInventory_Shipment_TEMP SET InventoryId = INV_ID FROM Inventory
		WHERE INV_WHM_ID = WarehoureId
		AND INV_PMA_ID = ProductId

		--���û������
		INSERT INTO Inventory(INV_OnHandQuantity,INV_ID,INV_WHM_ID,INV_PMA_ID)
		SELECT 0,InventoryId,WarehoureId,ProductId FROM #ReceiptInventory_Shipment_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Inventory WHERE INV_ID = InventoryId)

		--����InventoryId + LotMasterId��ȡLotId
		UPDATE #ReceiptInventory_Shipment_TEMP SET LotId = LOT_ID FROM Lot
		WHERE LOT_INV_ID = InventoryId
		AND LotMasterId = LOT_LTM_ID

		--���û������
		INSERT INTO LOT (LOT_ID,LOT_INV_ID,LOT_LTM_ID,LOT_OnHandQty)
		SELECT LotId,InventoryId,LotMasterId,0 FROM #ReceiptInventory_Shipment_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Lot WHERE LOT_ID = LotId)

		--��ԭʼ���۵��е�LotId�滻���²ֿ��Ӧ��LotId�����Ҹ���WHM_ID
		UPDATE C SET C.SLT_LOT_ID = D.LotId
		FROM ShipmentHeader A
		INNER JOIN ShipmentLine B ON A.SPH_ID = B.SPL_SPH_ID
		INNER JOIN ShipmentLot C ON B.SPL_ID = C.SLT_SPL_ID
		INNER JOIN #ReceiptInventory_Shipment_TEMP D ON C.SLT_LOT_ID = D.Old_LotId
		WHERE A.SPH_ID = @SPH_ID

		--���µ�������Ϊ��ͨ���۵�
		UPDATE A SET A.SPH_Type='Hospital' FROM ShipmentHeader A WHERE A.SPH_ID = @SPH_ID  AND A.SPH_Type IN ('Borrow','Consignment')
		 
		COMMIT TRAN

	END


	--2��ƽ̨���۷���
	--���ݡ��������š��ҵ��������ţ����ɶ�Ӧ�ġ�������ϵ��ݡ�������Ҫ�ı�ԭʼ�����������Ĳֿ⡢��桢������Ϣ
	IF @BillType = 'POReceipt_Consignment'
	BEGIN
		
		SELECT @DMA_ID = PRH_Vendor_DMA_ID 
			,@PRODUCTLINE_ID = PRH_ProductLine_BUM_ID 
			,@PRH_ID = PRH_ID 
			,@WAREHOUSE_TYPE = (SELECT WHM_Type FROM Warehouse WHERE WHM_ID = PRH_FromWHM_ID)
			FROM POReceiptHeader 
			WHERE PRH_PONumber = @BUSINESS_NO 
			AND PRH_Type = 'PurchaseOrder'
		
		--�жϡ����������Ƿ����
		IF @PRH_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = 'ƽ̨���۷�����������'

			RETURN;
			
		END

		--�жϲֿ������Ƿ��ǡ�Borrow��
		IF @WAREHOUSE_TYPE <> 'Borrow'
		BEGIN
			
			--ֻ�����ֿ�����ΪBorrow�ķ�����
			RETURN;
		END

		SELECT @DEFAULT_WAREHOURE_ID = WHM_ID FROM Warehouse WHERE WHM_Type = 'DefaultWH' AND WHM_DMA_ID = @DMA_ID

		IF @DEFAULT_WAREHOURE_ID IS NULL
		BEGIN
			
			SET @RtnVal = 'Error'
			SET @RtnMsg = '������û�����ֿ�'

			RETURN;
		END

		SELECT @REVERSE_IAH_ID =  IAH_ID FROM InventoryAdjustHeader 
		WHERE IAH_Reverse_IAH_ID = @PRH_ID

		--�жϡ����������Ƿ��Ѿ��������
		IF @REVERSE_IAH_ID IS NOT NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = 'ƽ̨���۷������Ѵ��ڶ�Ӧ�ļ�����ϵ�'

			RETURN;
			
		END

		--�жϡ����������Ƿ񷢻��������Ƿ����
		IF @DMA_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = 'ƽ̨���۷�����û�з�����������Ϣ��'

			RETURN;
			
		END

		--�жϡ����������Ƿ��Ʒ���Ƿ����
		IF @PRODUCTLINE_ID IS NULL
		BEGIN

			SET @RtnVal = 'Error'
			SET @RtnMsg = 'ƽ̨���۷�����û�в�Ʒ����Ϣ��'

			RETURN;
			
		END
		
		/****************�Զ�����[ƽ̨���]����***************/

		--���ݲ�Ʒ�߻�ȡ��Ӧ��BU
		SELECT @BU_NAME = A.ATTRIBUTE_NAME FROM Lafite_ATTRIBUTE A
		INNER JOIN Cache_OrganizationUnits B ON A.Id = B.RootID
		WHERE B.AttributeID = @PRODUCTLINE_ID
		AND ATTRIBUTE_TYPE = 'BU'

		EXEC dbo.GC_GetNextAutoNumber @DMA_ID,@NUMBER_SETTING,@BU_NAME,@NEXT_NUMBER OUTPUT
		
		BEGIN TRAN

		--����InventoryAdjustHeader
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
				,'ϵͳ�Զ�����ͨ��'
				,'����['+ @BUSINESS_NO +']ϵͳ�Զ�����'
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

		--����InventoryAdjustDetails
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
		
		--���ݲֿ�ID+��ƷID��ȡΨһ��INVENTORY ID
		UPDATE #AdjustInventory_TEMP SET InventoryId = INV_ID FROM Inventory
		WHERE INV_WHM_ID = WarehoureId
		AND INV_PMA_ID = ProductId

		--���û������
		INSERT INTO Inventory(INV_OnHandQuantity,INV_ID,INV_WHM_ID,INV_PMA_ID)
		SELECT 0,InventoryId,WarehoureId,ProductId FROM #AdjustInventory_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Inventory WHERE INV_ID = InventoryId)

		--����InventoryId + LotMasterId��ȡLotId
		UPDATE #AdjustInventory_TEMP SET LotId = LOT_ID FROM Lot
		WHERE LOT_INV_ID = InventoryId
		AND LotMasterId = LOT_LTM_ID

		--���û������
		INSERT INTO LOT (LOT_ID,LOT_INV_ID,LOT_LTM_ID,LOT_OnHandQty)
		SELECT LotId,InventoryId,LotMasterId,0 FROM #AdjustInventory_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Lot WHERE LOT_ID = LotId)

		--����InventoryAdjustLot
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
			,D.LotId		--��������Lot_Id
			,PRH_FromWHM_ID	--�������Ĳֿ�ID
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

		--����������־
		INSERT INTO PurchaseOrderLog(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
		VALUES (NEWID(),@IAH_ID,@OPERATION_USER,@OPERATION_TIME,'�Զ�����','ϵͳ�Զ�������ϵ���')

		/****************����ԭʼ�������еĲֿ���Ϣ����Borrow�ı�ΪDefaultWH��***************/
		UPDATE POReceiptHeader SET PRH_FromWHM_ID = @DEFAULT_WAREHOURE_ID,PRH_Note = 'ƽ̨���۷����Զ�����л��ֿ⵽���ֿ�' WHERE PRH_ID = @PRH_ID

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
		
		--���ݲֿ�ID+��ƷID��ȡΨһ��INVENTORY ID
		UPDATE #ReceiptInventory_TEMP SET InventoryId = INV_ID FROM Inventory
		WHERE INV_WHM_ID = WarehoureId
		AND INV_PMA_ID = ProductId

		--���û������
		INSERT INTO Inventory(INV_OnHandQuantity,INV_ID,INV_WHM_ID,INV_PMA_ID)
		SELECT 0,InventoryId,WarehoureId,ProductId FROM #ReceiptInventory_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Inventory WHERE INV_ID = InventoryId)

		--����InventoryId + LotMasterId��ȡLotId
		UPDATE #ReceiptInventory_TEMP SET LotId = LOT_ID FROM Lot
		WHERE LOT_INV_ID = InventoryId
		AND LotMasterId = LOT_LTM_ID

		--���û������
		INSERT INTO LOT (LOT_ID,LOT_INV_ID,LOT_LTM_ID,LOT_OnHandQty)
		SELECT LotId,InventoryId,LotMasterId,0 FROM #ReceiptInventory_TEMP
		WHERE NOT EXISTS(SELECT 1 FROM Lot WHERE LOT_ID = LotId)

		
		COMMIT TRAN

	END


	--3��ϵͳ�Զ����ɵ�ǿ�Ƽ������ �������ƿ�PROD��
	IF @BillType = 'Purchase_Consignment'
	BEGIN

		--���á������洢���̡�
		RETURN ;
	END

	--��AdjustInterface�ӿڱ�����������
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
