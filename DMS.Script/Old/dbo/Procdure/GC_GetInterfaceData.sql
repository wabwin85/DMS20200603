DROP Procedure [dbo].[GC_GetInterfaceData]
GO


/*
获取平台下载的日志信息
*/
Create Procedure [dbo].[GC_GetInterfaceData]
    @DataType nvarchar(500),
	@DataStatus nvarchar(20),
	@DealerId uniqueidentifier,
	@StareData nvarchar(10),
	@EndData nvarchar(10),
	@BatchNbr nvarchar(30),
	@OrderNo nvarchar(30),
	@start INT,
	@limit INT
AS
 DECLARE @SQL NVARCHAR(MAX)
 DECLARE @SQLCount NVARCHAR(MAX)
 DECLARE @STR NVARCHAR(MAX)
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
--临时表用于返回table
        create table #temp2
	    (
	    TotalCount int
	    )
	    create table #temp1
	    (
	    Id uniqueidentifier,
	    BatchNbr nvarchar(30),
	    RecordNbr  nvarchar(30),
	    HeaderId uniqueidentifier,
	    HeaderNo nvarchar(50),
	    [Status] nvarchar(30),
	    DataType nvarchar(50),
	    ProcessType nvarchar(50),
	    [FileName] nvarchar(50),
	    CreateUser uniqueidentifier,
	    CreateDate nvarchar(50),
	    UpdateUser uniqueidentifier,
	    UpdateDate nvarchar(50),
	    ClientId nvarchar(50),
	    DealerName nvarchar(50),
	    DealerCode nvarchar(30),
	    [row_number] int
	    )
	     
 --如果接口是获取平台订单和获取二级经销商订单
    SET @SQLCount='SELECT COUNT(*) ('
    SET @SQL=' SELECT * FROM ('
	 IF(@DataType='LpOrderDownloader' OR @DataType='T2OrderDownloader')
	    BEGIN
	    SET  @STR='  SELECT A.POI_ID AS Id,B.IL_BatchNbr AS BatchNbr ,A.POI_RecordNbr AS RecordNbr,A.POI_POH_ID AS HeaderId,A.POI_POH_OrderNo AS HeaderNo,A.POI_Status AS [Status],B.IL_Name AS DataType,A.POI_ProcessType AS ProcessType,
               B.IL_FileName AS [FileName],A.POI_CreateUser  AS CreateUser ,CONVERT(NVARCHAR(19), A.POI_CreateDate, 121) AS CreateDate,A.POI_UpdateUser AS UpdateUser,CONVERT(NVARCHAR(19), A.POI_UpdateDate, 121) AS UpdateDate, 
               B.IL_ClientID AS ClientId,D.DMA_ChineseName AS DealerName,D.DMA_SAP_Code AS DealerCode,row_number () OVER (ORDER BY IL_StartTime DESC) AS row_number FROM PurchaseOrderInterface A INNER JOIN InterfaceLog B
	          ON A.POI_BatchNbr=B.IL_BatchNbr INNER JOIN Client C ON C.CLT_ID=B.IL_ClientID INNER JOIN DealerMaster D
	          ON C.CLT_Corp_Id=D.DMA_ID WHERE 1=1  '
	         IF(@DataType<>'')
	          BEGIN
	           SET @STR=@STR + ' AND IL_Name='''+@DataType+'''';
	          END
	         IF(@DataStatus<>'')
	          BEGIN
	           SET @STR=@STR + ' AND A.POI_Status='''+@DataStatus+'''';
	          END
	         IF(@DealerId<>'00000000-0000-0000-0000-000000000000')
	          BEGIN
	           SET @STR=@STR +' AND D.DMA_ID='''+cast(@DealerId as varchar(100))+'''';
	          END
	          print @StareData
	         IF(@StareData<>'')
	          BEGIN
	           SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_StartTime, 112)>='''+@StareData+'''';
	          END 
	         IF(@EndData<>'')
	           BEGIN
	            SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_EndTime, 112)<='''+@EndData+'''';
	           END 
	          IF(@BatchNbr<>'')
	           BEGIN
	            SET @STR=@STR + ' AND B.IL_BatchNbr  LIKE ''%' +@BatchNbr+ '%''';
	           END 
	           IF(@OrderNo<>'')
	           BEGIN
	            SET @STR=@STR + ' AND A.POI_POH_OrderNo  LIKE ''%' +@OrderNo+ '%''';
	           END 
	    END
	    --如果是获取波科发货数据
	  IF(@DataType='SapDeliveryDownloader')
        BEGIN
           SET  @STR='           SELECT A.DI_ID AS Id,B.IL_BatchNbr AS BatchNbr ,A.DI_RecordNbr AS RecordNbr,NULL AS HeaderId,A.DI_SapDeliveryNo AS HeaderNo,A.DI_Status AS [Status],B.IL_Name AS DataType,A.DI_ProcessType AS ProcessType,
               B.IL_FileName AS [FileName],A.DI_CreateUser  AS CreateUser ,CONVERT(NVARCHAR(19), A.DI_CreateDate, 121) AS CreateDate,A.DI_UpdateUser AS UpdateUser,CONVERT(NVARCHAR(19), A.DI_UpdateDate, 121) AS UpdateDate, 
               B.IL_ClientID AS ClientId,D.DMA_ChineseName AS DealerName,D.DMA_SAP_Code AS DealerCode,row_number () OVER (ORDER BY IL_StartTime DESC) AS row_number FROM 
               DeliveryInterface A INNER JOIN InterfaceLog B
	          ON A.DI_BatchNbr=B.IL_BatchNbr INNER JOIN Client C ON C.CLT_ID=B.IL_ClientID INNER JOIN DealerMaster D
	          ON C.CLT_Corp_Id=D.DMA_ID WHERE 1=1  '
	         IF(@DataType<>'')
	          BEGIN
	           SET @STR=@STR + ' AND IL_Name='''+@DataType+'''';
	          END
	         IF(@DataStatus<>'')
	          BEGIN
	           SET @STR=@STR + ' AND A.DI_Status='''+@DataStatus+'''';
	          END
	         IF(@DealerId<>'00000000-0000-0000-0000-000000000000')
	          BEGIN
	           SET @STR=@STR +' AND D.DMA_ID='''+cast(@DealerId as varchar(100))+'''';
	          END
	          print @StareData
	         IF(@StareData<>'')
	          BEGIN
	           SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_StartTime, 112)>='''+@StareData+'''';
	          END 
	         IF(@EndData<>'')
	           BEGIN
	            SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_EndTime, 112)<='''+@EndData+'''';
	           END 
	         IF(@BatchNbr<>'')
	           BEGIN
	            SET @STR=@STR + ' AND B.IL_BatchNbr  LIKE ''%' +@BatchNbr+ '%''';
	           END 
	         IF(@OrderNo<>'')
	           BEGIN
	            SET @STR=@STR + ' AND A.DI_SapDeliveryNo  LIKE ''%' +@OrderNo+ '%''';
	           END  
        END
        --如果是获取经销商寄售产品
        IF(@DataType='T2ConsignmentSalesDownloader')
          BEGIN
            SET  @STR='       SELECT A.SI_ID AS Id,B.IL_BatchNbr AS BatchNbr ,A.SI_RecordNbr AS RecordNbr,NULL AS HeaderId,A.SI_SPH_ShipmentNbr AS HeaderNo,A.SI_Status AS [Status],B.IL_Name AS DataType,A.SI_ProcessType AS ProcessType,
               B.IL_FileName AS [FileName],A.SI_CreateUser  AS CreateUser ,CONVERT(NVARCHAR(19), A.SI_CreateDate, 121) AS CreateDate,A.SI_UpdateUser AS UpdateUser,CONVERT(NVARCHAR(19), A.SI_UpdateDate, 121) AS UpdateDate, 
               B.IL_ClientID AS ClientId,D.DMA_ChineseName AS DealerName,D.DMA_SAP_Code AS DealerCode,row_number () OVER (ORDER BY IL_StartTime DESC) AS row_number FROM 
               SalesInterface A INNER JOIN InterfaceLog B
	          ON A.SI_BatchNbr=B.IL_BatchNbr INNER JOIN Client C ON C.CLT_ID=B.IL_ClientID INNER JOIN DealerMaster D
	          ON C.CLT_Corp_Id=D.DMA_ID WHERE 1=1  '
	         IF(@DataType<>'')
	          BEGIN
	           SET @STR=@STR + ' AND IL_Name='''+@DataType+'''';
	          END
	         IF(@DataStatus<>'')
	          BEGIN
	           SET @STR=@STR + ' AND A.SI_Status='''+@DataStatus+'''';
	          END
	         IF(@DealerId<>'00000000-0000-0000-0000-000000000000')
	          BEGIN
	           SET @STR=@STR +' AND D.DMA_ID='''+cast(@DealerId as varchar(100))+'''';
	          END
	          print @StareData
	         IF(@StareData<>'')
	          BEGIN
	           SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_StartTime, 112)>='''+@StareData+'''';
	          END 
	         IF(@EndData<>'')
	           BEGIN
	            SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_EndTime, 112)<='''+@EndData+'''';
	           END 
	         IF(@BatchNbr<>'')
	           BEGIN
	            SET @STR=@STR + ' AND B.IL_BatchNbr  LIKE ''%' +@BatchNbr+ '%''';
	           END 
	         IF(@OrderNo<>'')
	           BEGIN
	            SET @STR=@STR + ' AND A.SI_SPH_ShipmentNbr  LIKE ''%' +@OrderNo+ '%''';
	           END  
          END
          --如果是 LP退货数据下载或二级经销商退货数据下载或如果是二级经销商寄售转销售数据接口  
          IF(@DataType='LpReturnDownloader' OR @DataType='T2ReturnDownloader' OR @DataType='T2ConsignToSellingDownloader')
              BEGIN
                SET  @STR='     SELECT A.AI_ID AS Id,B.IL_BatchNbr AS BatchNbr ,A.AI_RecordNbr AS RecordNbr,NULL AS HeaderId,A.AI_IAH_AdjustNo AS HeaderNo,A.AI_Status AS [Status],B.IL_Name AS DataType,A.AI_ProcessType AS ProcessType,
               B.IL_FileName AS [FileName],A.AI_CreateUser  AS CreateUser ,CONVERT(NVARCHAR(19), A.AI_CreateDate, 121) AS CreateDate,A.AI_UpdateUser AS UpdateUser,CONVERT(NVARCHAR(19), A.AI_UpdateDate, 121) AS UpdateDate, 
               B.IL_ClientID AS ClientId,D.DMA_ChineseName AS DealerName,D.DMA_SAP_Code AS DealerCode,row_number () OVER (ORDER BY IL_StartTime DESC) AS row_number FROM 
               AdjustInterface A INNER JOIN InterfaceLog B
	          ON A.AI_BatchNbr=B.IL_BatchNbr INNER JOIN Client C ON C.CLT_ID=B.IL_ClientID INNER JOIN DealerMaster D
	          ON C.CLT_Corp_Id=D.DMA_ID WHERE 1=1  '
	         IF(@DataType<>'')
	          BEGIN
	           SET @STR=@STR + ' AND IL_Name='''+@DataType+'''';
	          END
	         IF(@DataStatus<>'')
	          BEGIN
	           SET @STR=@STR + ' AND A.AI_Status='''+@DataStatus+'''';
	          END
	         IF(@DealerId<>'00000000-0000-0000-0000-000000000000')
	          BEGIN
	           SET @STR=@STR +' AND D.DMA_ID='''+cast(@DealerId as varchar(100))+'''';
	          END
	          print @StareData
	         IF(@StareData<>'')
	          BEGIN
	           SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_StartTime, 112)>='''+@StareData+'''';
	          END 
	         IF(@EndData<>'')
	           BEGIN
	            SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_EndTime, 112)<='''+@EndData+'''';
	           END 
	         IF(@BatchNbr<>'')
	           BEGIN
	            SET @STR=@STR + ' AND B.IL_BatchNbr  LIKE ''%' +@BatchNbr+ '%''';
	           END 
	         IF(@OrderNo<>'')
	           BEGIN
	            SET @STR=@STR + ' AND A.AI_IAH_AdjustNo  LIKE ''%' +@OrderNo+ '%''';
	           END  
              END
            --如果是平台ERP投诉数据接口
            IF(@DataType='LpComplainDownloader')
              BEGIN
              
                SET  @STR='     SELECT A.CI_ID AS Id,B.IL_BatchNbr AS BatchNbr ,A.CI_RecordNbr AS RecordNbr,NULL AS HeaderId,A.CI_POH_OrderNo AS HeaderNo,A.CI_Status AS [Status],B.IL_Name AS DataType,A.CI_ProcessType AS ProcessType,
               B.IL_FileName AS [FileName],A.CI_CreateUser  AS CreateUser ,CONVERT(NVARCHAR(19), A.CI_CreateDate, 121) AS CreateDate,A.CI_UpdateUser AS UpdateUser,CONVERT(NVARCHAR(19), A.CI_UpdateDate, 121) AS UpdateDate, 
               B.IL_ClientID AS ClientId,D.DMA_ChineseName AS DealerName,D.DMA_SAP_Code AS DealerCode,row_number () OVER (ORDER BY IL_StartTime DESC) AS row_number FROM 
               ComplainInterface A INNER JOIN InterfaceLog B
	          ON A.CI_BatchNbr=B.IL_BatchNbr INNER JOIN Client C ON C.CLT_ID=B.IL_ClientID INNER JOIN DealerMaster D
	          ON C.CLT_Corp_Id=D.DMA_ID WHERE 1=1 '
	         IF(@DataType<>'')
	          BEGIN
	           SET @STR=@STR + ' AND IL_Name='''+@DataType+'''';
	          END
	         IF(@DataStatus<>'')
	          BEGIN
	           SET @STR=@STR + ' AND A.CI_Status='''+@DataStatus+'''';
	          END
	         IF(@DealerId<>'00000000-0000-0000-0000-000000000000')
	          BEGIN
	           SET @STR=@STR +' AND D.DMA_ID='''+cast(@DealerId as varchar(100))+'''';
	          END
	          print @StareData
	         IF(@StareData<>'')
	          BEGIN
	           SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_StartTime, 112)>='''+@StareData+'''';
	          END 
	         IF(@EndData<>'')
	           BEGIN
	            SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_EndTime, 112)<='''+@EndData+'''';
	           END 
	         IF(@BatchNbr<>'')
	           BEGIN
	            SET @STR=@STR + ' AND B.IL_BatchNbr  LIKE ''%' +@BatchNbr+ '%''';
	           END 
	         IF(@OrderNo<>'')
	           BEGIN
	            SET @STR=@STR + ' AND A.CI_POH_OrderNo  LIKE ''%' +@OrderNo+ '%''';
	           END  
              END  
             
            --如果是二级经销商寄售转销售数据接口  
          --  IF(@DataType='T2ConsignToSellingDownloader')
          --     BEGIN
            
          --      SET  @STR='      SELECT A.AI_ID AS Id,B.IL_BatchNbr AS BatchNbr ,A.AI_BatchNbr AS RecordNbr,NULL AS HeaderId,A.AI_IAH_AdjustNo AS HeaderNo,A.AI_Status AS [Status],B.IL_Name AS DataType,A.AI_ProcessType AS ProcessType,
          --     B.IL_FileName AS [FileName],A.AI_CreateUser  AS CreateUser ,CONVERT(NVARCHAR(19), A.AI_CreateDate, 121) AS CreateDate,A.AI_UpdateUser AS UpdateUser,CONVERT(NVARCHAR(19), A.AI_UpdateDate, 121) AS UpdateDate, 
          --     B.IL_ClientID AS ClientId,D.DMA_ChineseName AS DealerName,D.DMA_SAP_Code AS DealerCode,row_number () OVER (ORDER BY IL_StartTime DESC) AS row_number FROM 
          --     AdjustInterface A INNER JOIN InterfaceLog B
	         -- ON A.AI_BatchNbr=B.IL_BatchNbr INNER JOIN Client C ON C.CLT_ID=B.IL_ClientID INNER JOIN DealerMaster D
	         -- ON C.CLT_Corp_Id=D.DMA_ID WHERE 1=1 '
	         --IF(@DataType<>'')
	         -- BEGIN
	         --  SET @STR=@STR + ' AND IL_Name='''+@DataType+'''';
	         -- END
	           
	         --IF(@DataStatus<>'')
	         -- BEGIN
	         --  SET @STR=@STR + ' AND IL_Status='''+@DataStatus+'''';
	         -- END
	          
	         --IF(@DealerId <>'00000000-0000-0000-0000-000000000000')
	         -- BEGIN
	           
	         --  SET @STR=@STR +' AND D.DMA_ID='''+cast(@DealerId as varchar(100))+'''';
	         -- END
	         -- print @StareData
	         --IF(@StareData<>'')
	         -- BEGIN
	         --  SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_StartTime, 112)>='''+@StareData+'''';
	         -- END 
	         --IF(@EndData<>'')
	         --  BEGIN
	         --   SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_EndTime, 112)<='''+@EndData+'''';
	         --  END 
	         --IF(@BatchNbr<>'')
	         --  BEGIN
	         --   SET @STR=@STR + ' AND B.IL_BatchNbr  LIKE ''%' +@BatchNbr+ '%''';
	         --  END 
	         --IF(@OrderNo<>'')
	         --  BEGIN
	         --   SET @STR=@STR + ' AND A.AI_IAH_AdjustNo  LIKE ''%' +@OrderNo+ '%''';
	         --  END  
          --    END
             --如果是平台下载借货入库数据
            IF(@DataType='LpRentDownloader') 
              BEGIN
                 SET  @STR='        	          SELECT A.LRI_ID AS Id,B.IL_BatchNbr AS BatchNbr ,A.LRI_RecordNbr AS RecordNbr,E.TRN_ID AS HeaderId,E.TRN_TransferNumber AS HeaderNo,A.LRI_Status AS [Status],B.IL_Name AS DataType,A.LRI_ProcessType AS ProcessType,
               B.IL_FileName AS [FileName],A.LRI_CreateUser  AS CreateUser ,CONVERT(NVARCHAR(19), A.LRI_CreateDate, 121) AS CreateDate,A.LRI_UpdateUser AS UpdateUser,CONVERT(NVARCHAR(19), A.LRI_UpdateDate, 121) AS UpdateDate, 
               B.IL_ClientID AS ClientId,D.DMA_ChineseName AS DealerName,D.DMA_SAP_Code AS DealerCode,row_number () OVER (ORDER BY IL_StartTime DESC) AS row_number FROM 
               LpRentInterface A INNER JOIN InterfaceLog B
	          ON A.LRI_BatchNbr=B.IL_BatchNbr INNER JOIN Client C ON C.CLT_ID=B.IL_ClientID INNER JOIN DealerMaster D
	          ON C.CLT_Corp_Id=D.DMA_ID INNER JOIN Transfer E ON A.LRI_TranferID=E.TRN_ID WHERE 1=1 '
	         IF(@DataType<>'')
	          BEGIN
	           SET @STR=@STR + ' AND IL_Name='''+@DataType+'''';
	          END
	           
	         IF(@DataStatus<>'')
	          BEGIN
	           SET @STR=@STR + ' AND A.LRI_Status='''+@DataStatus+'''';
	          END
	          
	         IF(@DealerId <>'00000000-0000-0000-0000-000000000000')
	          BEGIN
	           
	           SET @STR=@STR +' AND D.DMA_ID='''+cast(@DealerId as varchar(100))+'''';
	          END
	          print @StareData
	         IF(@StareData<>'')
	          BEGIN
	           SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_StartTime, 112)>='''+@StareData+'''';
	          END 
	         IF(@EndData<>'')
	           BEGIN
	            SET @STR=@STR + ' AND CONVERT(NVARCHAR(10), B.IL_EndTime, 112)<='''+@EndData+'''';
	           END 
	         IF(@BatchNbr<>'')
	           BEGIN
	            SET @STR=@STR + ' AND B.IL_BatchNbr  LIKE ''%' +@BatchNbr+ '%''';
	           END 
	         IF(@OrderNo<>'')
	           BEGIN
	            SET @STR=@STR + ' AND E.TRN_TransferNumber  LIKE ''%' +@OrderNo+ '%''';
	           END  
              END
       SET @SQL=' SELECT *  FROM ('+@STR;
       SET @SQL=@SQL+') TB ';
       SET @SQLCount=' SELECT COUNT(*) as totalCount  FROM ('+@STR;
       SET @SQLCount=@SQLCount+') TB ';
       
       SET @SQL=@SQL+' WHERE TB.[row_number]>'+''''+cast(@start as varchar)+''''

       SET @SQL=@SQL+'AND [row_number]<='+''''+cast(@start+@limit as varchar)+'''';
                     print @SQL;
       insert into #temp1
        EXEC(@SQL);
       insert into #temp2
       EXEC(@SQLCount);
       PRINT @SQL
       select * from #temp1
       select * from #temp2
      

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    return -1
    
END CATCH


GO


