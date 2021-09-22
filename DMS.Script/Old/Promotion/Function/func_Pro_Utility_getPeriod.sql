DROP FUNCTION [Promotion].[func_Pro_Utility_getPeriod]
GO

CREATE FUNCTION [Promotion].[func_Pro_Utility_getPeriod](
	@Period NVARCHAR(5),	--周期（季度、月度）
	@Type NVARCHAR(10),		--CURRENT,NEXT,PREVIOUS
	@Value NVARCHAR(7)		--YYYYQX,YYYYMM
	)
RETURNS NVARCHAR(7)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(7)
	DECLARE @iValue NVARCHAR(7)
	DECLARE @dValue DATETIME
	
	set @iValue = @Value 
	
	--STEP1:如果@Value是季度，首先转为月份
	IF CHARINDEX('Q',@iValue,0) > 0 
	BEGIN
		SET @iValue = SUBSTRING(@iValue,1,4)+ CASE RIGHT(@iValue,1) WHEN '1' THEN '01' WHEN '2' THEN '04' WHEN '3' THEN '07' WHEN '4' THEN '10' END
	END
	
	IF @Period = '月度' AND @Type = 'CURRENT'
	BEGIN
		SET @iReturn = @iValue
	END
	
	IF @Period = '月度' AND @Type = 'NEXT'
	BEGIN
		SET @iReturn = CONVERT(NVARCHAR(6),dateadd(M,1,CONVERT(DATETIME,@iValue+'01')),112)
	END
	
	IF @Period = '月度' AND @Type = 'PREVIOUS'
	BEGIN
		SET @iReturn = CONVERT(NVARCHAR(6),dateadd(M,-1,CONVERT(DATETIME,@iValue+'01')),112)
	END
	
	IF @Period = '季度' AND @Type = 'CURRENT'
	BEGIN
		SET @iReturn = SUBSTRING(@iValue,1,4)+ 'Q'+CONVERT(NVARCHAR,DATEPART(Q,CONVERT(DATETIME,@iValue+'01')))
	END
	
	IF @Period = '季度' AND @Type = 'NEXT'
	BEGIN
		SET @dValue = dateadd(Q,1, CONVERT(DATETIME,@iValue+'01'))
		SET @iReturn = CONVERT(NVARCHAR(4),@dValue,121) + 'Q' + CONVERT(NVARCHAR,DATEPART(Q,@dValue))
	END
	
	IF @Period = '季度' AND @Type = 'PREVIOUS'
	BEGIN
		SET @dValue = dateadd(Q,-1, CONVERT(DATETIME,@iValue+'01'))
		SET @iReturn = CONVERT(NVARCHAR(4),@dValue,121) + 'Q' + CONVERT(NVARCHAR,DATEPART(Q,@dValue))
	END
	
	IF @Period = '年度' AND @Type = 'CURRENT'
	BEGIN
		SET @iReturn = LEFT(@Value,4)
	END
	
	IF @Period = '年度' AND @Type = 'NEXT'
	BEGIN
		SET @iReturn = CONVERT(NVARCHAR,CONVERT(INT,LEFT(@Value,4))+1)
	END
	
	IF @Period = '年度' AND @Type = 'PREVIOUS'
	BEGIN
		SET @iReturn = CONVERT(NVARCHAR,CONVERT(INT,LEFT(@Value,4))-1)
	END
	return @iReturn
END


GO


