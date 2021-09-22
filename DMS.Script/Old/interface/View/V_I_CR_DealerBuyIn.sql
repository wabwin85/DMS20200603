DROP VIEW [interface].[V_I_CR_DealerBuyIn]
GO








CREATE VIEW [interface].[V_I_CR_DealerBuyIn]
AS
SELECT DM.DMA_ChineseName,
         DM.DMA_EnglishName,
         DM.DMA_SAP_Code,
         Header.PRH_PurchaseOrderNbr,
         Header.PRH_SAPShipmentID,
         Header.PRH_PONumber,         
         CONVERT (VARCHAR (10), Header.PRH_SAPShipmentDate, 120) AS PRH_SAPShipmentDate,
         datepart(yy,Header.PRH_SAPShipmentDate) AS Year,
         datepart(mm,Header.PRH_SAPShipmentDate) AS Month,
         --VPL.Attribute_Name AS ProductLineName,
         ProductLineName=isnull([dbo].[fn_GetPurchaseProductLine](PRH_Dealer_DMA_ID,PRH_PurchaseOrderNbr),ATTRIBUTE_NAME ),
         CFN.CFN_CustomerFaceNbr AS UPN,
         CFN.CFN_ChineseName,         
         Lot.PRL_LotNumber AS LTM_LotNumber,
         CASE WHEN CFN_Property6 = '1' THEN CONVERT (VARCHAR (10), Lot.PRL_ExpiredDate, 120)
         WHEN CFN_Property6 = '0' THEN CONVERT (NVARCHAR (7), Lot.PRL_ExpiredDate, 120) END AS LTM_ExpiredDate,
         Lot.PRL_ReceiptQty,
         (SELECT CASE Header.PRH_Status WHEN 'Complete' THEN '已确认收货' ELSE '待收货' END) AS PRH_StatusName
         ,POD_CFN_Price=[dbo].[fn_GetPurchasePrice](PRH_Dealer_DMA_ID,CFN_ID,PRH_PurchaseOrderNbr)
         ,PRH_Type
         ,ds.DMA_ChineseName as VendorName
         ,ds.DMA_SAP_Code as VendorCode
    FROM POReceiptHeader AS Header
         INNER JOIN POReceipt AS Line
            ON Line.POR_PRH_ID = Header.PRH_ID
         INNER JOIN POReceiptLot AS Lot
            ON Lot.PRL_POR_ID = Line.POR_ID
         INNER JOIN DealerMaster AS DM
            ON DM.DMA_ID = Header.PRH_Dealer_DMA_ID
          --left join PurchaseOrderHeader on DMA_ID=POH_DMA_ID
          --left join PurchaseOrderDetail on POD_POH_ID=POH_ID
         INNER JOIN Product
            ON Product.PMA_ID = Line.POR_SAP_PMA_ID
         INNER JOIN CFN
            ON CFN.CFN_ID = Product.PMA_CFN_ID
         left JOIN View_ProductLine AS VPL
            ON VPL.Id = CFN.CFN_ProductLine_BUM_ID
            inner join DealerMaster ds on Header.PRH_Vendor_DMA_ID=ds.DMA_ID
   WHERE     
   --Header.PRH_Type = 'PurchaseOrder' --采购入库
   --      AND 
         Header.PRH_Status IN ('Waiting','Complete' ) --完成或待接收







GO


