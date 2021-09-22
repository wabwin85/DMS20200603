DROP PROC [interface].[P_Stage_I_EW_cnfDataForComplain]
GO

CREATE PROC [interface].[P_Stage_I_EW_cnfDataForComplain]
AS
BEGIN

	TRUNCATE TABLE interface.Stage_V_I_EW_cnfDataForComplain

	INSERT INTO interface.Stage_V_I_EW_cnfDataForComplain (
		WHM_Name
		,WHM_ID
		,WHM_Type
		,DMA_CODE
		,DMA_ID
		,DMA_ChineseName
		,PMA_ID
		,PMA_UPN
		,LTM_LotNumber
		,LOT_OnHandQty
		,ConvertFactor
		,FactorNumber
		,LTM_ExpiredDate
		,CreateDate
		)
	SELECT [WHM_Name]
		,[WHM_ID]
		,[WHM_Type]
		,[DMA_CODE]
		,[DMA_ID]
		,[DMA_ChineseName]
		,[PMA_ID]
		,[PMA_UPN]
		,[LTM_LotNumber]
		,[LOT_OnHandQty]
		,[ConvertFactor]
		,[FactorNumber]
		,[LTM_ExpiredDate]
		,[LTM_CreatedDate]
	FROM interface.V_I_EW_cnfDataForComplain
	--where [LTM_CreatedDate]>=DATEADD(mm , datediff(mm, 0 ,getdate())-2, 0)

END

 
GO


