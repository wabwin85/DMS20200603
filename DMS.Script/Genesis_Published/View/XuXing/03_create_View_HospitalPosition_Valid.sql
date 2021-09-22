SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[View_HospitalPosition_Valid]
AS
SELECT HPM_ID AS ID,
       HPM_PositionID AS PositionID,
       Position.ATTRIBUTE_NAME AS PositionName,
       HPM_HospitalID AS HospitalID,
       HPM_ProductLineID AS ProductLineID,
       ProductLine.ATTRIBUTE_NAME AS ProductLineName,
       HPM_CreateDate AS CreateDate,
       Hospital.HOS_Key_Account,
       Hospital.HOS_HospitalName,
       Hospital.HOS_HospitalShortName,
       --Hospital.Hos_UsedName AS HospitalUsedName,
       Hospital.HOS_Province,
       Hospital.HOS_City,
	   Hospital.HOS_District,
       Hospital.HOS_HospitalName + CASE ISNULL(Hospital.HOS_HospitalShortName, '')
                                       WHEN Hospital.HOS_HospitalName THEN
                                           ''
                                       WHEN '' THEN
                                           ''
                                       ELSE
                                           '|' + Hospital.HOS_HospitalShortName
                                   END AS HospitalFullName,
       CONVERT(BIT, 1) AS IsValidHospital,
       CONVERT(   BIT,
                  CASE
                      WHEN ProductLine_Valid.Id IS NULL THEN
                          0
                      ELSE
                          1
                  END
              ) AS IsValidProductLine,
       CONVERT(   BIT,
                  CASE
                      WHEN Position_Valid.Id IS NULL THEN
                          0
                      ELSE
                          1
                  END
              ) AS IsValidPosition,
       ROW_NUMBER() OVER (PARTITION BY HospitalPositionMap.HPM_PositionID ORDER BY HOS_HospitalName) AS ROW_NUMBER
FROM HospitalPositionMap
    LEFT JOIN Hospital
        ON Hospital.HOS_ID = HPM_HospitalID
    LEFT JOIN Lafite_ATTRIBUTE ProductLine
        ON ProductLine.Id = HPM_ProductLineID
           AND ProductLine.ATTRIBUTE_TYPE = 'Product_Line'
    LEFT JOIN Lafite_ATTRIBUTE ProductLine_Valid
        ON ProductLine_Valid.Id = HPM_ProductLineID
           AND ProductLine_Valid.ATTRIBUTE_TYPE = 'Product_Line'
           AND ProductLine_Valid.BOOLEAN_FLAG = 1
           AND ProductLine_Valid.DELETE_FLAG = 0
    LEFT JOIN Lafite_ATTRIBUTE Position
        ON Position.Id = HPM_PositionID
           AND Position.ATTRIBUTE_TYPE = 'Position'
    LEFT JOIN Lafite_ATTRIBUTE Position_Valid
        ON Position_Valid.Id = HPM_PositionID
           AND Position_Valid.ATTRIBUTE_TYPE = 'Position'
           AND Position_Valid.BOOLEAN_FLAG = 1
           AND Position_Valid.DELETE_FLAG = 0
           AND EXISTS
               (
                   SELECT NULL
                   FROM Cache_OrganizationUnits
                   WHERE Cache_OrganizationUnits.AttributeType = 'Position'
                         AND Cache_OrganizationUnits.RootID = ProductLine.Id
                         AND Cache_OrganizationUnits.AttributeID = Position_Valid.Id
               );



GO



