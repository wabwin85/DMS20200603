DROP VIEW [MD].[V_INF_UPN_REG]
GO

CREATE VIEW [MD].[V_INF_UPN_REG]
AS
   SELECT DISTINCT CurReg.CFN_CustomerFaceNbr AS CurUPN,
          CurReg.SAP_Code AS CurShortCode,
          CurReg.REG_NO AS CurRegNo,
          CurReg.SERIAL_NO AS CurRegNoSerial,
          CurReg.GM_KIND AS CurGMKind,
          CurReg.GM_CATALOG AS CurGMCatalog,
          CurReg.PRODUCT_NAME AS CurProductName,
          CurReg.VALID_DATE_FROM AS CurValidDateFrom,
          CurReg.VALID_DATE_TO AS CurValidDataTo,
          CurReg.MANU_NAME AS CurManuName,
          CurReg.STATE AS CurRegStat,
          LastReg.REG_NO AS LastRegNo,
          LastReg.VALID_DATE_FROM AS LastValidDateFrom,
          LastReg.VALID_DATE_TO AS LastValidDataTo,
          LastReg.MANU_NAME AS LastManuName,
          LastReg.STATE AS LastRegStat,
          LastReg.PRODUCT_NAME AS LastProductName
     FROM (SELECT t1.CFN_CustomerFaceNbr,
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
                  LEFT JOIN [MD].[INF_UPN] t2(nolock)
                     ON (t1.CFN_Property1 = t2.SAP_Code)
                  LEFT JOIN [MD].[INF_REG] t3(nolock)
                     ON (t2.REG_No = t3.REG_NO AND t3.STATE = '10')) CurReg
          LEFT JOIN (SELECT DISTINCT CFN.CFN_CustomerFaceNbr,
                                     tab1.UPN,
                                     tab1.REG_NO,
                                     tab1.SERIAL_NO,
                                     tab1.GM_KIND,
                                     tab1.GM_CATALOG,
                                     tab1.PRODUCT_NAME,
                                     tab1.VALID_DATE_FROM,
                                     tab1.VALID_DATE_TO,
                                     tab1.MANU_NAME,
                                     tab1.STATE
                       FROM CFN(nolock)
                            INNER JOIN
                            (SELECT t2.UPN,
                                    t3.REG_NO,
                                    t3.SERIAL_NO,
                                    t3.GM_KIND,
                                    t3.GM_CATALOG,
                                    t3.PRODUCT_NAME,
                                    t3.VALID_DATE_FROM,
                                    t3.VALID_DATE_TO,
                                    t3.MANU_NAME,
                                    t3.STATE
                               FROM [MD].[INF_UPN_HISTORY] t2(nolock)
                                    INNER JOIN [MD].[INF_REG] t3(nolock)
                                       ON (    t2.REG_No = t3.REG_NO
                                           AND isnull (t3.STATE, '0') <> '10'))
                            tab1
                               ON (cfn.CFN_Property1 = tab1.UPN)
                            INNER JOIN
                            (SELECT t2.upn,
                                    max (t3.VALID_DATE_FROM) AS VALID_DATE_FROM
                               FROM [MD].[INF_UPN_HISTORY] t2(nolock)
                                    INNER JOIN [MD].[INF_REG] t3(nolock)
                                       ON (    t2.REG_No = t3.REG_NO
                                           AND isnull (t3.STATE, '0') <> '10')
                             GROUP BY t2.upn) tab2
                               ON (    tab1.upn = tab2.upn
                                   AND tab1.VALID_DATE_FROM =
                                          tab2.VALID_DATE_FROM)) LastReg
             ON (CurReg.CFN_CustomerFaceNbr = LastReg.CFN_CustomerFaceNbr)
GO


