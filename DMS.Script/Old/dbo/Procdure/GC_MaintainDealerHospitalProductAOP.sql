DROP Procedure [dbo].[GC_MaintainDealerHospitalProductAOP]
GO


/*
	
*/
CREATE Procedure [dbo].[GC_MaintainDealerHospitalProductAOP]
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
	DECLARE @PctId uniqueidentifier
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
	DELETE AOPICDealerHospitalTemp WHERE AOPICH_Contract_ID=@ContractId AND AOPICH_DMA_ID=@DealerDmaId AND AOPICH_ProductLine_ID=@ProductLineBumId
	AND AOPICH_Hospital_ID NOT IN 
	(
	SELECT	hos.HOS_ID 
	FROM	ContractTerritory hos,
			DealerAuthorizationTableTemp adtemp,
			AOPHospitalProductMapping hpm, 
			COP
	WHERE	adtemp.DAT_DCL_ID=@ContractId
			AND adtemp.DAT_ID=hos.Contract_ID
			AND hos.HOS_ID=hpm.AOPHPM_Hos_Id 
			AND adtemp.DAT_DCL_ID=hpm.AOPHPM_ContractId
			AND hpm.AOPHPM_ContractId=adtemp.DAT_DCL_ID 
			AND COP.COP_Type = 'Y' AND COP.COP_Year in ( SELECT  VAL FROM GC_Fn_SplitStringToTable(@yearString,','))
	)
		
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT	
			--adtemp.DAT_DCL_ID ,
			--hos.Contract_ID AS DAT_ID,
			hpm.AOPHPM_PCT_ID,
			hos.HOS_ID AS HOS_ID,
			--hpm.AOPHPM_PCP_ID,
			COP.COP_Year AS AopYear
			--,pcp.PCP_Price
	FROM	ContractTerritory hos,
			DealerAuthorizationTableTemp adtemp,
			AOPHospitalProductMapping hpm, 
			COP
	WHERE	adtemp.DAT_DCL_ID=@ContractId
			AND adtemp.DAT_ID=hos.Contract_ID
			AND hos.HOS_ID=hpm.AOPHPM_Hos_Id 
			AND adtemp.DAT_DCL_ID=hpm.AOPHPM_ContractId
			AND hpm.AOPHPM_ContractId=adtemp.DAT_DCL_ID 
			AND COP.COP_Type = 'Y' AND COP.COP_Year in ( SELECT  VAL FROM GC_Fn_SplitStringToTable(@yearString,','))
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @PctId,@HosID,@AopYear
    WHILE @@FETCH_STATUS = 0        
        BEGIN
		
			SELECT @CheckNumber=COUNT(*) FROM AOPICDealerHospitalTemp 
			WHERE AOPICH_Contract_ID=@ContractId
			AND AOPICH_DMA_ID=@DealerDmaId 
			AND AOPICH_ProductLine_ID=@ProductLineBumId 
			AND AOPICH_PCT_ID=@PctId
			AND AOPICH_Hospital_ID=@HosID
			AND AOPICH_Year=@AopYear
			
			IF(@CheckNumber=0)
			BEGIN
				IF @ContractType='Appointment'
				BEGIN
					SELECT @CheckHasInitial= COUNT(*) FROM AOPICDealerHospitalReference RE  
					WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID; 
					IF(@CheckHasInitial=0)
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'12',0 ;
					END
					ELSE 
					BEGIN
						IF(@NowMonth>1)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,AOPICHR_January AS Value 	FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>2)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'02',AOPICHR_February FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>3)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
						END
						ELSE  BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'03',AOPICHR_March FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>4)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'04',AOPICHR_April FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>5)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'05',AOPICHR_May FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>6)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'06',AOPICHR_June FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>7)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'07',AOPICHR_July FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>8)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'08',AOPICHR_August FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>9)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'09',AOPICHR_September FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						
						IF(@NowMonth>10)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'10',AOPICHR_October FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>11)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'11',AOPICHR_November FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@NowMonth>12)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'12',AOPICHR_December FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						
					END
				END
				ELSE IF @ContractType='Amendment'
				BEGIN
					SELECT @CheckHasInitial= COUNT(*)  FROM AOPICDealerHospital FRMAL
					WHERE  FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND FRMAL.AOPICH_Hospital_ID=@HosID
					
					IF(@CheckHasInitial=0)
					BEGIN
						SELECT @CheckHasInitial= COUNT(*) FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID; 
						IF(@CheckHasInitial=0)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'12',0 ;
						END
						ELSE 
						BEGIN
							
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,AOPICHR_January AS Value 	FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						
							
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'02',AOPICHR_February FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'03',AOPICHR_March FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'04',AOPICHR_April FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'05',AOPICHR_May FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'06',AOPICHR_June FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'07',AOPICHR_July FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'08',AOPICHR_August FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'09',AOPICHR_September FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							
							
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'10',AOPICHR_October FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'11',AOPICHR_November FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'12',AOPICHR_December FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							
							
						END
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='01';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'02' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='02';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'03' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='03';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'04' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='04';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'05' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='05';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'06' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='06';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'07' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='07';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'08' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='08';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'09' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='09';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'10' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='10';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'11' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='11';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'12' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='12';
					END
				END
				ELSE
				BEGIN
					SELECT @CheckHasInitial= COUNT(*)  FROM AOPICDealerHospital FRMAL
					WHERE  FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND FRMAL.AOPICH_Hospital_ID=@HosID
					
					IF(@CheckHasInitial=0)
					BEGIN
						SELECT @CheckHasInitial= COUNT(*) FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID; 
						IF(@CheckHasInitial=0)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'12',0 ;
						END
						ELSE 
						BEGIN
							IF(@NowMonth>1)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,AOPICHR_January AS Value 	FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>2)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'02',AOPICHR_February FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>3)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
							END
							ELSE  BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'03',AOPICHR_March FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>4)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'04',AOPICHR_April FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>5)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'05',AOPICHR_May FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>6)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'06',AOPICHR_June FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>7)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'07',AOPICHR_July FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>8)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'08',AOPICHR_August FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>9)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'09',AOPICHR_September FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							
							IF(@NowMonth>10)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'10',AOPICHR_October FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>11)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'11',AOPICHR_November FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@NowMonth>12)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerDmaId ,@ProductLineBumId ,@PctId  ,@HosID   ,@AopYear ,'12',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerDmaId,@ProductLineBumId,@PctId,@HosID ,@AopYear,'12',AOPICHR_December FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineBumId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							
						END
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='01';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'02' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='02';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'03' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='03';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'04' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='04';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'05' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='05';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'06' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='06';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'07' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='07';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'08' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='08';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'09' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='09';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'10' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='10';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'11' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='11';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerDmaId AS DmaId,@ProductLineBumId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'12' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerDmaId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineBumId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='12';
					END
				END
			END
			SET @CheckNumber=0
		
		FETCH NEXT FROM @PRODUCT_CUR INTO @PctId,@HosID,@AopYear
        END
    CLOSE @PRODUCT_CUR
    DEALLOCATE @PRODUCT_CUR ;
    
    --更新经销商指标临时表数据（同步经销商医院临时表）
	DELETE AOPDealerTemp WHERE   AOPD_Contract_ID=@ContractId AND AOPD_Dealer_DMA_ID=@DealerDmaId AND AOPD_ProductLine_BUM_ID=@ProductLineBumId
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
				SELECT NEWID(),AOPICH_Contract_ID,AOPICH_DMA_ID,@MarketType,AOPICH_ProductLine_ID ,AOPICH_Year,AOPICH_Month,sum(AOPICH_Unit * Pcp.PCP_Price) AS ProductAumt,GETDATE()
				FROM AOPICDealerHospitalTemp  temp
				INNER JOIN AOPHospitalProductMapping mp on mp.AOPHPM_Hos_Id=temp.AOPICH_Hospital_ID and  mp.AOPHPM_ContractId=temp.AOPICH_Contract_ID 
				and mp.AOPHPM_PCT_ID=temp.AOPICH_PCT_ID
				INNER JOIN ProductClassificationPrice Pcp on Pcp.PCP_ID=mp.AOPHPM_PCP_ID
				WHERE AOPICH_Contract_ID=@ContractId AND AOPICH_DMA_ID=@DealerDmaId AND AOPICH_ProductLine_ID=@ProductLineBumId
				GROUP BY AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_Year,AOPICH_Month;
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
				SELECT NEWID(),AOPICH_Contract_ID,AOPICH_DMA_ID,@MarketType,AOPICH_ProductLine_ID ,AOPICH_Year,AOPICH_Month,sum(AOPICH_Unit * Pcp.PCP_Price) AS ProductAumt,GETDATE()
				FROM AOPICDealerHospitalTemp  temp
				INNER JOIN AOPHospitalProductMapping mp on mp.AOPHPM_Hos_Id=temp.AOPICH_Hospital_ID and  mp.AOPHPM_ContractId=temp.AOPICH_Contract_ID 
				and mp.AOPHPM_PCT_ID=temp.AOPICH_PCT_ID
				INNER JOIN ProductClassificationPrice Pcp on Pcp.PCP_ID=mp.AOPHPM_PCP_ID
				WHERE AOPICH_Contract_ID=@ContractId AND AOPICH_DMA_ID=@DealerDmaId AND AOPICH_ProductLine_ID=@ProductLineBumId AND AOPICH_Month >=@NowMonth
				GROUP BY AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_Year,AOPICH_Month;
			END
			
		END
	END
	ELSE
	BEGIN
		INSERT INTO AOPDealerTemp(AOPD_ID,AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_Market_Type,AOPD_ProductLine_BUM_ID,AOPD_Year,AOPD_Month,AOPD_Amount,AOPD_Update_Date)
		SELECT NEWID(),AOPICH_Contract_ID,AOPICH_DMA_ID,@MarketType,AOPICH_ProductLine_ID ,AOPICH_Year,AOPICH_Month,sum(AOPICH_Unit * Pcp.PCP_Price) AS ProductAumt,GETDATE()
		FROM AOPICDealerHospitalTemp  temp
		INNER JOIN AOPHospitalProductMapping mp on mp.AOPHPM_Hos_Id=temp.AOPICH_Hospital_ID and  mp.AOPHPM_ContractId=temp.AOPICH_Contract_ID 
		and mp.AOPHPM_PCT_ID=temp.AOPICH_PCT_ID
		INNER JOIN ProductClassificationPrice Pcp on Pcp.PCP_ID=mp.AOPHPM_PCP_ID
		WHERE AOPICH_Contract_ID=@ContractId AND AOPICH_DMA_ID=@DealerDmaId AND AOPICH_ProductLine_ID=@ProductLineBumId
		GROUP BY AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_Year,AOPICH_Month;
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


