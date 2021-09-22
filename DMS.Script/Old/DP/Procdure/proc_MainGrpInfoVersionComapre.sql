
DROP PROCEDURE [DP].[proc_MainGrpInfoVersionComapre]
GO


CREATE PROCEDURE [DP].[proc_MainGrpInfoVersionComapre] (
    @DealerId    UNIQUEIDENTIFIER,
    @ThirdClass  UNIQUEIDENTIFIER,
    @VersionSrc  NVARCHAR(100),
    @VersionTag  NVARCHAR(100),
    @UserId      UNIQUEIDENTIFIER
)
AS
BEGIN
	CREATE TABLE #Result
	(
		ContentID     UNIQUEIDENTIFIER,
		ContentLeble  NVARCHAR(100),
		RowSite       INT,
		ColumnSite    INT,
		VerSrcValue   NVARCHAR(500),
		VerTagValue   NVARCHAR(500),
		DiffType      NVARCHAR(10)
	)
	
	DECLARE @ContentID UNIQUEIDENTIFIER;
	DECLARE @ContentLeble NVARCHAR(100);
	DECLARE @RowSite INT;
	DECLARE @ColumnSite INT;
	DECLARE @ColumnID NVARCHAR(500);
	DECLARE @Sql NVARCHAR(MAX);
	
	DECLARE CUR_CONDITION CURSOR  
	FOR
	    SELECT A.ContentID,
	           A.ContentLeble,
	           A.RowSite,
	           A.ColumnSite,
	           B.CM_ColumnID
	    FROM   DP.DPContent A,
	           DP.ColumnMapping B
	    WHERE  A.ContentID = B.ContentID
	           AND A.IsAction = 1
	           AND B.IsAction = 1
	           AND A.ModleID = @ThirdClass
	;
	
	OPEN CUR_CONDITION
	FETCH NEXT FROM CUR_CONDITION INTO @ContentID,@ContentLeble,@RowSite,@ColumnSite,
	@ColumnID
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    SET @Sql = 'INSERT INTO #Result (ContentID, ContentLeble, RowSite, ColumnSite, VerSrcValue, VerTagValue) ';
	    SET @Sql = @Sql + 'SELECT ''' + CONVERT(NVARCHAR(100), @ContentID) + ''', ';
	    SET @Sql = @Sql + '	   ''' + CONVERT(NVARCHAR(100), @ContentLeble) + ''', ';
	    SET @Sql = @Sql + '	   ' + CONVERT(NVARCHAR(100), @RowSite) + ', ';
	    SET @Sql = @Sql + '	   ' + CONVERT(NVARCHAR(100), @ColumnSite) + ', ';
	    SET @Sql = @Sql + '	   ( ';
	    SET @Sql = @Sql + '		   SELECT ' + @ColumnID + ' ';
	    SET @Sql = @Sql + '		   FROM   DP.DealerMaster ';
	    SET @Sql = @Sql + '		   WHERE  DealerId = ''' + CONVERT(NVARCHAR(100), @DealerId) + ''' ';
	    SET @Sql = @Sql + '				  AND ModleID = ''' + CONVERT(NVARCHAR(100), @ThirdClass) + ''' ';
	    SET @Sql = @Sql + '				  AND Version = ''' + @VersionSrc + ''' ';
	    SET @Sql = @Sql + '	   ), ';
	    SET @Sql = @Sql + '	   ( ';
	    SET @Sql = @Sql + '		   SELECT ' + @ColumnID + ' ';
	    SET @Sql = @Sql + '		   FROM   DP.DealerMaster ';
	    SET @Sql = @Sql + '		   WHERE  DealerId = ''' + CONVERT(NVARCHAR(100), @DealerId) + ''' ';
	    SET @Sql = @Sql + '				  AND ModleID = ''' + CONVERT(NVARCHAR(100), @ThirdClass) + ''' ';
	    SET @Sql = @Sql + '				  AND Version = ''' + @VersionTag + ''' ';
	    SET @Sql = @Sql + '	   ) ';
	    
	    EXEC(@Sql)
	    
	    FETCH NEXT FROM CUR_CONDITION INTO @ContentID,@ContentLeble,@RowSite,@ColumnSite,
	    @ColumnID
	END
	CLOSE CUR_CONDITION
	DEALLOCATE CUR_CONDITION
	
	UPDATE #Result SET DiffType = 'NOCHANGE' WHERE ISNULL(VerSrcValue,'') = ISNULL(VerTagValue,'');
	UPDATE #Result SET DiffType = 'UPDATE' WHERE ISNULL(VerSrcValue,'') <> ISNULL(VerTagValue,'');
	
	SELECT *
	FROM   #Result
	ORDER BY RowSite, ColumnSite
END
RETURN
GO


