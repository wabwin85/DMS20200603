DROP Procedure [dbo].[GC_MaintainDealerHospitalAOP]
GO


/*
	
*/
CREATE Procedure [dbo].[GC_MaintainDealerHospitalAOP]
	@ContractId NVARCHAR(36),
	@DealerDmaId NVARCHAR(36),
    @ProductLineBumId NVARCHAR(36),
    @ContractType NVARCHAR(36),
    @MarketType NVARCHAR(36),
    
    @yearString NVARCHAR(200) ,
    @BeginMonth NVARCHAR(10) ,
    @RtnVal NVARCHAR(50) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @HosID uniqueidentifier
	DECLARE @AopYear NVARCHAR(10)
	DECLARE @NowMonth int
	DECLARE @CheckNumber int
	DECLARE @CheckHasInitial int
	
SET NOCOUNT ON

BEGIN TRY	

BEGIN TRAN
	IF ISNULL(@MarketType,'')=''
	BEGIN
		SET @MarketType='0';
	END
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	
	IF @ContractType='Amendment'
	BEGIN
		
		IF(CONVERT(INT,@BeginMonth)>MONTH(DateAdd(D,14,GETDATE())))
		BEGIN
			SET @NowMonth=CONVERT(INT,@BeginMonth);
		END
		ELSE BEGIN
			SET @NowMonth=MONTH(DateAdd(D,14,GETDATE()));
		END
	END
	ELSE IF @ContractType='Appointment'
	BEGIN
		SET @NowMonth=CONVERT(INT,@BeginMonth);
	END
	ELSE IF @ContractType='Renewal'
	BEGIN
		SET @NowMonth=1;
	END
	
	
	--删除同一医院指标
	--DELETE AOPDealerHospitalTemp WHERE AOPDH_Contract_ID=@ContractId AND AOPDH_Dealer_DMA_ID=@DealerDmaId AND AOPDH_ProductLine_BUM_ID=@ProductLineBumId
	--AND AOPDH_Hospital_ID NOT IN 
	--(
	--SELECT	hos.HOS_ID 
	--FROM	ContractTerritory hos,
	--		DealerAuthorizationTableTemp adtemp,
	--		AOPHospitalProductMapping hpm, 
	--		COP
	--WHERE	adtemp.DAT_DCL_ID=@ContractId
	--		AND adtemp.DAT_ID=hos.Contract_ID
	--		AND hos.HOS_ID=hpm.AOPHPM_Hos_Id 
	--		AND adtemp.DAT_DCL_ID=hpm.AOPHPM_ContractId
	--		AND hpm.AOPHPM_ContractId=adtemp.DAT_DCL_ID 
	--		AND COP.COP_Type = 'Y' AND COP.COP_Year in ( SELECT  VAL FROM GC_Fn_SplitStringToTable(@yearString,','))
	--)
		
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT	hos.HOS_ID AS HOS_ID,
			COP.COP_Year AS AopYear
	FROM	ContractTerritory hos,
			DealerAuthorizationTableTemp adtemp,
			COP
	WHERE	adtemp.DAT_DCL_ID=@ContractId
			AND adtemp.DAT_ID=hos.Contract_ID
			AND COP.COP_Type = 'Y' AND COP.COP_Year in ( SELECT  VAL FROM GC_Fn_SplitStringToTable(@yearString,','))
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @HosID,@AopYear
    WHILE @@FETCH_STATUS = 0        
        BEGIN
		
			SELECT @CheckNumber=COUNT(*) FROM AOPDealerHospitalTemp 
			WHERE AOPDH_Contract_ID=@ContractId
			AND AOPDH_Dealer_DMA_ID=@DealerDmaId 
			AND AOPDH_ProductLine_BUM_ID=@ProductLineBumId 
			AND AOPDH_Hospital_ID=@HosID
			AND AOPDH_Year=@AopYear
			
			IF(@CheckNumber=0)
			BEGIN
				IF @ContractType='Appointment'
				BEGIN
					SELECT @CheckHasInitial= COUNT(*) FROM AOPHospitalReference RE  
					WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId  AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID; 
					IF(@CheckHasInitial=0)
					BEGIN
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'01',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'02',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'03',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'04',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'05',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'06',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'07',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'08',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'09',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'10',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'11',0 ;
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'12',0 ;
					END
					ELSE 
					BEGIN
						IF(@NowMonth>1)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'01',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,AOPHR_January AS Value 	FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>2)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'02',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'02',AOPHR_February FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>3)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'03',0 ;
						END
						ELSE  BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'03',AOPHR_March FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>4)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'04',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'04',AOPHR_April FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>5)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'05',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'05',AOPHR_May FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>6)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'06',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'06',AOPHR_June FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>7)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'07',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'07',AOPHR_July FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>8)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'08',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'08',AOPHR_August FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>9)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'09',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'09',AOPHR_September FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						
						IF(@NowMonth>10)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'10',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'10',AOPHR_October FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>11)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'11',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'11',AOPHR_November FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>12)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@HosID   ,@AopYear ,'12',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'12',AOPHR_December FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						END
						
					END
				END
				ELSE IF @ContractType='Amendment'
				BEGIN
					SELECT @CheckHasInitial= COUNT(*)  FROM AOPDealerHospital FRMAL
					WHERE  FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND FRMAL.AOPDH_Hospital_ID=@HosID
					
					IF(@CheckHasInitial=0)
					BEGIN
						SELECT @CheckHasInitial= COUNT(*) FROM AOPHospitalReference RE  
						WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID; 
						IF(@CheckHasInitial=0)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'01',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'02',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'03',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'04',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'05',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'06',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'07',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'08',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'09',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'10',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'11',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'12',0 ;
						END
						ELSE 
						BEGIN
							
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,AOPHR_January AS Value 	FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'02',AOPHR_February FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'03',AOPHR_March FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'04',AOPHR_April FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'05',AOPHR_May FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'06',AOPHR_June FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'07',AOPHR_July FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'08',AOPHR_August FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'09',AOPHR_September FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'10',AOPHR_October FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'11',AOPHR_November FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
						
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'12',AOPHR_December FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							
						END
					END
					ELSE BEGIN
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='01';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'02' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='02';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'03' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='03';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'04' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='04';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'05' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='05';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'06' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='06';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'07' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='07';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'08' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='08';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'09' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='09';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'10' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='10';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'11' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='11';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@HosID AS HosID  ,@AopYear AS AopYear,'12' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='12';
					END
				END
				ELSE
				BEGIN
					SELECT @CheckHasInitial= COUNT(*)  FROM AOPDealerHospital FRMAL
					WHERE  FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId  AND FRMAL.AOPDH_Year=@AopYear AND FRMAL.AOPDH_Hospital_ID=@HosID
					
					IF(@CheckHasInitial=0)
					BEGIN
						SELECT @CheckHasInitial= COUNT(*) FROM AOPHospitalReference RE  
						WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID; 
						IF(@CheckHasInitial=0)
						BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'01',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'02',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'03',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'04',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'05',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'06',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'07',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'08',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'09',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'10',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'11',0 ;
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId   ,@HosID   ,@AopYear ,'12',0 ;
						END
						ELSE 
						BEGIN
							IF(@NowMonth>1)
							BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'01',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,AOPHR_January AS Value 	FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>2)
							BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'02',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'02',AOPHR_February FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>3)
							BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'03',0 ;
							END
							ELSE  BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'03',AOPHR_March FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>4)
							BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'04',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'04',AOPHR_April FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>5)
							BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'05',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'05',AOPHR_May FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>6)
							BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'06',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'06',AOPHR_June FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>7)
							BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'07',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'07',AOPHR_July FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>8)
							BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'08',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'08',AOPHR_August FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>9)
							BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'09',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'09',AOPHR_September FROM AOPHospitalReference RE  
							WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							
							IF(@NowMonth>10)
							BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'10',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'10',AOPHR_October FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>11)
							BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'11',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'11',AOPHR_November FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>12)
							BEGIN
							INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId  ,@HosID   ,@AopYear ,'12',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@HosID ,@AopYear,'12',AOPHR_December FROM AOPHospitalReference RE  
								WHERE RE.AOPHR_ProductLine_BUM_ID=@ProductLineBumId AND RE.AOPHR_Year=@AopYear AND	RE.AOPHR_Hospital_ID=@HosID;
							END
							
						END
					END
					ELSE BEGIN
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='01';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'02' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='02';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'03' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='03';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'04' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='04';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'05' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='05';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'06' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='06';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'07' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='07';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'08' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='08';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'09' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='09';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'10' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='10';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'11' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='11';
						
						INSERT INTO AOPDealerHospitalTemp(AOPDH_ID,AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Hospital_ID,AOPDH_Year,AOPDH_Month,AOPDH_Amount) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId ,@HosID AS HosID  ,@AopYear AS AopYear,'12' AS AopMonth,FRMAL.AOPDH_Amount AS Value 	FROM AOPDealerHospital FRMAL  
						WHERE FRMAL.AOPDH_Dealer_DMA_ID=@DealerDmaId AND FRMAL.AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND FRMAL.AOPDH_Year=@AopYear AND	FRMAL.AOPDH_Hospital_ID=@HosID AND FRMAL.AOPDH_Month='12';
					END
				END
			END
			SET @CheckNumber=0
		
		FETCH NEXT FROM @PRODUCT_CUR INTO @HosID,@AopYear
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
    
    --更新经销商指标临时表数据（同步经销商医院临时表）
	--DELETE AOPDealerTemp WHERE   AOPD_Contract_ID=@ContractId AND AOPD_Dealer_DMA_ID=@DealerDmaId AND AOPD_ProductLine_BUM_ID=@ProductLineBumId
	DECLARE @CheckDealer int
	SELECT @CheckDealer=COUNT(*) FROM AOPDealerTemp WHERE   AOPD_Contract_ID=@ContractId 
	IF @CheckDealer=0
	BEGIN
		IF @ContractType='Amendment'
	BEGIN
		BEGIN
			DECLARE @CheckNumberDealer int
			SELECT @CheckNumberDealer=COUNT(*) 
			FROM AOPDealer  A 
			WHERE A.AOPD_ProductLine_BUM_ID=@ProductLineBumId 
			AND CONVERT(NVARCHAR(10), a.AOPD_Market_Type)= ISNULL(@MarketType,'0') 
			AND A.AOPD_Dealer_DMA_ID=@DealerDmaId
			AND A.AOPD_Year IN (SELECT  VAL FROM GC_Fn_SplitStringToTable(@yearString,','))
			IF @CheckNumberDealer=0
			BEGIN
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date)
				SELECT NEWID(),AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,@MarketType,AOPDH_ProductLine_BUM_ID ,AOPDH_Year,AOPDH_Month,SUM(AOPDH_Amount) AS ProductAumt,GETDATE()
				FROM AOPDealerHospitalTemp  temp
				WHERE AOPDH_Contract_ID=@ContractId AND AOPDH_Dealer_DMA_ID=@DealerDmaId AND AOPDH_ProductLine_BUM_ID=@ProductLineBumId
				GROUP BY AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Month;
			END
			ELSE
			BEGIN
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date)
				SELECT NEWID(),@ContractId,@DealerDmaId,@MarketType,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,GETDATE() 
				FROM AOPDealer 
				WHERE AOPD_Dealer_DMA_ID=@DealerDmaId 
				AND AOPD_ProductLine_BUM_ID=@ProductLineBumId 
				AND ISNULL(AOPD_Market_Type,'0') =ISNULL(@MarketType,'0')
				AND AOPD_Year IN (SELECT  VAL FROM GC_Fn_SplitStringToTable(@yearString,',')) AND CONVERT(INT,AOPD_Month) <@NowMonth
				
				INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date)
				SELECT NEWID(),AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,@MarketType,AOPDH_ProductLine_BUM_ID ,AOPDH_Year,AOPDH_Month,SUM(AOPDH_Amount) AS ProductAumt,GETDATE()
				FROM AOPDealerHospitalTemp  temp
				WHERE AOPDH_Contract_ID=@ContractId AND AOPDH_Dealer_DMA_ID=@DealerDmaId AND AOPDH_ProductLine_BUM_ID=@ProductLineBumId AND AOPDH_Month  >=@NowMonth
				GROUP BY AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Month;
			END
			
		END
	END
	ELSE
	BEGIN
		INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date)
		SELECT NEWID(),AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,@MarketType,AOPDH_ProductLine_BUM_ID ,AOPDH_Year,AOPDH_Month,SUM(AOPDH_Amount) AS ProductAumt,GETDATE()
		FROM AOPDealerHospitalTemp  temp
		WHERE AOPDH_Contract_ID=@ContractId AND AOPDH_Dealer_DMA_ID=@DealerDmaId AND AOPDH_ProductLine_BUM_ID=@ProductLineBumId
		GROUP BY AOPDH_Contract_ID,AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_Year,AOPDH_Month;
	END
	END
		
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


