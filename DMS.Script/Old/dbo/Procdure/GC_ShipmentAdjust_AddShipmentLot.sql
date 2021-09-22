DROP PROCEDURE [dbo].[GC_ShipmentAdjust_AddShipmentLot]
GO



/*
销售调整更新ShipmentLot
*/
CREATE PROCEDURE [dbo].[GC_ShipmentAdjust_AddShipmentLot]
	@SphId					UNIQUEIDENTIFIER,
	@DealerId				UNIQUEIDENTIFIER,
	@HosId					UNIQUEIDENTIFIER,
	@ShipmentDate			DATETIME,
	@Reason					NVARCHAR(100),
	@RtnVal					NVARCHAR(20) OUTPUT,
	@RtnMsg					NVARCHAR(1000) OUTPUT
AS
	DECLARE @RecodeCount INTEGER
	DECLARE @SltId UNIQUEIDENTIFIER
	DECLARE @TotalQty DECIMAL(18,6)
	DECLARE @TotalPrice DECIMAL(18,6)
	DECLARE @ProductId UNIQUEIDENTIFIER

	SET  NOCOUNT ON

	BEGIN TRY
	BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''

	CREATE TABLE #TEMP
	(
		SphId UNIQUEIDENTIFIER,
		SplId UNIQUEIDENTIFIER,
		SalId UNIQUEIDENTIFIER,
		LotId UNIQUEIDENTIFIER,
		PmaId UNIQUEIDENTIFIER,
		WhmId UNIQUEIDENTIFIER,
		Qty DECIMAL(18,6),
		Price DECIMAL(18,6),
		NewSltId  UNIQUEIDENTIFIER,
		ActualShipmentDate DATETIME
	)
	
	CREATE TABLE #ShipmentLine_Temp
	(
		SPL_ID UNIQUEIDENTIFIER,
		SPL_SPH_ID UNIQUEIDENTIFIER,
		SPL_Shipment_PMA_ID UNIQUEIDENTIFIER,
		SPL_ShipmentQty DECIMAL(18,6),
		SPL_UnitPrice DECIMAL(18,6),
		SPL_LineNbr INT
	)
	
	INSERT INTO #TEMP 
	SELECT @SphId,NULL,SAL_ID,SAL_LOT_ID,INV_PMA_ID,INV_WHM_ID,
	CASE WHEN SAL_Type = 'Inventory' THEN SAL_ShipmentQty WHEN SAL_Type = 'Shipment' THEN SAL_ShipmentQty * -1 END AS ShipmentQty 
	,SAL_ShipmentPrice,SAL_New_SLT_ID,NULL FROM ShipmentAdjustLot 
	INNER JOIN Lot ON LOT_ID = SAL_LOT_ID
	INNER JOIN Inventory ON INV_ID = LOT_INV_ID
	WHERE SAL_SPH_ID = @SphId

	--SELECT *,CAST(SAL_ShipmentQty AS INT) AS SAL_ShipmentQty1,SAL_ShipmentQty-CAST(SAL_ShipmentQty AS INT) AS SAL_ShipmentQty2 INTO #ShipmentAdjustLot_TEMP 
	--FROM ShipmentAdjustLot 
	--WHERE SAL_SPH_ID = @SphId

	--INSERT INTO #TEMP 
	--SELECT @SphId,NULL,SAL_ID,SAL_LOT_ID,INV_PMA_ID,INV_WHM_ID,
	--CASE WHEN SAL_Type = 'Inventory' THEN 1 WHEN SAL_Type = 'Shipment' THEN 1 * -1 END AS ShipmentQty 
	--,SAL_ShipmentPrice,SAL_New_SLT_ID,null FROM #ShipmentAdjustLot_TEMP 
	--INNER JOIN Lot ON LOT_ID = SAL_LOT_ID
	--INNER JOIN Inventory ON INV_ID = LOT_INV_ID
	--INNER JOIN master..spt_values B ON SAL_ShipmentQty1>B.number
	--WHERE SAL_SPH_ID = @SphId
	--AND B.type='P'
	--UNION ALL 
	--SELECT @SphId,NULL,SAL_ID,SAL_LOT_ID,INV_PMA_ID,INV_WHM_ID,
	--CASE WHEN SAL_Type = 'Inventory' THEN SAL_ShipmentQty2 WHEN SAL_Type = 'Shipment' THEN SAL_ShipmentQty2 * -1 END AS ShipmentQty 
	--,SAL_ShipmentPrice,SAL_New_SLT_ID,null FROM #ShipmentAdjustLot_TEMP 
	--INNER JOIN Lot ON LOT_ID = SAL_LOT_ID
	--INNER JOIN Inventory ON INV_ID = LOT_INV_ID
	--INNER JOIN master..spt_values B ON SAL_ShipmentQty2>B.number
	--WHERE SAL_SPH_ID = @SphId
	--AND B.type='P'
	--AND SAL_ShipmentQty2 <> 0

	--UPDATE #TEMP SET NewSltId = NEWID(),ActualShipmentDate = ShipmentDate FROM ShipmentLot
	--INNER JOIN ShipmentLine ON SPL_ID = SLT_SPL_ID
	--WHERE SPL_SPH_ID = 'DF014A6E-5C2A-454A-98BA-2F1DE1D79513'
	--AND SLT_LOT_ID = LotId
	--AND NewSltId IS NULL
	
	UPDATE #TEMP SET NewSltId = NEWID() --WHERE NewSltId IS NULL

	SELECT @TotalQty = SUM(ISNULL(Qty,0)),@TotalPrice = SUM(ISNULL(Qty,0)*ISNULL(Price,0)) FROM #TEMP

	SELECT @RecodeCount = COUNT(1) FROM #TEMP

	IF @RecodeCount = 0
		SET @RtnMsg = '请添加历史销售数据和库存调整数据！'

	--IF @TotalQty <> 0
	--	SET @RtnMsg = @RtnMsg + '历史销售数量和调整数量总和不为0'

	--IF @TotalPrice <> 0
	--	SET @RtnMsg = @RtnMsg + '$$历史销售数量和调整金额总和不为0'

	IF LEN(@RtnMsg) > 0
		SET @RtnVal = 'Error'

	IF @RtnVal = 'Success'
		BEGIN
			
			INSERT INTO #ShipmentLine_Temp(SPL_ID,SPL_SPH_ID,SPL_Shipment_PMA_ID,SPL_ShipmentQty,SPL_UnitPrice,SPL_LineNbr)
			SELECT NEWID(),@SphId,PmaId,SUM(Qty),NULL,ROW_NUMBER () OVER (PARTITION BY SphId ORDER BY Pmaid) FROM #TEMP
			GROUP BY SphId,PmaId

			UPDATE #TEMP SET SplId = SPL_ID FROM #ShipmentLine_Temp WHERE PmaId = SPL_Shipment_PMA_ID

			--清空主表下所有的批次数据
			DELETE FROM ShipmentLot WHERE EXISTS (SELECT 1 FROM ShipmentLine WHERE SPL_SPH_ID = @SphId AND SPL_ID = SLT_SPL_ID)

			--清空主表下所有的产品数据
			DELETE FROM ShipmentLine WHERE SPL_SPH_ID = @SphId

			--插入ShipmentLine表
			INSERT INTO ShipmentLine(SPL_ID,SPL_SPH_ID,SPL_Shipment_PMA_ID,SPL_ShipmentQty,SPL_UnitPrice,SPL_LineNbr)
			SELECT SPL_ID,SPL_SPH_ID,SPL_Shipment_PMA_ID,SPL_ShipmentQty,SPL_UnitPrice,SPL_LineNbr FROM #ShipmentLine_Temp

			--插入ShipmentLot表
			INSERT INTO ShipmentLot
				   (SLT_SPL_ID
				   ,SLT_LotShippedQty
				   ,SLT_LOT_ID
				   ,SLT_ID
				   ,SLT_WHM_ID
				   ,SLT_UnitPrice
				   ,AdjType
				   ,AdjReason
				   ,AdjAction
				   ,InputTime
				   ,ShipmentDate
				   ,Remark
				   ,SLT_CAH_ID
				   ,SLT_QRLOT_ID
				   ,SLT_QRLotNumber)
				SELECT SplId,Qty,LotId,NewSltId,WhmId,Price,'Adj',@Reason,NULL,GETDATE(),NULL,@Reason,NULL,NULL,NULL 
				FROM #TEMP

			--更新NewSltId
			UPDATE ShipmentAdjustLot SET SAL_New_SLT_ID = NewSltId FROM #TEMP WHERE SAL_ID = SalId
		END
	
	COMMIT TRAN

	SET  NOCOUNT OFF
	RETURN 1
	END TRY
	BEGIN CATCH
	SET  NOCOUNT OFF
	ROLLBACK TRAN
	SET @RtnVal = 'Failure'

	--记录错误日志开始
	DECLARE @error_line   INT
	DECLARE @error_number   INT
	DECLARE @error_message   NVARCHAR (256)
	DECLARE @vError   NVARCHAR (1000)
	SET @error_line = ERROR_LINE ()
	SET @error_number = ERROR_NUMBER ()
	SET @error_message = ERROR_MESSAGE ()
	SET @vError =
			'行'
		+ CONVERT (NVARCHAR (10), @error_line)
		+ '出错[错误号'
		+ CONVERT (NVARCHAR (10), @error_number)
		+ '],'
		+ @error_message
	SET @RtnMsg = @vError
	RETURN -1
   END CATCH


GO


