DROP PROCEDURE [Workflow].[Proc_IntegralImport_UpdateFormStatus]
GO


CREATE PROCEDURE [Workflow].[Proc_IntegralImport_UpdateFormStatus]
	@InstanceId uniqueidentifier,
	@OperType nvarchar(100),
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS
DECLARE @Type NVARCHAR(100)
SELECT @Type = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

DECLARE @ApplyStatus NVARCHAR(100)
SELECT @ApplyStatus = CASE WHEN @OperType = 'drafter_submit' THEN '审批中'
						WHEN @OperType = 'drafter_abandon' THEN '撤销'
						WHEN @OperType = 'handler_pass' THEN '审批中'
						WHEN @OperType = 'handler_refuse' THEN '审批拒绝'
						WHEN @OperType = 'handler_additionSign' THEN '审批中'
						WHEN @OperType = 'sys_complete' THEN '审批通过'
						WHEN @OperType = 'sys_abandon' THEN '撤销'
						ELSE NULL END

IF @ApplyStatus IS NOT NULL
BEGIN
	
	UPDATE A SET A.Status = @ApplyStatus
	FROM Promotion.Pro_InitPoint_Flow A
	WHERE A.InstanceID = @InstanceId
	
	IF  @ApplyStatus='审批通过'
	BEGIN
		DECLARE @FlowId INT
		SELECT @FlowId=FlowId FROM Promotion.Pro_InitPoint_Flow WHERE InstanceID = @InstanceId
		EXEC [interface].[P_I_EW_InitPoint_Approval] @FlowId,'','审批通过',1
		
	END
	
END



GO


