DROP view [interface].[V_I_QV_ShortConsignmentTracking_Alert]
GO

CREATE view [interface].[V_I_QV_ShortConsignmentTracking_Alert] AS 
select DMA_SAP_Code, DMA_ChineseName AS '经销商名称', PORCfnCode AS 'UPN', CfnCode2 AS '短编号',CLotNumber AS '批号',CQRCode AS '二维码', CahOrderNo AS '申请单号',-OverdueDays AS '超期天数'
from [interface].[T_I_QV_ShortConsignmentTrackingReport]
GO


