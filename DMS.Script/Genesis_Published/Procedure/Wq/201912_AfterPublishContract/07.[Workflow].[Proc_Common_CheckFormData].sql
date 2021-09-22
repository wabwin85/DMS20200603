
/****** Object:  StoredProcedure [Workflow].[Proc_Common_CheckFormData]    Script Date: 2019/12/2 14:11:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Workflow].[Proc_Common_CheckFormData]
	@InstanceId UNIQUEIDENTIFIER,
	@ModelId NVARCHAR(100),
	@TemplateFormId NVARCHAR(100),
	@NodeIds NVARCHAR(2000),
	@RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(4000) OUTPUT
AS
BEGIN
	SET @RtnVal = 'Success';
	SET @RtnMsg = '';
	
	IF @modelId = 'ContractAppointment'
	   AND @templateFormId = 'ContractAppointmentTemplate'
	BEGIN
	    EXEC [Workflow].[Proc_Contract_Appointment_CheckFormData] @InstanceId, @NodeIds, @RtnVal OUTPUT, @RtnMsg OUTPUT
	END
	IF @modelId = 'ContractRenewal'
	   AND @templateFormId = 'ContractRenewalTemplate'
	BEGIN
	    EXEC [Workflow].[Proc_Contract_Renewal_CheckFormData] @InstanceId, @NodeIds, @RtnVal OUTPUT, @RtnMsg OUTPUT
	END
	IF @ModelId = 'DealerReturn' 
		AND @TemplateFormId = 'DealerReturnTemplate'
	BEGIN
		EXEC [Workflow].[Proc_DealerReturn_CheckFormData] @InstanceId, @NodeIds, @RtnVal OUTPUT, @RtnMsg OUTPUT
	END
	IF @ModelId = 'DealerComplain' 
		AND @TemplateFormId = 'DealerComplainTemplate'
	BEGIN
		EXEC [Workflow].[Proc_DealerComplain_CheckFormData] @InstanceId, @NodeIds, @RtnVal OUTPUT, @RtnMsg OUTPUT
	END
	--IF @ModelId = 'PromotionPolicyClose' 
	--	AND @TemplateFormId = 'PromotionPolicyCloseTemplate'
	--BEGIN
	--	EXEC [Workflow].[Proc_PromotionPolicyClose_GetFormData] @InstanceId, @NodeIds, @RtnVal OUTPUT, @RtnMsg OUTPUT
	--END
END
	