DROP PROCEDURE [Workflow].[Proc_DealerReturn_GetHtmlData]
GO

CREATE PROCEDURE [Workflow].[Proc_DealerReturn_GetHtmlData]
	@InstanceId uniqueidentifier
AS
DECLARE @ApplyType NVARCHAR(100)
SELECT @ApplyType = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

--模版信息，必须放在第一个查询结果，且只有固定的两个字段，名称不能变
SELECT @ApplyType AS TemplateName, 'Header,ReturnProduct,Attachment' AS TableNames

--数据信息
--表头

SELECT  sum(isnull(IAL_UnitPrice,0)*IAL_LotQty )as Amount,DMA_ChineseName AS DealerName,DMA_SAP_Code AS DealerNo,ATTRIBUTE_NAME AS ProductLineName,IAH_Inv_Adj_Nbr AS OrderNo,CONVERT(NVARCHAR(100),IAH_CreatedDate,120) AS SubmitDate,IAH_RSM AS RsmName,IAH_UserDescription AS Remark,
(SELECT VALUE1 FROM Lafite_DICT WHERE DICT_TYPE = 'CONST_AdjustQty_Status' AND DICT_KEY = IAH_Status)  AS OrderStatus,
(SELECT VALUE1 FROM Lafite_DICT WHERE DICT_TYPE = 'CONST_AdjustRenturn_Type' AND DICT_KEY = IAH_ApplyType) AS ApplyType,
(SELECT VALUE1 FROM Lafite_DICT WHERE DICT_TYPE = 'CONST_AdjustRenturn_Reason' AND DICT_KEY = RetrunReason) AS ReturnReason,
(SELECT VALUE1 FROM Lafite_DICT WHERE DICT_TYPE = 'CONST_AdjustQty_Type' AND DICT_KEY = IAH_Reason) AS Reason,
ISNULL(IR_InvoiceNo,'') AS InvoiceNo,
ISNULL(IR_RGANo,'') AS RGANo,
ISNULL(IR_DeliveryNo,'') AS DeliveryNo,
ISNULL(D.VALUE1,'') AS ReasonCn,
ISNULL(D.VALUE2,'') AS ReasonEn,
ISNULL(IR_RevokeRemark,'') AS RevokeRemark
FROM InventoryAdjustHeader
INNER JOIN DealerMaster ON IAH_DMA_ID = DMA_ID
INNER JOIN View_ProductLine ON ID = IAH_ProductLine_BUM_ID
LEFT JOIN InventoryReturnBsc ON IR_Adj_Id = IAH_ID
LEFT JOIN LAFITE_DICT D ON D.DICT_TYPE = 'CONST_ReturnReason_EKP' AND D.DICT_KEY = IR_ReasonCode
left join InventoryAdjustDetail b on b.IAD_IAH_ID= IAH_ID
left JOIN InventoryAdjustLot v ON v.IAL_IAD_ID =b.IAD_ID
WHERE IAH_ID = @InstanceId
group by DMA_ChineseName,DMA_SAP_Code,ATTRIBUTE_NAME,IAH_Inv_Adj_Nbr,IAH_CreatedDate,IAH_RSM,IAH_UserDescription
,IAH_Status,IAH_ApplyType,RetrunReason,IAH_Reason,IR_InvoiceNo,IR_RGANo,IR_DeliveryNo,D.VALUE1,D.VALUE2,IR_RevokeRemark

--退货产品信息
SELECT WHM_Name AS WarehouseName,CFN_CustomerFaceNbr AS Sku,CFN_EnglishName AS EnglishName,CFN_ChineseName AS ChineseName,
CASE WHEN CHARINDEX('@@',ISNULL(IAL_QRLotNumber,IAL_LotNumber)) > 0 THEN substring(ISNULL(IAL_QRLotNumber,IAL_LotNumber),1,CHARINDEX('@@',ISNULL(IAL_QRLotNumber,IAL_LotNumber))-1) ELSE ISNULL(IAL_QRLotNumber,IAL_LotNumber) END AS LotMaster,
CASE WHEN CHARINDEX('@@',ISNULL(IAL_QRLotNumber,IAL_LotNumber)) > 0 THEN substring(ISNULL(IAL_QRLotNumber,IAL_LotNumber),CHARINDEX('@@',ISNULL(IAL_QRLotNumber,ISNULL(IAL_QRLotNumber,IAL_LotNumber)))+2,LEN(ISNULL(IAL_QRLotNumber,IAL_LotNumber))-CHARINDEX('@@',ISNULL(IAL_QRLotNumber,IAL_LotNumber))) ELSE 'NoQR' END AS QrCode,
CONVERT(NVARCHAR(10),IAL_ExpiredDate,120) AS ExpiredDate,
Product.PMA_UnitOfMeasure AS Uom,
CONVERT(NVARCHAR(10),LTM_CreatedDate,120) AS InInventoryDate,
CONVERT(DECIMAL(18,2),IAL_LotQty) AS ReturnQty,
CONVERT(DECIMAL(18,2),IAL_UnitPrice) AS ReturnPrice,
case when  IAL_UnitPrice is not null then CONVERT(DECIMAL(18,2),IAL_UnitPrice)*CONVERT(DECIMAL(18,2),IAL_LotQty) else '0'  end  as Totalamount,

CASE WHEN isnull(Receipt.PRH_SAPShipmentDate,convert(datetime,'2018-01-01'))<'2018-05-01 0:00:00' THEN '17%' ELSE '16%' END AS TaxRate  --获取税率
FROM InventoryAdjustDetail
INNER JOIN InventoryAdjustLot ON IAD_ID = IAL_IAD_ID
INNER JOIN Warehouse ON WHM_ID = IAL_WHM_ID
INNER JOIN Lot ON LOT_ID = IAL_LOT_ID
INNER JOIN Inventory ON INV_ID = LOT_INV_ID
INNER JOIN Product ON PMA_ID = INV_PMA_ID
INNER JOIN CFN ON CFN_ID = PMA_CFN_ID
INNER JOIN LotMaster ON LTM_ID = LOT_LTM_ID
LEFT JOIN 
(select H.PRH_Dealer_DMA_ID,MAX(H.PRH_SAPShipmentDate) AS PRH_SAPShipmentDate,PRL_LotNumber
from POReceiptHeader H, POReceipt L, POReceiptLot T
where H.PRH_ID = L.POR_PRH_ID and L.POR_ID = T.PRL_POR_ID
and H.PRH_Status in ('Complete') and T.PRL_LotNumber not like '%NoQR' GROUP BY   H.PRH_Dealer_DMA_ID ,PRL_LotNumber) AS Receipt ON (Receipt.PRH_Dealer_DMA_ID = Warehouse.WHM_DMA_ID and Receipt.PRL_LotNumber = LotMaster.LTM_LotNumber )
WHERE IAD_IAH_ID = @InstanceId
ORDER BY CFN_CustomerFaceNbr,ISNULL(IAL_QRLotNumber,IAL_LotNumber)

--附件信息
EXEC Workflow.Proc_Attachment_GetHtmlData @InstanceId,NULL



GO

