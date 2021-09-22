DROP FUNCTION [dbo].[Func_GetCode]
GO


CREATE FUNCTION [dbo].[Func_GetCode]
(
	@CodeType  SQL_VARIANT,
	@CodeId    SQL_VARIANT
)
RETURNS NVARCHAR(500)
AS
BEGIN
	DECLARE @returnValue NVARCHAR(500)
	
	SELECT @returnValue = VALUE1
	FROM   Lafite_DICT
	WHERE  DICT_TYPE = @CodeType
	       AND DICT_KEY = CONVERT(NVARCHAR(100), @CodeId)
	
	RETURN ISNULL(@returnValue, '')
END
GO


