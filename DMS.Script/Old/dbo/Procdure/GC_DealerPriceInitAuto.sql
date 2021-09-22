DROP PROCEDURE [dbo].[GC_DealerPriceInitAuto]
GO

/*
经销商价格导入定时处理程序
*/
CREATE PROCEDURE [dbo].[GC_DealerPriceInitAuto]
  @RtnVal NVARCHAR(20) OUTPUT,
  @RtnMsg NVARCHAR(MAX) OUTPUT
	
AS
	SET NOCOUNT ON
	
	BEGIN TRY
		BEGIN TRAN
		
    CREATE TABLE #DealerPriceInitShortUPN(
			[DPI_ID] [uniqueidentifier] NOT NULL,
      [DPI_DPH_ID] [uniqueidentifier] NOT NULL,
			[DPI_USER] [uniqueidentifier] NOT NULL,
			[DPI_UploadDate] [datetime] NOT NULL,
			[DPI_LineNbr] [int] NOT NULL,
			[DPI_FileName] [nvarchar](200) collate Chinese_PRC_CI_AS NOT NULL,
			[DPI_ErrorFlag] [bit] NULL,
			[DPI_ErrorDescription] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_LP_ID] [uniqueidentifier] NOT NULL,
			[DPI_ArticleNumber] [nvarchar](30) collate Chinese_PRC_CI_AS NULL,
			[DPI_ArticleNumber_ErrMsg] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_CFN_ID] [uniqueidentifier] NULL,
			[DPI_Dealer] [nvarchar](50) collate Chinese_PRC_CI_AS NULL,
			[DPI_Dealer_ErrMsg] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_DMA_ID] [uniqueidentifier] NULL,
			[DPI_Price] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_Price_ErrMsg] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_PriceTypeName] [nvarchar](20) collate Chinese_PRC_CI_AS NULL,
			[DPI_PriceTypeName_ErrMsg] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_PriceType] [nvarchar](20) collate Chinese_PRC_CI_AS NULL
	    )
    
		CREATE TABLE #DealerPriceInit(
			[DPI_ID] [uniqueidentifier] NOT NULL,
      [DPI_DPH_ID] [uniqueidentifier] NOT NULL,
			[DPI_USER] [uniqueidentifier] NOT NULL,
			[DPI_UploadDate] [datetime] NOT NULL,
			[DPI_LineNbr] [int] NOT NULL,
			[DPI_FileName] [nvarchar](200) collate Chinese_PRC_CI_AS NOT NULL,
			[DPI_ErrorFlag] [bit] NULL,
			[DPI_ErrorDescription] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_LP_ID] [uniqueidentifier] NOT NULL,
			[DPI_ArticleNumber] [nvarchar](30) collate Chinese_PRC_CI_AS NULL,
			[DPI_ArticleNumber_ErrMsg] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_CFN_ID] [uniqueidentifier] NULL,
			[DPI_Dealer] [nvarchar](50) collate Chinese_PRC_CI_AS NULL,
			[DPI_Dealer_ErrMsg] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_DMA_ID] [uniqueidentifier] NULL,
			[DPI_Price] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_Price_ErrMsg] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_PriceTypeName] [nvarchar](20) collate Chinese_PRC_CI_AS NULL,
			[DPI_PriceTypeName_ErrMsg] [nvarchar](100) collate Chinese_PRC_CI_AS NULL,
			[DPI_PriceType] [nvarchar](20) collate Chinese_PRC_CI_AS NULL
	    )
	  
    CREATE TABLE #ProcessingPrice(			
      [DPH_ID] [uniqueidentifier] NOT NULL,
      [DPH_Status] nvarchar(50) COLLATE Chinese_PRC_CI_AS NULL
	    )
      
    INSERT INTO #ProcessingPrice
     SELECT DPH_ID, H.DPH_Status
      FROM DealerPriceHead H(nolock)
     WHERE H.DPH_Status is Null 
      AND H.DPH_UploadDate>'2018-10-16'
    
   
    UPDATE PP set PP.DPH_Status = 'Processing'
      FROM #ProcessingPrice PP,DealerPriceHead H(nolock)
     WHERE H.DPH_Status is Null 
      AND H.DPH_UploadDate>'2018-10-16'
      AND H.DPH_ID = PP.DPH_ID
      AND Exists (select 1 from DealerPriceDetail(nolock) where DPD_DPH_ID = H.DPH_ID
                    group by DPD_DPH_ID having count(*) = H.DPH_RowNum) 
    
    SELECT * FROM #ProcessingPrice
    
    DECLARE @dphId uniqueidentifier
	    
		--查询当前未处理的接口数据，然后遍历进行处理
    Declare curPriceApply CURSOR FOR
    SELECT DPH_ID 
      FROM #ProcessingPrice WHERE DPH_Status is not null
    
    OPEN curPriceApply FETCH NEXT FROM curPriceApply INTO @dphId
    
    WHILE @@FETCH_STATUS = 0
    	BEGIN
    		DELETE FROM #DealerPriceInit
        DELETE FROM #DealerPriceInitShortUPN
        
        --写入数据（短编号）
        insert into #DealerPriceInitShortUPN(DPI_ID,DPI_DPH_ID,DPI_USER,DPI_UploadDate,DPI_LineNbr,DPI_FileName,DPI_ErrorFlag,
                                     DPI_ErrorDescription,DPI_LP_ID,DPI_ArticleNumber,DPI_ArticleNumber_ErrMsg,
                                     DPI_CFN_ID,DPI_Dealer,DPI_Dealer_ErrMsg,DPI_DMA_ID,DPI_Price,DPI_Price_ErrMsg,
                                     DPI_PriceTypeName,DPI_PriceTypeName_ErrMsg,DPI_PriceType)
        SELECT D.DPD_ID, H.DPH_ID ,H.DPH_USER,H.DPH_UploadDate,D.DPD_LineNbr,'Interface',null,null,H.DPH_LP,D.DPD_ArticleNumber,null,null As CFN_ID,D.DPD_Dealer,null AS DPI_Dealer_ErrMsg,null AS DPI_DMA_ID,DPD_Price,null AS DPI_Price_ErrMsg,
               D.DPD_PriceTypeName,null AS DPI_PriceTypeName_ErrMsg,null AS DPI_PriceType
        from DealerPriceHead H(nolock), DealerPriceDetail D(nolock)
        where H.DPH_ID = D.DPD_DPH_ID and H.DPH_ID=@dphId
        
        --转换为正式数据（标准UPN）
        INSERT INTO #DealerPriceInit
        SELECT DPI_ID,DPI_DPH_ID,DPI_USER,DPI_UploadDate,DPI_LineNbr,DPI_FileName,DPI_ErrorFlag,
               DPI_ErrorDescription,DPI_LP_ID,isnull(C.CFN_CustomerFaceNbr,T.DPI_ArticleNumber) ,DPI_ArticleNumber_ErrMsg,
               DPI_CFN_ID,DPI_Dealer,DPI_Dealer_ErrMsg,DPI_DMA_ID,DPI_Price,DPI_Price_ErrMsg,
               DPI_PriceTypeName,DPI_PriceTypeName_ErrMsg,DPI_PriceType
          FROM #DealerPriceInitShortUPN AS T LEFT JOIN CFN AS C(nolock) ON (T.DPI_ArticleNumber=C.CFN_Property1 ) 
        
        /* 数据校验  */
        BEGIN
        /*先将错误标志设为0*/
        UPDATE #DealerPriceInit
           SET DPI_ErrorFlag = 0,
               DPI_ArticleNumber_ErrMsg = '',
               DPI_Dealer_ErrMsg = '',
               DPI_Price_ErrMsg = '',
               DPI_PriceTypeName_ErrMsg = ''

        --WHERE  DPI_USER = @UserId;

        --检查产品是否存在
        UPDATE #DealerPriceInit
           SET DPI_CFN_ID = CFN_ID
          FROM CFN(nolock)
         WHERE CFN_CustomerFaceNbr = DPI_ArticleNumber

        UPDATE #DealerPriceInit
           SET DPI_ErrorFlag = 1,
               DPI_ArticleNumber_ErrMsg =
                  DPI_ArticleNumber_ErrMsg + N'产品不存在,'
         WHERE DPI_CFN_ID IS NULL


        --检查经销商是否存在
        UPDATE A
           SET A.DPI_DMA_ID = B.DMA_ID
          FROM #DealerPriceInit A, DealerMaster B (NOLOCK)
         WHERE     A.DPI_Dealer = B.DMA_SAP_Code
               AND B.DMA_Parent_DMA_ID = A.DPI_LP_ID            
               AND ISNULL (A.DPI_Dealer, '') <> '';

        UPDATE #DealerPriceInit
           SET DPI_ErrorFlag = 1,
               DPI_Dealer_ErrMsg = DPI_Dealer_ErrMsg + N'经销商不存在,'
         WHERE     ISNULL (DPI_Dealer, '') <> ''
               AND DPI_DMA_ID IS NULL
              
        --检查价格格式（OpenAPI进行校验）
        UPDATE #DealerPriceInit
           SET DPI_ErrorFlag = 1,
               DPI_Price_ErrMsg = DPI_Price_ErrMsg + N'价格格式不正确,'
         WHERE ISNUMERIC (DPI_Price) = 0 
         
        
        --检查价格（必须大于等于0）
        UPDATE #DealerPriceInit
           SET DPI_ErrorFlag = 1,
               DPI_Price_ErrMsg = DPI_Price_ErrMsg + N'价格必须大于等于0,'
         WHERE     ISNUMERIC (DPI_Price) = 1
               AND CONVERT (DECIMAL, DPI_Price) < 0
            

        --检查类型是否存在
        UPDATE A
           SET A.DPI_PriceType = B.DICT_KEY
          FROM #DealerPriceInit A, Lafite_DICT B (NOLOCK)
         WHERE     A.DPI_PriceTypeName = B.VALUE1
               AND B.DICT_TYPE = 'CONST_CFN_PriceType'
          

        UPDATE #DealerPriceInit
           SET DPI_ErrorFlag = 1,
               DPI_PriceTypeName_ErrMsg =
               DPI_PriceTypeName_ErrMsg + N'类型不正确,'
         WHERE DPI_PriceType IS NULL 
       

        --检查是否重复
        UPDATE A
           SET A.DPI_ErrorFlag = 1,
               A.DPI_ArticleNumber_ErrMsg = A.DPI_ArticleNumber_ErrMsg + N'[产品型号]+[经销商]+[类型]有重复,'
          FROM #DealerPriceInit A,
               (SELECT T.DPI_ArticleNumber,
                       T.DPI_Dealer,
                       T.DPI_PriceTypeName,
                       COUNT (*) CNT
                  FROM #DealerPriceInit T                 
                GROUP BY T.DPI_ArticleNumber, T.DPI_Dealer, T.DPI_PriceTypeName) B
         WHERE     A.DPI_ArticleNumber = B.DPI_ArticleNumber
               AND A.DPI_Dealer = B.DPI_Dealer
               AND A.DPI_PriceTypeName = B.DPI_PriceTypeName
               AND B.CNT > 1
		    
        END
        
        
    		--检查是否存在错误
    		IF ( SELECT COUNT(*)	FROM #DealerPriceInit	WHERE DPI_ErrorFlag = 1 ) > 0
    		BEGIN
    		    /*如果存在错误，则返回Error*/
    		    SET @RtnVal = 'Failure'
            UPDATE #ProcessingPrice SET DPH_Status = 'Failure'  WHERE DPH_ID = @dphId  
            
            INSERT INTO dbo.DealerPriceInitLog SELECT *,getdate() FROM #DealerPriceInit 
            
    		END
    		ELSE
    		BEGIN
    		    /*如果不存在错误，则返回Success*/		
    		    SET @RtnVal = 'Success'

    		    /* 更新价格表 */
            BEGIN
   		        
    		        DECLARE @Now DATETIME;
    		        SET @Now = GETDATE();
    		        
    		        DELETE A
    		        FROM   CFNPrice A
    		        WHERE  EXISTS (	SELECT 1
    		                	      	FROM   #DealerPriceInit B,
    		                	      	       DealerMaster C(NOLOCK)
    		                	      	WHERE      B.DPI_LP_ID = C.DMA_Parent_DMA_ID
    		                	      	       AND B.DPI_DMA_ID IS NULL
    		                	      	       AND A.CFNP_CFN_ID = B.DPI_CFN_ID
    		                	      	       AND A.CFNP_Group_ID = C.DMA_ID
    		                	      	       AND A.CFNP_PriceType = B.DPI_PriceType );
    		        
    		        INSERT INTO CFNPrice
    		        SELECT NEWID(),
    		               A.DPI_CFN_ID,
    		               A.DPI_PriceType,
    		               C.DMA_ID,
    		               1,
    		               CONVERT(DECIMAL(18, 6), A.DPI_Price),
    		               CONVERT(DECIMAL(18, 6), A.DPI_Price),
    		               'CNY',
    		               '盒',
    		               NULL,
    		               NULL,
    		               NULL,
    		               '00000000-0000-0000-0000-000000000000',
    		               @Now,
    		               NULL,
    		               NULL,
    		               0
    		        FROM   #DealerPriceInit A,
    		               CFN B(NOLOCK),
    		               DealerMaster C(NOLOCK),
    		               (select distinct DAT_DMA_ID, DAT_ProductLine_BUM_ID from DealerAuthorizationTable(NOLOCK)) D
    		        WHERE  A.DPI_DMA_ID IS NULL
    		               AND A.DPI_CFN_ID = B.CFN_ID
    		               AND A.DPI_LP_ID = C.DMA_Parent_DMA_ID
    		               AND C.DMA_ID = D.DAT_DMA_ID
    		               AND B.CFN_ProductLine_BUM_ID = D.DAT_ProductLine_BUM_ID    		             
    		               AND CONVERT(DECIMAL, A.DPI_Price) > 0;
    		        
    		        
    		        
    		        DELETE A
    		        FROM   CFNPrice A
    		        WHERE  EXISTS (	SELECT 1
    		                	      	FROM   #DealerPriceInit B
    		                	      	WHERE      B.DPI_DMA_ID IS NOT NULL
    		                	      	       AND A.CFNP_CFN_ID = B.DPI_CFN_ID
    		                	      	       AND A.CFNP_Group_ID = B.DPI_DMA_ID
    		                	      	       AND A.CFNP_PriceType = B.DPI_PriceType );
    		        
    		        INSERT INTO CFNPrice
    		        SELECT NEWID(),
    		               A.DPI_CFN_ID,
    		               A.DPI_PriceType,
    		               A.DPI_DMA_ID,
    		               1,
    		               CONVERT(DECIMAL(18, 6), A.DPI_Price),
    		               CONVERT(DECIMAL(18, 6), A.DPI_Price),
    		               'CNY',
    		               '盒',
    		               NULL,
    		               NULL,
    		               NULL,
    		               '00000000-0000-0000-0000-000000000000',
    		               @Now,
    		               NULL,
    		               NULL,
    		               0
    		        FROM   #DealerPriceInit A
    		        WHERE  A.DPI_DMA_ID IS NOT NULL    		             
    		               AND CONVERT(DECIMAL, A.DPI_Price) > 0;
    		        
    		       
    		      END
              
              /* 更新接口表 */
              BEGIN
    		        --将接口表更新为
                UPDATE #ProcessingPrice SET DPH_Status = 'Success'  WHERE DPH_ID = @dphId
                
    		        
    		        --发邮件
--                INSERT INTO MailMessageQueue
--                select newid(),'email','',tab2.MDA_MailAddress,tab1.MMT_Subject,replace(replace(replace(replace(tab1.MMT_Body,'{#DealerName}',tab1.DealerName),'{#SubmitDate}',convert(nvarchar(10),tab1.DPH_UploadDate,111)+' '+ convert(nvarchar(10),tab1.DPH_UploadDate,108)),'{#UploadNo}',DPH_NBR),'{#Remark}',DPH_Remark),'Waiting',getdate(),null
--                  from 
--                  (
--                  select 
--                  t1.DPH_Remark,t2.DMA_ChineseName+'('+t2.DMA_SAP_Code+')' As DealerName,t1.DPH_UploadDate, 
--                  t2.DMA_EnglishShortName+ convert(nvarchar(8),t1.DPH_UploadDate,112)+replace(convert(nvarchar(8),t1.DPH_UploadDate,114),':','') AS DPH_NBR,
--                  t3.MMT_Subject,t3.MMT_Body
--                  from DealerPriceHead t1(nolock),dealerMaster t2(nolock),MailMessageTemplate t3(nolock) where DPH_ID=@DPHId
--                  and t1.DPH_LP=t2.DMA_ID  and t3.MMT_Code='EMAIL_T2DEALER_PRICE_SUBMIT'
--                  ) tab1,
--                  (select distinct t3.MDA_MailAddress 
--                         from DealerPriceDetail t1(nolock),cfn t2(nolock) , MailDeliveryAddress t3(nolock)
--                         where t1.DPD_DPH_ID=@DPHId and t1.DPD_ArticleNumber = t2.CFN_CustomerFaceNbr
--                          and t2.CFN_ProductLine_BUM_ID=t3.MDA_ProductLineID
--                          and t3.MDA_MailTo ='EAI' and t3.MDA_MailType='T2DealerPrice'
--                          and t3.MDA_ActiveFlag =1) tab2
                
    		        --写入日志表
                INSERT INTO dbo.DealerPriceInitLog
    			      SELECT *,getdate() FROM #DealerPriceInit 
    		    END
    		END
    		
        
        FETCH NEXT FROM curPriceApply INTO @dphId
    	
      
      END

    CLOSE curPriceApply
    DEALLOCATE curPriceApply
		
    --更新结果  
    UPDATE H SET H.DPH_Status = PP.DPH_Status
    FROM DealerPriceHead H,#ProcessingPrice AS PP
    WHERE H.DPH_ID = PP.DPH_ID
    
		COMMIT TRAN
		
		SET NOCOUNT OFF
		RETURN 1
	END TRY
	BEGIN CATCH
		SET NOCOUNT OFF
		ROLLBACK TRAN
    
    --记录错误日志开始
  	declare @error_line int
  	declare @error_number int
  	declare @error_message nvarchar(256)
  	declare @vError nvarchar(1000)
  	set @error_line = ERROR_LINE()
  	set @error_number = ERROR_NUMBER()
  	set @error_message = ERROR_MESSAGE()
  	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	  	
    SET @RtnMsg = @vError     
		SET @RtnVal = 'Failure'
		
	END CATCH
GO