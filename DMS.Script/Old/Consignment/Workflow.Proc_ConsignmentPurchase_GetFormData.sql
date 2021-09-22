
/*
1. 功能名称：寄售买断发起MFlow
*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Workflow].[Proc_ConsignmentPurchase_GetFormData]
	@InstanceId uniqueidentifier
AS

DECLARE @UsdRate DECIMAL(18,2)
SELECT @UsdRate = Rate FROM interface.V_MDM_ExchangeRate

select distinct DivisionCode as Bu, IAH_Inv_Adj_Nbr as RequestNo,IAH_Reason as [Type],
sum(isnull(IAL_LotQty,0)*isnull(IAL_UnitPrice,0)) as TotalAmountRMB,
cast((sum(isnull(IAL_LotQty,0)*isnull(IAL_UnitPrice,0))*(cast(isnull(@UsdRate,1) AS decimal(18,2)))) as decimal(18,2)) as TotalAmountUSD
from InventoryAdjustHeader
left join  V_DivisionProductLineRelation on V_DivisionProductLineRelation.ProductLineID=InventoryAdjustHeader.IAH_ProductLine_BUM_ID
left join InventoryAdjustDetail on InventoryAdjustDetail.IAD_IAH_ID=InventoryAdjustHeader.IAH_ID
left join InventoryAdjustLot on InventoryAdjustLot.IAL_IAD_ID=InventoryAdjustDetail.IAD_ID
where IAH_ID=@InstanceId
group by DivisionCode,IAH_Inv_Adj_Nbr,IAH_Reason
