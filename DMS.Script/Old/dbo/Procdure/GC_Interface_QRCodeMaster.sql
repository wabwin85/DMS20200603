DROP PROCEDURE [dbo].[GC_Interface_QRCodeMaster]
GO


/*
��ά��ƽ̨�ϴ���ά��������
1����ά��ƽ̨ͨ���ӿ��ϴ����ݣ���ʱ@BatchNbr��@ClientID����Ϊ��
2��ϵͳ�������ݲ�У������׼ȷ�ԣ���д����ȷ����������ʽ��QRCodeMaster
   --��ά���Ƿ���ڡ�״̬�Ƿ�Ϊ1��0�����������Ƿ���ڣ�����������д������Ϣ 
   --�����ʽ�����Ѵ��ڴ˶�ά�룬�����״̬
   --�����ʽ����û�д˶�ά�룬������
*/

CREATE PROCEDURE [dbo].[GC_Interface_QRCodeMaster]
   @BatchNbr       NVARCHAR (30),
   @ClientID       NVARCHAR (50),
   @IsValid        NVARCHAR (20) OUTPUT,
   @RtnMsg         NVARCHAR (500) OUTPUT
AS
   DECLARE @ErrorCount   INTEGER 
   DECLARE @SysUserId   UNIQUEIDENTIFIER  
   DECLARE @EmptyGuid   UNIQUEIDENTIFIER

   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN

      SET @IsValid = 'Success'
      SET @RtnMsg = ''
      SET @SysUserId = '00000000-0000-0000-0000-000000000000'
      SET @EmptyGuid = '00000000-0000-0000-0000-000000000000'

		  /* ���´�����Ϣ */
		  UPDATE InterfaceQRCodeMaster
			 SET QRC_ErrorMsg = N'��ά�벻����'
		   WHERE (InterfaceQRCodeMaster.QRC_QRCode IS NULL OR InterfaceQRCodeMaster.QRC_QRCode	= '')
				 AND InterfaceQRCodeMaster.QRC_BatchNbr = @BatchNbr

		  UPDATE InterfaceQRCodeMaster
			 SET QRC_ErrorMsg =
					 (CASE
						WHEN QRC_ErrorMsg IS NULL
						THEN
						   N'��ά��״̬����ȷ(1������Ч��0������Ч)'
						ELSE
						   QRC_ErrorMsg + N',��ά��״̬����ȷ(1������Ч��0������Ч)'
					  END)
		   WHERE InterfaceQRCodeMaster.QRC_Status NOT IN (1,0)				
				 AND InterfaceQRCodeMaster.QRC_BatchNbr = @BatchNbr

		 UPDATE InterfaceQRCodeMaster
			 SET QRC_ErrorMsg =
					 (CASE
						WHEN QRC_ErrorMsg IS NULL
						THEN
						   N'��ά������ʱ�������д'
						ELSE
						   QRC_ErrorMsg + N',��ά������ʱ�������д'
					  END)
		   WHERE InterfaceQRCodeMaster.QRC_CreateDate IS NULL				
				 AND InterfaceQRCodeMaster.QRC_BatchNbr = @BatchNbr
         
     
      /* ����ȷ������д����ʽ�� */
      --����
      INSERT INTO QRCodeMaster(QRM_ID,QRM_QRCode,QRM_Status,QRM_CreateDate,QRM_UserCode,QRM_Channel,QRM_ImportDate,QRM_UpdateDate)
      SELECT Newid(),IQR.QRC_QRCode,IQR.QRC_Status,IQR.QRC_CreateDate,IQR.QRC_UserCode,IQR.QRC_Channel,getdate(),null
      FROM InterfaceQRCodeMaster AS IQR
      where IQR.QRC_BatchNbr = @BatchNbr and IQR.QRC_ErrorMsg IS NULL
      AND NOT Exists (select 1 from dbo.QRCodeMaster AS QRM where QRM.QRM_QRCode = IQR.QRC_QRCode )
      
      --����
      UPDATE QRM
         SET QRM.QRM_Status = IQR.QRC_Status, QRM_CreateDate = IQR.QRC_CreateDate, 
             QRM_UserCode = IQR.QRC_UserCode, QRM_Channel = IQR.QRC_Channel,
             QRM_UpdateDate = getdate()
        FROM InterfaceQRCodeMaster AS IQR , QRCodeMaster AS QRM
       WHERE IQR.QRC_BatchNbr = @BatchNbr 
         AND IQR.QRC_ErrorMsg IS NULL
         AND QRM.QRM_QRCode = IQR.QRC_QRCode
 		 
      COMMIT TRAN

      --��¼�ɹ���־
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Success', ''

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
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Failure', @vError

      RETURN -1
   END CATCH

GO


