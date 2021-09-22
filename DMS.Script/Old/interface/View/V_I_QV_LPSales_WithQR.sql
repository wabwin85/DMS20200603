DROP  view [interface].[V_I_QV_LPSales_WithQR]
GO




--drop  view [interface].[V_I_QV_LPSales_WithQR]


CREATE view [interface].[V_I_QV_LPSales_WithQR]
as


--采购(非促销订单的发货)
	SELECT
			ID=lot.PRL_ID
			,UPN=PMA_UPN			
      ,LOT = CASE WHEN charindex('@@',Lot.PRL_LotNumber) > 0 
                  THEN substring(Lot.PRL_LotNumber,1,charindex('@@',Lot.PRL_LotNumber)-1) 
                  ELSE Lot.PRL_LotNumber
                  END 
      ,QRCode = CASE WHEN charindex('@@',Lot.PRL_LotNumber) > 0
                     THEN substring(Lot.PRL_LotNumber,charindex('@@',Lot.PRL_LotNumber)+2,len(Lot.PRL_LotNumber)) 
                     ELSE ''
                     END      
			,CASE WHEN CFN_Property6 = '1' THEN CONVERT (VARCHAR (10), Lot.PRL_ExpiredDate, 120)
			      WHEN CFN_Property6 = '0' THEN CONVERT (NVARCHAR (10), Lot.PRL_ExpiredDate, 120) 
            END AS Expdate
			,PurchasePrice=interface.[QV_GetPurchasePrice](PRH_Dealer_DMA_ID,CFN_ID)/1.17			
			,SellingPrice=ISNULL(Lot.PRL_UnitPrice,[dbo].[fn_GetPurchasePrice](PRH_Dealer_DMA_ID,CFN_ID,PRH_PurchaseOrderNbr))
			,QTY=Lot.PRL_ReceiptQty
			,SellingAmount=ISNULL(Lot.PRL_UnitPrice,[dbo].[fn_GetPurchasePrice](PRH_Dealer_DMA_ID,CFN_ID,PRH_PurchaseOrderNbr))*Lot.PRL_ReceiptQty
			,PurchaseAmount=interface.[QV_GetPurchasePrice](PRH_Dealer_DMA_ID,CFN_ID)/1.17*Lot.PRL_ReceiptQty
			,Transaction_Date=Header.PRH_SAPShipmentDate
			,DealerID=PRH_Dealer_DMA_ID
			,Dealer=DM.DMA_ChineseName
			,DealerLevel= DM.DMA_DealerType
		  ,datepart(yy,Header.PRH_SAPShipmentDate) AS [Year]
			,datepart(mm,Header.PRH_SAPShipmentDate) AS [Month]
			,Division=Division
			,Divisionid=b.DivisionID
			,Province=DM.DMA_Province
			,ProvinceID=a.TER_ID
			,Region=''
			,RegionID=''
			,ParentDealerID=DM.DMA_Parent_DMA_ID
			,SAPID=DM.DMA_SAP_Code
			,ParentSAPID=(select DMA_SAP_Code from DealerMaster dl(nolock) where dl.DMA_ID=DM.DMA_Parent_DMA_ID)
			,Selltype=1
			,ProductLine=	case when (select COUNT(*) from dealerEmergingMarket(nolock) where PRH_Dealer_DMA_ID=DMT_DMA_ID)>=1 and ATTRIBUTE_NAME ='心脏介入（普通市场）' 
                         then N'心脏介入（新兴市场）' 
                         else isnull([dbo].[fn_GetPurchaseProductLine](PRH_Dealer_DMA_ID,PRH_PurchaseOrderNbr),ATTRIBUTE_NAME ) end
            , InputTime=(select MAX(DNL_CreatedDate) from DeliveryNote(nolock) where Header.PRH_SAPShipmentID=DNL_DeliveryNoteNbr)
            ,NBR=Header.PRH_SAPShipmentID
            ,Staus=PRH_Status
            --,(select POL_OperDate from PurchaseOrderLog(nolock) where pol_POH_ID=Header.PRH_ID and  pol_operType='Delivery') As interfaceUploadDate
			,POL_OperDate as interfaceUploadDate
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
		 left join PurchaseOrderLog(nolock) pol on pol.pol_POH_ID=Header.PRH_ID and pol_operType='Delivery'
   WHERE Header.PRH_Type = 'PurchaseOrder' --采购入库
     AND DM.DMA_DealerType='T2' 
     and Header.PRH_Status IN ('Waiting','Complete' ) --完成或待接收
     and Header.PRH_SAPShipmentDate >= Convert(datetime,convert(varchar(8),dateadd(mm,-12,getdate()),120) + '01')
 

     --and Header.PRH_SAPShipmentDate >'2000-01-01'
     --and not exists (
     --   select 1 from PurchaseOrderHeader POH where POH.POH_OrderNo = Header.PRH_PurchaseOrderNbr
     --   and (POH.POH_OrderType = 'PRO' OR POH.POH_OrderType='CRPO')
     --)
--UNION ALL
--采购(促销订单的发货)
	--SELECT
	--		ID=lot.PRL_ID
	--		,UPN=PMA_UPN
	--		,LOT=Lot.PRL_LotNumber
	--		,CASE WHEN CFN_Property6 = '1' THEN CONVERT (VARCHAR (10), Lot.PRL_ExpiredDate, 120)
	--		      WHEN CFN_Property6 = '0' THEN CONVERT (NVARCHAR (7), Lot.PRL_ExpiredDate, 120) 
 --           END AS Expdate
	--		,PurchasePrice=0			
	--		,SellingPrice=0
	--		,QTY=Lot.PRL_ReceiptQty
	--		,SellingAmount=0
	--		,PurchaseAmount=0
	--		,Transaction_Date=Header.PRH_SAPShipmentDate
	--		,DealerID=PRH_Dealer_DMA_ID
	--		,Dealer=DM.DMA_ChineseName
	--		,DealerLevel= DM.DMA_DealerType
	--	    ,datepart(yy,Header.PRH_SAPShipmentDate) AS [Year]
 --           ,datepart(mm,Header.PRH_SAPShipmentDate) AS [Month]
	--		,Division=Division
	--		,Divisionid=b.DivisionID
	--		,Province=DM.DMA_Province
	--		,ProvinceID=a.TER_ID
	--		,Region=''
	--		,RegionID=''
	--		,ParentDealerID=DM.DMA_Parent_DMA_ID
	--		,SAPID=DM.DMA_SAP_Code
	--		,ParentSAPID=(select DMA_SAP_Code from DealerMaster dl where dl.DMA_ID=DM.DMA_Parent_DMA_ID)
	--		,Selltype=1
	--		,ProductLine=	case when (select COUNT(*) from dealerEmergingMarket where PRH_Dealer_DMA_ID=DMT_DMA_ID)>=1 and ATTRIBUTE_NAME ='心脏介入（普通市场）' 
 --                        then N'心脏介入（新兴市场）' 
 --                        else isnull([dbo].[fn_GetPurchaseProductLine](PRH_Dealer_DMA_ID,PRH_PurchaseOrderNbr),ATTRIBUTE_NAME ) end
 --     , InputTime=(select MAX(DNL_CreatedDate) from DeliveryNote where Header.PRH_SAPShipmentID=DNL_DeliveryNoteNbr)
 --     ,NBR=Header.PRH_SAPShipmentID
 --     ,Staus=PRH_Status
 --     ,(select POL_OperDate from PurchaseOrderLog where pol_POH_ID=Header.PRH_ID and  pol_operType='Delivery') As interfaceUploadDate
 -- FROM POReceiptHeader(nolock) AS Header
 --        INNER JOIN POReceipt(nolock) AS Line
 --           ON Line.POR_PRH_ID = Header.PRH_ID
 --        INNER JOIN POReceiptLot(nolock) AS Lot
 --           ON Lot.PRL_POR_ID = Line.POR_ID
 --        INNER JOIN DealerMaster(nolock) AS DM
 --           ON DM.DMA_ID = Header.PRH_Dealer_DMA_ID
 --        INNER JOIN Product(nolock)
 --           ON Product.PMA_ID = Line.POR_SAP_PMA_ID
 --        INNER JOIN CFN(nolock)
 --           ON CFN.CFN_ID = Product.PMA_CFN_ID
 --        left JOIN View_ProductLine(nolock) AS VPL
 --           ON VPL.Id = CFN.CFN_ProductLine_BUM_ID
 --           inner join DealerMaster(nolock) ds on Header.PRH_Vendor_DMA_ID=ds.DMA_ID
 --        left join Territory(nolock) a on DM.DMA_Province=a.TER_Description and a.TER_Type='Province'
 --        left join interface.T_I_CR_Product(nolock) b on b.UPN=PMA_UPN
 --        left join interface.T_I_CR_Division(nolock) c on c.DivisionID=b.DivisionID
 --  WHERE Header.PRH_Type = 'PurchaseOrder' --采购入库
 --    AND DM.DMA_DealerType='T2' 
 --    and Header.PRH_Status IN ('Waiting','Complete' ) --完成或待接收
 --    and Header.PRH_SAPShipmentDate >'2000-01-01'
 --    and exists (
 --       select 1 from PurchaseOrderHeader POH where POH.POH_OrderNo = Header.PRH_PurchaseOrderNbr
 --       and (POH.POH_OrderType = 'PRO' OR POH.POH_OrderType='CRPO')
 --    )         
UNION ALL
--销售	
  select ID=SLT_ID
  			 ,UPN=PMA_UPN
  			 --,V_LotMaster.LTM_LotNumber AS LOT
		     --,V_LotMaster.LTM_QrCode AS QRCode
  		   --,LOT=LTM_LotNumber
         
         ,CASE WHEN charindex('@@',LTM_LotNumber) > 0 
                 THEN substring(LTM_LotNumber,1,charindex('@@',LTM_LotNumber)-1) 
                 ELSE LTM_LotNumber
                 END AS LOT
         ,CASE WHEN charindex('@@',LTM_LotNumber) > 0
                 THEN substring(LTM_LotNumber,charindex('@@',LTM_LotNumber)+2,len(LTM_LotNumber)) 
                 ELSE ''
                 END AS QRCode
  	     ,CASE WHEN CFN_Property6 = '1' THEN CONVERT (VARCHAR (10), LTM_ExpiredDate, 120)
  		 	       WHEN CFN_Property6 = '0' THEN CONVERT (NVARCHAR (10),LTM_ExpiredDate, 120) 
               END AS Expdate
  		   ,purchasePrice=	interface.fn_GetPurchasePrice(CFN.CFN_ID,SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type)/1.17   			
  			 ,SellingPrice= ISNULL((select top 1  SCD_UnitPrice 
                                  from ShipmentLPConfirmHeader(nolock)
                                  left join ShipmentLPConfirmDetail(nolock) on SCD_SCH_ID=SCH_ID
                                 where SCH_SalesNo=SPH_ShipmentNbr 
                                   and SCD_UPN=PMA_UPN 
                                   and CASE WHEN charindex('NoQR',SCD_Lot) > 0 THEN substring(SCD_Lot,1,charindex('@@',SCD_Lot)-1)+'@@NoQR' ELSE SCD_Lot END =LTM_LotNumber and SPH_Status='Complete'
                               ),(select CFNP_Price 
                                  from CFNPrice(nolock)
                                 where CFN_ID=CFNP_CFN_ID and CFNP_PriceType='DealerConsignment' 
                                   and CFNP_Group_ID=SPH_Dealer_DMA_ID))
  			,Qty=SLT_LotShippedQty  		
  			,SellingAmount=ISNULL((select  top 1 SCD_UnitPrice 
                                 from ShipmentLPConfirmHeader(nolock)
                                 left join ShipmentLPConfirmDetail(nolock) on SCD_SCH_ID=SCH_ID
                                where SCH_SalesNo=SPH_ShipmentNbr 
                                  and SCD_UPN=PMA_UPN 
                                  and CASE WHEN charindex('NoQR',SCD_Lot) > 0 THEN substring(SCD_Lot,1,charindex('@@',SCD_Lot)-1)+'@@NoQR' ELSE SCD_Lot END= LTM_LotNumber and SPH_Status='Complete'
                              ),(select CFNP_Price from CFNPrice(nolock) 
                                           where CFN_ID=CFNP_CFN_ID and CFNP_PriceType='DealerConsignment' 
                                             and CFNP_Group_ID=SPH_Dealer_DMA_ID) 
  			                     )*SLT_LotShippedQty
  			,PurchaseAmount=interface.fn_GetPurchasePrice(CFN.CFN_ID,SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type)/1.17*SLT_LotShippedQty  			
  			,Transaction_Date=SCH_ConfirmDate
  			,DealerID=DMA_ID
  			,Dealer=DMA_ChineseName
  			,DealerLevel=DMA_DealerType  			
  			,DATEPART(YEAR,SCH_ConfirmDate) AS [Year]  		
  			,DATEPART(month,SCH_ConfirmDate) as [MONTH]
  			,Division
  			,DivisionID=b.DivisionID
  			,Province=HOS_Province
  			,ProvinceID=TER_ID
  			,Region=''
  			,RegionID=''
  			,ParentDealerID=DMA_Parent_DMA_ID
  			,SAPID=DMA_SAP_Code
  			,ParentSAPID=(select DMA_SAP_Code from DealerMaster b(nolock) where b.DMA_ID=d.DMA_Parent_DMA_ID)
  			,Selltype=2
  			,ProductLine=case when (select COUNT(*) from dealerEmergingMarket(nolock)
                                 where SPH_Dealer_DMA_ID=DMT_DMA_ID)>=1 and ATTRIBUTE_NAME ='心脏介入（普通市场）' 
                          then N'心脏介入（新兴市场）' 
                          else ATTRIBUTE_NAME end
        ,InputTime=ISNULL(ShipmentLot.InputTime,SPH_UpdateDate)
        ,NBR=SPH_ShipmentNbr
        ,Staus=SPH_Status
        --,(select max(SCH_ImportDate) from ShipmentLPConfirmHeader(nolock) where SCH_SalesNo = ShipmentHeader.SPH_ShipmentNbr) As interfaceUploadDate
		,ImportDate.SCH_ImportDate As interfaceUploadDate
    from ShipmentHeader(nolock)
            INNER JOIN ShipmentLine(nolock) ON ShipmentHeader.SPH_ID = ShipmentLine.SPL_SPH_ID
            INNER JOIN ShipmentLot(nolock) ShipmentLot on ShipmentLine.SPL_ID=ShipmentLot.SLT_SPL_ID 
            INNER JOIN Product(nolock) ON ShipmentLine.SPL_Shipment_PMA_ID = Product.PMA_ID
            INNER JOIN CFN(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
            INNER JOIN Lot(nolock) ON ISNULL(ShipmentLot.SLT_QRLOT_ID,ShipmentLot.SLT_LOT_ID) = Lot.LOT_ID
            INNER JOIN LotMaster(nolock) ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
            LEFT JOIN DealerMaster(nolock) d on SPH_Dealer_DMA_ID=d.DMA_ID
            LEFT JOIN Hospital(nolock) on HOS_ID=SPH_Hospital_HOS_ID
            LEFT JOIN interface.T_I_CR_Product(nolock) b on b.UPN=PMA_UPN
            LEFT JOIN interface.T_I_CR_Division(nolock) c on c.DivisionID=b.DivisionID
            LEFT JOIN Territory(nolock) a on HOS_Province=a.TER_Description and a.TER_Type='Province'
            LEFT JOIN View_ProductLine(nolock) AS VPL ON VPL.Id = SPH_ProductLine_BUM_ID
  		    LEFT JOIN ShipmentLPConfirmHeader on SCH_SalesNo=SPH_ShipmentNbr 
			LEFT JOIN [interface].[Stage_V_LPSalesImportDate] ImportDate on ImportDate.SCH_SalesNo = ShipmentHeader.SPH_ShipmentNbr
    where SPH_Status IN ('Complete') --,'Reversed')
      and SPH_Type!='Hospital' and DMA_DealerType='T2'
  	  and SCH_ConfirmDate is not null 
  	  and SCH_ConfirmDate >= Convert(datetime,convert(varchar(8),dateadd(mm,-12,getdate()),120) + '01')	
           
UNION ALL   
      
--退换货
  SELECT ID=InventoryAdjustLot.IAL_ID,
         [UPN]=PMA_UPN ,
         --V_LotMaster.LTM_LotNumber AS LOT,
		     --V_LotMaster.LTM_QrCode AS QRCode,
         --LOT=ISNULL(LTM_LotNumber,IAL_LotNumber) ,
         
         CASE WHEN charindex('@@',LTM_LotNumber) > 0 
              THEN substring(LTM_LotNumber,1,charindex('@@',LTM_LotNumber)-1) 
              ELSE LTM_LotNumber
              END AS LOT,
         CASE WHEN charindex('@@',LTM_LotNumber) > 0
              THEN substring(LTM_LotNumber,charindex('@@',LTM_LotNumber)+2,len(LTM_LotNumber)) 
              ELSE ''
              END AS QRCode,
         
         [ExpDate]=CASE WHEN CFN_Property6 = '1' THEN CONVERT (VARCHAR (10), ISNULL(LTM_ExpiredDate, IAL_ExpiredDate) , 120)
                        WHEN CFN_Property6 = '0' THEN CONVERT (NVARCHAR (10), LTM_ExpiredDate, 120) END ,
         [purchasePrice]=Convert(money,[interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID,whm.WHM_DMA_ID,whm.WHM_Type)/1.17),
         SellingPrice=ISNULL((select top 1 SCD_UnitPrice from ShipmentLPConfirmHeader(nolock)
                                left join ShipmentLPConfirmDetail(nolock) on SCD_SCH_ID=SCH_ID 
                               where SCD_UPN=PMA_UPN 
                                 and CASE WHEN charindex('NoQR',SCD_Lot) > 0 THEN substring(SCD_Lot,1,charindex('@@',SCD_Lot)-1)+'@@NoQR' ELSE SCD_Lot END=ISNULL(LTM_LotNumber,IAL_LotNumber)
                                 and SCH_SalesNo=IAH_Inv_Adj_Nbr),interface.QV_GetReturnPrice(CFN_ID,IAH_DMA_ID)),
         [Qty]=-IAL_LotQty,    
		     SellingAmount= ISNULL((select top 1 SCD_UnitPrice from ShipmentLPConfirmHeader(nolock)
                                  left join ShipmentLPConfirmDetail(nolock) on SCD_SCH_ID=SCH_ID  
                                 where SCD_UPN=PMA_UPN 
                                   and CASE WHEN charindex('NoQR',SCD_Lot) > 0 THEN substring(SCD_Lot,1,charindex('@@',SCD_Lot)-1)+'@@NoQR' ELSE SCD_Lot END=ISNULL(LTM_LotNumber,IAL_LotNumber)
                                   and SCH_SalesNo=IAH_Inv_Adj_Nbr),interface.QV_GetReturnPrice(CFN_ID,IAH_DMA_ID)) *-IAL_LotQty,
			  
         [PurchaseAmount]=Convert(money,[interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID,whm.WHM_DMA_ID,whm.WHM_Type)/1.17)*-IAL_LotQty,
         [Transaction_Date]=CONVERT (VARCHAR (10), IAH_ApprovalDate, 120),        
         [DealerID]=DMA_ID,
         Dealer=DMA_ChineseName,
         DealerLevel=DMA_DealerType,       
         [Year]=year(IAH_ApprovalDate),
         [Month]=Month(IAH_ApprovalDate),
         [Division],
	       [DivisionID]=b.DivisionID,
	       [Province]=d.DMA_Province,
	       [ProvinceID]=TER_ID,
	       [Region]='',
	       [RegionID]='',
	       ParentDealerID=DMA_Parent_DMA_ID,
	       [SAPID]=d.DMA_SAP_Code,
	       [ParentSAPID]=(select DMA_SAP_Code from DealerMaster(nolock) where DMA_ID=d.DMA_Parent_DMA_ID),
	       Selltype=3,
	       ProductLine=	case when (select COUNT(*) from dealerEmergingMarket(nolock) where inv.IAH_DMA_ID=DMT_DMA_ID)>=1 
                                and ATTRIBUTE_NAME ='心脏介入（普通市场）' 
                           then N'心脏介入（新兴市场）' else ATTRIBUTE_NAME end,
         InputTime=(select MAX(POL_OperDate) from PurchaseOrderLog(nolock) where POL_POH_ID=inv.IAH_ID),
         NBR=IAH_Inv_Adj_Nbr,
         Staus=IAH_Status,
         --(select max(SCH_ImportDate) from ShipmentLPConfirmHeader(nolock) where SCH_SalesNo = inv.IAH_Inv_Adj_Nbr) As interfaceUploadDate
		 ImportDate.SCH_ImportDate As interfaceUploadDate
    FROM InventoryAdjustHeader(nolock) inv
         INNER JOIN InventoryAdjustDetail(nolock)
            ON InventoryAdjustDetail.IAD_IAH_ID = inv.IAH_ID
         INNER JOIN InventoryAdjustLot(nolock)
            ON InventoryAdjustLot.IAL_IAD_ID = InventoryAdjustDetail.IAD_ID
         INNER JOIN DealerMaster(nolock) d
            ON d.DMA_ID = inv.IAH_DMA_ID
         INNER JOIN Lafite_DICT(nolock)
            ON DICT_TYPE = 'CONST_AdjustQty_Type' AND DICT_KEY = inv.IAH_Reason
         INNER JOIN Product(nolock)
            ON Product.PMA_ID = InventoryAdjustDetail.IAD_PMA_ID
         INNER JOIN CFN(nolock)
            ON CFN.CFN_ID = Product.PMA_CFN_ID
         INNER JOIN View_ProductLine(nolock)
            ON View_ProductLine.Id = inv.IAH_ProductLine_BUM_ID
         LEFT OUTER JOIN Lot(nolock) ON isnull(InventoryAdjustLot.IAL_QRLOT_ID,InventoryAdjustLot.IAL_LOT_ID) = Lot.LOT_ID
		     LEFT OUTER JOIN LotMaster(nolock) ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
         LEFT JOIN interface.T_I_CR_Product (nolock) b on b.UPN=PMA_UPN
         LEFT JOIN interface.T_I_CR_Division(nolock) c on c.DivisionID=b.DivisionID
         LEFT JOIN Territory(nolock) a on DMA_Province=a.TER_Description and a.TER_Type='Province'
         LEFT JOIN Warehouse(nolock) whm on InventoryAdjustLot.IAL_WHM_ID=whm.WHM_ID
		 LEFT JOIN [interface].[Stage_V_LPSalesImportDate] ImportDate on ImportDate.SCH_SalesNo = inv.IAH_Inv_Adj_Nbr
   WHERE IAH_Status in ('Accept') 
     and IAH_Reason in ('Return','Exchange') 
     and DMA_DealerType='T2'
     and whm.WHM_Type in ('Normal','DefaultWH','Frozen')
     AND IAH_ApprovalDate<'2016-01-31 0:00:00'
     and IAH_ApprovalDate >= Convert(datetime,convert(varchar(8),dateadd(mm,-12,getdate()),120) + '01')	
UNION ALL     
     
--退换货（二维码逻辑）
  SELECT ID=InventoryAdjustLot.IAL_ID,
         [UPN]=PMA_UPN ,
         --V_LotMaster.LTM_LotNumber AS LOT,
		     --V_LotMaster.LTM_QrCode AS QRCode,
         --LOT=ISNULL(LTM_LotNumber,IAL_LotNumber) ,
         
         CASE WHEN charindex('@@',LTM_LotNumber) > 0 
              THEN substring(LTM_LotNumber,1,charindex('@@',LTM_LotNumber)-1) 
              ELSE LTM_LotNumber
              END AS LOT,
         CASE WHEN charindex('@@',LTM_LotNumber) > 0
              THEN substring(LTM_LotNumber,charindex('@@',LTM_LotNumber)+2,len(LTM_LotNumber)) 
              ELSE ''
              END AS QRCode,
         
         [ExpDate]=CASE WHEN CFN_Property6 = '1' THEN CONVERT (VARCHAR (10), ISNULL(LTM_ExpiredDate, IAL_ExpiredDate) , 120)
                        WHEN CFN_Property6 = '0' THEN CONVERT (NVARCHAR (10), LTM_ExpiredDate, 120) END ,
         [purchasePrice]=Convert(money,[interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID,whm.WHM_DMA_ID,whm.WHM_Type)/1.17),
         SellingPrice=ISNULL((select top 1 SCD_UnitPrice from ShipmentLPConfirmHeader(nolock)
                                left join ShipmentLPConfirmDetail on SCD_SCH_ID=SCH_ID 
                               where SCD_UPN=PMA_UPN 
                                 and CASE WHEN charindex('NoQR',SCD_Lot) > 0 THEN substring(SCD_Lot,1,charindex('@@',SCD_Lot)-1)+'@@NoQR' ELSE SCD_Lot END=ISNULL(LTM_LotNumber,IAL_LotNumber)
                                 and SCH_SalesNo=IAH_Inv_Adj_Nbr),ISNULL((select Price from TMP_SalesPrice_LPQ1 tsl(nolock)
                                                                           where Product.PMA_UPN=tsl.UPN
			                                                                       and tsl.Dealer_SAP_Code=d.DMA_SAP_Code and DataType='return'),interface.QV_GetReturnPrice(CFN_ID,IAH_DMA_ID))),
         [Qty]= CASE WHEN TDC_Qty =0 then 0 ELSE -IAL_LotQty END,    
		     SellingAmount= ISNULL((select top 1 SCD_UnitPrice from ShipmentLPConfirmHeader(nolock)
                                  left join ShipmentLPConfirmDetail on SCD_SCH_ID=SCH_ID  
                                 where SCD_UPN=PMA_UPN 
                                   and CASE WHEN charindex('NoQR',SCD_Lot) > 0 THEN substring(SCD_Lot,1,charindex('@@',SCD_Lot)-1)+'@@NoQR' ELSE SCD_Lot END=ISNULL(LTM_LotNumber,IAL_LotNumber)
                                   and SCH_SalesNo=IAH_Inv_Adj_Nbr),ISNULL((select Price from TMP_SalesPrice_LPQ1 tsl(nolock)
                                                                             where Product.PMA_UPN=tsl.UPN
			                                                                         and tsl.Dealer_SAP_Code=d.DMA_SAP_Code 
                                                                               and DataType='return'),interface.QV_GetReturnPrice(CFN_ID,IAH_DMA_ID))) * CASE WHEN TDC_Qty =0 then 0 ELSE -IAL_LotQty END,
			  
         [PurchaseAmount]=Convert(money,[interface].[fn_GetPurchasePriceForInventory](CFN.CFN_ID,whm.WHM_DMA_ID,whm.WHM_Type)/1.17)* CASE WHEN TDC_Qty =0 then 0 ELSE -IAL_LotQty END,
         [Transaction_Date]=CONVERT (VARCHAR (10), IAH_ApprovalDate, 120),        
         [DealerID]=DMA_ID,
         Dealer=DMA_ChineseName,
         DealerLevel=DMA_DealerType,       
         [Year]=year(IAH_ApprovalDate),
         [Month]=Month(IAH_ApprovalDate),
         [Division],
	       [DivisionID]=b.DivisionID,
	       [Province]=d.DMA_Province,
	       [ProvinceID]=TER_ID,
	       [Region]='',
	       [RegionID]='',
	       ParentDealerID=DMA_Parent_DMA_ID,
	       [SAPID]=d.DMA_SAP_Code,
	       [ParentSAPID]=(select DMA_SAP_Code from DealerMaster(nolock) where DMA_ID=d.DMA_Parent_DMA_ID),
	       Selltype=3,
	       ProductLine=	case when (select COUNT(*) from dealerEmergingMarket(nolock) where inv.IAH_DMA_ID=DMT_DMA_ID)>=1 
                                and ATTRIBUTE_NAME ='心脏介入（普通市场）' 
                           then N'心脏介入（新兴市场）' else ATTRIBUTE_NAME end,
         InputTime=(select MAX(POL_OperDate) from PurchaseOrderLog(nolock) where POL_POH_ID=inv.IAH_ID),
         NBR=IAH_Inv_Adj_Nbr,
         Staus=IAH_Status,
         --(select max(SCH_ImportDate) from ShipmentLPConfirmHeader(nolock) where SCH_SalesNo = inv.IAH_Inv_Adj_Nbr) As interfaceUploadDate
		 ImportDate.SCH_ImportDate As interfaceUploadDate
    FROM InventoryAdjustHeader(nolock) inv
         INNER JOIN InventoryAdjustDetail(nolock)
            ON InventoryAdjustDetail.IAD_IAH_ID = inv.IAH_ID
         INNER JOIN InventoryAdjustLot(nolock)
            ON InventoryAdjustLot.IAL_IAD_ID = InventoryAdjustDetail.IAD_ID
         INNER JOIN DealerMaster(nolock) d
            ON d.DMA_ID = inv.IAH_DMA_ID
         INNER JOIN Lafite_DICT(nolock)
            ON DICT_TYPE = 'CONST_AdjustQty_Type' AND DICT_KEY = inv.IAH_Reason
         INNER JOIN Product(nolock)
            ON Product.PMA_ID = InventoryAdjustDetail.IAD_PMA_ID
         INNER JOIN CFN(nolock)
            ON CFN.CFN_ID = Product.PMA_CFN_ID
         INNER JOIN View_ProductLine(nolock)
            ON View_ProductLine.Id = inv.IAH_ProductLine_BUM_ID
         INNER JOIN Lot(nolock) ON isnull(InventoryAdjustLot.IAL_QRLOT_ID,InventoryAdjustLot.IAL_LOT_ID) = Lot.LOT_ID
         INNER JOIN LotMaster(nolock) ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
         INNER JOIN Tmp_DealerReturnConfirm AS DRC
            ON (DRC.TDC_IAH_ID = inv.IAH_ID and Product.PMA_UPN = DRC.TDC_UPN 
                and DRC.TDC_Lot = LotMaster.LTM_LotNumber)
         LEFT JOIN interface.T_I_CR_Product (nolock) b on b.UPN=PMA_UPN
         LEFT JOIN interface.T_I_CR_Division(nolock) c on c.DivisionID=b.DivisionID
         LEFT JOIN Territory(nolock) a on DMA_Province=a.TER_Description and a.TER_Type='Province'
         LEFT JOIN Warehouse(nolock) whm on InventoryAdjustLot.IAL_WHM_ID=whm.WHM_ID
		 LEFT JOIN [interface].[Stage_V_LPSalesImportDate] ImportDate on ImportDate.SCH_SalesNo = inv.IAH_Inv_Adj_Nbr
   WHERE IAH_Status in ('Accept','Submitted') 
     and IAH_Reason in ('Return','Exchange') 
     and DMA_DealerType='T2'
     and whm.WHM_Type in ('Normal','DefaultWH','Frozen')
     AND IAH_ApprovalDate>'2016-01-31 0:00:00'  
     and IAH_ApprovalDate >= Convert(datetime,convert(varchar(8),dateadd(mm,-12,getdate()),120) + '01')




GO


