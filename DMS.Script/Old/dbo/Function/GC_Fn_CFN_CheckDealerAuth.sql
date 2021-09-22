DROP FUNCTION [dbo].[GC_Fn_CFN_CheckDealerAuth]
GO


CREATE FUNCTION [dbo].[GC_Fn_CFN_CheckDealerAuth]
(
	@DealerId UNIQUEIDENTIFIER,
	@CfnId UNIQUEIDENTIFIER
)
RETURNS TINYINT
AS

BEGIN
	DECLARE @RtnVal TINYINT
	
	DECLARE @OrderAuthCount INT
	DECLARE @BumId UNIQUEIDENTIFIER

	SELECT @BumId = CFN_ProductLine_BUM_ID FROM CFN WHERE CFN_ID = @CfnId
	SELECT @OrderAuthCount = COUNT(1) FROM DealerAuthorizationTable WHERE DAT_DMA_ID = @DealerId AND DAT_ProductLine_BUM_ID = @BumId AND DAT_Type = 'Order'

	--判断是否为共享产品，共享产品默认为授权
	IF EXISTS (SELECT * FROM CFN t1, PartsClassification t2,DealerAuthorizationTable t3,dbo.CfnClassification t4
				WHERE t1.CFN_ID = @CfnId AND t1.CFN_CustomerFaceNbr=t4.CfnCustomerFaceNbr and t4.ClassificationId=t2.PCT_ID
				and t3.DAT_DMA_ID=@DealerId and t3.DAT_PMA_ID=t2.PCT_ID	
				and (CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
				AND (t2.PCT_Name LIKE '%Share%' OR t2.PCT_Description LIKE '%SHARE%' OR t2.PCT_Description LIKE '%share%') )
		SET @RtnVal = 1
	ELSE
		BEGIN
			--判断是否为经销商授权产品
			IF EXISTS 
				(SELECT 1 FROM
				(
				SELECT CFN.CFN_ID FROM CFN
				INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
				WHERE EXISTS (SELECT 1 FROM DealerAuthorizationTable AS DA
				INNER JOIN Cache_PartsClassificationRec AS CP
				ON CP.PCT_ProductLine_BUM_ID = DA.DAT_ProductLine_BUM_ID
				WHERE DA.DAT_DMA_ID = @DealerId
				AND CFN.CFN_DeletedFlag = 0
				AND DA.DAT_PMA_ID = DA.DAT_ProductLine_BUM_ID
				AND CP.PCT_ProductLine_BUM_ID = DA.DAT_PMA_ID
				AND CP.PCT_ID = CCF.ClassificationId
				AND ((DA.DAT_Type = 'Order' AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
				OR (@OrderAuthCount = 0 AND (DA.DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
				)
				)
				)
				UNION
				SELECT CFN.CFN_ID FROM CFN
				INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
				WHERE EXISTS 
				(SELECT 1 FROM DealerAuthorizationTable AS DA
				INNER JOIN DealerContract AS DC
				ON DA.DAT_DCL_ID = DC.DCL_ID
				INNER JOIN Cache_PartsClassificationRec AS CP
				ON CP.PCT_ProductLine_BUM_ID = DA.DAT_ProductLine_BUM_ID
				WHERE DC.DCL_DMA_ID = @DealerId
				AND CFN.CFN_DeletedFlag = 0
				AND DA.DAT_PMA_ID != DA.DAT_ProductLine_BUM_ID
				AND CP.PCT_ParentClassification_PCT_ID = DA.DAT_PMA_ID
				AND CP.PCT_ID = CCF.ClassificationId
				AND ((DA.DAT_Type = 'Order' AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
				OR (@OrderAuthCount = 0 AND (DA.DAT_Type IN ('Normal','Temp') AND CONVERT(DATETIME,CONVERT(NVARCHAR(10),GETDATE(),120)) BETWEEN ISNULL(DAT_StartDate,'1900-01-01') AND ISNULL(DAT_EndDate,DATEADD(DAY,-1,GETDATE())))
				)
				)
				)
				
				
				) AS C WHERE C.CFN_ID = @CfnId
				)
				SET @RtnVal = 1
			ELSE
				
				SET @RtnVal = 0
		END
	RETURN @RtnVal
END
GO


