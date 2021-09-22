DROP VIEW [dbo].[V_HospitalMarketProperty]

GO





CREATE VIEW [dbo].[V_HospitalMarketProperty]
AS
SELECT A.DMSCode AS HospitalCode,
       c.HOS_HospitalName AS HospitalName,
       C.HOS_ID AS HospitalId,
       CONVERT(nvarchar(10),A.DivisionID) AS DivisionId,
       B.DivisionName AS DivisionName,
       b.ProductLineID AS ProductLineId,
       b.ProductLineName AS ProductLineName,
       CONVERT(nvarchar(10),A.MarketProperty) AS MarketProperty,
       CASE A.MarketProperty
          WHEN 1 THEN '新兴市场'
          WHEN 0 THEN '普通市场'
       END
          AS MarketName
  FROM interface.[HospitalMarketProperty] A with(nolock) 
       INNER JOIN V_DivisionProductLineRelation B
          ON CONVERT(nvarchar(10),A.DivisionID) = B.DivisionCode AND ISNULL(B.IsEmerging,'0') = '0'
       LEFT JOIN Hospital C(nolock)
          ON A.DMSCode = C.HOS_Key_Account






GO


