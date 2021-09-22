DROP Procedure [dbo].[GC_PurchaseOrder_AfterGenerate]
GO


/*
自动生成订单后，更新其他信息
*/

CREATE Procedure [dbo].[GC_PurchaseOrder_AfterGenerate]
    @PohId uniqueidentifier
AS
		
SET NOCOUNT ON
	
--更新经销商区域
UPDATE PurchaseOrderHeader 
	SET POH_TerritoryCode = (SELECT TOP 1 TerritoryMaster.TEM_Code FROM DealerTerritory 
							INNER JOIN TerritoryMaster ON TerritoryMaster.TEM_ID = DealerTerritory.DT_TEM_ID
							INNER JOIN TerritoryHierarchy ON TerritoryHierarchy.TH_ID =TerritoryMaster.TEM_Parent_ID
							WHERE DealerTerritory.DT_DMA_ID = PurchaseOrderHeader.POH_DMA_ID
							AND TerritoryHierarchy.TH_Level = 'Province' 
							AND TerritoryHierarchy.TH_BUM_ID = PurchaseOrderHeader.POH_ProductLine_BUM_ID
							AND DealerTerritory.DT_DeleteFlag = 0
							AND TerritoryMaster.TEM_DeleteFlag = 0
							AND TerritoryHierarchy.TH_DeleteFlag = 0)
WHERE POH_ID = @PohId

--更新订单联系人信息
UPDATE PurchaseOrderHeader 
	SET POH_ContactPerson = DST_ContactPerson,
		POH_Contact = DST_Contact,
		POH_ContactMobile = DST_ContactMobile,
		POH_Consignee = DST_Consignee,
		POH_ConsigneePhone = DST_ConsigneePhone
FROM DealerShipTo WHERE DST_Dealer_DMA_ID = PurchaseOrderHeader.POH_DMA_ID
AND POH_ID = @PohId

--更新收货信息
UPDATE PurchaseOrderHeader 
	SET POH_ShipToAddress = DMA_ShipToAddress
FROM DealerMaster WHERE DMA_ID = PurchaseOrderHeader.POH_DMA_ID
AND POH_ID = @PohId
		
SET NOCOUNT OFF


GO


