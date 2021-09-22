DROP FUNCTION [dbo].[UrlDecode]
GO

CREATE FUNCTION [dbo].[UrlDecode]
(
	@v VARCHAR(2000)
)
RETURNS VARCHAR(6000)
AS
 
BEGIN
	DECLARE @s   VARCHAR(6000),
	        @b   VARBINARY(6000),
	        @n1  INT,
	        @n2  INT
	
	SET @b = CAST(@v AS VARBINARY(4000)) 
	SET @s = '' 
	WHILE DATALENGTH(@b) > 0
	BEGIN
	    SET @n1 = CAST(SUBSTRING(@b, 1, 1) AS INT) 
	    SET @n2 = @n1 / 16 
	    SET @s = @s + '%' + CASE 
	                             WHEN @n2 > 9 THEN CHAR(ASCII('A') + @n2 - 10)
	                             ELSE CAST(@n2 AS CHAR(1))
	                        END
	    
	    SET @n2 = @n1 %16 
	    SET @s = @s + CASE 
	                       WHEN @n2 > 9 THEN CHAR(ASCII('A') + @n2 - 10)
	                       ELSE CAST(@n2 AS CHAR(1))
	                  END
	    
	    SET @b = SUBSTRING(@b, 2, DATALENGTH(@b) - 1)
	END 
	RETURN(@s)
END
GO


