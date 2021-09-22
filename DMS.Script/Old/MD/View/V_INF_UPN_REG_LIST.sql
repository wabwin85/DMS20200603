DROP VIEW [MD].[V_INF_UPN_REG_LIST]
GO

CREATE VIEW [MD].[V_INF_UPN_REG_LIST]
AS
SELECT t1.CFN_CustomerFaceNbr,
       t2.SAP_Code,
       t3.REG_NO,
       t3.SERIAL_NO,
       t3.GM_KIND,
       t3.GM_CATALOG,
       t3.PRODUCT_NAME,
       t3.VALID_DATE_FROM,
       t3.VALID_DATE_TO,
       t3.MANU_NAME,
       t3.STATE
  FROM cfn t1(nolock)
       LEFT JOIN [MD].[INF_UPN] t2(nolock) ON (t1.CFN_Property1 = t2.SAP_Code)
       LEFT JOIN [MD].[INF_REG] t3(nolock)
          ON (t2.REG_No = t3.REG_NO AND t3.STATE = '10')
UNION ALL
SELECT t1.CFN_CustomerFaceNbr,
       t2.UPN,
       t3.REG_NO,
       t3.SERIAL_NO,
       t3.GM_KIND,
       t3.GM_CATALOG,
       t3.PRODUCT_NAME,
       t3.VALID_DATE_FROM,
       t3.VALID_DATE_TO,
       t3.MANU_NAME,
       isnull (t3.STATE, '0')
  FROM cfn t1(nolock)
       LEFT JOIN [MD].[INF_UPN_HISTORY] t2(nolock) ON (t1.CFN_Property1 = t2.UPN)
       LEFT JOIN [MD].[INF_REG] t3(nolock)
          ON (t2.REG_No = t3.REG_NO AND isnull (t3.STATE, '0') <> '10')
GO


