drop PROCEDURE [dbo].[Pro_DCMSStatusCheck]
GO



Create PROCEDURE [dbo].[Pro_DCMSStatusCheck]
WITH EXEC AS CALLER
AS
DECLARE @Massage NVARCHAR(max)	
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN

	SELECT 
	@Massage=STUFF(REPLACE(REPLACE(
				(
					SELECT ContractType+':'+CONVERT(nvarchar(36),ID) RESULT FROM (
					SELECT CAP_ID ID,'Appointment' ContractType FROM ContractAppointment WHERE CAP_Status IS NULL
					UNION
					SELECT CAM_ID,'Amendment' FROM ContractAmendment WHERE CAM_Status IS NULL
					UNION
					SELECT CRE_ID,'Renewal' FROM ContractRenewal WHERE CRE_Status IS NULL
					UNION
					SELECT CTE_ID,'Termination' FROM ContractTermination WHERE CTE_Status IS NULL
					)A 
					FOR XML AUTO
				), '<A RESULT="', ','), '"/>', ''), 1, 1, '')
	
	IF 	ISNULL(@Massage,'')<>''
	BEGIN
		INSERT INTO MailMessageQueue values(NEWID(),'email','','kaichun.hua@cnc.grapecity.com','合同同步程序出错',@Massage,'Waiting',getdate(),null);
		INSERT INTO MailMessageQueue values(NEWID(),'email','','Hao.Zhang2@bsci.com','合同同步程序出错',@Massage,'Waiting',getdate(),null);
	END
	
COMMIT TRAN
SET NOCOUNT OFF
END TRY
BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	
	
  
END CATCH
		

GO


