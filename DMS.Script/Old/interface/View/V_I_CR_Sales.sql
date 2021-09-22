DROP view [interface].[V_I_CR_Sales]
GO




CREATE view [interface].[V_I_CR_Sales]
as

select 
			case when DMA_DealerType='T2' then DMA_Parent_DMA_ID else DMA_ID end AS DealerID
		   ,case when DMA_DealerType='T2' then DMA_SAP_Code else '' end AS Tier2ID
		   ,HOS_Key_Account AS HospitalID
		   ,CFN_CustomerFaceNbr AS UPN
		   ,LotMaster.LTM_LotNumber AS LOT
		   ,SLT_UnitPrice AS SellingPrice
		   ,interface.fn_GetPurchasePrice(CFN.CFN_ID,SPH_Dealer_DMA_ID, ShipmentHeader.SPH_Type)/1.17 AS PurchasePrice
		   ,ShipmentLot.SLT_LotShippedQty AS Qty
		   ,SLT_UnitPrice*SLT_LotShippedQty AS SellingAmount
		   ,LTM_ExpiredDate AS Expdate
		   ,SPH_InvoiceDate AS InvoiceDate
		   ,SPH_InvoiceNo AS Invoice
		   ,SPH_ShipmentDate AS TransactionDate
		   ,ShipmentHeader.SPH_ShipmentNbr AS SalesNo
		   ,ShipmentHeader.SPH_Status AS [Status]
		   ,ShipmentHeader.SPH_SubmitDate AS [Date]
		   --,DATEPART(YEAR,ShipmentHeader.SPH_SubmitDate) AS [Year]
		   --,DATEPART(MONTH,ShipmentHeader.SPH_SubmitDate) AS [Month]
		   ,DATEPART(YEAR,ShipmentHeader.SPH_ShipmentDate) AS [Year]
		   ,DATEPART(MONTH,ShipmentHeader.SPH_ShipmentDate) AS [Month]
		   ,SPH_Type as SalesType
       from ShipmentHeader
          INNER JOIN ShipmentLine ON ShipmentHeader.SPH_ID = ShipmentLine.SPL_SPH_ID
          INNER JOIN ShipmentLot ShipmentLot on ShipmentLine.SPL_ID=ShipmentLot.SLT_SPL_ID 
          INNER JOIN Product ON ShipmentLine.SPL_Shipment_PMA_ID = Product.PMA_ID
          INNER JOIN CFN ON Product.PMA_CFN_ID = CFN.CFN_ID
          INNER JOIN Lot ON ShipmentLot.SLT_LOT_ID = Lot.LOT_ID
          INNER JOIN LotMaster ON Lot.LOT_LTM_ID = LotMaster.LTM_ID
          left join DealerMaster on SPH_Dealer_DMA_ID=DealerMaster.DMA_ID
          left join Hospital on HOS_ID=SPH_Hospital_HOS_ID
        where
           SPH_Status IN ('Complete','Reversed')



GO


