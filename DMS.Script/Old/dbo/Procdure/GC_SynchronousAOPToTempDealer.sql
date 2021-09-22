DROP  Procedure [dbo].[GC_SynchronousAOPToTempDealer]
GO


/*
维护经销商指标
*/
Create Procedure [dbo].[GC_SynchronousAOPToTempDealer]
	@ContractId NVARCHAR(100), 
	@DealerId NVARCHAR(100),	  
	@ProductLineId NVARCHAR(100), 
	@SubBuId NVARCHAR(100), 
	@YearString NVARCHAR(max),
	@IsEmerging  NVARCHAR(2),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @CheckNumber int
	DECLARE @CheckNumberFormal int
	DECLARE @AopYear NVARCHAR(10)


	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''

	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT VAL FROM GC_Fn_SplitStringToTable(@YearString,',')
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @AopYear
    WHILE @@FETCH_STATUS = 0        
        BEGIN
        SELECT @CheckNumber=COUNT(*) FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@ContractId AND A.AOPD_Year=@AopYear
        IF @CheckNumber=0
        BEGIN
			SELECT @CheckNumberFormal=COUNT(*) FROM AOPDealer A WHERE A.AOPD_Dealer_DMA_ID=@DealerId AND A.AOPD_ProductLine_BUM_ID=@ProductLineId AND A.AOPD_CC_ID=@SubBuId AND A.AOPD_Market_Type=@IsEmerging AND A.AOPD_Year=@AopYear;
			IF @CheckNumberFormal>0
			BEGIN
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],
											[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				SELECT NEWID(), @ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,A.AOPD_Month,A.AOPD_Amount,NULL,GETDATE(),@SubBuId
				FROM AOPDealer A 
				WHERE A.AOPD_Dealer_DMA_ID=@DealerId AND A.AOPD_ProductLine_BUM_ID=@ProductLineId AND A.AOPD_CC_ID=@SubBuId AND A.AOPD_Market_Type=@IsEmerging AND A.AOPD_Year=@AopYear; 
			
			END
			ELSE 
			BEGIN
			
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'01',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'02',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'03',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'04',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'05',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'06',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'07',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'08',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'09',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'10',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'11',0,NULL,GETDATE(),@SubBuId)
				
				INSERT INTO AOPDealerTemp ([AOPD_ID],[AOPD_Contract_ID],[AOPD_Dealer_DMA_ID],[AOPD_Dealer_DMA_ID_Actual],[AOPD_ProductLine_BUM_ID],[AOPD_Market_Type],[AOPD_Year],[AOPD_Month],[AOPD_Amount],[AOPD_Update_User_ID],[AOPD_Update_Date] ,[AOPD_CC_ID])
				VALUES(NEWID(),@ContractId,@DealerId,NULL,@ProductLineId,@IsEmerging,@AopYear,'12',0,NULL,GETDATE(),@SubBuId)
				
			END
        END
        
        
        FETCH NEXT FROM @PRODUCT_CUR INTO @AopYear
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
	
		
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


