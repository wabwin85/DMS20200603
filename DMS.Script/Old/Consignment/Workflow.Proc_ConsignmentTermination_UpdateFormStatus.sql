
/*
1. 功能名称：合同终止发起MFlow
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [Workflow].[Proc_ConsignmentTermination_UpdateFormStatus]
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
						WHEN @OperType = 'sys_complete' THEN 'Approved'
						WHEN @OperType = 'sys_abandon' THEN 'Revoke'
						ELSE NULL END

IF @applyStatus IS NOT NULL
	BEGIN
		UPDATE A SET A.CST_Status = @applyStatus
		FROM Consignment.ConsignmentTermination A
		WHERE A.CST_ID = @InstanceId
	  IF @applyStatus='Approved'
		   BEGIN
		    --记录log
			INSERT  INTO Platform_OperLogMaster (LogId,MainId,OperUser,OperUserEN,OperDate,OperType,OperNote,OperRole,DataSource)
			VALUES (NEWID(),@InstanceId,'系统','',GETDATE(),'审批通过','','系统','Consignment_TerminationInfo')
			
			INSERT INTO Consignment.TerminationCompleteList (TCL_ID,TCL_CST_ID,TCL_CompleteDate,TCL_SynStatus,TCL_SynDate)
			VALUES (NEWID(),@InstanceId,GETDATE(),0,NULL)
			--审批完成 更新寄售合同终止日期
			update Consignment.ContractHeader set CCH_EndDate=GETDATE()
			where CCH_ID=(select CST_CCH_ID from Consignment.ConsignmentTermination where CST_ID=@InstanceId)
		   END
		IF @applyStatus='Deny'
		   BEGIN
		   INSERT  INTO Platform_OperLogMaster (LogId,MainId,OperUser,OperUserEN,OperDate,OperType,OperNote,OperRole,DataSource)
			VALUES (NEWID(),@InstanceId,'系统','',GETDATE(),'审批拒绝','','系统','Consignment_TerminationInfo')
		   END
	END

