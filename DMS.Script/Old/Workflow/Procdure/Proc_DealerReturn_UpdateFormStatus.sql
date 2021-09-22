DROP PROCEDURE [Workflow].[Proc_DealerReturn_UpdateFormStatus]
GO

CREATE PROCEDURE [Workflow].[Proc_DealerReturn_UpdateFormStatus]
	@InstanceId uniqueidentifier,
	@NodeIds nvarchar(2000),
	@OperType nvarchar(100),
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS
DECLARE @Type NVARCHAR(100)
SELECT @Type = ApplyType FROM Workflow.FormInstanceMaster WHERE ApplyId = @InstanceId

DECLARE @ApplyStatus NVARCHAR(100)
SELECT @ApplyStatus = CASE WHEN @OperType = 'drafter_submit' THEN 'InWorkflow'
						WHEN @OperType = 'drafter_abandon' THEN 'Cancelled'
						WHEN @OperType = 'handler_pass' THEN 'InWorkflow'
						WHEN @OperType = 'handler_refuse' THEN 'Reject'
						WHEN @OperType = 'handler_additionSign' THEN 'InWorkflow'
						WHEN @OperType = 'sys_complete' THEN 'Accept'
						WHEN @OperType = 'sys_abandon' THEN 'Cancelled'
						ELSE NULL END

IF @ApplyStatus IS NOT NULL
BEGIN
	IF @Type = 'DealerReturn'
		BEGIN
			--UPDATE A SET A.IAH_Status = @ApplyStatus
			--FROM InventoryAdjustHeader A
			--WHERE A.IAH_ID = @InstanceId
			DECLARE @ReturnNo NVARCHAR(30)
			DECLARE @ApproveDate NVARCHAR(50)
			DECLARE @ReturnValue NVARCHAR(100)

			SELECT @ReturnNo = IAH_Inv_Adj_Nbr FROM InventoryAdjustHeader
			WHERE IAH_ID = @InstanceId
			SET @ApproveDate = CONVERT(NVARCHAR(50),GETDATE(),120)

			EXEC [interface].[P_I_EW_ReturnApplicationApproval]	@ReturnNo,@ApplyStatus,@UserAccount,@ApproveDate,@AuditNote,@NodeIds,@ReturnValue OUTPUT

			DECLARE @ReqMsg NVARCHAR(MAX)
			SET @ReqMsg =  'EXEC [interface].[P_I_EW_ReturnApplicationApproval] '
			+ ISNULL(@ReturnNo,'NULL') + ',' 
			+ ISNULL(@ApplyStatus,'NULL') + ',' 
			+ ISNULL(@UserAccount,'NULL') + ',' 
			+ ISNULL(@ApproveDate,'NULL') + ',' 
			+ ISNULL(@AuditNote,'NULL') + ',' 
			+ ISNULL(@NodeIds,'NULL') + ',' 
			+ ISNULL(@ReturnValue,'NULL') + ' OUTPUT'

			INSERT INTO Workflow.WorkflowLog
			SELECT NEWID(),@InstanceId,NULL,GETDATE(),GETDATE(),'Success',@ReturnValue,@ReqMsg,ISNULL(@ReturnValue,''),NULL,NULL

		END
	
END
GO


