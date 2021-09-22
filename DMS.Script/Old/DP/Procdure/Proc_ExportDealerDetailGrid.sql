DROP PROCEDURE [DP].[Proc_ExportDealerDetailGrid]
GO


CREATE PROCEDURE [DP].[Proc_ExportDealerDetailGrid]
	@DealerId NVARCHAR(100),
	@ModleId NVARCHAR(100),
	@Version NVARCHAR(100),
	@UserId NVARCHAR(100),
	@UserType NVARCHAR(100),
	@FilterBu NVARCHAR(100)
AS
BEGIN
	CREATE TABLE #Tmp
	(
		[SAP账号]     NVARCHAR(500),
		[经销商名称]  NVARCHAR(500)
	)
	
	DECLARE @DealerCode NVARCHAR(100);
	DECLARE @DealerName NVARCHAR(200);
	
	SELECT @DealerCode = DMA_SAP_Code,
	       @DealerName = DMA_ChineseName
	FROM   dbo.DealerMaster
	WHERE  DMA_ID = @DealerId;
	
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
	
	SET @Sql = '';
	SET @Sql = @Sql + 'INSERT INTO #Tmp ';
	SET @Sql = @Sql + 'SELECT ''' + @DealerCode + ''', ''' + @DealerName 
	    + ''', '
	
	SET @Sql = @Sql + @ColumnSql + ' FROM DP.DealerMaster A '
	SET @Sql = @Sql + 'WHERE A.DealerId = ''' + @DealerId + ''' '
	SET @Sql = @Sql + 'AND A.ModleId = ''' + @ModleId + ''' '
	SET @Sql = @Sql + 'AND (''' + ISNULL(@Version, '') + ''' = '''' OR A.[Version] = ''' + ISNULL(@Version, '') + ''') ';
	SET @Sql = @Sql + 'AND ( ';
	SET @Sql = @Sql + '       ''' + @UserType + ''' = ''User'' ';
	SET @Sql = @Sql + '       OR ''' + @FilterBu + ''' = ''FALSE'' ';
	SET @Sql = @Sql + '       OR A.Bu IN (SELECT BB.DivisionName ';
	SET @Sql = @Sql + '                   FROM   View_ProductLine AA, ';
	SET @Sql = @Sql + '                          V_DivisionProductLineRelation BB ';
	SET @Sql = @Sql + '                   WHERE  EXISTS ( ';
	SET @Sql = @Sql + '                              SELECT 1 ';
	SET @Sql = @Sql + '                              FROM   Lafite_IDENTITY_MAP BB, ';
	SET @Sql = @Sql + '                                     Cache_OrganizationUnits CC ';
	SET @Sql = @Sql + '                              WHERE  BB.MAP_TYPE = ''Organization'' ';
	SET @Sql = @Sql + '                                     AND BB.IDENTITY_ID = ''' + @UserId +
	    ''' ';
	SET @Sql = @Sql + '                                     AND BB.MAP_ID = CC.RootID ';
	SET @Sql = @Sql + '                                     AND CC.AttributeType =  ';
	SET @Sql = @Sql + '                                         ''Product_Line'' ';
	SET @Sql = @Sql + '                                     AND CC.AttributeID = AA.Id ';
	SET @Sql = @Sql + '                          ) ';
	SET @Sql = @Sql + '                          AND AA.ATTRIBUTE_NAME = BB.ProductLineName) ';
	SET @Sql = @Sql + '   ) ';
	
	SET @Sql = @Sql + 'ORDER BY A.SortId DESC '
	
	EXEC (@Sql)
	
	SELECT *
	FROM   #Tmp;
	
	DROP TABLE #Tmp;
END
GO


