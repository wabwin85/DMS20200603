DROP FUNCTION [dbo].[GC_GetProductStructurePath]
GO

-- =============================================
-- Author:		Steven Su
-- Create date: 2009/09/01
-- Description:	To get the path of the product
-- =============================================
CREATE FUNCTION [dbo].[GC_GetProductStructurePath] 
(
	-- Add the parameters for the function here
	@RowPath BIGINT
)
RETURNS NVARCHAR(500)
AS
BEGIN
	-- Declare the return variable here
	
	DECLARE @ResultVar NVARCHAR(500)
	DECLARE @iLen INT
	DECLARE @ProductLineName NVARCHAR(50)
	SET @iLen = LEN(CONVERT(NVARCHAR(30),@RowPath))
	SELECT @ResultVar = dbo.[_ProdStructure].PCT_Name,@ProductLineName = ATTRIBUTE_NAME  FROM dbo.[_ProdStructure] WHERE RowNbr = @RowPath
	WHILE @iLen > 0
	BEGIN
		SET @iLen = @iLen - 2
		--SELECT @iLen
		IF @iLen > 0
		SELECT @ResultVar = dbo.[_ProdStructure].PCT_Name + '\' + @ResultVar FROM dbo.[_ProdStructure] WHERE RowNbr = CONVERT(bigint,LEFT(CONVERT(NVARCHAR(30),@RowPath),@iLen))
	END
	SELECT @ResultVar = @ProductLineName + '\' + @ResultVar
	--SELECT @ResultVar = CONVERT(NVARCHAR(10),LEN(@ResultVar)) + '--' + @ResultVar

	RETURN @ResultVar

END

GO


