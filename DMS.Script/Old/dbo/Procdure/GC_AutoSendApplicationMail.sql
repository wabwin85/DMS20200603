DROP PROCEDURE [dbo].[GC_AutoSendApplicationMail]
GO

/*
1��Endo�캣�Ķ������˻���������ת�������뵥�ύ���ʼ���RSM
2������������Ķ��������޶�����������������Ա
*/

CREATE PROCEDURE [dbo].[GC_AutoSendApplicationMail]
   @IsValid NVARCHAR (20) OUTPUT, @RtnMsg NVARCHAR (500) OUTPUT
AS
DECLARE @SysUserId   UNIQUEIDENTIFIER
DECLARE @EmptyGuid   UNIQUEIDENTIFIER
DECLARE @ErrCnt   INT
DECLARE @RowCnt   INT
DECLARE @HTML   NVARCHAR (MAX)
DECLARE @SubjectToRSM   NVARCHAR (500)
DECLARE @TemplateToRSM   NVARCHAR (MAX)
DECLARE @SubjectTo3RD   NVARCHAR (500)
DECLARE @TemplateTo3RD   NVARCHAR (MAX)

DECLARE @SubRtnValue   NVARCHAR (500)
DECLARE @SubRtnMsg   NVARCHAR (500)

--������ƥ���¼ʱʹ��
DECLARE @MSLID   UNIQUEIDENTIFIER
DECLARE @FormNbr   NVARCHAR (50)
DECLARE @FormType   NVARCHAR (50)
DECLARE @MailType   NVARCHAR (50)
DECLARE @Remark   NVARCHAR (50)
DECLARE @Email   NVARCHAR (50)
DECLARE @UserName   NVARCHAR (50)

SET  NOCOUNT ON

BEGIN TRY
   BEGIN TRAN

   SET @IsValid = 'Success'
   SET @RtnMsg = ''
   SET @SysUserId = '00000000-0000-0000-0000-000000000000'
   SET @EmptyGuid = '00000000-0000-0000-0000-000000000000'

   SELECT @SubjectToRSM = MMT_Subject,
          @TemplateToRSM = MMT_Body
   FROM MailMessageTemplate
   WHERE MMT_Code = 'EMAIL_DEALER_APPLICATION_TOENDORSM'

   SELECT @SubjectTo3RD = MMT_Subject,
          @TemplateTo3RD = MMT_Body
   FROM MailMessageTemplate
   WHERE MMT_Code = 'EMAIL_DEALER_T2ORDER_TO3RDPAYMENT'

   CREATE TABLE #ApplicationAutoSend
   (
      [MSL_ID]           UNIQUEIDENTIFIER NOT NULL,
      [MSL_FormNbr]      NVARCHAR (50) NULL,
      [MSL_FormType]     NVARCHAR (50) NULL,
      [MSL_MailType]     NVARCHAR (50) NULL,
      [MSL_CreateDate]   DATETIME NULL,
      [MSL_Remark]       NVARCHAR (50) NULL,
      [MSL_Email]        NVARCHAR (50) NULL,
      [MSL_UserName]     NVARCHAR (50) NULL
   )

   --д�붩������
   INSERT INTO #ApplicationAutoSend
      SELECT H.POH_ID,
             H.POH_OrderNo,
             'Order',
             'ToEndoRSM',
             getdate (),
             '',
             SR.Email,
             SR.[Name]
        FROM PurchaseOrderHeader H (NOLOCK)
             INNER JOIN interface.T_I_QV_SalesRep SR (NOLOCK)
                ON (H.POH_SalesAccount = SR.UserAccount)
       WHERE     POH_CreateType = 'Manual'
             AND POH_OrderStatus NOT IN ('Draft')
             AND POH_SalesAccount IS NOT NULL
             AND POH_SalesAccount <> ''
             AND H.POH_CreateDate > dateadd (dd, -10, getdate ())
             AND NOT EXISTS
                    (SELECT 1
                       FROM dbo.Mail_ApplicationAutoSendLog MLog
                      WHERE     MLog.MSL_FormNbr = H.POH_OrderNo
                            AND MLog.MSL_FormType = 'Order'
                            AND MLog.MSL_MailType = 'ToEndoRSM')

   --д�����������
   INSERT INTO #ApplicationAutoSend
      SELECT H.POH_ID,
             H.POH_OrderNo,
             'Order',
             'To3rdPayment',
             getdate (),
             '',
             '' AS Email,
             '' AS [Name]
        FROM PurchaseOrderHeader H (NOLOCK)
       WHERE     POH_CreateType = 'Manual'
             AND POH_OrderStatus NOT IN ('Draft')
             AND H.POH_SAP_OrderNo = '����������'
             AND H.POH_CreateDate > dateadd (dd, -10, getdate ())
             AND NOT EXISTS
                    (SELECT 1
                       FROM dbo.Mail_ApplicationAutoSendLog MLog
                      WHERE     MLog.MSL_FormNbr = H.POH_OrderNo
                            AND MLog.MSL_FormType = 'Order'
                            AND MLog.MSL_MailType = 'To3rdPayment')

   --д���˻���������ת��������MSL_FormNbr
   INSERT INTO #ApplicationAutoSend
      SELECT H.IAH_ID,
             H.IAH_Inv_Adj_Nbr,
             'Return',
             'ToEndoRSM',
             getdate (),
             '',
             SR.Email,
             SR.[Name]
        FROM InventoryAdjustHeader H (NOLOCK)
             INNER JOIN interface.T_I_QV_SalesRep SR (NOLOCK)
                ON (H.IAH_RSM = SR.UserAccount)
       WHERE     H.IAH_Status NOT IN ('Draft')
             AND H.IAH_RSM IS NOT NULL
             AND H.IAH_RSM <> ''
             AND H.IAH_CreatedDate > dateadd (dd, -10, getdate ())
             AND NOT EXISTS
                    (SELECT 1
                       FROM dbo.Mail_ApplicationAutoSendLog MLog
                      WHERE     MLog.MSL_FormNbr = H.IAH_Inv_Adj_Nbr
                            AND MLog.MSL_FormType = 'Return'
                            AND MLog.MSL_MailType = 'ToEndoRSM')



   --�ж��Ƿ��м�¼������м�¼���������д���
   SELECT @RowCnt = count (*) FROM #ApplicationAutoSend

   IF @RowCnt > 0
      BEGIN
         --�α����SAP������
         DECLARE
            curAutoSend CURSOR FOR SELECT [MSL_ID],
                                          [MSL_FormNbr],
                                          [MSL_FormType],
                                          [MSL_MailType],
                                          [MSL_Remark],
                                          [MSL_Email],
                                          [MSL_UserName]
                                     FROM #ApplicationAutoSend

         OPEN curAutoSend
         FETCH NEXT FROM curAutoSend
              INTO @MSLID,
                   @FormNbr,
                   @FormType,
                   @MailType,
                   @Remark,
                   @Email,
                   @UserName

         WHILE @@FETCH_STATUS = 0
         BEGIN
            --����Procedure��Ȼ�����ʼ�
            IF (@FormType = 'Order' AND @MailType = 'ToEndoRSM')
               BEGIN
                  SET @HTML = ''
                  EXEC [dbo].[GC_GetApplyOrderHtml] @MSLID,
                                                       N'Id',
                                                       N'V_PurchaseOrder',
                                                       N'Id',
                                                       N'V_PurchaseOrderTable',
                                                       @SubRtnValue OUTPUT,
                                                       @HTML OUTPUT

                  INSERT INTO MailMessageQueue (MMQ_ID,
                                                MMQ_QueueNo,
                                                MMQ_From,
                                                MMQ_To,
                                                MMQ_Subject,
                                                MMQ_Body,
                                                MMQ_Status,
                                                MMQ_CreateDate,
                                                MMQ_SendDate)
                     SELECT newid (),
                            'email',
                            '',
                            @Email,
                            @SubjectToRSM + '(���ݺţ�' + @FormNbr + ')',
                            replace (
                               replace (@TemplateToRSM, '{#RSM}', @UserName),
                               '{#HTML}',
                               @HTML),
                            'Waiting',
                            getdate (),
                            NULL
               END
            ELSE
               IF (@FormType = 'Return' AND @MailType = 'ToEndoRSM')
                  BEGIN
                     SET @HTML = ''
                     EXEC [dbo].[GC_GetApplyOrderHtml] @MSLID,
                                                          N'Id',
                                                          N'V_InventoryAdjust',
                                                          N'Id',
                                                          N'V_InventoryAdjustTable',
                                                          @SubRtnValue OUTPUT,
                                                          @HTML OUTPUT

                     INSERT INTO MailMessageQueue (MMQ_ID,
                                                   MMQ_QueueNo,
                                                   MMQ_From,
                                                   MMQ_To,
                                                   MMQ_Subject,
                                                   MMQ_Body,
                                                   MMQ_Status,
                                                   MMQ_CreateDate,
                                                   MMQ_SendDate)
                        SELECT newid (),
                               'email',
                               '',
                               @Email,
                               @SubjectToRSM + '(���ݺţ�' + @FormNbr + ')',
                               replace (
                                  replace (@TemplateToRSM,
                                           '{#RSM}',
                                           @UserName),
                                  '{#HTML}',
                                  @HTML),
                               'Waiting',
                               getdate (),
                               NULL
                  END
               ELSE
                  IF (@FormType = 'Order' AND @MailType = 'To3rdPayment')
                     BEGIN
                        SET @HTML = ''
                        EXEC [dbo].[GC_GetApplyOrderHtml] @MSLID,
                                                             N'Id',
                                                             N'V_PurchaseOrder',
                                                             N'Id',
                                                             N'V_PurchaseOrderTable',
                                                             @SubRtnValue OUTPUT,
                                                             @HTML OUTPUT

                        INSERT INTO MailMessageQueue (MMQ_ID,
                                                      MMQ_QueueNo,
                                                      MMQ_From,
                                                      MMQ_To,
                                                      MMQ_Subject,
                                                      MMQ_Body,
                                                      MMQ_Status,
                                                      MMQ_CreateDate,
                                                      MMQ_SendDate)
                           SELECT newid (),
                                  'email',
                                  '',
                                  MDA_MailAddress,
                                  @SubjectTo3RD + '( �����ţ�' + @FormNbr + ')',
                                  replace (@TemplateTo3RD, '{#HTML}', @HTML),
                                  'Waiting',
                                  getdate (),
                                  NULL
                            FROM MailDeliveryAddress
                            WHERE  MDA_ActiveFlag=1 and MDA_MailType='3RDPayment'
                     END


            FETCH NEXT FROM curAutoSend
                 INTO @MSLID,
                      @FormNbr,
                      @FormType,
                      @MailType,
                      @Remark,
                      @Email,
                      @UserName
         END

         CLOSE curAutoSend
         DEALLOCATE curAutoSend


         --Insert into log table
         INSERT INTO dbo.Mail_ApplicationAutoSendLog (MSL_ID,
                                                      MSL_FormNbr,
                                                      MSL_FormType,
                                                      MSL_MailType,
                                                      MSL_CreateDate,
                                                      MSL_Remark,
                                                      MSL_Email)
            SELECT newid(),
                   MSL_FormNbr,
                   MSL_FormType,
                   MSL_MailType,
                   MSL_CreateDate,
                   MSL_Remark,
                   MSL_Email
              FROM #ApplicationAutoSend
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
   SET @vError =
            '��'
          + CONVERT (NVARCHAR (10), @error_line)
          + '����[�����'
          + CONVERT (NVARCHAR (10), @error_number)
          + '],'
          + @error_message
   SET @RtnMsg = @vError
   RETURN -1
END CATCH

GO


