
DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Product_PrdGrp]
GO



/**********************************************
 功能:
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor_Product_PrdGrp](
	@HierType NVARCHAR(50),
	@HierId NVARCHAR(50)
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	
	SELECT TOP 1 @SQL = CASE @HierType WHEN 'LEVEL1' THEN A.CFN_Level1Desc
		WHEN 'LEVEL2' THEN A.CFN_Level2Desc
		WHEN 'LEVEL3' THEN A.CFN_Level3Desc
		WHEN 'LEVEL4' THEN A.CFN_Level4Desc
		WHEN 'LEVEL5' THEN A.CFN_Level5Desc END +'('+@HierType+'='+@HierId+')'
		FROM dbo.CFN A WHERE CASE @HierType WHEN 'LEVEL1' THEN A.CFN_Level1Code
		WHEN 'LEVEL2' THEN A.CFN_Level2Code
		WHEN 'LEVEL3' THEN A.CFN_Level3Code
		WHEN 'LEVEL4' THEN A.CFN_Level4Code
		WHEN 'LEVEL5' THEN A.CFN_Level5Code END = @HierId
	
	IF @SQL IS NULL
		SET @SQL = '未知产品组('+@HierType+'='+@HierId+')'
	 
	RETURN @SQL
END



GO


