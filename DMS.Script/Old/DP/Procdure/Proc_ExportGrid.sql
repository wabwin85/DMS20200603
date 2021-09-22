DROP PROCEDURE [DP].[Proc_ExportGrid]
GO


CREATE PROCEDURE [DP].[Proc_ExportGrid]
	@ModleId NVARCHAR(100)
AS
BEGIN
	CREATE TABLE #Tmp
	(
		[SAP账号]     NVARCHAR(500),
		[经销商名称]  NVARCHAR(500)
	)
	
	DECLARE @ColumnName NVARCHAR(100);
	DECLARE @ColumnId NVARCHAR(100);
	DECLARE @Sql NVARCHAR(MAX);
	DECLARE @ColumnSql NVARCHAR(MAX);
	SET @ColumnSql = '';
	
	DECLARE CUR_COLUMN CURSOR  
	FOR
	    SELECT B.CM_ColumnID,
	           A.ContentLeble
	    FROM   DP.DPContent A,
	           DP.ColumnMapping B
	    WHERE  A.ContentID = B.ContentID
	           AND A.ModleID = @ModleId
	           AND A.IsDeleted = 0
	           AND A.IsAction = 1
	           AND A.ControlID <> 'Blank'
	    ORDER BY A.RowSite, A.ColumnSite
	
	OPEN CUR_COLUMN
	FETCH NEXT FROM CUR_COLUMN INTO @ColumnId,@ColumnName
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @Sql = 'ALTER TABLE #Tmp ADD [' + @ColumnName + '] NVARCHAR(2000)';
	    EXEC (@Sql)
	    
	    SET @ColumnSql = @ColumnSql + @ColumnId + ', ';
	    
	    FETCH NEXT FROM CUR_COLUMN INTO @ColumnId,@ColumnName
	END
	CLOSE CUR_COLUMN
	DEALLOCATE CUR_COLUMN
	
	SET @ColumnSql = LTRIM(RTRIM(@ColumnSql))
	SET @ColumnSql = SUBSTRING(@ColumnSql, 1, LEN(@ColumnSql) -1)
	
	DECLARE @DealerId NVARCHAR(500);
	DECLARE @DealerCode NVARCHAR(500);
	DECLARE @DealerName NVARCHAR(500);
	
	DECLARE CUR_DEALER CURSOR  
	FOR
	    SELECT DealerId,
	           DealerCode,
	           DealerName
	    FROM   #DealerList
	
	OPEN CUR_DEALER
	FETCH NEXT FROM CUR_DEALER INTO @DealerId,@DealerCode,@DealerName
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @Sql = '';
	    SET @Sql = @Sql + 'INSERT INTO #Tmp ';
	    SET @Sql = @Sql + 'SELECT ''' + @DealerCode + ''', ''' + @DealerName 
	        + ''', '
	    
	    SET @Sql = @Sql + @ColumnSql + ' FROM DP.DealerMaster '
	    SET @Sql = @Sql + 'WHERE DealerId = ''' + @DealerId + ''' '
	    SET @Sql = @Sql + 'AND ModleId = ''' + @ModleId + ''' '
	    
	    SET @Sql = @Sql + 'ORDER BY SortId DESC '
	    
	    EXEC (@Sql)
	    
	    FETCH NEXT FROM CUR_DEALER INTO @DealerId,@DealerCode,@DealerName
	END
	CLOSE CUR_DEALER
	DEALLOCATE CUR_DEALER
	
	SELECT *
	FROM   #Tmp;
	
	DROP TABLE #Tmp;
END
GO


