DROP view [Promotion].[V_I_QV_LPSales_PRO_CRPO]
GO










Create view [Promotion].[V_I_QV_LPSales_PRO_CRPO]
as


--采购(促销订单的发货)
	SELECT
			ID=lot.PRL_ID
  FROM POReceiptHeader(nolock) AS Header
         INNER JOIN POReceipt(nolock) AS Line
            ON Line.POR_PRH_ID = Header.PRH_ID
         INNER JOIN POReceiptLot(nolock) AS Lot
            ON Lot.PRL_POR_ID = Line.POR_ID
         INNER JOIN DealerMaster(nolock) AS DM
            ON DM.DMA_ID = Header.PRH_Dealer_DMA_ID
         INNER JOIN Product(nolock)
            ON Product.PMA_ID = Line.POR_SAP_PMA_ID
         INNER JOIN CFN(nolock)
            ON CFN.CFN_ID = Product.PMA_CFN_ID
         left JOIN View_ProductLine(nolock) AS VPL
            ON VPL.Id = CFN.CFN_ProductLine_BUM_ID
            inner join DealerMaster(nolock) ds on Header.PRH_Vendor_DMA_ID=ds.DMA_ID
         left join Territory(nolock) a on DM.DMA_Province=a.TER_Description and a.TER_Type='Province'
         left join interface.T_I_CR_Product(nolock) b on b.UPN=PMA_UPN
         left join interface.T_I_CR_Division(nolock) c on c.DivisionID=b.DivisionID
   WHERE Header.PRH_Type = 'PurchaseOrder' --采购入库
     AND DM.DMA_DealerType='T2' 
     and Header.PRH_Status IN ('Waiting','Complete' ) --完成或待接收
     and Header.PRH_SAPShipmentDate >'2000-01-01'
     and  exists (
        select 1 from PurchaseOrderHeader POH where POH.POH_OrderNo = Header.PRH_PurchaseOrderNbr
        and (POH.POH_OrderType = 'PRO' OR POH.POH_OrderType='CRPO')
     )      





































































GO


