DROP PROCEDURE [DP].[Proc_ExportBscFeedback]
GO


CREATE PROCEDURE [DP].[Proc_ExportBscFeedback]
(
    @UserAccount           NVARCHAR(100),
    @Bu                    NVARCHAR(100),
    @SubBu                 NVARCHAR(100),
    @Area                  NVARCHAR(100),
    @YearQuarter           NVARCHAR(100),
    @Lp                    NVARCHAR(100),
    @AlertType             NVARCHAR(100),
    @BscFeedbackStatus     NVARCHAR(100),
    @DealerFeedbackStatus  NVARCHAR(100),
    @KeyWord               NVARCHAR(100),
    @DealerLevel           NVARCHAR(100),
    @KeyHospital           NVARCHAR(100)
)
AS
BEGIN
	CREATE TABLE #Result
	(
		[Year]                 NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		[Quarter]              NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		BuCode                 NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SubBuCode              NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SapCode                NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		FeedbackCode           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter            NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		Bu                     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SubBu                  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		DealerName             NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		DealerLevel            NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		SummaryLevel           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalScoreLevel        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		TotalScoreDesc         NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		PurchaseScoreLevel     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		PurchaseScoreDesc      NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		CoverScoreLevel        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		CoverScoreDesc         NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		AchieveScoreLevel      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveScoreDesc       NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		BscFeedbackStatus      NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		DealerFeedbackStatus   NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalSysContent     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmContent     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmUser        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmRemark      NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmContent     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmUser        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmRemark      NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmContent     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmUser        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmRemark      NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		DealerFeedbackUser     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		DealerFeedbackContent  NVARCHAR(500) COLLATE Chinese_PRC_CI_AS
		PRIMARY KEY(SapCode, BuCode, SubBuCode, [Year], [Quarter])
	)
	
	CREATE TABLE #ResultCover
	(
		[Year]              NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		[Quarter]           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		BuCode              NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SubBuCode           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SapCode             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		HospitalCode        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		FeedbackCode        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter         NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		Bu                  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SubBu               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		DealerName          NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		HospitalName        NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		KeyHospital         NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		WarningLevel        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AuthStartDate       NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		UncoverMonth        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		BscFeedbackStatus   NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalSysContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmUser     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmUser     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmUser     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS
	)
	
	CREATE TABLE #ResultAchieve
	(
		[Year]              NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		[Quarter]           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		BuCode              NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SubBuCode           NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SapCode             NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		HospitalCode        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		FeedbackCode        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		YearQuarter         NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		Bu                  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		SubBu               NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		DealerName          NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		HospitalName        NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		KeyHospital         NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		WarningLevel        NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		AchieveDesc         NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		BscFeedbackStatus   NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalSysContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmUser     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalZsmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmUser     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalRsmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmContent  NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmUser     NVARCHAR(100) COLLATE Chinese_PRC_CI_AS,
		ProposalNcmRemark   NVARCHAR(500) COLLATE Chinese_PRC_CI_AS
	)
	
	INSERT INTO #Result
	  ([Year], [Quarter], BuCode, SubBuCode, SapCode, FeedbackCode, YearQuarter, Bu, SubBu, DealerName, DealerLevel, SummaryLevel, TotalScoreLevel, TotalScoreDesc, PurchaseScoreLevel, 
	   PurchaseScoreDesc, CoverScoreLevel, CoverScoreDesc, AchieveScoreLevel, AchieveScoreDesc, BscFeedbackStatus, DealerFeedbackStatus, DealerFeedbackUser, DealerFeedbackContent)
	SELECT DISTINCT 
	       Summary.[Year],
	       Summary.[Quarter],
	       Summary.DivisionID,
	       Summary.SubBUCode,
	       Summary.SAPID,
	       Feedback.FeedbackCode,
	       CONVERT(NVARCHAR(4), Summary.[Year]) + '-Q' + CONVERT(NVARCHAR(1), Summary.[Quarter]),
	       Summary.Division,
	       Summary.SubBUName,
	       Dealer.DMA_ChineseShortName,
	       Warning.DealerLevel,
	       dbo.Func_GetCode('CONST_DP_KpiWarningLevel', Summary.WarningLevel),
	       dbo.Func_GetCode('CONST_DP_KpiWarningLevel', Warning.TotalScoreCurrentLevel),
	       DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3) + ':' + ISNULL(Warning.TotalScoreBack3, '') + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2) + ':' + ISNULL(Warning.TotalScoreBack2, '') 
	       + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1) + ':' + ISNULL(Warning.TotalScoreBack1, '') + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0) + ':' +
	       ISNULL(Warning.TotalScoreCurrent, '') + ' ',
	       dbo.Func_GetCode('CONST_DP_KpiWarningLevel', Warning.PurchaseCurrentLevel),
	       DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3) + ':' + ISNULL(Warning.PurchaseBack3, '') + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2) + ':' + ISNULL(Warning.PurchaseBack2, '') 
	       + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1) + ':' + ISNULL(Warning.PurchaseBack1, '') + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0) + ':' +
	       ISNULL(Warning.PurchaseCurrent, '') + ' ',
	       dbo.Func_GetCode('CONST_DP_KpiWarningLevel', Warning.CoverCurrentLevel),
	       DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3) + ':' + ISNULL(Warning.CoverBack3, '') + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2) + ':' + ISNULL(Warning.CoverBack2, '') 
	       + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1) + ':' + ISNULL(Warning.CoverBack1, '') + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0) + ':' +
	       ISNULL(Warning.CoverCurrent, '') + ' ',
	       dbo.Func_GetCode('CONST_DP_KpiWarningLevel', Warning.ReachCurrentLevel),
	       DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -3) + ':' + ISNULL(Warning.ReachBack3, '') + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -2) + ':' + ISNULL(Warning.ReachBack2, '') 
	       + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], -1) + ':' + ISNULL(Warning.ReachBack1, '') + ' ' + DP.Func_GetQuarterAdd(Summary.[Year], Summary.[Quarter], 0) + ':' +
	       ISNULL(Warning.ReachCurrent, '') + ' ',
	       dbo.Func_GetCode('CONST_DP_BscFeedbackStatus', Feedback.BscFeedStatus),
	       dbo.Func_GetCode(
	           'CONST_DP_DealerFeedbackStatus',
	           CASE 
	                WHEN DealerFeedback.FeedbackId IS NULL THEN '00'
	                ELSE '10'
	           END
	       ),
	       DealerFeedback.FeedbackUser,
	       DealerFeedback.FeedbackContent
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
	       LEFT JOIN dp.DealerFeedback DealerFeedback
	            ON  Summary.DivisionID = DealerFeedback.Bu
	            AND Summary.SubBUCode = DealerFeedback.SubBu
	            AND Summary.[Year] = DealerFeedback.[Year]
	            AND Summary.[Quarter] = DealerFeedback.[Quarter]
	            AND Summary.SAPID = DealerFeedback.SapCode
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
	               ISNULL(@BscFeedbackStatus, '') = ''
	               OR Feedback.BscFeedStatus = @BscFeedbackStatus
	           )
	       AND (
	               ISNULL(@DealerFeedbackStatus, '') = ''
	               OR CASE 
	                       WHEN DealerFeedback.FeedbackId IS NULL THEN '00'
	                       ELSE '10'
	                  END = @DealerFeedbackStatus
	           )
	       AND (
	               ISNULL(@KeyWord, '') = ''
	               OR (
	                      @AlertType = 'Dealer'
	                      AND Dealer.DMA_ChineseShortName LIKE '%' + @KeyWord + '%'
	                  )
	               OR (
	                      @AlertType = 'Hospital'
	                      AND EXISTS (
	                              SELECT 1
	                              FROM   interface.RV_HospitalKPI_WarningLevel Hospital,
	                                     DP.BscFeedbackProposal FeedbackProposal
	                              WHERE  Summary.[Year] = Hospital.[Year]
	                                     AND Summary.[Quarter] = Hospital.[Quarter]
	                                     AND Summary.DivisionID = Hospital.DivisionID
	                                     AND Summary.SubBUCode = Hospital.SubBUCode
	                                     AND Summary.SAPID = Hospital.SAPID
	                                     AND Hospital.DMSCode = FeedbackProposal.HospitalCode
	                                     AND Feedback.FeedbackCode = FeedbackProposal.FeedbackCode
	                                     AND (
	                                             Hospital.DMSCode LIKE '%' + @KeyWord + '%'
	                                             OR Hospital.HospitalName LIKE '%' + @KeyWord + '%'
	                                         )
	                          )
	                  )
	           )
	       AND (
	               ISNULL(@DealerLevel, '') = ''
	               OR (
	                      @AlertType = 'Dealer'
	                      AND Warning.DealerLevel = @DealerLevel
	                  )
	           )
	       AND (
	               ISNULL(@KeyHospital, '') = ''
	               OR (
	                      @AlertType = 'Hospital'
	                      AND EXISTS (
	                              SELECT 1
	                              FROM   interface.RV_HospitalKPI_WarningLevel Hospital,
	                                     DP.BscFeedbackProposal FeedbackProposal
	                              WHERE  Summary.[Year] = Hospital.[Year]
	                                     AND Summary.[Quarter] = Hospital.[Quarter]
	                                     AND Summary.DivisionID = Hospital.DivisionID
	                                     AND Summary.SubBUCode = Hospital.SubBUCode
	                                     AND Summary.SAPID = Hospital.SAPID
	                                     AND Hospital.DMSCode = FeedbackProposal.HospitalCode
	                                     AND Feedback.FeedbackCode = FeedbackProposal.FeedbackCode
	                                     AND Hospital.KeyHospitalFlag = @KeyHospital
	                          )
	                  )
	           )
	
	UPDATE A
	SET    A.ProposalSysContent = ISNULL(C.ProposalName, B.ProposalContent)
	FROM   #Result A
	       LEFT JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	            AND B.ProposalType = 'DLR'
	            AND B.ProposalRole = 'SYS'
	       LEFT JOIN interface.RV_KPI_Proposal C
	            ON  B.ProposalContent = C.ProposalCode
	            AND C.ProposalType = 'Dealer'
	
	UPDATE A
	SET    A.ProposalZsmContent = ISNULL(C.ProposalName, B.ProposalContent),
	       A.ProposalZsmUser = B.ProposalUser,
	       A.ProposalZsmRemark = B.ProposalRemark
	FROM   #Result A
	       LEFT JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	            AND B.ProposalType = 'DLR'
	            AND B.ProposalRole = 'ZSM'
	       LEFT JOIN interface.RV_KPI_Proposal C
	            ON  B.ProposalContent = C.ProposalCode
	            AND C.ProposalType = 'Dealer'
	
	UPDATE A
	SET    A.ProposalRsmContent = ISNULL(C.ProposalName, B.ProposalContent),
	       A.ProposalRsmUser = B.ProposalUser,
	       A.ProposalRsmRemark = B.ProposalRemark
	FROM   #Result A
	       LEFT JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	            AND B.ProposalType = 'DLR'
	            AND B.ProposalRole = 'RSM'
	       LEFT JOIN interface.RV_KPI_Proposal C
	            ON  B.ProposalContent = C.ProposalCode
	            AND C.ProposalType = 'Dealer'
	
	UPDATE A
	SET    A.ProposalNcmContent = ISNULL(C.ProposalName, B.ProposalContent),
	       A.ProposalNcmUser = B.ProposalUser,
	       A.ProposalNcmRemark = B.ProposalRemark
	FROM   #Result A
	       LEFT JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	            AND B.ProposalType = 'DLR'
	            AND B.ProposalRole = 'NCM'
	       LEFT JOIN interface.RV_KPI_Proposal C
	            ON  B.ProposalContent = C.ProposalCode
	            AND C.ProposalType = 'Dealer'
	
	SELECT *
	FROM   #Result
	ORDER BY
	       YearQuarter,
	       Bu,
	       SubBu,
	       DealerName DESC
	
	INSERT INTO #ResultCover
	  ([Year], [Quarter], BuCode, SubBuCode, SapCode, HospitalCode, FeedbackCode, YearQuarter, Bu, SubBu, DealerName, HospitalName, KeyHospital, WarningLevel, AuthStartDate, UncoverMonth, 
	   BscFeedbackStatus, ProposalSysContent)
	SELECT DISTINCT A.[Year],
	       A.[Quarter],
	       A.BuCode,
	       A.SubBuCode,
	       A.SapCode,
	       B.HospitalCode,
	       A.FeedbackCode,
	       A.YearQuarter,
	       A.Bu,
	       A.SubBu,
	       A.DealerName,
	       C.HospitalName,
	       CASE 
	            WHEN C.KeyHospitalFlag = 1 THEN 'ÊÇ'
	            ELSE '·ñ'
	       END,
	       dbo.Func_GetCode('CONST_DP_KpiWarningLevel', C.HCoverWarningLevel),
	       C.AuthStartDate,
	       C.UncoverMonth,
	       A.BscFeedbackStatus,
	       ISNULL(D.ProposalName, B.ProposalContent)
	FROM   #Result A
	       INNER JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	       INNER JOIN interface.RV_HospitalKPI_WarningLevel C
	            ON  A.[Year] = C.[Year]
	            AND A.[Quarter] = C.[Quarter]
	            AND A.BuCode = C.DivisionID
	            AND A.SubBuCode = C.SubBUCode
	            AND A.SapCode = C.SAPID
	            AND B.HospitalCode = C.DMSCode
	       LEFT JOIN interface.RV_KPI_Proposal D
	            ON  B.ProposalContent = D.ProposalCode
	            AND D.ProposalType = 'Hospital'
	WHERE  B.ProposalType = 'CVR'
	       AND B.ProposalRole = 'SYS'
	       AND (
	               @AlertType = 'Dealer'
	               OR (
	                      @AlertType = 'Hospital'
	                      AND (
	                              ISNULL(@KeyHospital, '') = ''
	                              OR C.KeyHospitalFlag = @KeyHospital
	                          )
	                  )
	           )
	
	UPDATE A
	SET    A.ProposalZsmContent = ISNULL(C.ProposalName, B.ProposalContent),
	       A.ProposalZsmUser = B.ProposalUser,
	       A.ProposalZsmRemark = B.ProposalRemark
	FROM   #ResultCover A
	       LEFT JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	            AND B.ProposalType = 'CVR'
	            AND B.ProposalRole = 'ZSM'
	            AND A.HospitalCode = B.HospitalCode
	       LEFT JOIN interface.RV_KPI_Proposal C
	            ON  B.ProposalContent = C.ProposalCode
	            AND C.ProposalType = 'Hospital'
	
	UPDATE A
	SET    A.ProposalRsmContent = ISNULL(C.ProposalName, B.ProposalContent),
	       A.ProposalRsmUser = B.ProposalUser,
	       A.ProposalRsmRemark = B.ProposalRemark
	FROM   #ResultCover A
	       LEFT JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	            AND B.ProposalType = 'CVR'
	            AND B.ProposalRole = 'RSM'
	            AND A.HospitalCode = B.HospitalCode
	       LEFT JOIN interface.RV_KPI_Proposal C
	            ON  B.ProposalContent = C.ProposalCode
	            AND C.ProposalType = 'Hospital'
	
	UPDATE A
	SET    A.ProposalNcmContent = ISNULL(C.ProposalName, B.ProposalContent),
	       A.ProposalNcmUser = B.ProposalUser,
	       A.ProposalNcmRemark = B.ProposalRemark
	FROM   #ResultCover A
	       LEFT JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	            AND B.ProposalType = 'CVR'
	            AND B.ProposalRole = 'NCM'
	            AND A.HospitalCode = B.HospitalCode
	       LEFT JOIN interface.RV_KPI_Proposal C
	            ON  B.ProposalContent = C.ProposalCode
	            AND C.ProposalType = 'Hospital'
	
	SELECT *
	FROM   #ResultCover
	
	INSERT INTO #ResultAchieve
	  ([Year], [Quarter], BuCode, SubBuCode, SapCode, HospitalCode, FeedbackCode, YearQuarter, Bu, SubBu, DealerName, HospitalName, KeyHospital, WarningLevel, AchieveDesc, BscFeedbackStatus, 
	   ProposalSysContent)
	SELECT DISTINCT A.[Year],
	       A.[Quarter],
	       A.BuCode,
	       A.SubBuCode,
	       A.SapCode,
	       B.HospitalCode,
	       A.FeedbackCode,
	       A.YearQuarter,
	       A.Bu,
	       A.SubBu,
	       A.DealerName,
	       C.HospitalName,
	       CASE 
	            WHEN C.KeyHospitalFlag = 1 THEN 'ÊÇ'
	            ELSE '·ñ'
	       END,
	       dbo.Func_GetCode('CONST_DP_KpiWarningLevel', C.HAchieveWarningLevel),
	       DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], -3) + ':' + ISNULL(C.SalesRateBack3, '') + ' ' + DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], -2) + ':' + ISNULL(C.SalesRateBack2, '') + ' ' +
	       DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], -1) + ':' + ISNULL(C.SalesRateBack1, '') + ' ' + DP.Func_GetQuarterAdd(A.[Year], A.[Quarter], 0) + ':' + ISNULL(C.SalesRateCurrent, '') + ' ',
	       A.BscFeedbackStatus,
	       ISNULL(D.ProposalName, B.ProposalContent)
	FROM   #Result A
	       INNER JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	       INNER JOIN interface.RV_HospitalKPI_WarningLevel C
	            ON  A.[Year] = C.[Year]
	            AND A.[Quarter] = C.[Quarter]
	            AND A.BuCode = C.DivisionID
	            AND A.SubBuCode = C.SubBUCode
	            AND A.SapCode = C.SAPID
	            AND B.HospitalCode = C.DMSCode
	       LEFT JOIN interface.RV_KPI_Proposal D
	            ON  B.ProposalContent = D.ProposalCode
	            AND D.ProposalType = 'Hospital'
	WHERE  B.ProposalType = 'ACH'
	       AND B.ProposalRole = 'SYS'
	       AND (
	               @AlertType = 'Dealer'
	               OR (
	                      @AlertType = 'Hospital'
	                      AND (
	                              ISNULL(@KeyHospital, '') = ''
	                              OR C.KeyHospitalFlag = @KeyHospital
	                          )
	                  )
	           )
	
	UPDATE A
	SET    A.ProposalZsmContent = ISNULL(C.ProposalName, B.ProposalContent),
	       A.ProposalZsmUser = B.ProposalUser,
	       A.ProposalZsmRemark = B.ProposalRemark
	FROM   #ResultAchieve A
	       LEFT JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	            AND B.ProposalType = 'ACH'
	            AND B.ProposalRole = 'ZSM'
	            AND A.HospitalCode = B.HospitalCode
	       LEFT JOIN interface.RV_KPI_Proposal C
	            ON  B.ProposalContent = C.ProposalCode
	            AND C.ProposalType = 'Hospital'
	
	UPDATE A
	SET    A.ProposalRsmContent = ISNULL(C.ProposalName, B.ProposalContent),
	       A.ProposalRsmUser = B.ProposalUser,
	       A.ProposalRsmRemark = B.ProposalRemark
	FROM   #ResultAchieve A
	       LEFT JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	            AND B.ProposalType = 'ACH'
	            AND B.ProposalRole = 'RSM'
	            AND A.HospitalCode = B.HospitalCode
	       LEFT JOIN interface.RV_KPI_Proposal C
	            ON  B.ProposalContent = C.ProposalCode
	            AND C.ProposalType = 'Hospital'
	
	UPDATE A
	SET    A.ProposalNcmContent = ISNULL(C.ProposalName, B.ProposalContent),
	       A.ProposalNcmUser = B.ProposalUser,
	       A.ProposalNcmRemark = B.ProposalRemark
	FROM   #ResultAchieve A
	       LEFT JOIN DP.BscFeedbackProposal B
	            ON  A.FeedbackCode = B.FeedbackCode
	            AND B.ProposalType = 'ACH'
	            AND B.ProposalRole = 'NCM'
	            AND A.HospitalCode = B.HospitalCode
	       LEFT JOIN interface.RV_KPI_Proposal C
	            ON  B.ProposalContent = C.ProposalCode
	            AND C.ProposalType = 'Hospital'
	
	SELECT *
	FROM   #ResultAchieve
END
GO


