
DROP PROCEDURE [Workflow].[Proc_SampleReturn_UpdateFormStatus]
GO


CREATE PROCEDURE [Workflow].[Proc_SampleReturn_UpdateFormStatus]
	@InstanceId uniqueidentifier,
	@OperType nvarchar(100),
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS
DECLARE @Type NVARCHAR(100)
SELECT @Type = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

DECLARE @ApplyStatus NVARCHAR(100)
SELECT @ApplyStatus = CASE WHEN @OperType = 'drafter_submit' THEN 'InApproval'
						WHEN @OperType = 'drafter_abandon' THEN 'Complete'
						WHEN @OperType = 'handler_pass' THEN 'InApproval'
						WHEN @OperType = 'handler_refuse' THEN 'Deny'
						WHEN @OperType = 'handler_additionSign' THEN 'InApproval'
						WHEN @OperType = 'sys_complete' THEN 'Approved'
						WHEN @OperType = 'sys_abandon' THEN 'Complete'
						ELSE NULL END

IF @ApplyStatus IS NOT NULL
BEGIN
	UPDATE A SET A.ReturnStatus = @ApplyStatus
	FROM SampleReturnHead A
	WHERE A.SampleReturnHeadId = @InstanceId
		
END



GO


