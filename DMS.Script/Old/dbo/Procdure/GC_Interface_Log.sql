DROP Procedure [dbo].[GC_Interface_Log]
GO

/*
接口日志处理
*/
CREATE Procedure [dbo].[GC_Interface_Log]
	@InterfaceType NVARCHAR(20),
	@Status NVARCHAR(20),
	@ExceptionMessage NVARCHAR(1000)
AS
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN

IF @InterfaceType = 'Confirmation'
	BEGIN
		INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_FileName,IL_Message) 
		VALUES (NEWID(),@InterfaceType,GETDATE(),GETDATE(),@Status,(SELECT TOP 1 ICO_FileName FROM InterfaceConfirmation),@ExceptionMessage)
	END

IF @InterfaceType = 'Customer'
	BEGIN
		INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_FileName,IL_Message) 
		VALUES (NEWID(),@InterfaceType,GETDATE(),GETDATE(),@Status,(SELECT TOP 1 ICU_FileName FROM InterfaceCustomer),@ExceptionMessage)
	END

IF @InterfaceType = 'Payment'
	BEGIN
		INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_FileName,IL_Message) 
		VALUES (NEWID(),@InterfaceType,GETDATE(),GETDATE(),@Status,(SELECT TOP 1 IPA_FileName FROM InterfacePayment),@ExceptionMessage)
	END

IF @InterfaceType = 'Product'
	BEGIN
		INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_FileName,IL_Message) 
		VALUES (NEWID(),@InterfaceType,GETDATE(),GETDATE(),@Status,(SELECT TOP 1 IPR_FileName FROM InterfaceProduct),@ExceptionMessage)
	END

IF @InterfaceType = 'DistributorPrice'
	BEGIN
		INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_FileName,IL_Message) 
		VALUES (NEWID(),@InterfaceType,GETDATE(),GETDATE(),@Status,(SELECT TOP 1 IDP_FileName FROM InterfaceDistributorPrice),@ExceptionMessage)
	END
	
IF @InterfaceType = 'Shipment'
	BEGIN
		INSERT INTO InterfaceLog (IL_ID,IL_Name,IL_StartTime,IL_EndTime,IL_Status,IL_FileName,IL_Message) 
		VALUES (NEWID(),@InterfaceType,GETDATE(),GETDATE(),@Status,(SELECT TOP 1 ISH_FileName FROM InterfaceShipment),@ExceptionMessage)
	END
	
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    return -1
    
END CATCH
GO


