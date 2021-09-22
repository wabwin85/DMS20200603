DROP PROCEDURE [DP].[Proc_ExportForm]
GO


CREATE PROCEDURE [DP].[Proc_ExportForm]
	@ModleId NVARCHAR(100),
	@IsShowVersion BIT
AS
BEGIN
	CREATE TABLE #Tmp
	(
		[SAP账号]     NVARCHAR(500),
		[经销商名称]  NVARCHAR(500)
	)
	IF @IsShowVersion = 1
	BEGIN
	    ALTER TABLE #Tmp ADD [版本号] NVARCHAR(500)
	END
	
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
	DECLARE @Version NVARCHAR(500);
	
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
	    
	    IF @IsShowVersion = 1
	    BEGIN
	        SET @Sql = @Sql + 'Version, '
	    END
	    
	    SET @Sql = @Sql + @ColumnSql + ' FROM DP.DealerMaster '
	    SET @Sql = @Sql + 'WHERE DealerId = ''' + @DealerId + ''' '
	    SET @Sql = @Sql + 'AND ModleId = ''' + @ModleId + ''' '
	    
	    IF @IsShowVersion = 1
	    BEGIN
	        SET @Sql = @Sql + 'ORDER BY Version DESC '
	    END
	    ELSE
	    BEGIN
	        SELECT @Version = MAX(Version)
	        FROM   DP.DealerMaster
	        WHERE  DealerId = @DealerId
	               AND ModleID = @ModleId;
	        
	        SET @Sql = @Sql + 'AND Version = ''' + @Version + ''' '
	    END
	    
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


