DROP view  [interface].[V_I_DPS_BusinessSample_DeliveryNotification]
GO

CREATE view  [interface].[V_I_DPS_BusinessSample_DeliveryNotification] As 
select t2.ApplyNo,t1.ShipmentNbr,t3.PRH_TrackingNo, t1.DeliveryTime,t2.ApplyUserId,t2.ApplyUser,'���������ҵ��Ʒ�����ţ�'+ isnull(t2.ApplyNo,'') +'���Ѿ����������Ʒ������ţ�'+ isnull(t1.ShipmentNbr,'') +'����ݵ��ţ�'+ CASE WHEN Len(isnull(t3.PRH_TrackingNo,''))>0 THEN t3.PRH_TrackingNo ELSE '����' END+'����������΢����ҵ�ŵ���ҵ��Ʒģ���в�ѯ������Ϣ��' AS [Notification]
 from interface.V_I_QV_SampleSAPDelivery t1 inner join SampleApplyHead t2 on (t1.OrderNumber = t2.ApplyNo)
      left join POReceiptHeader t3 on (t1.ShipmentNbr = t3.PRH_SAPShipmentID)
where  t2.SampleType='��ҵ��Ʒ' and t1.DeliveryType='PurchaseOrder'
group by t2.ApplyNo,t1.ShipmentNbr,t1.DeliveryTime,t2.ApplyUserId,t2.ApplyUser,t3.PRH_TrackingNo
GO


