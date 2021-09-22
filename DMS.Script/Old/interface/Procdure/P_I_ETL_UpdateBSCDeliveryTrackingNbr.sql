DROP PROCEDURE [interface].[P_I_ETL_UpdateBSCDeliveryTrackingNbr] 
GO

/*
���²��Ʒ������Ŀ�ݵ���
1����������δ����ĵ���д����ʱ��������δ����ı�ʶ�ǣ�ProcessResultΪ�գ���ProcessDateΪ��)
2���˲����ݣ����´������Ϣ
   A����������Ϊ��
   B����ݹ�˾Ϊ��
   C����ݵ���Ϊ��
   D������������DMS�в�����
3��������ȷ�ķ�������Ϣ
   A����������
4��������Ϣ���ʼ�֪ͨ�����Ա
5��ʹ����ʱ�����ݸ�����ʽ�ӿڱ�   
*/

CREATE PROCEDURE [interface].[P_I_ETL_UpdateBSCDeliveryTrackingNbr]  
   @IsValid        NVARCHAR (20) OUTPUT,
   @RtnMsg         NVARCHAR (500) OUTPUT
AS  
   DECLARE @SysUserId   UNIQUEIDENTIFIER   
   DECLARE @EmptyGuid   UNIQUEIDENTIFIER
   DECLARE @ErrCnt      INT
   DECLARE @RowCnt      INT
   DECLARE @NowDate     Datetime
   
   
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN

      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      SET @EmptyGuid = '00000000-0000-0000-0000-000000000000'
      SET @NowDate = getdate()    
	
      CREATE TABLE #DNTracking
        (
          [SAPDeliveryNbr] nvarchar(100) NULL,
          [ExpressCompany] nvarchar(100) NULL,
          [ExpressCoDeliveryNbr] nvarchar(100) NULL,
          [CreateDate] datetime NULL,
          [ProcessResult] nvarchar(100) NULL,
          [HandleDate] datetime NULL,
          [ErrorDescription] nvarchar(2000) NULL
        )
        
      --��5���ڴ�����������¸���Ϊ��δ���������´���һ��
      UPDATE interface.T_I_WMS_DN_UPDATE
         SET ProcessResult = NULL
       WHERE     CreateDate >= dateadd (day, -5, getdate ())
             AND ProcessResult = 'Error'
             AND SAPDeliveryNbr IS NOT NULL
      
      --��δ���������д����ʱ��������
      INSERT INTO #DNTracking(SAPDeliveryNbr, ExpressCompany, ExpressCoDeliveryNbr, CreateDate, ProcessResult)
      SELECT SAPDeliveryNbr, ExpressCompany, ExpressCoDeliveryNbr, CreateDate, ProcessResult 
        FROM interface.T_I_WMS_DN_UPDATE
       WHERE ProcessResult IS NULL
      
      
      --�˲����ݣ����´������Ϣ
      --A����������Ϊ��
      --B����ݹ�˾Ϊ��
      --C����ݵ���Ϊ��
      --D������������DMS�в�����
      update #DNTracking set ProcessResult='Error',ErrorDescription = '��������Ϊ��;' where SAPDeliveryNbr is null or SAPDeliveryNbr=''
      update #DNTracking set ProcessResult='Error',ErrorDescription = isnull(ErrorDescription,'') + '��ݹ�˾Ϊ��;'  where ExpressCompany is null or ExpressCompany=''
      update #DNTracking set ProcessResult='Error',ErrorDescription = isnull(ErrorDescription,'') + '��ݵ���Ϊ��;'  where ExpressCoDeliveryNbr is null or ExpressCoDeliveryNbr='' 
      update #DNTracking set ProcessResult='Error',ErrorDescription = isnull(ErrorDescription,'') + '����������DMS�в�����;'  
       where SAPDeliveryNbr is not null and SAPDeliveryNbr<>''
       and not exists (select 1 from POReceiptHeader H where H.PRH_SAPShipmentID = SAPDeliveryNbr )
       
      --������ȷ�ķ�������Ϣ
      update #DNTracking set ProcessResult = 'Success' where ProcessResult is null
      
      --�������ݴ���ʱ��
      update #DNTracking set HandleDate = @NowDate      
      
      --�������ݵ���ʽ��
      UPDATE PRD
      SET PRD.ProcessResult = TMP.ProcessResult
      FROM interface.T_I_WMS_DN_UPDATE PRD,#DNTracking TMP
      where isnull(PRD.SAPDeliveryNbr,'NULL') = isnull(TMP.SAPDeliveryNbr,'NULL')
      and isnull(PRD.ExpressCompany,'NULL') = isnull(TMP.ExpressCompany,'NULL')
      and isnull(PRD.ExpressCoDeliveryNbr,'NULL') = isnull(TMP.ExpressCoDeliveryNbr,'NULL')
      and isnull(PRD.CreateDate,'2999-01-01') = ISNULL(TMP.CreateDate,'2999-01-01')
      and PRD.ProcessResult IS NULL     
      
      --���µ��ջ���     
      UPDATE PRH
      SET PRH_Carrier=ExpressCompany,PRH_TrackingNo = ExpressCoDeliveryNbr           
      FROM POReceiptHeader PRH,#DNTracking TMP
      where PRH.PRH_SAPShipmentID = TMP.SAPDeliveryNbr
        AND TMP.ErrorDescription is null      
      
      INSERT INTO INTERFACE.T_I_WMS_DN_UPDATE_LOG(SAPDeliveryNbr, ExpressCompany, ExpressCoDeliveryNbr, CreateDate, ProcessResult,HandleDate,ErrorDescription)
      SELECT SAPDeliveryNbr, ExpressCompany, ExpressCoDeliveryNbr, CreateDate, ProcessResult,HandleDate,ErrorDescription
        FROM #DNTracking
    
      
      IF (SELECT count(*) FROM #DNTracking WHERE ErrorDescription is NOT NULL) > 0 
      BEGIN
        --��ȡ������Ϣ
        DELETE FROM interface.T_I_WMS_DN_UPDATE_TMP
        INSERT INTO interface.T_I_WMS_DN_UPDATE_TMP(TAB_PK,[SAP��������],[��ݹ�˾],[��ݵ���],[��������],[��������])
        SELECT 1,SAPDeliveryNbr,ExpressCompany,ExpressCoDeliveryNbr,convert(nvarchar(20),CreateDate,120),ErrorDescription
          FROM #DNTracking where ErrorDescription is NOT NULL AND SAPDeliveryNbr IS Not null AND SAPDeliveryNbr<>''
        
        
        DECLARE @DetailRtnMsg nvarchar(MAX)
        EXEC dbo.Proc_getHtmlTable '1','TAB_PK','interface.T_I_WMS_DN_UPDATE_TMP',@DetailRtnMsg OUTPUT  
        
      
         --������Ϣ���ʼ�֪ͨ�����Ա
        INSERT INTO MailMessageQueue 
        select NEWID(),'email','',t2.MDA_MailAddress,MMT_Subject,
        replace(MMT_Body,'{#HTML}',@DetailRtnMsg) AS MMT_Body,'Waiting',getdate(),null
		     from MailMessageTemplate t1, MailDeliveryAddress t2
		    where MMT_Code='EMAIL_SAPDELIVERY_TRACKING_NBR_UPDATE_ERROR_ALERT'
        and t2.MDA_MailType='TrackingNoUpd' and t2.MDA_MailTo = 'SLC'
        
      
      END
  
      COMMIT TRAN
      SET @IsValid = 'Success'

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @IsValid = 'Failure'
      
      --��¼������־��ʼ
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError = '��' + CONVERT (NVARCHAR (10), @error_line) + '����[�����' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
      SET @RtnMsg = @vError      
      RETURN -1
   END CATCH
GO


