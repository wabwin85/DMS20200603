DROP FUNCTION [Promotion].[func_Pro_Utility_getPointValidDate]
GO

CREATE FUNCTION [Promotion].[func_Pro_Utility_getPointValidDate](
	@Period NVARCHAR(50),				--季度/月份
	@AccountMonth  NVARCHAR(50),		--当前计算帐期
	@PointValidDateType NVARCHAR(50),	--积分有效期类型(Always始终有效；AbsoluteDate固定日期；AccountMonth帐期延展；)
	@PointValidDateDuration INT,		--积分有效期基准时间跨度:1-12个月
	@PointValidDateAbsolute DATETIME	--积分有效期统一日期:统一日期
	)
RETURNS DATETIME
AS
BEGIN
	DECLARE @RETURN_DATE DATETIME
	
	IF @PointValidDateType = 'Always'
	BEGIN
		SET	@RETURN_DATE = '9999-12-31'
	END
	
	IF @PointValidDateType = 'AbsoluteDate'
	BEGIN
		SET	@RETURN_DATE = @PointValidDateAbsolute
	END
	
	IF @PointValidDateType = 'AccountMonth'
	BEGIN
		IF @Period = '季度'
		BEGIN
			SET	@RETURN_DATE = DATEADD(M,@PointValidDateDuration+1,CONVERT(DATETIME,LEFT(@AccountMonth,4) 
				+ CASE RIGHT(@AccountMonth,2) WHEN 'Q1' THEN '03' WHEN 'Q2' THEN '06' WHEN 'Q3' THEN '09' ELSE '12' END+'01'))-1
		END
		ELSE
		BEGIN
			SET	@RETURN_DATE = DATEADD(M,@PointValidDateDuration+1,CONVERT(DATETIME,@AccountMonth+'01'))-1
		END 
	END
	
	RETURN @RETURN_DATE
END


GO


