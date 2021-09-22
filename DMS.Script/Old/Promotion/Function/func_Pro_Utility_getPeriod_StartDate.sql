DROP FUNCTION [Promotion].[func_Pro_Utility_getPeriod_StartDate]
GO

CREATE FUNCTION [Promotion].[func_Pro_Utility_getPeriod_StartDate](
	@Period NVARCHAR(10)
	)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(10)
	
	IF LEN(@Period)<>4
	BEGIN
		IF CHARINDEX('Q',@Period,0) > 0 --¼¾¶È
		BEGIN
			IF RIGHT(@Period,1) = 1 	SET @iReturn = LEFT(@Period,4)+'-01-01'
			IF RIGHT(@Period,1) = 2 	SET @iReturn = LEFT(@Period,4)+'-04-01'
			IF RIGHT(@Period,1) = 3 	SET @iReturn = LEFT(@Period,4)+'-07-01'
			IF RIGHT(@Period,1) = 4 	SET @iReturn = LEFT(@Period,4)+'-10-01'
		END
		ELSE
		BEGIN
			SET @iReturn = LEFT(@Period,4)+'-' + RIGHT(@Period,2) + '-01'
		END
	END
	
	--Äê¶È
	IF LEN(@Period)=4
	BEGIN
		SET @iReturn = @Period+'-01-01'
	END	
	
	return @iReturn
END


GO


