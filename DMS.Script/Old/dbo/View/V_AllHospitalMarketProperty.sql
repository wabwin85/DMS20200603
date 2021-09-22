DROP VIEW [dbo].[V_AllHospitalMarketProperty]
GO








CREATE VIEW [dbo].[V_AllHospitalMarketProperty]
AS
SELECT TAB.HOS_ID Hos_Id,
       TAB.HOS_HospitalName Hos_Name,
       TAB.HOS_Key_Account Hos_Code,
       TAB.ProductLineID,
       TAB.ProductLineName,
       TAB.DivisionCode,
       TAB.DivisionName,
       CASE
          WHEN ISNULL (MAR.MarketProperty, '') = '' THEN 2
          ELSE MAR.MarketProperty
       END
          AS MarketProperty,
       CASE
          WHEN ISNULL (MAR.MarketName, '') = '' THEN NULL
          ELSE MAR.MarketName
       END
          AS MarketName,
       CASE WHEN ISNULL (MAR.MarketName, '') = '' THEN 0 ELSE 1 END
          AS HosRelation
  FROM    (SELECT HOS.HOS_ID,
                  HOS.HOS_HospitalName,
                  HOS.HOS_Key_Account,
                  PL.ProductLineID,
                  PL.ProductLineName,
                  PL.DivisionCode,
                  PL.DivisionName
             FROM Hospital HOS(nolock), V_DivisionProductLineRelation PL
            WHERE ISNULL (PL.IsEmerging, 0) = 0 AND HOS.HOS_ActiveFlag=1 AND PL.DivisionCode IN (SELECT DISTINCT CONVERT(NVARCHAR(10), Divisionid ) FROM interface.HospitalMarketProperty )) TAB
       LEFT JOIN
          V_HospitalMarketProperty MAR
       ON     MAR.HospitalId = TAB.HOS_ID
          AND TAB.ProductLineID = MAR.ProductLineId
UNION
SELECT HOS.HOS_ID Hos_Id,
                  HOS.HOS_HospitalName Hos_Name,
                  HOS.HOS_Key_Account Hos_Code,
                  PL.ProductLineID ProductLineID,
                  PL.ProductLineName ProductLineName,
                  PL.DivisionCode DivisionCode,
                  PL.DivisionName DivisionName,
                  0 AS MarketProperty,
                  '∆’Õ® –≥°' AS MarketName,
                  0 AS HosRelation
             FROM Hospital HOS(nolock), V_DivisionProductLineRelation PL
            WHERE ISNULL (PL.IsEmerging, 0) = 0 
            AND PL.DivisionCode NOT IN (SELECT DISTINCT CONVERT(NVARCHAR(10), Divisionid ) FROM interface.HospitalMarketProperty)
   






GO


