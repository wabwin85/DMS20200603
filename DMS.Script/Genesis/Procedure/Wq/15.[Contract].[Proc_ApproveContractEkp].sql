
/****** Object:  StoredProcedure [Contract].[Proc_ApproveContractEkp]    Script Date: 2019/11/25 13:08:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Contract].[Proc_ApproveContractEkp](
    @ContractId    UNIQUEIDENTIFIER,
    @ContractType  NVARCHAR(100),
    @OperType      NVARCHAR(100),
    @UaerAccount   NVARCHAR(100),
    @AuditNote     NVARCHAR(MAX),
    @NodeIds       NVARCHAR(100)
)
AS
BEGIN
	DECLARE @ContractStatus NVARCHAR(100)
	DECLARE @ApproveUser NVARCHAR(100)
	DECLARE @ApproveUserEN NVARCHAR(200)
	DECLARE @ApproveType NVARCHAR(100)
	DECLARE @ApproveDate DATETIME
	DECLARE @ApproveNote NVARCHAR(500)
	DECLARE @ApproveRole NVARCHAR(100)
	DECLARE @NextApprove NVARCHAR(100)
	
	SET @ContractStatus = '';
	SET @ApproveType = '';
	SET @ApproveDate = GETDATE();
	SET @ApproveNote = @AuditNote;
	SET @ApproveRole = '';
	SET @NextApprove = '';
	
	--SELECT @ApproveUser = NAME,
	--       @ApproveUserEN = eName
	--FROM   interface.MDM_EmployeeMaster
	--WHERE  account = @UaerAccount;
	SET @ApproveUser=''
	SET @ApproveUserEN =''
	SELECT @ApproveUser = @ApproveUser + IDENTITY_NAME +';', 
		   @ApproveUserEN = @ApproveUserEN + LOWERED_IDENTITY_CODE +';'
	FROM Lafite_IDENTITY
	WHERE IDENTITY_CODE IN(
		SELECT VAL FROM  GC_Fn_SplitStringToTable(@UaerAccount, ';')
	)
	IF(LEN(@ApproveUser)>0)
	BEGIN
		SET @ApproveUser = LEFT(@ApproveUser,len(@ApproveUser)-1)
		SET @ApproveUserEN = LEFT(@ApproveUserEN,len(@ApproveUserEN)-1)
	END
	IF(@ApproveUser='系统' OR @ApproveUser='')
	BEGIN
		SET @ApproveUser='无'
		SET @ApproveUserEN='none'
	END
	--废弃，会再次调用sys_abandon，忽略本次操作
	--drafter_abandon
	--handler_abandon
	
	IF @OperType = 'drafter_submit' --提交
	BEGIN
	    SET @ContractStatus = 'InApproval';
	    
	    IF @ContractType = 'Appointment'
	    BEGIN
	        UPDATE [Contract].AppointmentMain
	        SET    ContractStatus  = @ContractStatus,
	               UpdateDate      = GETDATE(),
				   CurrentApprove  = @ApproveUser
	        WHERE  ContractId      = @ContractId
	    END
	    ELSE 
	    IF @ContractType = 'Amendment'
	    BEGIN
	        UPDATE [Contract].AmendmentMain
	        SET    ContractStatus  = @ContractStatus,
	               UpdateDate      = GETDATE(),
				   CurrentApprove  = @ApproveUser
	        WHERE  ContractId      = @ContractId
	    END
	    ELSE 
	    IF @ContractType = 'Renewal'
	    BEGIN
	        UPDATE [Contract].RenewalMain
	        SET    ContractStatus  = @ContractStatus,
	               UpdateDate      = GETDATE(),
				   CurrentApprove  = @ApproveUser
	        WHERE  ContractId      = @ContractId
	    END
	    ELSE 
	    IF @ContractType = 'Termination'
	    BEGIN
	        UPDATE [Contract].TerminationMain
	        SET    ContractStatus  = @ContractStatus,
	               UpdateDate      = GETDATE(),
				   CurrentApprove  = @ApproveUser
	        WHERE  ContractId      = @ContractId
	    END
	END
	ELSE
	IF @OperType = 'sys_abandon' --废弃
	BEGIN
	    SET @ContractStatus = 'Abandon';
	    
	    IF @ContractType = 'Appointment'
	    BEGIN
	        UPDATE [Contract].AppointmentMain
	        SET    ContractStatus  = @ContractStatus,
	               CurrentApprove  = @ApproveUser,
	               UpdateDate      = GETDATE()
	        WHERE  ContractId      = @ContractId
	    END
	    ELSE 
	    IF @ContractType = 'Amendment'
	    BEGIN
	        UPDATE [Contract].AmendmentMain
	        SET    ContractStatus  = @ContractStatus,
	               CurrentApprove  = @ApproveUser,
	               UpdateDate      = GETDATE()
	        WHERE  ContractId      = @ContractId
	    END
	    ELSE 
	    IF @ContractType = 'Renewal'
	    BEGIN
	        UPDATE [Contract].RenewalMain
	        SET    ContractStatus  = @ContractStatus,
	               CurrentApprove  = @ApproveUser,
	               UpdateDate      = GETDATE()
	        WHERE  ContractId      = @ContractId
	    END
	    ELSE 
	    IF @ContractType = 'Termination'
	    BEGIN
	        UPDATE [Contract].TerminationMain
	        SET    ContractStatus  = @ContractStatus,
	               CurrentApprove  = @ApproveUser,
	               UpdateDate      = GETDATE()
	        WHERE  ContractId      = @ContractId
	    END
	END
	ELSE
	IF @OperType = 'handler_refuse' --拒绝
	BEGIN
	    SET @ContractStatus = 'Deny';
	    SET @ApproveType = '审批拒绝';
	    
	    EXEC [Contract].Proc_ApproveContract @ContractId, @ContractType, @ContractStatus, @ApproveUser, @ApproveUserEN, 
	         @ApproveType, @ApproveDate, @ApproveNote, @ApproveRole, @NextApprove
	END
	ELSE
	IF @OperType = 'handler_pass' --通过
	BEGIN
	    SET @ContractStatus = 'InApproval';
	    SET @ApproveType = '审批通过';
	    
	    IF @ContractType = 'Appointment'
	       AND EXISTS (
	               SELECT 1
	               FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	               WHERE  VAL IN ('总经理审批_平台新建','总经理审批_T1新建','总经理审批_T2新建')
	           )
	    BEGIN
	        SET @ApproveRole = 'CO Confirm';
	    END
	    ELSE 
	    IF @ContractType = 'Amendment'
	       AND EXISTS (
	               SELECT 1
	               FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	               WHERE  VAL IN ('总经理审批_平台变更','总经理审批_T1变更','商务审批_T2变更')
	           )
	    BEGIN
	        SET @ApproveRole = 'CO Confirm';
	    END
	    ELSE 
	    IF @ContractType = 'Renewal'
	       AND EXISTS (
	               SELECT 1
	               FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	               WHERE  VAL IN ('总经理审批_平台续签','总经理审批_T1续签','商务审批_T2续签')
	           )
	    BEGIN
	        SET @ApproveRole = 'CO Confirm';
	    END
	    ELSE 
	    IF @ContractType = 'Termination'
	       AND EXISTS (
	               SELECT 1
	               FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	               WHERE  VAL IN ('总经理审批_平台终止','总经理审批_T1终止','总经理审批_T2终止')
	           )
	    BEGIN
	        SET @ApproveRole = 'CO Confirm';
	    END
	    
	    IF EXISTS (
	           SELECT 1
	           FROM   [Contract].AppointmentMain
	           WHERE  ContractId = @ContractId
	                  AND DealerType NOT IN ('T2', 'Trade')
	       )
	       AND EXISTS (
	               SELECT 1
	               FROM   [Contract].AppointmentCandidate
	               WHERE  ContractId = @ContractId
	                      AND ISNULL(SAPCode, '') <> ''
	           )
	       AND EXISTS (
	               SELECT 1
	               FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	               WHERE  VAL = 'N50'
	           )
	    BEGIN
	        DECLARE @SapCode NVARCHAR(200);
	        
	        SELECT @SapCode = SAPCode
	        FROM   [Contract].AppointmentCandidate
	        WHERE  ContractId = @ContractId
	        
	        EXEC [Contract].Proc_ApproveSapCode @ContractId, @SapCode
	    END
	    
	    EXEC [Contract].Proc_ApproveContract @ContractId, @ContractType, @ContractStatus, @ApproveUser, @ApproveUserEN, 
	         @ApproveType, @ApproveDate, @ApproveNote, @ApproveRole, @NextApprove
	END
	ELSE
	IF @OperType = 'sys_complete' --结束
	BEGIN
	    SET @ContractStatus = 'Approved';
	    SET @ApproveType = '归档通过';		
	    
	    IF @ContractType = 'Appointment'
	    BEGIN
	        SET @ApproveRole = 'CO Confirm';
	    END
	    
	    EXEC [Contract].Proc_ApproveContract @ContractId, @ContractType, @ContractStatus, @ApproveUser, @ApproveUserEN, 
	         @ApproveType, @ApproveDate, '审批完成', @ApproveRole, @NextApprove
	END
END