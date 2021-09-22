DROP FUNCTION [Promotion].[func_Pro_Utility_getPeriodForMonth]
GO

CREATE FUNCTION [Promotion].[func_Pro_Utility_getPeriodForMonth](
	@Period NVARCHAR(5),	--周期（季度、月度）
	@Value NVARCHAR(7)		--YYYYQX,YYYYMM
	)
RETURNS @temp TABLE 
(
	IMonth NVARCHAR(100) NULL,
	ITime NVARCHAR(10) NULL,
	IYearMonth NVARCHAR(10) NULL
)
	WITH
	EXECUTE AS CALLER
AS
BEGIN
    DECLARE @Q NVARCHAR(2)	
    DECLARE @YEAR NVARCHAR(4)	
    
    SET @YEAR=SUBSTRING(@Value,0,5)
	IF @Period='季度'
	BEGIN
		SET @Q=SUBSTRING(@Value,LEN(@Value),LEN(@Value))
		IF @Q='1'
		BEGIN
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('01',@YEAR+'-'+'01'+'-'+'01',@YEAR+'01');
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('02',@YEAR+'-'+'02'+'-'+'01',@YEAR+'02');
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('03',@YEAR+'-'+'03'+'-'+'01',@YEAR+'03');
		END
		IF @Q='2'
		BEGIN
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('04',@YEAR+'-'+'04'+'-'+'01',@YEAR+'04');
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('05',@YEAR+'-'+'05'+'-'+'01',@YEAR+'05');
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('06',@YEAR+'-'+'06'+'-'+'01',@YEAR+'06');
		END
		IF @Q='3'
		BEGIN
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('07',@YEAR+'-'+'07'+'-'+'01',@YEAR+'07');
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('08',@YEAR+'-'+'08'+'-'+'01',@YEAR+'08');
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('09',@YEAR+'-'+'09'+'-'+'01',@YEAR+'09');
		END
		IF @Q='4'
		BEGIN
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('10',@YEAR+'-'+'10'+'-'+'01',@YEAR+'10');
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('11',@YEAR+'-'+'11'+'-'+'01',@YEAR+'11');
			INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('12',@YEAR+'-'+'12'+'-'+'01',@YEAR+'12');
		END
	END
	
	IF @Period='月度'
	BEGIN
		SET @Q=SUBSTRING(@Value,LEN(@Value)-1,LEN(@Value))
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES(@Q,@YEAR+'-'+@Q+'-'+'01',@Value);
	END
	
	IF @Period='年度'
	BEGIN
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('01',@Value+'-'+'01'+'-'+'01',@Value+'01');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('02',@Value+'-'+'02'+'-'+'01',@Value+'02');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('03',@Value+'-'+'03'+'-'+'01',@Value+'03');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('04',@Value+'-'+'04'+'-'+'01',@Value+'04');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('05',@Value+'-'+'05'+'-'+'01',@Value+'05');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('06',@Value+'-'+'06'+'-'+'01',@Value+'06');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('07',@Value+'-'+'07'+'-'+'01',@Value+'07');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('08',@Value+'-'+'08'+'-'+'01',@Value+'08');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('09',@Value+'-'+'09'+'-'+'01',@Value+'09');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('10',@Value+'-'+'10'+'-'+'01',@Value+'10');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('11',@Value+'-'+'11'+'-'+'01',@Value+'11');
		INSERT INTO @temp(IMonth,ITime,IYearMonth) VALUES('12',@Value+'-'+'12'+'-'+'01',@Value+'12');
	END
	
	return
END


GO


