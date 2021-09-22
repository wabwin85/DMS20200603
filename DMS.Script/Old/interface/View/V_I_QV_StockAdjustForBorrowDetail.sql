DROP VIEW   [interface].[V_I_QV_StockAdjustForBorrowDetail]
GO


CREATE VIEW   [interface].[V_I_QV_StockAdjustForBorrowDetail]
AS
	SELECT  
	PL.DivisionName
	,TRN_TransferNumber 
	,dict.VALUE1 FromOrderType
	,FDealer.DMA_SAP_Code FromSAPCOde
	,FDealer.DMA_ChineseName FromDealerName
	,FDealer.DMA_DealerType FromDealerType
	,FDICT.VALUE1 FromWarehouseType
	,FWarehouse.WHM_Name  FromWarehouseName
	,FWarehouse.WHM_Code  FromWarehouseCode

	,PORdict.VALUE1 ToOrderType
	,TDealer.DMA_SAP_Code ToSAPCode
	,TDealer.DMA_ChineseName ToDealerName
	,TDealer.DMA_DealerType ToDealerType
	,tDICT.VALUE1 ToWarehouseType
	,TWarehouse.WHM_Name  ToWarehouseName
	,TWarehouse.WHM_Code  ToWarehouseCode
	,a.TRN_TransferDate OperDate
	,Product.PMA_UPN AS UPN
	,VLot.LTM_LotNumber AS Lot
	,c.TLT_TransferLotQty AS Qty
	from Transfer a  
	inner join TransferLine b on a.TRN_ID=b.TRL_TRN_ID
	inner join TransferLot c on c.TLT_TRL_ID=b.TRL_ID
	inner join Warehouse FWarehouse on FWarehouse.WHM_ID=b.TRL_FromWarehouse_WHM_ID
	inner join Lafite_DICT FDICT on FDICT.DICT_KEY=FWarehouse.WHM_Type and FDICT.DICT_TYPE='MS_WarehouseType'
	inner join Lot on lot.LOT_ID=c.TLT_LOT_ID
	inner join LotMaster on LotMaster.LTM_ID=lot.LOT_LTM_ID
	LEFT JOIN Lafite_DICT dict on dict.DICT_KEY=a.TRN_Type and dict.DICT_TYPE='CONST_TransferOrder_Type'

	inner join POReceiptHeader e on  a.TRN_TransferNumber =e.PRH_SAPShipmentID
	inner join POReceipt f on e.PRH_ID=f.POR_PRH_ID and f.POR_SAP_PMA_ID=b.TRL_TransferPart_PMA_ID
	inner join POReceiptLot h on h.PRL_POR_ID=f.POR_ID and h.PRL_LotNumber=LotMaster.LTM_LotNumber
	inner join Warehouse TWarehouse on TWarehouse.WHM_ID=h.PRL_WHM_ID
	inner join Lafite_DICT tDICT on tDICT.DICT_KEY=TWarehouse.WHM_Type and tDICT.DICT_TYPE='MS_WarehouseType'
	LEFT JOIN Lafite_DICT PORdict on PORdict.DICT_KEY=e.PRH_Type and PORdict.DICT_TYPE='CONST_Receipt_Type'

	 INNER  JOIN DealerMaster FDealer ON FDealer.DMA_ID=A.TRN_FromDealer_DMA_ID
	 INNER JOIN DealerMaster TDealer ON TDealer.DMA_ID=A.TRN_ToDealer_DMA_ID
	 INNER JOIN V_DivisionProductLineRelation PL ON PL.ProductLineID=A.TRN_ProductLine_BUM_ID AND PL.IsEmerging='0'
	 
	 inner join Product on Product.PMA_ID=b.TRL_TransferPart_PMA_ID
	 inner join V_LotMaster VLot on VLot.LTM_ID=LotMaster.LTM_ID
	where TRN_Type='Rent'
	and a.TRN_Status='Complete'
	and CONVERT(nvarchar(10),TRN_TransferDate,120)>='2016-01-01'
	--and CONVERT(nvarchar(10),TRN_TransferDate,120)<'2017-08-01'


GO


