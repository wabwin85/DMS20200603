DROP PROCEDURE [dbo].[GC_InventoryQr_Submit_Transfer]
GO


CREATE PROCEDURE [dbo].[GC_InventoryQr_Submit_Transfer]
	@UserId uniqueidentifier,
	@DealerId uniqueidentifier,
	@ProductLineId uniqueidentifier,	
	@TransferType nvarchar(50),
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(2000) OUTPUT
AS 
	DECLARE @SysUserId uniqueidentifier;
	DECLARE @VENDORID uniqueidentifier;
	DECLARE @WarehouseTypeCode nvarchar(20);
SET NOCOUNT ON
BEGIN TRY
	
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	
	CREATE TABLE #TransferHeader(
		[TRN_ID] [uniqueidentifier] NOT NULL,
		[TRN_TransferNumber] [nvarchar](30) NULL,
		[TRN_FromDealer_DMA_ID] [uniqueidentifier] NULL,
		[TRN_Status] [nvarchar](50) NOT NULL,
		[TRN_ToDealer_DMA_ID] [uniqueidentifier] NULL,
		[TRN_Type] [nvarchar](50) NOT NULL,
		[TRN_Description] [nvarchar](2000) NULL,
		[TRN_Reverse_TRN_ID] [uniqueidentifier] NULL,
		[TRN_TransferDate] [datetime] NULL,
		[TRN_ProductLine_BUM_ID] [uniqueidentifier] NULL,
		[TRN_Transfer_USR_UserID] [uniqueidentifier] NULL
	)

	CREATE TABLE #TransferLine(
		[TRL_TRN_ID] [uniqueidentifier] NOT NULL,
		[TRL_TransferPart_PMA_ID] [uniqueidentifier] NOT NULL,
		[TRL_ID] [uniqueidentifier] NOT NULL,
		[TRL_FromWarehouse_WHM_ID] [uniqueidentifier] NOT NULL,
		[TRL_ToWarehouse_WHM_ID] [uniqueidentifier] NULL,
		[TRL_TransferQty] [float] NOT NULL,
		[TRL_LineNbr] [int] NULL
	)

	CREATE TABLE #TransferLot(
		[TLT_TRL_ID] [uniqueidentifier] NOT NULL,
		[TLT_LOT_ID] [uniqueidentifier] NOT NULL,
		[TLT_ID] [uniqueidentifier] NOT NULL,
		[TLT_TransferLotQty] [float] NOT NULL,
		[IAL_QRLOT_ID] [uniqueidentifier] NULL,
		[IAL_QRLotNumber] [nvarchar](50) NULL
	)
	
	IF @TransferType = 'Transfer'
		SET @WarehouseTypeCode = 0
	ELSE IF @TransferType = 'TransferConsignment'
		SET @WarehouseTypeCode = 1
	ELSE 
		RAISERROR ('TransferType is empty or not exists.', 16, 1)

	SELECT IO_Id AS ID,
		IO_DMA_ID AS DealerId,
		IO_CFN_ID AS CfnId,
		IO_PMA_ID AS PmaId,
		IO_Lot_Id AS LotId,
		IO_QRC_ID AS QrcId,
		INV_ID AS InvId,
		WHM_ID AS WhmId,
		WHM_Type AS WarehouseType,
		null AS WarehouseTypeCode,
		IO_LotNumber AS LotNumber,
		IO_BarCode AS BarCode,
		IO_Qty AS Qty,
		IO_ToWarehouseId AS ToWhmId,
		CFN_ProductLine_BUM_ID AS ProductLineId,
		CAST(null AS uniqueidentifier) AS TrnId,
		CAST(null AS uniqueidentifier) AS TrlId,
		CAST(null AS uniqueidentifier) AS TltId,
		LOT_LTM_ID AS LTM_ID,
	    NEWID() AS	TLT_ID,
	    NULL AS Error_Messinge 
		 INTO #TEMP
	 FROM InventoryQROperation 
	INNER JOIN CFN ON CFN_ID = IO_CFN_ID
	INNER JOIN Lot ON LOT_ID = IO_Lot_Id
	INNER JOIN Inventory ON INV_ID = LOT_INV_ID
	INNER JOIN Warehouse ON WHM_ID = INV_WHM_ID
	WHERE WHM_Type IN ('Normal','DefaultWH','Consignment','LP_Consignment','Frozen')
	AND CFN_ProductLine_BUM_ID = @ProductLineId
	AND IO_CreateUser = @UserId
	AND IO_OperationType = 'Transfer'
	AND EXISTS (SELECT 1 FROM interface.T_I_WC_DealerBarcodeQRcodeScan 
						WHERE QRC_ID = IO_QRC_ID
							AND QRC_Status = 'New'
				)

	UPDATE #TEMP SET WarehouseTypeCode = 0 WHERE WarehouseType IN ('Normal','DefaultWH','Frozen')
	UPDATE #TEMP SET WarehouseTypeCode = 1 WHERE WarehouseType IN ('Consignment','LP_Consignment')
	UPDATE #TEMP SET WarehouseTypeCode = 2 WHERE WarehouseType IN ('Borrow')

	--ɾ����ʱ���е������ֿ�Ŀ��
	DELETE FROM #TEMP WHERE WarehouseTypeCode != @WarehouseTypeCode

	SELECT NEWID() AS Id,
		WarehouseTypeCode INTO #TransferHeadId_TEMP
	FROM #TEMP GROUP BY WarehouseTypeCode

	UPDATE #TEMP SET TrnId = #TransferHeadId_TEMP.Id FROM #TransferHeadId_TEMP
	WHERE #TransferHeadId_TEMP.WarehouseTypeCode = #TEMP.WarehouseTypeCode
	
	
	--�������ڲֿ�Ĳ�ͬ���ɲ�ͬ�����۳��ⵥ������Ϣ
	INSERT INTO #TransferHeader
			([TRN_ID]
			,[TRN_TransferNumber]
			,[TRN_FromDealer_DMA_ID]
			,[TRN_Status]
			,[TRN_ToDealer_DMA_ID]
			,[TRN_Type]
			,[TRN_Description]
			,[TRN_Reverse_TRN_ID]
			,[TRN_TransferDate]
			,[TRN_ProductLine_BUM_ID]
			,[TRN_Transfer_USR_UserID])
	SELECT TrnId,NULL,DealerId,'Draft',NULL,'Transfer',NULL,NULL,GETDATE(),@ProductLineId,@UserId FROM #TEMP
	WHERE WarehouseType IN ('Normal','DefaultWH','Frozen')
	GROUP BY TrnId,DealerId,ProductLineId
	UNION 
	SELECT TrnId,NULL,DealerId,'Draft',NULL,'TransferConsignment',NULL,NULL,GETDATE(),@ProductLineId,@UserId FROM #TEMP
	WHERE WarehouseType IN ('Consignment','LP_Consignment')
	GROUP BY TrnId,DealerId,ProductLineId
	UNION 
	SELECT TrnId,NULL,DealerId,'Draft',NULL,'TransferBorrow',NULL,NULL,GETDATE(),@ProductLineId,@UserId FROM #TEMP
	WHERE WarehouseType IN ('Borrow')
	GROUP BY TrnId,DealerId,ProductLineId

	SELECT NEWID() AS Id,
		TrnId,PmaId,WhmId,ToWhmId INTO #TransferLineId_TEMP
	FROM #TEMP 
	GROUP BY TrnId,PmaId,WhmId,ToWhmId

	UPDATE #TEMP SET TrlId = #TransferLineId_TEMP.Id FROM #TransferLineId_TEMP
	WHERE #TransferLineId_TEMP.TrnId = #TEMP.TrnId
	AND #TransferLineId_TEMP.PmaId = #TEMP.PmaId
	AND #TransferLineId_TEMP.WhmId = #TEMP.WhmId
	AND #TransferLineId_TEMP.ToWhmId = #TEMP.ToWhmId

	INSERT INTO #TransferLine([TRL_TRN_ID]
							,[TRL_TransferPart_PMA_ID]
							,[TRL_ID]
							,[TRL_FromWarehouse_WHM_ID]
							,[TRL_ToWarehouse_WHM_ID]
							,[TRL_TransferQty]
							,[TRL_LineNbr])
	SELECT TrnId,PmaId,TrlId,WhmId,ToWhmId,SUM(Qty) AS Qty,ROW_NUMBER() OVER(PARTITION BY TrnId ORDER BY PmaId) AS LineNbr FROM #TEMP 
	GROUP BY TrnId,TrlId,PmaId,WhmId,ToWhmId

	INSERT INTO #TransferLot
			   ([TLT_TRL_ID]
				,[TLT_LOT_ID]
				,[TLT_ID]
				,[TLT_TransferLotQty]
				,[IAL_QRLOT_ID]
				,[IAL_QRLotNumber])
	SELECT TrlId,LotId,TLT_ID,Qty,NULL,NULL FROM #TEMP

BEGIN TRAN

	INSERT INTO [dbo].[Transfer]
           ([TRN_ID]
           ,[TRN_TransferNumber]
           ,[TRN_FromDealer_DMA_ID]
           ,[TRN_Status]
           ,[TRN_ToDealer_DMA_ID]
           ,[TRN_Type]
           ,[TRN_Description]
           ,[TRN_Reverse_TRN_ID]
           ,[TRN_TransferDate]
           ,[TRN_ProductLine_BUM_ID]
           ,[TRN_Transfer_USR_UserID])
	SELECT [TRN_ID]
           ,[TRN_TransferNumber]
           ,[TRN_FromDealer_DMA_ID]
           ,[TRN_Status]
           ,[TRN_ToDealer_DMA_ID]
           ,[TRN_Type]
           ,[TRN_Description]
           ,[TRN_Reverse_TRN_ID]
           ,[TRN_TransferDate]
           ,[TRN_ProductLine_BUM_ID]
           ,[TRN_Transfer_USR_UserID] FROM #TransferHeader
	
	INSERT INTO [dbo].[TransferLine]
           ([TRL_TRN_ID]
           ,[TRL_TransferPart_PMA_ID]
           ,[TRL_ID]
           ,[TRL_FromWarehouse_WHM_ID]
           ,[TRL_ToWarehouse_WHM_ID]
           ,[TRL_TransferQty]
           ,[TRL_LineNbr])
	SELECT [TRL_TRN_ID]
           ,[TRL_TransferPart_PMA_ID]
           ,[TRL_ID]
           ,[TRL_FromWarehouse_WHM_ID]
           ,[TRL_ToWarehouse_WHM_ID]
           ,[TRL_TransferQty]
           ,[TRL_LineNbr]
	FROM #TransferLine

	INSERT INTO [dbo].[TransferLot]
           ([TLT_TRL_ID]
           ,[TLT_LOT_ID]
           ,[TLT_ID]
           ,[TLT_TransferLotQty]
           ,[IAL_QRLOT_ID]
           ,[IAL_QRLotNumber])
	SELECT [TLT_TRL_ID]
           ,[TLT_LOT_ID]
           ,[TLT_ID]
           ,[TLT_TransferLotQty]
           ,[IAL_QRLOT_ID]
           ,[IAL_QRLotNumber]
	FROM #TransferLot

	--У�����Ƿ��㹻
	SELECT @RtnMsg = STUFF((SELECT CAST(','+'���κ�:' + LotNumber + ' ��ά��:' + QrCode + ' �����˿������,' AS NVARCHAR(2000)) FROM
	(
		SELECT
		Product.PMA_UPN AS UPN,
		V_LotMaster.LTM_LotNumber AS LotNumber,
		V_LotMaster.LTM_QrCode AS QRCode,
		Convert(decimal(18,6),Lot.LOT_OnHandQty) AS TotalQty,
		SUM(TransferLot.TLT_TransferLotQty) AS TransferQty
		FROM TransferLot
		INNER JOIN TransferLine ON TransferLot.TLT_TRL_ID = TransferLine.TRL_ID
		INNER JOIN Product ON TransferLine.TRL_TransferPart_PMA_ID = Product.PMA_ID
		INNER JOIN CFN ON Product.PMA_CFN_ID = CFN.CFN_ID
		INNER JOIN Warehouse ON TransferLine.TRL_FromWarehouse_WHM_ID = Warehouse.WHM_ID
		INNER JOIN Lot ON ISNULL(TransferLot.IAL_QRLOT_ID, TransferLot.TLT_LOT_ID) = Lot.LOT_ID
		INNER JOIN V_LotMaster ON Lot.LOT_LTM_ID = V_LotMaster.LTM_ID
		INNER JOIN Warehouse wh2 ON TransferLine.TRL_ToWarehouse_WHM_ID = wh2.WHM_ID
		WHERE TransferLine.TRL_TRN_ID in (SELECT #TransferHeader.TRN_ID FROM #TransferHeader)
		GROUP BY PMA_UPN,LTM_LotNumber,LTM_QrCode,Lot.LOT_OnHandQty
	) T
	WHERE TransferQty>TotalQty
	ORDER BY LotNumber,QRCode FOR XML PATH('')),1,1,'')
	
	IF(@RtnMsg <> '')
		BEGIN
			RAISERROR (@RtnMsg, 16, 1)
		END
        
	--��¼��־
	INSERT INTO PurchaseOrderLog
	SELECT NEWID(),TRN_ID,@UserId,GETDATE(),'CreateShipment','��ά���ռ�ҳ���ƿ�' FROM #TransferHeader

	--�ڿ���ϴ����м�¼��������
	UPDATE interface.T_I_WC_DealerBarcodeQRcodeScan 
	SET QRC_DataHandleRemark = ISNULL(QRC_DataHandleRemark,'') + ('��'+CONVERT(NVARCHAR(50),GETDATE(),120)+'ִ���ƿ�,�ƿ�����:'+CAST(Qty AS NVARCHAR(100)))
	FROM (SELECT QrcId,SUM(Qty) AS Qty FROM #TEMP GROUP BY QrcId) T
	WHERE QRC_ID = T.QrcId
	
	--�������ϱ����е�����
	DELETE FROM InventoryQROperation 
	WHERE IO_CreateUser = @UserId 
	AND EXISTS (SELECT 1 FROM CFN WHERE CFN_ID = IO_CFN_ID AND CFN_ProductLine_BUM_ID = @ProductLineId)
	AND IO_OperationType = 'Transfer'

    --lijie add 20160630
   /*�����ʱ��*/
	create table #tmp_inventory(
	INV_ID uniqueidentifier,
	INV_WHM_ID uniqueidentifier,
	INV_PMA_ID uniqueidentifier,
	INV_OnHandQuantity float,
	INV_TOWHM_ID uniqueidentifier,
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
	LOT_TO_WHM_ID uniqueidentifier,
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

	--�����α�
	DECLARE @TransferId uniqueidentifier;
	DECLARE @Transferpe nvarchar(50);

	DECLARE TransferCursor CURSOR FOR SELECT #TransferHeader.TRN_ID,#TransferHeader.TRN_Type
	FROM #TransferHeader
	
	--���α� 
	OPEN TransferCursor
    FETCH NEXT FROM TransferCursor INTO @TransferId,@Transferpe
    WHILE @@FETCH_STATUS = 0
    BEGIN
		--��ȡ�������
		DECLARE @TransferNumber NVARCHAR(50);
		DECLARE @NextAutoNbr NVarChar(50) ;
		DECLARE @m_BuName nvarchar(50);
		
		SELECT @m_BuName=ATTRIBUTE_NAME 
		FROM Lafite_ATTRIBUTE 
		WHERE Id IN 
		(
			SELECT RootID FROM Cache_OrganizationUnits WHERE AttributeID = Convert(varchar(36),@ProductLineId)
		) 
		AND ATTRIBUTE_TYPE = 'BU'		
		EXEC GC_GetNextAutoNumber @DealerId ,'Next_RentNbr', @m_BuName,@NextAutoNbr OUTPUT
		
		--������ʱ�����ź�״̬
		UPDATE #TransferHeader SET TRN_Status='Complete' ,TRN_TransferNumber=@NextAutoNbr
		WHERE TRN_ID=@TransferId
    
		FETCH NEXT FROM TransferCursor  INTO @TransferId,@Transferpe
	END

	CLOSE TransferCursor
	DEALLOCATE TransferCursor
   
    --����������ʱ��
    INSERT INTO #tmp_inventory(INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
    SELECT QTY,InvId,WhmId,PmaId FROM (SELECT PmaId,WhmId,InvId, SUM(#TEMP.Qty) AS QTY FROM #TEMP GROUP BY PmaId,WhmId,InvId)A

    --�����Ƴ��ֿ����
    UPDATE Inventory SET INV_OnHandQuantity=Inventory.INV_OnHandQuantity+(-#tmp_inventory.INV_OnHandQuantity)
    FROM #tmp_inventory WHERE Inventory.INV_ID=#tmp_inventory.INV_ID AND Inventory.INV_PMA_ID=#tmp_inventory.INV_PMA_ID
    AND Inventory.INV_WHM_ID=#tmp_inventory.INV_WHM_ID
    
	--�����ο�������ʱ��
    INSERT INTO #tmp_lot(LOT_ID,LOT_LTM_ID,LOT_WHM_ID,LOT_PMA_ID,LOT_INV_ID,LOT_OnHandQty,LOT_LotNumber)
    SELECT A.LotId,A.LTM_ID,A.WhmId,A.PmaId,A.InvId,A.QTY,A.LotNumber  FROM (SELECT #TEMP.LotId,#TEMP.LTM_ID,#TEMP.WhmId,#TEMP.PmaId,#TEMP.InvId,SUM(#TEMP.Qty)AS QTY,#TEMP.LotNumber FROM #TEMP GROUP BY #TEMP.LotId,#TEMP.LTM_ID,#TEMP.WhmId,#TEMP.PmaId,#TEMP.InvId,#TEMP.LotNumber)A
    
	--�������α�
    UPDATE Lot SET LOT_OnHandQty=Lot.LOT_OnHandQty+(-#tmp_lot.LOT_OnHandQty)
    FROM #tmp_lot WHERE lOT.LOT_ID=#tmp_lot.LOT_ID AND LOT.LOT_INV_ID=#tmp_lot.LOT_INV_ID
    AND LOT.LOT_LTM_ID=#tmp_lot.LOT_LTM_ID
    
	--��¼��־
    INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
			SELECT -Qty,NEWID(),#TEMP.TLT_ID,'ɨ���ƿ�',#TEMP.WhmId,#TEMP.PmaId,0,
			'�������ƿ⣺' + #TransferHeader.TRN_TransferNumber + '���Ӳֿ����Ƴ���'
			FROM #TEMP INNER JOIN #TransferHeader ON #TEMP.TrnId=#TransferHeader.TRN_ID
	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
			SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans
			
	--Lot������־���Ƴ��м��
    INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
			SELECT -D.Qty,NEWID(),D.LTM_ID,D.LotNumber+'@@'+D.BarCode,ITR.ITR_ID
			FROM #TEMP D INNER JOIN #tmp_invtrans ITR ON ITR.ITR_ReferenceID = D.TLT_ID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
			SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
	
	--�����ʱ��
    DELETE #tmp_inventory
    DELETE #tmp_lot
    DELETE #tmp_invtrans
    DELETE #tmp_invtranslot

    --��Ҫ����Ĳ�Ʒ�����Ϣ������ʱ��
    INSERT INTO #tmp_inventory(INV_OnHandQuantity, INV_ID, INV_TOWHM_ID, INV_PMA_ID)
    SELECT QTY,NEWID(),ToWhmId,PmaId FROM (SELECT PmaId,ToWhmId, SUM(#TEMP.Qty) AS QTY FROM #TEMP GROUP BY PmaId,ToWhmId)A
    
	--���¿����ʱ�����ڸ���
    UPDATE #tmp_inventory SET INV_ID=Inventory.INV_ID
    FROM Inventory WHERE #tmp_inventory.INV_PMA_ID=Inventory.INV_PMA_ID
    AND #tmp_inventory.INV_TOWHM_ID=Inventory.INV_WHM_ID
    
    --��������ֿ���棬���ڸ��£�����������
	UPDATE Inventory SET INV_OnHandQuantity=Inventory.INV_OnHandQuantity+#tmp_inventory.INV_OnHandQuantity
	FROM #tmp_inventory WHERE #tmp_inventory.INV_ID=Inventory.INV_ID

	INSERT INTO Inventory(INV_OnHandQuantity,INV_ID,INV_WHM_ID,INV_PMA_ID)
	SELECT INV_OnHandQuantity,INV_ID,INV_TOWHM_ID,INV_PMA_ID FROM #tmp_inventory WHERE Not EXISTS(SELECT 1 FROM Inventory 
	WHERE #tmp_inventory.INV_ID=Inventory.INV_ID)
	
	 --�������Ʒ����������ʱ��
    INSERT INTO #tmp_lot(LOT_ID,LOT_LTM_ID,LOT_TO_WHM_ID,LOT_PMA_ID,LOT_OnHandQty,LOT_LotNumber)
    SELECT NEWID(),A.LTM_ID,A.ToWhmId,A.PmaId,A.QTY,A.LotNumber  FROM (SELECT #TEMP.LTM_ID,#TEMP.ToWhmId,#TEMP.PmaId,SUM(#TEMP.Qty)AS QTY,#TEMP.LotNumber FROM #TEMP GROUP BY #TEMP.LTM_ID,#TEMP.ToWhmId,#TEMP.PmaId,#TEMP.LotNumber)A
	
	--����������ʱ�����
    UPDATE #tmp_lot SET #tmp_lot.LOT_INV_ID=#tmp_inventory.INV_ID
    FROM #tmp_inventory WHERE #tmp_lot.LOT_PMA_ID=#tmp_inventory.INV_PMA_ID
    AND #tmp_lot.LOT_TO_WHM_ID=#tmp_inventory.INV_TOWHM_ID
      
	--�������ο����ڸ���,����������
	UPDATE Lot SET LOT.LOT_OnHandQty=LOT.LOT_OnHandQty+#tmp_lot.LOT_OnHandQty
	FROM #tmp_lot WHERE LOT.LOT_INV_ID=#tmp_lot.LOT_INV_ID
	AND LOT.LOT_LTM_ID=#tmp_lot.LOT_LTM_ID
    
    INSERT INTO Lot (LOT_ID,LOT_LTM_ID,LOT_OnHandQty,LOT_INV_ID)
    SELECT LOT_ID,LOT_LTM_ID,LOT_OnHandQty,LOT_INV_ID FROM #tmp_lot WHERE NOT EXISTS(SELECT 1 FROM Lot WHERE Lot.LOT_INV_ID=#tmp_lot.LOT_INV_ID
    AND LOT.LOT_LTM_ID=#tmp_lot.LOT_LTM_ID)
	
	 --��¼��־
    INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
			SELECT Qty,NEWID(),#TEMP.TLT_ID,'ɨ���ƿ�',#TEMP.ToWhmId,#TEMP.PmaId,0,
			 '�������ƿ⣺'+#TransferHeader.TRN_TransferNumber+'������ֿ⡣'
			FROM #TEMP INNER JOIN #TransferHeader ON #TEMP.TrnId=#TransferHeader.TRN_ID
	INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
			SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans
			
	--Lot������־���Ƴ��м��
    INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_ITR_ID)
			SELECT D.Qty,NEWID(),D.LTM_ID,D.LotNumber+'@@'+D.BarCode,ITR.ITR_ID
			FROM #TEMP D INNER JOIN #tmp_invtrans ITR ON ITR.ITR_ReferenceID = D.TLT_ID

	INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
			SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot
   --�޸Ķ���״̬Ϊ�����,�����ɵĶ������д��

   UPDATE [Transfer] SET TRN_Status = #TransferHeader.TRN_Status,TRN_TransferNumber = #TransferHeader.TRN_TransferNumber
   FROM #TransferHeader WHERE [Transfer].TRN_ID = #TransferHeader.TRN_ID
 
COMMIT TRAN

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
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH

GO


