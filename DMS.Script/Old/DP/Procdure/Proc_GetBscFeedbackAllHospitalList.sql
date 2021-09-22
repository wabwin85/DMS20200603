DROP PROCEDURE [DP].[Proc_GetBscFeedbackAllHospitalList]
GO


CREATE PROCEDURE [DP].[Proc_GetBscFeedbackAllHospitalList]
(
    @UserAccount           NVARCHAR(100),
    @Bu                    NVARCHAR(100),
    @SubBu                 NVARCHAR(100),
    @Area                  NVARCHAR(100),
    @YearQuarter           NVARCHAR(100),
    @Lp                    NVARCHAR(100),
    @KeyWord               NVARCHAR(100),
    @KeyHospital           NVARCHAR(100)
)
AS
BEGIN
	SET @Bu = LTRIM(RTRIM(ISNULL(@Bu, '')));
	SET @SubBu = LTRIM(RTRIM(ISNULL(@SubBu, '')));
	SET @Area = LTRIM(RTRIM(ISNULL(@Area, '')));
	SET @YearQuarter = LTRIM(RTRIM(ISNULL(@YearQuarter, '')));
	SET @Lp = LTRIM(RTRIM(ISNULL(@Lp, '')));
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
		HospitalCode          NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		HospitalName          NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		MarketType            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		HospitalQuota         MONEY,
		AuthStartDate         NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverLevel            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		UncoverMonth          NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveLevel          NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ1             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ2             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ3             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ4             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		BscFeedbackStatus     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		DealerFeedbackStatus  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PRIMARY KEY(
		    SapCode,
		    BuCode,
		    SubBuCode,
		    [Year],
		    [Quarter],
		    HospitalCode
		)
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
	    HospitalCode,
	    HospitalName,
	    MarketType,
	    HospitalQuota,
	    AuthStartDate,
	    CoverLevel,
	    UncoverMonth,
	    AchieveLevel,
	    AchieveQ1,
	    AchieveQ2,
	    AchieveQ3,
	    AchieveQ4,
	    BscFeedbackStatus,
	    DealerFeedbackStatus
	  )
	SELECT DISTINCT Warning.SAPID,
	       Dealer.DMA_ID,
	       Dealer.DMA_ChineseShortName,
	       Warning.DivisionID,
	       Warning.Division,
	       Warning.SubBUCode,
	       Warning.SubBUName,
	       Warning.[Year],
	       Warning.[Quarter],
	       CONVERT(NVARCHAR(4), Warning.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Warning.[Quarter]),
	       DP.Func_GetQuarterAdd(Warning.[Year], Warning.[Quarter], -1),
	       DP.Func_GetQuarterAdd(Warning.[Year], Warning.[Quarter], -2),
	       DP.Func_GetQuarterAdd(Warning.[Year], Warning.[Quarter], -3),
	       Warning.DMSCode,
	       Warning.HospitalName,
	       Warning.MarketType,
	       Warning.HospitalQuota,
	       Warning.AuthStartDate,
	       Warning.HCoverWarningLevel,
	       Warning.UncoverMonth,
	       Warning.HAchieveWarningLevel,
	       ISNULL(Warning.SalesRateBack3, ''),
	       ISNULL(Warning.SalesRateBack2, ''),
	       ISNULL(Warning.SalesRateBack1, ''),
	       ISNULL(Warning.SalesRateCurrent, ''),
	       '',
	       ''
	FROM   interface.RV_HospitalKPI_WarningLevel Warning
	       INNER JOIN dbo.DealerMaster Dealer
	            ON  Warning.SAPID = Dealer.DMA_SAP_Code
	       INNER JOIN DP.UserDealerMapping Mapping
	            ON  Warning.DivisionID = Mapping.Division
	                AND Warning.SubBUCode = Mapping.SubBu
	                AND Warning.SAPID = Mapping.SapCode
	WHERE  Mapping.UserAccount = @UserAccount
	       AND (@Bu = '' OR Warning.DivisionID = @Bu)
	       AND (@SubBu = '' OR Warning.SubBUCode = @SubBu)
	       AND (@Area = '' OR ISNULL(Warning.AreaCode, 'NULL') = @Area)
	       AND (
	               @Lp = ''
	               OR CONVERT(NVARCHAR(100), Dealer.DMA_Parent_DMA_ID) = @Lp
	           )
	       AND (
	               @YearQuarter = ''
	               OR (
	                      Warning.[Year] = SUBSTRING(@YearQuarter, 1, 4)
	                      AND Warning.[Quarter] = SUBSTRING(@YearQuarter, 7, 1)
	                  )
	           )
	       AND (
	               @KeyWord = ''
	               OR Dealer.DMA_ChineseShortName LIKE '%' + @KeyWord + '%'
	               OR Warning.DMSCode LIKE '%' + @KeyWord + '%'
	               OR Warning.HospitalName LIKE '%' + @KeyWord + '%'
	           )
	       AND (
	               @KeyHospital = ''
	               OR Warning.KeyHospitalFlag = @KeyHospital
	           )
	
	SELECT *
	FROM   #Result
	ORDER BY
	       DealerName,
	       HospitalName,
	       BuName,
	       SubBuName,
	       YearQuarter DESC
END
GO


