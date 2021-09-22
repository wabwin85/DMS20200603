USE [BSC_DMS140717]
GO
/****** Object:  StoredProcedure [Contract].[Proc_GetContractList]    Script Date: 01/23/2018 18:30:47 ******/
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
      @StartTime NVARCHAR(50) ,
      @EndTime NVARCHAR(50) ,
      @ProductLine NVARCHAR(50),
      @CurrentPageIndex INT = 0 ,
      @PageSize INT = 0
    )
AS
    BEGIN  
   
    
   SELECT  ROW_NUMBER() OVER(ORDER BY A.CreateDate DESC) AS ROWNUMBER,A.ExportId, 
   D.DMA_ID,D.DMA_ChineseName,A.ContractNo,A.ContractId,A.SubProductName,A.DeptName,CONVERT(NVARCHAR(10),MAX(A.CreateDate),112)AS CreateDate,A.CreateUser,B.FileName,B.FileType,
     replace(B.UploadFilePath,'\','/')  as UploadFilePath, 
      replace(SUBSTRING(B.UploadFilePath,1,len(B.UploadFilePath)- CHARINDEX('/',REVERSE(B.UploadFilePath))),'\','//') as FileSrcPath,REVERSE(SUBSTRING(REVERSE(B.UploadFilePath),1,CHARINDEX('/',REVERSE(B.UploadFilePath))-1)) as FileSrcName,
     C.VersionStatus,C.VersionNo,E.VALUE1 AS StatusName,CASE ISNULL(F.Id,'') WHEN '' THEN '0' ELSE '1' END IsSinge
     INTO  #Result
      FROM Contract.ExportMain A INNER JOIN Contract.ExportSelectedTemplate B
     ON A.ExportId=B.ExportId INNER JOIN Contract.ExportVersion C ON A.ExportId=C.ExportId
     INNER JOIN DealerMaster D ON A.DealerId=D.DMA_ID
     INNER JOIN Lafite_DICT  E ON C.VersionStatus=E.DICT_KEY
     LEFT JOIN Lafite_IDENTITY F ON C.CreateUser=F.Id
     AND (CONVERT(NVARCHAR(50),F.Corp_ID) =@DealerId or @DealerId='All')
     AND E.DICT_TYPE='ContractElectronic'
     WHERE A.Status='submit' AND B.FileType='Finaldraft' AND 
      E.DICT_TYPE='ContractElectronic'
      AND (A.ContractNo=@ContractNo OR ISNULL(@ContractNo,'')='')
      AND (C.VersionStatus=@Status OR ISNULL(@Status,'')='')
      AND A.CreateDate IN(SELECT MAX(CreateDate) FROM Contract.ExportMain where Status='submit' GROUP BY ContractId )
     AND (@DealerId='All' or A.DealerId=@DealerId) AND CONVERT(NVARCHAR(10),A.CreateDate,112) >=CONVERT(NVARCHAR(10), CONVERT(DATETIME,@StartTime),112)
     AND CONVERT(NVARCHAR(10),A.CreateDate,112) <=CONVERT(NVARCHAR(10), CONVERT(DATETIME,@EndTime),112)
     AND (A.DeptId=@ProductLine OR @ProductLine='')
     GROUP BY D.DMA_ID,D.DMA_ChineseName,A.ContractNo,A.ContractId,A.CreateDate,A.CreateUser,B.FileName,B.FileType,A.ExportId,
     B.UploadFilePath,C.VersionNo,C.VersionStatus,E.VALUE1,F.Id,
     A.SubProductName,A.DeptName
     
        SELECT  * INTO #TMP
        FROM    #Result
        WHERE   ( ROWNUMBER BETWEEN ( ( @CurrentPageIndex - 1 ) * @PageSize )
                                    + 1
                            AND     ( @CurrentPageIndex - 1 ) * @PageSize
                                    + @PageSize )
                OR @CurrentPageIndex <= 0
                OR @PageSize < = 0 ;
                
        SELECT ROWNUMBER,ExportId,DMA_ID,DMA_ChineseName,ContractNo,ContractId,CreateDate,CreateUser,FileName,FileType,
        UploadFilePath,CASE CHARINDEX('~', SUBSTRING(FileSrcPath,1,1)) WHEN 1 THEN SUBSTRING(FileSrcPath,2,LEN(FileSrcPath)-1) ELSE  FileSrcPath END AS FileSrcPath,IsSinge,FileSrcName ,VersionStatus ,VersionNo,StatusName, IsSinge,SubProductName,DeptName FROM #TMP
		ORDER BY ROWNUMBER;
  
        SELECT  COUNT(1)
        FROM    #Result;
       

    END;








