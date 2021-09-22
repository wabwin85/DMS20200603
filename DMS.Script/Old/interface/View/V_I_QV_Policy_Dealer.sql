DROP VIEW  [interface].[V_I_QV_Policy_Dealer]
GO


CREATE VIEW  [interface].[V_I_QV_Policy_Dealer]
AS

SELECT B.PolicyId,B.PolicyNo,B.BU,b.SubBu,A.OperType,CASE A.WithType WHEN 'ByAuth' THEN N'��Ȩ������' ELSE N'ָ��������' END WithType,A.DEALERID,C.DMA_SAP_Code AS SAPCode ,C.DMA_ChineseName AS DealerName FROM Promotion.PRO_DEALER A 
INNER JOIN Promotion.PRO_POLICY B ON A.PolicyId=B.PolicyId
LEFT JOIN DealerMaster C ON C.DMA_ID=A.DEALERID

GO


