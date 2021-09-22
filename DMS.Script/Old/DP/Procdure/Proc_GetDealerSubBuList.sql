DROP PROCEDURE [DP].[Proc_GetDealerSubBuList]
GO


CREATE PROCEDURE [DP].[Proc_GetDealerSubBuList]
(
    @UserAccount     NVARCHAR(100),
    @DealerId        UNIQUEIDENTIFIER,
    @YearQuarter     NVARCHAR(100),
    @Bu              NVARCHAR(100),
    @IsNeedFeedback  BIT
)
AS
BEGIN
	DECLARE @StartQuarter NVARCHAR(7);
	SELECT @StartQuarter = ParamValue
	FROM   DP.DPParam
	WHERE  ParamType = 'Feedback'
	       AND ParamKey = 'StartQuarter'
	       
	SELECT DISTINCT A.SubBUCode SubBuCode,
	       A.SubBUName SubBuName
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
	       AND SUBSTRING(@YearQuarter, 1, 4) = CONVERT(NVARCHAR(4), A.[Year])
	       AND SUBSTRING(@YearQuarter, 7, 1) = CONVERT(NVARCHAR(1), A.[Quarter])
	       AND A.DivisionID = @Bu
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
	ORDER BY A.SubBUName
END
GO


