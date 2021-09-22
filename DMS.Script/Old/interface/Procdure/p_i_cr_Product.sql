DROP PROCEDURE [interface].[p_i_cr_Product]
GO

CREATE PROCEDURE [interface].[p_i_cr_Product]
WITH EXEC AS CALLER
AS
Delete from interface.T_I_CR_Product 

INSERT INTO interface.T_I_CR_Product
   SELECT ROW_NUMBER () OVER (ORDER BY t1.CFN_CustomerFaceNbr),
          t1.CFN_CustomerFaceNbr,
          t1.CFN_ChineseName,
          t1.CFN_Property5,
          t2.PMA_ConvertFactor,
          t1.CFN_Description,
          (SELECT REV1
             FROM Lafite_ATTRIBUTE
            WHERE     id IN
                         (SELECT parentid
                            FROM Cache_OrganizationUnits
                           WHERE AttributeID IN
                                    (SELECT parentid
                                       FROM Cache_OrganizationUnits
                                      WHERE AttributeID =
                                               t1.CFN_ProductLine_BUM_ID))
                  AND ATTRIBUTE_TYPE = 'BU'),
          CASE WHEN CFN_Property6 = '1' THEN 'CRM' ELSE 'BSC' END AS level0,
          CASE WHEN CFN_Property6 = '1' THEN 'CRM' ELSE 'BSC' END
             AS level0Code,
          t1.CFN_Level1Code,
          t1.CFN_Level1Desc,
          t1.CFN_Level2Code,
          t1.CFN_Level2Desc,
          t1.CFN_Level3Code,
          t1.CFN_Level3Desc,
          t1.CFN_Level4Code,
          t1.CFN_Level4Desc,
          t1.CFN_Level5Code,
          t1.CFN_Level5Desc,
          NULL AS Tag,
          NULL AS Plant,
          NULL AS sourceType,
          1 AS st,
          '0',
          '0',
          CFN_Property3,
          CFN_Property1
     FROM cfn t1, product t2
    WHERE t1.CFN_ID = t2.PMA_CFN_ID
GO


