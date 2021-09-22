DROP view  [interface].[V_I_DPS_BusinessSample_DeliveryNotification]
GO

CREATE view  [interface].[V_I_DPS_BusinessSample_DeliveryNotification] As 
select t2.ApplyNo,t1.ShipmentNbr,t3.PRH_TrackingNo, t1.DeliveryTime,t2.ApplyUserId,t2.ApplyUser,'您申请的商业样品（单号：'+ isnull(t2.ApplyNo,'') +'）已经发货，波科发货单号：'+ isnull(t1.ShipmentNbr,'') +'，快递单号：'+ CASE WHEN Len(isnull(t3.PRH_TrackingNo,''))>0 THEN t3.PRH_TrackingNo ELSE '暂无' END+'。您可以在微信企业号的商业样品模块中查询物流信息。' AS [Notification]
 from interface.V_I_QV_SampleSAPDelivery t1 inner join SampleApplyHead t2 on (t1.OrderNumber = t2.ApplyNo)
      left join POReceiptHeader t3 on (t1.ShipmentNbr = t3.PRH_SAPShipmentID)
where  t2.SampleType='商业样品' and t1.DeliveryType='PurchaseOrder'
group by t2.ApplyNo,t1.ShipmentNbr,t1.DeliveryTime,t2.ApplyUserId,t2.ApplyUser,t3.PRH_TrackingNo
GO


