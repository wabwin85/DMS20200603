SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

ALTER VIEW [dbo].[View_ProductLine]
AS
SELECT T_ProductLine.Id,
       T_ProductLine.ATTRIBUTE_NAME,
       T_ProductLine.ATTRIBUTE_TYPE,
       T_ProductLine.BOOLEAN_FLAG,
       T_ProductLine.DESCRIPTION,
       T_ProductLine.ATTRIBUTE_LEVEL,
       T_ProductLine.ATTRIBUTE_FIELD1,
       T_ProductLine.ATTRIBUTE_FIELD2,
       T_ProductLine.ATTRIBUTE_FIELD3,
       T_ProductLine.ATTRIBUTE_FIELD4,
       T_ProductLine.REV1,
       T_ProductLine.REV2,
       T_ProductLine.REV3,
       T_ProductLine.APP_ID,
       T_ProductLine.SORT_COL,
       T_ProductLine.DELETE_FLAG,
       T_ProductLine.CREATE_USER,
       T_ProductLine.CREATE_DATE,
       T_ProductLine.LAST_UPDATE_USER,
       T_ProductLine.LAST_UPDATE_DATE,
       T_SubCompany.Id AS SubCompanyId,
       T_SubCompany.ATTRIBUTE_NAME AS SubCompanyName,
	   T_SubCompany.REV2 AS SubCompanyAbbr,
       T_Brand.Id AS BrandId,
       T_Brand.ATTRIBUTE_NAME AS BrandName,
	   T_Brand.REV2 AS BrandAbbr
FROM dbo.Lafite_ATTRIBUTE (NOLOCK) T_ProductLine
    LEFT JOIN
    (
        SELECT *
        FROM dbo.Lafite_ATTRIBUTE (NOLOCK) T_LafiteAttribute
            INNER JOIN dbo.Cache_OrganizationUnits (NOLOCK) T_OrgUnit
                ON T_LafiteAttribute.Id = T_OrgUnit.RootID
                   AND T_LafiteAttribute.ATTRIBUTE_TYPE = 'SubCompany'
                   AND T_LafiteAttribute.DELETE_FLAG = '0'
    ) T_SubCompany
        ON T_SubCompany.AttributeID = T_ProductLine.Id
    LEFT JOIN
    (
        SELECT *
        FROM dbo.Lafite_ATTRIBUTE (NOLOCK) T_LafiteAttribute
            INNER JOIN dbo.Cache_OrganizationUnits (NOLOCK) T_OrgUnit
                ON T_LafiteAttribute.Id = T_OrgUnit.RootID
                   AND T_LafiteAttribute.ATTRIBUTE_TYPE = 'Brand'
                   AND T_LafiteAttribute.DELETE_FLAG = '0'
    ) T_Brand
        ON T_Brand.AttributeID = T_ProductLine.Id
WHERE (T_ProductLine.ATTRIBUTE_TYPE = 'Product_Line')
      AND (T_ProductLine.DELETE_FLAG = '0');

GO


