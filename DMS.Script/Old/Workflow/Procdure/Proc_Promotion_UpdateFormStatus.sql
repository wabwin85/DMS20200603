DROP PROCEDURE [Workflow].[Proc_Promotion_UpdateFormStatus]
GO


CREATE PROCEDURE [Workflow].[Proc_Promotion_UpdateFormStatus]
	@InstanceId uniqueidentifier,
	@OperType nvarchar(100),
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS
DECLARE @Type NVARCHAR(100)
SELECT @Type = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

DECLARE @ApplyStatus NVARCHAR(100)
SELECT @ApplyStatus = CASE WHEN @OperType = 'drafter_submit' THEN '������'
						WHEN @OperType = 'drafter_abandon' THEN '����'
						WHEN @OperType = 'handler_pass' THEN '������'
						WHEN @OperType = 'handler_refuse' THEN '�����ܾ�'
						WHEN @OperType = 'handler_additionSign' THEN '������'
						WHEN @OperType = 'sys_complete' THEN '����ͨ��'
						WHEN @OperType = 'sys_abandon' THEN '����'
						ELSE NULL END

IF @ApplyStatus IS NOT NULL
BEGIN
	IF  @ApplyStatus<>'����ͨ��'
		BEGIN
			UPDATE A SET A.Status = @ApplyStatus
			FROM PROMOTION.T_Pro_Flow A
			WHERE A.InstanceID = @InstanceId
		END
	ELSE IF  @ApplyStatus='����ͨ��'
	BEGIN
		DECLARE @FlowId INT
		SELECT @FlowId=FlowId FROM Promotion.T_Pro_Flow WHERE InstanceID = @InstanceId
		EXEC [Promotion].[Proc_Pro_EWorkFlowFinish] @FlowId,'����ͨ��','',''
		
	END
		
END



GO


