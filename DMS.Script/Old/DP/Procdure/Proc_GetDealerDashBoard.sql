DROP PROCEDURE [DP].[Proc_GetDealerDashBoard]
GO

CREATE PROCEDURE [DP].[Proc_GetDealerDashBoard]
(
    @UserAccount  NVARCHAR(100),
    @DealerId     UNIQUEIDENTIFIER,
    @YearQuarter  NVARCHAR(100),
    @Bu           NVARCHAR(100),
    @SubBu        NVARCHAR(100)
)
AS
BEGIN
	CREATE TABLE #Dealer
	(
		[Year]            INT,
		[Quarter]         INT,
		DivisionID        INT,
		Division          VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUCode         VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUName         VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		DealerId          UNIQUEIDENTIFIER,
		SAPID             VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		BICode            VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		DealerName        NVARCHAR(255) COLLATE Chinese_PRC_CI_AS,
		DealerType        VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		TotalScore        INT,
		WarningLevel      INT,
		DealerQuota       MONEY,
		ScoreRank         INT,
		ScoreRankPercent  INT,
		PRIMARY KEY([Year], [Quarter], DivisionID, SubBUCode, SAPID)
	)
	
	CREATE TABLE #DealerBu
	(
		[Year]      INT,
		[Quarter]   INT,
		DivisionID  INT,
		SubBUCode   VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SAPID       VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		BICode      VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		PRIMARY KEY([Year], [Quarter], DivisionID, SubBUCode, SAPID)
	)
	
	CREATE TABLE #Hospital
	(
		[YEAR]                INT,
		[Quarter]             INT,
		DivisionID            INT,
		Division              VARCHAR(50) COLLATE Chinese_PRC_CI_AS,
		SubBUCode             VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUName             NVARCHAR(50) COLLATE Chinese_PRC_CI_AS,
		SAPID                 VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		BICode                VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		DealerName            NVARCHAR(255) COLLATE Chinese_PRC_CI_AS,
		DMSCode               VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		HospitalName          NVARCHAR(200) COLLATE Chinese_PRC_CI_AS,
		SalesOrgLineID        INT,
		AuthStartDate         date,
		KeyHospitalFlag       BIT,
		CoverFlag             BIT,
		HCoverWarningLevel    INT,
		AchieveFlag           BIT,
		HAchieveWarningLevel  INT,
		WarningLevel          INT,
		HospitalQuota         MONEY,
		MarketType            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AuthMonth             INT,
		UncoverMonth          INT,
		SalesRateCurrent      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SalesRateBack1        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SalesRateBack2        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SalesRateBack3        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PRIMARY KEY([Year], [Quarter], DivisionID, SubBUCode, SAPID, DMSCode)
	)
	
	CREATE TABLE #ResultMain
	(
		ResultKey    NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ResultValue  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS
	)
	
	CREATE TABLE #DealerRank
	(
		SapCode     NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		TotalScore  NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		DealerRank  INT
	)
	
	DECLARE @SapCode NVARCHAR(100);
	SELECT @SapCode = DMA_SAP_Code
	FROM   dbo.DealerMaster
	WHERE  DMA_ID = @DealerId
	
	INSERT INTO #Dealer
	  ([Year], [Quarter], DivisionID, Division, SubBUCode, SubBUName, DealerId, SAPID, BICode, DealerName, DealerType, 
	   TotalScore, WarningLevel, DealerQuota, ScoreRank, ScoreRankPercent)
	SELECT DISTINCT Summary.[Year],
	       Summary.[Quarter],
	       Summary.DivisionID,
	       Summary.Division,
	       Summary.SubBUCode,
	       Summary.SubBUName,
	       Dealer.DMA_ID,
	       Summary.SAPID,
	       Summary.BICode,
	       Dealer.DMA_ChineseShortName,
	       Summary.DealerType,
	       Summary.TotalScore,
	       Summary.WarningLevel,
	       Summary.DealerQuota,
	       Warning.ScoreRank,
	       Warning.ScoreRankPercent
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	       INNER JOIN interface.RV_DealerKPI_Score_Warning Warning
	            ON  Summary.[Year] = Warning.[Year]
	            AND Summary.Quarter = Warning.Quarter
	            AND Summary.DivisionID = Warning.DivisionID
	            AND Summary.SubBUCode = Warning.SubBUCode
	            AND Summary.SAPID = Warning.SAPID
	            AND Summary.BICode = Warning.BICode
	       INNER JOIN dbo.DealerMaster Dealer
	            ON  Summary.SAPID = Dealer.DMA_SAP_Code
	WHERE  Summary.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	       AND Summary.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	       AND Summary.DivisionID = @Bu
	       AND Summary.SubBUCode = @SubBu
	       AND Dealer.DMA_ID = @DealerId
	       AND Summary.SAPID = Summary.BICode
	
	INSERT INTO #DealerBu
	  ([Year], [Quarter], DivisionID, SubBUCode, SAPID, BICode)
	SELECT DISTINCT Summary.[Year],
	       Summary.[Quarter],
	       Summary.DivisionID,
	       Summary.SubBUCode,
	       Summary.SAPID,
	       Summary.BICode
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	       INNER JOIN dbo.DealerMaster Dealer
	            ON  Summary.SAPID = Dealer.DMA_SAP_Code
	WHERE  Summary.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	       AND Summary.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	       AND Summary.DivisionID = @Bu
	       AND Summary.SAPID = Summary.BICode
	
	INSERT INTO #Hospital
	  ([YEAR], [Quarter], DivisionID, Division, SubBUCode, SubBUName, SAPID, DealerName, DMSCode, HospitalName, 
	   SalesOrgLineID, AuthStartDate, KeyHospitalFlag, CoverFlag, HCoverWarningLevel, AchieveFlag, HAchieveWarningLevel, 
	   WarningLevel, HospitalQuota, MarketType, AuthMonth, UncoverMonth, SalesRateCurrent, SalesRateBack1, 
	   SalesRateBack2, SalesRateBack3)
	SELECT DISTINCT B.[YEAR],
	       B.[Quarter],
	       B.DivisionID,
	       B.Division,
	       B.SubBUCode,
	       B.SubBUName,
	       B.SAPID,
	       B.DealerName,
	       B.DMSCode,
	       B.HospitalName,
	       B.SalesOrgLineID,
	       B.AuthStartDate,
	       B.KeyHospitalFlag,
	       B.CoverFlag,
	       B.HCoverWarningLevel,
	       B.AchieveFlag,
	       B.HAchieveWarningLevel,
	       B.WarningLevel,
	       B.HospitalQuota,
	       B.MarketType,
	       B.AuthMonth,
	       B.UncoverMonth,
	       B.SalesRateCurrent,
	       B.SalesRateBack1,
	       B.SalesRateBack2,
	       B.SalesRateBack3
	FROM   #Dealer A
	       INNER JOIN interface.RV_HospitalKPI_WarningLevel B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.DivisionID
	            AND A.SubBUCode = B.SubBUCode
	            AND A.SAPID = B.SAPID
	WHERE  A.BICode = B.BICode
	
	--管辖信息
	INSERT INTO #ResultMain
	SELECT 'Cooperation',
	       CONVERT(
	           NVARCHAR(10),
	           CONVERT(
	               DECIMAL(10, 1),
	               CONVERT(
	                   DECIMAL(10, 1),
	                   DATEDIFF(MONTH, MIN(A.FirstContractDate), GETDATE())
	               ) / 12
	           )
	       )
	FROM   interface.RV_DealerContractMaster_Convert A
	WHERE  A.SubBUCode = @SubBu
	       AND A.SAPID = @SapCode
	       AND A.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	       AND A.[Month] = CASE SUBSTRING(@YearQuarter, 7, 1)
	                            WHEN '1' THEN 3
	                            WHEN '2' THEN 6
	                            WHEN '3' THEN 9
	                            ELSE 12
	                       END
	
	INSERT INTO #ResultMain
	SELECT 'PurchaseQuota',
	       CONVERT(VARCHAR(100), SUM(ISNULL(DealerQuota, 0)), 1)
	FROM   #Dealer
	
	INSERT INTO #ResultMain
	SELECT 'HospitalCount',
	       COUNT(DISTINCT A.DMSCode)
	FROM   #Hospital A
	
	INSERT INTO #ResultMain
	SELECT 'ImplantQuota',
	       CONVERT(VARCHAR(100), SUM(ISNULL(A.HospitalQuota, 0)), 1)
	FROM   #Hospital A
	
	UPDATE #ResultMain
	SET    ResultValue = SUBSTRING(ResultValue, 1, LEN(ResultValue) -3)
	WHERE  ResultKey IN ('PurchaseQuota', 'ImplantQuota')
	
	INSERT INTO #ResultMain
	SELECT 'DealerName',
	       DMA_ChineseShortName
	FROM   dbo.DealerMaster
	WHERE  DMA_ID = @DealerId
	
	IF EXISTS (
	       SELECT 1
	       FROM   Lafite_IDENTITY_MAP T1
	              INNER JOIN Lafite_ATTRIBUTE T2
	                   ON  T1.MAP_ID = T2.Id
	              INNER JOIN DP.RoleMenu T3
	                   ON  T2.ATTRIBUTE_NAME = T3.RoleName
	              INNER JOIN Lafite_IDENTITY T4
	                   ON  T1.IDENTITY_ID = T4.Id
	       WHERE  T1.MAP_TYPE = 'Role'
	              AND T2.ATTRIBUTE_TYPE = 'Role'
	              AND T3.MenuId = 'M_30'
	              AND T4.IDENTITY_CODE = @UserAccount
	   )
	BEGIN
	    INSERT INTO #ResultMain
	    VALUES
	      ('IsCanSeeFeedback', 'True')
	END
	ELSE
	BEGIN
	    INSERT INTO #ResultMain
	    VALUES
	      ('IsCanSeeFeedback', 'False')
	END
	
	IF EXISTS (
	       SELECT 1
	       FROM   interface.RV_DealerKPI_Score_Detail A
	       WHERE  A.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	              AND A.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	              AND A.SAPID = @SapCode
	              AND A.DivisionID = @Bu
	              AND A.SubBUCode = @SubBu
	              AND A.KPICategory <> 'Total'
	              AND A.ParentCode = 'C006'
	   )
	BEGIN
	    INSERT INTO #ResultMain
	    VALUES
	      ('HasAdjust', 'True')
	END
	ELSE
	BEGIN
	    INSERT INTO #ResultMain
	    VALUES
	      ('HasAdjust', 'False')
	END
	
	SELECT *
	FROM   #ResultMain
	
	SELECT DISTINCT Summary.SAPID SapCode,
	       Summary.DealerName DealerName,
	       Summary.DivisionID BuCode,
	       Summary.Division BuName,
	       Summary.SubBUCode SubBuCode,
	       Summary.SubBUName SubBuName,
	       Summary.[Year] [Year],
	       Summary.[Quarter] [Quarter],
	       CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]) YearQuarter,
	       DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1) YearQuarter3,
	       DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2) YearQuarter2,
	       DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3) YearQuarter1,
	       ISNULL(Summary.WarningLevel, '') SummaryLevel,
	       ISNULL(Warning.TotalScoreCurrent, '') TotalScore,
	       ISNULL(Warning.TotalScoreCurrentLevel, '') TotalLevel,
	       ISNULL(Warning.TotalScoreBack3, '') TotalQ1,
	       ISNULL(Warning.TotalScoreBack2, '') TotalQ2,
	       ISNULL(Warning.TotalScoreBack1, '') TotalQ3,
	       ISNULL(Warning.TotalScoreCurrent, '') TotalQ4,
	       ISNULL(Warning.PurchaseCurrent, '') PurchaseScore,
	       ISNULL(Warning.PurchaseCurrentLevel, '') PurchaseLevel,
	       ISNULL(Warning.PurchaseBack3, '') PurchaseQ1,
	       ISNULL(Warning.PurchaseBack2, '') PurchaseQ2,
	       ISNULL(Warning.PurchaseBack1, '') PurchaseQ3,
	       ISNULL(Warning.PurchaseCurrent, '') PurchaseQ4,
	       ISNULL(Warning.CoverCurrent, '') CoverScore,
	       ISNULL(Warning.CoverCurrentLevel, '') CoverLevel,
	       ISNULL(Warning.CoverBack3, '') CoverQ1,
	       ISNULL(Warning.CoverBack2, '') CoverQ2,
	       ISNULL(Warning.CoverBack1, '') CoverQ3,
	       ISNULL(Warning.CoverCurrent, '') CoverQ4,
	       ISNULL(Warning.ReachCurrent, '') AchieveScore,
	       ISNULL(Warning.ReachCurrentLevel, '') AchieveLevel,
	       ISNULL(Warning.ReachBack3, '') AchieveQ1,
	       ISNULL(Warning.ReachBack2, '') AchieveQ2,
	       ISNULL(Warning.ReachBack1, '') AchieveQ3,
	       ISNULL(Warning.ReachCurrent, '') AchieveQ4,
	       CASE 
	            WHEN Feedback.BscFeedStatus IS NULL THEN '99'
	            ELSE Feedback.BscFeedStatus
	       END BscFeedStatus,
	       CASE 
	            WHEN Feedback.BscFeedStatus IS NULL THEN '无需反馈'
	            ELSE dbo.Func_GetCode('CONST_DP_BscFeedbackStatus', Feedback.BscFeedStatus)
	       END AlertStatus
	FROM   #Dealer Summary
	       LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	            ON  Summary.[Year] = Warning.[Year]
	            AND Summary.[Quarter] = Warning.[Quarter]
	            AND Summary.DivisionID = Warning.DivisionID
	            AND Summary.SubBUCode = Warning.SubBUCode
	            AND Summary.SAPID = Warning.SAPID
	            AND Summary.BICode = Warning.BICode
	       LEFT JOIN DP.BscFeedback Feedback
	            ON  Summary.DivisionID = Feedback.Bu
	            AND Summary.SubBUCode = Feedback.SubBu
	            AND Summary.[Year] = Feedback.[Year]
	            AND Summary.[Quarter] = Feedback.[Quarter]
	            AND Summary.SAPID = Feedback.SapCode
	ORDER BY
	       Summary.DealerName,
	       Summary.Division,
	       Summary.SubBUName,
	       CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]) DESC
	
	SELECT DISTINCT Warning.SAPID SapCode,
	       Warning.DealerName DealerName,
	       Warning.DivisionID BuCode,
	       Warning.Division BuName,
	       Warning.SubBUCode SubBuCode,
	       Warning.SubBUName SubBuName,
	       Warning.[Year] [Year],
	       Warning.[Quarter] [Quarter],
	       CONVERT(NVARCHAR(4), Warning.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Warning.[Quarter]) YearQuarter,
	       DP.Func_GetQuarterAdd(Warning.[Year], Warning.[Quarter], -1) YearQuarter3,
	       DP.Func_GetQuarterAdd(Warning.[Year], Warning.[Quarter], -2) YearQuarter2,
	       DP.Func_GetQuarterAdd(Warning.[Year], Warning.[Quarter], -3) YearQuarter1,
	       Warning.DMSCode HospitalCode,
	       Warning.HospitalName HospitalName,
	       Warning.MarketType MarketType,
	       Warning.AuthMonth AuthMonth,
	       Warning.HCoverWarningLevel CoverLevel,
	       Warning.UncoverMonth UncoverMonth,
	       Warning.HAchieveWarningLevel AchieveLevel,
	       ISNULL(Warning.SalesRateBack3, '') AchieveQ1,
	       ISNULL(Warning.SalesRateBack2, '') AchieveQ2,
	       ISNULL(Warning.SalesRateBack1, '') AchieveQ3,
	       ISNULL(Warning.SalesRateCurrent, '') AchieveQ4,
	       Warning.HospitalQuota,
	       CASE 
	            WHEN BscFeedbackProposal.ProposalId IS NULL THEN '99'
	            ELSE Feedback.BscFeedStatus
	       END BscFeedStatus,
	       CASE 
	            WHEN BscFeedbackProposal.ProposalId IS NULL THEN '无需反馈'
	            ELSE dbo.Func_GetCode('CONST_DP_BscFeedbackStatus', Feedback.BscFeedStatus)
	       END AlertStatus
	FROM   #Hospital Warning
	       LEFT JOIN DP.BscFeedback Feedback
	            ON  Warning.DivisionID = Feedback.Bu
	            AND Warning.SubBUCode = Feedback.SubBu
	            AND Warning.[Year] = Feedback.[Year]
	            AND Warning.[Quarter] = Feedback.[Quarter]
	            AND Warning.SAPID = Feedback.SapCode
	       LEFT JOIN DP.BscFeedbackProposal BscFeedbackProposal
	            ON  Feedback.FeedbackCode = BscFeedbackProposal.FeedbackCode
	            AND BscFeedbackProposal.HospitalCode = Warning.DMSCode
	ORDER BY
	       CASE 
	            WHEN BscFeedbackProposal.ProposalId IS NULL THEN '99'
	            ELSE Feedback.BscFeedStatus
	       END,
	       Warning.HospitalQuota DESC,
	       DealerName,
	       HospitalName,
	       BuName,
	       SubBuName,
	       YearQuarter DESC
	
	--迪乐明细
	SELECT A.KPICode,
	       A.KPICategory,
	       A.ScoreRemark,
	       A.ParentCode,
	       A.ParentCategory,
	       A.FullScore,
	       A.FinalScore,
	       CASE 
	            WHEN A.WarningLevel IS NULL THEN ''
	            ELSE CONVERT(NVARCHAR(10), A.WarningLevel)
	       END WarningLevel
	FROM   interface.RV_DealerKPI_Score_Detail A
	WHERE  A.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	       AND A.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	       AND A.SAPID = @SapCode
	       AND A.DivisionID = @Bu
	       AND A.SubBUCode = @SubBu
	       AND A.KPICategory <> 'Total'
	ORDER BY
	       A.ParentCode,
	       A.KPICode
	
	--迪乐总分
	SELECT A.KPICode,
	       A.KPICategory,
	       A.ScoreRemark,
	       A.ParentCode,
	       A.ParentCategory,
	       A.FullScore,
	       A.FinalScore,
	       CASE 
	            WHEN A.WarningLevel IS NULL THEN ''
	            ELSE CONVERT(NVARCHAR(10), A.WarningLevel)
	       END WarningLevel
	FROM   interface.RV_DealerKPI_Score_Detail A
	WHERE  A.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	       AND A.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	       AND A.SAPID = @SapCode
	       AND A.DivisionID = @Bu
	       AND A.SubBUCode = @SubBu
	       AND A.KPICategory = 'Total'
	ORDER BY
	       A.ParentCode,
	       A.KPICode
	
	--经销商维度分析
	--经销商
	DECLARE @DealerCountRange INT;
	SELECT @DealerCountRange = COUNT(*)
	FROM   #Dealer;
	
	IF @DealerCountRange <> 0
	BEGIN
	    SELECT SUM(
	               CASE 
	                    WHEN B.ParentCode = 'C001' THEN B.FinalScore
	                    ELSE 0
	               END
	           ) / @DealerCountRange CGWC,
	           SUM(
	               CASE 
	                    WHEN B.ParentCode = 'C003' THEN B.FinalScore
	                    ELSE 0
	               END
	           ) / @DealerCountRange YYZZJFG,
	           SUM(
	               CASE 
	                    WHEN B.ParentCode = 'C002' THEN B.FinalScore
	                    ELSE 0
	               END
	           ) / @DealerCountRange JXCGL,
	           SUM(
	               CASE 
	                    WHEN B.ParentCode = 'C005' THEN B.FinalScore
	                    ELSE 0
	               END
	           ) / @DealerCountRange BUDZZB,
	           SUM(
	               CASE 
	                    WHEN B.ParentCode = 'C004' THEN B.FinalScore
	                    ELSE 0
	               END
	           ) / @DealerCountRange YYXSWC
	    FROM   #Dealer A
	           INNER JOIN interface.RV_DealerKPI_Score_Detail B
	                ON  A.[Year] = B.[Year]
	                AND A.[Quarter] = B.[Quarter]
	                AND A.DivisionID = B.DivisionID
	                AND A.SubBUCode = B.SubBUCode
	                AND A.SAPID = B.SAPID
	END
	ELSE
	BEGIN
	    SELECT 0 CGWC,
	           0 YYZZJFG,
	           0 JXCGL,
	           0 BUDZZB,
	           0 YYXSWC
	END
	
	/*
	--Bu
	DECLARE @DealerCountBu INT;
	SELECT @DealerCountBu = COUNT(*)
	FROM   #DealerBu;
	
	IF @DealerCountBu <> 0
	BEGIN
	SELECT SUM(
	CASE 
	WHEN B.ParentCode = 'C001' THEN B.FinalScore
	ELSE 0
	END
	) / @DealerCountBu CGWC,
	SUM(
	CASE 
	WHEN B.ParentCode = 'C003' THEN B.FinalScore
	ELSE 0
	END
	) / @DealerCountBu YYZZJFG,
	SUM(
	CASE 
	WHEN B.ParentCode = 'C002' THEN B.FinalScore
	ELSE 0
	END
	) / @DealerCountBu JXCGL,
	SUM(
	CASE 
	WHEN B.ParentCode = 'C005' THEN B.FinalScore
	ELSE 0
	END
	) / @DealerCountBu BUDZZB,
	SUM(
	CASE 
	WHEN B.ParentCode = 'C004' THEN B.FinalScore
	ELSE 0
	END
	) / @DealerCountBu YYXSWC
	FROM   #DealerBu A
	INNER JOIN interface.RV_DealerKPI_Score_Detail B
	ON  A.[Year] = B.[Year]
	AND A.[Quarter] = B.[Quarter]
	AND A.DivisionID = B.DivisionID
	AND A.SubBUCode = B.SubBUCode
	AND A.SAPID = B.SAPID
	END
	ELSE
	BEGIN
	SELECT 0 CGWC,
	0 YYZZJFG,
	0 JXCGL,
	0 BUDZZB,
	0 YYXSWC
	END
	*/
	SELECT 0 CGWC,
	       0 YYZZJFG,
	       0 JXCGL,
	       0 BUDZZB,
	       0 YYXSWC;
	
	--趋势
	SELECT 'Q1' ResultKey,
	       DP.Func_GetQuarterAdd(
	           CONVERT(INT, SUBSTRING(@YearQuarter, 1, 4)),
	           CONVERT(INT, SUBSTRING(@YearQuarter, 7, 1)),
	           -3
	       ) ResultValue
	UNION
	SELECT 'Q2' ResultKey,
	       DP.Func_GetQuarterAdd(
	           CONVERT(INT, SUBSTRING(@YearQuarter, 1, 4)),
	           CONVERT(INT, SUBSTRING(@YearQuarter, 7, 1)),
	           -2
	       ) ResultValue
	UNION
	SELECT 'Q3' ResultKey,
	       DP.Func_GetQuarterAdd(
	           CONVERT(INT, SUBSTRING(@YearQuarter, 1, 4)),
	           CONVERT(INT, SUBSTRING(@YearQuarter, 7, 1)),
	           -1
	       ) ResultValue
	UNION
	SELECT 'Q4' ResultKey,
	       @YearQuarter ResultValue
	UNION
	SELECT 'TotalScoreQ1' ResultKey,
	       Warning.TotalScoreBack3 ResultValue
	FROM   #Dealer Summary
	       LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	            ON  Summary.[Year] = Warning.[Year]
	            AND Summary.[Quarter] = Warning.[Quarter]
	            AND Summary.DivisionID = Warning.DivisionID
	            AND Summary.SubBUCode = Warning.SubBUCode
	            AND Summary.SAPID = Warning.SAPID
	UNION
	SELECT 'TotalScoreQ2' ResultKey,
	       Warning.TotalScoreBack2 ResultValue
	FROM   #Dealer Summary
	       LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	            ON  Summary.[Year] = Warning.[Year]
	            AND Summary.[Quarter] = Warning.[Quarter]
	            AND Summary.DivisionID = Warning.DivisionID
	            AND Summary.SubBUCode = Warning.SubBUCode
	            AND Summary.SAPID = Warning.SAPID
	UNION
	SELECT 'TotalScoreQ3' ResultKey,
	       Warning.TotalScoreBack1 ResultValue
	FROM   #Dealer Summary
	       LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	            ON  Summary.[Year] = Warning.[Year]
	            AND Summary.[Quarter] = Warning.[Quarter]
	            AND Summary.DivisionID = Warning.DivisionID
	            AND Summary.SubBUCode = Warning.SubBUCode
	            AND Summary.SAPID = Warning.SAPID
	UNION
	SELECT 'TotalScoreQ4' ResultKey,
	       Warning.TotalScoreCurrent ResultValue
	FROM   #Dealer Summary
	       LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	            ON  Summary.[Year] = Warning.[Year]
	            AND Summary.[Quarter] = Warning.[Quarter]
	            AND Summary.DivisionID = Warning.DivisionID
	            AND Summary.SubBUCode = Warning.SubBUCode
	            AND Summary.SAPID = Warning.SAPID
	
	INSERT INTO #DealerRank
	SELECT Summary.SAPID,
	       Summary.TotalScore,
	       ROW_NUMBER() OVER(ORDER BY TotalScore ASC)
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	WHERE  Summary.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	       AND Summary.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	       AND Summary.DivisionID = @Bu
	       AND Summary.SubBUCode = @SubBu
	
	SELECT 'TotalScore' ResultKey,
	       TotalScore ResultValue
	FROM   #Dealer
	UNION
	SELECT 'ScoreRank' ResultKey,
	       ScoreRank ResultValue
	FROM   #Dealer
	UNION
	SELECT 'ScoreRankPercent' ResultKey,
	       ScoreRankPercent ResultValue
	FROM   #Dealer
	       --SELECT 'ScoreRank' ResultKey,
	       --       CONVERT(NVARCHAR(10), DealerRank) ResultValue
	       --FROM   #DealerRank
	       --WHERE  SapCode = @SapCode
	       --UNION
	       --SELECT 'DealerCount' ResultKey,
	       --       COUNT(*) ResultValue
	       --FROM   #DealerRank
END
GO


