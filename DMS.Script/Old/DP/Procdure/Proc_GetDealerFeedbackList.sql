DROP  PROCEDURE [DP].[Proc_GetDealerFeedbackList]
GO


CREATE PROCEDURE [DP].[Proc_GetDealerFeedbackList]
(
    @UserAccount  NVARCHAR(100),
    @Bu           NVARCHAR(100),
    @SubBu        NVARCHAR(100),
    @Area         NVARCHAR(100),
    @YearQuarter  NVARCHAR(100),
    @Lp           NVARCHAR(100),
    @AlertStatus  NVARCHAR(100),
    @KeyWord      NVARCHAR(100)
)
AS
BEGIN
	CREATE TABLE #Result
	(
		SapCode        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		DealerName     NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		BuCode         NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		BuName         NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SubBuCode      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SubBuName      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		[Year]         NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		[Quarter]      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter    NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter3   NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter2   NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter1   NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SummaryLevel   NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalScore     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalLevel     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ1        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ2        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ3        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ4        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseScore  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseLevel  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ1     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ2     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ3     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ4     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverScore     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverLevel     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ1        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ2        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ3        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ4        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveScore   NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveLevel   NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ1      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ2      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ3      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ4      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AlertStatus    NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PRIMARY KEY(SapCode, BuCode, SubBuCode, [Year], [Quarter])
	)
	
	INSERT INTO #Result
	  (SapCode, DealerName, BuCode, BuName, SubBuCode, SubBuName, [Year], [Quarter], YearQuarter, YearQuarter3, YearQuarter2, YearQuarter1, SummaryLevel, TotalScore, TotalLevel, TotalQ1, TotalQ2, TotalQ3, TotalQ4, PurchaseScore, PurchaseLevel, PurchaseQ1, PurchaseQ2, PurchaseQ3, PurchaseQ4, CoverScore, CoverLevel, CoverQ1, CoverQ2, CoverQ3, CoverQ4, AchieveScore, AchieveLevel, AchieveQ1, AchieveQ2, AchieveQ3, AchieveQ4, AlertStatus)
	SELECT Summary.SAPID,
	       Dealer.DMA_ChineseShortName,
	       Summary.DivisionID,
	       Summary.Division,
	       Summary.SubBUCode,
	       Summary.SubBUName,
	       Summary.[Year],
	       Summary.[Quarter],
	       CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]),
	       DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1),
	       DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2),
	       DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3),
	       ISNULL(Summary.WarningLevel, ''),
	       ISNULL(Warning.TotalScoreCurrent, ''),
	       ISNULL(Warning.TotalScoreCurrentLevel, ''),
	       ISNULL(Warning.TotalScoreBack3, ''),
	       ISNULL(Warning.TotalScoreBack2, ''),
	       ISNULL(Warning.TotalScoreBack1, ''),
	       ISNULL(Warning.TotalScoreCurrent, ''),
	       ISNULL(Warning.PurchaseCurrent, ''),
	       ISNULL(Warning.PurchaseCurrentLevel, ''),
	       ISNULL(Warning.PurchaseBack3, ''),
	       ISNULL(Warning.PurchaseBack2, ''),
	       ISNULL(Warning.PurchaseBack1, ''),
	       ISNULL(Warning.PurchaseCurrent, ''),
	       ISNULL(Warning.CoverCurrent, ''),
	       ISNULL(Warning.CoverCurrentLevel, ''),
	       ISNULL(Warning.CoverBack3, ''),
	       ISNULL(Warning.CoverBack2, ''),
	       ISNULL(Warning.CoverBack1, ''),
	       ISNULL(Warning.CoverCurrent, ''),
	       ISNULL(Warning.ReachCurrent, ''),
	       ISNULL(Warning.ReachCurrentLevel, ''),
	       ISNULL(Warning.ReachBack3, ''),
	       ISNULL(Warning.ReachBack2, ''),
	       ISNULL(Warning.ReachBack1, ''),
	       ISNULL(Warning.ReachCurrent, ''),
	       dbo.Func_GetCode(
	           'CONST_DP_DealerFeedbackStatus',
	           CASE 
	                WHEN Feedback.FeedbackId IS NULL THEN '00'
	                ELSE '10'
	           END
	       )
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	       INNER JOIN dbo.DealerMaster Dealer
	            ON  Summary.SAPID = Dealer.DMA_SAP_Code
	       LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	            ON  Summary.[Year] = Warning.[Year]
	            AND Summary.[Quarter] = Warning.[Quarter]
	            AND Summary.DivisionID = Warning.DivisionID
	            AND Summary.SubBUCode = Warning.SubBUCode
	            AND Summary.SAPID = Warning.SAPID
	       INNER JOIN DP.DealerFeedback Feedback
	            ON  Summary.DivisionID = Feedback.Bu
	            AND Summary.SubBUCode = Feedback.SubBu
	            AND Summary.[Year] = Feedback.[Year]
	            AND Summary.[Quarter] = Feedback.[Quarter]
	            AND Summary.SAPID = Feedback.SapCode
	       INNER JOIN DP.UserDealerMapping Mapping
	            ON  Summary.DivisionID = Mapping.Division
	            AND Summary.SubBUCode = Mapping.SubBu
	            AND Summary.SAPID = Mapping.SapCode
	WHERE  Mapping.UserAccount = @UserAccount
	       AND (ISNULL(@Bu, '') = '' OR Summary.DivisionID = @Bu)
	       AND (ISNULL(@SubBu, '') = '' OR Summary.SubBUCode = @SubBu)
	       AND (ISNULL(@Area, '') = '' OR Summary.AreaCode = @Area)
	       AND (
	               ISNULL(@Lp, '') = ''
	               OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	           )
	       AND (
	               ISNULL(@YearQuarter, '') = ''
	               OR (
	                      Summary.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	                      AND Summary.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	                  )
	           )
	       AND (
	               ISNULL(@AlertStatus, '') = ''
	               OR CASE 
	                       WHEN Feedback.FeedbackId IS NULL THEN '00'
	                       ELSE '10'
	                  END = @AlertStatus
	           )
	       AND (
	               ISNULL(@KeyWord, '') = ''
	               OR Dealer.DMA_ChineseShortName LIKE '%' + @KeyWord + '%'
	           )
	
	SELECT *
	FROM   #Result
	ORDER BY DealerName, BuName, SubBuName, YearQuarter DESC
END
GO


