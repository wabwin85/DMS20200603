SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO
CREATE VIEW [dbo].[View_PositionSalesRepHospital]
AS
SELECT DISTINCT
       HPM_HospitalID AS HospitalID,
       map.IDENTITY_ID AS IDENTITY_ID,
       HPM_ProductLineID AS ProductLineID,
       HPM_PositionID AS PositionID
FROM HospitalPositionMap
    INNER JOIN dbo.View_Lafite_IDENTITY_MAP_Position_Valid map
        ON map.MAP_ID = HPM_PositionID;

GO