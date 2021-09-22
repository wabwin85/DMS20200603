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
SELECT @ApplyStatus = CASE WHEN @OperType = 'drafter_submit' THEN '������'
						WHEN @OperType = 'drafter_abandon' THEN '����'
						WHEN @OperType = 'handler_pass' THEN '������'
						WHEN @OperType = 'handler_refuse' THEN '�����ܾ�'
						WHEN @OperType = 'handler_additionSign' THEN '������'
						WHEN @OperType = 'sys_complete' THEN '��Ч'
						WHEN @OperType = 'sys_abandon' THEN '����'
						ELSE NULL END

IF @ApplyStatus IS NOT NULL
BEGIN
	UPDATE A SET A.Status = @ApplyStatus
	FROM PROMOTION.PRO_POLICY A
	WHERE A.InstanceID = @InstanceId
	
	IF  @ApplyStatus='��Ч'
	BEGIN
		DECLARE @PolicyNo NVARCHAR(100)
		SELECT @PolicyNo=A.PolicyNo FROM Promotion.PRO_POLICY A WHERE InstanceID = @InstanceId
		
		EXEC [Promotion].[P_I_EW_Promotion_Status]  @PolicyNo,'��Ч','',''
	END
	
END



GO


