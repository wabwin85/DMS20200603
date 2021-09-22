DROP PROCEDURE [Workflow].[Proc_DealerReturn_GetFormData]
GO

CREATE PROCEDURE [Workflow].[Proc_DealerReturn_GetFormData]
	@InstanceId uniqueidentifier
AS

DECLARE @RecordCount INT
SELECT @RecordCount = COUNT(1) FROM InventoryAdjustHeader WHERE IAH_ID = @InstanceId

IF @RecordCount = 1
	BEGIN
		DECLARE @TotalRmb DECIMAL(18,2)
		DECLARE @UsdRate DECIMAL(18,2)

		SELECT @UsdRate = Rate FROM interface.V_MDM_ExchangeRate

		SELECT @TotalRmb = SUM(ISNULL(IAL_UnitPrice,0) * ISNULL(IAL_LotQty,0))
		FROM InventoryAdjustDetail
		INNER JOIN InventoryAdjustLot ON IAD_ID = IAL_IAD_ID
		WHERE IAD_IAH_ID = @InstanceId

		SELECT IAH_ApplyType AS ReturnType 
		,RetrunReason AS ReturnReason
		,DivisionCode AS Bu 
		,DMA_DealerType AS DealerType
		,@TotalRmb AS TotalAmountRMB
		,CAST((ISNULL(@TotalRmb,0) / ISNULL(@UsdRate,1)) AS decimal(18,2)) AS TotalAmountUSD
		FROM InventoryAdjustHeader
		INNER JOIN V_DivisionProductLineRelation ON ProductLineID = IAH_ProductLine_BUM_ID
		INNER JOIN DealerMaster ON DMA_ID = IAH_DMA_ID
		WHERE IAH_ID = @InstanceId
	END

GO


