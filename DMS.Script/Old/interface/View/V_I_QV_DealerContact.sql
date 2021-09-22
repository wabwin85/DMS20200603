DROP VIEW [interface].[V_I_QV_DealerContact]
GO

CREATE VIEW [interface].[V_I_QV_DealerContact]
AS
SELECT u.BWU_ID AS ContactID
	,d.DMA_SAP_Code AS SAPID
	,BWU_UserName AS ContactName
	,BWU_Phone AS Phone
	,BWU_Post AS JobTitle
	,BWU_NickName AS NickName
	,BWU_Sex AS Gender
	,BWU_Email AS Email
	,CASE WHEN u.BWU_Status = 'Active' THEN 1 ELSE 0 END AS Active
FROM dbo.BusinessWechatUser u WITH (NOLOCK)
INNER JOIN dbo.DealerMaster d WITH (NOLOCK)
	ON u.BWU_DealerId = d.DMA_ID
GO


