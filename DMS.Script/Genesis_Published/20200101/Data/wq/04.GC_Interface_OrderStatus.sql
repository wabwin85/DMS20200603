USE [GenesisDMS_PRD]
GO
/****** Object:  StoredProcedure [dbo].[GC_Interface_OrderStatus]    Script Date: 2019/12/25 17:11:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GC_Interface_OrderStatus]
   @BatchNbr       NVARCHAR (30),
   @ClientID       NVARCHAR (50),
   --@SubCompanyId   NVARCHAR(50),--20191105,增加分子公司和品牌分组
   --@BrandId        NVARCHAR(50),
   @IsValid        NVARCHAR (20) OUTPUT,
   @RtnMsg         NVARCHAR (500) OUTPUT
AS
   BEGIN TRY
	  BEGIN TRAN
	  SET @IsValid='Faild'
	  SET @RtnMsg=''
	  --判断订单号是否存在
	  UPDATE InterfaceOrderStatus
	  SET ProblemDescription = ISNULL(ProblemDescription,'') + ';'+'订单编号未存在DMS系统中'
	  WHERE NOT EXISTS(SELECT 1 FROM PurchaseOrderHeader WHERE POH_OrderNo=OrderNo)
	  AND ClientID=@ClientID AND BatchNbr = @BatchNbr

	  --判断订单状态是否正确

	  UPDATE InterfaceOrderStatus
	  SET ProblemDescription = ISNULL(ProblemDescription,'') + ';'+'订单状态错误'
	  WHERE NOT EXISTS(SELECT 1 FROM Lafite_DICT WHERE DICT_TYPE='CONST_Order_Status'
	  AND DICT_KEY = OrderStatus AND OrderStatus IN ('Rejected','Confirmed'))
	  AND ClientID=@ClientID AND BatchNbr = @BatchNbr

	  --判断是否有权限修改当前订单
	  --UPDATE InterfaceOrderStatus
	  --SET ProblemDescription = ISNULL(ProblemDescription,'') + ';'+'无权更新当前订单状态'
	  --WHERE EXISTS(SELECT 1 FROM PurchaseOrderHeader WHERE POH_OrderNo=OrderNo
	  --AND POH_OrderStatus<>'Uploaded') AND ClientID=@ClientID AND BatchNbr = @BatchNbr

	  if((SELECT COUNT(1) FROM InterfaceOrderStatus WHERE ISNULL(ProblemDescription,'')<>'' 
	  AND ClientID=@ClientID AND BatchNbr = @BatchNbr)<=0)
	  BEGIN
	  --更新处理时间
		Update ios
		SET ios.ProcessDate = GETDATE()
		FROM InterfaceOrderStatus ios
		INNER JOIN PurchaseOrderHeader poh ON ios.OrderNo=poh.POH_OrderNo
		WHERE ClientID=@ClientID AND BatchNbr = @BatchNbr
	  --更新订单状态

	    DECLARE @OrderNO NVARCHAR(50)
		DECLARE @OrderStatus NVARCHAR(50)
		DECLARE cursor_Order CURSOR FOR --定义游标
			SELECT OrderNo,OrderStatus FROM InterfaceOrderStatus WHERE ClientID=@ClientID AND BatchNbr = @BatchNbr
		OPEN cursor_Order --打开游标
		FETCH NEXT FROM cursor_Order INTO @OrderNO,@OrderStatus  --抓取下一行游标数据
		WHILE @@FETCH_STATUS = 0
			BEGIN
			    --更新订单状态
				UPDATE 	poh set poh.POH_OrderStatus=@OrderStatus
				FROM PurchaseOrderHeader poh
				WHERE poh.POH_OrderNo=@OrderNO
				--记录订单日志
				INSERT INTO PurchaseOrderLog(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
				Values(NEWID(),(SELECT POH_ID FROM PurchaseOrderHeader WHERE POH_OrderNo=@OrderNO AND POH_LastVersion=0),'00000000-0000-0000-0000-000000000000'
				,GETDATE(),'UpdateOrderStatus','金蝶上传更新订单状态')
				FETCH NEXT FROM cursor_Order INTO @OrderNO,@OrderStatus
			END
		CLOSE cursor_Order --关闭游标
		DEALLOCATE cursor_Order --释放游标
		--Update poh
		--SET poh.POH_OrderStatus = ios.OrderStatus
		--FROM PurchaseOrderHeader poh
		--INNER JOIN InterfaceOrderStatus ios ON ios.OrderNo=poh.POH_OrderNo
		--WHERE ClientID=@ClientID AND BatchNbr = @BatchNbr


		SET @IsValid='Success'
		SET @RtnMsg=''
	  END

      COMMIT TRAN
      
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
      SET @vError = 'GC_Interface_OrderStatus_行:' + CONVERT (NVARCHAR (10), @error_line) + '出错[错误号' + CONVERT (NVARCHAR (10), @error_number) + '],' + @error_message
      SET @RtnMsg = @vError
      --EXEC dbo.GC_Interface_Log 'Shipment', 'Failure', @vError

      RETURN -1
   END CATCH



