DROP PROCEDURE [dbo].[GC_DealerConsignmentTransfer_AutoApproval]
GO

CREATE PROCEDURE [dbo].[GC_DealerConsignmentTransfer_AutoApproval]
	@RtnVal nvarchar(20) OUTPUT,
	@RtnMsg  nvarchar(MAX)  OUTPUT
as	
SET NOCOUNT ON
BEGIN TRY

--BEGIN TRAN
	DECLARE @SysUserId uniqueidentifier
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @SysUserId = '00000000-0000-0000-0000-000000000000'
	
  --先获取所有审批状态的寄售转移单据
  --然后调用接口进行自动审批通过
  	--@ReturnNo NVARCHAR(30),
	  --@ApprovalStatus NVARCHAR(30),
    --@ApproveUser NVARCHAR(50),
    --@ApproveDate NVARCHAR(50),
    --@ApproveNote NVARCHAR(1000),
    --@NoteId  NVARCHAR(50),
    --@ReturnValue NVARCHAR(100) OUTPUT
	
  
  --生成单据号
	Declare @ReturnNo NVARCHAR(30)
	Declare @ApprovalStatus NVARCHAR(30)
  Declare @ApproveUser NVARCHAR(50)
  Declare @ApproveDate NVARCHAR(50)
  Declare @ApproveNote NVARCHAR(1000)
  Declare @NoteId  NVARCHAR(50)
  Declare @ReturnValue NVARCHAR(100)
  
  SET @ApprovalStatus = 'Accept'
  SET @ApproveUser = '1'
  SET @ApproveDate = Getdate()
  SET @ApproveNote = ''
  SET @NoteId = ''

	DECLARE	curReturnListTmp CURSOR 
	FOR SELECT IAH_Inv_Adj_Nbr from InventoryAdjustHeader where IAH_Reason='Transfer' and IAH_Status in ('Submitted','EWFApprove') and IAH_CreatedDate>'2017-02-15 0:00:00'
  
	OPEN curReturnListTmp
	FETCH NEXT FROM curReturnListTmp INTO @ReturnNo

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC [interface].[P_I_EW_ReturnApplicationApproval]	 @ReturnNo ,@ApprovalStatus ,@ApproveUser ,@ApproveDate,@ApproveNote,@NoteId,@ReturnValue output		
   
		FETCH NEXT FROM curReturnListTmp INTO @ReturnNo
	END

	CLOSE curReturnListTmp
	DEALLOCATE curReturnListTmp
		
--COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
  SET NOCOUNT OFF
  --ROLLBACK TRAN
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
	
    return -1
    
END CATCH
GO


