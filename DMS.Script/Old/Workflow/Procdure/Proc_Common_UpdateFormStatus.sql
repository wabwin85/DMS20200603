DROP PROCEDURE [Workflow].[Proc_Common_UpdateFormStatus]
GO

CREATE PROCEDURE [Workflow].[Proc_Common_UpdateFormStatus]
	@InstanceId uniqueidentifier,
	@ModelId nvarchar(100),
	@TemplateFormId nvarchar(100),
	@NodeIds nvarchar(2000),
	@OperType nvarchar(100),
	@OperName nvarchar(100),
	@UserAccount nvarchar(100),
	@AuditNote nvarchar(MAX)
AS

IF @modelId = 'Tender' AND @templateFormId = 'TenderTemplate'
	BEGIN
		EXEC Workflow.Proc_Tender_UpdateFormStatus @InstanceId,@OperType,@OperName,@UserAccount,@AuditNote
	END
ELSE IF @ModelId = 'Consignment' AND @TemplateFormId = 'ConsignmentTemplate'
	BEGIN
		EXEC Workflow.Proc_Consignment_UpdateFormStatus @InstanceId,@OperType,@OperName,@UserAccount,@AuditNote
	END
ELSE IF @modelId = 'SampleBusiness' AND @templateFormId = 'SampleBusinessTemplate'
	BEGIN
		EXEC Workflow.Proc_SampleBusiness_UpdateFormStatus @InstanceId,@OperType,@OperName,@UserAccount,@AuditNote
	END
ELSE IF @modelId = 'SampleReturn' AND @templateFormId = 'SampleReturnTemplate'
	BEGIN
		EXEC Workflow.Proc_SampleReturn_UpdateFormStatus @InstanceId,@OperType,@OperName,@UserAccount,@AuditNote
	END
ELSE IF @modelId = 'IntegralImport' AND @templateFormId = 'IntegralImportTemplate'
	BEGIN
		EXEC Workflow.Proc_IntegralImport_UpdateFormStatus @InstanceId,@OperType,@OperName,@UserAccount,@AuditNote
	END
ELSE IF @modelId = 'Promotion' AND @templateFormId = 'PromotionTemplate'
	BEGIN
		EXEC Workflow.Proc_Promotion_UpdateFormStatus @InstanceId,@OperType,@OperName,@UserAccount,@AuditNote
	END
ELSE IF @modelId = 'PromotionPolicy' AND @templateFormId = 'PromotionPolicyTemplate'
	BEGIN
		EXEC Workflow.Proc_PromotionPolicy_UpdateFormStatus @InstanceId,@OperType,@OperName,@UserAccount,@AuditNote
	END
ELSE IF @modelId = 'ContractAppointment' AND @templateFormId = 'ContractAppointmentTemplate'
	BEGIN
		EXEC [Contract].Proc_ApproveContractEkp @InstanceId, 'Appointment', @OperType, @UserAccount, @AuditNote, @NodeIds
	END
ELSE IF @modelId = 'ContractAmendment' AND @templateFormId = 'ContractAmendmentTemplate'
	BEGIN
		EXEC [Contract].Proc_ApproveContractEkp @InstanceId, 'Amendment', @OperType, @UserAccount, @AuditNote, @NodeIds
	END
ELSE IF @modelId = 'ContractRenewal' AND @templateFormId = 'ContractRenewalTemplate'
	BEGIN
		EXEC [Contract].Proc_ApproveContractEkp @InstanceId, 'Renewal', @OperType, @UserAccount, @AuditNote, @NodeIds
	END
ELSE IF @modelId = 'ContractTermination' AND @templateFormId = 'ContractTerminationTemplate'
	BEGIN
		EXEC [Contract].Proc_ApproveContractEkp @InstanceId, 'Termination', @OperType, @UserAccount, @AuditNote, @NodeIds
	END
ELSE IF @modelId = 'DealerReturn' AND @templateFormId = 'DealerReturnTemplate'
	BEGIN
		EXEC [Workflow].[Proc_DealerReturn_UpdateFormStatus] @InstanceId, @NodeIds, @OperType, @OperName, @UserAccount, @AuditNote
	END

	DECLARE @UserId NVARCHAR(200)
	SELECT @UserId = Id FROM Lafite_IDENTITY WHERE IDENTITY_CODE = @UserAccount

	IF @UserId IS NOT NULL
		BEGIN
			INSERT INTO PurchaseOrderLog
				   ([POL_ID]
				   ,[POL_POH_ID]
				   ,[POL_OperUser]
				   ,[POL_OperDate]
				   ,[POL_OperType]
				   ,[POL_OperNote])
			 VALUES
				   (NEWID()
				   ,@InstanceId
				   ,@UserId
				   ,GETDATE()
				   ,@OperName
				   ,@AuditNote
				   )
		END
	
GO


