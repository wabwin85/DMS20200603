DROP PROCEDURE [interface].[P_I_EW_ConsignmentDelayApproval]	
GO

/*
* E-Workflow ���ڼ�����������
*/
create PROCEDURE [interface].[P_I_EW_ConsignmentDelayApproval]	
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
			SET @RtnMsg = '���ڼ������뵥������'
		END
	
	IF LEN(@RtnMsg) = 0 AND NOT EXISTS(SELECT 1 
				FROM ConsignmentApplyHeader
			WHERE CAH_OrderNo = @OrderNo
				AND CAH_CAH_ID IS NULL
				AND CAH_OrderStatus = 'Approved')
		BEGIN
			SET @RtnVal = 'Error'
			SET @RtnMsg = '���ڼ������뵥δ������ͨ������������������'
		END
	
	IF LEN(@RtnMsg) = 0 AND NOT EXISTS(SELECT 1 
				FROM ConsignmentApplyHeader
			WHERE CAH_OrderNo = @OrderNo
				AND CAH_CAH_ID IS NULL
				AND (CAH_Delay_OrderStatus IN ('Submitted','') OR CAH_Delay_OrderStatus IS NULL))
		BEGIN
			SET @RtnVal = 'Error'
			SET @RtnMsg = '���ڼ������������ѱ�����'
		END

	IF LEN(@RtnMsg) = 0 AND NOT EXISTS(SELECT 1 
				FROM ConsignmentApplyHeader
			WHERE CAH_OrderNo = @OrderNo
				AND CAH_CAH_ID IS NULL
				AND CAH_Delay_OrderStatus IN ('Submitted','')
				AND CAH_Delay_DelayTime != 0)
		BEGIN
			SET @RtnVal = 'Error'
			SET @RtnMsg = '���ڼ������ڴ�������'
		END

	IF LEN(@RtnMsg) = 0 AND (@ApprovalResult != 'agree' AND @ApprovalResult != 'disagree' AND @ApprovalResult != 'submit')
		BEGIN
			SET @RtnVal = 'Error'
			SET @RtnMsg = '�����������ȷ'
		END

	IF LEN(@RtnMsg) = 0
		BEGIN
			SELECT TOP 1 @OrderId = CAH_ID FROM ConsignmentApplyHeader 
				WHERE CAH_OrderNo = @OrderNo
					AND CAH_OrderStatus = 'Approved'
					AND CAH_Delay_OrderStatus IN ('Submitted','')
					AND CAH_CAH_ID IS NULL

					PRINT @OrderId

			IF @ApprovalResult = 'agree'
				BEGIN

					--���洢����ִ��ʧ�ܣ���ô���ô���
					IF @RtnVal='Success'
						BEGIN
							UPDATE ConsignmentApplyHeader 
								SET CAH_Delay_ApproveDate = GETDATE(), 
									CAH_Delay_ApproveUser = @SysUserId,
									CAH_Delay_OrderStatus = 'Approved',
									CAH_Delay_DelayTime = CAH_Delay_DelayTime - 1
								WHERE CAH_ID = @OrderId

							INSERT INTO PurchaseOrderLog(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
							VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Approve','����������'+@Remark)

						END
					ELSE
						BEGIN
							SET @RtnVal = 'Error'
						END
				END
			ELSE IF @ApprovalResult = 'disagree'
				BEGIN
					UPDATE ConsignmentApplyHeader 
						SET CAH_Delay_ApproveDate = GETDATE(), 
							CAH_Delay_ApproveUser = @SysUserId,
							CAH_Delay_OrderStatus = 'Rejected'
						WHERE CAH_ID = @OrderId

					INSERT INTO PurchaseOrderLog(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
					VALUES (NEWID(),@OrderId,@SysUserId,GETDATE(),'Reject','����������'+@Remark)
				END
			ELSE
				BEGIN
					UPDATE ConsignmentApplyHeader 
						SET CAH_Delay_OrderStatus = 'Submitted'
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
    
    --��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
    return -1
    
END CATCH
GO


