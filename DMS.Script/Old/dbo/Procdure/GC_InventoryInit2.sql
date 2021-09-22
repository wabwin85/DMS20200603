DROP Procedure [dbo].[GC_InventoryInit2]
GO


CREATE Procedure [dbo].[GC_InventoryInit2]
    @UserId uniqueidentifier,
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
    DECLARE @ErrorCount INTEGER
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

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
LOT_LotNumber nvarchar(20),
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
ITL_LotNumber        nvarchar(20)         collate Chinese_PRC_CI_AS,
ITL_WHM_ID           uniqueidentifier,
ITL_PMA_ID           uniqueidentifier,
primary key (ITL_ID)
)
/*�Ƚ������־��Ϊ0*/
UPDATE InventoryInit SET II_ErrorFlag = 0 WHERE II_USER = @UserId

/*��龭�����Ƿ����*/
UPDATE InventoryInit SET II_DMA_ID = DealerMaster.DMA_ID
FROM DealerMaster WHERE DealerMaster.DMA_SAP_Code = InventoryInit.II_SAP_CODE
AND InventoryInit.II_SAP_CODE_ErrMsg IS NULL AND II_USER = @UserId

UPDATE InventoryInit SET II_SAP_CODE_ErrMsg = '�����̲�����'
WHERE II_SAP_CODE_ErrMsg IS NULL AND II_DMA_ID IS NULL AND II_USER = @UserId

/*��鵼����û��Ƿ����ڵ����ļ��еľ�����*/
UPDATE InventoryInit SET II_SAP_CODE_ErrMsg = '�����û������ڵ����ļ��еľ�����'
WHERE II_SAP_CODE_ErrMsg IS NULL AND II_USER = @UserId 
AND NOT EXISTS (SELECT 1 FROM dbo.Lafite_IDENTITY WHERE Id = @UserId and Corp_ID = II_DMA_ID)

/*���ֲֿ��Ƿ����*/
UPDATE InventoryInit SET II_WHM_ID = 
(SELECT TOP 1 WHM_ID FROM Warehouse WHERE Warehouse.WHM_DMA_ID = InventoryInit.II_DMA_ID
AND Warehouse.WHM_Name = InventoryInit.II_WHM_NAME)
WHERE InventoryInit.II_WHM_NAME_ErrMsg IS NULL AND II_USER = @UserId

UPDATE InventoryInit SET II_WHM_NAME_ErrMsg = '�ֲֿⲻ����'
WHERE II_WHM_NAME_ErrMsg IS NULL AND II_WHM_ID IS NULL AND II_USER = @UserId

/*���CFN�Ƿ����*/
UPDATE InventoryInit SET II_CFN_ID = CFN.CFN_ID, II_PMA_ID = Product.PMA_ID, II_PMA_UPN = Product.PMA_UPN
FROM CFN 
INNER JOIN Product ON Product.PMA_CFN_ID = CFN.CFN_ID
WHERE CFN.CFN_CustomerFaceNbr = InventoryInit.II_CFN
AND InventoryInit.II_CFN_ErrMsg IS NULL AND II_USER = @UserId

UPDATE InventoryInit SET II_CFN_ErrMsg = '��Ʒ�ͺŲ�����'
WHERE II_CFN_ErrMsg IS NULL AND II_CFN_ID IS NULL AND II_USER = @UserId


--Added By Song Yuqi On 2015-06-11
--�ж�С��λ
UPDATE InventoryInit SET II_QTY_ErrMsg='��С��λ��'+CONVERT(NVARCHAR(10),1/(PMA_ConvertFactor)) FROM Product 
WHERE PMA_ID = II_PMA_ID AND II_QTY_ErrMsg IS NULL AND II_QTY_ErrMsg IS NULL AND II_USER = @UserId AND 
(CONVERT(decimal(18,6),II_QTY)*1000000)%((CONVERT(decimal(18,6),1)/CONVERT(decimal(18,6),PMA_ConvertFactor))*1000000) != 0



/* ��鵼���CFN�Ƿ�������Ʒ�߹��� */
--UPDATE InventoryInit SET II_CFN_ErrMsg = '��Ʒ�߻��Ʒ����δ����'
--WHERE II_CFN_ErrMsg IS NULL AND II_USER = @UserId
--and exists (select 1 from CFN where CFN_ID = II_CFN_ID 
--and (CFN_ProductLine_BUM_ID is null or CFN_ProductCatagory_PCT_ID is null))

UPDATE InventoryInit SET II_CFN_ErrMsg = '��Ʒ�߻��Ʒ����δ����'
WHERE II_CFN_ErrMsg IS NULL AND II_USER = @UserId
and exists (select 1 from CFN INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr where CFN_ID = II_CFN_ID 
and CFN_ProductLine_BUM_ID is null)

	
/*��鵼���CFN�Ƿ��ڿ���г��ֹ�*/	
UPDATE InventoryInit SET II_CFN_ErrMsg = '��Ʒ�ڲֿ����Ѵ���'
WHERE II_CFN_ErrMsg IS NULL AND II_USER = @UserId
and exists (select 1 from Inventory
where Inventory.INV_WHM_ID in (SELECT WHM_ID FROM Warehouse where WHM_DMA_ID = 
(SELECT TOP 1 II_DMA_ID FROM InventoryInit WHERE II_USER = @UserId))
and Inventory.INV_WHM_ID = II_WHM_ID and Inventory.INV_PMA_ID = II_PMA_ID
)

/* ����Ʒ���κ��Ƿ���� */
UPDATE InventoryInit SET II_LTM_ID = LotMaster.LTM_ID
FROM LotMaster WHERE LotMaster.LTM_LotNumber = InventoryInit.II_LTM_LotNumber
AND LotMaster.LTM_Product_PMA_ID = InventoryInit.II_PMA_ID
AND InventoryInit.II_CFN_ErrMsg IS NULL
AND InventoryInit.II_LTM_LotNumber_ErrMsg IS NULL AND II_USER = @UserId

UPDATE InventoryInit SET II_LTM_LotNumber_ErrMsg = '��Ʒ���Ų�����'
WHERE II_CFN_ErrMsg IS NULL
AND II_LTM_LotNumber_ErrMsg IS NULL AND II_LTM_ID IS NULL AND II_USER = @UserId

/* ���ͬһ��Ʒͬһ���κ��Ƿ���Ч����ͬ */
UPDATE InventoryInit SET II_LTM_ExpiredDate_ErrMsg = 'ͬ���κŵ���Ч�ڱ�����ͬ'
WHERE EXISTS (SELECT 1 FROM InventoryInit T 
WHERE T.II_CFN_ErrMsg IS NULL AND T.II_LTM_LotNumber_ErrMsg IS NULL 
AND T.II_LTM_ExpiredDate_ErrMsg IS NULL AND T.II_USER = @UserId
AND T.II_CFN = InventoryInit.II_CFN AND T.II_LTM_LotNumber = InventoryInit.II_LTM_LotNumber
AND T.II_LTM_ExpiredDate <> InventoryInit.II_LTM_ExpiredDate)
AND InventoryInit.II_CFN_ErrMsg IS NULL AND InventoryInit.II_LTM_LotNumber_ErrMsg IS NULL 
AND InventoryInit.II_LTM_ExpiredDate_ErrMsg IS NULL AND InventoryInit.II_USER = @UserId

UPDATE InventoryInit SET II_ErrorFlag = 1
WHERE II_USER = @UserId
AND (II_SAP_CODE_ErrMsg IS NOT NULL OR II_WHM_NAME_ErrMsg IS NOT NULL OR II_CFN_ErrMsg IS NOT NULL
OR II_LTM_LotNumber_ErrMsg IS NOT NULL OR II_LTM_ExpiredDate_ErrMsg IS NOT NULL OR II_QTY_ErrMsg IS NOT NULL)

/*����Ƿ���ڴ���*/
SELECT @ErrorCount = COUNT(*) FROM InventoryInit WHERE II_ErrorFlag = 1 AND II_USER = @UserId

IF @ErrorCount > 0
	BEGIN
		/*������ڴ����򷵻�Error*/
		SET @IsValid = 'Error'
	END
ELSE
	BEGIN
		/*��������ڴ����򷵻�Success����ִ�г�ʼ�����Ĳ���*/		
		SET @IsValid = 'Success'

		--TODO: 20130806 @������Ҫ�����Ƿ���Ҫȥ���ⲽ������֮ǰҪ��֤���ϵ����κ��Ƿ����LotMaster�У���Ҫ��֤�Ƿ�ͬһ����ͬһ������Ч�ڲ�ͬ����
		--��Ϊ����/���к���Ψһ��
		/*���������ڵ�����/���к�*/
		/*
		INSERT INTO LotMaster (LTM_ID, LTM_LotNumber, LTM_ExpiredDate, LTM_Product_PMA_ID, LTM_CreatedDate)
		SELECT NEWID(), II_LTM_LotNumber, II_LTM_ExpiredDate, II_PMA_ID, GETDATE() FROM (
		SELECT DISTINCT II_LTM_LotNumber, II_LTM_ExpiredDate, II_PMA_ID FROM InventoryInit
		WHERE InventoryInit.II_ErrorFlag = 0 AND II_USER = @UserId
		AND NOT EXISTS (SELECT 1 FROM LotMaster
		WHERE LotMaster.LTM_LotNumber = InventoryInit.II_LTM_LotNumber
		AND LotMaster.LTM_Product_PMA_ID = InventoryInit.II_PMA_ID)) AS a
		*/
		
		/*��������/���кŸ���LTM_ID*/
		/*
		UPDATE InventoryInit SET II_LTM_ID = LotMaster.LTM_ID
		FROM LotMaster WHERE LotMaster.LTM_LotNumber = InventoryInit.II_LTM_LotNumber
		AND LotMaster.LTM_Product_PMA_ID = InventoryInit.II_PMA_ID
		AND InventoryInit.II_ErrorFlag = 0 AND II_USER = @UserId
		*/
		
		/*ɾ��Lot��Inventory�����ε��벻��Ҫ�������*/
		/*
		DELETE FROM Lot WHERE LOT_INV_ID IN (
		SELECT INV_ID FROM Inventory WHERE INV_WHM_ID IN(
		SELECT WHM_ID FROM Warehouse WHERE WHM_DMA_ID 
		= (SELECT TOP 1 II_DMA_ID FROM InventoryInit WHERE II_ErrorFlag = 0 AND II_USER = @UserId)))
		
		DELETE FROM Inventory WHERE INV_WHM_ID IN(
		SELECT WHM_ID FROM Warehouse WHERE WHM_DMA_ID 
		= (SELECT TOP 1 II_DMA_ID FROM InventoryInit WHERE II_ErrorFlag = 0 AND II_USER = @UserId))
		*/
		
		/*��ʼ�����*/
		INSERT INTO #tmp_inventory (INV_ID, INV_WHM_ID, INV_PMA_ID, INV_OnHandQuantity)
		SELECT NEWID(), II_WHM_ID, II_PMA_ID, II_QTY FROM
		(SELECT II_WHM_ID, II_PMA_ID, SUM(CONVERT(FLOAT,II_QTY)) AS II_QTY FROM InventoryInit
		WHERE II_ErrorFlag = 0 AND II_USER = @UserId
		GROUP BY II_WHM_ID, II_PMA_ID) AS a
		
		INSERT INTO #tmp_lot (LOT_ID, LOT_LTM_ID, LOT_WHM_ID, LOT_PMA_ID, LOT_LotNumber, LOT_OnHandQty)
		SELECT NEWID(), II_LTM_ID, II_WHM_ID, II_PMA_ID, II_LTM_LotNumber, II_QTY FROM
		(SELECT II_LTM_ID, II_WHM_ID, II_PMA_ID, II_LTM_LotNumber, SUM(CONVERT(FLOAT,II_QTY)) AS II_QTY FROM InventoryInit
		WHERE II_ErrorFlag = 0 AND II_USER = @UserId
		GROUP BY II_LTM_ID, II_WHM_ID, II_PMA_ID, II_LTM_LotNumber) AS a
		
		UPDATE #tmp_lot SET LOT_INV_ID = a.INV_ID
		FROM #tmp_inventory a 
		WHERE a.INV_PMA_ID = #tmp_lot.LOT_PMA_ID
		AND a.INV_WHM_ID = #tmp_lot.LOT_WHM_ID

		/*��¼��������־*/
		INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
		SELECT INV_OnHandQuantity, NEWID(), '00000000-0000-0000-0000-000000000000', '������', INV_WHM_ID, INV_PMA_ID, 0, '�����ε���'
		FROM #tmp_inventory

		INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_WHM_ID, ITL_PMA_ID)
		SELECT LOT_OnHandQty, NEWID(), LOT_LTM_ID, LOT_LotNumber, LOT_WHM_ID, LOT_PMA_ID
		FROM #tmp_lot	

		UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
		FROM #tmp_invtrans a 
		WHERE a.ITR_PMA_ID = #tmp_invtranslot.ITL_PMA_ID
		AND a.ITR_WHM_ID = #tmp_invtranslot.ITL_WHM_ID

		/*���������־��*/
		INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
		SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID FROM #tmp_inventory
		
		INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
		SELECT LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID FROM #tmp_lot

		INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
		SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

		INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
		SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot

		/*ɾ���ϴ�����*/
		DELETE FROM InventoryInit WHERE II_USER = @UserId
		
	END 
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    return -1
    
END CATCH




GO


