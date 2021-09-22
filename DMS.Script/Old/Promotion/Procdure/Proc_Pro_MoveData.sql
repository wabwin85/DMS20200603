DROP PROCEDURE [Promotion].[Proc_Pro_MoveData]
GO





/**********************************************
	���ܣ��ƶ����߼��������
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_MoveData]
	@PolicyId Int, --���߱��
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


