SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
ALTER PROC USP_SelectOrgsForPositionHospital @RootID UNIQUEIDENTIFIER
AS
IF @RootID IS NULL
BEGIN
    SELECT TOP 1
           @RootID = Id
    FROM Lafite_ATTRIBUTE
    WHERE ATTRIBUTE_TYPE = 'Root';
END;

SELECT GID AS GID,
       RootID AS RootID,
       ParentID AS ParentID,
       AttributeID AS AttributeID,
       AttributeType AS AttributeType,
       AttributeName AS AttributeName,
       AttributeLevel AS AttributeLevel,
       ROW_NUMBER() OVER (ORDER BY (SELECT 0)) AS ROW_NUMBER,
       CASE
           WHEN
           (
               SELECT COUNT(*)
               FROM Cache_OrganizationUnits org
               WHERE org.ParentID = Cache_OrganizationUnits.AttributeID
           ) > 1 THEN
               1
           ELSE
               0
       END AS HasChildren,
       A.ProductLineID,
       A.ATTRIBUTE_NAME AS ProductLineName,
       table2.TSR
FROM Cache_OrganizationUnits
    LEFT JOIN
    (
        SELECT RootID AS ProductLineID,
               vp.ATTRIBUTE_NAME,
               AttributeID AS PositionID
        FROM dbo.Cache_OrganizationUnits co
            INNER JOIN dbo.View_ProductLine vp
                ON vp.Id = co.RootID
        WHERE co.AttributeType = 'Position'
    ) A
        ON Cache_OrganizationUnits.AttributeID = A.PositionID
    LEFT JOIN
    (
        SELECT Id,
               REVERSE(STUFF(
                                REVERSE(
                                (
                                    SELECT Lafite_IDENTITY.IDENTITY_NAME + Lafite_IDENTITY.IDENTITY_CODE + ','
                                    FROM dbo.View_Lafite_IDENTITY_MAP_Position_Valid
                                        INNER JOIN dbo.Lafite_IDENTITY
                                            ON View_Lafite_IDENTITY_MAP_Position_Valid.IDENTITY_ID = dbo.Lafite_IDENTITY.Id
                                    WHERE View_Lafite_IDENTITY_MAP_Position_Valid.MAP_ID = Lafite_ATTRIBUTE.Id
                                          AND Lafite_IDENTITY.DELETE_FLAG = 0
                                          AND dbo.Lafite_IDENTITY.BOOLEAN_FLAG = 1
                                    FOR XML PATH('')
                                )
                                       ),
                                1,
                                1,
                                ''
                            )
                      ) AS TSR
        FROM dbo.Lafite_ATTRIBUTE
        WHERE Lafite_ATTRIBUTE.ATTRIBUTE_TYPE = 'Position'
    ) table2
        ON Cache_OrganizationUnits.AttributeID = table2.Id
WHERE RootID = @RootID;
GO

