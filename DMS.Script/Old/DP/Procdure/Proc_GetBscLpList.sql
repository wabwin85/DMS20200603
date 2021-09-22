
DROP PROCEDURE [DP].[Proc_GetBscLpList]
GO


CREATE PROCEDURE [DP].[Proc_GetBscLpList]
(@UserAccount NVARCHAR(100))
AS
BEGIN
	SELECT DMA_ID LpCode,
	       DMA_ChineseName LpName
	FROM   dbo.DealerMaster
	WHERE  DMA_DealerType = 'LP'
	       AND DMA_ActiveFlag = 1
	ORDER BY DMA_ChineseName
END
GO


