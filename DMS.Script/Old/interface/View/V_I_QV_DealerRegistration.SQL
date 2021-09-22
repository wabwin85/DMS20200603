
DROP VIEW [interface].[V_I_QV_DealerRegistration]
GO

CREATE VIEW [interface].[V_I_QV_DealerRegistration]
AS
SELECT DISTINCT  TAB.DMA_SAP_Code AS [经销商编号],TAB.DMA_ChineseName AS [经销商名称],TAB.DMA_DealerType AS [经销商类型],
  REG.CurRegNo AS [当前注册证号],

      REG.CurValidDateFrom [当前注册证起始日期],

      REG.CurValidDataTo [当前注册证结束日期]

      --,REG.CurManuName [当前注册证生产厂家],

      --REG.LastRegNo [历史注册证号],

      --REG.LastValidDateFrom [历史注册证起始日期],

      --REG.LastValidDataTo [历史注册证结束日期],

      --REG.LastManuName [历史注册证生产厂家],

      --REG.CurGMKind [产品所属分类],

      --REG.CurGMCatalog [产品所属分类代码]
FROM (
SELECT B.DMA_SAP_Code,B.DMA_ChineseName,b.DMA_DealerType ,cfn.CFN_CustomerFaceNbr UPN
FROM DealerAuthorizationTable A 
INNER JOIN DealerMaster B ON A.DAT_DMA_ID=B.DMA_ID
INNER JOIN CfnClassification CC ON CC.ClassificationId=a.DAT_PMA_ID
INNER JOIN CFN ON CFN.CFN_CustomerFaceNbr=CC.CfnCustomerFaceNbr
WHERE GETDATE() between a.DAT_StartDate and a.DAT_EndDate
AND A.DAT_PMA_ID<>A.DAT_ProductLine_BUM_ID
UNION
SELECT B.DMA_SAP_Code,B.DMA_ChineseName,b.DMA_DealerType ,CFN_CustomerFaceNbr
FROM DealerAuthorizationTable A 
INNER JOIN DealerMaster B ON A.DAT_DMA_ID=B.DMA_ID
INNER JOIN CFN ON CFN.CFN_ProductLine_BUM_ID=A.DAT_ProductLine_BUM_ID
WHERE GETDATE() between a.DAT_StartDate and a.DAT_EndDate
AND A.DAT_PMA_ID=A.DAT_ProductLine_BUM_ID) TAB
LEFT JOIN MD.V_INF_UPN_REG AS REG ON TAB.UPN = REG.CurUPN



GO


