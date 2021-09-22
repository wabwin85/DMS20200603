DROP FUNCTION [Promotion].[func_Pro_Utility_getPolicyTableName]
GO



/**********************************************
 功能:根据政策ID取得计算表名
 作者：Grapecity
 最后更新时间： 2015-08-28
 更新记录说明：
 1.创建 2015-08-28
**********************************************/
CREATE FUNCTION [Promotion].[func_Pro_Utility_getPolicyTableName]( 
	@PolicyId INT, --政策id
	@TableType NVARCHAR(10)	--表类型（正式表REP、计算表TMP、预算表CAL）
	)
RETURNS NVARCHAR(50)
AS
BEGIN
	DECLARE @iTableName NVARCHAR(50)
	SET @iTableName = 'Promotion.TPRO_'+@TableType+'_'+RIGHT('000'+CONVERT(NVARCHAR,@PolicyId),4)
	
	RETURN @iTableName
END



GO


