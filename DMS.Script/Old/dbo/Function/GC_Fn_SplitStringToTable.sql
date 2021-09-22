
DROP FUNCTION [dbo].[GC_Fn_SplitStringToTable]
GO


CREATE FUNCTION [dbo].[GC_Fn_SplitStringToTable]
(
	 @SourceString NVARCHAR(MAX),
	 @SeprateString NVARCHAR(10)
)
RETURNS @temp TABLE 
(
	VAL NVARCHAR(MAX) NULL
)
	WITH
	EXECUTE AS CALLER
AS
    BEGIN
        DECLARE @i INT
        SET @SourceString = rtrim (ltrim (@SourceString))
        SET @i = charindex (@SeprateString, @SourceString)

        WHILE @i >= 1
            BEGIN
                IF len (left (@SourceString, @i - 1)) > 0
                    BEGIN
                        INSERT @temp
                        VALUES (left (@SourceString, @i - 1))
                    END
                SET @SourceString   = substring (@SourceString, @i + 1, len (@SourceString) - @i)
                SET @i   = charindex (@SeprateString, @SourceString)
            END

        IF @SourceString <> ''
            INSERT @temp
            VALUES (@SourceString)
        RETURN
    END



GO


