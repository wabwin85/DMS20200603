
/****** Object:  StoredProcedure [Contract].[Proc_GetContractList]    Script Date: 2020/5/18 11:46:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Ye Pan Fei
-- Create date: 2017-08-01
-- Description:	分页获取用户信息
-- =============================================
ALTER PROCEDURE [Contract].[Proc_GetContractList]
    (
      @DealerId NVARCHAR(50) ,
      @Status NVARCHAR(50) ,
      @ContractNo NVARCHAR(50) ,
      @StartTime DATETIME,
      @EndTime DATETIME,
      @ProductLine NVARCHAR(50),
	  @UserId UNIQUEIDENTIFIER,
	  @SubCompanyId    UNIQUEIDENTIFIER,
	  @BrandId         UNIQUEIDENTIFIER,
      @CurrentPageIndex INT = 0 ,
      @PageSize INT = 0
    )
AS
    BEGIN  
	
	DECLARE @UserType NVARCHAR(50)
	DECLARE @DealerType NVARCHAR(50)
	DECLARE @CorpId NVARCHAR(50)

	Create TABLE #ExportMaxDate
	(
		CreateDate DATETIME,
		ContractId UNIQUEIDENTIFIER
	)
	Create TABLE #ExportT2MaxDate
	(
		CreateDate DATETIME,
		ContractId UNIQUEIDENTIFIER
	)

	SELECT @UserType = IDENTITY_TYPE,@CorpId = Corp_ID FROM Lafite_IDENTITY WHERE ID = @UserId
	
	IF(@UserType = 'Dealer')
	BEGIN
		SELECT @DealerType = DMA_DealerType FROM DealerMaster WHERE DMA_ID = @CorpId 
		
	
	END
	SELECT @UserType = IDENTITY_TYPE FROM Lafite_IDENTITY WHERE ID = @UserId
	
	IF (@DealerType = 'T2')
		BEGIN
		INSERT INTO #ExportT2MaxDate(ContractId,CreateDate)
		SELECT ContractId,MAX(CreateDate) FROM Contract.ExportT2Main AA WHERE Status  ='submit' GROUP BY ContractId 

		SELECT ROW_NUMBER() OVER(ORDER BY A.CreateDate DESC) AS ROWNUMBER,A.ExportId, 
		D.DMA_ID,D.DMA_ChineseName,A.ContractNo,A.ContractId,A.ContractType,D.DMA_DealerType,V.DivisionName as SubProductName,V.ProductLineName as DeptName,V.DivisionCode,CONVERT(NVARCHAR(10),MAX(A.CreateDate),112)AS CreateDate,A.CreateUser,B.FileName,B.FileType,
		REPLACE(B.UploadFilePath,'\','/') AS UploadFilePath,
		REPLACE(SUBSTRING(B.UploadFilePath,1,LEN(B.UploadFilePath) - CHARINDEX('/',REVERSE(B.UploadFilePath))),'\','//') AS FileSrcPath,REVERSE(SUBSTRING(REVERSE(B.UploadFilePath),1,CHARINDEX('/',REVERSE(B.UploadFilePath))-1)) AS FileSrcName,
		C.VersionStatus,C.VersionNo,E.VALUE1 AS StatusName,CASE ISNULL(F.Id,'') WHEN '' THEN '0' ELSE '1' END IsSinge
		INTO #Result_T2
		FROM Contract.ExportT2Main A 
		INNER JOIN Contract.ExportSelectedTemplate B ON A.ExportId = B.ExportId 
		INNER JOIN V_DivisionProductLineRelation V ON V.DivisionCode=A.DeptId and v.IsEmerging='0'
		INNER JOIN Contract.ExportVersion C ON A.ExportId = C.ExportId
		INNER JOIN DealerMaster D ON A.DealerId =CAST(D.DMA_ID AS NVARCHAR(50))
		INNER JOIN Lafite_DICT  E ON C.VersionStatus = E.DICT_KEY AND E.DICT_TYPE = 'ContractElectronic'
		INNER JOIN #ExportT2MaxDate H ON H.ContractId=A.ContractId AND A.CreateDate=H.CreateDate
		LEFT JOIN Lafite_IDENTITY F ON C.CreateUser = F.Id
		AND (CONVERT(NVARCHAR(50),F.Corp_ID) = @DealerId OR @DealerId = 'All')
		WHERE A.Status ='submit' AND B.FileType = 'Finaldraft'
		AND (A.ContractNo = @ContractNo OR ISNULL(@ContractNo,'') = '')
		AND (C.VersionStatus = @Status OR ISNULL(@Status,'') = '')
		--AND A.CreateDate IN(SELECT MAX(CreateDate) FROM Contract.ExportT2Main WHERE Status  ='submit' GROUP BY ContractId )
		AND (@DealerId='All' OR A.DealerId = @DealerId) 
		AND A.CreateDate BETWEEN @StartTime AND @EndTime
		AND (A.DeptId = @ProductLine OR @ProductLine = '')
		AND (D.DMA_Parent_DMA_ID = @CorpId OR DMA_ID = @CorpId)
		AND ((V.SubCompanyId = @SubCompanyId AND V.BrandId = @BrandId))
		GROUP BY D.DMA_ID,D.DMA_ChineseName,A.ContractNo,A.ContractId,A.CreateDate,A.CreateUser,B.FileName,B.FileType,A.ExportId,
		B.UploadFilePath,C.VersionNo,C.VersionStatus,E.VALUE1,F.Id,A.DeptNameEn,
		A.DeptName,A.ContractType,D.DMA_DealerType,ProductLineName,DivisionName,DivisionCode
		
        SELECT * INTO #TMP_T2
        FROM #Result_T2
        WHERE ( ROWNUMBER BETWEEN ( ( @CurrentPageIndex - 1 ) * @PageSize )
                                    + 1
                            AND     ( @CurrentPageIndex - 1 ) * @PageSize
                                    + @PageSize )
                OR @CurrentPageIndex <= 0
                OR @PageSize < = 0 ;
                
        SELECT ROWNUMBER,ExportId,DMA_ID,DMA_ChineseName,ContractNo,ContractId,ContractType,DMA_DealerType,CreateDate,CreateUser,FileName,FileType,
        UploadFilePath,CASE CHARINDEX('~', SUBSTRING(FileSrcPath,1,1)) WHEN 1 THEN SUBSTRING(FileSrcPath,2,LEN(FileSrcPath)-1) ELSE  FileSrcPath END AS FileSrcPath,IsSinge,FileSrcName ,VersionStatus ,VersionNo,StatusName, IsSinge,SubProductName,DeptName,DivisionCode FROM #TMP_T2
		ORDER BY ROWNUMBER;
  
        SELECT COUNT(1) SumRow
        FROM #Result_T2;

		END
	ELSE IF (@DealerType = 'LP' OR @DealerType = 'LS')
      BEGIN
		INSERT INTO #ExportT2MaxDate(ContractId,CreateDate)
		SELECT ContractId,MAX(CreateDate) FROM Contract.ExportT2Main AA WHERE Status  ='submit' GROUP BY ContractId 
		INSERT INTO #ExportMaxDate(ContractId,CreateDate)
		SELECT ContractId,MAX(CreateDate) FROM Contract.ExportMain AA WHERE Status  ='submit' GROUP BY ContractId 

		SELECT A.ExportId, 
		D.DMA_ID,D.DMA_ChineseName,A.ContractNo,A.ContractId,A.ContractType,D.DMA_DealerType,V.DivisionName as SubProductName,V.ProductLineName as DeptName,V.DivisionCode,CONVERT(NVARCHAR(10),MAX(A.CreateDate),112)AS CreateDate,A.CreateUser,B.FileName,B.FileType,
		REPLACE(B.UploadFilePath,'\','/') AS UploadFilePath,
		REPLACE(SUBSTRING(B.UploadFilePath,1,LEN(B.UploadFilePath) - CHARINDEX('/',REVERSE(B.UploadFilePath))),'\','//') AS FileSrcPath,REVERSE(SUBSTRING(REVERSE(B.UploadFilePath),1,CHARINDEX('/',REVERSE(B.UploadFilePath))-1)) AS FileSrcName,
		C.VersionStatus,C.VersionNo,E.VALUE1 AS StatusName,CASE ISNULL(F.Id,'') WHEN '' THEN '0' ELSE '1' END IsSinge
		INTO #Result_LP
		FROM Contract.ExportT2Main A 
		INNER JOIN Contract.ExportSelectedTemplate B ON A.ExportId = B.ExportId 
		INNER JOIN V_DivisionProductLineRelation V ON V.DivisionCode=A.DeptId and v.IsEmerging='0'
		INNER JOIN Contract.ExportVersion C ON A.ExportId = C.ExportId
		INNER JOIN DealerMaster D ON A.DealerId =CAST(D.DMA_ID AS NVARCHAR(50))
		INNER JOIN Lafite_DICT  E ON C.VersionStatus = E.DICT_KEY AND E.DICT_TYPE = 'ContractElectronic'
		INNER JOIN #ExportT2MaxDate H ON H.ContractId=A.ContractId AND A.CreateDate=H.CreateDate
		LEFT JOIN Lafite_IDENTITY F ON C.CreateUser = F.Id AND (CONVERT(NVARCHAR(50),F.Corp_ID) = @DealerId OR @DealerId = 'All')
		WHERE A.Status ='submit' AND B.FileType = 'Finaldraft'
		AND (A.ContractNo = @ContractNo OR ISNULL(@ContractNo,'') = '')
		AND (C.VersionStatus = @Status OR ISNULL(@Status,'') = '')
		--AND A.CreateDate IN(SELECT MAX(CreateDate) FROM Contract.ExportT2Main AA WHERE Status  ='submit' AND AA.ContractId=A.ContractId GROUP BY ContractId )
		AND (@DealerId='All' OR A.DealerId = @DealerId) 
		AND A.CreateDate BETWEEN @StartTime and @EndTime
		AND (A.DeptId = @ProductLine OR @ProductLine = '')
		AND (D.DMA_Parent_DMA_ID = @CorpId OR DMA_ID = @CorpId)
		AND ((V.SubCompanyId = @SubCompanyId AND V.BrandId = @BrandId))
		GROUP BY D.DMA_ID,D.DMA_ChineseName,A.ContractNo,A.ContractId,A.CreateDate,A.CreateUser,B.FileName,B.FileType,A.ExportId,
		B.UploadFilePath,C.VersionNo,C.VersionStatus,E.VALUE1,F.Id,A.DeptNameEn,
		A.DeptName,A.ContractType,D.DMA_DealerType,ProductLineName,DivisionName,DivisionCode
		
		INSERT INTO #Result_LP
		SELECT A.ExportId, 
		D.DMA_ID,D.DMA_ChineseName,A.ContractNo,A.ContractId,A.ContractType,D.DMA_DealerType,SubProductName,A.DeptName,A.DeptId DivisionCode,CONVERT(NVARCHAR(10),MAX(A.CreateDate),112)AS CreateDate,A.CreateUser,B.FileName,B.FileType,
		REPLACE(B.UploadFilePath,'\','/') AS UploadFilePath,
		REPLACE(SUBSTRING(B.UploadFilePath,1,LEN(B.UploadFilePath) - CHARINDEX('/',REVERSE(B.UploadFilePath))),'\','//') AS FileSrcPath,REVERSE(SUBSTRING(REVERSE(B.UploadFilePath),1,CHARINDEX('/',REVERSE(B.UploadFilePath))-1)) AS FileSrcName,
		C.VersionStatus,C.VersionNo,E.VALUE1 AS StatusName,CASE ISNULL(F.Id,'') WHEN '' THEN '0' ELSE '1' END IsSinge
		FROM Contract.ExportMain A 
		INNER JOIN Contract.ExportSelectedTemplate B ON A.ExportId = B.ExportId 
		INNER JOIN Contract.ExportVersion C ON A.ExportId = C.ExportId
		INNER JOIN DealerMaster D ON A.DealerId =CAST( D.DMA_ID AS NVARCHAR(50))
		INNER JOIN Lafite_DICT  E ON C.VersionStatus = E.DICT_KEY AND E.DICT_TYPE = 'ContractElectronic'
		INNER JOIN #ExportMaxDate H ON H.ContractId=A.ContractId AND A.CreateDate=H.CreateDate
		LEFT JOIN Lafite_IDENTITY F ON CAST( C.CreateUser AS NVARCHAR(50)) = F.Id
		AND (CONVERT(NVARCHAR(50),F.Corp_ID) = @DealerId OR @DealerId = 'All')
		WHERE A.Status ='submit' AND B.FileType = 'Finaldraft'
		AND (A.ContractNo = @ContractNo OR ISNULL(@ContractNo,'') = '')
		AND (C.VersionStatus = @Status OR ISNULL(@Status,'') = '')
		--AND A.CreateDate IN(SELECT MAX(CreateDate) FROM Contract.ExportMain AA  WHERE Status  ='submit' AND AA.ContractId=A.ContractId GROUP BY ContractId )
		AND (@DealerId='All' OR A.DealerId = @DealerId) 
		--AND CONVERT(NVARCHAR(8),A.CreateDate,112) BETWEEN CONVERT(NVARCHAR(8), @StartTime,112) AND CONVERT(NVARCHAR(8), @EndTime,112)
		AND A.CreateDate BETWEEN @StartTime and @EndTime
		AND (A.DeptId = @ProductLine OR @ProductLine = '')
		GROUP BY D.DMA_ID,D.DMA_ChineseName,A.ContractNo,A.ContractId,A.CreateDate,A.CreateUser,B.FileName,B.FileType,A.ExportId,
		B.UploadFilePath,C.VersionNo,C.VersionStatus,E.VALUE1,F.Id,A.DeptNameEn,A.SubProductName,
		A.DeptName,A.ContractType,D.DMA_DealerType,A.DeptId

		--UPDATE #Result_LP SET ROWNUMBER = A.ROWNUMBER
		--FROM (SELECT ExportId,ROW_NUMBER() OVER(ORDER BY A.CreateDate DESC) AS ROWNUMBER FROM #Result_LP ) A
		--WHERE A.ExportId = #Result_LP.ExportId

        SELECT *,ROW_NUMBER() OVER(ORDER BY A.CreateDate DESC)AS ROWNUMBER INTO #TMP_LP
        FROM #Result_LP A
       
                
        SELECT ROWNUMBER,ExportId,DMA_ID,DMA_ChineseName,ContractNo,ContractId,ContractType,DMA_DealerType,CreateDate,CreateUser,FileName,FileType,
        UploadFilePath,CASE CHARINDEX('~', SUBSTRING(FileSrcPath,1,1)) WHEN 1 THEN SUBSTRING(FileSrcPath,2,LEN(FileSrcPath)-1) ELSE  FileSrcPath END AS FileSrcPath,IsSinge,FileSrcName ,VersionStatus ,VersionNo,StatusName, IsSinge,SubProductName,DeptName,DivisionCode 
		FROM #TMP_LP
		 WHERE ( ROWNUMBER BETWEEN ( ( @CurrentPageIndex - 1 ) * @PageSize )
                                    + 1
                            AND     ( @CurrentPageIndex - 1 ) * @PageSize
                                    + @PageSize )
                OR @CurrentPageIndex <= 0
                OR @PageSize < = 0 
		ORDER BY ROWNUMBER;
  
        SELECT COUNT(1) AS SumRow
        FROM #Result_LP;
      END
     ELSE
       BEGIN
	   	INSERT INTO #ExportMaxDate(ContractId,CreateDate)
		SELECT ContractId,MAX(CreateDate) FROM Contract.ExportMain AA WHERE Status  ='submit' GROUP BY ContractId 

         SELECT ROW_NUMBER() OVER(ORDER BY A.CreateDate DESC) AS ROWNUMBER,A.ExportId, 
		D.DMA_ID,D.DMA_ChineseName,A.ContractNo,A.ContractId,A.ContractType,D.DMA_DealerType,SubProductName,A.DeptName,V.DivisionCode,CONVERT(NVARCHAR(10),MAX(A.CreateDate),112)AS CreateDate,A.CreateUser,B.FileName,B.FileType,
		REPLACE(B.UploadFilePath,'\','/') AS UploadFilePath,
		REPLACE(SUBSTRING(B.UploadFilePath,1,LEN(B.UploadFilePath) - CHARINDEX('/',REVERSE(B.UploadFilePath))),'\','//') AS FileSrcPath,REVERSE(SUBSTRING(REVERSE(B.UploadFilePath),1,CHARINDEX('/',REVERSE(B.UploadFilePath))-1)) AS FileSrcName,
		C.VersionStatus,C.VersionNo,E.VALUE1 AS StatusName,CASE ISNULL(F.Id,'') WHEN '' THEN '0' ELSE '1' END IsSinge
		INTO #Result
		FROM Contract.ExportMain A 
		INNER JOIN Contract.ExportSelectedTemplate B ON A.ExportId = B.ExportId 
		INNER JOIN V_DivisionProductLineRelation V ON V.DivisionCode=A.DeptId and v.IsEmerging='0'
		INNER JOIN Contract.ExportVersion C ON A.ExportId = C.ExportId
		INNER JOIN DealerMaster D ON A.DealerId =CAST( D.DMA_ID AS NVARCHAR(50))
		INNER JOIN Lafite_DICT  E ON C.VersionStatus = E.DICT_KEY 	AND E.DICT_TYPE = 'ContractElectronic'
		INNER JOIN #ExportMaxDate H ON H.ContractId=A.ContractId AND A.CreateDate=H.CreateDate
		LEFT JOIN Lafite_IDENTITY F ON CAST( C.CreateUser AS NVARCHAR(50)) = F.Id
		AND (CONVERT(NVARCHAR(50),F.Corp_ID) = @DealerId OR @DealerId = 'All')
		WHERE A.Status ='submit' AND B.FileType = 'Finaldraft'
		AND (A.ContractNo = @ContractNo OR ISNULL(@ContractNo,'') = '')
		AND (C.VersionStatus = @Status OR ISNULL(@Status,'') = '')
		--AND A.CreateDate IN(SELECT MAX(CreateDate) FROM Contract.ExportMain WHERE Status  ='submit' GROUP BY ContractId )
		AND (@DealerId='All' OR A.DealerId = @DealerId) 
		AND A.CreateDate BETWEEN @StartTime AND @EndTime
		--AND CONVERT(NVARCHAR(10),A.CreateDate,112) >= CONVERT(NVARCHAR(10), CONVERT(DATETIME,@StartTime),112)
		--AND CONVERT(NVARCHAR(10),A.CreateDate,112) <= CONVERT(NVARCHAR(10), CONVERT(DATETIME,@EndTime),112)
		AND (A.DeptId = @ProductLine OR @ProductLine = '')
		AND ((V.SubCompanyId = @SubCompanyId AND V.BrandId = @BrandId))

		GROUP BY D.DMA_ID,D.DMA_ChineseName,A.ContractNo,A.ContractId,A.CreateDate,A.CreateUser,B.FileName,B.FileType,A.ExportId,
		B.UploadFilePath,C.VersionNo,C.VersionStatus,E.VALUE1,F.Id,A.DeptNameEn,A.SubProductName,
		A.DeptName,A.ContractType,D.DMA_DealerType,DivisionCode
     
        SELECT * INTO #TMP
        FROM #Result
        WHERE ( ROWNUMBER BETWEEN ( ( @CurrentPageIndex - 1 ) * @PageSize )
                                    + 1
                            AND     ( @CurrentPageIndex - 1 ) * @PageSize
                                    + @PageSize )
                OR @CurrentPageIndex <= 0
                OR @PageSize < = 0 ;
                
        SELECT ROWNUMBER,ExportId,DMA_ID,DMA_ChineseName,ContractNo,ContractId,ContractType,DMA_DealerType,CreateDate,CreateUser,FileName,FileType,
        UploadFilePath,CASE CHARINDEX('~', SUBSTRING(FileSrcPath,1,1)) WHEN 1 THEN SUBSTRING(FileSrcPath,2,LEN(FileSrcPath)-1) ELSE  FileSrcPath END AS FileSrcPath,IsSinge,FileSrcName ,VersionStatus ,VersionNo,StatusName, IsSinge,SubProductName,DeptName,DivisionCode FROM #TMP
		ORDER BY ROWNUMBER;
  
        SELECT COUNT(1) SumRow
        FROM #Result;
       
       
       
       END
      
	
       

    END;









