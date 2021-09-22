DROP PROCEDURE [Contract].[Proc_ApproveSapCode]
GO


CREATE PROCEDURE [Contract].[Proc_ApproveSapCode](@ContractId UNIQUEIDENTIFIER, @SapCode NVARCHAR(100))
AS
BEGIN
	DECLARE @RtnVal NVARCHAR(20);
	DECLARE @RtnMsg NVARCHAR(4000);
	
	SET @RtnVal = '';
	SET @RtnMsg = '';
	
	EXEC [interface].[P_I_EW_UpdateDealerSAPCode] @ContractId, 'Appointment', @SapCode, @RtnVal OUTPUT, @RtnMsg OUTPUT
END
GO


