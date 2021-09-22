DROP procedure [dbo].[GC_Interface_RedCrossHospitalTransactionWithQR]
GO

create procedure [dbo].[GC_Interface_RedCrossHospitalTransactionWithQR]
	@BatchNbr NVARCHAR(30),
	@ClientID NVARCHAR(50),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(MAX) OUTPUT
    AS
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	
	update IHT
	set IHT_ErrorMsg = '�����̱�Ų�����'
	from InterfaceRedCrossHospitalTransactionWithQR IHT left join DealerMaster c on IHT_Dealer_SapCode = C.DMA_SAP_Code
	where c.DMA_ID is null
	--and IDC_IsConfirm = 1
	and IHT_BatchNbr = @BatchNbr
	
	update InterfaceRedCrossHospitalTransactionWithQR
	set IHT_ErrorMsg = (case when IHT_ErrorMsg  = '' then '' else IHT_ErrorMsg + ',' end) + '��ά�볤�Ȳ���ȷ'
	where IHT_BatchNbr = @BatchNbr
	and len(IHT_QRCode) <> 15
	
	update InterfaceRedCrossHospitalTransactionWithQR
	set IHT_ErrorMsg = (case when IHT_ErrorMsg  = '' then '' else IHT_ErrorMsg + ',' end) + '��ά��ӦΪ15λ������'
	where IHT_BatchNbr = @BatchNbr
	and PatIndex('%[^0-9]%', IHT_QRCode) > 0
	
	declare @cnt int
	select @cnt = COUNT(*) from InterfaceRedCrossHospitalTransactionWithQR where IHT_ErrorMsg <> '' and IHT_BatchNbr = @BatchNbr
	print @cnt
	IF(@cnt > 0)
	BEGIN
		SET NOCOUNT OFF
		COMMIT TRAN
		SET @RtnVal = 'Success'
		SELECT @RtnMsg = ''
		return
	END
									
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
	
	--��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	SET @RtnMsg = @vError
    return -1
    
END CATCH

GO


