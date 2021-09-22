DROP VIEW [interface].[V_I_EW_BSCSales]
GO


CREATE VIEW [interface].[V_I_EW_BSCSales]
AS
SELECT ID = lot.PRL_ID,
       UPN = PMA_UPN,
       LOT = Lot.PRL_LotNumber,
       CASE 
            WHEN CFN_Property6 = '1' THEN CONVERT(VARCHAR(10), Lot.PRL_ExpiredDate, 120)
            WHEN CFN_Property6 = '0' THEN CONVERT(NVARCHAR(7), Lot.PRL_ExpiredDate, 120)
       END AS Expdate,
       PurchasePrice = interface.[QV_GetPurchasePrice](PRH_Dealer_DMA_ID, CFN_ID)
       / 1.17
       --,SellingPrice=[dbo].[fn_GetPurchasePrice](PRH_Dealer_DMA_ID,CFN_ID,PRH_PurchaseOrderNbr)
       ,
       SellingPrice = ISNULL(
           Line.POR_UnitPrice,
           [dbo].[fn_GetPurchasePrice](PRH_Dealer_DMA_ID, CFN_ID, PRH_PurchaseOrderNbr)
       ),
       QTY = Lot.PRL_ReceiptQty
       --,SellingAmount=[dbo].[fn_GetPurchasePrice](PRH_Dealer_DMA_ID,CFN_ID,PRH_PurchaseOrderNbr)*Lot.PRL_ReceiptQty
       ,
       SellingAmount = ISNULL(
           Line.POR_UnitPrice,
           [dbo].[fn_GetPurchasePrice](PRH_Dealer_DMA_ID, CFN_ID, PRH_PurchaseOrderNbr)
       ) * Lot.PRL_ReceiptQty,
       PurchaseAmount = interface.[QV_GetPurchasePrice](PRH_Dealer_DMA_ID, CFN_ID)
       / 1.17 * Lot.PRL_ReceiptQty,
       Transaction_Date = Header.PRH_SAPShipmentDate,
       DealerID = PRH_Dealer_DMA_ID,
       Dealer = DM.DMA_ChineseName,
       DealerLevel = DM.DMA_DealerType,
       DATEPART(yy, Header.PRH_SAPShipmentDate) AS [Year],
       DATEPART(mm, Header.PRH_SAPShipmentDate) AS [Month],
       Division = Division,
       Divisionid = b.DivisionID,
       Province = DM.DMA_Province,
       ProvinceID = a.TER_ID,
       Region = '',
       RegionID = '',
       ParentDealerID = DM.DMA_Parent_DMA_ID,
       SAPID = DM.DMA_SAP_Code,
       ParentSAPID = (
           SELECT DMA_SAP_Code
           FROM   DealerMaster dl(nolock)
           WHERE  dl.DMA_ID = DM.DMA_Parent_DMA_ID
       ),
       Selltype = 1,
       ProductLine = CASE 
                          WHEN (
                                   SELECT COUNT(*)
                                   FROM   dealerEmergingMarket(nolock)
                                   WHERE  PRH_Dealer_DMA_ID = DMT_DMA_ID
                               ) >= 1 AND ATTRIBUTE_NAME =
                               '心脏介入（普通市场）' THEN 
                               N'心脏介入（新兴市场）'
                          ELSE ISNULL(
                                   [dbo].[fn_GetPurchaseProductLine](PRH_Dealer_DMA_ID, PRH_PurchaseOrderNbr),
                                   ATTRIBUTE_NAME
                               )
                     END,
       InputTime = (
           SELECT MAX(DNL_CreatedDate)
           FROM   DeliveryNote(nolock)
           WHERE  Header.PRH_SAPShipmentID = DNL_DeliveryNoteNbr
       ),
       NBR = Header.PRH_SAPShipmentID,
       Staus = PRH_Status
       FROM   POReceiptHeader(NOLOCK) AS Header
       INNER JOIN POReceipt(NOLOCK) AS Line
            ON  Line.POR_PRH_ID = Header.PRH_ID
       INNER JOIN POReceiptLot(NOLOCK) AS Lot
            ON  Lot.PRL_POR_ID = Line.POR_ID
       INNER JOIN DealerMaster(NOLOCK) AS DM
            ON  DM.DMA_ID = Header.PRH_Dealer_DMA_ID
       INNER JOIN Product(NOLOCK)
            ON  Product.PMA_ID = Line.POR_SAP_PMA_ID
       INNER JOIN CFN(NOLOCK)
            ON  CFN.CFN_ID = Product.PMA_CFN_ID
       LEFT JOIN View_ProductLine(NOLOCK) AS VPL
            ON  VPL.Id = CFN.CFN_ProductLine_BUM_ID
       INNER JOIN DealerMaster(NOLOCK) ds
            ON  Header.PRH_Vendor_DMA_ID = ds.DMA_ID
       LEFT JOIN Territory(NOLOCK) a
            ON  DM.DMA_Province = a.TER_Description
                AND a.TER_Type = 'Province'
       LEFT JOIN interface.T_I_CR_Product(NOLOCK) b
            ON  b.UPN = PMA_UPN
       LEFT JOIN interface.T_I_CR_Division(NOLOCK) c
            ON  c.DivisionID = b.DivisionID
WHERE  Header.PRH_Type = 'PurchaseOrder' --采购入库
       AND Header.PRH_Status IN ('Waiting', 'Complete') --完成或待接收
       AND Header.PRH_SAPShipmentDate > '2000-01-01'
UNION ALL   
SELECT ID = InventoryAdjustLot.IAL_ID,
       [UPN] = PMA_UPN,
       LOT = ISNULL(LTM_LotNumber, IAL_LotNumber),
       [ExpDate] = CASE 
                        WHEN CFN_Property6 = '1' THEN CONVERT(VARCHAR(10), ISNULL(LTM_ExpiredDate, IAL_ExpiredDate), 120)
                        WHEN CFN_Property6 = '0' THEN CONVERT(NVARCHAR(7), LTM_ExpiredDate, 120)
                   END,
       [purchasePrice] = CONVERT(
           MONEY,
           [interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID, whm.WHM_DMA_ID, whm.WHM_Type)
           / 1.17
       ),
       --    SellingPrice=
       --    ISNULL(interface.QV_GetReturnPurchasePrice(IAH_DMA_ID,CFN_ID,IAL_PRH_ID),
       --    ISNULL((select Price from TMP_SalesPrice_LPQ1 tsl where Product.PMA_UPN=tsl.UPN
       --and tsl.Dealer_SAP_Code=d.DMA_SAP_Code and DataType='return'),
       --interface.QV_GetReturnPrice(CFN_ID,IAH_DMA_ID)))
       --,
       SellingPrice = ISNULL(
           (
               SELECT TOP 1 SCD_UnitPrice
               FROM   ShipmentLPConfirmHeader(nolock)
                      LEFT JOIN ShipmentLPConfirmDetail(nolock)
                           ON  SCD_SCH_ID = SCH_ID
               WHERE  SCD_UPN = PMA_UPN
                      AND SCD_Lot = ISNULL(LTM_LotNumber, IAL_LotNumber)
                      AND SCH_SalesNo = IAH_Inv_Adj_Nbr
               ORDER BY SCH_ConfirmDate DESC
           ),
               interface.QV_GetReturnPrice(CFN_ID, IAH_DMA_ID) ),
       [Qty] = -IAL_LotQty,
       --    [SellingAmount]=  ISNULL(interface.QV_GetReturnPurchasePrice(IAH_DMA_ID,CFN_ID,IAL_PRH_ID),
       --    ISNULL((select Price from TMP_SalesPrice_LPQ1 tsl where Product.PMA_UPN=tsl.UPN
       --and tsl.Dealer_SAP_Code=d.DMA_SAP_Code and DataType='return'),
       --interface.QV_GetReturnPrice(CFN_ID,IAH_DMA_ID)))*-IAL_LotQty,
       SellingAmount = ISNULL(
           (
               SELECT TOP 1 SCD_UnitPrice
               FROM   ShipmentLPConfirmHeader(nolock)
                      LEFT JOIN ShipmentLPConfirmDetail(nolock)
                           ON  SCD_SCH_ID = SCH_ID
               WHERE  SCD_UPN = PMA_UPN
                      AND SCD_Lot = ISNULL(LTM_LotNumber, IAL_LotNumber)
                      AND SCH_SalesNo = IAH_Inv_Adj_Nbr
               ORDER BY SCH_ConfirmDate DESC
           ),interface.QV_GetReturnPrice(CFN_ID, IAH_DMA_ID)
       ) * -IAL_LotQty,
       [PurchaseAmount] = CONVERT(
           MONEY,
           [interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID, whm.WHM_DMA_ID, whm.WHM_Type)
           / 1.17
       ) * -IAL_LotQty,
       [Transaction_Date] = CONVERT(VARCHAR(10), IAH_ApprovalDate, 120),
       --[Transaction_Date]=(select MAX(POL_OperDate) from PurchaseOrderLog where POL_POH_ID=inv.IAH_ID),
       [DealerID] = DMA_ID,
       Dealer = DMA_ChineseName,
       DealerLevel = DMA_DealerType,
       --[Year]=year((select MAX(POL_OperDate) from PurchaseOrderLog where POL_POH_ID=inv.IAH_ID)),
       --[Month]=month((select MAX(POL_OperDate) from PurchaseOrderLog where POL_POH_ID=inv.IAH_ID)),
       [Year] = YEAR(IAH_ApprovalDate),
       [Month] = MONTH(IAH_ApprovalDate),
       [Division],
       [DivisionID] = b.DivisionID,
       [Province] = d.DMA_Province,
       [ProvinceID] = TER_ID,
       [Region] = '',
       [RegionID] = '',
       ParentDealerID = DMA_Parent_DMA_ID,
       [SAPID] = d.DMA_SAP_Code,
       [ParentSAPID] = (
           SELECT DMA_SAP_Code
           FROM   DealerMaster(nolock)
           WHERE  DMA_ID = d.DMA_Parent_DMA_ID
       ),
       Selltype = 3,
       ProductLine = CASE 
                          WHEN (
                                   SELECT COUNT(*)
                                   FROM   dealerEmergingMarket(nolock)
                                   WHERE  inv.IAH_DMA_ID = DMT_DMA_ID
                               ) >= 1 AND ATTRIBUTE_NAME =
                               '心脏介入（普通市场）' THEN 
                               N'心脏介入（新兴市场）'
                          ELSE ATTRIBUTE_NAME
                     END,
       InputTime = (
           SELECT MAX(POL_OperDate)
           FROM   PurchaseOrderLog(nolock)
           WHERE  POL_POH_ID = inv.IAH_ID
       ),
       NBR = IAH_Inv_Adj_Nbr,
       Staus = IAH_Status
FROM   InventoryAdjustHeader(NOLOCK) inv
       INNER JOIN InventoryAdjustDetail(NOLOCK)
            ON  InventoryAdjustDetail.IAD_IAH_ID = inv.IAH_ID
       INNER JOIN InventoryAdjustLot(NOLOCK)
            ON  InventoryAdjustLot.IAL_IAD_ID = InventoryAdjustDetail.IAD_ID
       INNER JOIN DealerMaster(NOLOCK) d
            ON  d.DMA_ID = inv.IAH_DMA_ID
       INNER JOIN Lafite_DICT(NOLOCK)
            ON  DICT_TYPE = 'CONST_AdjustQty_Type'
                AND DICT_KEY = inv.IAH_Reason
       INNER JOIN Product(NOLOCK)
            ON  Product.PMA_ID = InventoryAdjustDetail.IAD_PMA_ID
       INNER JOIN CFN(NOLOCK)
            ON  CFN.CFN_ID = Product.PMA_CFN_ID
       INNER JOIN View_ProductLine(NOLOCK)
            ON  View_ProductLine.Id = inv.IAH_ProductLine_BUM_ID
       LEFT OUTER JOIN Lot(NOLOCK)
            ON  InventoryAdjustLot.IAL_LOT_ID = Lot.LOT_ID
       LEFT OUTER JOIN LotMaster(NOLOCK)
            ON  Lot.LOT_LTM_ID = LotMaster.LTM_ID
       LEFT JOIN interface.T_I_CR_Product (NOLOCK) b
            ON  b.UPN = PMA_UPN
       LEFT JOIN interface.T_I_CR_Division(NOLOCK) c
            ON  c.DivisionID = b.DivisionID
       LEFT JOIN Territory(NOLOCK) a
            ON  DMA_Province = a.TER_Description
                AND a.TER_Type = 'Province'
       LEFT JOIN Warehouse(NOLOCK) whm
            ON  InventoryAdjustLot.IAL_WHM_ID = whm.WHM_ID
WHERE  IAH_Status IN ('Accept')
       AND IAH_Reason IN ('Return', 'Exchange')
       AND whm.WHM_Type IN ('Normal', 'DefaultWH')

GO


