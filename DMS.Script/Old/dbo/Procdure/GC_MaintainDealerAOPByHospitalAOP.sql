DROP Procedure [dbo].[GC_MaintainDealerAOPByHospitalAOP]
GO


/*
	
*/
CREATE Procedure [dbo].[GC_MaintainDealerAOPByHospitalAOP]
	@ContractId NVARCHAR(100),
	@DealerDmaId NVARCHAR(100),
    @ProductLineBumId NVARCHAR(100),
    @ContractType NVARCHAR(100),
    @MarketType NVARCHAR(100),
    
    @yearString NVARCHAR(200) ,
    @BeginMonth NVARCHAR(10) ,
    @AOPType NVARCHAR(10),
    @PartsContractCode NVARCHAR(200),
    @IsAmountSy NVARCHAR(10),
    @RtnVal NVARCHAR(50) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @PartsContractID uniqueidentifier
	DECLARE @Year NVARCHAR(10)
	DECLARE @MinYear NVARCHAR(10)
	
SET NOCOUNT ON

BEGIN TRY	

BEGIN TRAN
	IF ISNULL(@MarketType,'')=''
	BEGIN
		SET @MarketType='0';
	END
	
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	SELECT TOP 1 @MinYear= VAL FROM GC_Fn_SplitStringToTable(@YearString,',') ORDER BY VAL ASC;
	
	SELECT @PartsContractID=a.CC_ID FROM interface.ClassificationContract a WHERE a.CC_Code=@PartsContractCode ;
	
	--更新经销商指标临时表数据（同步经销商医院临时表）
	IF @AOPType='Unit'
	BEGIN
		DELETE AOPDealerTemp WHERE   AOPD_Contract_ID=@ContractId 
	END
	IF @IsAmountSy='1' AND @AOPType='Amount'
	BEGIN
		DELETE AOPDealerTemp WHERE   AOPD_Contract_ID=@ContractId 
	END
    
    DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT  VAL FROM GC_Fn_SplitStringToTable(@YearString,',');
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @Year
    WHILE @@FETCH_STATUS = 0        
        BEGIN
        DECLARE @CheckAmuntDealer int
		SET @CheckAmuntDealer=0;
		IF @AOPType='Amount'
		BEGIN
			SELECT @CheckAmuntDealer=COUNT(*)	
			FROM V_AOPDealer_Temp  A WHERE A.AOPD_Contract_ID=@ContractId And A.AOPD_Year=@Year;
		END
		IF @CheckAmuntDealer=0	
		BEGIN
			IF @Year=@MinYear
			BEGIN
				
				DECLARE @CheckNumberDealer int
				SELECT @CheckNumberDealer=COUNT(*)	
				FROM AOPDealer  A WHERE A.AOPD_ProductLine_BUM_ID=@ProductLineBumId AND A.AOPD_CC_ID=@PartsContractID 
				AND CONVERT(NVARCHAR(10), a.AOPD_Market_Type)= ISNULL(@MarketType,'0') AND A.AOPD_Dealer_DMA_ID=@DealerDmaId AND A.AOPD_Year= @Year
				
				IF @CheckNumberDealer=0
				BEGIN
					IF @AOPType='Unit'
					BEGIN
						INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
						SELECT NEWID(),AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,@MarketType,AOPDH_ProductLine_BUM_ID ,AOPDH_Year,AOPDH_Month,sum(AOPDH_Amount * DBO.GC_Fn_GetProductHospitalPrice(temp.AOPDH_Hospital_ID,temp.AOPDH_PCT_ID,temp.AOPDH_Year,temp.AOPDH_Month)) AS ProductAumt,GETDATE(),@PartsContractID
						FROM AOPDealerHospitalTemp  temp
						WHERE AOPDH_Contract_ID=@ContractId AND AOPDH_Dealer_DMA_ID=@DealerDmaId AND AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND AOPDH_Year=@MinYear
						GROUP BY AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Month;
						
					END
					ELSE
					BEGIN
						INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
						SELECT NEWID(), AOPDH_Contract_ID ,AOPDH_Dealer_DMA_ID, @MarketType,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Month,SUM(AOPDH_Amount),GETDATE(),@PartsContractID
						FROM  AOPDealerHospitalTemp 
						WHERE  AOPDH_Contract_ID=@ContractId AND AOPDH_Dealer_DMA_ID=@DealerDmaId AND AOPDH_ProductLine_BUM_ID=@ProductLineBumId  AND AOPDH_Year=@Year
						GROUP BY AOPDH_Contract_ID ,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Month
					END
				END
				ELSE
				BEGIN
					INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
					SELECT NEWID(),@ContractId,@DealerDmaId,@MarketType,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,GETDATE() ,AOPD_CC_ID
					FROM AOPDealer 
					WHERE AOPD_Dealer_DMA_ID=@DealerDmaId 
					AND AOPD_ProductLine_BUM_ID=@ProductLineBumId 
					AND ISNULL(AOPD_Market_Type,'0') =ISNULL(@MarketType,'0')
					AND AOPD_CC_ID=@PartsContractID
					AND AOPD_Year =@Year
					AND CONVERT(INT,AOPD_Month) <CONVERT(INT,@BeginMonth)
					
					IF @AOPType='Unit'
					BEGIN
						INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
						SELECT NEWID(),AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,@MarketType,AOPDH_ProductLine_BUM_ID ,AOPDH_Year,AOPDH_Month,sum(AOPDH_Amount * DBO.GC_Fn_GetProductHospitalPrice(temp.AOPDH_Hospital_ID,temp.AOPDH_PCT_ID,temp.AOPDH_Year,temp.AOPDH_Month)) AS ProductAumt,GETDATE(),@PartsContractID
						FROM AOPDealerHospitalTemp  temp
						WHERE AOPDH_Contract_ID=@ContractId AND AOPDH_Dealer_DMA_ID=@DealerDmaId AND AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND AOPDH_Year=@MinYear AND CONVERT(INT,AOPDH_Month)>=CONVERT(INT,@BeginMonth)
						GROUP BY AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Month;
					END
					ELSE
					BEGIN
						INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
						SELECT NEWID(), AOPDH_Contract_ID ,AOPDH_Dealer_DMA_ID, @MarketType,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Month,SUM(AOPDH_Amount),GETDATE(),@PartsContractID
						FROM  AOPDealerHospitalTemp 
						WHERE  AOPDH_Contract_ID=@ContractId AND AOPDH_Dealer_DMA_ID=@DealerDmaId AND AOPDH_ProductLine_BUM_ID=@ProductLineBumId  AND AOPDH_Year=@Year AND CONVERT(INT,AOPDH_Month)>=CONVERT(INT,@BeginMonth)
						GROUP BY AOPDH_Contract_ID ,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Month
					END
				END
			END
			ELSE
			BEGIN
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'01','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'02','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'03','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'04','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'05','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'06','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'07','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'08','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'09','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'10','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'11','0',GETDATE(),@PartsContractID)
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date,AOPD_CC_ID)
				VALUES(NEWID(),@ContractId,@DealerDmaId,@MarketType,@ProductLineBumId,@Year,'12','0',GETDATE(),@PartsContractID)
			END
        END
        
         FETCH NEXT FROM @PRODUCT_CUR INTO @Year
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


