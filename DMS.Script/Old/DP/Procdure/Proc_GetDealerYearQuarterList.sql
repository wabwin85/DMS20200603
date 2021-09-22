DROP PROCEDURE [DP].[Proc_GetDealerYearQuarterList]
GO


CREATE PROCEDURE [DP].[Proc_GetDealerYearQuarterList]
(
    @UserAccount     NVARCHAR(100),
    @DealerId        UNIQUEIDENTIFIER,
    @IsNeedFeedback  BIT
)
AS
BEGIN
	DECLARE @StartQuarter NVARCHAR(7);
	SELECT @StartQuarter = ParamValue
	FROM   DP.DPParam
	WHERE  ParamType = 'Feedback'
	       AND ParamKey = 'StartQuarter'
	
	SELECT DISTINCT CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]) [Quarter]
	FROM   interface.RV_DealerKPI_Score_Summary A,
	       dbo.DealerMaster B
	WHERE  A.SAPID = B.DMA_SAP_Code
	       AND CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]) >= @StartQuarter
	       AND EXISTS (
	               SELECT 1
	               FROM   DP.UserDealerMapping T
	               WHERE  T.Division = A.DivisionID
	                      AND T.SubBu = A.SubBUCode
	                      AND T.SapCode = A.SAPID
	                      AND T.UserAccount = @UserAccount
	           )
	       AND B.DMA_ID = @DealerId
	       AND (
	               @IsNeedFeedback = 0
	               OR EXISTS (
	                      SELECT 1
	                      FROM   DP.BscFeedback T
	                      WHERE  A.[Year] = T.[Year]
	                             AND A.[Quarter] = T.[Quarter]
	                             AND A.DivisionID = T.Bu
	                             AND A.SubBUCode = T.SubBu
	                             AND A.SAPID = T.SapCode
	                  )
	           )
	ORDER BY CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]) DESC
END
GO


