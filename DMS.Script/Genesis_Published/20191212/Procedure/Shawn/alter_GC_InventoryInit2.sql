
/****** Object:  StoredProcedure [dbo].[GC_InventoryInit2]    Script Date: 2019/12/11 19:55:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[GC_InventoryInit2]
    @UserId uniqueidentifier,
    @IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
    DECLARE @ErrorCount INTEGER
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

/*库存临时表*/
create table #tmp_inventory(
INV_ID uniqueidentifier,
INV_WHM_ID uniqueidentifier,
INV_PMA_ID uniqueidentifier,
INV_OnHandQuantity float
primary key (INV_ID)
)
/*库存明细Lot临时表*/
create table #tmp_lot(
LOT_ID uniqueidentifier,
LOT_LTM_ID uniqueidentifier,
LOT_WHM_ID uniqueidentifier,
LOT_PMA_ID uniqueidentifier,
LOT_INV_ID uniqueidentifier,
LOT_OnHandQty float,
LOT_LotNumber nvarchar(30),
primary key (LOT_ID)
)

/*库存日志临时表*/
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
/*库存明细Lot日志临时表*/
create table #tmp_invtranslot(
ITL_Quantity         float,
ITL_ID               uniqueidentifier,
ITL_ITR_ID           uniqueidentifier,
ITL_LTM_ID           uniqueidentifier,
ITL_LotNumber        nvarchar(30)         collate Chinese_PRC_CI_AS,
ITL_WHM_ID           uniqueidentifier,
ITL_PMA_ID           uniqueidentifier,
primary key (ITL_ID)
)
/*先将错误标志设为0*/
UPDATE InventoryInit SET II_ErrorFlag = 0 WHERE II_USER = @UserId

/*检查经销商是否存在*/
UPDATE InventoryInit SET II_DMA_ID = DealerMaster.DMA_ID
FROM DealerMaster WHERE DealerMaster.DMA_SAP_Code = InventoryInit.II_SAP_CODE
AND InventoryInit.II_SAP_CODE_ErrMsg IS NULL AND II_USER = @UserId

UPDATE InventoryInit SET II_SAP_CODE_ErrMsg = '经销商不存在'
WHERE II_SAP_CODE_ErrMsg IS NULL AND II_DMA_ID IS NULL AND II_USER = @UserId

/*检查导入的用户是否属于导入文件中的经销商*/
UPDATE InventoryInit SET II_SAP_CODE_ErrMsg = '导入用户不属于导入文件中的经销商'
WHERE II_SAP_CODE_ErrMsg IS NULL AND II_USER = @UserId 
AND NOT EXISTS (SELECT 1 FROM dbo.Lafite_IDENTITY WHERE Id = @UserId and Corp_ID = II_DMA_ID)

/*检查分仓库是否存在*/
UPDATE InventoryInit SET II_WHM_ID = 
(SELECT TOP 1 WHM_ID FROM Warehouse WHERE Warehouse.WHM_DMA_ID = InventoryInit.II_DMA_ID
AND Warehouse.WHM_Name = InventoryInit.II_WHM_NAME)
WHERE InventoryInit.II_WHM_NAME_ErrMsg IS NULL AND II_USER = @UserId

UPDATE InventoryInit SET II_WHM_NAME_ErrMsg = '分仓库不存在'
WHERE II_WHM_NAME_ErrMsg IS NULL AND II_WHM_ID IS NULL AND II_USER = @UserId

/*检查CFN是否存在*/
UPDATE InventoryInit SET II_CFN_ID = CFN.CFN_ID, II_PMA_ID = Product.PMA_ID, II_PMA_UPN = Product.PMA_UPN
FROM CFN 
INNER JOIN Product ON Product.PMA_CFN_ID = CFN.CFN_ID
WHERE CFN.CFN_CustomerFaceNbr = InventoryInit.II_CFN
AND InventoryInit.II_CFN_ErrMsg IS NULL AND II_USER = @UserId

UPDATE InventoryInit SET II_CFN_ErrMsg = '产品型号不存在'
WHERE II_CFN_ErrMsg IS NULL AND II_CFN_ID IS NULL AND II_USER = @UserId


--Added By Song Yuqi On 2015-06-11
--判断小数位
UPDATE InventoryInit SET II_QTY_ErrMsg='最小单位：'+CONVERT(NVARCHAR(10),1/(PMA_ConvertFactor)) FROM Product 
WHERE PMA_ID = II_PMA_ID AND II_QTY_ErrMsg IS NULL AND II_QTY_ErrMsg IS NULL AND II_USER = @UserId AND 
(CONVERT(decimal(18,6),II_QTY)*1000000)%((CONVERT(decimal(18,6),1)/CONVERT(decimal(18,6),PMA_ConvertFactor))*1000000) != 0



/* 检查导入的CFN是否做过产品线关联 */
--UPDATE InventoryInit SET II_CFN_ErrMsg = '产品线或产品分类未关联'
--WHERE II_CFN_ErrMsg IS NULL AND II_USER = @UserId
--and exists (select 1 from CFN where CFN_ID = II_CFN_ID 
--and (CFN_ProductLine_BUM_ID is null or CFN_ProductCatagory_PCT_ID is null))

UPDATE InventoryInit SET II_CFN_ErrMsg = '产品线或产品分类未关联'
WHERE II_CFN_ErrMsg IS NULL AND II_USER = @UserId
and exists (select 1 from CFN INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr where CFN_ID = II_CFN_ID 
and CFN_ProductLine_BUM_ID is null)

	
/*检查导入的CFN是否在库存中出现过*/	
UPDATE InventoryInit SET II_CFN_ErrMsg = '产品在仓库中已存在'
WHERE II_CFN_ErrMsg IS NULL AND II_USER = @UserId
and exists (select 1 from Inventory
where Inventory.INV_WHM_ID in (SELECT WHM_ID FROM Warehouse where WHM_DMA_ID = 
(SELECT TOP 1 II_DMA_ID FROM InventoryInit WHERE II_USER = @UserId))
and Inventory.INV_WHM_ID = II_WHM_ID and Inventory.INV_PMA_ID = II_PMA_ID
)

/* 检查产品批次号是否存在 */
UPDATE InventoryInit SET II_LTM_ID = LotMaster.LTM_ID
FROM LotMaster WHERE LotMaster.LTM_LotNumber = InventoryInit.II_LTM_LotNumber
AND LotMaster.LTM_Product_PMA_ID = InventoryInit.II_PMA_ID
AND InventoryInit.II_CFN_ErrMsg IS NULL
AND InventoryInit.II_LTM_LotNumber_ErrMsg IS NULL AND II_USER = @UserId

UPDATE InventoryInit SET II_LTM_LotNumber_ErrMsg = '产品批号不存在'
WHERE II_CFN_ErrMsg IS NULL
AND II_LTM_LotNumber_ErrMsg IS NULL AND II_LTM_ID IS NULL AND II_USER = @UserId

/* 检查同一产品同一批次号是否有效期相同 */
UPDATE InventoryInit SET II_LTM_ExpiredDate_ErrMsg = '同批次号的有效期必须相同'
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

/*检查是否存在错误*/
SELECT @ErrorCount = COUNT(*) FROM InventoryInit WHERE II_ErrorFlag = 1 AND II_USER = @UserId

IF @ErrorCount > 0
	BEGIN
		/*如果存在错误，则返回Error*/
		SET @IsValid = 'Error'
	END
ELSE
	BEGIN
		/*如果不存在错误，则返回Success，并执行初始化库存的操作*/		
		SET @IsValid = 'Success'

		--TODO: 20130806 @这里需要讨论是否需要去除这步，并在之前要验证物料的批次号是否存在LotMaster中，还要验证是否同一物料同一批次有效期不同？！
		--认为批次/序列号是唯一的
		/*新增不存在的批次/序列号*/
		/*
		INSERT INTO LotMaster (LTM_ID, LTM_LotNumber, LTM_ExpiredDate, LTM_Product_PMA_ID, LTM_CreatedDate)
		SELECT NEWID(), II_LTM_LotNumber, II_LTM_ExpiredDate, II_PMA_ID, GETDATE() FROM (
		SELECT DISTINCT II_LTM_LotNumber, II_LTM_ExpiredDate, II_PMA_ID FROM InventoryInit
		WHERE InventoryInit.II_ErrorFlag = 0 AND II_USER = @UserId
		AND NOT EXISTS (SELECT 1 FROM LotMaster
		WHERE LotMaster.LTM_LotNumber = InventoryInit.II_LTM_LotNumber
		AND LotMaster.LTM_Product_PMA_ID = InventoryInit.II_PMA_ID)) AS a
		*/
		
		/*根据批次/序列号更新LTM_ID*/
		/*
		UPDATE InventoryInit SET II_LTM_ID = LotMaster.LTM_ID
		FROM LotMaster WHERE LotMaster.LTM_LotNumber = InventoryInit.II_LTM_LotNumber
		AND LotMaster.LTM_Product_PMA_ID = InventoryInit.II_PMA_ID
		AND InventoryInit.II_ErrorFlag = 0 AND II_USER = @UserId
		*/
		
		/*删除Lot和Inventory表，二次导入不需要清空数据*/
		/*
		DELETE FROM Lot WHERE LOT_INV_ID IN (
		SELECT INV_ID FROM Inventory WHERE INV_WHM_ID IN(
		SELECT WHM_ID FROM Warehouse WHERE WHM_DMA_ID 
		= (SELECT TOP 1 II_DMA_ID FROM InventoryInit WHERE II_ErrorFlag = 0 AND II_USER = @UserId)))
		
		DELETE FROM Inventory WHERE INV_WHM_ID IN(
		SELECT WHM_ID FROM Warehouse WHERE WHM_DMA_ID 
		= (SELECT TOP 1 II_DMA_ID FROM InventoryInit WHERE II_ErrorFlag = 0 AND II_USER = @UserId))
		*/
		
		/*初始化库存*/
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

		/*记录库存操作日志*/
		INSERT INTO #tmp_invtrans (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription)
		SELECT INV_OnHandQuantity, NEWID(), '00000000-0000-0000-0000-000000000000', '补充库存', INV_WHM_ID, INV_PMA_ID, 0, '库存二次导入'
		FROM #tmp_inventory

		INSERT INTO #tmp_invtranslot (ITL_Quantity, ITL_ID, ITL_LTM_ID, ITL_LotNumber, ITL_WHM_ID, ITL_PMA_ID)
		SELECT LOT_OnHandQty, NEWID(), LOT_LTM_ID, LOT_LotNumber, LOT_WHM_ID, LOT_PMA_ID
		FROM #tmp_lot	

		UPDATE #tmp_invtranslot SET ITL_ITR_ID = a.ITR_ID
		FROM #tmp_invtrans a 
		WHERE a.ITR_PMA_ID = #tmp_invtranslot.ITL_PMA_ID
		AND a.ITR_WHM_ID = #tmp_invtranslot.ITL_WHM_ID

		/*插入库存和日志表*/
		INSERT INTO Inventory (INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID)
		SELECT INV_OnHandQuantity, INV_ID, INV_WHM_ID, INV_PMA_ID FROM #tmp_inventory
		
		INSERT INTO Lot (LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID)
		SELECT LOT_ID, LOT_LTM_ID, LOT_OnHandQty, LOT_INV_ID FROM #tmp_lot

		INSERT INTO InventoryTransaction (ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, ITR_TransactionDate)
		SELECT ITR_Quantity, ITR_ID, ITR_ReferenceID, ITR_Type, ITR_WHM_ID, ITR_PMA_ID, ITR_UnitPrice, ITR_TransDescription, GETDATE() FROM #tmp_invtrans

		INSERT INTO InventoryTransactionLot (ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber)
		SELECT ITL_Quantity, ITL_ID, ITL_ITR_ID, ITL_LTM_ID, ITL_LotNumber FROM #tmp_invtranslot

		/*删除上传数据*/
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



