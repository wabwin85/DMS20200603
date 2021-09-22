DROP PROCEDURE [Promotion].[Proc_Pro_MoveData]
GO





/**********************************************
	功能：移动政策计算表数据
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_MoveData]
	@PolicyId Int, --政策编号
	@FromTable NVARCHAR(50),
	@ToTable NVARCHAR(50)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @FromTableNew NVARCHAR(50)
	DECLARE @ToTableNew NVARCHAR(50)
	
	SET @FromTableNew = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,@FromTable)
	SET @ToTableNew = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,@ToTable)
 
	 
	SET @SQL = 'DELETE FROM '+ @ToTableNew
	EXEC(@SQL)
	
	SET @SQL = 'INSERT INTO '+ @ToTableNew + ' SELECT * FROM '+@FromTableNew
	EXEC(@SQL)
END


GO


