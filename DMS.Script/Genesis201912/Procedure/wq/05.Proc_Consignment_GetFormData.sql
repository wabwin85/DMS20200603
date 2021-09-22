
/****** Object:  StoredProcedure [Workflow].[Proc_Consignment_GetFormData]    Script Date: 2019/12/13 18:15:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [Workflow].[Proc_Consignment_GetFormData]
	@InstanceId uniqueidentifier
AS

DECLARE @ApplyType NVARCHAR(100)

IF (SELECT COUNT(1) FROM ConsignmentApplyHeader WHERE CAH_ID = @InstanceId) > 0
	BEGIN
		SET @ApplyType = 'ConsignmentApply'
	END
ELSE IF (SELECT COUNT(1) FROM ConsignmentApplyHeader WHERE LOWER(CAST(CAH_CAH_ID AS NVARCHAR(100))) = LOWER(@InstanceId)) > 0
	BEGIN
		SET @ApplyType = 'DelayApply'
	END

select 1 'NoData'
/*
DECLARE @TotalRmb DECIMAL(18,2)
DECLARE @UsdRate DECIMAL(18,2)

SELECT @UsdRate = Rate FROM interface.V_MDM_ExchangeRate

IF @ApplyType = 'ConsignmentApply'
	BEGIN
		
		SELECT @TotalRmb = ISNULL(SUM(CAD_Price * CAD_Qty),0) 
		FROM ConsignmentApplyDetails
		WHERE CAD_CAH_ID = @InstanceId

		SELECT CAH_OrderNo AS RequestNo,ISNULL(@TotalRmb,0)/1.16 AS TotalRMB,CAST((ISNULL(@TotalRmb,0) / ISNULL(@UsdRate,1)/1.16) AS decimal(18,2)) AS TotalUSD,'1' AS Type FROM dbo.ConsignmentApplyHeader 
		WHERE CAH_ID = @InstanceId

	END
ELSE IF @ApplyType = 'DelayApply'
	BEGIN

		DECLARE @MainId uniqueidentifier
		
		SELECT @MainId = CAH_ID FROM ConsignmentApplyHeader 
		WHERE LOWER(CAST(CAH_CAH_ID AS NVARCHAR(100))) = LOWER(@InstanceId)

		SELECT @TotalRmb = SUM(ISNULL(LOT_OnHandQty,0)*ISNULL(CAD_Price,0)) FROM (
		SELECT DISTINCT LOT_ID,LOT_OnHandQty,CAD_Price FROM POReceiptHeader
		INNER JOIN ConsignmentApplyHeader ON POReceiptHeader.PRH_PurchaseOrderNbr LIKE + '%' + ConsignmentApplyHeader.CAH_POH_OrderNo + '%'
		INNER JOIN ConsignmentApplyDetails ON ConsignmentApplyHeader.CAH_ID = ConsignmentApplyDetails.CAD_CAH_ID
		INNER JOIN POReceipt ON POReceiptHeader.PRH_ID = POReceipt.POR_PRH_ID
		INNER JOIN POReceiptLot ON POR_ID = PRL_POR_ID
		INNER JOIN Product A ON A.PMA_ID = POR_SAP_PMA_ID
		INNER JOIN CFN B ON B.CFN_ID = A.PMA_CFN_ID
		INNER JOIN CFN C ON C.CFN_ID = CAD_CFN_ID AND C.CFN_Property1 = B.CFN_Property1
		INNER JOIN LotMaster ON LotMaster.LTM_Product_PMA_ID = POReceipt.POR_SAP_PMA_ID AND LotMaster.LTM_LotNumber = POReceiptLot.PRL_LotNumber
		INNER JOIN Lot ON LotMaster.LTM_ID = Lot.LOT_LTM_ID
		INNER JOIN Inventory ON Lot.LOT_INV_ID = Inventory.INV_ID AND POReceiptLot.PRL_WHM_ID = Inventory.INV_WHM_ID
		INNER JOIN Warehouse ON WHM_ID = Inventory.INV_WHM_ID
		WHERE PRH_Status != 'Cancelled'
		AND PRH_Type = 'PurchaseOrder'
		AND WHM_Type = 'Borrow'
		AND ConsignmentApplyHeader.CAH_ID = @MainId
		) T

		SELECT CAH_OrderNo AS RequestNo,ISNULL(@TotalRmb,0)/1.16 AS TotalRMB,CAST(((ISNULL(@TotalRmb,0) / ISNULL(@UsdRate,1))/1.16) AS decimal(18,2)) AS TotalUSD,'2' AS Type FROM dbo.ConsignmentApplyHeader 
		WHERE LOWER(CAST(CAH_CAH_ID AS NVARCHAR(100))) = LOWER(@InstanceId)

	END
	*/