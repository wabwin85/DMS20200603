
DROP PROCEDURE [Workflow].[Proc_Common_GetFormData]
GO


CREATE PROCEDURE [Workflow].[Proc_Common_GetFormData]
	@InstanceId uniqueidentifier,
	@ModelId nvarchar(200),
	@TemplateFormId nvarchar(200)
AS

IF @ModelId = 'Tender' AND @TemplateFormId = 'TenderTemplate'
	BEGIN
		EXEC [Workflow].[Proc_Tender_GetFormData] @InstanceId
	END
ELSE IF @ModelId = 'Consignment' AND @TemplateFormId = 'ConsignmentTemplate'
	BEGIN
		EXEC [Workflow].[Proc_Consignment_GetFormData] @InstanceId
	END
ELSE IF @ModelId = 'SampleBusiness' AND @TemplateFormId = 'SampleBusinessTemplate'
	BEGIN
		EXEC [Workflow].[Proc_SampleBusiness_GetFormData] @InstanceId
	END
ELSE IF @ModelId = 'SampleReturn' AND @TemplateFormId = 'SampleReturnTemplate'
	BEGIN
		EXEC [Workflow].[Proc_SampleReturn_GetFormData] @InstanceId
	END
ELSE IF @ModelId = 'IntegralImport' AND @TemplateFormId = 'IntegralImportTemplate'
	BEGIN
		EXEC [Workflow].[Proc_IntegralImport_GetFormData] @InstanceId
	END
ELSE IF @ModelId = 'Promotion' AND @TemplateFormId = 'PromotionTemplate'
	BEGIN
		EXEC [Workflow].[Proc_Promotion_GetFormData] @InstanceId
	END
ELSE IF @ModelId = 'PromotionPolicy' AND @TemplateFormId = 'PromotionPolicyTemplate'
	BEGIN
		EXEC [Workflow].[Proc_PromotionPolicy_GetFormData] @InstanceId
	END
ELSE IF @ModelId = 'ContractAppointment' AND @TemplateFormId = 'ContractAppointmentTemplate'
	BEGIN
		EXEC Workflow.Proc_Contract_Appointment_GetFormData @InstanceId
	END
ELSE IF @ModelId = 'ContractAmendment' AND @TemplateFormId = 'ContractAmendmentTemplate'
	BEGIN
		EXEC Workflow.Proc_Contract_Amendment_GetFormData @InstanceId
	END
ELSE IF @ModelId = 'ContractRenewal' AND @TemplateFormId = 'ContractRenewalTemplate'
	BEGIN
		EXEC Workflow.Proc_Contract_Renewal_GetFormData @InstanceId
	END
ELSE IF @ModelId = 'ContractTermination' AND @TemplateFormId = 'ContractTerminationTemplate'
	BEGIN
		EXEC Workflow.Proc_Contract_Termination_GetFormData @InstanceId
	END
ELSE IF @ModelId = 'DealerReturn' AND @TemplateFormId = 'DealerReturnTemplate'
	BEGIN
		EXEC Workflow.Proc_DealerReturn_GetFormData @InstanceId
	END	


GO


