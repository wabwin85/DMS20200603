DROP PROCEDURE [DP].[Proc_GetDealerFeedbackInfo]
GO


CREATE PROCEDURE [DP].[Proc_GetDealerFeedbackInfo]
(
    @Bu       NVARCHAR(100),
    @SubBu    NVARCHAR(100),
    @Year     NVARCHAR(100),
    @Quarter  NVARCHAR(100),
    @SapCode  NVARCHAR(100)
)
AS
BEGIN
	SELECT B.Division,
	       B.SubBUName,
	       CONVERT(NVARCHAR(4), B.[Year]) + '-Q' + CONVERT(NVARCHAR(1), B.[Quarter]) YearQuarter,
	       B.WarningLevel,
	       A.FeedbackUser,
	       A.FeedbackContent,
	       CONVERT(NVARCHAR(19), A.FeedbackTime, 121) FeedbackTime
	FROM   interface.RV_DealerKPI_Score_Summary B
	       LEFT JOIN DP.DealerFeedback A
	            ON  A.Bu = B.DivisionID
	            AND A.SubBu = B.SubBUCode
	            AND A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.SapCode = B.SAPID
	WHERE  B.DivisionID = @Bu
	       AND B.SubBUCode = @SubBu
	       AND B.[Year] = @Year
	       AND B.[Quarter] = @Quarter
	       AND B.SAPID = @SapCode
	
	SELECT A.TotalScoreCurrentLevel TotalScoreLevel,
	       A.TotalScoreCurrent TotalScore1,
	       A.TotalScoreBack1 TotalScore2,
	       A.PurchaseCurrentLevel PurchaseLevel,
	       A.PurchaseCurrent Purchase1,
	       A.PurchaseBack1 Purchase2,
	       A.CoverCurrentLevel CoverLevel,
	       A.CoverCurrent Cover1,
	       A.CoverBack1 Cover2,
	       (
	           SELECT COUNT(*)
	           FROM   interface.RV_HospitalKPI_WarningLevel T
	           WHERE  A.[Year] = T.[Year]
	                  AND A.[Quarter] = T.[Quarter]
	                  AND A.DivisionID = T.DivisionID
	                  AND A.SubBUCode = T.SubBUCode
	                  AND A.SAPID = T.SAPID
	                  AND T.CoverFlag = 0
	       ) CoverCount,
	       (
	           SELECT COUNT(*)
	           FROM   interface.RV_HospitalKPI_WarningLevel T
	           WHERE  A.[Year] = T.[Year]
	                  AND A.[Quarter] = T.[Quarter]
	                  AND A.DivisionID = T.DivisionID
	                  AND A.SubBUCode = T.SubBUCode
	                  AND A.SAPID = T.SAPID
	                  AND T.CoverFlag = 0
	                  AND T.HCoverWarningLevel = 11
	       ) CoverRed,
	       (
	           SELECT COUNT(*)
	           FROM   interface.RV_HospitalKPI_WarningLevel T
	           WHERE  A.[Year] = T.[Year]
	                  AND A.[Quarter] = T.[Quarter]
	                  AND A.DivisionID = T.DivisionID
	                  AND A.SubBUCode = T.SubBUCode
	                  AND A.SAPID = T.SAPID
	                  AND T.CoverFlag = 0
	                  AND T.HCoverWarningLevel = 12
	       ) CoverYellow,
	       A.ReachCurrentLevel AchieveLevel,
	       A.ReachCurrent Achieve1,
	       A.ReachBack1 Achieve2,
	       (
	           SELECT COUNT(*)
	           FROM   interface.RV_HospitalKPI_WarningLevel T
	           WHERE  A.[Year] = T.[Year]
	                  AND A.[Quarter] = T.[Quarter]
	                  AND A.DivisionID = T.DivisionID
	                  AND A.SubBUCode = T.SubBUCode
	                  AND A.SAPID = T.SAPID
	                  AND T.AchieveFlag = 0
	       ) AchieveCount,
	       (
	           SELECT COUNT(*)
	           FROM   interface.RV_HospitalKPI_WarningLevel T
	           WHERE  A.[Year] = T.[Year]
	                  AND A.[Quarter] = T.[Quarter]
	                  AND A.DivisionID = T.DivisionID
	                  AND A.SubBUCode = T.SubBUCode
	                  AND A.SAPID = T.SAPID
	                  AND T.AchieveFlag = 0
	                  AND T.HAchieveWarningLevel = 11
	       ) AchieveRed,
	       (
	           SELECT COUNT(*)
	           FROM   interface.RV_HospitalKPI_WarningLevel T
	           WHERE  A.[Year] = T.[Year]
	                  AND A.[Quarter] = T.[Quarter]
	                  AND A.DivisionID = T.DivisionID
	                  AND A.SubBUCode = T.SubBUCode
	                  AND A.SAPID = T.SAPID
	                  AND T.AchieveFlag = 0
	                  AND T.HAchieveWarningLevel = 12
	       ) AchieveYellow,
	       (
	           SELECT COUNT(*)
	           FROM   interface.RV_HospitalKPI_WarningLevel T
	           WHERE  A.[Year] = T.[Year]
	                  AND A.[Quarter] = T.[Quarter]
	                  AND A.DivisionID = T.DivisionID
	                  AND A.SubBUCode = T.SubBUCode
	                  AND A.SAPID = T.SAPID
	       ) DealerCount
	FROM   interface.RV_DealerKPI_Score_Warning A
	WHERE  A.[Year] = @Year
	       AND A.[Quarter] = @Quarter
	       AND A.DivisionID = @Bu
	       AND A.SubBUCode = @SubBu
	       AND A.SAPID = @SapCode
	
	SELECT A.DMSCode,
	       A.HospitalName,
	       A.HCoverWarningLevel WarningLevel,
	       A.UncoverMonth
	FROM   interface.RV_HospitalKPI_WarningLevel A
	WHERE  A.CoverFlag = 0
	       AND A.[Year] = @Year
	       AND A.[Quarter] = @Quarter
	       AND A.DivisionID = @Bu
	       AND A.SubBUCode = @SubBu
	       AND A.SAPID = @SapCode
	
	SELECT A.DMSCode,
	       A.HospitalName,
	       A.HAchieveWarningLevel WarningLevel,
	       A.SalesRateCurrent,
	       A.SalesRateBack1
	FROM   interface.RV_HospitalKPI_WarningLevel A
	WHERE  A.AchieveFlag = 0
	       AND A.[Year] = @Year
	       AND A.[Quarter] = @Quarter
	       AND A.DivisionID = @Bu
	       AND A.SubBUCode = @SubBu
	       AND A.SubBUCode = @SubBu
	       AND A.KeyHospitalFlag = 1
	
	SELECT A.DMSCode,
	       A.HospitalName,
	       A.HAchieveWarningLevel WarningLevel,
	       A.SalesRateCurrent,
	       A.SalesRateBack1
	FROM   interface.RV_HospitalKPI_WarningLevel A
	WHERE  A.AchieveFlag = 0
	       AND A.[Year] = @Year
	       AND A.[Quarter] = @Quarter
	       AND A.DivisionID = @Bu
	       AND A.SubBUCode = @SubBu
	       AND A.SubBUCode = @SubBu
	       AND A.KeyHospitalFlag = 0
END
GO


