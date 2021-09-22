DROP  Procedure [dbo].[GC_UploadHospitalSalesByDateBox]
GO


/*
微信数据盒子
*/
CREATE Procedure [dbo].[GC_UploadHospitalSalesByDateBox]
	@UPN NVARCHAR(2000),	  
	@LOT NVARCHAR(2000), 
	@HOS_ID NVARCHAR(36), 
	@Sub_User NVARCHAR(500),
	@Rv1 NVARCHAR(2000),
	@Rv2 NVARCHAR(2000),
	@Rv3 NVARCHAR(2000),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @HSL_ID UNIQUEIDENTIFIER
	DECLARE @PRODUCTLINE_ID UNIQUEIDENTIFIER
	DECLARE @LotExpiredDate DATETIME
	DECLARE @ErrorString NVARCHAR(4000)
	
	DECLARE @DmaIdCount INT
	CREATE TABLE #TbDmaId
	(
		DMA_ID NVARCHAR(36),
	)
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @ErrorString=''
	
	SET @HSL_ID=NEWID();
	
	INSERT INTO HospitalSalesLog( HSL_ID,HSL_HOS_ID,HSL_CustomerFaceNbr,HSL_LotNumber,HSL_SendState,HSL_Sub_User,HSL_CreatDate,HSL_Rv1,HSL_Rv2,HSL_Rv3)
	VALUES(@HSL_ID,@HOS_ID,@UPN,@LOT,0,@Sub_User,GETDATE(),@Rv1,@Rv2,@Rv3);
	
	SELECT TOP 1 @PRODUCTLINE_ID=CFN_ProductLine_BUM_ID FROM CFN WHERE CFN_CustomerFaceNbr=@UPN
	IF(@PRODUCTLINE_ID IS NULL)
	BEGIN
		SET @ErrorString +='产品编码错误（非波士顿科学产品）';
	END
	ELSE
	BEGIN
		UPDATE HospitalSalesLog SET HSL_ProductLine_BUM_ID=@PRODUCTLINE_ID WHERE HSL_ID=@HSL_ID;
		
		SELECT @LotExpiredDate=LotMaster.LTM_ExpiredDate
		FROM CFN 
			INNER JOIN Product ON CFN.CFN_ID=Product.PMA_CFN_ID
			INNER JOIN LotMaster ON Product.PMA_ID=LotMaster.LTM_Product_PMA_ID
		WHERE  CFN.CFN_CustomerFaceNbr=@UPN AND LotMaster.LTM_LotNumber=@LOT
		IF(@LotExpiredDate IS NULL)
		BEGIN
			SET @ErrorString +='产品批号填写错误';
		END
		ELSE
		BEGIN
			UPDATE HospitalSalesLog SET HSL_ExpiredDate=@LotExpiredDate WHERE HSL_ID=@HSL_ID;
			INSERT INTO #TbDmaId
			SELECT DISTINCT dat.DAT_DMA_ID 
			FROM DealerAuthorizationTable dat
				INNER JOIN HospitalList hos ON dat.DAT_ID=hos.HLA_DAT_ID
			WHERE dat.DAT_ProductLine_BUM_ID=@PRODUCTLINE_ID 
				AND hos.HLA_HOS_ID=@HOS_ID
				AND dat.DAT_PMA_ID  not in ('0a3b34da-43d6-4fed-b62b-a253010d7dd0','a2cf5034-52ca-4f7e-b6f7-a26700e82bd9')
			SELECT @DmaIdCount=COUNT(*) FROM #TbDmaId;
			IF(@DmaIdCount=0)
			BEGIN
				SET @ErrorString +='该产品未在此医院授权销售';
			END
			--ELSE
			--BEGIN
			--	--UPDATE HospitalSalesLog SET HSL_DMA_ID=@DMA_ID  WHERE HSL_ID=@HSL_ID;
			--	INSERT INTO HospitalSalesLog
			--	SELECT
			--	NEWID(),DMA_ID,	HSL_HOS_ID,	HSL_ProductLine_BUM_ID,	HSL_CustomerFaceNbr,HSL_LotNumber,HSL_ExpiredDate,HSL_CreatDate,HSL_ErrorMessage,HSL_SendState,HSL_Sub_User,HSL_Rv1,HSL_Rv2,HSL_Rv3
			--	FROM HospitalSalesLog,#TbDmaId 
			--	WHERE HSL_ID=@HSL_ID;
			--	DELETE HospitalSalesLog WHERE HSL_ID=@HSL_ID;
			--END
		END
	END
	--即刻发送
	
	IF(@ErrorString<>'')
	BEGIN
		UPDATE HospitalSalesLog SET HSL_ErrorMessage =@ErrorString WHERE HSL_ID=@HSL_ID;
		SET @RtnVal = 'Failure';
	END
	ELSE
	BEGIN
		IF(@Rv2='Instant')
		BEGIN
			EXEC [dbo].[GC_SendHospitalSalesMessage] 'Instant','','' ;
		END
	END
	SET  @RtnMsg=@ErrorString;
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
    return -1
END CATCH




GO


