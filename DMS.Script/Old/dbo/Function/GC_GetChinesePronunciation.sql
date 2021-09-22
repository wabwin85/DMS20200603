DROP FUNCTION [dbo].[GC_GetChinesePronunciation] 
GO

-- =============================================
-- Author:		Steven Su
-- Create date: 2009/09/01
-- Description:	To get the Chinese string pronunciation
-- =============================================
CREATE FUNCTION [dbo].[GC_GetChinesePronunciation] 
(
	-- Add the parameters for the function here
	-- select dbo.GC_GetChinesePronunciation('ÉÏº£')
	@ChineseString NVARCHAR(100)
)
RETURNS NVARCHAR(500)
AS
BEGIN
	-- Declare the return variable here
	
	DECLARE @ResultVar NVARCHAR(500)
	DECLARE @iLen INT
	DECLARE @CurrentChar NVARCHAR(50)
	SET @ResultVar = ''
	SET @CurrentChar = @ChineseString
	SET @iLen = LEN(@ChineseString)
	WHILE @iLen > 0
	BEGIN
		IF @iLen > 0
		BEGIN
			SELECT TOP 1 @ResultVar = LEFT(dbo.Hanzibiao.Pronunciation,LEN(dbo.Hanzibiao.Pronunciation) -1) + @ResultVar FROM dbo.Hanzibiao WHERE dbo.Hanzibiao.Hanzi = RIGHT(@CurrentChar,1)
			SELECT @CurrentChar = LEFT(@CurrentChar,LEN(@CurrentChar)-1)
		END
		SET @iLen = @iLen - 1
	END

	RETURN @ResultVar

END

GO


