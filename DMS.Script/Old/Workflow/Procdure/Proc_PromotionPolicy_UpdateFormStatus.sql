DROP PROCEDURE [Workflow].[Proc_PromotionPolicy_UpdateFormStatus]
GO


Create PROCEDURE [Workflow].[Proc_PromotionPolicy_UpdateFormStatus]
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
						WHEN @OperType = 'sys_complete' THEN '有效'
						WHEN @OperType = 'sys_abandon' THEN '撤销'
						ELSE NULL END

IF @ApplyStatus IS NOT NULL
BEGIN
	UPDATE A SET A.Status = @ApplyStatus
	FROM PROMOTION.PRO_POLICY A
	WHERE A.InstanceID = @InstanceId
	
	IF  @ApplyStatus='有效'
	BEGIN
		DECLARE @PolicyNo NVARCHAR(100)
		SELECT @PolicyNo=A.PolicyNo FROM Promotion.PRO_POLICY A WHERE InstanceID = @InstanceId
		
		EXEC [Promotion].[P_I_EW_Promotion_Status]  @PolicyNo,'有效','',''
	END
	
END



GO


