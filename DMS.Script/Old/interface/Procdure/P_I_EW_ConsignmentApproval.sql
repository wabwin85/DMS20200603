DROP PROCEDURE [interface].[P_I_EW_ConsignmentApproval]	
GO

/*
* E-Workflow 审批
*/
CREATE PROCEDURE [interface].[P_I_EW_ConsignmentApproval]	
	@OrderNo nvarchar(200),
	@ApprovalResult nvarchar(10),
	@Remark nvarchar(2000),
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(2000)  OUTPUT
AS
SET NOCOUNT ON
BEGIN TRY

BEGIN TRAN
	
	DECLARE @SysUserId uniqueidentifier
	DECLARE @OrderId uniqueidentifier

	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''

	SET @Remark = ISNULL(@Remark,'')

	IF NOT EXISTS(SELECT 1 
				FROM ConsignmentApplyHeader
			WHERE CAH_OrderNo = @OrderNo
				AND CAH_CAH_ID IS NULL)
		BEGIN
			SET @RtnVal = 'Error'
			SET @RtnMsg = '短期寄售申请单不存在'
		END
	
	IF LEN(@RtnMsg) = 0 AND NOT EXISTS(SELECT 1 
				FROM ConsignmentApplyHeader
			WHERE CAH_OrderNo = @OrderNo
				AND CAH_CAH_ID IS NULL
				AND CAH_OrderStatus IN ('Submitted','Draft'))
		BEGIN
			SET @RtnVal = 'Error'
			SET @RtnMsg = '短期寄售申请单已被审批'
		END
	
	IF LEN(@RtnMsg) = 0 AND (@ApprovalResult != 'agree' AND @ApprovalResult != 'disagree' AND @ApprovalResult != 'submit')
		BEGIN
			SET @RtnVal = 'Error'
			SET @RtnMsg = '审批结果不正确'
		END

	IF LEN(@RtnMsg) = 0
		BEGIN
			SELECT TOP 1 @OrderId = CAH_ID FROM ConsignmentApplyHeader 
				WHERE CAH_OrderNo = @OrderNo
					AND CAH_OrderStatus IN ('Submitted','Draft')
					AND CAH_CAH_ID IS NULL

					PRINT @OrderId

			IF @ApprovalResult = 'agree'
				BEGIN
					EXEC GC_PurchaseOrder_AutoGenConsignmentForT1 @OrderId,@RtnVal,@RtnMsg
					
					--若存储过程执行失败，那么设置错误
					IF @RtnVal='Success'
						BEGIN
							UPDATE ConsignmentApplyHeader 
								SET CAH_ApproveDate = GETDATE(), 
									CAH_ApproveUser = @SysUserId,
									CAH_OrderStatus = 'Approved'
								WHERE CAH_ID = @OrderId

							INSERT INTO PurchaseOrderLog(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
							VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Approve',@Remark)
							
						END
					ELSE
						BEGIN
							SET @RtnVal = 'Error'
						END
				END
			ELSE IF @ApprovalResult = 'disagree'
				BEGIN
					UPDATE ConsignmentApplyHeader 
						SET CAH_ApproveDate = GETDATE(), 
							CAH_ApproveUser = @SysUserId,
							CAH_OrderStatus = 'Rejected'
						WHERE CAH_ID = @OrderId

					INSERT INTO PurchaseOrderLog(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
					VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Reject',@Remark)
				END
			ELSE
				BEGIN
					UPDATE ConsignmentApplyHeader 
								SET CAH_OrderStatus = 'Submitted'
								WHERE CAH_ID = @OrderId

					INSERT INTO PurchaseOrderLog
					VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Download','')
				END
		END

COMMIT TRAN

SET NOCOUNT OFF
RETURN 1

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


