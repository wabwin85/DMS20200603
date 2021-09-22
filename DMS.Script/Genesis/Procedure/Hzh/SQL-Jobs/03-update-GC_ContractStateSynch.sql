SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


/*

*/
ALTER Procedure [dbo].[GC_ContractStateSynch]
AS
	--参数
	DECLARE @ContractId uniqueidentifier
	DECLARE @ContractState NVARCHAR(20)
	DECLARE @ContractType NVARCHAR(100)
	DECLARE @RtnVal nvarchar(20)
	DECLARE @RtnMsg nvarchar(4000) 
	
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
		
		UPDATE Contract.StatusSynchronization SET SynStatus=1 
		WHERE SynStatus=0 
		
		SELECT * into #StatusSynchronization FROM Contract.StatusSynchronization WHERE SynStatus=1 
		
		DECLARE @PRODUCT_CUR cursor;
		SET @PRODUCT_CUR=cursor for 
			SELECT ContractId,ContractStatus,ContractType 
			FROM #StatusSynchronization  WHERE SynStatus=1  order by ApprovalDate asc
		OPEN @PRODUCT_CUR
		FETCH NEXT FROM @PRODUCT_CUR INTO @ContractId,@ContractState,@ContractType
		WHILE @@FETCH_STATUS = 0        
			BEGIN
			
			EXEC interface.P_I_EW_MaintContract_New @ContractId,@ContractType,NULL,NULL;
			
			EXEC interface.P_I_EW_Contract_Status_New @ContractId,@ContractType,@ContractState
			
			FETCH NEXT FROM @PRODUCT_CUR INTO @ContractId,@ContractState,@ContractType
			END
		CLOSE @PRODUCT_CUR
		DEALLOCATE @PRODUCT_CUR ;
		
		UPDATE Contract.StatusSynchronization  SET SynStatus=2,SynDate=GETDATE() WHERE SynStatus=1
		
		
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 

 SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
    --记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
	
	INSERT INTO MailMessageQueue 
	VALUES(NEWID(),'email','','aaron.ma@gmedtech.com','经销商'+@ContractType+'审批状态同步错误，合同编号：'+CONVERT(nvarchar(50),@ContractId),@RtnMsg,'Waiting',GETDATE(),null)
	
    return -1
		
END CATCH




GO

