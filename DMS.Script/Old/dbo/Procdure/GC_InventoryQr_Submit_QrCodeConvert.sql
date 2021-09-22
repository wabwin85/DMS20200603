DROP Procedure [dbo].[GC_InventoryQr_Submit_QrCodeConvert]
GO

/*
����������Ӳ�Ʒ
*/
CREATE Procedure [dbo].[GC_InventoryQr_Submit_QrCodeConvert]
	@DealerId uniqueidentifier,
	@QrCode NVARCHAR(50),
	@NewQrCode  NVARCHAR(50),
	@LotString NVARCHAR(1000),
	@LotNumber NVARCHAR(50),
	@Upn NVARCHAR(100),
	@User uniqueidentifier,
	@HeadId uniqueidentifier,
	@PMAId uniqueidentifier,
	@NewWhId uniqueidentifier,
    @RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(1000) OUTPUT
AS
   
	DECLARE @IsReg bit
    CREATE TABLE #TMP_CHECK(
		LotId uniqueidentifier,
		PMA_ID uniqueidentifier,
		Qty decimal(18,6),
		DeductionQty decimal(18,6),
		IsReg bit,
		ErrorDesc NVARCHAR(50),
		WHM_ID uniqueidentifier,
		Price decimal(18,6),
		id uniqueidentifier,
		Inv_Id uniqueidentifier
    )
    
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
		DECLARE @UpnSum DECIMAL(18,6) 
	 
		SELECT @UpnSum = SUM(ISNULL(ShipmentLot.SLT_LotShippedQty,0))
        FROM ShipmentHeader 
		INNER JOIN ShipmentLine(nolock) ON ShipmentHeader.SPH_ID = ShipmentLine.SPL_SPH_ID
        INNER JOIN ShipmentLot(nolock) ON ShipmentLine.SPL_ID = ShipmentLot.SLT_SPL_ID
        INNER JOIN Lot(nolock) ON ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID) = Lot.LOT_ID
        INNER JOIN Product(nolock) ON Product.PMA_ID = ShipmentLine.SPL_Shipment_PMA_ID
        INNER JOIN CFN(nolock) ON CFN.CFN_ID = Product.PMA_CFN_ID
        INNER JOIN LotMaster(nolock) ON LotMaster.LTM_ID = Lot.LOT_LTM_ID
        INNER JOIN Warehouse(nolock) ON ShipmentLot.SLT_WHM_ID = Warehouse.WHM_ID
        INNER JOIN Hospital(nolock) ON ShipmentHeader.SPH_Hospital_HOS_ID = Hospital.HOS_ID
        WHERE CFN.CFN_CustomerFaceNbr = @Upn 
		AND CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 THEN substring(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber)
        - CHARINDEX('@@', LTM_LotNumber, 0)) ELSE 'NoQR' END = @QrCode
        AND  CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 THEN substring(LotMaster.LTM_LotNumber, 1, CHARINDEX('@@', LotMaster.LTM_LotNumber,
        0) - 1) ELSE LTM_LotNumber END = @LotNumber
        AND ShipmentHeader.SPH_Dealer_DMA_ID = @DealerId
        AND ShipmentHeader.SPH_Status = 'Complete'
        
		--�жϸ����εĶ�ά���Ƿ��Ѿ�ȫ�����滻
        IF(@UpnSum>0)
			BEGIN
	
				IF NOT EXISTS(SELECT 1 FROM ShipmentLot WHERE SLT_ID IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@LotString,',')) 
					GROUP BY ISNULL(SLT_QRLOT_ID,SLT_LOT_ID) HAVING SUM(SLT_LotShippedQty)>
						(SELECT SUM(ISNULL(ShipmentLot.SLT_LotShippedQty,0))
							FROM ShipmentHeader(nolock) 
							INNER JOIN ShipmentLine(nolock) ON ShipmentHeader.SPH_ID = ShipmentLine.SPL_SPH_ID
							INNER JOIN ShipmentLot(nolock) ON ShipmentLine.SPL_ID = ShipmentLot.SLT_SPL_ID
							INNER JOIN Lot(nolock) ON ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID) = Lot.LOT_ID
							INNER JOIN Product(nolock) ON Product.PMA_ID = ShipmentLine.SPL_Shipment_PMA_ID
							INNER JOIN CFN(nolock) ON CFN.CFN_ID = Product.PMA_CFN_ID
							INNER JOIN LotMaster(nolock) ON LotMaster.LTM_ID = Lot.LOT_LTM_ID
							INNER JOIN Warehouse(nolock) ON ShipmentLot.SLT_WHM_ID = Warehouse.WHM_ID
							INNER JOIN Hospital(nolock) ON ShipmentHeader.SPH_Hospital_HOS_ID = Hospital.HOS_ID
							WHERE CFN.CFN_CustomerFaceNbr = @Upn 
							AND CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 THEN SUBSTRING(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber)
							- CHARINDEX('@@', LTM_LotNumber, 0)) ELSE 'NoQR' END =@QrCode
							AND CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 THEN SUBSTRING(LotMaster.LTM_LotNumber, 1, CHARINDEX('@@', LotMaster.LTM_LotNumber,
							0) - 1) ELSE LTM_LotNumber END = @LotNumber
							AND ShipmentHeader.SPH_Dealer_DMA_ID = @DealerId
							AND ShipmentHeader.SPH_Status='Complete'
						)
					)
					BEGIN

						--���ѡ��Ķ�ά���Ƿ��Ӧ��UPN
						IF EXISTS(SELECT 1 FROM Inventory(nolock) 
										INNER JOIN Lot(nolock) ON Inventory.INV_ID = Lot.LOT_INV_ID 
										INNER JOIN LotMaster(nolock) ON LotMaster.LTM_ID = Lot.LOT_LTM_ID
										INNER JOIN Product(nolock) ON Product.PMA_ID = Inventory.INV_PMA_ID 
										INNER JOIN CFN(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
										INNER JOIN Warehouse(nolock) ON Warehouse.WHM_ID = Inventory.INV_WHM_ID
									WHERE CFN.CFN_CustomerFaceNbr = @Upn
										AND LotMaster.LTM_LotNumber = @LotNumber + '@@' + @NewQrCode 
										AND Warehouse.WHM_DMA_ID = @DealerId
										AND (Warehouse.WHM_Type = 'Normal' OR Warehouse.WHM_Type = 'DefaultWH')
										AND CFN_DeletedFlag = '0')
							BEGIN
								--�����ά���Ѿ����ڣ���У����
								SET @IsReg=1
								INSERT INTO #TMP_CHECK 
								SELECT
									Lot.LOT_ID,
									Product.PMA_ID,
									Lot.LOT_OnHandQty,
									0,
									0,
									null,
									Warehouse.WHM_ID,
									0,
									NEWID(),
									Inventory.INV_ID 
								FROM  Inventory(nolock) 
									INNER JOIN Lot(nolock) ON Inventory.INV_ID = Lot.LOT_INV_ID
									INNER JOIN LotMaster(nolock) ON LotMaster.LTM_ID = Lot.LOT_LTM_ID 
									INNER JOIN Product(nolock) on Product.PMA_ID = Inventory.INV_PMA_ID
									INNER JOIN CFN(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID 
									INNER JOIN Warehouse(nolock) ON Warehouse.WHM_ID = Inventory.INV_WHM_ID
								WHERE CFN.CFN_CustomerFaceNbr = @Upn 
									AND LotMaster.LTM_LotNumber = @LotNumber + '@@' + @NewQrCode 
									AND Warehouse.WHM_DMA_ID = @DealerId
									AND (Warehouse.WHM_Type = 'Normal' OR Warehouse.WHM_Type = 'DefaultWH') 
									AND CFN_DeletedFlag = '0' 
									AND Warehouse.WHM_ID = @NewWhId 
									AND LOT_OnHandQty>0  
								ORDER BY Warehouse.WHM_Type,LOT_OnHandQty DESC

								--У���¶�ά���Ʒ�����Ƿ��㹻
								UPDATE #TMP_CHECK SET ErrorDesc = '�¶�ά���Ʒ��������',IsReg = 0
								WHERE EXISTS(SELECT 1 FROM ShipmentLot(nolock) WHERE SLT_ID IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@LotString,',')) 
													GROUP BY ISNULL(SLT_QRLOT_ID,SLT_LOT_ID) 
													HAVING SUM(SLT_LotShippedQty) > (SELECT SUM(ISNULL(Qty,0)) FROM #TMP_CHECK)
											)
							END
						ELSE
							BEGIN
							IF EXISTS(SELECT 1 FROM QRCodeMaster WHERE QRM_QRCode = @NewQrCode)
								BEGIN
									--�����ά�벻������У���ά��
									SET @IsReg = 0

									INSERT INTO #TMP_CHECK 
									SELECT
										Lot.LOT_ID,
										Product.PMA_ID,
										Lot.LOT_OnHandQty,
										0,
										0,
										null,
										Warehouse.WHM_ID,
										0,
										NEWID(),
										Inventory.INV_ID  
									FROM Inventory(nolock) 
										INNER JOIN Lot(nolock) ON Inventory.INV_ID = Lot.LOT_INV_ID
										INNER JOIN LotMaster(nolock) ON LotMaster.LTM_ID = Lot.LOT_LTM_ID 
										INNER JOIN Product(nolock) ON Product.PMA_ID = Inventory.INV_PMA_ID
										INNER JOIN CFN(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID 
										INNER JOIN Warehouse(nolock) ON Warehouse.WHM_ID = Inventory.INV_WHM_ID
									WHERE CFN.CFN_CustomerFaceNbr = @Upn 
										AND LotMaster.LTM_LotNumber = @LotNumber
										AND Warehouse.WHM_DMA_ID = @DealerId
										AND (Warehouse.WHM_Type='Normal' OR Warehouse.WHM_Type='DefaultWH') 
										AND CFN_DeletedFlag='0' 
										AND LOT_OnHandQty>0 
										AND Warehouse.WHM_ID=@NewWhId 
										ORDER BY Warehouse.WHM_Type,LOT_OnHandQty DESC

									--У���¶�ά���Ʒ�����Ƿ��㹻
									UPDATE #TMP_CHECK SET ErrorDesc = '�¶�ά���Ʒ��������',IsReg = 0
									WHERE EXISTS (SELECT 1 FROM ShipmentLot(nolock) WHERE SLT_ID IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@LotString,',')) 
									GROUP BY ISNULL(SLT_QRLOT_ID,SLT_LOT_ID) 
									HAVING SUM(SLT_LotShippedQty) > (SELECT SUM(ISNULL(Qty,0)) FROM #TMP_CHECK))
									--У���ά���Ƿ�����ʷ�����г��ֹ�
    							END
							ELSE
								BEGIN
									SET @RtnMsg = '��ά�벻����';
								END
						END
					END
				ELSE
					 BEGIN
						SET @RtnMsg = '�滻�Ĳ�Ʒ�������ô���ԭ�еĲ�Ʒ����'
					 END
			END
		ELSE
			BEGIN
				SET @RtnMsg = '�����β�Ʒ��ȫ���滻,'
			END

		--У���ά���Ƿ�����ʷ��������ʹ��
		IF EXISTS (SELECT 1 FROM ShipmentHeader(nolock) 
							INNER JOIN ShipmentLine(nolock) ON ShipmentHeader.SPH_ID = ShipmentLine.SPL_SPH_ID
							INNER JOIN ShipmentLot(nolock) ON ShipmentLine.SPL_ID = ShipmentLot.SLT_SPL_ID
							INNER JOIN Lot(nolock) ON ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID) = Lot.LOT_ID
							INNER JOIN LotMaster(nolock) ON LotMaster.LTM_ID = Lot.LOT_LTM_ID
						WHERE @DealerId = ShipmentHeader.SPH_Dealer_DMA_ID 
							AND ShipmentHeader.SPH_Status='Complete' 
							AND (@NewQrCode = CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 
													THEN substring(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber) - CHARINDEX('@@', LotMaster.LTM_LotNumber, 0)) 
												ELSE 'NoQR' END 
								) 
							AND CASE WHEN CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) > 0 
									THEN substring(LotMaster.LTM_LotNumber, CHARINDEX('@@', LotMaster.LTM_LotNumber, 0) + 2, LEN(LotMaster.LTM_LotNumber) - CHARINDEX('@@', LotMaster.LTM_LotNumber, 0)) 
								  ELSE 'NoQR' END <> 'NoQR' 
						GROUP BY ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID) 
						HAVING SUM(ISNULL(ShipmentLot.SLT_LotShippedQty,0)) + (SELECT SUM(ISNULL(SLT_LotShippedQty,0)) AS Qty FROM ShipmentLot WHERE SLT_ID IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@LotString,','))) > 1
					)
			--BEGIN
			--	SET @RtnMsg = @RtnMsg + '�¶�ά��������ʷ������ʹ��,'
			--END

		IF LEN(@RtnMsg) > 0
			BEGIN
				SET @RtnVal = 'Error'
			END
		ELSE
			BEGIN
				SELECT @RtnMsg=ErrorDesc FROM #TMP_CHECK WHERE ErrorDesc IS NOT NULL GROUP BY ErrorDesc
			END
   
IF(LEN(@RtnMsg) <= 0)
	BEGIN

	--���ɵ��ݺ�
	DECLARE @m_DmaId uniqueidentifier
	DECLARE @m_BuName nvarchar(50)
	DECLARE @m_Id uniqueidentifier
	DECLARE @m_OrderNo nvarchar(50)
	DECLARE @m_LineId uniqueidentifier
	DECLARE @m_BuId uniqueidentifier
	SELECT @m_BuId=SPH_ProductLine_BUM_ID from ShipmentHeader where SPH_ID=@HeadId
	SET @m_DmaId = @DealerId
    SELECT @m_BuName = ATTRIBUTE_NAME 
	FROM Lafite_ATTRIBUTE 
	WHERE Id IN (SELECT RootID FROM Cache_OrganizationUnits 
					WHERE AttributeID = Convert(varchar(36),@m_BuId)
				) 
		AND ATTRIBUTE_TYPE = 'BU'
	
	
	EXEC [GC_GetNextAutoNumber] @m_DmaId,'Next_ShipmentNbr',@m_BuName, @m_OrderNo OUTPUT
		
	--�½�������ʱ����
	--����ID
	SELECT @m_Id = NEWID()
	CREATE TABLE #tmp_header
	(
		SPH_ID	uniqueidentifier,
		SPH_Hospital_HOS_ID	uniqueidentifier,
		SPH_ShipmentNbr	nvarchar(30),
		SPH_Dealer_DMA_ID	uniqueidentifier,
		SPH_ShipmentDate	datetime,
		SPH_Status	nvarchar(50),
		SPH_Reverse_SPH_ID	uniqueidentifier,
		SPH_NoteForPumpSerialNbr	nvarchar(2000),
		SPH_Type	nvarchar(50),
		SPH_ProductLine_BUM_ID	uniqueidentifier,
		SPH_Shipment_User	uniqueidentifier,
		SPH_InvoiceNo	nvarchar(400),
		SPH_UpdateDate	datetime,
		SPH_SubmitDate	datetime,
		SPH_Office	nvarchar(200),
		SPH_InvoiceTitle	nvarchar(200),
		SPH_InvoiceDate	datetime,
		SPH_IsAuth	bit,
		SPH_InvoiceFirstDate	datetime,
		InputTime	datetime,
		DataType	nvarchar(50),
		AdjReason	nvarchar(50),
		AdjAction	nvarchar(50),
	)
	--���������۵���������ʱ����
	INSERT INTO #tmp_header(
			SPH_ID,
			SPH_Hospital_HOS_ID,
			SPH_ShipmentNbr,
			SPH_Dealer_DMA_ID,
			SPH_ShipmentDate,
			SPH_Status,
			SPH_Type,
			SPH_ProductLine_BUM_ID,
			SPH_Shipment_User,
			SPH_UpdateDate,
			SPH_SubmitDate,
			SPH_IsAuth
		)
	--������ʱ��
	SELECT @m_Id,
		SPH_Hospital_HOS_ID,
		@m_OrderNo,
		SPH_Dealer_DMA_ID,
		GETDATE(),
		'Complete',
		'Hospital',
		SPH_ProductLine_BUM_ID,
		@User,
		GETDATE()
		,GETDATE()
		,0 
	FROM ShipmentHeader(nolock) 
	WHERE SPH_ID = @HeadId
		
	--����Line��ʱ��
	CREATE TABLE #tmp_Line
	(
		SPL_ID uniqueidentifier,	
		SPL_SPH_ID uniqueidentifier,	
		SPL_Shipment_PMA_ID uniqueidentifier,
		SPL_ShipmentQty float,
		SPL_UnitPrice float,
		SPL_LineNbr int
	)
 
	--����LineId 
	SELECT @m_LineId=NEWID()
	--����Line�����ݷ�����ʱ��
	INSERT INTO #tmp_Line(SPL_ID,SPL_SPH_ID,SPL_Shipment_PMA_ID,SPL_ShipmentQty,SPL_UnitPrice,SPL_LineNbr)
	SELECT @m_LineId,@m_Id,SPL_Shipment_PMA_ID,0,SPL_UnitPrice,SPL_LineNbr 
	FROM ShipmentLine(nolock) WHERE SPL_SPH_ID = @HeadId AND SPL_Shipment_PMA_ID = @PMAId
 
	--����Ҫ�滻����ʷ��Ʒ��ʱ��
	CREATE TABLE #TMP_ShipmentLot
	(
		Id uniqueidentifier,
		SLT_ID uniqueidentifier,
		ShippedQty decimal(18,6),
		LOT_ID uniqueidentifier,
		WHM_ID uniqueidentifier,
		SLT_SPL_ID uniqueidentifier,
		UniTPrice decimal(18, 6),
		WHM_TYPE NVARCHAR(50),
		Ltm_ID uniqueidentifier
	)
     --������
	/*�����־��ʱ��*/
	CREATE TABLE #tmp_InventoryTransaction
	(
		ITR_Quantity float	,
		ITR_ID uniqueidentifier	,
		ITR_ReferenceID uniqueidentifier,
		ITR_Type nvarchar(50),	
		ITR_TransactionDate datetime,	
		ITR_WHM_ID uniqueidentifier,	
		ITR_PMA_ID uniqueidentifier,	
		ITR_UnitPrice float,	
		ITR_PostedDate datetime,	
		ITR_TransDescription nvarchar(4000)
	)

	CREATE TABLE #tmp_InventoryTransactionLot
	(
		ITL_Quantity float,
		ITL_ID uniqueidentifier,
		ITL_ITR_ID uniqueidentifier,
		ITL_LTM_ID uniqueidentifier,
		ITL_LotNumber nvarchar(50)
	)
		
	--��ѯ��Ҫ�˻�����ʷ��Ʒ���ݷ�����ʱ��
	INSERT INTO #TMP_ShipmentLot 
	SELECT
		NEWID(),
		SLT_ID,
		-SLT_LotShippedQty,
		ISNULL(SLT_QRLOT_ID,SLT_LOT_ID),
		SLT_WHM_ID,
		@m_LineId,
		ShipmentLot.SLT_UnitPrice,
		Warehouse.WHM_Type,
		LotMaster.LTM_ID
	FROM ShipmentLot(nolock) 
	INNER JOIN Warehouse(nolock) ON ShipmentLot.SLT_WHM_ID = Warehouse.WHM_ID 
	INNER JOIN Lot(nolock) ON ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID) = Lot.LOT_ID
	INNER JOIN LotMaster(nolock) ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
	WHERE ShipmentLot.SLT_ID IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@LotString,','))

	DECLARE @s_Id uniqueidentifier
	DECLARE @s_ShippedQty decimal(18,6)
	DECLARE @s_LotId uniqueidentifier
	DECLARE @s_WhmId uniqueidentifier
	DECLARE @s_SplId uniqueidentifier
	DECLARE @s_UniTPrice decimal(18, 6)
	DECLARE @s_WhmType NVARCHAR(50)
	DECLARE @s_Ltm_ID uniqueidentifier
	DECLARE @ITR_ID uniqueidentifier

	--����Ǽ��ۿ⣬����������ڸþ��������ֿ�
	DECLARE @i_InvId uniqueidentifier
	DECLARE @i_SumQty decimal(18, 6)
	DECLARE @i_LotId uniqueidentifier

	--�½��α�
    DECLARE	CurShipmentLot CURSOR 
	FOR SELECT Id,ShippedQty,LOT_ID,WHM_ID,SLT_SPL_ID,UniTPrice,WHM_TYPE,Ltm_ID FROM #TMP_ShipmentLot
	OPEN CurShipmentLot
	FETCH NEXT FROM CurShipmentLot INTO @s_Id,@s_ShippedQty,@s_LotId,@s_WhmId,@s_SplId,@s_UniTPrice,@s_WhmType,@s_Ltm_ID
	WHILE @@FETCH_STATUS = 0
		BEGIN
	
			--������Ǽ��ۿ�����⣬���������ԭ���ϱ������Ĳֿ�
			IF (@s_WhmType = 'DefaultWH' OR @s_WhmType = 'Normal' OR @s_WhmType = 'Frozen')
				BEGIN
					UPDATE Lot SET LOT_OnHandQty = LOT_OnHandQty + (-@s_ShippedQty)
					FROM #TMP_ShipmentLot,Inventory(nolock),Product(nolock),Warehouse(nolock),CFN(nolock)   
					WHERE (#TMP_ShipmentLot.WHM_TYPE = 'DefaultWH' OR #TMP_ShipmentLot.WHM_TYPE = 'Normal' OR #TMP_ShipmentLot.WHM_TYPE = 'Frozen') 
					AND #TMP_ShipmentLot.LOT_ID = Lot.LOT_ID  
					AND Lot.LOT_INV_ID = Inventory.INV_ID  
					AND Inventory.INV_PMA_ID = Product.PMA_ID
					AND Product.PMA_CFN_ID = CFN_ID 
					AND Inventory.INV_WHM_ID = Warehouse.WHM_ID
					AND Warehouse.WHM_DMA_ID = @DealerId 
					AND CFN.CFN_CustomerFaceNbr = @Upn
					AND #TMP_ShipmentLot.Id = @s_Id

					--���²�Ʒ���
					UPDATE Inventory SET INV_OnHandQuantity = INV_OnHandQuantity + (-@s_ShippedQty)
					FROM #TMP_ShipmentLot,Lot(nolock),Product(nolock),Warehouse(nolock),CFN(nolock)   
					WHERE (#TMP_ShipmentLot.WHM_TYPE = 'DefaultWH' OR #TMP_ShipmentLot.WHM_TYPE = 'Normal' OR #TMP_ShipmentLot.WHM_TYPE = 'Frozen') 
					AND #TMP_ShipmentLot.LOT_ID = Lot.LOT_ID  
					AND Lot.LOT_INV_ID = Inventory.INV_ID  
					AND Inventory.INV_PMA_ID = Product.PMA_ID
					AND Product.PMA_CFN_ID = CFN_ID 
					AND Inventory.INV_WHM_ID = Warehouse.WHM_ID
					AND Warehouse.WHM_DMA_ID = @DealerId 
					AND CFN.CFN_CustomerFaceNbr = @Upn
					AND #TMP_ShipmentLot.Id = @s_Id
        
					--�����������־��ʱ��
					SELECT @ITR_ID = NEWID()
					INSERT INTO #tmp_InventoryTransaction(ITR_Quantity,ITR_ID,ITR_ReferenceID,ITR_Type,ITR_TransactionDate,ITR_WHM_ID,ITR_PMA_ID,ITR_UnitPrice,ITR_TransDescription)
					VALUES(-@s_ShippedQty,@ITR_ID,@s_Id,'���۵���',GETDATE(),@s_WhmId,@PMAId,@s_UniTPrice,'���۵�����:'+@m_OrderNo+'����')
	   
					INSERT INTO  #tmp_InventoryTransactionLot(ITL_Quantity,ITL_ID,ITL_ITR_ID,ITL_LTM_ID,ITL_LotNumber)
					VALUES(-@s_ShippedQty,NEWID(),@ITR_ID,@s_Ltm_ID,@LotNumber)
				END
			ELSE IF(@s_WhmType='LP_Consignment' OR @s_WhmType='Consignment' OR @s_WhmType='Borrow' OR @s_WhmType='LP_Borrow')
				BEGIN
					SELECT @i_SumQty = SUM(ShipmentLot.SLT_LotShippedQty) FROM ShipmentLot WHERE ShipmentLot.SLT_ID IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@LotString,','))
					SELECT @i_InvId = NEWID()
					SELECT @i_LotId = NEWID()
					--������ֿⲻ��������Inventory���һ����¼
					IF NOT EXISTS(SELECT 1 FROM Inventory(nolock) 
										INNER JOIN Warehouse(nolock) ON INV_WHM_ID = Warehouse.WHM_ID 
										INNER JOIN Product(nolock) ON INV_PMA_ID = Product.PMA_ID  
									WHERE Warehouse.WHM_Type = 'DefaultWH' 
										AND WHM_DMA_ID = @DealerId 
										AND Product.PMA_UPN = @Upn
									)
						BEGIN
							INSERT INTO Inventory(INV_ID,INV_OnHandQuantity,INV_PMA_ID,INV_WHM_ID) 
							VALUES (@i_InvId,0,@PMAId,(SELECT WHM_ID FROM Warehouse WHERE WHM_Type='DefaultWH' AND WHM_DMA_ID=@DealerId))
						END
		
					--����ֿ�Id
					SELECT @i_InvId = INV_ID FROM Inventory 
					INNER JOIN Warehouse ON INV_WHM_ID = Warehouse.WHM_ID 
					INNER JOIN Product ON INV_PMA_ID = Product.PMA_ID
					WHERE Warehouse.WHM_Type = 'DefaultWH' 
					AND WHM_DMA_ID = @DealerId 
					AND Product.PMA_UPN = @Upn
	       
					UPDATE Inventory SET INV_OnHandQuantity = INV_OnHandQuantity + (-@s_ShippedQty) WHERE Inventory.INV_ID = @i_InvId
       
					--������ֿⲻ��������LOT����һ��
					IF NOT EXISTS (SELECT 1 FROM Lot WHERE Lot.LOT_INV_ID = @i_InvId AND LOT_LTM_ID = @s_Ltm_ID)
						BEGIN
							INSERT INTO Lot (LOT_ID,LOT_LTM_ID,LOT_OnHandQty,LOT_INV_ID)
							VALUES (@i_LotId,@s_Ltm_ID,0,@i_InvId)
						END 
	      
					SELECT TOP 1 @i_LotId = Lot.LOT_ID FROM Lot(nolock) WHERE Lot.LOT_INV_ID = @i_InvId AND LOT_LTM_ID = @s_Ltm_ID
               
					--������ʱ���е���ͬLotID �� LotId
					UPDATE #TMP_ShipmentLot SET LOT_ID = @i_LotId WHERE LOT_ID = @s_LotId

					--������ʱ���еĲֿ�
					UPDATE #TMP_ShipmentLot SET WHM_ID = (SELECT TOP 1 WHM_ID FROM Warehouse WHERE WHM_DMA_ID = @DealerId AND WHM_TYPE = 'DefaultWH') WHERE SLT_ID = @s_Id
		
					--����Lot�еĿ��
					UPDATE Lot SET LOT_OnHandQty = LOT_OnHandQty + (-@s_ShippedQty) WHERE LOT_ID = @i_LotId
	    
					SELECT @ITR_ID=NEWID()
					INSERT INTO #tmp_InventoryTransaction(ITR_Quantity,ITR_ID,ITR_ReferenceID,ITR_Type,ITR_TransactionDate,ITR_WHM_ID,ITR_PMA_ID,ITR_UnitPrice,ITR_TransDescription)
					VALUES(-@s_ShippedQty,@ITR_ID,@s_Id,'���۵���',GETDATE(),@s_WhmId,@PMAId,@s_UniTPrice,'���۵�����:' + @m_OrderNo + '����')
	   
					INSERT INTO  #tmp_InventoryTransactionLot(ITL_Quantity,ITL_ID,ITL_ITR_ID,ITL_LTM_ID,ITL_LotNumber)
					VALUES (-@s_ShippedQty,NEWID(),@ITR_ID,@s_Ltm_ID,@LotNumber)
				END
			FETCH NEXT FROM CurShipmentLot INTO @s_Id,@s_ShippedQty,@s_LotId,@s_WhmId,@s_SplId,@s_UniTPrice,@s_WhmType,@s_Ltm_ID
		END
	CLOSE CurShipmentLot
	DEALLOCATE CurShipmentLot
	 
	--�����µĶ�ά�����ۼ�¼
	--������ʱ��
	CREATE TABLE #TMP_NewShipmentLot
	(
		LotId uniqueidentifier,
		ShipQty decimal(18,6),
		UniTPrice decimal(18, 6),
		SplID uniqueidentifier,
		WHM_Id uniqueidentifier,
		DeductionQty decimal(18,6),
		Id uniqueidentifier
	)
	
	DECLARE @ne_LotId uniqueidentifier
	DECLARE @ne_PMA_ID uniqueidentifier
	DECLARE @ne_Qty  decimal(18,6)
	DECLARE @ne_DeductionQty decimal(18,6)
	DECLARE @ne_WHM_ID uniqueidentifier
	DECLARE @SUMQTY decimal(18,6)
	DECLARE @ne_Id uniqueidentifier
	DECLARE @SUMPRICE decimal(18,6)
	DECLARE @ne_Ltm_Id uniqueidentifier
	DECLARE @ne_InvId uniqueidentifier
	DECLARE @New_Id uniqueidentifier
     
	--��ȡҪ�滻�Ķ�ά���Ʒ������
	SELECT @SUMQTY=SUM(ShipmentLot.SLT_LotShippedQty) FROM ShipmentLot(nolock) 
	WHERE SLT_ID IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@LotString,','))

	--��ȡҪ�滻�Ķ�ά���Ʒ�ܼ۸�
	SELECT @SUMPRICE = SUM(ShipmentLot.SLT_LotShippedQty * ShipmentLot.SLT_UnitPrice) FROM ShipmentLot(nolock) 
	WHERE SLT_ID IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@LotString,','))
	
	DECLARE @A NVARCHAR(1000)  
	 --�½��α�
	DECLARE	CurChec CURSOR 
	FOR SELECT LotId,PMA_ID,Qty,WHM_ID,DeductionQty,Id,Inv_Id FROM #TMP_CHECK
	OPEN CurChec
	FETCH NEXT FROM CurChec INTO @ne_LotId,@ne_PMA_ID,@ne_Qty,@ne_WHM_ID,@ne_DeductionQty,@ne_Id,@ne_InvId
	WHILE @@FETCH_STATUS = 0
		--������
		BEGIN
    
			IF(@IsReg=1)
				BEGIN
					--����shiplot��id
					SELECT @New_Id = NEWID()
					--�������㹻
					IF(@SUMQTY <= @ne_Qty AND @SUMQTY > 0)
						BEGIN
							--������ʱ��Ŀ�������Ϳۼ�����
							UPDATE #TMP_CHECK SET Qty = Qty - @SUMQTY,DeductionQty = @SUMQTY WHERE id = @ne_Id

							--�����¶�ά����ʱ��
							INSERT INTO #TMP_NewShipmentLot(LotId,ShipQty,UniTPrice,SplID,WHM_Id,DeductionQty,Id)
							VALUES(@ne_LotId,@SUMQTY,((@SUMQTY/@SUMQTY) * @SUMPRICE),@m_LineId,@ne_WHM_ID,@ne_DeductionQty,@New_Id)
        
							--�������ε��еĿ��
							UPDATE Lot SET LOT_OnHandQty = LOT_OnHandQty - @SUMQTY WHERE LOT_ID = @ne_LotId
							--���²ֿ⵱�еĿ��
							UPDATE Inventory SET INV_OnHandQuantity = INV_OnHandQuantity - @SUMQTY WHERE INV_ID = @ne_InvId
         
							--��������¼��־ 
							SELECT @ITR_ID = NEWID()
							INSERT INTO #tmp_InventoryTransaction(ITR_Quantity,ITR_ID,ITR_ReferenceID,ITR_Type,ITR_TransactionDate,ITR_WHM_ID,ITR_PMA_ID,ITR_UnitPrice,ITR_TransDescription)
							VALUES(-@SUMQTY,@ITR_ID,@New_Id,'���۵���',GETDATE(),@ne_WHM_ID,@PMAId,@SUMPRICE,'���۵�����:' + @m_OrderNo + '�Ƴ�')
	
							INSERT INTO #tmp_InventoryTransactionLot(ITL_Quantity,ITL_ID,ITL_ITR_ID,ITL_LTM_ID,ITL_LotNumber)
							VALUES(-@SUMQTY,NEWID(),@ITR_ID,(SELECT LTM_ID FROM LotMaster WHERE LTM_LotNumber = @LotNumber + '@@' + @NewQrCode),@LotNumber)
							SET @SUMQTY = 0
						END
					--�����治��
					ELSE
						BEGIN
							-- ���¿��
							UPDATE #TMP_CHECK SET Qty = @SUMQTY - Qty,DeductionQty = @SUMQTY WHERE id = @ne_Id
							--�����¶�ά����ʱ��
			
							INSERT INTO #TMP_NewShipmentLot(LotId,ShipQty,UniTPrice,SplID,WHM_Id,DeductionQty,Id)
							VALUES(@ne_LotId,@ne_Qty,((@ne_Qty / @SUMQTY) * @SUMPRICE),@m_LineId,@ne_WHM_ID,@ne_DeductionQty,NEWID())
			
							--�������ε��еĿ��
							UPDATE Lot SET LOT_OnHandQty = 0 WHERE LOT_ID = @ne_LotId
							--���²ֿ⵱�еĿ��
			
							UPDATE Inventory SET INV_OnHandQuantity = INV_OnHandQuantity - @SUMQTY WHERE INV_ID = @ne_InvId
							SET @SUMQTY = @SUMQTY - @ne_Qty
						END
				END
			ELSE
				BEGIN
					--����һ������
					SELECT @ne_Ltm_Id=NEWID()
	   
					INSERT INTO LotMaster (LTM_ID,LTM_LotNumber,LTM_CreatedDate,LTM_Product_PMA_ID)
					VALUES(@ne_Ltm_Id,@LotNumber + '@@' + @NewQrCode,GETDATE(),@PMAId)
	   
					--�������ε�lot
					INSERT INTO Lot (LOT_ID,LOT_LTM_ID,LOT_OnHandQty,LOT_INV_ID)
					VALUES(@ne_Ltm_Id,@ne_Ltm_Id,0,@ne_InvId)

					--�����¶�ά����ʱ��
					INSERT INTO #TMP_NewShipmentLot(LotId,ShipQty,UniTPrice,SplID,WHM_Id,DeductionQty,Id)
					VALUES(@ne_LotId,@ne_Qty,0,@m_LineId,@ne_WHM_ID,@SUMQTY,NEWID())
          
					--�ۼ�NoQR�Ŀ��
					UPDATE Lot SET LOT_OnHandQty = LOT_OnHandQty - @SUMQTY WHERE LOT_ID = @ne_LotId

					--���²ֿ⵱�еĿ��
					UPDATE Inventory set INV_OnHandQuantity = INV_OnHandQuantity - @SUMQTY WHERE INV_ID = @ne_InvId
				END

			FETCH NEXT FROM CurChec INTO @ne_LotId,@ne_PMA_ID,@ne_Qty,@ne_WHM_ID,@ne_DeductionQty,@ne_Id,@ne_InvId
		END
	CLOSE CurChec
	DEALLOCATE CurChec

	--����������
	INSERT INTO ShipmentHeader (
		SPH_ID,
		SPH_Hospital_HOS_ID,
		SPH_ShipmentNbr,
		SPH_Dealer_DMA_ID,
		SPH_ShipmentDate,
		SPH_Status,
		SPH_Type,
		SPH_ProductLine_BUM_ID,
		SPH_Shipment_User,
		SPH_UpdateDate,
		SPH_SubmitDate,
		SPH_IsAuth,
		SPH_NoteForPumpSerialNbr	
	) 
	SELECT 
		SPH_ID,
		SPH_Hospital_HOS_ID,
		SPH_ShipmentNbr,
		SPH_Dealer_DMA_ID,
		SPH_ShipmentDate,
		SPH_Status,
		SPH_Type,
		SPH_ProductLine_BUM_ID,
		SPH_Shipment_User,
		SPH_UpdateDate,
		SPH_SubmitDate,
		SPH_IsAuth,
		'��ά���滻:'+@NewQrCode+'�滻'+@QrCode
	FROM #tmp_header
		
		
	--����Line��
	INSERT INTO ShipmentLine 
	(
		SPL_ID,	
		SPL_SPH_ID,	
		SPL_Shipment_PMA_ID,
		SPL_ShipmentQty,
		SPL_UnitPrice,
		SPL_LineNbr
	) 
	SELECT   
		SPL_ID,	
		SPL_SPH_ID,	
		SPL_Shipment_PMA_ID,
		SPL_ShipmentQty,
		SPL_UnitPrice,
		SPL_LineNbr 
	FROM #tmp_Line
    
	--�������ۼ�¼������ϸ��
	INSERT INTO ShipmentLot(SLT_SPL_ID,SLT_LotShippedQty,SLT_LOT_ID,SLT_ID,SLT_WHM_ID,SLT_UnitPrice,AdjType,AdjReason,InputTime,ShipmentDate,AdjAction)
	SELECT SLT_SPL_ID,ShippedQty,LOT_ID,Id,WHM_ID,UniTPrice,'Adj','��ά���滻',GETDATE(),GETDATE(),'Add' FROM #TMP_ShipmentLot
       
	--�������ۼ�¼������ϸ��
	INSERT INTO ShipmentLot(SLT_SPL_ID,SLT_LotShippedQty,SLT_LOT_ID,SLT_ID,SLT_WHM_ID,SLT_UnitPrice,AdjType,AdjReason,InputTime,ShipmentDate,AdjAction)
	SELECT SplID,ShipQty,LotId,Id,WHM_Id,UniTPrice,'Adj','��ά���滻',GETDATE(),GETDATE(),'Add' FROM #TMP_NewShipmentLot  
	
	--��¼��������־
	INSERT INTO InventoryTransaction(ITR_Quantity,ITR_ID,ITR_ReferenceID,ITR_Type,ITR_TransactionDate,ITR_WHM_ID,ITR_PMA_ID,ITR_UnitPrice,ITR_TransDescription)
	SELECT ITR_Quantity,ITR_ID,ITR_ReferenceID,ITR_Type,ITR_TransactionDate,ITR_WHM_ID,ITR_PMA_ID,ITR_UnitPrice,ITR_TransDescription FROM #tmp_InventoryTransaction
	
	INSERT INTO InventoryTransactionLot(ITL_Quantity,ITL_ID,ITL_ITR_ID,ITL_LTM_ID,ITL_LotNumber)
	SELECT ITL_Quantity,ITL_ID,ITL_ITR_ID,ITL_LTM_ID,ITL_LotNumber FROM #tmp_InventoryTransactionLot

	 --��¼������־
	UPDATE interface.T_I_WC_DealerBarcodeQRcodeScan 
	SET QRC_DataHandleRemark = ISNULL(QRC_DataHandleRemark,'') + ('��'+CONVERT(NVARCHAR(50),GETDATE(),120)+'ִ�ж�ά�����,��������:' + CAST((select SUM(ShipmentLot.SLT_LotShippedQty) FROM ShipmentLot 
    WHERE SLT_ID IN (SELECT VAL FROM dbo.GC_Fn_SplitStringToTable(@LotString,','))) AS NVARCHAR(100)))
	WHERE QRC_LOT = @LotNumber AND QRC_DMA_ID = @DealerId AND QRC_QRCode = @QrCode  
	
	--��¼���۵���־
	INSERT INTO PurchaseOrderLog
	SELECT NEWID(),SPH_ID,@User,GETDATE(),'CreateShipment','��ά���滻:'+@NewQrCode+'�滻'+@QrCode FROM #tmp_header

	
END
ELSE
SET @RtnVal = 'Error'
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '2��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
  
    return -1
    
END CATCH
GO


