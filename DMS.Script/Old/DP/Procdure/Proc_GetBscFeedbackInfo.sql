DROP PROCEDURE [DP].[Proc_GetBscFeedbackInfo]
GO


CREATE PROCEDURE [DP].[Proc_GetBscFeedbackInfo]
(
    @UserId   UNIQUEIDENTIFIER,
    @Bu       NVARCHAR(100),
    @SubBu    NVARCHAR(100),
    @Year     NVARCHAR(100),
    @Quarter  NVARCHAR(100),
    @SapCode  NVARCHAR(100)
)
AS
BEGIN
	CREATE TABLE #ResultMain
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
		TotalLevel     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ1        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ2        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ3        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalQ4        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseLevel  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ1     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ2     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ3     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseQ4     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverLevel     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ1        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ2        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ3        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverQ4        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveLevel   NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ1      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ2      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ3      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveQ4      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AlertStatus    NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PRIMARY KEY(SapCode, BuCode, SubBuCode, [Year], [Quarter])
	)
	
	CREATE TABLE #ResultCover
	(
		HospitalCode        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		HospitalName        NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		CoverLevel          NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AuthStartDate       NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		UncoverMonth        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalSys         NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		PRIMARY KEY(HospitalCode)
	)
	
	CREATE TABLE #ResultAchieve
	(
		HospitalCode        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		HospitalName        NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		AchieveLevel        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		IsKeyHospital       NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter1        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter2        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter3        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter4        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveRateQ1       NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveRateQ2       NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveRateQ3       NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveRateQ4       NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalSys         NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		PRIMARY KEY(HospitalCode)
	)
	
	DECLARE @FeedbackCode NVARCHAR(200);
	DECLARE @BscFeedStatus NVARCHAR(20);
	
	SELECT @FeedbackCode = A.FeedbackCode,
	       @BscFeedStatus = A.BscFeedStatus
	FROM   DP.BscFeedback A
	WHERE  A.Bu = @Bu
	       AND A.SubBu = @SubBu
	       AND A.[Year] = @Year
	       AND A.[Quarter] = @Quarter
	       AND A.SapCode = @SapCode
	
	INSERT INTO #ResultMain
	  (SapCode, DealerName, BuCode, BuName, SubBuCode, SubBuName, [Year], [Quarter], YearQuarter, YearQuarter3, YearQuarter2, YearQuarter1, SummaryLevel, TotalLevel, TotalQ1, TotalQ2, TotalQ3, TotalQ4, PurchaseLevel, PurchaseQ1, PurchaseQ2, PurchaseQ3, PurchaseQ4, CoverLevel, CoverQ1, CoverQ2, CoverQ3, CoverQ4, AchieveLevel, AchieveQ1, AchieveQ2, AchieveQ3, AchieveQ4, AlertStatus)
	SELECT DISTINCT Summary.SAPID,
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
	       Summary.WarningLevel,
	       Warning.TotalScoreCurrentLevel,
	       Warning.TotalScoreBack3,
	       Warning.TotalScoreBack2,
	       Warning.TotalScoreBack1,
	       Warning.TotalScoreCurrent,
	       Warning.PurchaseCurrentLevel,
	       Warning.PurchaseBack3,
	       Warning.PurchaseBack2,
	       Warning.PurchaseBack1,
	       Warning.PurchaseCurrent,
	       Warning.CoverCurrentLevel,
	       Warning.CoverBack3,
	       Warning.CoverBack2,
	       Warning.CoverBack1,
	       Warning.CoverCurrent,
	       Warning.ReachCurrentLevel,
	       Warning.ReachBack3,
	       Warning.ReachBack2,
	       Warning.ReachBack1,
	       Warning.ReachCurrent,
	       Feedback.BscFeedStatus
	FROM   DP.BscFeedback Feedback,
	       interface.RV_DealerKPI_Score_Summary Summary,
	       interface.RV_DealerKPI_Score_Warning Warning,
	       dbo.DealerMaster Dealer
	WHERE  Summary.DivisionID = Feedback.Bu
	       AND Summary.SubBUCode = Feedback.SubBu
	       AND Summary.[Year] = Feedback.[Year]
	       AND Summary.[Quarter] = Feedback.[Quarter]
	       AND Summary.SAPID = Feedback.SapCode
	       AND Summary.DivisionID = Warning.DivisionID
	       AND Summary.SubBUCode = Warning.SubBUCode
	       AND Summary.[Year] = Warning.[Year]
	       AND Summary.[Quarter] = Warning.[Quarter]
	       AND Summary.SAPID = Warning.SAPID
	       AND Summary.SAPID = Dealer.DMA_SAP_Code
	       AND Feedback.FeedbackCode = @FeedbackCode
	
	SELECT *
	FROM   #ResultMain
	
	IF (
	       @BscFeedStatus = '30'
	       AND NOT EXISTS(
	               SELECT 1
	               FROM   DP.BscFeedbackProposal
	               WHERE  FeedbackCode = @FeedbackCode
	                      AND ProposalType = 'DLR'
	                      AND ProposalRole = 'NCM'
	           )
	   )
	BEGIN
	    SELECT B.ProposalRole,
	           B.ProposalUser,
	           B.ProposalContent,
	           B.ProposalRemark,
	           CONVERT(NVARCHAR(19), B.ProposalTime, 121) ProposalTime
	    FROM   DP.BscFeedbackProposal B
	    WHERE  B.FeedbackCode = @FeedbackCode
	           AND B.ProposalType = 'DLR' 
	    UNION
	    SELECT 'NCM',
	           '',
	           B.ProposalContent,
	           '',
	           CONVERT(NVARCHAR(19), B.ProposalTime, 121) ProposalTime
	    FROM   DP.BscFeedbackProposal B
	    WHERE  B.FeedbackCode = @FeedbackCode
	           AND B.ProposalType = 'DLR'
	           AND ProposalRole = 'RSM'
	END
	ELSE
	BEGIN
	    SELECT B.ProposalRole,
	           B.ProposalUser,
	           B.ProposalContent,
	           B.ProposalRemark,
	           CONVERT(NVARCHAR(19), B.ProposalTime, 121) ProposalTime
	    FROM   DP.BscFeedbackProposal B
	    WHERE  B.FeedbackCode = @FeedbackCode
	           AND B.ProposalType = 'DLR'
	END
	
	SELECT B.ProposalRole ApproveRole,
	       B.ProposalUser ApproveUser,
	       B.ProposalContent ApproveAction,
	       B.ProposalRemark ApproveRemark,
	       CONVERT(NVARCHAR(19), B.ProposalTime, 121) ApproveTime
	FROM   DP.BscFeedbackProposal B
	WHERE  B.FeedbackCode = @FeedbackCode
	       AND B.ProposalType = 'EWF'
	ORDER BY B.ProposalTime
	
	INSERT INTO #ResultCover
	  (HospitalCode, HospitalName, CoverLevel, AuthStartDate, UncoverMonth, ProposalSys)
	SELECT DISTINCT B.HospitalCode,
	       C.HospitalName,
	       C.HCoverWarningLevel CoverLevel,
	       C.AuthStartDate,
	       C.UncoverMonth,
	       B.ProposalContent
	FROM   DP.BscFeedback A,
	       DP.BscFeedbackProposal B,
	       interface.RV_HospitalKPI_WarningLevel C
	WHERE  A.FeedbackCode = B.FeedbackCode
	       AND A.Bu = C.DivisionID
	       AND A.SubBu = C.SubBUCode
	       AND A.[Year] = C.[Year]
	       AND A.[Quarter] = C.[Quarter]
	       AND A.SapCode = C.SAPID
	       AND B.HospitalCode = C.DMSCode
	       AND B.ProposalType = 'CVR'
	       AND B.ProposalRole = 'SYS'
	       AND A.FeedbackCode = @FeedbackCode
	
	UPDATE A
	SET    A.ProposalZsmContent = B.ProposalContent,
	       A.ProposalZsmRemark = B.ProposalRemark
	FROM   #ResultCover A,
	       DP.BscFeedbackProposal B
	WHERE  A.HospitalCode = B.HospitalCode
	       AND B.ProposalType = 'CVR'
	       AND B.FeedbackCode = @FeedbackCode
	       AND B.ProposalRole = 'ZSM'
	
	UPDATE A
	SET    A.ProposalRsmContent = B.ProposalContent,
	       A.ProposalRsmRemark = B.ProposalRemark
	FROM   #ResultCover A,
	       DP.BscFeedbackProposal B
	WHERE  A.HospitalCode = B.HospitalCode
	       AND B.ProposalType = 'CVR'
	       AND B.FeedbackCode = @FeedbackCode
	       AND B.ProposalRole = 'RSM'
	
	IF (
	       @BscFeedStatus = '30'
	       AND NOT EXISTS(
	               SELECT 1
	               FROM   DP.BscFeedbackProposal
	               WHERE  FeedbackCode = @FeedbackCode
	                      AND ProposalType = 'CVR'
	                      AND ProposalRole = 'NCM'
	           )
	   )
	BEGIN
	    UPDATE A
	    SET    A.ProposalNcmContent = A.ProposalRsmContent,
	           A.ProposalNcmRemark = ''
	    FROM   #ResultCover A
	END
	ELSE
	BEGIN
	    UPDATE A
	    SET    A.ProposalNcmContent = B.ProposalContent,
	           A.ProposalNcmRemark = B.ProposalRemark
	    FROM   #ResultCover A,
	           DP.BscFeedbackProposal B
	    WHERE  A.HospitalCode = B.HospitalCode
	           AND B.ProposalType = 'CVR'
	           AND B.FeedbackCode = @FeedbackCode
	           AND B.ProposalRole = 'NCM'
	END
	
	SELECT *
	FROM   #ResultCover
	ORDER BY HospitalName
	
	INSERT INTO #ResultAchieve
	  (HospitalCode, HospitalName, AchieveLevel, IsKeyHospital, YearQuarter1, YearQuarter2, YearQuarter3, YearQuarter4, AchieveRateQ1, AchieveRateQ2, AchieveRateQ3, AchieveRateQ4, ProposalSys)
	SELECT DISTINCT B.HospitalCode,
	       C.HospitalName,
	       C.HAchieveWarningLevel AchieveLevel,
	       CASE 
	            WHEN C.KeyHospitalFlag = 1 THEN 'ÊÇ'
	            ELSE '·ñ'
	       END,
	       DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], -3),
	       DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], -2),
	       DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], -1),
	       CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]),
	       C.SalesRateBack3,
	       C.SalesRateBack2,
	       C.SalesRateBack1,
	       C.SalesRateCurrent,
	       B.ProposalContent
	FROM   DP.BscFeedback A,
	       DP.BscFeedbackProposal B,
	       interface.RV_HospitalKPI_WarningLevel C
	WHERE  A.FeedbackCode = B.FeedbackCode
	       AND A.Bu = C.DivisionID
	       AND A.SubBu = C.SubBUCode
	       AND A.[Year] = C.[Year]
	       AND A.[Quarter] = C.[Quarter]
	       AND A.SapCode = C.SAPID
	       AND B.HospitalCode = C.DMSCode
	       AND B.ProposalType = 'ACH'
	       AND B.ProposalRole = 'SYS'
	       AND A.FeedbackCode = @FeedbackCode
	
	UPDATE A
	SET    A.ProposalZsmContent = B.ProposalContent,
	       A.ProposalZsmRemark = B.ProposalRemark
	FROM   #ResultAchieve A,
	       DP.BscFeedbackProposal B
	WHERE  A.HospitalCode = B.HospitalCode
	       AND B.ProposalType = 'ACH'
	       AND B.FeedbackCode = @FeedbackCode
	       AND B.ProposalRole = 'ZSM'
	
	UPDATE A
	SET    A.ProposalRsmContent = B.ProposalContent,
	       A.ProposalRsmRemark = B.ProposalRemark
	FROM   #ResultAchieve A,
	       DP.BscFeedbackProposal B
	WHERE  A.HospitalCode = B.HospitalCode
	       AND B.ProposalType = 'ACH'
	       AND B.FeedbackCode = @FeedbackCode
	       AND B.ProposalRole = 'RSM'
	
	IF (
	       @BscFeedStatus = '30'
	       AND NOT EXISTS(
	               SELECT 1
	               FROM   DP.BscFeedbackProposal
	               WHERE  FeedbackCode = @FeedbackCode
	                      AND ProposalType = 'ACH'
	                      AND ProposalRole = 'NCM'
	           )
	   )
	BEGIN
	    UPDATE A
	    SET    A.ProposalNcmContent = A.ProposalRsmContent,
	           A.ProposalNcmRemark = ''
	    FROM   #ResultAchieve A
	END
	ELSE
	BEGIN
	    UPDATE A
	    SET    A.ProposalNcmContent = B.ProposalContent,
	           A.ProposalNcmRemark = B.ProposalRemark
	    FROM   #ResultAchieve A,
	           DP.BscFeedbackProposal B
	    WHERE  A.HospitalCode = B.HospitalCode
	           AND B.ProposalType = 'ACH'
	           AND B.FeedbackCode = @FeedbackCode
	           AND B.ProposalRole = 'NCM'
	END
	
	SELECT *
	FROM   #ResultAchieve
	ORDER BY HospitalName
	
	SELECT FeedbackUser,
	       FeedbackContent,
	       CONVERT(NVARCHAR(19), FeedbackTime, 121) FeedbackTime
	FROM   DP.DealerFeedback
	WHERE  [Year] = @Year
	       AND [Quarter] = @Quarter
	       AND Bu = @Bu
	       AND SubBu = @SubBu
	       AND SapCode = @SapCode
END
GO


