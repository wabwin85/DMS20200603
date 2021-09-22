DROP PROCEDURE [dbo].[GC_InterfaceData_SetStatus]
GO


/*
库存上报——生成销售单
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

   /*将传递进来的接口日志ID字符串转换成纵表*/
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
          --如果是获取平台订单或是获取二级经销商订单
          IF(@DataType='LpOrderDownloader' OR @DataType='T2OrderDownloader')
             BEGIN
               UPDATE PurchaseOrderInterface SET POI_Status=@Status,POI_UpdateDate=GETDATE(),POI_CreateUser=@UserId WHERE POI_ID=@DataId
             END
            

          --如果获取波科发货数据
           IF(@DataType='SapDeliveryDownloader')
             BEGIN
               UPDATE DeliveryInterface SET DI_Status=@Status,DI_UpdateDate=GETDATE(),DI_UpdateUser=@UserId WHERE DI_ID=@DataId
             END
           --如果是获取经销商寄售产品
           IF(@DataType='T2ConsignmentSalesDownloader')
             BEGIN
                UPDATE SalesInterface SET SI_Status=@Status,SI_UpdateDate=GETDATE(),SI_UpdateUser=@UserId WHERE SI_ID=@DataId
             END
            --如果是LP退货数据下载或二级经销商退货数据下载或二级经销商寄售转销售数据接口
            IF(@DataType='LpReturnDownloader' OR @DataType='T2ReturnDownloader' OR @DataType='T2ConsignToSellingDownloader')
             BEGIN
               UPDATE AdjustInterface SET AI_Status=@Status,AI_UpdateDate=GETDATE(),AI_UpdateUser=@UserId WHERE AI_ID=@DataId
             END
             --如果是平台ERP投诉数据接口
             IF(@DataType='LpComplainDownloader')
              BEGIN
                UPDATE ComplainInterface SET CI_Status=@Status,CI_UpdateDate=GETDATE(),CI_UpdateUser=@UserId WHERE CI_ID=@DataId
              END
              --平台下载借货入库数据
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
	  --记录错误日志开始
      DECLARE @error_line   INT
      DECLARE @error_number   INT
      DECLARE @error_message   NVARCHAR (256)
      DECLARE @vError   NVARCHAR (1000)
      SET @error_line = ERROR_LINE ()
      SET @error_number = ERROR_NUMBER ()
      SET @error_message = ERROR_MESSAGE ()
      SET @vError =
				 '行'
			   + CONVERT (NVARCHAR (10), @error_line)
			   + '出错[错误号'
			   + CONVERT (NVARCHAR (10), @error_number)
			   + '],'
			   + @error_message
		SET @RtnMsg = @vError
      RETURN -1
   END CATCH

GO


