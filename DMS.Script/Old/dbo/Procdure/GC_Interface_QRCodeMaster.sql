DROP PROCEDURE [dbo].[GC_Interface_QRCodeMaster]
GO


/*
二维码平台上传二维码主数据
1、二维码平台通过接口上传数据，此时@BatchNbr和@ClientID不能为空
2、系统保存数据并校验数据准确性，并写入正确的数据至正式表：QRCodeMaster
   --二维码是否存在、状态是否为1或0、生成日期是否存在，错误数据填写错误信息 
   --如果正式表中已存在此二维码，则更新状态
   --如果正式表中没有此二维码，则新增
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

		  /* 更新错误信息 */
		  UPDATE InterfaceQRCodeMaster
			 SET QRC_ErrorMsg = N'二维码不存在'
		   WHERE (InterfaceQRCodeMaster.QRC_QRCode IS NULL OR InterfaceQRCodeMaster.QRC_QRCode	= '')
				 AND InterfaceQRCodeMaster.QRC_BatchNbr = @BatchNbr

		  UPDATE InterfaceQRCodeMaster
			 SET QRC_ErrorMsg =
					 (CASE
						WHEN QRC_ErrorMsg IS NULL
						THEN
						   N'二维码状态不正确(1代表有效，0代表无效)'
						ELSE
						   QRC_ErrorMsg + N',二维码状态不正确(1代表有效，0代表无效)'
					  END)
		   WHERE InterfaceQRCodeMaster.QRC_Status NOT IN (1,0)				
				 AND InterfaceQRCodeMaster.QRC_BatchNbr = @BatchNbr

		 UPDATE InterfaceQRCodeMaster
			 SET QRC_ErrorMsg =
					 (CASE
						WHEN QRC_ErrorMsg IS NULL
						THEN
						   N'二维码生成时间必须填写'
						ELSE
						   QRC_ErrorMsg + N',二维码生成时间必须填写'
					  END)
		   WHERE InterfaceQRCodeMaster.QRC_CreateDate IS NULL				
				 AND InterfaceQRCodeMaster.QRC_BatchNbr = @BatchNbr
         
     
      /* 将正确的数据写入正式表 */
      --新增
      INSERT INTO QRCodeMaster(QRM_ID,QRM_QRCode,QRM_Status,QRM_CreateDate,QRM_UserCode,QRM_Channel,QRM_ImportDate,QRM_UpdateDate)
      SELECT Newid(),IQR.QRC_QRCode,IQR.QRC_Status,IQR.QRC_CreateDate,IQR.QRC_UserCode,IQR.QRC_Channel,getdate(),null
      FROM InterfaceQRCodeMaster AS IQR
      where IQR.QRC_BatchNbr = @BatchNbr and IQR.QRC_ErrorMsg IS NULL
      AND NOT Exists (select 1 from dbo.QRCodeMaster AS QRM where QRM.QRM_QRCode = IQR.QRC_QRCode )
      
      --更新
      UPDATE QRM
         SET QRM.QRM_Status = IQR.QRC_Status, QRM_CreateDate = IQR.QRC_CreateDate, 
             QRM_UserCode = IQR.QRC_UserCode, QRM_Channel = IQR.QRC_Channel,
             QRM_UpdateDate = getdate()
        FROM InterfaceQRCodeMaster AS IQR , QRCodeMaster AS QRM
       WHERE IQR.QRC_BatchNbr = @BatchNbr 
         AND IQR.QRC_ErrorMsg IS NULL
         AND QRM.QRM_QRCode = IQR.QRC_QRCode
 		 
      COMMIT TRAN

      --记录成功日志
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Success', ''

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
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Failure', @vError

      RETURN -1
   END CATCH

GO


