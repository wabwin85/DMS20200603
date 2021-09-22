DROP PROCEDURE [dbo].[Proc_XlsImportTempTable_Check1]
GO


CREATE PROCEDURE [dbo].[Proc_XlsImportTempTable_Check1]
(
	@UserId UNIQUEIDENTIFIER,
	@TableName NVARCHAR(200),	
	@SettingTable NVARCHAR(MAX),
	@IsValid NVARCHAR(200) = 'a' OUTPUT  
)
AS
BEGIN
	SET @IsValid = 'Error' 
	
	DECLARE @iSettingTable INT    
	EXEC sp_xml_preparedocument @iSettingTable OUTPUT, @SettingTable   
	            SELECT  Position,
	            		ColumnName,
	            		DescName,
	            		DataType,
	            		IsRequired,
	            		ErrorMsgColumn,
	            		CheckType,
	            		CheckValue
	            INTO    #SettingTable
	            FROM    OPENXML(@iSettingTable,'/DocumentElement/Table',2)  
	   WITH(   
	      Position NVARCHAR(200),
	      ColumnName NVARCHAR(200),
	      DescName NVARCHAR(200),
	      DataType NVARCHAR(200),
	      IsRequired NVARCHAR(200),
	      ErrorMsgColumn NVARCHAR(200),
	      CheckType NVARCHAR(200),
	      CheckValue NVARCHAR(200)
	    )  
	 
	
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @ColumnName NVARCHAR(200);
	DECLARE @DescName NVARCHAR(200);	
	DECLARE @CheckValue NVARCHAR(200);	
	DECLARE @DataType NVARCHAR(200);	
	DECLARE @ErrorMsgColumn NVARCHAR(200);	
	DECLARE @iCursor CURSOR  
	DECLARE @CheckTable NVARCHAR(200);
	DECLARE @CheckColumn NVARCHAR(200);
	
	--将DECIMAIL与INT中的,去掉
    SET @iCursor = CURSOR FOR
			SELECT a.ColumnName
    	FROM #SettingTable a WHERE DataType IN ('INT','DECIMAL')
    OPEN @iCursor FETCH NEXT FROM @iCursor INTO @ColumnName
      WHILE @@fetch_status = 0
		BEGIN
			PRINT @TableName
			PRINT @ColumnName
			SET @SQL = 'UPDATE '+@TableName+' SET '+@ColumnName+' = REPLACE('+@ColumnName+','','','''') 
				WHERE ISNULL('+@ColumnName+','''') <> '''' AND II_User = '''+ CONVERT(NVARCHAR(100),@UserId) +''' '
			PRINT @SQL
			EXECUTE (@SQL)
			FETCH NEXT FROM @iCursor INTO @ColumnName
		END
    CLOSE @iCursor
    DEALLOCATE @iCursor
    
	SET @SQL = 'SELECT * INTO #TMP_TABLE FROM '+@TableName+' WHERE II_User = '''+ CONVERT(NVARCHAR(100),@UserId) +''' '
	
	--效验必填字段
    SET @iCursor = CURSOR FOR SELECT a.ColumnName,a.DescName,
    	CASE ISNULL(a.ErrorMsgColumn,'') WHEN '' THEN 'II_ErrorMsg' ELSE A.ErrorMsgColumn END ErrorMsgColumn 
    	FROM #SettingTable a WHERE a.IsRequired = 'Y'	
    OPEN @iCursor FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn
      WHILE @@fetch_status = 0
		BEGIN
			SET @SQL += 'UPDATE #TMP_TABLE SET II_ErrorFlag = 1 ,'+@ErrorMsgColumn+' = ISNULL('+@ErrorMsgColumn+','''') + ''['+@DescName+']''+''必须填写!'' 
				WHERE ISNULL(CONVERT(NVARCHAR,'+@ColumnName+'),'''') = '''' '
			PRINT @SQL	
			--EXECUTE (@SQL)	 		 	
			FETCH NEXT FROM @iCursor INTO  @ColumnName,@DescName,@ErrorMsgColumn
		END
    CLOSE @iCursor
    DEALLOCATE @iCursor
	    
	--效验为DECIMAIL与INT型字段
    SET @iCursor = CURSOR FOR
			SELECT a.ColumnName,a.DescName,
    	CASE ISNULL(a.ErrorMsgColumn,'') WHEN '' THEN 'II_ErrorMsg' ELSE A.ErrorMsgColumn END ErrorMsgColumn 
    	FROM #SettingTable a WHERE DataType IN ('INT','DECIMAL')
    OPEN @iCursor FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn
      WHILE @@fetch_status = 0
		BEGIN
			SET @SQL += 'UPDATE #TMP_TABLE SET II_ErrorFlag = 1 ,'+@ErrorMsgColumn+' = ISNULL('+@ErrorMsgColumn+','''') + ''['+@DescName+']''+''类型不正确!'' 
				WHERE ISNUMERIC('+@ColumnName+') <> 1 AND ISNULL('+@ColumnName+','''') <> '''' '
			PRINT @SQL	
			--EXECUTE (@SQL)	 		 			
			FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn
		END
    CLOSE @iCursor
    DEALLOCATE @iCursor
    
	--效验日期类型字段
	SET @iCursor = CURSOR FOR
			SELECT a.ColumnName,a.DescName,
    	CASE ISNULL(a.ErrorMsgColumn,'') WHEN '' THEN 'II_ErrorMsg' ELSE A.ErrorMsgColumn END ErrorMsgColumn 
    	FROM #SettingTable a WHERE DataType IN ('DATETIME')
    OPEN @iCursor FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn
      WHILE @@fetch_status = 0
		BEGIN
			SET @SQL += 'UPDATE #TMP_TABLE SET II_ErrorFlag = 1 ,'+@ErrorMsgColumn+' = ISNULL('+@ErrorMsgColumn+','''') + ''['+@DescName+']''+''必须是日期类型!'' 
				WHERE ISDATE('+@ColumnName+') <> 1 AND  ISNULL('+@ColumnName+','''') <> '''' '
			PRINT @SQL	
			--EXECUTE (@SQL)	  
			FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn
		END
    CLOSE @iCursor
    DEALLOCATE @iCursor
    
    --判断INT必须是整型
    SET @iCursor = CURSOR FOR
			SELECT a.ColumnName,a.DescName,
    	CASE ISNULL(a.ErrorMsgColumn,'') WHEN '' THEN 'II_ErrorMsg' ELSE A.ErrorMsgColumn END ErrorMsgColumn 
    	FROM #SettingTable a WHERE DataType IN ('INT')
    OPEN @iCursor FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn
      WHILE @@fetch_status = 0
		BEGIN
			SET @SQL += 'UPDATE #TMP_TABLE SET II_ErrorFlag = 1 ,'+@ErrorMsgColumn+' = ISNULL('+@ErrorMsgColumn+','''') + ''['+@DescName+']''+''必须是整数!'' 
				WHERE 1=1 --II_ErrorFlag = 0 
				AND ISNULL('+@ColumnName+','''') <> ''''
				AND ISNUMERIC('+@ColumnName+') = 1
				AND CONVERT(DECIMAL(10,0),CONVERT(MONEY,'+@ColumnName+')) <> CONVERT(DECIMAL(14,6),CONVERT(MONEY,'+@ColumnName+')) '
			PRINT @SQL
			--EXECUTE (@SQL)	 		 			
			FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn
		END
    CLOSE @iCursor
    DEALLOCATE @iCursor
    
    --判断CheckType="Value",枚举型
    SET @iCursor = CURSOR FOR
			SELECT a.ColumnName,a.DescName,
    	CASE ISNULL(a.ErrorMsgColumn,'') WHEN '' THEN 'II_ErrorMsg' ELSE A.ErrorMsgColumn END ErrorMsgColumn,CheckValue
    	FROM #SettingTable a WHERE CheckType='Value'
    OPEN @iCursor FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn,@CheckValue
      WHILE @@fetch_status = 0
		BEGIN
			SET @SQL += 'UPDATE #TMP_TABLE SET II_ErrorFlag = 1 ,'+@ErrorMsgColumn+' = ISNULL('+@ErrorMsgColumn+','''') + ''['+@DescName+']''+''只能是：'+@CheckValue+'!'' 
				WHERE '+@CheckValue+' like ''%'+@ColumnName+'%''
				AND ISNULL('+@ColumnName+','''') <> '''' '
			PRINT @SQL
			--EXECUTE (@SQL)	 		 			
			FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn,@CheckValue
		END
    CLOSE @iCursor
    DEALLOCATE @iCursor
    
    --判断CheckType="Format",YYYYMM,YYYY-MM
    SET @iCursor = CURSOR FOR
			SELECT a.ColumnName,a.DescName,
    	CASE ISNULL(a.ErrorMsgColumn,'') WHEN '' THEN 'II_ErrorMsg' ELSE A.ErrorMsgColumn END ErrorMsgColumn,CheckValue
    	FROM #SettingTable a WHERE CheckType='Format' AND REPLACE(CheckValue,'-','') = 'YYYYMM'
    OPEN @iCursor FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn,@CheckValue
      WHILE @@fetch_status = 0
		BEGIN
			SET @SQL += 'UPDATE #TMP_TABLE SET II_ErrorFlag = 1 ,'+@ErrorMsgColumn+' = ISNULL('+@ErrorMsgColumn+','''') + ''['+@DescName+']''+''格式必须是：'+@CheckValue+'!'' 
				WHERE ISDATE('+@ColumnName+'+CASE '''+@CheckValue+''' WHEN ''YYYYMM'' THEN ''01'' ELSE ''-01'' END) <> 1
				AND ISNULL('+@ColumnName+','''') <> '''' '
			PRINT @SQL
			--EXECUTE (@SQL)	 		 			
			FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn,@CheckValue
		END
    CLOSE @iCursor
    DEALLOCATE @iCursor
    
    --判断CheckType="Format",>0 >=0,<0
    SET @iCursor = CURSOR FOR
			SELECT a.ColumnName,a.DescName,
    	CASE ISNULL(a.ErrorMsgColumn,'') WHEN '' THEN 'II_ErrorMsg' ELSE A.ErrorMsgColumn END ErrorMsgColumn,CheckValue,DataType
    	FROM #SettingTable a WHERE DataType IN ('INT','DECIMAL') AND CheckType='Format' AND (CheckValue like '%>%' or CheckValue like '%=%' or CheckValue like '%<%')
    OPEN @iCursor FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn,@CheckValue,@DataType
      WHILE @@fetch_status = 0
		BEGIN
			SET @SQL += 'UPDATE #TMP_TABLE SET II_ErrorFlag = 1 ,'+@ErrorMsgColumn+' = ISNULL('+@ErrorMsgColumn+','''') + ''['+@DescName+']''+''必须'+@CheckValue+'!'' 
				WHERE 1=1 --II_ErrorFlag = 0
				AND ISNULL('+@ColumnName+','''') <> '''' 
				AND ISNUMERIC('+@ColumnName+') = 1
				AND NOT CONVERT(DECIMAL,CONVERT(MONEY,'+@ColumnName+'))'+@CheckValue+ '
				AND II_User = '''+ CONVERT(NVARCHAR(100),@UserId) +''' '
			PRINT @SQL
			--EXECUTE (@SQL)	 		 			
			FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn,@CheckValue,@DataType
		END
    CLOSE @iCursor
    DEALLOCATE @iCursor
    
    --判断CheckType="Table",是否合法
    SET @iCursor = CURSOR FOR
			SELECT a.ColumnName,a.DescName,
    	CASE ISNULL(a.ErrorMsgColumn,'') WHEN '' THEN 'II_ErrorMsg' ELSE A.ErrorMsgColumn END ErrorMsgColumn,CheckValue
    	FROM #SettingTable a WHERE CheckType='Table'
    OPEN @iCursor FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn,@CheckValue
      WHILE @@fetch_status = 0
		BEGIN
			SET @CheckColumn = reverse(substring(reverse(@CheckValue),1,charindex('.',reverse(@CheckValue)) - 1)) 
			SET @CheckTable = reverse(substring(reverse(@CheckValue),charindex('.',reverse(@CheckValue))+1,200))
			SET @SQL += 'UPDATE A SET II_ErrorFlag = 1 ,'+@ErrorMsgColumn+' = ISNULL('+@ErrorMsgColumn+','''') + ''['+@DescName+']''+''不正确!'' 
				 FROM #TMP_TABLE A
				WHERE NOT EXISTS (SELECT 1 FROM '+@CheckTable+' WHERE '+@CheckColumn+' = A.'+@ColumnName+')
				AND ISNULL('+@ColumnName+','''') <> '''' '
			PRINT @SQL
			--EXECUTE (@SQL)	 		 			
			FETCH NEXT FROM @iCursor INTO @ColumnName,@DescName,@ErrorMsgColumn,@CheckValue
		END
    CLOSE @iCursor
    DEALLOCATE @iCursor
    
    --将错误信息更新回导入实表
    SET @SQL += 'UPDATE A SET '
    SET @iCursor = CURSOR FOR SELECT DISTINCT a.ErrorMsgColumn FROM #SettingTable a 
    	WHERE isnull(ErrorMsgColumn,'') <> '' AND isnull(ErrorMsgColumn,'') <> 'II_ErrorMsg'
    OPEN @iCursor FETCH NEXT FROM @iCursor INTO @ErrorMsgColumn
      WHILE @@fetch_status = 0
		BEGIN
			SET @SQL += @ErrorMsgColumn+'=B.'+@ErrorMsgColumn+','
			FETCH NEXT FROM @iCursor INTO @ErrorMsgColumn
		END
    CLOSE @iCursor
    DEALLOCATE @iCursor
    SET @SQL += 'II_ErrorMsg=B.II_ErrorMsg,II_ErrorFlag=B.II_ErrorFlag 
     	FROM '+@TableName+' A,#TMP_TABLE B
		WHERE A.II_ID = B.II_ID '
    --EXECUTE (@SQL)
    
	CREATE TABLE #TMP
	(
		ErrorCnt INTEGER
	)	
	SET @SQL += 'INSERT #TMP SELECT 1 FROM #TMP_TABLE WHERE II_ErrorFlag = 1 AND II_User = '''+ CONVERT(NVARCHAR(100),@UserId) +''' '
	
	--select @SQL
	--最后批量执行
	EXEC sp_executesql @SQL
	
	IF EXISTS (SELECT 1 FROM #TMP)
	BEGIN 
		SET @IsValid = 'Error' 
	END 
	ELSE  
	BEGIN
		SET @IsValid = 'Success'
	END  
END

GO


