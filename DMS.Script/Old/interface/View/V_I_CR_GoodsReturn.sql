
DROP view [interface].[V_I_CR_GoodsReturn]
GO




CREATE view [interface].[V_I_CR_GoodsReturn]
as
	SELECT
		DMA_SAP_Code AS SAPCode,
		Product.PMA_UPN AS UPN,
		ISNULL(LotMaster.LTM_LotNumber, ajlot.IAL_LotNumber) AS  LotNumber,
		ajlot.IAL_LotQty AS Qty,
		IAH_Inv_Adj_Nbr AS ReturnNbr,
		--IAH_CreatedDate AS ReturnDate,
		VALUE1 AS ReStatus,
		IAH_ApprovalDate as ReturnDate
		FROM InventoryAdjustHeader head
		left join InventoryAdjustDetail detail on detail.IAD_IAH_ID=head.IAH_ID
		left join InventoryAdjustLot ajlot on ajlot.IAL_IAD_ID = detail.IAD_ID
		left JOIN Product ON detail.IAD_PMA_ID = Product.PMA_ID
		left join DealerMaster on head.IAH_DMA_ID=DMA_ID
		LEFT OUTER JOIN Lot ON ajlot.IAL_LOT_ID = Lot.LOT_ID
		LEFT OUTER JOIN LotMaster ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
		left join Lafite_DICT d on d.DICT_KEY=IAH_Status and DICT_TYPE= 'CONST_AdjustQty_Status'
		left join Warehouse on WHM_ID=ajlot.IAL_WHM_ID
	WHERE IAH_Reason in('Return','Exchange') and IAH_Status in ('Accept')
	and WHM_Type in ('Normal','DefaultWH')



GO


