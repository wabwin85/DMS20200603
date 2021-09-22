DROP Procedure [dbo].[GC_ThirdPartyDisclosure_SendEmail]
GO


/*
T1/T2自动收货
*/
CREATE Procedure [dbo].[GC_ThirdPartyDisclosure_SendEmail]

AS
	DECLARE @SysUserId uniqueidentifier
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

--临时表存放未上传附件的经销商邮件地址
CREATE TABLE #DmaEmailAddress(
ID uniqueidentifier,
Name NVARCHAR(100),
Email NVARCHAR(100),
MMTSubject NVARCHAR(100),
Body NVARCHAR(MAX)
)
--将经销商邮件地址写入临时表
INSERT INTO #DmaEmailAddress
 SELECT A.DMA_ID,A.DMA_ChineseName,A.DMA_Email,D.MMT_Subject,D.MMT_Body FROM DealerMaster A,MailMessageTemplate D WHERE NOT EXISTS
      (SELECT 1 FROM ThirdPartyDisclosure B INNER JOIN Attachment C ON B.TPD_ID=C.AT_Main_ID
       WHERE A.DMA_ID=B.TPD_DMA_ID AND (B.TPD_RSM='经销商指定公司' OR B.TPD_RSM2='经销商指定公司') AND B.TPD_ApprovalStatus='待审批' AND  DATEDIFF(DAY,B.TPD_CreatDate,GETDATE())>7 )
       AND EXISTS
       (SELECT 1 FROM ThirdPartyDisclosure WHERE A.DMA_ID=ThirdPartyDisclosure.TPD_DMA_ID AND ThirdPartyDisclosure.TPD_ApprovalStatus='待审批' 
       AND  DATEDIFF(DAY,ThirdPartyDisclosure.TPD_CreatDate,GETDATE())>7)
       AND D.MMT_Code='EMAIL_ThirdParty_ChangeNotice_DelaerDay'
      
--将邮件写入发送邮件表
INSERT INTO  MailMessageQueue(MMQ_ID, MMQ_From,MMQ_QueueNo,MMQ_To,MMQ_Subject,MMQ_Body,MMQ_Status,MMQ_CreateDate)
SELECT NEWID(),'','email',Email,MMTSubject,Body,'Waiting',GETDATE() FROM #DmaEmailAddress      
       
COMMIT TRAN

SET NOCOUNT OFF
return 1

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

    return -1
    
END CATCH




GO


