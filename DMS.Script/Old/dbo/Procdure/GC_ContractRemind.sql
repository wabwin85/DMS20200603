DROP Procedure [dbo].[GC_ContractRemind]
GO


/*
DCMS提醒功能
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
	--对应销售员名称 
	DECLARE @SalesName NVARCHAR(100)
	DECLARE @DealerName NVARCHAR(500)
	
	DECLARE @MAILADDRESS NVARCHAR(100)
	DECLARE @MAILBODY NVARCHAR(2000)
	
	DECLARE @DateStamp INT 
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN	
	--1. 系统提醒所有即将到期经销商续约及指标修改提醒(1个月)
	SET @DateStamp=0; --初始化日期标记
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
				SET @MAILBODY='尊敬的RMS <b>'+@SalesName+'</b>您好，<br/>您所管理的经销商<b>'+@DealerName+' '+@DivisionName+'</b>产品线 <b>'+ @MARKETTYPENAME +'</b> 合同即将在一个月内终止，请及时续约合同，并作必要的指标调整<br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
				
				INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
				SELECT NEWID(),'email','',@MAILADDRESS,'波士顿科学合同终止提醒',@MAILBODY,'Waiting',GETDATE(),NULL
				
			END
			
	 FETCH NEXT FROM @PRODUCT_CUR INTO @MinDate,@DMAID,@DEALERTYPE,@MARKETTYPENAME,@MARKETTYPECODE,@DivisionName,@DivisionCode
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
    
    --2.系统于每年12.31/1.31 提醒合同到期但未续约的经销商名单
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
					SET @MAILBODY='尊敬的RMS <b>'+@SalesName+'</b>您好，<br/>您所管理的经销商<b>'+@DealerName+' '+@DivisionName+'</b>产品线 <b>'+ @MARKETTYPENAME +'</b> 合同已经到期，请尽快提交续约申请。<br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
					
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@MAILADDRESS,'波士顿科学合同续约提醒',@MAILBODY,'Waiting',GETDATE(),NULL
					
				END
			
			FETCH NEXT FROM @PRODUCT_CUR2 INTO @MinDate,@DMAID,@DEALERTYPE,@MARKETTYPENAME,@MARKETTYPECODE,@DivisionName,@DivisionCode
			END
		CLOSE @PRODUCT_CUR2
		DEALLOCATE @PRODUCT_CUR2 ;
	END

	--3.合同，附件上传提醒
	--T2： 合同完成审批后，平台超过14天仍然没有上传相关附件，发账号终止提醒
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
					SET @MAILBODY='尊敬的平台合作伙伴您好，<br/>您公司所属二级经销商'+@DMA_Name+' '+@PL_Name+'产品线合同完成审批已超14天，但截止当前仍未上传任何附件信息，请尽快补齐，以避免该经销商DMS账号被注销。<br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
					
					INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
					SELECT NEWID(),'email','',@MAILADDRESS,'DMS账户终止提醒',@MAILBODY,'Waiting',GETDATE(),NULL
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
						SET @MAILBODY='尊敬的波士顿科学经销合作伙伴您好，<br/>您公司'+@PL_Name+'产品线合同完成审批已超14天，但截止当前仍未上传任何附件信息，请尽快补齐，以避免该经销商DMS账号被注销。<br>波士顿科学DMS系统<br>――――――――――――――――――――――――<br>此邮件为系统自动发送，请勿回复！<br>谢谢！'
						
						INSERT INTO MailMessageQueue([MMQ_ID],[MMQ_QueueNo] ,[MMQ_From] ,[MMQ_To],[MMQ_Subject],[MMQ_Body],[MMQ_Status],[MMQ_CreateDate],[MMQ_SendDate])
						SELECT NEWID(),'email','',@MAILADDRESS,'DMS账户终止提醒',@MAILBODY,'Waiting',GETDATE(),NULL
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
    return -1
END CATCH




GO


