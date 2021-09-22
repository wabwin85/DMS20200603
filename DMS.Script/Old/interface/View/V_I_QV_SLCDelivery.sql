DROP view [interface].[V_I_QV_SLCDelivery]
GO

create view [interface].[V_I_QV_SLCDelivery]
AS
select DeliveryNo,DeliveryDate,SoldToSAPCod,SoldToName,ShipToSAPCode,ShipToName,UPN,LOT,ExpireDate,sum(Qty)  AS Qty,BoxNo,Remark,OrderNo,createDate
from interface.V_I_QV_SLCDelivery_WithQR
group by DeliveryNo,DeliveryDate,SoldToSAPCod,SoldToName,ShipToSAPCode,ShipToName,UPN,LOT,ExpireDate,BoxNo,Remark,OrderNo,createDate

GO


