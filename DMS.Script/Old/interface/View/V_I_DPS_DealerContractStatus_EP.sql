DROP view [interface].[V_I_DPS_DealerContractStatus_EP]
GO

CREATE view [interface].[V_I_DPS_DealerContractStatus_EP] AS 
select Tab.*,
case when status='Delivery' then (select top 1 '经销商：'+ CompanyName + '(' + DM.DMA_SAP_CODE +')的订单波科已发货，快递单号：'+ CASE WHEN Len(isnull(PRH_TrackingNo,''))>0 THEN PRH_TrackingNo ELSE '暂无' END 
                                    from POReceiptHeader where PRH_Dealer_DMA_ID = tab.CompanyID 
                                     and PRH_Status in ('Complete','Waiting') and PRH_Type ='PurchaseOrder' 
                                     and Tab.OperDate = PRH_SAPShipmentDate ) 
     WHEN status='ContractApply' then  '经销商：'+ CompanyName + '(' + DM.DMA_SAP_CODE +')的合同已提交审批'
     WHEN status='ContractAproved' then  '经销商：'+ CompanyName + '(' + DM.DMA_SAP_CODE +')的合同已审批通过'
     WHEN status='ContractEffective' then  '经销商：'+ CompanyName + '(' + DM.DMA_SAP_CODE +')的合同已正式生效'
     WHEN status='NewPrice' then  '经销商：'+ CompanyName + '(' + DM.DMA_SAP_CODE +')的价格申请已审批通过'
     WHEN status='Order' then  '经销商：'+ CompanyName + '(' + DM.DMA_SAP_CODE +')的订单已提交审批，还未发货'     
  ELSE '' END AS Notification
from
(
select RS.CompanyID,RS.CompanyName,RS.DealerType,EId,EName,
case when DeliveryDate is not null then 'Delivery' 
 when OrderDate is not null then 'Order'
 when NewPriceDate is not null then 'NewPrice'
 when len(UpdateDate)<>0    then 
                                     CASE WHEN Convert(datetime,updateDate)<AgreementBegin THEN 'ContractAproved' ELSE 'ContractEffective' END
     ELSE 'ContractApply' END AS Status,
     
case when DeliveryDate is not null then DeliveryDate
     when OrderDate is not null then OrderDate
     when NewPriceDate is not null then NewPriceDate
     when len(UpdateDate)<>0 then 
                                     CASE WHEN Convert(datetime,updateDate)<AgreementBegin THEN Convert(datetime,updateDate) ELSE AgreementBegin END
     ELSE RequestDate END AS OperDate
from 
(
select DCS.*,DC.EId,DC.EName from (  
  select tab.CompanyID,CompanyName, DealerType,max(RequestDate) As RequestDate,max(AgreementBegin) AS AgreementBegin,max(AgreementEnd) AS AgreementEnd,max(UpdateDate) As UpdateDate,
         (select max(CFNP_CreateDate) from cfnprice cfp where cfp.CFNP_Group_ID = tab.CompanyID  ) As NewPriceDate,
         (select max(POH_CreateDate) from PurchaseOrderHeader where tab.CompanyID = POH_DMA_ID and POH_CreateType ='Manual' and POH_OrderStatus not in ('Draft','Rejected','Revoked')) AS OrderDate,
         (select max(PRH_SAPShipmentDate) from POReceiptHeader where PRH_Dealer_DMA_ID = tab.CompanyID and PRH_Status in ('Complete','Waiting') and PRH_Type ='PurchaseOrder' ) As DeliveryDate
   from interface.V_I_DPS_DealerContractStatus tab 
	  where DepId=32 and ContractType in ('Appointment','Amendment') 
    group by CompanyName, DealerType,tab.CompanyID
)  DCS inner join  interface.V_I_DPS_DealerContractStatus AS DC 
      on (DCS.CompanyID = DC.CompanyID and DCS.DealerType = DC.DealerType and DCS.RequestDate=DC.RequestDate and DC.AgreementBegin = DCS.AgreementBegin and DC.AgreementEnd = DCS.AgreementEnd )
) RS      
) AS Tab inner join DealerMaster DM on (DM.DMA_ID= Tab.CompanyID)
GO


