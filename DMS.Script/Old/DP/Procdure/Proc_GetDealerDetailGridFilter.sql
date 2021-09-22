DROP PROCEDURE [DP].[Proc_GetDealerDetailGridFilter]
GO


/**********************************************
 功能：获取每个大类的所有相关信息，为提高速度集中进行查询
 作者：宋卫铭
 最后更新时间：2012-07-03
 更新记录说明：
 1.创建 2012-07-03
**********************************************/
CREATE PROCEDURE [DP].[Proc_GetDealerDetailGridFilter]
	@DealerId UNIQUEIDENTIFIER,
	@ThirdClass UNIQUEIDENTIFIER,
	@Version NVARCHAR(100),
	@UserId UNIQUEIDENTIFIER,
	@UserType NVARCHAR(100),
	@FilterBu NVARCHAR(100),
	@Condition XML
AS
BEGIN
	DECLARE @ColumnName NVARCHAR(100);
	DECLARE @ColumnValue NVARCHAR(100);
	DECLARE @Sql NVARCHAR(MAX);
	
	SET @Sql = 'SELECT *, ROW_NUMBER() OVER(ORDER BY ID) AS ROW_NUMBER ';
	SET @Sql = @Sql + 'FROM DP.DealerMaster A ';
	SET @Sql = @Sql + 'WHERE DealerId = ''' + CONVERT(NVARCHAR(100), @DealerId) + ''' ';
	SET @Sql = @Sql + 'AND ModleID = ''' + CONVERT(NVARCHAR(100), @ThirdClass) + ''' ';
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
	SET @Sql = @Sql + '                                     AND BB.IDENTITY_ID = ''' + CONVERT(NVARCHAR(100), @UserId) + ''' ';
	SET @Sql = @Sql + '                                     AND BB.MAP_ID = CC.RootID ';
	SET @Sql = @Sql + '                                     AND CC.AttributeType =  ';
	SET @Sql = @Sql + '                                         ''Product_Line'' ';
	SET @Sql = @Sql + '                                     AND CC.AttributeID = AA.Id ';
	SET @Sql = @Sql + '                          ) ';
	SET @Sql = @Sql + '                          AND AA.ATTRIBUTE_NAME = BB.ProductLineName) ';
	SET @Sql = @Sql + '   ) ';
	
	DECLARE CUR_CONDITION CURSOR  
	FOR
	    SELECT doc.col.value('ColumnName[1]', 'NVARCHAR(100)'),
	           doc.col.value('ColumnValue[1]', 'NVARCHAR(100)')
	    FROM   @Condition.nodes('/ConditionList/Condition') doc(col)
	
	OPEN CUR_CONDITION
	FETCH NEXT FROM CUR_CONDITION INTO @ColumnName,@ColumnValue
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    IF @ColumnValue <> ''
	    BEGIN
	        SET @Sql = @Sql + 'AND ' + @ColumnName + ' LIKE ''%' + @ColumnValue 
	            + '%'' ';
	    END
	    
	    FETCH NEXT FROM CUR_CONDITION INTO @ColumnName,@ColumnValue
	END
	CLOSE CUR_CONDITION
	DEALLOCATE CUR_CONDITION
	
	SET @Sql = @Sql + '  ORDER BY A.SortId ';
	
	PRINT @Sql
	EXEC (@Sql)
END
GO


