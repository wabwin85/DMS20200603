DROP PROCEDURE [dbo].[GC_Interface_ProcessRunner_UpdateStatus]
GO


CREATE PROCEDURE [dbo].[GC_Interface_ProcessRunner_UpdateStatus]
AS
BEGIN
	UPDATE t1
	SET t1.poi_Status = t2.poi_Status
		,t1.POI_ModifyDate = GETDATE()
	FROM interface.T_I_ProcessRunner_PurchaseOrderInterface t1
		,interface.T_I_ProcessRunner_mid t2
	WHERE t1.poi_orderno = t2.poi_orderno AND convert(NVARCHAR(10), t2.POI_Date, 120) = convert(NVARCHAR(10), GETDATE(), 120)

	UPDATE t1
	SET POH_OrderStatus = 'Uploaded'
	FROM PurchaseOrderHeader t1
		,interface.T_I_ProcessRunner_mid t2
	WHERE t1.POH_OrderNo = t2.poi_orderno AND convert(NVARCHAR(10), t2.POI_Date, 120) = convert(NVARCHAR(10), GETDATE(), 120) AND t1.POH_OrderStatus = 'Submitted'
END

GO


