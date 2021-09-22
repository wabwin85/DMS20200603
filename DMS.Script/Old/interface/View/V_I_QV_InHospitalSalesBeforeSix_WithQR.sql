DROP view [interface].[V_I_QV_InHospitalSalesBeforeSix_WithQR]
GO

CREATE view [interface].[V_I_QV_InHospitalSalesBeforeSix_WithQR]
as
		select	
	
			ID=SLT_ID
			,DealerID=SPH_Dealer_DMA_ID
			,ParentDealerID=d.DMA_Parent_DMA_ID
			,UPN=PMA_UPN
			--,LOT=LTM_LotNumber
      ,CASE WHEN charindex('@@',LTM_LotNumber) > 0 
            THEN substring(LTM_LotNumber,1,charindex('@@',LTM_LotNumber)-1) 
            ELSE LTM_LotNumber
            END AS LOT
      ,CASE WHEN charindex('@@',LTM_LotNumber) > 0
            THEN substring(LTM_LotNumber,charindex('@@',LTM_LotNumber)+2,len(LTM_LotNumber)) 
            ELSE ''
            END AS QRCode
			,ExpDate=LTM_ExpiredDate
			,Transaction_Date=SPH_ShipmentDate
			,SellingPrice=SLT_UnitPrice
			,Qty=SLT_LotShippedQty
			,SellingAmount=SLT_UnitPrice*SLT_LotShippedQty
			,purchasePrice=	interface.fn_GetPurchasePrice(CFN.CFN_ID,SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type)/1.17 
			,PurchaseAmount=interface.fn_GetPurchasePrice(CFN.CFN_ID,SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type)/1.17*SLT_LotShippedQty
			--,purchasePrice=ISNULL(interface.QV_GetHospitalPrice(DMA_SAP_Code,PMA_UPN,SPH_ShipmentDate),
			--interface.fn_GetPurchasePrice(CFN.CFN_ID,SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type)/1.17 )
			--,PurchaseAmount=ISNULL(interface.QV_GetHospitalPrice(DMA_SAP_Code,PMA_UPN,SPH_ShipmentDate),
			--interface.fn_GetPurchasePrice(CFN.CFN_ID,SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type)/1.17 )*SLT_LotShippedQty
			,DMScode=HOS_Key_Account
			,Hospital=HOS_HospitalName
			,DATEPART(YEAR,ShipmentHeader.SPH_ShipmentDate) AS [Year]
			,DATEPART(MONTH,ShipmentHeader.SPH_ShipmentDate) AS [Month]
			,V_DivisionProductLineRelation.DivisionName AS Division--Division
	        ,V_DivisionProductLineRelation.DivisionCode AS DivisionID -- b.DivisionID			
			,Province=HOS_Province
			,ProvinceID=TER_ID
			,Region=''
			,RegionID=''
			,SalesType=SPH_Type
			,SPH_InvoiceDate AS InvoiceDate
			,SPH_InvoiceNo AS Invoice
			,SAPID=DMA_SAP_Code
			,SubmitDate=SPH_SubmitDate
			,ParentSAPID=(select DMA_SAP_Code from DealerMaster b where b.DMA_ID=d.DMA_Parent_DMA_ID)
			,SPH_ShipmentNbr
			,i.WHM_Code
			,case when   DMA_DealerType='LP'
                --and i.WHM_Type='Normal' and i.WHM_Name=N'波科借货库'
                and i.WHM_Type='Borrow'
                then 1 --平台中波科的寄售货
		   when DMA_DealerType='LP'
		        and i.WHM_Type in ('Normal','DefaultWH')
		        --and i.WHM_Name<>N'波科借货库' 
		        then 2 --平台的平台正常采购货
		  when DMA_DealerType='T1' and i.WHM_Type in ('Normal','DefaultWH','Frozen')
		        then 3   --一级的一级采购库
          when DMA_DealerType='T1' 
          --and i.WHM_Type not in ('Normal','DefaultWH')
          and i.WHM_Type='Borrow'
		        then 4   --一级的波科借货库
		   when  DMA_DealerType='T2' and i.WHM_Type in ('Normal','DefaultWH','Frozen')
		        then 5   --二级的二级采购库
		   when   DMA_DealerType='T2'
		         --and i.WHM_Type='LP_Consignment' and i.WHM_Name like '%波科%'
		         and i.WHM_Type='Consignment'
		         then 6  --二级的波科寄售货
		   when   DMA_DealerType='T2' 
		         and i.WHM_Type='LP_Consignment'
		          --and i.WHM_Name not like '%波科%' 
		         then 7  --二级的平台寄售货 
       ELSE 0 end as InventoryTypeID,
		         SPH_Status
  from ShipmentHeader
          INNER JOIN ShipmentLine(nolock) ON ShipmentHeader.SPH_ID = ShipmentLine.SPL_SPH_ID
          INNER JOIN ShipmentLot(nolock) ShipmentLot on ShipmentLine.SPL_ID=ShipmentLot.SLT_SPL_ID 
          INNER JOIN Product(nolock) ON ShipmentLine.SPL_Shipment_PMA_ID = Product.PMA_ID
          INNER JOIN CFN(nolock) ON Product.PMA_CFN_ID = CFN.CFN_ID
          INNER JOIN Lot(nolock) ON ShipmentLot.SLT_LOT_ID = Lot.LOT_ID
          INNER JOIN LotMaster(nolock) ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
          INNER join DealerMaster d(nolock) on SPH_Dealer_DMA_ID=d.DMA_ID
          INNER join Hospital(nolock) on HOS_ID=SPH_Hospital_HOS_ID
          INNER JOIN V_DivisionProductLineRelation(nolock) ON CFN.CFN_ProductLine_BUM_ID = V_DivisionProductLineRelation.ProductLineID
          --left join interface.T_I_CR_Product b(nolock) on b.UPN=PMA_UPN
          --left join interface.T_I_CR_Division c(nolock) on c.DivisionID=b.DivisionID
          INNER join CalendarDate(nolock) on CDD_Calendar=convert(nvarchar(6),SPH_SubmitDate,112)
          INNER join Warehouse i(nolock) on WHM_ID=SLT_WHM_ID
          left join Territory a(nolock) on HOS_Province=a.TER_Description and a.TER_Type='Province'          
        where
           SPH_Status IN ('Complete','Reversed')
           --and SPH_SubmitDate>=DATEADD(mm,DATEDIFF(mm,0,getdate()),0)
           and DATEDIFF(m,SPH_ShipmentDate,SPH_SubmitDate)=1
           and Day(SPH_SubmitDate) between 1 and CDD_Date1
GO


