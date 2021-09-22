DROP Procedure [interface].[P_I_EW_GoodsReturn]
GO


/*
ƽ̨�˻�ȷ�����ݴ���
*/
CREATE Procedure [interface].[P_I_EW_GoodsReturn]
	@ReturnNo NVARCHAR(30),
	@IsApproval int,
    @Detail NVARCHAR(MAX),
    @ReturnValue NVARCHAR(100) OUTPUT
AS
	DECLARE @idoc int
	DECLARE @SysUserId uniqueidentifier
	DECLARE @SystemHoldWarehouse uniqueidentifier
	DECLARE @DealerId uniqueidentifier
	DECLARE @OrderId uniqueidentifier
	DECLARE @DealerType nvarchar(5)
	DECLARE @BatchNbr NVARCHAR(30)
	DECLARE @OrderType NVARCHAR(50)
SET NOCOUNT ON

BEGIN TRY
	SET @BatchNbr = ''
	EXEC dbo.GC_GetNextAutoNumberForInt 'SYS','P_I_EW_GoodsReturn',@BatchNbr OUTPUT

	SET @SysUserId = '00000000-0000-0000-0000-000000000000'

BEGIN TRAN

	--�����˻����Ų�ѯ�����Ƿ���ڣ��ҵ���״̬�����Ǵ�����
	SELECT @OrderId = IAH_ID,@DealerId = IAH_DMA_ID,@OrderType = IAH_Reason FROM InventoryAdjustHeader WHERE IAH_Inv_Adj_Nbr = @ReturnNo AND IAH_Reason in ('Return','Exchange','Transfer') AND IAH_Status = 'Submitted'
	IF @@ROWCOUNT = 0
		RAISERROR ('�˻����Ų����ڻ򵥾��ѱ�����',16,1);
		
	--��������;������
	SELECT @SystemHoldWarehouse = WHM_ID FROM Warehouse WHERE WHM_DMA_ID = @DealerId AND WHM_Type = 'SystemHold'
	--��þ���������
	SELECT @DealerType = DMA_DealerType FROM DealerMaster WHERE DMA_ID = @DealerId
	
	--���µ���״̬
	UPDATE InventoryAdjustHeader SET IAH_Status = (CASE @IsApproval WHEN 0 THEN 'Reject' ELSE 'Accept' END)
	WHERE IAH_ID = @OrderId
	--��¼������־
	INSERT INTO PurchaseOrderLog (POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
	VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),(CASE @IsApproval WHEN 0 THEN 'Reject' ELSE 'Approve' END),NULL)

	--���˻���������ϸ������ʱ�������˻�����Ĭ��0��0����ʾȡ���˻���
	SELECT IAL.IAL_ID,IAL.IAL_LOT_ID,IAL.IAL_WHM_ID,IAL.IAL_LotNumber,IAD.IAD_PMA_ID,
	Lot.LOT_LTM_ID,IAL.IAL_LotQty,WHM.WHM_Code,WHM.WHM_Name,Product.PMA_UPN, Convert(decimal(18,6),0.00) AS IAL_LotQtyNew,
	IAD.IAD_ID,IAL.IAL_UnitPrice
	INTO #TMP_DETAIL
  	FROM InventoryAdjustHeader IAH
	INNER JOIN InventoryAdjustDetail IAD ON IAD.IAD_IAH_ID = IAH.IAH_ID 
	INNER JOIN InventoryAdjustLot IAL ON IAL.IAL_IAD_ID = IAD.IAD_ID
	INNER JOIN Lot ON Lot.LOT_ID = IAL.IAL_LOT_ID
	INNER JOIN Warehouse WHM ON WHM.WHM_ID = IAL.IAL_WHM_ID
	INNER JOIN Product ON Product.PMA_ID = IAD.IAD_PMA_ID
	WHERE IAH.IAH_ID = @OrderId

	--�������ͨ��������Ҫ��ȡXML����
	IF @IsApproval = 1
		BEGIN
			--XML�ĵ�Ԥ����
			EXEC sp_xml_preparedocument @idoc OUTPUT, @Detail
			--��ȡXML��������ʱ��
			SELECT * INTO #TMP_RETURN
			FROM   OPENXML (@idoc, '/InterfaceDataSet/Record')
			         WITH (UPN NVARCHAR(30) 'UPN',
			               Lot NVARCHAR(50) 'Lot',
			               Qty DECIMAL(18,6) 'Qty',
			               WarehouseCode NVARCHAR(100) 'WarehouseCode')
			--XML�ĵ�����ͷ�
			EXEC sp_xml_removedocument @idoc   	   
			
			update #TMP_RETURN set Lot = Lot + '@@NoQR' where CHARINDEX('@@',Lot) = 0
			update #TMP_RETURN set Lot = Lot + 'NoQR' where Lot like '%@@'

			--�����޸ĺ���˻�����
			UPDATE #TMP_DETAIL SET #TMP_DETAIL.IAL_LotQtyNew = #TMP_RETURN.Qty
			FROM #TMP_RETURN
			WHERE #TMP_RETURN.UPN = #TMP_DETAIL.PMA_UPN
			AND #TMP_RETURN.Lot = #TMP_DETAIL.IAL_LotNumber
			AND #TMP_RETURN.WarehouseCode = #TMP_DETAIL.WHM_Code

			--�ж��޸ĺ���˻������Ƿ����Ҫ���������ܴ���ԭ������������������ڵ���0
			IF EXISTS (SELECT 1 FROM #TMP_DETAIL WHERE IAL_LotQtyNew < 0 OR (IAL_LotQtyNew - IAL_LotQty) > 0)
				RAISERROR ('�˻��������ܴ���ԭ�������ұ�����ڵ���0',16,1);					
		END

	/*�����ʱ��*/
	create table #tmp_inventory(
	INV_ID uniqueidentifier,
	INV_WHM_ID uniqueidentifier,
	INV_PMA_ID uniqueidentifier,
	INV_OnHandQuantity float
	primary key (INV_ID)
	)

	/*�����ϸLot��ʱ��*/
	create table #tmp_lot(
	LOT_ID uniqueidentifier,
	LOT_LTM_ID uniqueidentifier,
	LOT_WHM_ID uniqueidentifier,
	LOT_PMA_ID uniqueidentifier,
	LOT_INV_ID uniqueidentifier,
	LOT_OnHandQty float,
	LOT_LotNumber nvarchar(50),
	primary key (LOT_ID)
	)

	/*�����־��ʱ��*/
	create table #tmp_invtrans(
	ITR_Quantity         float,
	ITR_ID               uniqueidentifier,
	ITR_ReferenceID      uniqueidentifier,
	ITR_Type             nvarchar(50)         collate Chinese_PRC_CI_AS,
	ITR_WHM_ID           uniqueidentifier,
	ITR_PMA_ID           uniqueidentifier,
	ITR_UnitPrice        float,
	ITR_TransDescription nvarchar(200)        collate Chinese_PRC_CI_AS,
	primary key (ITR_ID)
	)
	/*�����ϸLot��־��ʱ��*/
	create table #tmp_invtranslot(
	ITL_Quantity         float,
	ITL_ID               uniqueidentifier,
	ITL_ITR_ID           uniqueidentifier,
	ITL_LTM_ID           uniqueidentifier,
	ITL_LotNumber        nvarchar(50)         collate Chinese_PRC_CI_AS,
	primary key (ITL_ID)
	)

	/*�˻������ϸ��ʱ��*/
	CREATE TABLE #TMP_DealerReturnPosition(
		[DRP_ID] [uniqueidentifier] NOT NULL,
		[DRP_DMA_ID] [uniqueidentifier] NOT NULL,
		[DRP_BUM_ID] [uniqueidentifier] NOT NULL,
		[DRP_Year] [nvarchar](4) NOT NULL,
		[DRP_Quarter] [nvarchar](2) NOT NULL,
		[DRP_DetailAmount] [decimal](18, 6) NOT NULL,
		[DRP_IsInit] [bit] NOT NULL,
		[DRP_ReturnId] [uniqueidentifier] NULL,
		[DRP_ReturnNo] [nvarchar](200) NULL,
		[DRP_ReturnLotId] [uniqueidentifier] NULL,
		[DRP_Sku] [nvarchar](200) NULL,
		[DRP_LotNumber] [nvarchar](200) NULL,
		[DRP_QrCode] [nvarchar](200) NULL,
		[DRP_ReturnQty] [decimal](18, 6) NULL,
		[DRP_Price] [decimal](18, 6) NULL,
		[DRP_Type] [nvarchar](50) NOT NULL,
		[DRP_Desc] [nvarchar](2000) NULL,
		[DRP_REV1] [nvarchar](2000) NULL,
		[DRP_REV2] [nvarchar](2000) NULL,
		[DRP_REV3] [nvarchar](2000) NULL,
		[DRP_CreateDate] [datetime] NOT NULL,
		[DRP_CreateUser] [uniqueidentifier] NOT NULL,
		[DRP_CreateUserName] [nvarchar](200) NOT NULL,
		[DRP_IsActived] [bit] NOT NULL
	)

	--����������������������T1������LP�˻�����δͨ��ʱִ��
	IF @DealerType = 'T1' OR (@DealerType = 'LP' AND @IsApproval = 0)
		BEGIN
			--IAL_LotQty���м���Ƴ���IAL_LotQty-IAL_LotQtyNew�õ�Ҫ�ƻ�ԭ�ֿ������
			--Inventory��
			INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
			SELECT -A.QTY,NEWID(),@SystemHoldWarehouse,A.IAD_PMA_ID
			FROM 
			(SELECT IAD_PMA_ID,SUM(IAL_LotQty) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAD_PMA_ID) AS A
			
			INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
			SELECT A.QTY,NEWID(),A.IAL_WHM_ID,A.IAD_PMA_ID
			FROM 
			(SELECT IAL_WHM_ID,IAD_PMA_ID,SUM(IAL_LotQty - IAL_LotQtyNew) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAL_WHM_ID,IAD_PMA_ID) AS A		

			--���¿������ڵĸ��£������ڵ�����
			UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)+Convert(decimal(18,6),TMP.INV_OnHandQuantity)
			FROM #tmp_inventory AS TMP
			WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
			AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

			INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
			SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID
			FROM #tmp_inventory AS TMP	
			WHERE NOT EXISTS (SELECT 1 FROM Inventory INV WHERE INV.INV_WHM_ID = TMP.INV_WHM_ID
			AND INV.INV_PMA_ID = TMP.INV_PMA_ID)

			--Lot��
			INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
			SELECT NEWID(),A.LOT_LTM_ID,@SystemHoldWarehouse,A.IAD_PMA_ID,A.IAL_LotNumber,-A.QTY
			FROM 
			(SELECT IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber,SUM(IAL_LotQty) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber) AS A

			INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
			SELECT NEWID(),A.LOT_LTM_ID,A.IAL_WHM_ID,A.IAD_PMA_ID,A.IAL_LotNumber,A.QTY
			FROM 
			(SELECT IAL_WHM_ID,IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber,SUM(IAL_LotQty - IAL_LotQtyNew) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAL_WHM_ID,IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber) AS A

			--���¹����������
			UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
			FROM Inventory INV 
			WHERE INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
			AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

			--�������α����ڵĸ��£������ڵ�����
			UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,6),Lot.LOT_OnHandQty)+Convert(decimal(18,6),TMP.LOT_OnHandQty)
			FROM #tmp_lot AS TMP
			WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
			AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

			INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
			SELECT LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID 
			FROM #tmp_lot AS TMP
			WHERE NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
			AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)

			--Inventory������־���Ƴ��м��
			INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
			SELECT -IAL_LotQty,NEWID(),IAL_ID,'���������˻�',@SystemHoldWarehouse,IAD_PMA_ID,0,
			CASE WHEN @OrderType = 'Transfer' THEN '���������ͣ�Transfer�����м���Ƴ���' ELSE '���������ͣ�Return�����м���Ƴ���' END
			FROM #TMP_DETAIL

			INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
			SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

			--Lot������־���Ƴ��м��
			INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
			SELECT -D.IAL_LotQty,NEWID(),D.LOT_LTM_ID,D.IAL_LotNumber,ITR.ITR_ID
			FROM #TMP_DETAIL D
			INNER JOIN #tmp_invtrans ITR ON ITR.ITR_ReferenceID = D.IAL_ID

			INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
			SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot

			--�����־����
			DELETE FROM #tmp_invtrans
			DELETE FROM #tmp_invtranslot

			--Inventory������־���ƻ�ԭ�ֿ�
			INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
			SELECT IAL_LotQty - IAL_LotQtyNew,NEWID(),IAL_ID,
			CASE WHEN @OrderType = 'Transfer' THEN '��������ת�Ƹ�����������' ELSE '���������˻�' END,
			IAL_WHM_ID,IAD_PMA_ID,0,
			CASE WHEN @OrderType = 'Transfer' THEN '���������ͣ�Transfer���ƻ�ԭ�ֿ⡣' ELSE '���������ͣ�Return���ƻ�ԭ�ֿ⡣' END 
			FROM #TMP_DETAIL

			INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
			SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

			--Lot������־���ƻ�ԭ�ֿ�
			INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
			SELECT D.IAL_LotQty - D.IAL_LotQtyNew,NEWID(),D.LOT_LTM_ID,D.IAL_LotNumber,ITR.ITR_ID
			FROM #TMP_DETAIL D
			INNER JOIN #tmp_invtrans ITR ON ITR.ITR_ReferenceID = D.IAL_ID

			INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
			SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot		

			--������˻����͡�������ͬԼ�������ڵġ�
			--��Ҫ���в�����˻�����˻ص��˻���ȳ���
			--��ȡ������ > 0������
			INSERT INTO #TMP_DealerReturnPosition 
				([DRP_ID]
			   ,[DRP_DMA_ID]
			   ,[DRP_BUM_ID]
			   ,[DRP_Year]
			   ,[DRP_Quarter]
			   ,[DRP_DetailAmount]
			   ,[DRP_IsInit]
			   ,[DRP_ReturnId]
			   ,[DRP_ReturnNo]
			   ,[DRP_ReturnLotId]
			   ,[DRP_Sku]
			   ,[DRP_LotNumber]
			   ,[DRP_QrCode]
			   ,[DRP_ReturnQty]
			   ,[DRP_Price]
			   ,[DRP_Type]
			   ,[DRP_Desc]
			   ,[DRP_REV1]
			   ,[DRP_REV2]
			   ,[DRP_REV3]
			   ,[DRP_CreateDate]
			   ,[DRP_CreateUser]
			   ,[DRP_CreateUserName]
			   ,[DRP_IsActived])
			SELECT NEWID(),
				@DealerId,
				C.IAH_ProductLine_BUM_ID,
				YEAR(GETDATE()),
				DATEPART(QUARTER,GETDATE()),
				ISNULL(IAL_LotQty,0) * A.IAL_UnitPrice,
				0,
				@OrderId,
				IAH_Inv_Adj_Nbr,
				A.IAL_ID,
				A.PMA_UPN,
				CASE WHEN CHARINDEX('@@',IAL_LotNumber) > 0 THEN substring(IAL_LotNumber,1,CHARINDEX('@@',IAL_LotNumber)-1) ELSE IAL_LotNumber END,
				CASE WHEN CHARINDEX('@@',IAL_LotNumber) > 0 THEN substring(IAL_LotNumber,CHARINDEX('@@',IAL_LotNumber)+2,LEN(IAL_LotNumber)-CHARINDEX('@@',IAL_LotNumber)) ELSE 'NoQR' END,
				ISNULL(IAL_LotQty,0),
				A.IAL_UnitPrice,
				'�˻��˻�',
				'�˻��˻�����',
				C.IAH_UserDescription,
				@BatchNbr,
				null,
				GETDATE(),
				@SysUserId,
				'ϵͳ',
				ISNULL((SELECT TOP 1 DRP_IsActived FROM DealerReturnPosition WHERE DRP_ReturnLotId = A.IAL_ID),0)
				FROM #TMP_DETAIL A
			INNER JOIN InventoryAdjustDetail B ON A.IAD_ID = B.IAD_ID
			INNER JOIN InventoryAdjustHeader C ON C.IAH_ID = B.IAD_IAH_ID
			WHERE ISNULL(IAL_LotQty,0) > 0
			AND C.IAH_ApplyType = '4'
			AND C.IAH_Reason IN ('Return','Exchange')

			INSERT INTO DealerReturnPosition
					([DRP_ID]
					,[DRP_DMA_ID]
					,[DRP_BUM_ID]
					,[DRP_Year]
					,[DRP_Quarter]
					,[DRP_DetailAmount]
					,[DRP_IsInit]
					,[DRP_ReturnId]
					,[DRP_ReturnNo]
					,[DRP_ReturnLotId]
					,[DRP_Sku]
					,[DRP_LotNumber]
					,[DRP_QrCode]
					,[DRP_ReturnQty]
					,[DRP_Price]
					,[DRP_Type]
					,[DRP_Desc]
					,[DRP_REV1]
					,[DRP_REV2]
					,[DRP_REV3]
					,[DRP_CreateDate]
					,[DRP_CreateUser]
					,[DRP_CreateUserName]
					,[DRP_IsActived])
			SELECT [DRP_ID]
					,[DRP_DMA_ID]
					,[DRP_BUM_ID]
					,[DRP_Year]
					,[DRP_Quarter]
					,[DRP_DetailAmount]
					,[DRP_IsInit]
					,[DRP_ReturnId]
					,[DRP_ReturnNo]
					,[DRP_ReturnLotId]
					,[DRP_Sku]
					,[DRP_LotNumber]
					,[DRP_QrCode]
					,[DRP_ReturnQty]
					,[DRP_Price]
					,[DRP_Type]
					,[DRP_Desc]
					,[DRP_REV1]
					,[DRP_REV2]
					,[DRP_REV3]
					,[DRP_CreateDate]
					,[DRP_CreateUser]
					,[DRP_CreateUserName] 
					,[DRP_IsActived]
				FROM #TMP_DealerReturnPosition		
		END

	--�����LP���˻�����������ͨ������Ҫ��AdjustInterface�������ݣ��ȴ�ƽ̨����
	IF @DealerType = 'LP' AND @IsApproval = 1
		BEGIN

			--IAL_LotQty���м���Ƴ���IAL_LotQty-IAL_LotQtyNew�õ�Ҫ�ƻ�ԭ�ֿ������
			--Inventory��
			INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
			SELECT -A.QTY,NEWID(),@SystemHoldWarehouse,A.IAD_PMA_ID
			FROM 
			(SELECT IAD_PMA_ID,SUM(IAL_LotQty) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAD_PMA_ID) AS A
			
			INSERT INTO #tmp_inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
			SELECT A.QTY,NEWID(),A.IAL_WHM_ID,A.IAD_PMA_ID
			FROM 
			(SELECT IAL_WHM_ID,IAD_PMA_ID,SUM(IAL_LotQty - IAL_LotQtyNew) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAL_WHM_ID,IAD_PMA_ID) AS A		

			--���¿������ڵĸ��£������ڵ�����
			UPDATE Inventory SET Inventory.INV_OnHandQuantity = Convert(decimal(18,6),Inventory.INV_OnHandQuantity)+Convert(decimal(18,6),TMP.INV_OnHandQuantity)
			FROM #tmp_inventory AS TMP
			WHERE Inventory.INV_WHM_ID = TMP.INV_WHM_ID
			AND Inventory.INV_PMA_ID = TMP.INV_PMA_ID

			INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)	
			SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID
			FROM #tmp_inventory AS TMP	
			WHERE NOT EXISTS (SELECT 1 FROM Inventory INV WHERE INV.INV_WHM_ID = TMP.INV_WHM_ID
			AND INV.INV_PMA_ID = TMP.INV_PMA_ID)

			--Lot��
			INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
			SELECT NEWID(),A.LOT_LTM_ID,@SystemHoldWarehouse,A.IAD_PMA_ID,A.IAL_LotNumber,-A.QTY
			FROM 
			(SELECT IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber,SUM(IAL_LotQty) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber) AS A

			INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
			SELECT NEWID(),A.LOT_LTM_ID,A.IAL_WHM_ID,A.IAD_PMA_ID,A.IAL_LotNumber,A.QTY
			FROM 
			(SELECT IAL_WHM_ID,IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber,SUM(IAL_LotQty - IAL_LotQtyNew) AS QTY 
			FROM #TMP_DETAIL
			GROUP BY IAL_WHM_ID,IAD_PMA_ID,LOT_LTM_ID,IAL_LotNumber) AS A

			--���¹����������
			UPDATE #tmp_lot SET LOT_INV_ID = INV.INV_ID
			FROM Inventory INV 
			WHERE INV.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
			AND INV.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

			--�������α����ڵĸ��£������ڵ�����
			UPDATE Lot SET Lot.LOT_OnHandQty = Convert(decimal(18,6),Lot.LOT_OnHandQty)+Convert(decimal(18,6),TMP.LOT_OnHandQty)
			FROM #tmp_lot AS TMP
			WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID 
			AND Lot.LOT_INV_ID = TMP.LOT_INV_ID

			INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
			SELECT LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID 
			FROM #tmp_lot AS TMP
			WHERE NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_LTM_ID = TMP.LOT_LTM_ID
			AND Lot.LOT_INV_ID = TMP.LOT_INV_ID)

			--Inventory������־���Ƴ��м��
			INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
			SELECT -IAL_LotQty,NEWID(),IAL_ID,
			CASE WHEN @OrderType = 'Transfer' THEN '��������ת�Ƹ�����������' ELSE '���������˻�' END,
			@SystemHoldWarehouse,IAD_PMA_ID,0,
			CASE WHEN @OrderType = 'Transfer' THEN '���������ͣ�Transfer�����м���Ƴ���' ELSE '���������ͣ�Return�����м���Ƴ���' END 
			FROM #TMP_DETAIL

			INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
			SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

			--Lot������־���Ƴ��м��
			INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
			SELECT -(D.IAL_LotQty),NEWID(),D.LOT_LTM_ID,D.IAL_LotNumber,ITR.ITR_ID
			FROM #TMP_DETAIL D
			INNER JOIN #tmp_invtrans ITR ON ITR.ITR_ReferenceID = D.IAL_ID

			INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
			SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot

			--�����־����
			DELETE FROM #tmp_invtrans
			DELETE FROM #tmp_invtranslot

			--Inventory������־���ƻ�ԭ�ֿ�
			INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
			SELECT IAL_LotQty - IAL_LotQtyNew,NEWID(),IAL_ID,
			CASE WHEN @OrderType = 'Transfer' THEN '��������ת�Ƹ�����������' ELSE '���������˻�' END,
			IAL_WHM_ID,IAD_PMA_ID,0,
			CASE WHEN @OrderType = 'Transfer' THEN '���������ͣ�Transfer���ƻ�ԭ�ֿ⡣' ELSE '���������ͣ�Return���ƻ�ԭ�ֿ⡣' END 
			FROM #TMP_DETAIL

			INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
			SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

			--Lot������־���ƻ�ԭ�ֿ�
			INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
			SELECT D.IAL_LotQty - D.IAL_LotQtyNew,NEWID(),D.LOT_LTM_ID,D.IAL_LotNumber,ITR.ITR_ID
			FROM #TMP_DETAIL D
			INNER JOIN #tmp_invtrans ITR ON ITR.ITR_ReferenceID = D.IAL_ID

			INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
			SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot

			--�õ�LP��ClientID
			DECLARE @ClientID NVARCHAR(50)
			SELECT @ClientID = CLT_ID FROM Client WHERE CLT_Corp_Id = @DealerId
			INSERT INTO AdjustInterface
			(
				AI_ID,
				AI_BatchNbr,
				AI_RecordNbr,
				AI_IAH_ID,
				AI_IAH_AdjustNo,
				AI_Status,
				AI_ProcessType,
				AI_FileName,
				AI_CreateUser,
				AI_CreateDate,
				AI_UpdateUser,
				AI_UpdateDate,
				AI_ClientID
			)
			VALUES
			(
				NEWID(),
				'',
				'',
				@OrderId,
				@ReturnNo,
				'Pending',
				'System',
				NULL,
				@SysUserId,
				GETDATE(),
				NULL,
				NULL,
				@ClientID
			)

			--������˻����͡�������ͬԼ�������ڵġ�
			--��Ҫ���в�����˻�����˻ص��˻���ȳ���
			--��ȡ������ > 0������
			INSERT INTO #TMP_DealerReturnPosition 
				([DRP_ID]
			   ,[DRP_DMA_ID]
			   ,[DRP_BUM_ID]
			   ,[DRP_Year]
			   ,[DRP_Quarter]
			   ,[DRP_DetailAmount]
			   ,[DRP_IsInit]
			   ,[DRP_ReturnId]
			   ,[DRP_ReturnNo]
			   ,[DRP_ReturnLotId]
			   ,[DRP_Sku]
			   ,[DRP_LotNumber]
			   ,[DRP_QrCode]
			   ,[DRP_ReturnQty]
			   ,[DRP_Price]
			   ,[DRP_Type]
			   ,[DRP_Desc]
			   ,[DRP_REV1]
			   ,[DRP_REV2]
			   ,[DRP_REV3]
			   ,[DRP_CreateDate]
			   ,[DRP_CreateUser]
			   ,[DRP_CreateUserName]
			   ,[DRP_IsActived])
			SELECT NEWID(),
				@DealerId,
				C.IAH_ProductLine_BUM_ID,
				YEAR(GETDATE()),
				DATEPART(QUARTER,GETDATE()),
				(ISNULL(IAL_LotQty,0) - ISNULL(IAL_LotQtyNew,0)) * A.IAL_UnitPrice,
				0,
				@OrderId,
				IAH_Inv_Adj_Nbr,
				A.IAL_ID,
				A.PMA_UPN,
				CASE WHEN CHARINDEX('@@',IAL_LotNumber) > 0 THEN substring(IAL_LotNumber,1,CHARINDEX('@@',IAL_LotNumber)-1) ELSE IAL_LotNumber END,
				CASE WHEN CHARINDEX('@@',IAL_LotNumber) > 0 THEN substring(IAL_LotNumber,CHARINDEX('@@',IAL_LotNumber)+2,LEN(IAL_LotNumber)-CHARINDEX('@@',IAL_LotNumber)) ELSE 'NoQR' END,
				(ISNULL(IAL_LotQty,0) - ISNULL(IAL_LotQtyNew,0)),
				A.IAL_UnitPrice,
				'�˻��˻�',
				'�˻��˻�����',
				C.IAH_UserDescription,
				@BatchNbr,
				null,
				GETDATE(),
				@SysUserId,
				'ϵͳ',
				ISNULL((SELECT TOP 1 DRP_IsActived FROM DealerReturnPosition WHERE DRP_ReturnLotId = A.IAL_ID),0)
				FROM #TMP_DETAIL A
			INNER JOIN InventoryAdjustDetail B ON A.IAD_ID = B.IAD_ID
			INNER JOIN InventoryAdjustHeader C ON C.IAH_ID = B.IAD_IAH_ID
			WHERE (ISNULL(IAL_LotQty,0) - ISNULL(IAL_LotQtyNew,0)) > 0
			AND C.IAH_ApplyType = '4'
			AND C.IAH_Reason IN ('Return','Exchange')

			INSERT INTO DealerReturnPosition
					([DRP_ID]
					,[DRP_DMA_ID]
					,[DRP_BUM_ID]
					,[DRP_Year]
					,[DRP_Quarter]
					,[DRP_DetailAmount]
					,[DRP_IsInit]
					,[DRP_ReturnId]
					,[DRP_ReturnNo]
					,[DRP_ReturnLotId]
					,[DRP_Sku]
					,[DRP_LotNumber]
					,[DRP_QrCode]
					,[DRP_ReturnQty]
					,[DRP_Price]
					,[DRP_Type]
					,[DRP_Desc]
					,[DRP_REV1]
					,[DRP_REV2]
					,[DRP_REV3]
					,[DRP_CreateDate]
					,[DRP_CreateUser]
					,[DRP_CreateUserName]
					,[DRP_IsActived])
			SELECT [DRP_ID]
					,[DRP_DMA_ID]
					,[DRP_BUM_ID]
					,[DRP_Year]
					,[DRP_Quarter]
					,[DRP_DetailAmount]
					,[DRP_IsInit]
					,[DRP_ReturnId]
					,[DRP_ReturnNo]
					,[DRP_ReturnLotId]
					,[DRP_Sku]
					,[DRP_LotNumber]
					,[DRP_QrCode]
					,[DRP_ReturnQty]
					,[DRP_Price]
					,[DRP_Type]
					,[DRP_Desc]
					,[DRP_REV1]
					,[DRP_REV2]
					,[DRP_REV3]
					,[DRP_CreateDate]
					,[DRP_CreateUser]
					,[DRP_CreateUserName] 
					,[DRP_IsActived]
				FROM #TMP_DealerReturnPosition
		END

	--�������ͨ����������޸ĺ���˻�����
	IF @IsApproval = 1
		BEGIN
			UPDATE InventoryAdjustLot SET InventoryAdjustLot.IAL_LotQty = T.IAL_LotQtyNew
			FROM #TMP_DETAIL AS T
			WHERE T.IAL_ID = InventoryAdjustLot.IAL_ID

			UPDATE InventoryAdjustDetail SET InventoryAdjustDetail.IAD_Quantity = QTY
			FROM (SELECT IAD_ID, SUM(IAL_LotQtyNew) AS QTY FROM #TMP_DETAIL
			GROUP BY IAD_ID) AS T
			WHERE T.IAD_ID = InventoryAdjustDetail.IAD_ID
		END
		
	SET @ReturnValue = '1'		        	

	--��¼��־
	INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_Message,IL_ClientID,IL_BatchNbr) 
	VALUES (NEWID(),'P_I_EW_GoodsReturn',GETDATE(),GETDATE(),'Success','�ӿڵ��óɹ���ReturnNo = '+@ReturnNo+' IsApproval = '+CONVERT(NVARCHAR(50),@IsApproval)+' Detail = '+@Detail,'SYS',@BatchNbr)

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
	SET @ReturnValue = ERROR_MESSAGE()	

	--��¼��־
	INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_Message,IL_ClientID,IL_BatchNbr) 
	VALUES (NEWID(),'P_I_EW_GoodsReturn',GETDATE(),GETDATE(),'Failure','�ӿڵ���ʧ�ܣ�ReturnNo = '+@ReturnNo+' IsApproval = '+CONVERT(NVARCHAR(50),@IsApproval)+' Detail = '+@Detail+' ������Ϣ��' + ERROR_MESSAGE(),'SYS',@BatchNbr)

    return -1
    
END CATCH





GO


