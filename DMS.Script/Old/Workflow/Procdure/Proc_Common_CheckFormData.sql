
DROP PROCEDURE [Workflow].[Proc_Common_CheckFormData]
GO


CREATE PROCEDURE [Workflow].[Proc_Common_CheckFormData]
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
	IF @ModelId = 'DealerReturn' 
		AND @TemplateFormId = 'DealerReturnTemplate'
	BEGIN
		EXEC [Workflow].[Proc_DealerReturn_CheckFormData] @InstanceId, @NodeIds, @RtnVal OUTPUT, @RtnMsg OUTPUT
	END
END
	
GO


