DROP PROCEDURE [Workflow].[Proc_Contract_Appointment_GetHtmlData]
GO


CREATE PROCEDURE [Workflow].[Proc_Contract_Appointment_GetHtmlData]
	@InstanceId UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @DealerType NVARCHAR(200) ;
	
	SELECT @DealerType = A.DealerType
	FROM   [Contract].AppointmentMain A
	WHERE  A.ContractId = @InstanceId;
	
	IF @DealerType = 'Trade'
	BEGIN
	    EXEC Workflow.Proc_Contract_AppointmentTrade_GetHtmlData @InstanceId
	END
	ELSE 
	IF @DealerType = 'T2'
	BEGIN
	    EXEC Workflow.Proc_Contract_AppointmentT2_GetHtmlData @InstanceId
	END
	ELSE 
	IF @DealerType = 'T1'
	   OR @DealerType = 'LP'
	   OR @DealerType = 'RLD'
	BEGIN
	    EXEC Workflow.Proc_Contract_AppointmentLp_GetHtmlData @InstanceId
	END
END
GO


