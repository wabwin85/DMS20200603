DROP PROCEDURE [Workflow].[Proc_Common_GetHtmlData]
GO

CREATE PROCEDURE [Workflow].[Proc_Common_GetHtmlData]
	@InstanceId uniqueidentifier,
	@ModelId nvarchar(200),
	@TemplateFormId nvarchar(200)
AS

--INSERT INTO Workflow.WorkflowLog
--		SELECT NEWID(),@InstanceId,NULL,GETDATE(),GETDATE(),'Success','',ISNULL(@ModelId,''),ISNULL(@TemplateFormId,''),NULL,NULL
		
IF @ModelId = 'Tender' AND @TemplateFormId = 'TenderTemplate'
	BEGIN
		EXEC Workflow.Proc_Tender_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'Consignment' AND @TemplateFormId = 'ConsignmentTemplate'
	BEGIN
		EXEC Workflow.Proc_Consignment_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'SampleBusiness' AND @TemplateFormId = 'SampleBusinessTemplate'
	BEGIN
		EXEC Workflow.Proc_SampleBusiness_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'SampleReturn' AND @TemplateFormId = 'SampleReturnTemplate'
	BEGIN
		EXEC Workflow.Proc_SampleReturn_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'IntegralImport' AND @TemplateFormId = 'IntegralImportTemplate'
	BEGIN
		EXEC Workflow.Proc_IntegralImport_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'Promotion' AND @TemplateFormId = 'PromotionTemplate'
	BEGIN
		EXEC Workflow.Proc_Promotion_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'PromotionPolicy' AND @TemplateFormId = 'PromotionPolicyTemplate'
	BEGIN
		EXEC Workflow.Proc_PromotionPolicy_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'ContractAppointment' AND @TemplateFormId = 'ContractAppointmentTemplate'
	BEGIN
		EXEC Workflow.Proc_Contract_Appointment_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'ContractAmendment' AND @TemplateFormId = 'ContractAmendmentTemplate'
	BEGIN
		EXEC Workflow.Proc_Contract_Amendment_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'ContractRenewal' AND @TemplateFormId = 'ContractRenewalTemplate'
	BEGIN
		EXEC Workflow.Proc_Contract_Renewal_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'ContractTermination' AND @TemplateFormId = 'ContractTerminationTemplate'
	BEGIN
		EXEC Workflow.Proc_Contract_Termination_GetHtmlData @InstanceId
	END
ELSE IF @ModelId = 'DealerReturn' AND @TemplateFormId = 'DealerReturnTemplate'
	BEGIN
		EXEC Workflow.Proc_DealerReturn_GetHtmlData @InstanceId
	END	
GO


