DROP FUNCTION [dbo].[Func_GetCode2]
GO

CREATE FUNCTION [dbo].[Func_GetCode2]
(
	@CodeType  SQL_VARIANT,
	@CodeId    SQL_VARIANT
)
RETURNS NVARCHAR(500)
AS
BEGIN
	DECLARE @returnValue NVARCHAR(500)
	
	SELECT @returnValue = STUFF(
	           REPLACE(
	               REPLACE(
	                   (
	                       SELECT VALUE1
	                       FROM   Lafite_DICT T
	                       WHERE  DICT_TYPE = @CodeType
							      AND T.DICT_KEY IN (SELECT val FROM dbo.GC_Fn_SplitStringToTable(CONVERT(NVARCHAR(1000), @CodeId),','))
							      FOR XML AUTO
	                   ),
	                   '<T VALUE1="',
	                   ','
	               ),
	               '"/>',
	               ''
	           ),
	           1,
	           1,
	           ''
	       )
	
	RETURN ISNULL(@returnValue, '')
END
GO


