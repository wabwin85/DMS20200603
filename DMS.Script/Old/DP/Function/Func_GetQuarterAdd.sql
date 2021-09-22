DROP FUNCTION [DP].[Func_GetQuarterAdd]
GO


CREATE FUNCTION [DP].[Func_GetQuarterAdd]
(
	@Year     INT,
	@Quarter  INT,
	@Diff     INT
)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @Rtn NVARCHAR(10);
	DECLARE @OldTime NVARCHAR(10);
	DECLARE @NewTime DATETIME;
	SET @OldTime = CONVERT(NVARCHAR(4), @Year);
	
	IF @Quarter = 1
	BEGIN
	    SET @OldTime += '-01-01';
	END
	ELSE 
	IF @Quarter = 2
	BEGIN
	    SET @OldTime += '-04-01';
	END
	ELSE 
	IF @Quarter = 3
	BEGIN
	    SET @OldTime += '-07-01';
	END
	ELSE 
	IF @Quarter = 4
	BEGIN
	    SET @OldTime += '-10-01';
	END
	
	SET @NewTime = DATEADD(QQ, @Diff, CONVERT(DATETIME, @OldTime, 121))
	
	SET @Rtn = CONVERT(NVARCHAR(4), DATEPART(YEAR, @NewTime)) + '-Q' + CONVERT(NVARCHAR(1), DATEPART(QQ, @NewTime));
	
	RETURN @Rtn
END

GO


