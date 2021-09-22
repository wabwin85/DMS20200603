DROP proc [interface].[p_i_cr_Sales]
GO

CREATE proc [interface].[p_i_cr_Sales]
as

  Insert into interface.T_I_CR_Sales
	select 
			DealerID=case when DMA_DealerType='T2' then DMA_Parent_DMA_ID else DMA_ID end
		   ,Tier2ID=case when DMA_DealerType='T2' then DMA_SAP_Code else '' end 
		   ,HospitalID=HOS_Key_Account  --医院编号
		   ,UPN=CFN_CustomerFaceNbr
		   ,LOT=LotMaster.LTM_LotNumber
		   ,SellingPrice=SPL_UnitPrice
		   ,PurchasePrice=interface.fn_GetPurchasePrice(ShipmentHeader.SPH_Dealer_DMA_ID,CFN_ID,ShipmentHeader.SPH_Type)
		   ,Qty=SPL_ShipmentQty
		   ,Expdate=LTM_ExpiredDate
		   ,InvoiceDate=SPH_InvoiceDate   --发票日期
		   ,Invoice=SPH_InvoiceNo
		   ,TransactionDate=SPH_ShipmentDate
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
           SPH_Status='Complete' and 
           convert(date,SPH_SubmitDate)=convert(date,GETDATE()-1)
GO


