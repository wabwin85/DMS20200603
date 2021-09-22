/*
1. 功能名称：寄售合同申请发起MFlow
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Workflow].[Proc_ConsignmentContract_UpdateFormStatus]
	@InstanceId uniqueidentifier,
	@OperType nvarchar(100),
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS

DECLARE @applyStatus NVARCHAR(100)
SELECT @applyStatus = CASE WHEN @OperType = 'drafter_submit' THEN 'InApproval'
						WHEN @OperType = 'drafter_press' THEN 'InApproval'
						WHEN @OperType = 'drafter_abandon' THEN 'Revoke'
						WHEN @OperType = 'handler_pass' THEN 'InApproval'
						WHEN @OperType = 'handler_refuse' THEN 'Deny'
						WHEN @OperType = 'handler_additionSign' THEN 'InApproval'
						WHEN @OperType = 'sys_complete' THEN 'Completed'
						WHEN @OperType = 'sys_abandon' THEN 'Revoke'
						ELSE NULL END

IF @applyStatus IS NOT NULL
	BEGIN
		UPDATE A SET A.CCH_Status = @applyStatus
		FROM Consignment.ContractHeader A
		WHERE A.CCH_ID = @InstanceId
		
		
		IF @applyStatus='Completed'
		   BEGIN
		    --记录log
			INSERT  INTO Platform_OperLogMaster (LogId,MainId,OperUser,OperUserEN,OperDate,OperType,OperNote,OperRole,DataSource)
			VALUES (NEWID(),@InstanceId,'系统','',GETDATE(),'审批通过','','系统','Consign_ContractInfo')
		   END
		IF @applyStatus='Deny'
		   BEGIN
		   INSERT  INTO Platform_OperLogMaster (LogId,MainId,OperUser,OperUserEN,OperDate,OperType,OperNote,OperRole,DataSource)
			VALUES (NEWID(),@InstanceId,'系统','',GETDATE(),'审批拒绝','','系统','Consign_ContractInfo')
		   END
	END
