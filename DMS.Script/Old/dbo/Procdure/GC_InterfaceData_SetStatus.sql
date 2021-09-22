DROP PROCEDURE [dbo].[GC_InterfaceData_SetStatus]
GO


/*
����ϱ������������۵�
*/
Create PROCEDURE [dbo].[GC_InterfaceData_SetStatus]
   @UserId               UNIQUEIDENTIFIER,
   @DataType              NVARCHAR (50),
   @InterfaceString      NVARCHAR (MAX),
   @Status               NVARCHAR (20),
   @RtnVal               NVARCHAR (20) OUTPUT,
   @RtnMsg               NVARCHAR (1000) OUTPUT
AS
   DECLARE @DataId		UNIQUEIDENTIFIER

   /*�����ݽ����Ľӿ���־ID�ַ���ת�����ݱ�*/
   DECLARE InterfaceDataCursor CURSOR FOR SELECT VAL
                             FROM dbo.GC_Fn_SplitStringToTable (
                                     @InterfaceString,
                                     ';') A
								
   SET  NOCOUNT ON

   BEGIN TRY
      BEGIN TRAN
      SET @RtnVal = 'Success'
      SET @RtnMsg = ''

      OPEN InterfaceDataCursor
      FETCH NEXT FROM InterfaceDataCursor INTO @DataId

      WHILE @@FETCH_STATUS = 0
		BEGIN
          --����ǻ�ȡƽ̨�������ǻ�ȡ���������̶���
          IF(@DataType='LpOrderDownloader' OR @DataType='T2OrderDownloader')
             BEGIN
               UPDATE PurchaseOrderInterface SET POI_Status=@Status,POI_UpdateDate=GETDATE(),POI_CreateUser=@UserId WHERE POI_ID=@DataId
             END
            

          --�����ȡ���Ʒ�������
           IF(@DataType='SapDeliveryDownloader')
             BEGIN
               UPDATE DeliveryInterface SET DI_Status=@Status,DI_UpdateDate=GETDATE(),DI_UpdateUser=@UserId WHERE DI_ID=@DataId
             END
           --����ǻ�ȡ�����̼��۲�Ʒ
           IF(@DataType='T2ConsignmentSalesDownloader')
             BEGIN
                UPDATE SalesInterface SET SI_Status=@Status,SI_UpdateDate=GETDATE(),SI_UpdateUser=@UserId WHERE SI_ID=@DataId
             END
            --�����LP�˻��������ػ�����������˻��������ػ���������̼���ת�������ݽӿ�
            IF(@DataType='LpReturnDownloader' OR @DataType='T2ReturnDownloader' OR @DataType='T2ConsignToSellingDownloader')
             BEGIN
               UPDATE AdjustInterface SET AI_Status=@Status,AI_UpdateDate=GETDATE(),AI_UpdateUser=@UserId WHERE AI_ID=@DataId
             END
             --�����ƽ̨ERPͶ�����ݽӿ�
             IF(@DataType='LpComplainDownloader')
              BEGIN
                UPDATE ComplainInterface SET CI_Status=@Status,CI_UpdateDate=GETDATE(),CI_UpdateUser=@UserId WHERE CI_ID=@DataId
              END
              --ƽ̨���ؽ���������
             IF(@DataType='LpRentDownloader')
              BEGIN
               UPDATE LpRentInterface SET LRI_Status=@Status,LRI_UpdateDate=GETDATE(),LRI_UpdateUser=@UserId WHERE LRI_ID=@DataId
              END 
              FETCH NEXT FROM InterfaceDataCursor INTO @DataId
		  END
      CLOSE InterfaceDataCursor
      DEALLOCATE InterfaceDataCursor

      COMMIT TRAN

      SET  NOCOUNT OFF
      RETURN 1
   END TRY
   BEGIN CATCH
      SET  NOCOUNT OFF
      ROLLBACK TRAN
      SET @RtnVal = 'Failure'
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


