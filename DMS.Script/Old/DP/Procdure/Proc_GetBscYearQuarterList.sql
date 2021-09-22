DROP PROCEDURE [DP].[Proc_GetBscYearQuarterList]
GO


CREATE PROCEDURE [DP].[Proc_GetBscYearQuarterList]
(@UserAccount NVARCHAR(100), @IsNeedFeedback BIT)
AS
BEGIN
	DECLARE @StartQuarter NVARCHAR(7);
	SELECT @StartQuarter = ParamValue
	FROM   DP.DPParam
	WHERE  ParamType = 'Feedback'
	       AND ParamKey = 'StartQuarter'
	
	SELECT DISTINCT CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]) [Quarter]
	FROM   interface.RV_DealerKPI_Score_Summary A
	       INNER JOIN DP.UserDealerMapping B
	            ON  A.DivisionID = B.Division
	            AND A.SubBUCode = B.SubBu
	            AND A.SAPID = B.SapCode
	WHERE  CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]) >= @StartQuarter
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
	       AND B.UserAccount = @UserAccount
	ORDER BY CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]) DESC
END
GO


