SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
ALTER PROCEDURE [Workflow].[Proc_Consignment_UpdateFormStatus]
	@InstanceId uniqueidentifier,
	@OperType nvarchar(100),
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS

DECLARE @ApplyType NVARCHAR(100)
DECLARE @OrderNo NVARCHAR(100)

SELECT @OrderNo=A.CAH_OrderNo FROM ConsignmentApplyHeader A WHERE A.CAH_ID = @InstanceId

IF (SELECT COUNT(1) FROM ConsignmentApplyHeader WHERE CAH_ID = @InstanceId) > 0
	BEGIN
		SET @ApplyType = 'ConsignmentApply'
	END
ELSE IF (SELECT COUNT(1) FROM ConsignmentApplyHeader WHERE LOWER(CAST(CAH_CAH_ID AS NVARCHAR(100))) = LOWER(@InstanceId)) > 0
	BEGIN
		SET @ApplyType = 'DelayApply'
	END


	
DECLARE @SubCompanyId NVARCHAR(50)
DECLARE @BrandId NVARCHAR(50)
DECLARE @ProductlineId NVARCHAR(50)
DECLARE @ApplyStatus NVARCHAR(100)
SELECT @ApplyStatus = CASE WHEN @OperType = 'drafter_submit' THEN 'Submitted'
						WHEN @OperType = 'drafter_abandon' THEN 'Revoke'
						WHEN @OperType = 'handler_pass' THEN 'Submitted'
						WHEN @OperType = 'handler_refuse' THEN 'Rejected'
						WHEN @OperType = 'handler_additionSign' THEN 'Approved'
						WHEN @OperType = 'sys_complete' THEN 'Approved'
						WHEN @OperType = 'sys_abandon' THEN 'Revoke'
						ELSE NULL END

IF @ApplyStatus IS NOT NULL AND @ApplyType = 'ConsignmentApply'
	BEGIN
		UPDATE A SET A.CAH_OrderStatus = @ApplyStatus,
			A.CAH_ApproveDate = GETDATE()
		FROM ConsignmentApplyHeader A
		WHERE A.CAH_ID = @InstanceId

		IF @OperType = 'sys_complete'
			BEGIN
				DECLARE @RtnVal NVARCHAR(200)
				DECLARE @RtnMsg NVARCHAR(MAX)

				SELECT @SubCompanyId=A.SubCompanyId,@BrandId=A.BrandId,@ProductlineId=A.CAH_ProductLine_Id FROM ConsignmentApplyHeader A
		         WHERE A.CAH_ID = @InstanceId
				 IF(ISNULL(@SubCompanyId,'')='' OR ISNULL(@BrandId,'')='')
				 SELECT @SubCompanyId=SubCompanyId,@BrandId=BrandId FROM  dbo.View_ProductLine WHERE Id=@ProductlineId
				--EXEC GC_PurchaseOrder_AutoGenConsignmentForT1 @InstanceId,@RtnVal,@RtnMsg
				EXEC  Consignment.Proc_CreateOrder 'KB','ConsignmentApply',@SubCompanyId,@BrandId,@OrderNo,'1',@RtnVal,@RtnMsg
				
				INSERT INTO PurchaseOrderLog
				(POL_ID,POL_POH_ID,POL_OperUser,POL_OperDate,POL_OperType,POL_OperNote)
				VALUES(newid(),@InstanceId,'00000000-0000-0000-0000-000000000000',GETDATE(),'Approved','提交订单')
				
				INSERT INTO Workflow.WorkflowLog
				SELECT NEWID(),@InstanceId,NULL,GETDATE(),GETDATE(),CASE WHEN @RtnVal = 'Success' THEN 'Success' ELSE 'Failure' END,@RtnMsg,'GC_PurchaseOrder_AutoGenConsignmentForT1',ISNULL(@RtnMsg,''),NULL,NULL

			END
	END
ELSE IF @ApplyStatus IS NOT NULL AND @ApplyType = 'DelayApply'
	BEGIN
		UPDATE A SET A.CAH_Delay_OrderStatus = @ApplyStatus,
			CAH_Delay_ApproveDate = GETDATE()
		FROM ConsignmentApplyHeader A
		WHERE LOWER(CAST(A.CAH_CAH_ID AS NVARCHAR(100))) = LOWER(@InstanceId)
		

		IF @OperType = 'sys_complete'
			BEGIN
				IF LEN(@RtnMsg) = 0 AND NOT EXISTS(SELECT 1 
						FROM ConsignmentApplyHeader
					WHERE LOWER(CAST(CAH_CAH_ID AS NVARCHAR(100))) = LOWER(@InstanceId)
						AND CAH_Delay_OrderStatus IN ('Submitted','')
						AND CAH_Delay_DelayTime != 0)
					BEGIN
						SET @RtnVal = 'Error'
						SET @RtnMsg = '短期寄售延期次数不足'

						INSERT INTO Workflow.WorkflowLog
						SELECT NEWID(),@InstanceId,NULL,GETDATE(),GETDATE(),'Failure',NULL,'短期寄售申请延期','短期寄售延期次数不足',NULL,NULL

					END
				ELSE
					BEGIN
						UPDATE A SET A.CAH_Delay_DelayTime = A.CAH_Delay_DelayTime - 1
						FROM ConsignmentApplyHeader A
						WHERE LOWER(CAST(A.CAH_CAH_ID AS NVARCHAR(100))) = LOWER(@InstanceId)

					END
			END

	END



GO

