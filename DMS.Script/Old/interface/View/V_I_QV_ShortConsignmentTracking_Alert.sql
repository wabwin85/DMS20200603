DROP view [interface].[V_I_QV_ShortConsignmentTracking_Alert]
GO

CREATE view [interface].[V_I_QV_ShortConsignmentTracking_Alert] AS 
select DMA_SAP_Code, DMA_ChineseName AS '����������', PORCfnCode AS 'UPN', CfnCode2 AS '�̱��',CLotNumber AS '����',CQRCode AS '��ά��', CahOrderNo AS '���뵥��',-OverdueDays AS '��������'
from [interface].[T_I_QV_ShortConsignmentTrackingReport]
GO


