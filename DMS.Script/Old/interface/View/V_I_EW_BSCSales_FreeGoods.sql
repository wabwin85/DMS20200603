DROP view [interface].[V_I_EW_BSCSales_FreeGoods]
GO


CREATE view [interface].[V_I_EW_BSCSales_FreeGoods]
as

		select
			
			UPN=PMA_UPN
			--,SellingPrice=Line.POR_UnitPrice
			,QTY=Lot.PRL_ReceiptQty
			,Transaction_Date=Header.PRH_SAPShipmentDate
			,DealerID=PRH_Dealer_DMA_ID
			,Division=Division
			,ProductLine=
			case when (select COUNT(*) from dealerEmergingMarket
        where PRH_Dealer_DMA_ID=DMT_DMA_ID)>=1 and ATTRIBUTE_NAME ='心脏介入（普通市场）' then N'心脏介入（新兴市场）' else
			isnull([dbo].[fn_GetPurchaseProductLine](PRH_Dealer_DMA_ID,PRH_PurchaseOrderNbr),ATTRIBUTE_NAME ) end
  FROM POReceiptHeader(nolock) AS Header
         INNER JOIN POReceipt(nolock) AS Line
            ON Line.POR_PRH_ID = Header.PRH_ID
         INNER JOIN POReceiptLot(nolock) AS Lot
            ON Lot.PRL_POR_ID = Line.POR_ID
         INNER JOIN Product(nolock)
            ON Product.PMA_ID = Line.POR_SAP_PMA_ID
         INNER JOIN CFN(nolock)
            ON CFN.CFN_ID = Product.PMA_CFN_ID
         left JOIN View_ProductLine(nolock) AS VPL
            ON VPL.Id = CFN.CFN_ProductLine_BUM_ID
            inner join DealerMaster(nolock) ds on Header.PRH_Vendor_DMA_ID=ds.DMA_ID
         left join interface.T_I_CR_Product(nolock) b on b.UPN=PMA_UPN
         left join interface.T_I_CR_Division(nolock) c on c.DivisionID=b.DivisionID
   WHERE     
    Header.PRH_Type = 'PurchaseOrder' --采购入库
      and Header.PRH_Status IN ('Complete' ) --完成或待接收
      and Line.POR_UnitPrice=0
      and PRH_SAPShipmentDate>'2010-01-01'
   

GO


