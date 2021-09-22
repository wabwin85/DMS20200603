DROP PROCEDURE [DP].[Proc_GetBscFeedbackDealerList]
GO


CREATE PROCEDURE [DP].[Proc_GetBscFeedbackDealerList]
(
    @UserAccount           NVARCHAR(100),
    @Bu                    NVARCHAR(100),
    @SubBu                 NVARCHAR(100),
    @Area                  NVARCHAR(100),
    @YearQuarter           NVARCHAR(100),
    @Lp                    NVARCHAR(100),
    @BscFeedbackStatus     NVARCHAR(100),
    @DealerFeedbackStatus  NVARCHAR(100),
    @KeyWord               NVARCHAR(100),
    @DealerLevel           NVARCHAR(100)
)
AS
BEGIN
	SET @Bu = LTRIM(RTRIM(ISNULL(@Bu, '')));
	SET @SubBu = LTRIM(RTRIM(ISNULL(@SubBu, '')));
	SET @Area = LTRIM(RTRIM(ISNULL(@Area, '')));
	SET @YearQuarter = LTRIM(RTRIM(ISNULL(@YearQuarter, '')));
	SET @Lp = LTRIM(RTRIM(ISNULL(@Lp, '')));
	SET @BscFeedbackStatus = LTRIM(RTRIM(ISNULL(@BscFeedbackStatus, '')));
	SET @DealerFeedbackStatus = LTRIM(RTRIM(ISNULL(@DealerFeedbackStatus, '')));
	SET @KeyWord = LTRIM(RTRIM(ISNULL(@KeyWord, '')));
	
	CREATE TABLE #Result
	(
		SapCode               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		DealerId              UNIQUEIDENTIFIER,
		DealerName            NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		BuCode                NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		BuName                NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SubBuCode             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SubBuName             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		[Year]                NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		[Quarter]             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter3          NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter2          NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter1          NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SummaryLevel          NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalScore            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalLevel            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ1               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ2               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ3               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ4               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseScore         NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseLevel         NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ1            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ2            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ3            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ4            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverScore            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverLevel            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ1               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ2               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ3               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ4               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveScore          NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveLevel          NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ1             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ2             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ3             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ4             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		DealerQuota           MONEY,
		BscFeedbackStatus     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		DealerFeedbackStatus  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PRIMARY KEY(SapCode, BuCode, SubBuCode, [Year], [Quarter])
	)
	
	INSERT INTO #Result
	  (
	    SapCode,
	    DealerId,
	    DealerName,
	    BuCode,
	    BuName,
	    SubBuCode,
	    SubBuName,
	    [Year],
	    [Quarter],
	    YearQuarter,
	    YearQuarter3,
	    YearQuarter2,
	    YearQuarter1,
	    SummaryLevel,
	    TotalScore,
	    TotalLevel,
	    TotalQ1,
	    TotalQ2,
	    TotalQ3,
	    TotalQ4,
	    PurchaseScore,
	    PurchaseLevel,
	    PurchaseQ1,
	    PurchaseQ2,
	    PurchaseQ3,
	    PurchaseQ4,
	    CoverScore,
	    CoverLevel,
	    CoverQ1,
	    CoverQ2,
	    CoverQ3,
	    CoverQ4,
	    AchieveScore,
	    AchieveLevel,
	    AchieveQ1,
	    AchieveQ2,
	    AchieveQ3,
	    AchieveQ4,
	    DealerQuota,
	    BscFeedbackStatus,
	    DealerFeedbackStatus
	  )
	SELECT DISTINCT Summary.SAPID,
	       Dealer.DMA_ID,
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
	       Summary.DealerQuota,
	       dbo.Func_GetCode('CONST_DP_BscFeedbackStatus', Feedback.BscFeedStatus),
	       dbo.Func_GetCode(
	           'CONST_DP_DealerFeedbackStatus',
	           CASE 
	                WHEN DealerFeedback.FeedbackId IS NULL THEN '00'
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
	       INNER JOIN DP.BscFeedback Feedback
	            ON  Summary.DivisionID = Feedback.Bu
	                AND Summary.SubBUCode = Feedback.SubBu
	                AND Summary.[Year] = Feedback.[Year]
	                AND Summary.[Quarter] = Feedback.[Quarter]
	                AND Summary.SAPID = Feedback.SapCode
	       INNER JOIN DP.UserDealerMapping Mapping
	            ON  Summary.DivisionID = Mapping.Division
	                AND Summary.SubBUCode = Mapping.SubBu
	                AND Summary.SAPID = Mapping.SapCode
	       LEFT JOIN DP.DealerFeedback DealerFeedback
	            ON  Summary.DivisionID = DealerFeedback.Bu
	                AND Summary.SubBUCode = DealerFeedback.SubBu
	                AND Summary.[Year] = DealerFeedback.[Year]
	                AND Summary.[Quarter] = DealerFeedback.[Quarter]
	                AND Summary.SAPID = DealerFeedback.SapCode
	WHERE  Mapping.UserAccount = @UserAccount
	       AND (@Bu = '' OR Summary.DivisionID = @Bu)
	       AND (@SubBu = '' OR Summary.SubBUCode = @SubBu)
	       AND (@Area = '' OR ISNULL(Summary.AreaCode, 'NULL') = @Area)
	       AND (
	               @Lp = ''
	               OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	           )
	       AND (
	               @YearQuarter = ''
	               OR (
	                      Summary.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	                      AND Summary.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	                  )
	           )
	       AND (
	               @BscFeedbackStatus = ''
	               OR ISNULL(Feedback.BscFeedStatus, '00') = @BscFeedbackStatus
	           )
	       AND (
	               @DealerFeedbackStatus = ''
	               OR CASE 
	                       WHEN DealerFeedback.FeedbackId IS NULL THEN '00'
	                       ELSE '10'
	                  END = @DealerFeedbackStatus
	           )
	       AND (
	               @KeyWord = ''
	               OR Dealer.DMA_ChineseShortName LIKE '%' + @KeyWord + '%'
	           )
	       AND (
	               @DealerLevel = ''
	               OR Warning.Dealerlevel = @DealerLevel
	           )
	
	SELECT *
	FROM   #Result
	ORDER BY
	       DealerName,
	       BuName,
	       SubBuName,
	       YearQuarter DESC
END
GO


