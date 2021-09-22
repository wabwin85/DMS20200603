DROP PROCEDURE [Workflow].[Proc_SampleBusiness_UpdateFormStatus]
GO


CREATE PROCEDURE [Workflow].[Proc_SampleBusiness_UpdateFormStatus]
	@InstanceId uniqueidentifier,
	@OperType nvarchar(100),
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS
DECLARE @Type NVARCHAR(100)
SELECT @Type = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

DECLARE @APPROVEDATE DATETIME
DECLARE @SampleNo      NVARCHAR(100)
DECLARE @ApproveUser   NVARCHAR(100)
SELECT @SampleNo = ApplyNo FROM SampleApplyHead where SampleApplyHeadId=@InstanceId
SELECT @ApproveUser = IDENTITY_NAME FROM Lafite_IDENTITY WHERE IDENTITY_CODE = @UserAccount
SELECT @APPROVEDATE = GETDATE();

DECLARE @ApplyStatus NVARCHAR(100)
SELECT @ApplyStatus = CASE WHEN @OperType = 'drafter_submit' THEN 'InApproval'
						WHEN @OperType = 'drafter_abandon' THEN 'Deny'	--暂时先改成审批拒绝
						WHEN @OperType = 'handler_pass' THEN 'InApproval'
						WHEN @OperType = 'handler_refuse' THEN 'Deny'
						WHEN @OperType = 'handler_additionSign' THEN 'InApproval'
						WHEN @OperType = 'sys_complete' THEN 'Approved'
						WHEN @OperType = 'sys_abandon' THEN 'Deny'		--暂时先改成审批拒绝
						ELSE NULL END

IF @ApplyStatus IS NOT NULL
BEGIN
	UPDATE A SET A.ApplyStatus = @ApplyStatus
	FROM SampleApplyHead A
	WHERE A.SampleApplyHeadId = @InstanceId
	
	if(@ApplyStatus = 'Approved')
	begin
		EXEC [dbo].[Proc_ApproveSample] '申请单',@SampleNo,@ApplyStatus,@ApproveUser,'审批同意',@APPROVEDATE,@AuditNote
	end
	INSERT INTO Workflow.WorkflowLog
	SELECT NEWID(),@InstanceId,NULL,GETDATE(),GETDATE(),'Success','','Proc_ApproveSample;'+@OperType+';'+@ApplyStatus+';'+@UserAccount,'',NULL,NULL

		
END

GO


