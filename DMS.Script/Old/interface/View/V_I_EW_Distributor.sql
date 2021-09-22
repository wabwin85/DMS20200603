DROP VIEW [interface].[V_I_EW_Distributor]
GO

CREATE VIEW [interface].[V_I_EW_Distributor]
AS
   SELECT A.ID,
          a.SapCode,
          a.Name_CN,
          a.Name_EN,
          ISNULL (b.DMA_SAP_CODE, a.SapCode) AS ParentCode,
          a.[Type],
          a.City,
          DMA_ActiveFlag,
          DCL_StopDate
     FROM (SELECT DMA_ID AS ID,
                  DMA_SAP_Code AS SapCode,
                  DMA_ChineseName AS Name_CN,
                  DMA_EnglishName AS Name_EN,
                  CASE DMA_DealerType
                     WHEN 'LP' THEN NULL
                     WHEN 'T1' THEN NULL
                     ELSE DMA_Parent_DMA_ID
                  END
                     AS ParentId,
                  DMA_DealerType AS [Type],
                  DMA_City AS City,
                  DMA_ActiveFlag,
                  DCL_StopDate
             FROM DealerMaster(nolock)
                  LEFT JOIN DealerContract(nolock) ON DCL_DMA_ID = DMA_ID
            WHERE DMA_HostCompanyFlag = 0 AND DMA_DeletedFlag = 0) AS a
          LEFT OUTER JOIN (SELECT DMA_ID, DMA_SAP_CODE
                             FROM DealerMaster(nolock)
                            WHERE DMA_DealerType = 'LP') b
             ON a.ParentId = b.DMA_ID
GO


