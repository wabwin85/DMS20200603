
DROP PROCEDURE [Workflow].[Proc_Contract_Appointment_CheckFormData]
GO


CREATE PROCEDURE [Workflow].[Proc_Contract_Appointment_CheckFormData]
	@InstanceId UNIQUEIDENTIFIER,
	@NodeIds NVARCHAR(2000),
	@RtnVal NVARCHAR(20) OUTPUT,
	@RtnMsg NVARCHAR(4000) OUTPUT
AS
BEGIN
	IF EXISTS (
	       SELECT 1
	       FROM   [Contract].AppointmentMain
	       WHERE  ContractId = @InstanceId
	              AND DealerType NOT IN ('T2', 'Trade')
	   )
	   AND EXISTS (
	           SELECT 1
	           FROM   [Contract].AppointmentCandidate
	           WHERE  ContractId = @InstanceId
	                  AND ISNULL(SAPCode, '') = ''
	       )
	   AND EXISTS (
	           SELECT 1
	           FROM   GC_Fn_SplitStringToTable(@NodeIds, ',')
	           WHERE  VAL = 'N50'
	       )
	BEGIN
	    SET @RtnVal = 'Fail';
	    SET @RtnMsg = '«ÎÃÓ–¥SAP Code';
	END
	ELSE
	BEGIN
	    SET @RtnVal = 'Success';
	    SET @RtnMsg = '';
	END
END
GO


