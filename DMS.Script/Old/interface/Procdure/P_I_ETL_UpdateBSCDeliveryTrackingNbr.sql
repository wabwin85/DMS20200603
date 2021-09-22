DROP PROCEDURE [interface].[P_I_ETL_UpdateBSCDeliveryTrackingNbr] 
GO

/*
更新波科发货单的快递单号
1、查找所有未处理的单据写入临时表，待处理（未处理的标识是：ProcessResult为空，且ProcessDate为空)
2、核查数据，更新错误的信息
   A、发货单号为空
   B、快递公司为空
   C、快递单号为空
   D、发货单号在DMS中不存在
3、更新正确的发货单信息
   A、更新数据
4、错误信息发邮件通知相关人员
5、使用临时表数据更新正式接口表   
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
        
      --将5天内错误的数据重新更新为“未处理”，重新处理一下
      UPDATE interface.T_I_WMS_DN_UPDATE
         SET ProcessResult = NULL
       WHERE     CreateDate >= dateadd (day, -5, getdate ())
             AND ProcessResult = 'Error'
             AND SAPDeliveryNbr IS NOT NULL
      
      --将未处理的数据写入临时表，待处理
      INSERT INTO #DNTracking(SAPDeliveryNbr, ExpressCompany, ExpressCoDeliveryNbr, CreateDate, ProcessResult)
      SELECT SAPDeliveryNbr, ExpressCompany, ExpressCoDeliveryNbr, CreateDate, ProcessResult 
        FROM interface.T_I_WMS_DN_UPDATE
       WHERE ProcessResult IS NULL
      
      
      --核查数据，更新错误的信息
      --A、发货单号为空
      --B、快递公司为空
      --C、快递单号为空
      --D、发货单号在DMS中不存在
      update #DNTracking set ProcessResult='Error',ErrorDescription = '发货单号为空;' where SAPDeliveryNbr is null or SAPDeliveryNbr=''
      update #DNTracking set ProcessResult='Error',ErrorDescription = isnull(ErrorDescription,'') + '快递公司为空;'  where ExpressCompany is null or ExpressCompany=''
      update #DNTracking set ProcessResult='Error',ErrorDescription = isnull(ErrorDescription,'') + '快递单号为空;'  where ExpressCoDeliveryNbr is null or ExpressCoDeliveryNbr='' 
      update #DNTracking set ProcessResult='Error',ErrorDescription = isnull(ErrorDescription,'') + '发货单号在DMS中不存在;'  
       where SAPDeliveryNbr is not null and SAPDeliveryNbr<>''
       and not exists (select 1 from POReceiptHeader H where H.PRH_SAPShipmentID = SAPDeliveryNbr )
       
      --更新正确的发货单信息
      update #DNTracking set ProcessResult = 'Success' where ProcessResult is null
      
      --更新数据处理时间
      update #DNTracking set HandleDate = @NowDate      
      
      --更新数据到正式表
      UPDATE PRD
      SET PRD.ProcessResult = TMP.ProcessResult
      FROM interface.T_I_WMS_DN_UPDATE PRD,#DNTracking TMP
      where isnull(PRD.SAPDeliveryNbr,'NULL') = isnull(TMP.SAPDeliveryNbr,'NULL')
      and isnull(PRD.ExpressCompany,'NULL') = isnull(TMP.ExpressCompany,'NULL')
      and isnull(PRD.ExpressCoDeliveryNbr,'NULL') = isnull(TMP.ExpressCoDeliveryNbr,'NULL')
      and isnull(PRD.CreateDate,'2999-01-01') = ISNULL(TMP.CreateDate,'2999-01-01')
      and PRD.ProcessResult IS NULL     
      
      --更新到收货表     
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
        --获取错误信息
        DELETE FROM interface.T_I_WMS_DN_UPDATE_TMP
        INSERT INTO interface.T_I_WMS_DN_UPDATE_TMP(TAB_PK,[SAP发货单号],[快递公司],[快递单号],[创建日期],[错误描述])
        SELECT 1,SAPDeliveryNbr,ExpressCompany,ExpressCoDeliveryNbr,convert(nvarchar(20),CreateDate,120),ErrorDescription
          FROM #DNTracking where ErrorDescription is NOT NULL AND SAPDeliveryNbr IS Not null AND SAPDeliveryNbr<>''
        
        
        DECLARE @DetailRtnMsg nvarchar(MAX)
        EXEC dbo.Proc_getHtmlTable '1','TAB_PK','interface.T_I_WMS_DN_UPDATE_TMP',@DetailRtnMsg OUTPUT  
        
      
         --错误信息发邮件通知相关人员
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
      
      --记录错误日志开始
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError = '行' + CONVERT (NVARCHAR (10), @error_line) + '出错[错误号' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
      SET @RtnMsg = @vError      
      RETURN -1
   END CATCH
GO


