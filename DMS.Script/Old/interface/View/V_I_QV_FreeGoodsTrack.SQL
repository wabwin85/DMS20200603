DROP view [interface].[V_I_QV_FreeGoodsTrack] 
GO






CREATE view [interface].[V_I_QV_FreeGoodsTrack] 

AS



--SELECT 
--	OrderType ,
--	OrderNo ,
--	D.DivisionCode ,
--	D.DivisionName ,
--	F.DMA_SAP_Code SAPCode,
--	F.DMA_ChineseName DealerName,
--	b.CFN_CustomerFaceNbr AS UPN,
--	b.CFN_ChineseName UPNName,
--	RequiredQty ,
--	SubmitDate ,
--	c.IDENTITY_NAME SubmitUser,
--	EWCode,
--	a.ShipmentNo,
--	a.ShipmentDate 
--	FROM interface.Pro_FreeGoodsTrack A 
--	INNER JOIN CFN B ON A.CfnId=B.CFN_ID
--	INNER JOIN Lafite_IDENTITY C ON C.Id=A.SubmitUser 
--	INNER JOIN V_DivisionProductLineRelation D ON D.ProductLineID=A.ProductLineId AND D.IsEmerging='0'
--	INNER JOIN PurchaseOrderHeader E ON E.POH_OrderNo=A.OrderNo
--	INNER JOIN DealerMaster F ON F.DMA_ID=E.POH_DMA_ID
SELECT A.POH_OrderType OrderType,
A.POH_OrderNo OrderNo, 
D.DivisionCode DivisionCode,
D.DivisionName DivisionName,
E.DMA_SAP_Code SAPCode,
E.DMA_ChineseName DealerName,
CFN.CFN_CustomerFaceNbr UPN,
CFN.CFN_ChineseName UPNName,
B.POD_ReceiptQty RequiredQty,
A.POH_SubmitDate SubmitDate,
F.IDENTITY_NAME SubmitUser,
G.Remark EWCode,
H.PRH_SAPShipmentID ShipmentNo ,
H.PRH_SAPShipmentDate ShipmentDate
FROM PurchaseOrderHeader A 
INNER JOIN PurchaseOrderDetail B ON A.POH_ID=B.POD_POH_ID
INNER JOIN Promotion.PurchaseOrderPoint C ON C.POD_ID=B.POD_ID
INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.ProductLineID=A.POH_ProductLine_BUM_ID
INNER JOIN DealerMaster E ON E.DMA_ID=A.POH_DMA_ID
INNER JOIN CFN ON CFN.CFN_ID=B.POD_CFN_ID
INNER JOIN Lafite_IDENTITY F ON F.Id=A.POH_SubmitUser 
LEFT JOIN (SELECT DISTINCT DLid,Remark FROM Promotion.PRO_DEALER_POINT_LOG WHERE ISNULL(Remark,'')<>'') G ON  CONVERT(INT,G.DLid)=CONVERT(INT,C.PointDetailId)
LEFT JOIN POReceiptHeader H ON H.PRH_PurchaseOrderNbr =A.POH_OrderNo
WHERE A.POH_OrderType='CRPO' AND A.POH_OrderStatus NOT IN ('Draft') AND E.DMA_DealerType IN ('T1','LP')
UNION
SELECT A.POH_OrderType OrderType,
A.POH_OrderNo OrderNo, 
D.DivisionCode DivisionCode,
D.DivisionName DivisionName,
E.DMA_SAP_Code SAPCode,
E.DMA_ChineseName DealerName,
CFN.CFN_CustomerFaceNbr UPN,
CFN.CFN_ChineseName UPNName,
B.POD_ReceiptQty RequiredQty,
A.POH_SubmitDate SubmitDate,
F.IDENTITY_NAME SubmitUser,
G.Remark EWCode,
H.PRH_SAPShipmentID ShipmentNo ,
H.PRH_SAPShipmentDate ShipmentDate
FROM PurchaseOrderHeader A 
INNER JOIN PurchaseOrderDetail B ON A.POH_ID=B.POD_POH_ID
INNER JOIN V_DivisionProductLineRelation D ON D.IsEmerging='0' AND D.ProductLineID=A.POH_ProductLine_BUM_ID
INNER JOIN DealerMaster E ON E.DMA_ID=A.POH_DMA_ID
INNER JOIN CFN ON CFN.CFN_ID=B.POD_CFN_ID
INNER JOIN Lafite_IDENTITY F ON F.Id=A.POH_SubmitUser 
LEFT JOIN (SELECT DISTINCT DLid,Remark FROM Promotion.PRO_DEALER_LARGESS_LOG WHERE ISNULL(Remark,'')<>'') G ON  CONVERT(INT,G.DLid)=CONVERT(INT,B.POD_Field3)
LEFT JOIN POReceiptHeader H ON H.PRH_PurchaseOrderNbr =A.POH_OrderNo
WHERE A.POH_OrderType='PRO' AND A.POH_OrderStatus NOT IN ('Draft') AND E.DMA_DealerType IN ('T1','LP')


GO


