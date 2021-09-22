DROP PROCEDURE [DP].[Proc_GetBscDashBoard]
GO


CREATE PROCEDURE [DP].[Proc_GetBscDashBoard]
(
    @UserAccount  NVARCHAR(100),
    @YearQuarter  NVARCHAR(100),
    @Bu           NVARCHAR(100),
    @SubBu        NVARCHAR(100),
    @Area         NVARCHAR(100),
    @Lp           NVARCHAR(100),
    @DealerName   NVARCHAR(100)
)
AS
BEGIN
	CREATE TABLE #Dealer
	(
		[Year]        INT,
		[Quarter]     INT,
		DivisionID    INT,
		Division      VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUCode     VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUName     VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		DealerId      UNIQUEIDENTIFIER,
		SAPID         VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		BICode        VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		DealerName    NVARCHAR(255) COLLATE Chinese_PRC_CI_AS,
		DealerType    VARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		TotalScore    INT,
		WarningLevel  INT,
		DealerQuota   MONEY,
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
		AuthStartDate         DATE,
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
	
	CREATE TABLE #ResultQualified
	(
		DealerId               UNIQUEIDENTIFIER,
		DealerName             NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		DivisionID             INT,
		Division               NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUCode              NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUName              NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		[Year]                 INT,
		[Quarter]              INT,
		YearQuarter            NVARCHAR(7),
		WarningLevel           INT,
		Quota                  MONEY,
		TotalScoreQ1           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalScoreQ2           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalScoreQ3           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalScoreQ4           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter1           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter2           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter3           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter4           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		Increase               INT,
		FeedbackHospitalCount  INT,
		QualifiedType          NVARCHAR(20) COLLATE Chinese_PRC_CI_AS
	)
	
	CREATE TABLE #DealerRankTop
	(
		DealerId     UNIQUEIDENTIFIER,
		DealerName   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		DivisionID   INT,
		Division     NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUCode    NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUName    NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		YearQuarter  NVARCHAR(7) COLLATE Chinese_PRC_CI_AS,
		TotalScore   NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		DealerQuota  NVARCHAR(100),
		DealerRank   INT
	)
	
	CREATE TABLE #DealerRankBottom
	(
		DealerId     UNIQUEIDENTIFIER,
		DealerName   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		DivisionID   INT,
		Division     NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUCode    NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		SubBUName    NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		YearQuarter  NVARCHAR(7) COLLATE Chinese_PRC_CI_AS,
		TotalScore   NVARCHAR(20) COLLATE Chinese_PRC_CI_AS,
		DealerQuota  NVARCHAR(100),
		DealerRank   INT
	)
	
	INSERT INTO #Dealer
	  (
	    [Year],
	    [Quarter],
	    DivisionID,
	    Division,
	    SubBUCode,
	    SubBUName,
	    DealerId,
	    SAPID,
	    BICode,
	    DealerName,
	    DealerType,
	    TotalScore,
	    WarningLevel,
	    DealerQuota
	  )
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
	       Summary.DealerQuota
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	       INNER JOIN dbo.DealerMaster Dealer
	            ON  Summary.SAPID = Dealer.DMA_SAP_Code
	       INNER JOIN interface.RV_DealerKPI_Score_Warning Warning
	            ON  Summary.[Year] = Warning.[Year]
	            AND Summary.[Quarter] = Warning.[Quarter]
	            AND Summary.DivisionID = Warning.DivisionID
	            AND Summary.SubBUCode = Warning.SubBUCode
	            AND Summary.SAPID = Warning.SAPID
	            AND Summary.BICode = Warning.BICode
	WHERE  Warning.IsActive = 1
	       AND Summary.SAPID = Summary.BICode
	       AND Summary.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	       AND Summary.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	       AND Summary.DivisionID = @Bu
	       AND Summary.SubBUCode = @SubBu
	       AND (
	               ISNULL(@Area, '') = ''
	               OR EXISTS (
	                      SELECT 1
	                      FROM   dbo.GC_Fn_SplitStringToTable(@Area, ',')
	                      WHERE  VAL = ISNULL(Summary.AreaCode, 'NULL')
	                  )
	           )
	       AND (
	               ISNULL(@Lp, '') = ''
	               OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	           )
	       AND (
	               ISNULL(@DealerName, '') = ''
	               OR Dealer.DMA_ChineseShortName LIKE '%' + @DealerName + '%'
	           )
	       AND EXISTS (
	               SELECT 1
	               FROM   DP.UserDealerMapping Mapping
	               WHERE  Summary.DivisionID = Mapping.Division
	                      AND Summary.SubBUCode = Mapping.SubBu
	                      AND Summary.SAPID = Mapping.SapCode
	                      AND Mapping.UserAccount = @UserAccount
	           )
	
	INSERT INTO #DealerBu
	  (
	    [Year],
	    [Quarter],
	    DivisionID,
	    SubBUCode,
	    SAPID,
	    BICode
	  )
	SELECT DISTINCT Summary.[Year],
	       Summary.[Quarter],
	       Summary.DivisionID,
	       Summary.SubBUCode,
	       Summary.SAPID,
	       Summary.BICode
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	       INNER JOIN interface.RV_DealerKPI_Score_Warning Warning
	            ON  Summary.[Year] = Warning.[Year]
	            AND Summary.[Quarter] = Warning.[Quarter]
	            AND Summary.DivisionID = Warning.DivisionID
	            AND Summary.SubBUCode = Warning.SubBUCode
	            AND Summary.SAPID = Warning.SAPID
	            AND Summary.BICode = Warning.BICode
	WHERE  Warning.IsActive = 1
	       AND Summary.SAPID = Summary.BICode
	       AND Summary.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	       AND Summary.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	       AND Summary.DivisionID = @Bu
	
	INSERT INTO #Hospital
	  (
	    [YEAR],
	    [Quarter],
	    DivisionID,
	    Division,
	    SubBUCode,
	    SubBUName,
	    SAPID,
	    BICode,
	    DealerName,
	    DMSCode,
	    HospitalName,
	    SalesOrgLineID,
	    AuthStartDate,
	    KeyHospitalFlag,
	    CoverFlag,
	    HCoverWarningLevel,
	    AchieveFlag,
	    HAchieveWarningLevel,
	    WarningLevel,
	    HospitalQuota,
	    MarketType,
	    AuthMonth,
	    UncoverMonth,
	    SalesRateCurrent,
	    SalesRateBack1,
	    SalesRateBack2,
	    SalesRateBack3
	  )
	SELECT DISTINCT B.[YEAR],
	       B.[Quarter],
	       B.DivisionID,
	       B.Division,
	       B.SubBUCode,
	       B.SubBUName,
	       B.SAPID,
	       B.BICode,
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
	            AND A.BICode = B.BICode
	
	--管辖信息
	DECLARE @Q1 NVARCHAR(7);
	DECLARE @Q2 NVARCHAR(7);
	DECLARE @Q3 NVARCHAR(7);
	DECLARE @Q4 NVARCHAR(7);
	SET @Q1 = DP.Func_GetQuarterAdd(
	        CONVERT(INT, SUBSTRING(@YearQuarter, 1, 4)),
	        CONVERT(INT, SUBSTRING(@YearQuarter, 7, 1)),
	        -3
	    );
	SET @Q2 = DP.Func_GetQuarterAdd(
	        CONVERT(INT, SUBSTRING(@YearQuarter, 1, 4)),
	        CONVERT(INT, SUBSTRING(@YearQuarter, 7, 1)),
	        -2
	    );
	SET @Q3 = DP.Func_GetQuarterAdd(
	        CONVERT(INT, SUBSTRING(@YearQuarter, 1, 4)),
	        CONVERT(INT, SUBSTRING(@YearQuarter, 7, 1)),
	        -1
	    );
	SET @Q4 = @YearQuarter;
	
	INSERT INTO #ResultMain
	SELECT 'Q-3',
	       @Q1
	
	INSERT INTO #ResultMain
	SELECT 'Q-2',
	       @Q2
	
	INSERT INTO #ResultMain
	SELECT 'Q-1',
	       @Q3
	
	INSERT INTO #ResultMain
	SELECT 'Q',
	       @Q4
	
	INSERT INTO #ResultMain
	SELECT 'DealerCount',
	       COUNT(SAPID)
	FROM   #Dealer
	
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
	
	INSERT INTO #ResultMain
	SELECT 'DealerLevelRed',
	       COUNT(SAPID)
	FROM   #Dealer A
	       INNER JOIN DP.BscFeedback B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.Bu
	            AND A.SubBUCode = B.SubBu
	            AND A.SAPID = B.SapCode
	WHERE  A.WarningLevel = 11
	
	INSERT INTO #ResultMain
	SELECT 'DealerLevelYellow',
	       COUNT(SAPID)
	FROM   #Dealer A
	       INNER JOIN DP.BscFeedback B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.Bu
	            AND A.SubBUCode = B.SubBu
	            AND A.SAPID = B.SapCode
	WHERE  A.WarningLevel = 12
	
	INSERT INTO #ResultMain
	SELECT 'DealerLevelGreen',
	       COUNT(SAPID)
	FROM   #Dealer A
	       INNER JOIN DP.BscFeedback B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.Bu
	            AND A.SubBUCode = B.SubBu
	            AND A.SAPID = B.SapCode
	WHERE  A.WarningLevel = 0
	
	INSERT INTO #ResultMain
	SELECT 'HospitalLevelRed',
	       COUNT(DISTINCT D.DMSCode)
	FROM   #Dealer A
	       INNER JOIN DP.BscFeedback B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.Bu
	            AND A.SubBUCode = B.SubBu
	            AND A.SAPID = B.SapCode
	       INNER JOIN DP.BscFeedbackProposal C
	            ON  B.FeedbackCode = C.FeedbackCode
	       INNER JOIN #Hospital D
	            ON  A.[Year] = D.[YEAR]
	            AND A.Quarter = D.Quarter
	            AND A.DivisionID = D.DivisionID
	            AND A.SubBUCode = D.SubBUCode
	            AND A.SAPID = D.SAPID
	            AND C.HospitalCode = D.DMSCode
	WHERE  A.WarningLevel = 11
	
	INSERT INTO #ResultMain
	SELECT 'HospitalLevelYellow',
	       COUNT(DISTINCT D.DMSCode)
	FROM   #Dealer A
	       INNER JOIN DP.BscFeedback B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.Bu
	            AND A.SubBUCode = B.SubBu
	            AND A.SAPID = B.SapCode
	       INNER JOIN DP.BscFeedbackProposal C
	            ON  B.FeedbackCode = C.FeedbackCode
	       INNER JOIN #Hospital D
	            ON  A.[Year] = D.[YEAR]
	            AND A.Quarter = D.Quarter
	            AND A.DivisionID = D.DivisionID
	            AND A.SubBUCode = D.SubBUCode
	            AND A.SAPID = D.SAPID
	            AND C.HospitalCode = D.DMSCode
	WHERE  A.WarningLevel = 12
	
	INSERT INTO #ResultMain
	SELECT 'HospitalLevelGreen',
	       COUNT(DISTINCT D.DMSCode)
	FROM   #Dealer A
	       INNER JOIN DP.BscFeedback B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.Bu
	            AND A.SubBUCode = B.SubBu
	            AND A.SAPID = B.SapCode
	       INNER JOIN DP.BscFeedbackProposal C
	            ON  B.FeedbackCode = C.FeedbackCode
	       INNER JOIN #Hospital D
	            ON  A.[Year] = D.[YEAR]
	            AND A.Quarter = D.Quarter
	            AND A.DivisionID = D.DivisionID
	            AND A.SubBUCode = D.SubBUCode
	            AND A.SAPID = D.SAPID
	            AND C.HospitalCode = D.DMSCode
	WHERE  A.WarningLevel = 0
	
	UPDATE #ResultMain
	SET    ResultValue = SUBSTRING(ResultValue, 1, LEN(ResultValue) -3)
	WHERE  ResultKey IN ('PurchaseQuota', 'ImplantQuota')
	
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
	      (
	        'IsCanSeeFeedback',
	        'True'
	      )
	END
	ELSE
	BEGIN
	    INSERT INTO #ResultMain
	    VALUES
	      (
	        'IsCanSeeFeedback',
	        'False'
	      )
	END
	
	SELECT *
	FROM   #ResultMain
	
	--销售团队反馈
	SELECT A.WarningLevel,
	       B.BscFeedStatus,
	       COUNT(*) CNT
	FROM   #Dealer A
	       INNER JOIN DP.BscFeedback B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.Bu
	            AND A.SubBUCode = B.SubBu
	            AND A.SAPID = B.SapCode
	GROUP BY
	       A.WarningLevel,
	       B.BscFeedStatus
	
	--经销商反馈
	SELECT A.WarningLevel,
	       CASE 
	            WHEN B.FeedbackId IS NULL THEN '00'
	            ELSE '10'
	       END DealerFeedStatus,
	       COUNT(*) CNT
	FROM   #Dealer A
	       LEFT JOIN DP.DealerFeedback B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.Bu
	            AND A.SubBUCode = B.SubBu
	            AND A.SAPID = B.SapCode
	       INNER JOIN DP.BscFeedback C
	            ON  A.[Year] = C.[Year]
	            AND A.[Quarter] = C.[Quarter]
	            AND A.DivisionID = C.Bu
	            AND A.SubBUCode = C.SubBu
	            AND A.SAPID = C.SapCode
	GROUP BY
	       A.WarningLevel,
	       CASE 
	            WHEN B.FeedbackId IS NULL THEN '00'
	            ELSE '10'
	       END
	
	--经销商分布
	SELECT A.DealerId,
	       A.DealerName,
	       A.DivisionID,
	       A.Division,
	       A.SubBUCode,
	       A.SubBUName,
	       CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]) YearQuarter,
	       A.DealerQuota,
	       DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], -3) YearQuarter1,
	       DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], -2) YearQuarter2,
	       DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], -1) YearQuarter3,
	       DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], 0) YearQuarter4,
	       ISNULL(B.TotalScoreBack3, '') TotalScoreQ1,
	       ISNULL(B.TotalScoreBack2, '') TotalScoreQ2,
	       ISNULL(B.TotalScoreBack1, '') TotalScoreQ3,
	       ISNULL(B.TotalScoreCurrent, '') TotalScoreQ4,
	       CONVERT(INT, ISNULL(B.TotalScoreCurrent, '0')) - CONVERT(INT, ISNULL(B.TotalScoreBack1, '0')) Increase,
	       ISNULL(B.FeedbackHospital, 0) FeedbackHospitalCount,
	       B.SpreadRate,
	       A.WarningLevel
	FROM   #Dealer A
	       INNER JOIN interface.RV_DealerKPI_Score_Warning B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.DivisionID
	            AND A.SubBUCode = B.SubBUCode
	            AND A.SAPID = B.SAPID
	            AND A.BICode = B.BICode
	
	/*
	--经销商维度分析
	--所选区域
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
	
	--BU
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
	SELECT 0 CGWC,
	       0 YYZZJFG,
	       0 JXCGL,
	       0 BUDZZB,
	       0 YYXSWC;
	
	--未预警经销商比率
	/*
	--Q1
	INSERT INTO #ResultQualified
	SELECT DISTINCT Dealer.DMA_ID,
	Dealer.DMA_ChineseShortName,
	Summary.DivisionID,
	Summary.Division,
	Summary.SubBUCode,
	Summary.SubBUName,
	Summary.[Year],
	Summary.[Quarter],
	CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]),
	Summary.WarningLevel,
	Summary.DealerQuota,
	ISNULL(Warning.TotalScoreBack3, ''),
	ISNULL(Warning.TotalScoreBack2, ''),
	ISNULL(Warning.TotalScoreBack1, ''),
	ISNULL(Warning.TotalScoreCurrent, ''),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0),
	CONVERT(INT, ISNULL(Warning.TotalScoreBack1, '')) -CONVERT(INT, ISNULL(Warning.TotalScoreCurrent, '')),
	ISNULL(Warning.FeedbackHospital, 0),
	'QualifiedQ1'
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	INNER JOIN dbo.DealerMaster Dealer
	ON  Summary.SAPID = Dealer.DMA_SAP_Code
	LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	ON  Summary.[Year] = Warning.[Year]
	AND Summary.[Quarter] = Warning.[Quarter]
	AND Summary.DivisionID = Warning.DivisionID
	AND Summary.SubBUCode = Warning.SubBUCode
	AND Summary.SAPID = Warning.SAPID
	WHERE  Warning.IsWarning = 0
	AND Summary.[Year] = SUBSTRING(@Q1, 1, 4)
	AND Summary.[Quarter] = SUBSTRING(@Q1, 7, 1)
	AND Summary.DivisionID = @Bu
	AND Summary.SubBUCode = @SubBu
	AND (ISNULL(@Area, '') = '' OR Summary.AreaCode = @Area)
	AND (
	ISNULL(@Lp, '') = ''
	OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	)
	AND EXISTS (
	SELECT 1
	FROM   DP.UserDealerMapping Mapping
	WHERE  Summary.DivisionID = Mapping.Division
	AND Summary.SubBUCode = Mapping.SubBu
	AND Summary.SAPID = Mapping.SapCode
	AND Mapping.UserAccount = @UserAccount
	)
	
	INSERT INTO #ResultQualified
	SELECT DISTINCT Dealer.DMA_ID,
	Dealer.DMA_ChineseShortName,
	Summary.DivisionID,
	Summary.Division,
	Summary.SubBUCode,
	Summary.SubBUName,
	Summary.[Year],
	Summary.[Quarter],
	CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]),
	Summary.WarningLevel,
	Summary.DealerQuota,
	ISNULL(Warning.TotalScoreBack3, ''),
	ISNULL(Warning.TotalScoreBack2, ''),
	ISNULL(Warning.TotalScoreBack1, ''),
	ISNULL(Warning.TotalScoreCurrent, ''),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0),
	CONVERT(INT, ISNULL(Warning.TotalScoreBack1, '')) -CONVERT(INT, ISNULL(Warning.TotalScoreCurrent, '')),
	ISNULL(Warning.FeedbackHospital, 0),
	'UnqualifiedQ1'
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	INNER JOIN dbo.DealerMaster Dealer
	ON  Summary.SAPID = Dealer.DMA_SAP_Code
	LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	ON  Summary.[Year] = Warning.[Year]
	AND Summary.[Quarter] = Warning.[Quarter]
	AND Summary.DivisionID = Warning.DivisionID
	AND Summary.SubBUCode = Warning.SubBUCode
	AND Summary.SAPID = Warning.SAPID
	WHERE  Warning.IsWarning = 1
	AND Summary.[Year] = SUBSTRING(@Q1, 1, 4)
	AND Summary.[Quarter] = SUBSTRING(@Q1, 7, 1)
	AND Summary.DivisionID = @Bu
	AND Summary.SubBUCode = @SubBu
	AND (ISNULL(@Area, '') = '' OR Summary.AreaCode = @Area)
	AND (
	ISNULL(@Lp, '') = ''
	OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	)
	AND EXISTS (
	SELECT 1
	FROM   DP.UserDealerMapping Mapping
	WHERE  Summary.DivisionID = Mapping.Division
	AND Summary.SubBUCode = Mapping.SubBu
	AND Summary.SAPID = Mapping.SapCode
	AND Mapping.UserAccount = @UserAccount
	)
	
	--Q2
	INSERT INTO #ResultQualified
	SELECT DISTINCT Dealer.DMA_ID,
	Dealer.DMA_ChineseShortName,
	Summary.DivisionID,
	Summary.Division,
	Summary.SubBUCode,
	Summary.SubBUName,
	Summary.[Year],
	Summary.[Quarter],
	CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]),
	Summary.WarningLevel,
	Summary.DealerQuota,
	ISNULL(Warning.TotalScoreBack3, ''),
	ISNULL(Warning.TotalScoreBack2, ''),
	ISNULL(Warning.TotalScoreBack1, ''),
	ISNULL(Warning.TotalScoreCurrent, ''),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0),
	CONVERT(INT, ISNULL(Warning.TotalScoreBack1, '')) -CONVERT(INT, ISNULL(Warning.TotalScoreCurrent, '')),
	ISNULL(Warning.FeedbackHospital, 0),
	'QualifiedQ2'
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	INNER JOIN dbo.DealerMaster Dealer
	ON  Summary.SAPID = Dealer.DMA_SAP_Code
	LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	ON  Summary.[Year] = Warning.[Year]
	AND Summary.[Quarter] = Warning.[Quarter]
	AND Summary.DivisionID = Warning.DivisionID
	AND Summary.SubBUCode = Warning.SubBUCode
	AND Summary.SAPID = Warning.SAPID
	WHERE  Warning.IsWarning = 0
	AND Summary.[Year] = SUBSTRING(@Q2, 1, 4)
	AND Summary.[Quarter] = SUBSTRING(@Q2, 7, 1)
	AND Summary.DivisionID = @Bu
	AND Summary.SubBUCode = @SubBu
	AND (ISNULL(@Area, '') = '' OR Summary.AreaCode = @Area)
	AND (
	ISNULL(@Lp, '') = ''
	OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	)
	AND EXISTS (
	SELECT 1
	FROM   DP.UserDealerMapping Mapping
	WHERE  Summary.DivisionID = Mapping.Division
	AND Summary.SubBUCode = Mapping.SubBu
	AND Summary.SAPID = Mapping.SapCode
	AND Mapping.UserAccount = @UserAccount
	)
	
	INSERT INTO #ResultQualified
	SELECT DISTINCT Dealer.DMA_ID,
	Dealer.DMA_ChineseShortName,
	Summary.DivisionID,
	Summary.Division,
	Summary.SubBUCode,
	Summary.SubBUName,
	Summary.[Year],
	Summary.[Quarter],
	CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]),
	Summary.WarningLevel,
	Summary.DealerQuota,
	ISNULL(Warning.TotalScoreBack3, ''),
	ISNULL(Warning.TotalScoreBack2, ''),
	ISNULL(Warning.TotalScoreBack1, ''),
	ISNULL(Warning.TotalScoreCurrent, ''),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0),
	CONVERT(INT, ISNULL(Warning.TotalScoreBack1, '')) -CONVERT(INT, ISNULL(Warning.TotalScoreCurrent, '')),
	ISNULL(Warning.FeedbackHospital, 0),
	'UnqualifiedQ2'
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	INNER JOIN dbo.DealerMaster Dealer
	ON  Summary.SAPID = Dealer.DMA_SAP_Code
	LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	ON  Summary.[Year] = Warning.[Year]
	AND Summary.[Quarter] = Warning.[Quarter]
	AND Summary.DivisionID = Warning.DivisionID
	AND Summary.SubBUCode = Warning.SubBUCode
	AND Summary.SAPID = Warning.SAPID
	WHERE  Warning.IsWarning = 1
	AND Summary.[Year] = SUBSTRING(@Q2, 1, 4)
	AND Summary.[Quarter] = SUBSTRING(@Q2, 7, 1)
	AND Summary.DivisionID = @Bu
	AND Summary.SubBUCode = @SubBu
	AND (ISNULL(@Area, '') = '' OR Summary.AreaCode = @Area)
	AND (
	ISNULL(@Lp, '') = ''
	OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	)
	AND EXISTS (
	SELECT 1
	FROM   DP.UserDealerMapping Mapping
	WHERE  Summary.DivisionID = Mapping.Division
	AND Summary.SubBUCode = Mapping.SubBu
	AND Summary.SAPID = Mapping.SapCode
	AND Mapping.UserAccount = @UserAccount
	)
	
	--Q3
	INSERT INTO #ResultQualified
	SELECT DISTINCT Dealer.DMA_ID,
	Dealer.DMA_ChineseShortName,
	Summary.DivisionID,
	Summary.Division,
	Summary.SubBUCode,
	Summary.SubBUName,
	Summary.[Year],
	Summary.[Quarter],
	CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]),
	Summary.WarningLevel,
	Summary.DealerQuota,
	ISNULL(Warning.TotalScoreBack3, ''),
	ISNULL(Warning.TotalScoreBack2, ''),
	ISNULL(Warning.TotalScoreBack1, ''),
	ISNULL(Warning.TotalScoreCurrent, ''),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0),
	CONVERT(INT, ISNULL(Warning.TotalScoreBack1, '')) -CONVERT(INT, ISNULL(Warning.TotalScoreCurrent, '')),
	ISNULL(Warning.FeedbackHospital, 0),
	'QualifiedQ3'
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	INNER JOIN dbo.DealerMaster Dealer
	ON  Summary.SAPID = Dealer.DMA_SAP_Code
	LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	ON  Summary.[Year] = Warning.[Year]
	AND Summary.[Quarter] = Warning.[Quarter]
	AND Summary.DivisionID = Warning.DivisionID
	AND Summary.SubBUCode = Warning.SubBUCode
	AND Summary.SAPID = Warning.SAPID
	WHERE  Warning.IsWarning = 0
	AND Summary.[Year] = SUBSTRING(@Q3, 1, 4)
	AND Summary.[Quarter] = SUBSTRING(@Q3, 7, 1)
	AND Summary.DivisionID = @Bu
	AND Summary.SubBUCode = @SubBu
	AND (ISNULL(@Area, '') = '' OR Summary.AreaCode = @Area)
	AND (
	ISNULL(@Lp, '') = ''
	OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	)
	AND EXISTS (
	SELECT 1
	FROM   DP.UserDealerMapping Mapping
	WHERE  Summary.DivisionID = Mapping.Division
	AND Summary.SubBUCode = Mapping.SubBu
	AND Summary.SAPID = Mapping.SapCode
	AND Mapping.UserAccount = @UserAccount
	)
	
	INSERT INTO #ResultQualified
	SELECT DISTINCT Dealer.DMA_ID,
	Dealer.DMA_ChineseShortName,
	Summary.DivisionID,
	Summary.Division,
	Summary.SubBUCode,
	Summary.SubBUName,
	Summary.[Year],
	Summary.[Quarter],
	CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]),
	Summary.WarningLevel,
	Summary.DealerQuota,
	ISNULL(Warning.TotalScoreBack3, ''),
	ISNULL(Warning.TotalScoreBack2, ''),
	ISNULL(Warning.TotalScoreBack1, ''),
	ISNULL(Warning.TotalScoreCurrent, ''),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0),
	CONVERT(INT, ISNULL(Warning.TotalScoreBack1, '')) -CONVERT(INT, ISNULL(Warning.TotalScoreCurrent, '')),
	ISNULL(Warning.FeedbackHospital, 0),
	'UnqualifiedQ3'
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	INNER JOIN dbo.DealerMaster Dealer
	ON  Summary.SAPID = Dealer.DMA_SAP_Code
	LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	ON  Summary.[Year] = Warning.[Year]
	AND Summary.[Quarter] = Warning.[Quarter]
	AND Summary.DivisionID = Warning.DivisionID
	AND Summary.SubBUCode = Warning.SubBUCode
	AND Summary.SAPID = Warning.SAPID
	WHERE  Warning.IsWarning = 1
	AND Summary.[Year] = SUBSTRING(@Q3, 1, 4)
	AND Summary.[Quarter] = SUBSTRING(@Q3, 7, 1)
	AND Summary.DivisionID = @Bu
	AND Summary.SubBUCode = @SubBu
	AND (ISNULL(@Area, '') = '' OR Summary.AreaCode = @Area)
	AND (
	ISNULL(@Lp, '') = ''
	OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	)
	AND EXISTS (
	SELECT 1
	FROM   DP.UserDealerMapping Mapping
	WHERE  Summary.DivisionID = Mapping.Division
	AND Summary.SubBUCode = Mapping.SubBu
	AND Summary.SAPID = Mapping.SapCode
	AND Mapping.UserAccount = @UserAccount
	)
	
	--Q4
	INSERT INTO #ResultQualified
	SELECT DISTINCT Dealer.DMA_ID,
	Dealer.DMA_ChineseShortName,
	Summary.DivisionID,
	Summary.Division,
	Summary.SubBUCode,
	Summary.SubBUName,
	Summary.[Year],
	Summary.[Quarter],
	CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]),
	Summary.WarningLevel,
	Summary.DealerQuota,
	ISNULL(Warning.TotalScoreBack3, ''),
	ISNULL(Warning.TotalScoreBack2, ''),
	ISNULL(Warning.TotalScoreBack1, ''),
	ISNULL(Warning.TotalScoreCurrent, ''),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0),
	CONVERT(INT, ISNULL(Warning.TotalScoreBack1, '')) -CONVERT(INT, ISNULL(Warning.TotalScoreCurrent, '')),
	ISNULL(Warning.FeedbackHospital, 0),
	'QualifiedQ4'
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	INNER JOIN dbo.DealerMaster Dealer
	ON  Summary.SAPID = Dealer.DMA_SAP_Code
	LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	ON  Summary.[Year] = Warning.[Year]
	AND Summary.[Quarter] = Warning.[Quarter]
	AND Summary.DivisionID = Warning.DivisionID
	AND Summary.SubBUCode = Warning.SubBUCode
	AND Summary.SAPID = Warning.SAPID
	WHERE  Warning.IsWarning = 0
	AND Summary.[Year] = SUBSTRING(@Q4, 1, 4)
	AND Summary.[Quarter] = SUBSTRING(@Q4, 7, 1)
	AND Summary.DivisionID = @Bu
	AND Summary.SubBUCode = @SubBu
	AND (ISNULL(@Area, '') = '' OR Summary.AreaCode = @Area)
	AND (
	ISNULL(@Lp, '') = ''
	OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	)
	AND EXISTS (
	SELECT 1
	FROM   DP.UserDealerMapping Mapping
	WHERE  Summary.DivisionID = Mapping.Division
	AND Summary.SubBUCode = Mapping.SubBu
	AND Summary.SAPID = Mapping.SapCode
	AND Mapping.UserAccount = @UserAccount
	)
	
	INSERT INTO #ResultQualified
	SELECT DISTINCT Dealer.DMA_ID,
	Dealer.DMA_ChineseShortName,
	Summary.DivisionID,
	Summary.Division,
	Summary.SubBUCode,
	Summary.SubBUName,
	Summary.[Year],
	Summary.[Quarter],
	CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]),
	Summary.WarningLevel,
	Summary.DealerQuota,
	ISNULL(Warning.TotalScoreBack3, ''),
	ISNULL(Warning.TotalScoreBack2, ''),
	ISNULL(Warning.TotalScoreBack1, ''),
	ISNULL(Warning.TotalScoreCurrent, ''),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1),
	DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0),
	CONVERT(INT, ISNULL(Warning.TotalScoreBack1, '')) -CONVERT(INT, ISNULL(Warning.TotalScoreCurrent, '')),
	ISNULL(Warning.FeedbackHospital, 0),
	'UnqualifiedQ4'
	FROM   interface.RV_DealerKPI_Score_Summary Summary
	INNER JOIN dbo.DealerMaster Dealer
	ON  Summary.SAPID = Dealer.DMA_SAP_Code
	LEFT JOIN interface.RV_DealerKPI_Score_Warning Warning
	ON  Summary.[Year] = Warning.[Year]
	AND Summary.[Quarter] = Warning.[Quarter]
	AND Summary.DivisionID = Warning.DivisionID
	AND Summary.SubBUCode = Warning.SubBUCode
	AND Summary.SAPID = Warning.SAPID
	WHERE  Warning.IsWarning = 1
	AND Summary.[Year] = SUBSTRING(@Q4, 1, 4)
	AND Summary.[Quarter] = SUBSTRING(@Q4, 7, 1)
	AND Summary.DivisionID = @Bu
	AND Summary.SubBUCode = @SubBu
	AND (ISNULL(@Area, '') = '' OR Summary.AreaCode = @Area)
	AND (
	ISNULL(@Lp, '') = ''
	OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	)
	AND EXISTS (
	SELECT 1
	FROM   DP.UserDealerMapping Mapping
	WHERE  Summary.DivisionID = Mapping.Division
	AND Summary.SubBUCode = Mapping.SubBu
	AND Summary.SAPID = Mapping.SapCode
	AND Mapping.UserAccount = @UserAccount
	)
	*/
	
	SELECT 'Q1' ResultKey,
	       @Q1 ResultValue
	UNION
	SELECT 'Q2' ResultKey,
	       @Q2 ResultValue
	UNION
	SELECT 'Q3' ResultKey,
	       @Q3 ResultValue
	UNION
	SELECT 'Q4' ResultKey,
	       @Q4 ResultValue
	UNION
	SELECT 'QualifiedQ1' ResultKey,
	       CONVERT(NVARCHAR(100), COUNT(*)) ResultValue
	FROM   #ResultQualified
	WHERE  QualifiedType = 'QualifiedQ1'
	UNION
	SELECT 'QualifiedQ2' ResultKey,
	       CONVERT(NVARCHAR(100), COUNT(*)) ResultValue
	FROM   #ResultQualified
	WHERE  QualifiedType = 'QualifiedQ2'
	UNION
	SELECT 'QualifiedQ3' ResultKey,
	       CONVERT(NVARCHAR(100), COUNT(*)) ResultValue
	FROM   #ResultQualified
	WHERE  QualifiedType = 'QualifiedQ3'
	UNION
	SELECT 'QualifiedQ4' ResultKey,
	       CONVERT(NVARCHAR(100), COUNT(*)) ResultValue
	FROM   #ResultQualified
	WHERE  QualifiedType = 'QualifiedQ4'
	UNION
	SELECT 'UnqualifiedQ1' ResultKey,
	       CONVERT(NVARCHAR(100), COUNT(*)) ResultValue
	FROM   #ResultQualified
	WHERE  QualifiedType = 'UnqualifiedQ1'
	UNION
	SELECT 'UnqualifiedQ2' ResultKey,
	       CONVERT(NVARCHAR(100), COUNT(*)) ResultValue
	FROM   #ResultQualified
	WHERE  QualifiedType = 'UnqualifiedQ2'
	UNION
	SELECT 'UnqualifiedQ3' ResultKey,
	       CONVERT(NVARCHAR(100), COUNT(*)) ResultValue
	FROM   #ResultQualified
	WHERE  QualifiedType = 'UnqualifiedQ3'
	UNION
	SELECT 'UnqualifiedQ4' ResultKey,
	       CONVERT(NVARCHAR(100), COUNT(*)) ResultValue
	FROM   #ResultQualified
	WHERE  QualifiedType = 'UnqualifiedQ4'
	
	SELECT *
	FROM   #ResultQualified
	WHERE  QualifiedType = 'QualifiedQ1'
	
	SELECT *
	FROM   #ResultQualified
	WHERE  QualifiedType = 'QualifiedQ2'
	
	SELECT *
	FROM   #ResultQualified
	WHERE  QualifiedType = 'QualifiedQ3'
	
	SELECT *
	FROM   #ResultQualified
	WHERE  QualifiedType = 'QualifiedQ4'
	
	SELECT *
	FROM   #ResultQualified
	WHERE  QualifiedType = 'UnqualifiedQ1'
	
	SELECT *
	FROM   #ResultQualified
	WHERE  QualifiedType = 'UnqualifiedQ2'
	
	SELECT *
	FROM   #ResultQualified
	WHERE  QualifiedType = 'UnqualifiedQ3'
	
	SELECT *
	FROM   #ResultQualified
	WHERE  QualifiedType = 'UnqualifiedQ4'
	
	--成长进步
	SELECT TOP 5 A.DealerId,
	       A.DealerName,
	       A.DivisionID,
	       A.Division,
	       A.SubBUCode,
	       A.SubBUName,
	       CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]) YearQuarter,
	       B.TotalScoreBack1 TotalScoreBack1,
	       B.TotalScoreCurrent TotalScoreCurrent,
	       SUBSTRING(
	           CONVERT(VARCHAR(100), ISNULL(A.DealerQuota, 0), 1),
	           1,
	           LEN(CONVERT(VARCHAR(100), ISNULL(A.DealerQuota, 0), 1)) -3
	       ) DealerQuota,
	       (
	           CONVERT(INT, B.TotalScoreCurrent) - CONVERT(INT, B.TotalScoreBack1)
	       ) Grow,
	       ROW_NUMBER() OVER(
	           ORDER BY(
	               CONVERT(INT, B.TotalScoreCurrent) - CONVERT(INT, B.TotalScoreBack1)
	           ) DESC
	       ) DealerRank
	FROM   #Dealer A
	       INNER JOIN interface.RV_DealerKPI_Score_Warning B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.DivisionID
	            AND A.SubBUCode = B.SubBUCode
	            AND A.SAPID = B.SAPID
	            AND A.BICode = B.BICode
	WHERE  CONVERT(INT, B.TotalScoreCurrent) - CONVERT(INT, B.TotalScoreBack1) > 0
	
	--成长退步
	SELECT TOP 5 A.DealerId,
	       A.DealerName,
	       A.DivisionID,
	       A.Division,
	       A.SubBUCode,
	       A.SubBUName,
	       CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]) YearQuarter,
	       B.TotalScoreBack1 TotalScoreBack1,
	       B.TotalScoreCurrent TotalScoreCurrent,
	       SUBSTRING(
	           CONVERT(VARCHAR(100), ISNULL(A.DealerQuota, 0), 1),
	           1,
	           LEN(CONVERT(VARCHAR(100), ISNULL(A.DealerQuota, 0), 1)) -3
	       ) DealerQuota,
	       (
	           CONVERT(INT, B.TotalScoreCurrent) - CONVERT(INT, B.TotalScoreBack1)
	       ) Grow,
	       ROW_NUMBER() OVER(
	           ORDER BY(
	               CONVERT(INT, B.TotalScoreCurrent) - CONVERT(INT, B.TotalScoreBack1)
	           ) ASC
	       ) DealerRank
	FROM   #Dealer A
	       INNER JOIN interface.RV_DealerKPI_Score_Warning B
	            ON  A.[Year] = B.[Year]
	            AND A.[Quarter] = B.[Quarter]
	            AND A.DivisionID = B.DivisionID
	            AND A.SubBUCode = B.SubBUCode
	            AND A.SAPID = B.SAPID
	            AND A.BICode = B.BICode
	WHERE  CONVERT(INT, B.TotalScoreCurrent) - CONVERT(INT, B.TotalScoreBack1) < 0
	
	--评分排行TOP
	INSERT INTO #DealerRankTop
	SELECT TOP 5 DealerId,
	       DealerName,
	       DivisionID,
	       Division,
	       SubBUCode,
	       SubBUName,
	       CONVERT(NVARCHAR(4), [Year]) + '-Q' + CONVERT(NVARCHAR(1), [Quarter]),
	       TotalScore,
	       SUBSTRING(
	           CONVERT(VARCHAR(100), ISNULL(A.DealerQuota, 0), 1),
	           1,
	           LEN(CONVERT(VARCHAR(100), ISNULL(A.DealerQuota, 0), 1)) -3
	       ) DealerQuota,
	       ROW_NUMBER() OVER(ORDER BY TotalScore DESC)
	FROM   #Dealer A
	
	SELECT *
	FROM   #DealerRankTop
	ORDER BY
	       DealerRank
	
	--评分排行BOTTOM
	INSERT INTO #DealerRankBottom
	SELECT TOP 5 DealerId,
	       DealerName,
	       DivisionID,
	       Division,
	       SubBUCode,
	       SubBUName,
	       CONVERT(NVARCHAR(4), [Year]) + '-Q' + CONVERT(NVARCHAR(1), [Quarter]),
	       TotalScore,
	       SUBSTRING(
	           CONVERT(VARCHAR(100), ISNULL(A.DealerQuota, 0), 1),
	           1,
	           LEN(CONVERT(VARCHAR(100), ISNULL(A.DealerQuota, 0), 1)) -3
	       ) DealerQuota,
	       ROW_NUMBER() OVER(ORDER BY TotalScore ASC)
	FROM   #Dealer A
	WHERE  NOT EXISTS (
	           SELECT 1
	           FROM   #DealerRankTop T
	           WHERE  A.DealerId = T.DealerId
	       )
	
	SELECT *
	FROM   #DealerRankBottom
	ORDER BY
	       DealerRank
END
GO


