DROP Procedure [dbo].[GC_ContractRemind]
GO


/*
DCMS���ѹ���
*/
CREATE Procedure [dbo].[GC_ContractRemind]
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @MinDate DATETIME
	DECLARE @DEALERTYPE DATETIME
	DECLARE @MARKETTYPENAME DATETIME
	DECLARE @MARKETTYPECODE NVARCHAR(20)
	DECLARE @DMAID uniqueidentifier
	DECLARE @DivisionName NVARCHAR(20)
	DECLARE @DivisionCode NVARCHAR(20)
	--��Ӧ����Ա���� 
	DECLARE @SalesName NVARCHAR(100)
	DECLARE @DealerName NVARCHAR(500)
	
	DECLARE @MAILADDRESS NVARCHAR(100)
	DECLARE @MAILBODY NVARCHAR(2000)
	
	DECLARE @DateStamp INT 
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN	
	--1. ϵͳ�������м������ھ�������Լ��ָ���޸�����(1����)
	SET @DateStamp=0; --��ʼ�����ڱ��
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT  ExpirationDate,DMA_ID, DealerType,MarketTypeName,MarketType, B.DivisionName,B.DivisionCode
	FROM V_DealerContractMaster A
	INNER JOIN  V_DivisionProductLineRelation B ON A.Division=B.DivisionCode AND B.IsEmerging='0'
	WHERE CONVERT(NVARCHAR(10), A.ExpirationDate,120)< CONVERT(NVARCHAR(10),GETDATE(),120)
	AND CONVERT(NVARCHAR(10),DATEADD(m,1, A.ExpirationDate),120)> CONVERT(NVARCHAR(10),GETDATE(),120)
	AND A.TerminationDate IS NULL
	
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @MinDate,@DMAID,@DEALERTYPE,@MARKETTYPENAME,@MARKETTYPECODE,@DivisionName,@DivisionCode
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			SET @MAILADDRESS=NULL
			SET @MAILBODY=NULL
			SET @DealerName=NULL
			SELECT @SalesName=RSM,	@MAILADDRESS=RSMEmail ,@DealerName=B.DMA_ChineseName FROM [Interface].[V_I_QV_DealerRelation]  A
			INNER JOIN DealerMaster B ON A.SAPID=B.DMA_SAP_Code
			WHERE B.DMA_ID=@DMAID AND CONVERT(NVARCHAR(20),DivisionID)=@DivisionCode AND ISNULL(MarketType,'0')= ISNULL(@MARKETTYPECODE,'0');
			
			IF ISNULL(@MAILADDRESS,'')<>'' AND (
			CONVERT(NVARCHAR(10),DATEADD(DD,0,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) OR 
			CONVERT(NVARCHAR(10),DATEADD(DD,1,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) OR 
			CONVERT(NVARCHAR(10),DATEADD(DD,2,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) OR 
			CONVERT(NVARCHAR(10),DATEADD(DD,3,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) OR 
			CONVERT(NVARCHAR(10),DATEADD(DD,4,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) OR 
			CONVERT(NVARCHAR(10),DATEADD(DD,5,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) OR 
			CONVERT(NVARCHAR(10),DATEADD(DD,6,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) OR 
			CONVERT(NVARCHAR(10),DATEADD(DD,7,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) OR 
			CONVERT(NVARCHAR(10),DATEADD(DD,14,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) OR 
			CONVERT(NVARCHAR(10),DATEADD(DD,21,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) OR 
			CONVERT(NVARCHAR(10),DATEADD(DD,28,GETDATE()),120)=CONVERT(NVARCHAR(10),@MinDate,120) )
			BEGIN
				--MailBody
				SET @MAILBODY='�𾴵�RMS <b>'+@SalesName+'</b>���ã�<br/>��������ľ�����<b>'+@DealerName+' '+@DivisionName+'</b>��Ʒ�� <b>'+ @MARKETTYPENAME +'</b> ��ͬ������һ��������ֹ���뼰ʱ��Լ��ͬ��������Ҫ��ָ�����<br>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'
				
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',@MAILADDRESS,'��ʿ�ٿ�ѧ��ͬ��ֹ����',@MAILBODY,'Waiting',GETDATE(),NULL
				
			END
			
	 FETCH NEXT FROM @PRODUCT_CUR INTO @MinDate,@DMAID,@DEALERTYPE,@MARKETTYPENAME,@MARKETTYPECODE,@DivisionName,@DivisionCode
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
    
    --2.ϵͳ��ÿ��12.31/1.31 ���Ѻ�ͬ���ڵ�δ��Լ�ľ���������
    IF  MONTH(GETDATE())=1
    BEGIN
		SET @MinDate=NULL SET @DMAID=NULL SET @DEALERTYPE=NULL SET @MARKETTYPENAME=NULL SET @MARKETTYPECODE=NULL SET @DivisionName=NULL  SET @DivisionCode=NULL;
		
		DECLARE @PRODUCT_CUR2 cursor;
		SET @PRODUCT_CUR2=cursor for 
		SELECT  ExpirationDate,DMA_ID, DealerType,MarketTypeName,MarketType, B.DivisionName,B.DivisionCode
		FROM V_DealerContractMaster A
		INNER JOIN  V_DivisionProductLineRelation B ON A.Division=B.DivisionCode AND B.IsEmerging='0'
		WHERE CONVERT(NVARCHAR(10), a.ExpirationDate,120)<CONVERT(NVARCHAR(10),GETDATE(),120)
		AND A.TerminationDate IS NULL 
		AND  (YEAR(A.ExpirationDate)+1)= YEAR(GETDATE())
		
		OPEN @PRODUCT_CUR2
		FETCH NEXT FROM @PRODUCT_CUR2 INTO @MinDate,@DMAID,@DEALERTYPE,@MARKETTYPENAME,@MARKETTYPECODE,@DivisionName,@DivisionCode
		WHILE @@FETCH_STATUS = 0        
			BEGIN
				SET @MAILADDRESS=NULL
				SET @MAILBODY=NULL
				SET @DealerName=NULL
				
				SELECT @SalesName=RSM,	@MAILADDRESS=RSMEmail ,@DealerName=B.DMA_ChineseName FROM [Interface].[V_I_QV_DealerRelation]  A
				INNER JOIN DealerMaster B ON A.SAPID=B.DMA_SAP_Code
				WHERE B.DMA_ID=@DMAID AND CONVERT(NVARCHAR(20),DivisionID)=@DivisionCode AND ISNULL(MarketType,'0')= ISNULL(@MARKETTYPECODE,'0');
				
				IF ISNULL(@MAILADDRESS,'')<>'' AND(
				CONVERT(NVARCHAR(10),DATEADD(DD,7,@MinDate),120)=CONVERT(NVARCHAR(10),GETDATE(),120) OR 
				CONVERT(NVARCHAR(10),DATEADD(DD,14,@MinDate),120)=CONVERT(NVARCHAR(10),GETDATE(),120) OR 
				CONVERT(NVARCHAR(10),DATEADD(DD,21,@MinDate),120)=CONVERT(NVARCHAR(10),GETDATE(),120) OR 
				CONVERT(NVARCHAR(10),DATEADD(DD,27,@MinDate),120)=CONVERT(NVARCHAR(10),GETDATE(),120) OR 
				CONVERT(NVARCHAR(10),DATEADD(DD,28,@MinDate),120)=CONVERT(NVARCHAR(10),GETDATE(),120)OR 
				CONVERT(NVARCHAR(10),DATEADD(DD,29,@MinDate),120)=CONVERT(NVARCHAR(10),GETDATE(),120)OR 
				CONVERT(NVARCHAR(10),DATEADD(DD,30,@MinDate),120)=CONVERT(NVARCHAR(10),GETDATE(),120)OR 
				CONVERT(NVARCHAR(10),DATEADD(DD,31,@MinDate),120)=CONVERT(NVARCHAR(10),GETDATE(),120))
				BEGIN
					--MailBody
					SET @MAILBODY='�𾴵�RMS <b>'+@SalesName+'</b>���ã�<br/>��������ľ�����<b>'+@DealerName+' '+@DivisionName+'</b>��Ʒ�� <b>'+ @MARKETTYPENAME +'</b> ��ͬ�Ѿ����ڣ��뾡���ύ��Լ���롣<br>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'
					
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@MAILADDRESS,'��ʿ�ٿ�ѧ��ͬ��Լ����',@MAILBODY,'Waiting',GETDATE(),NULL
					
				END
			
			FETCH NEXT FROM @PRODUCT_CUR2 INTO @MinDate,@DMAID,@DEALERTYPE,@MARKETTYPENAME,@MARKETTYPECODE,@DivisionName,@DivisionCode
			END
		CLOSE @PRODUCT_CUR2
		DEALLOCATE @PRODUCT_CUR2 ;
	END

	--3.��ͬ�������ϴ�����
	--T2�� ��ͬ���������ƽ̨����14����Ȼû���ϴ���ظ��������˺���ֹ����
	CREATE TABLE #TBContractAttach
	(
		Id			uniqueidentifier,
		DMA_ID		uniqueidentifier,
		DMA_Name	NVARCHAR(500),
		DealerType	NVARCHAR(100),
		ProductLine NVARCHAR(100),
		AttachCount INT
	)
	DECLARE @Id				uniqueidentifier
	DECLARE @DMA_ID			uniqueidentifier
	DECLARE @DMA_Name		NVARCHAR(200)
	DECLARE @DMA_Type		NVARCHAR(20)
	DECLARE @PL_Name		NVARCHAR(20)
	DECLARE @Attach_Count	INT
	
	DECLARE @DMA_ID_LP		uniqueidentifier
	
	INSERT INTO #TBContractAttach(Id,DMA_ID,DMA_Name,DealerType,ProductLine,AttachCount)
	SELECT TAB.ID,TAB.DMA_ID,DM.DMA_ChineseName AS DMA_Name,TAB.DealerType,ProductLineName,ATTypeCount FROM (
	SELECT CAP_ID AS ID,CAP_DMA_ID AS DMA_ID,DMA_DealerType AS DealerType,DPL.ProductLineName FROM ContractAppointment 
	LEFT JOIN DealerMaster ON CAP_DMA_ID=DMA_ID 
	LEFT JOIN V_DivisionProductLineRelation DPL ON DPL.DivisionName=CAP_Division AND DPL.IsEmerging='0'  
	WHERE CAP_Status='Completed' AND CONVERT(NVARCHAR(10),DATEADD(DD,14,CAP_Update_Date),120)<CONVERT(NVARCHAR(10),GETDATE() ,120)
	UNION
	SELECT CRE_ID,CRE_DMA_ID,DMA_DealerType,DPL.ProductLineName FROM ContractRenewal 
	LEFT JOIN DealerMaster ON CRE_DMA_ID=DMA_ID 
	LEFT JOIN V_DivisionProductLineRelation DPL ON DPL.DivisionName=CRE_Division AND DPL.IsEmerging='0'  
	WHERE CRE_Status='Completed' AND CONVERT(NVARCHAR(10),DATEADD(DD,14,CRE_Update_Date),120)<CONVERT(NVARCHAR(10),GETDATE() ,120)
	UNION
	SELECT CAM_ID,CAM_DMA_ID,DMA_DealerType,DPL.ProductLineName FROM ContractAmendment 
	LEFT JOIN DealerMaster ON CAM_DMA_ID=DMA_ID	
	LEFT JOIN V_DivisionProductLineRelation DPL ON DPL.DivisionName=CAM_Division AND DPL.IsEmerging='0'  
	WHERE CAM_Status='Completed' AND CONVERT(NVARCHAR(10),DATEADD(DD,14,CAM_Update_Date),120)<CONVERT(NVARCHAR(10),GETDATE() ,120)
	)TAB
	LEFT JOIN(SELECT ATM.AT_Main_ID ATMainID,COUNT(ATM.AT_Type) AS ATTypeCount  FROM Attachment ATM  GROUP BY ATM.AT_Main_ID) Attachment
	ON TAB.ID=Attachment.ATMainID
	LEFT JOIN DealerMaster DM ON DM.DMA_ID=TAB.DMA_ID
	
	
	DECLARE @PRODUCT_CUR3 cursor;
	SET @PRODUCT_CUR3=cursor for 
	SELECT Id,DMA_ID,DMA_Name,DealerType, ProductLine,AttachCount FROM #TBContractAttach WHERE ISNULL(AttachCount,0)=0
	
	OPEN @PRODUCT_CUR3
    FETCH NEXT FROM @PRODUCT_CUR3 INTO @Id,@DMA_ID,@DMA_Name,@DMA_Type,@PL_Name,@Attach_Count
    WHILE @@FETCH_STATUS = 0        
        BEGIN
			SET @MAILADDRESS=NULL;
			SET @MAILBODY=NULL;
			
			IF ISNULL(@MAILADDRESS,'')<>''
			BEGIN
				--MailBody
				IF  ISNULL(@DMA_Type,'')='T2'
				BEGIN
					SELECT @DMA_ID_LP=DMA_Parent_DMA_ID FROM DealerMaster WHERE DMA_ID=@DMAID
					SET @MAILBODY='�𾴵�ƽ̨����������ã�<br/>����˾��������������'+@DMA_Name+' '+@PL_Name+'��Ʒ�ߺ�ͬ��������ѳ�14�죬����ֹ��ǰ��δ�ϴ��κθ�����Ϣ���뾡�첹�룬�Ա���þ�����DMS�˺ű�ע����<br>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'
					
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@MAILADDRESS,'DMS�˻���ֹ����',@MAILBODY,'Waiting',GETDATE(),NULL
					FROM MailDeliveryAddress 
					INNER JOIN Client 
						ON MailDeliveryAddress.MDA_MailTo=Client.CLT_ID
						AND Client.CLT_Corp_Id=@DMA_ID_LP
					WHERE MDA_MailType='DCMS'  
				END
				ELSE
				BEGIN
					SELECT @MAILADDRESS= DMA_Email FROM DealerMaster WHERE DMA_ID=@DMAID
					IF ISNULL(@MAILADDRESS,'')<>''
					BEGIN
						SET @MAILBODY='�𾴵Ĳ�ʿ�ٿ�ѧ��������������ã�<br/>����˾'+@PL_Name+'��Ʒ�ߺ�ͬ��������ѳ�14�죬����ֹ��ǰ��δ�ϴ��κθ�����Ϣ���뾡�첹�룬�Ա���þ�����DMS�˺ű�ע����<br>��ʿ�ٿ�ѧDMSϵͳ<br>�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D�D<br>���ʼ�Ϊϵͳ�Զ����ͣ�����ظ���<br>лл��'
						
						INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
						SELECT NEWID(),'email','',@MAILADDRESS,'DMS�˻���ֹ����',@MAILBODY,'Waiting',GETDATE(),NULL
					END
				END
				
				
				
			END
			
	 FETCH NEXT FROM @PRODUCT_CUR3 INTO @Id,@DMA_ID,@DMA_Name,@DMA_Type,@PL_Name,@Attach_Count
        END
    CLOSE @PRODUCT_CUR3
    DEALLOCATE @PRODUCT_CUR3 ;
		
    	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
END CATCH




GO


