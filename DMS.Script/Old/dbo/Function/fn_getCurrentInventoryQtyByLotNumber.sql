
DROP FUNCTION [dbo].[fn_getCurrentInventoryQtyByLotNumber]
GO



CREATE FUNCTION [dbo].[fn_getCurrentInventoryQtyByLotNumber]
(
	@DealerId UNIQUEIDENTIFIER,
	@ProductId UNIQUEIDENTIFIER,
	@LotNumber NVARCHAR(100),
	@WhmID UNIQUEIDENTIFIER
)
RETURNS INTEGER
AS

BEGIN
	DECLARE @count INTEGER
	
	SELECT @count = SUM(Lot.LOT_OnHandQty)
          FROM Lot
          INNER JOIN LotMaster ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
          INNER JOIN Inventory ON Lot.LOT_INV_ID = Inventory.INV_ID
          INNER JOIN Warehouse ON Inventory.INV_WHM_ID = Warehouse.WHM_ID
          WHERE
          Warehouse.WHM_DMA_ID = @DealerId
          AND Inventory.INV_PMA_ID = @ProductId
          AND LotMaster.LTM_LotNumber = @LotNumber
          AND Warehouse.WHM_ID = @WhmID
	RETURN @count
END



GO


