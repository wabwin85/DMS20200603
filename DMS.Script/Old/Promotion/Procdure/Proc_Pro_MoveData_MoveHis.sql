DROP PROCEDURE [Promotion].[Proc_Pro_MoveData_MoveHis]
GO





/**********************************************
	���ܣ��ƶ����߼������ʷ���ݱ�
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_MoveData_MoveHis]
	@PolicyId Int --���߱��
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


