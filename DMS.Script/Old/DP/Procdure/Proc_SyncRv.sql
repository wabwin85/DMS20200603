
DROP PROCEDURE [DP].[Proc_SyncRv]
GO


CREATE PROCEDURE [DP].[Proc_SyncRv]
AS
BEGIN
	EXEC DP.Proc_SyncRvDealerLevel;
	EXEC DP.Proc_SyncRvDealerRef;
	EXEC DP.Proc_SyncRvDealerBi;
	EXEC DP.Proc_SyncRvDealerQuota;
	EXEC DP.Proc_SyncRvDealerScoreCard;
	EXEC DP.Proc_SyncRvDealerKpi;
END
GO


