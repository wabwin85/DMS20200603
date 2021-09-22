DROP PROCEDURE [DP].[Proc_GetBscAreaList]
GO


CREATE PROCEDURE [DP].[Proc_GetBscAreaList]
(
    @UserAccount     NVARCHAR(100),
    @YearQuarter     NVARCHAR(100),
    @Bu              NVARCHAR(100),
    @SubBu           NVARCHAR(100),
    @IsNeedFeedback  BIT
)
AS
BEGIN
	DECLARE @StartQuarter NVARCHAR(7);
	SELECT @StartQuarter = ParamValue
	FROM   DP.DPParam
	WHERE  ParamType = 'Feedback'
	       AND ParamKey = 'StartQuarter'
	
	SELECT DISTINCT CASE WHEN A.AreaCode IS NULL THEN 'NULL' ELSE A.AreaCode END AreaCode,
	       CASE WHEN A.AreaName IS NULL THEN 'Пе' ELSE A.AreaName END AreaName
	FROM   interface.RV_DealerKPI_Score_Summary A
	       INNER JOIN DP.UserDealerMapping B
	            ON  A.DivisionID = B.Division
	            AND A.SubBUCode = B.SubBu
	            AND A.SAPID = B.SapCode
	WHERE  CONVERT(NVARCHAR(4), A.[Year]) + '-Q' + CONVERT(NVARCHAR(1), A.[Quarter]) >= @StartQuarter
	       AND CONVERT(NVARCHAR(4), A.[Year]) = SUBSTRING(@YearQuarter, 1, 4)
	       AND CONVERT(NVARCHAR(1), A.[Quarter]) = SUBSTRING(@YearQuarter, 7, 1)
	       AND A.DivisionID = @Bu
	       AND A.SubBUCode = @SubBu
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
	ORDER BY CASE WHEN A.AreaName IS NULL THEN 'Пе' ELSE A.AreaName END
END
GO


