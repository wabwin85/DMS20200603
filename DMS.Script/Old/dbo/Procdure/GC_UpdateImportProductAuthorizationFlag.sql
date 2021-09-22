DROP  PROCEDURE [dbo].[GC_UpdateImportProductAuthorizationFlag] 
GO

-- =============================================
-- Author:		Steven
-- Create date: 2009/08/25
-- Description:	更新导入数据已获得授权标志
-- =============================================
CREATE PROCEDURE [dbo].[GC_UpdateImportProductAuthorizationFlag] 
AS
BEGIN

WITH LeafToNode(PCT_IDLeaf, PCT_ID, PCT_ParentClassification_PCT_ID, PartLevel) 
AS (
		SELECT PCT_ID LeafID, PCT_ID, PCT_ParentClassification_PCT_ID, 0 as PartLevel
		FROM PartsClassification
		LEFT JOIN
		(
		SELECT     PCT_ParentClassification_PCT_ID parentID
		FROM         PartsClassification
		WHERE     (PCT_ParentClassification_PCT_ID IS NOT NULL)
		) Parent ON PCT_ID = Parent.parentID
		WHERE Parent.parentID is null
		UNION ALL
		SELECT     LeafToNode.PCT_IDLeaf, p.PCT_ID, 
							   p.PCT_ParentClassification_PCT_ID,
							   LeafToNode.PartLevel - 1 AS PartLevel
		FROM         PartsClassification
							   AS p INNER JOIN
							  LeafToNode ON 
							  LeafToNode.PCT_ParentClassification_PCT_ID
							   = p.PCT_ID
)
UPDATE DeliveryNote
SET DeliveryNote.DNL_Authorized = 1
--SELECT     AuthLeaf.DealerID, AuthLeaf.LeafID, DeliveryNote.DNL_CFN_ID
FROM         (
					SELECT     Auth.DealerID, PCT_IDLeaf AS LeafID
                       FROM          LeafToNode INNER JOIN
                       (SELECT DISTINCT DAT_PMA_ID AS ProductNodeID, DAT_DMA_ID AS DealerID
							FROM          DealerAuthorizationTable
							WHERE      (DAT_ProductLine_BUM_ID <> DAT_PMA_ID)
						) AS Auth ON LeafToNode.PCT_ID = Auth.ProductNodeID
                       --WHERE      (PartLevel <> 0)
                    UNION
                    SELECT     Auth_1.DealerID, LeafList.LeafID
                       FROM         (
						SELECT DISTINCT DAT_PMA_ID AS ProductLineID, DAT_DMA_ID AS DealerID
                        FROM          DealerAuthorizationTable AS DealerAuthorizationTable_1 WITH (NOLOCK)
                        WHERE      (DAT_ProductLine_BUM_ID = DAT_PMA_ID)) AS Auth_1 INNER JOIN
                       (SELECT DISTINCT PartsClassification.PCT_ID AS LeafID, PartsClassification.PCT_ProductLine_BUM_ID AS ProductLineID
                        FROM          PartsClassification WITH (NOLOCK) LEFT OUTER JOIN
                        (SELECT     PCT_ParentClassification_PCT_ID AS parentID
                                FROM          PartsClassification AS PartsClassification_1 WITH (NOLOCK)
                                WHERE      (PCT_ParentClassification_PCT_ID IS NOT NULL)) AS Parent ON 
                                PartsClassification.PCT_ID = Parent.parentID
                                WHERE      (Parent.parentID IS NULL)
						) AS LeafList ON Auth_1.ProductLineID = LeafList.ProductLineID
			) AS AuthLeaf INNER JOIN
                      DeliveryNote ON AuthLeaf.DealerID = DeliveryNote.DNL_DealerID_DMA_ID 
                      INNER JOIN CFN ON DeliveryNote.DNL_CFN_ID = CFN.CFN_ID 
                      INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr AND AuthLeaf.LeafID = CCF.ClassificationId
END

GO


