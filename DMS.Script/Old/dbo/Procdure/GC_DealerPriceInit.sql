DROP PROCEDURE [dbo].[GC_DealerPriceInit]
GO

/*
�����̼۸���
*/
CREATE PROCEDURE [dbo].[GC_DealerPriceInit]
	@UserId UNIQUEIDENTIFIER,
	@ImportType NVARCHAR(20), --�������ͣ���Ϊ������ƽ̨��һ��
	@Remark NVARCHAR(1000),
	@IsValid NVARCHAR(20) = 'Success' OUTPUT
AS
	SET NOCOUNT ON
	
	BEGIN TRY
		BEGIN TRAN
		
		CREATE TABLE #DealerPriceInit(
			[DPI_ID] [uniqueidentifier] NOT NULL,
			[DPI_USER] [uniqueidentifier] NOT NULL,
			[DPI_UploadDate] [datetime] NOT NULL,
			[DPI_LineNbr] [int] NOT NULL,
			[DPI_FileName] [nvarchar](200) NOT NULL,
			[DPI_ErrorFlag] [bit] NOT NULL,
			[DPI_ErrorDescription] [nvarchar](100) NULL,
			[DPI_LP_ID] [uniqueidentifier] NOT NULL,
			[DPI_ArticleNumber] [nvarchar](30) NULL,
			[DPI_ArticleNumber_ErrMsg] [nvarchar](100) NULL,
			[DPI_CFN_ID] [uniqueidentifier] NULL,
			[DPI_Dealer] [nvarchar](50) NULL,
			[DPI_Dealer_ErrMsg] [nvarchar](100) NULL,
			[DPI_DMA_ID] [uniqueidentifier] NULL,
			[DPI_Price] [nvarchar](100) NULL,
			[DPI_Price_ErrMsg] [nvarchar](100) NULL,
			[DPI_PriceTypeName] [nvarchar](20) NULL,
			[DPI_PriceTypeName_ErrMsg] [nvarchar](100) NULL,
			[DPI_PriceType] [nvarchar](20) NULL
	    )
	    
	    
		
		
		/*�Ƚ������־��Ϊ0*/
		UPDATE DealerPriceInit
		SET    DPI_ErrorFlag = 0,
		       DPI_ArticleNumber_ErrMsg = '',
		       DPI_Dealer_ErrMsg = '',
		       DPI_Price_ErrMsg = '',
		       DPI_PriceTypeName_ErrMsg = ''
		WHERE  DPI_USER = @UserId;
		
		--����Ʒ�Ƿ����
		UPDATE DealerPriceInit
		SET    DPI_CFN_ID = CFN_ID
		FROM   CFN
		WHERE  CFN_CustomerFaceNbr = DPI_ArticleNumber
		       AND DPI_USER = @UserId;
		
		UPDATE DealerPriceInit
		SET    DPI_ErrorFlag = 1,
		       DPI_ArticleNumber_ErrMsg = DPI_ArticleNumber_ErrMsg + N'��Ʒ������,'
		WHERE  DPI_CFN_ID IS NULL
		       AND DPI_USER = @UserId;
		
		--��龭�����Ƿ����
		UPDATE A
		SET    A.DPI_DMA_ID = B.DMA_ID
		FROM   DealerPriceInit A,
		       DealerMaster B(NOLOCK)
		WHERE  A.DPI_Dealer = B.DMA_SAP_Code
		       AND B.DMA_Parent_DMA_ID = A.DPI_LP_ID
		       AND A.DPI_USER = @UserId
		       AND ISNULL(A.DPI_Dealer, '') <> '';
		
		UPDATE DealerPriceInit
		SET    DPI_ErrorFlag = 1,
		       DPI_Dealer_ErrMsg = DPI_Dealer_ErrMsg + N'�����̲�����,'
		WHERE  ISNULL(DPI_Dealer, '') <> ''
		       AND DPI_DMA_ID IS NULL
		       AND DPI_USER = @UserId;
		
		--���۸�
		UPDATE DealerPriceInit
		SET    DPI_ErrorFlag = 1,
		       DPI_Price_ErrMsg = DPI_Price_ErrMsg + N'�۸��ʽ����ȷ,'
		WHERE  ISNUMERIC(DPI_Price) = 0
		       AND DPI_USER = @UserId;
		
		UPDATE DealerPriceInit
		SET    DPI_ErrorFlag = 1,
		       DPI_Price_ErrMsg = DPI_Price_ErrMsg + N'�۸������ڵ���0,'
		WHERE  ISNUMERIC(DPI_Price) = 1
		       AND CONVERT(DECIMAL, DPI_Price) < 0
		       AND DPI_USER = @UserId;
		
		--��������Ƿ����
		UPDATE A
		SET    A.DPI_PriceType = B.DICT_KEY
		FROM   DealerPriceInit A,
		       Lafite_DICT B(NOLOCK)
		WHERE  A.DPI_PriceTypeName = B.VALUE1
		       AND B.DICT_TYPE = 'CONST_CFN_PriceType'
		       AND A.DPI_USER = @UserId
		
		UPDATE DealerPriceInit
		SET    DPI_ErrorFlag = 1,
		       DPI_PriceTypeName_ErrMsg = DPI_PriceTypeName_ErrMsg + N'���Ͳ���ȷ,'
		WHERE  DPI_PriceType IS NULL
		       AND DPI_USER = @UserId;
		
		--����Ƿ��ظ�
		UPDATE A
		SET    A.DPI_ErrorFlag = 1,
		       A.DPI_ArticleNumber_ErrMsg = A.DPI_ArticleNumber_ErrMsg + N'[��Ʒ�ͺ�]+[������]+[����]���ظ�,'
		FROM   DealerPriceInit A,
		       (	SELECT T.DPI_ArticleNumber,
		        	       T.DPI_Dealer,
		        	       T.DPI_PriceTypeName,
		        	       COUNT(*) CNT
		        	FROM   DealerPriceInit T(NOLOCK)
		        	WHERE  T.DPI_USER = @UserId
		        	GROUP BY
		        	       T.DPI_ArticleNumber,
		        	       T.DPI_Dealer,
		        	       T.DPI_PriceTypeName ) B
		WHERE  A.DPI_USER = @UserId
		       AND A.DPI_ArticleNumber = B.DPI_ArticleNumber
		       AND A.DPI_Dealer = B.DPI_Dealer
		       AND A.DPI_PriceTypeName = B.DPI_PriceTypeName
		       AND B.CNT > 1
		
		--����Ƿ���ڴ���
		IF (	SELECT COUNT(*)
		    	FROM   DealerPriceInit(NOLOCK)
		    	WHERE  DPI_ErrorFlag = 1
		    	       AND DPI_USER = @UserId ) > 0
		BEGIN
		    /*������ڴ����򷵻�Error*/
		    SET @IsValid = 'Error'
		END
		ELSE
		BEGIN
		    /*��������ڴ����򷵻�Success*/		
		    SET @IsValid = 'Success'
		    
		    /*�ϴ���ť��д��ʽ�����밴ť��д*/
		    IF @ImportType = 'Import'
		    BEGIN
		        --д����ʱ��
		        insert into #DealerPriceInit
		        SELECT * from dbo.DealerPriceInit where DPI_USER = @UserId
		        
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
		               '��',
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
		               --AND A.DPI_USER = @UserId
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
		               '��',
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
		               --AND A.DPI_USER = @UserId
		               AND CONVERT(DECIMAL, A.DPI_Price) > 0;
		        
		        DECLARE @DPHId UNIQUEIDENTIFIER;
		        SET @DPHId = NEWID();
		        
		        
		        INSERT INTO DealerPriceHead
		        SELECT DISTINCT 
		               @DPHId,
		               @Remark,
		               @UserId,
		               DPI_LP_ID,
		               @Now
		        FROM   #DealerPriceInit
		        WHERE  DPI_USER = @UserId;
		        
		        INSERT INTO DealerPriceDetail
		        SELECT NEWID(),
		               @DPHId,
		               A.DPI_LineNbr,
		               A.DPI_FileName,
		               A.DPI_ArticleNumber,
		               A.DPI_Dealer,
		               A.DPI_Price,
		               A.DPI_PriceTypeName
		        FROM   #DealerPriceInit A
		        WHERE  A.DPI_USER = @UserId;
		        
		        --���ʼ�
            INSERT INTO MailMessageQueue
            select newid(),'email','',tab2.MDA_MailAddress,tab1.MMT_Subject,replace(replace(replace(replace(tab1.MMT_Body,'{#DealerName}',tab1.DealerName),'{#SubmitDate}',convert(nvarchar(10),tab1.DPH_UploadDate,111)+' '+ convert(nvarchar(10),tab1.DPH_UploadDate,108)),'{#UploadNo}',DPH_NBR),'{#Remark}',DPH_Remark),'Waiting',getdate(),null
              from 
              (
              select 
              t1.DPH_Remark,t2.DMA_ChineseName+'('+t2.DMA_SAP_Code+')' As DealerName,t1.DPH_UploadDate, 
              t2.DMA_EnglishShortName+ convert(nvarchar(8),t1.DPH_UploadDate,112)+replace(convert(nvarchar(8),t1.DPH_UploadDate,114),':','') AS DPH_NBR,
              t3.MMT_Subject,t3.MMT_Body
              from DealerPriceHead t1(nolock),dealerMaster t2(nolock),MailMessageTemplate t3(nolock) where DPH_ID=@DPHId
              and t1.DPH_LP=t2.DMA_ID  and t3.MMT_Code='EMAIL_T2DEALER_PRICE_SUBMIT'
              ) tab1,
              (select distinct t3.MDA_MailAddress 
                     from DealerPriceDetail t1(nolock),cfn t2(nolock) , MailDeliveryAddress t3(nolock)
                     where t1.DPD_DPH_ID=@DPHId and t1.DPD_ArticleNumber = t2.CFN_CustomerFaceNbr
                      and t2.CFN_ProductLine_BUM_ID=t3.MDA_ProductLineID
                      and t3.MDA_MailTo ='EAI' and t3.MDA_MailType='T2DealerPrice'
                      and t3.MDA_ActiveFlag =1) tab2
                      
            
            
		        --����м�������
			    DELETE FROM DealerPriceInit WHERE DPI_USER = @UserId
		    END
		END
		
		COMMIT TRAN
		
		SET NOCOUNT OFF
		RETURN 1
	END TRY
	BEGIN CATCH
		SET NOCOUNT OFF
		ROLLBACK TRAN
		--declare @error_message nvarchar(256)
		--set @error_message = ERROR_MESSAGE()
		SET @IsValid = 'Failure'--+@error_message
		RETURN -1
	END CATCH
GO


