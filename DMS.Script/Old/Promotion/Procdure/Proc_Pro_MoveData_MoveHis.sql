DROP PROCEDURE [Promotion].[Proc_Pro_MoveData_MoveHis]
GO





/**********************************************
	功能：移动政策计算表到历史数据表
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_MoveData_MoveHis]
	@PolicyId Int --政策编号
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @REP_TABLE NVARCHAR(50)
	DECLARE @HIS_TABLE NVARCHAR(50)
	DECLARE @maxID INT
	
	SET @REP_TABLE = Promotion.func_Pro_Utility_getPolicyTableName(@PolicyId,'REP')
	SET @HIS_TABLE = @REP_TABLE + '_HIS'
 	
 	SET @SQL = N'SELECT @maxID = MAX(ID) FROM '+@HIS_TABLE
 	EXEC SP_EXECUTESQL @SQL,N'@maxID INT output',@maxID output
	
	SET @maxID = ISNULL(@maxID,0)+1
	--PRINT @maxID
	SET @SQL = 'INSERT INTO '+@HIS_TABLE+' SELECT '+CONVERT(NVARCHAR,@maxID)+',GETDATE(),* FROM '+@REP_TABLE
	EXEC(@SQL)
END


GO


