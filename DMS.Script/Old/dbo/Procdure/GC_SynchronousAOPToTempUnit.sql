DROP Procedure [dbo].[GC_SynchronousAOPToTempUnit]
GO


/*
维护医院指标分类指标
*/
CREATE Procedure [dbo].[GC_SynchronousAOPToTempUnit]
	@ContractId NVARCHAR(100), 
	@DealerId NVARCHAR(100),	  
	@ProductLineId NVARCHAR(100), 
	@YearString NVARCHAR(max),
	@IsEmerging  NVARCHAR(2),
	@ContractType NVARCHAR(20),
	@BeginYearMinMonth INT,
	@CC_Code NVARCHAR(200),
    @RtnVal NVARCHAR(20) OUTPUT,
    @RtnMsg NVARCHAR(4000) OUTPUT
AS
	DECLARE @MinYear NVARCHAR(4)
	DECLARE @PctId uniqueidentifier
	DECLARE @HosID uniqueidentifier
	DECLARE @AopYear NVARCHAR(10)
	DECLARE @CheckNumber int
	DECLARE @CheckHasInitial int
	
	DECLARE @CC_ID uniqueidentifier
	DECLARE @MinTypeAop NVARCHAR(20)
	DECLARE @AvgAop money
	DECLARE @i INT
	
	--正式表中以及临时表中已经维护的指标产品分类与价格关系
	CREATE TABLE #CQ_CP(
		CQ_ID uniqueidentifier,
		CP_ID uniqueidentifier
	)
	--临时表中医院与指标产品分类关系
	CREATE TABLE #HPMappingTemp
	(
		CA_ID uniqueidentifier,
		Hos_ID uniqueidentifier,
		CQ_ID uniqueidentifier
	)
	
	CREATE TABLE #HPMappingYearTemp
	(
		Hos_ID uniqueidentifier,
		CQ_ID uniqueidentifier,
		AOPYear  NVARCHAR(10)
	)
	
SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	--获取合同分类ID
	SELECT @CC_ID=a.CC_ID FROM  interface.ClassificationContract a where a.CC_Code=@CC_Code
	--获取合同最小年份
	SELECT TOP 1 @MinYear= VAL FROM GC_Fn_SplitStringToTable(@YearString,',') ORDER BY VAL ASC;
	
	--获取授权医院和指标产品分类关系表
	INSERT INTO #HPMappingTemp(CA_ID,Hos_ID,CQ_ID)
	SELECT A.DAT_PMA_ID,B.HOS_ID,D.CQ_ID 
	FROM DealerAuthorizationTableTemp A 
	INNER JOIN ContractTerritory B ON A.DAT_ID=B.Contract_ID
	INNER JOIN (SELECT DISTINCT CA_ID,CQ_ID FROM V_ProductClassificationStructure  where CQ_ID is not null ) D ON D.CA_ID=A.DAT_PMA_ID
	WHERE A.DAT_DCL_ID=@ContractId;
	
	IF @ContractType='Renewal'
	BEGIN
		INSERT INTO #CQ_CP(CQ_ID,CP_ID)
		SELECT DISTINCT B.AOPHPM_PCT_ID,B.AOPHPM_PCP_ID  FROM AOPHospitalProductMapping B WHERE B.AOPHPM_ContractId=@ContractId
	END
	ELSE
	BEGIN
		IF @IsEmerging=2
		BEGIN
			--不分红蓝海
			INSERT INTO #CQ_CP(CQ_ID,CP_ID)
			SELECT DISTINCT AOPHPM_PCT_ID,AOPHPM_PCP_ID FROM (
			SELECT DISTINCT B.AOPHPM_PCT_ID,B.AOPHPM_PCP_ID  FROM AOPHospitalProductMapping B WHERE B.AOPHPM_ContractId=@ContractId
			UNION
			SELECT DISTINCT A.AOPHPM_PCT_ID,A.AOPHPM_PCP_ID  
			FROM AOPHospitalProductMapping A 
			WHERE A.AOPHPM_Dma_id=@DealerId and a.AOPHPM_ActiveFlag=1 
			and a.AOPHPM_PCT_ID NOT IN 
				(SELECT DISTINCT C.AOPHPM_PCT_ID  FROM AOPHospitalProductMapping C WHERE C.AOPHPM_ContractId=@ContractId)) TAB;
		END
		ELSE 
		BEGIN
			--区分红蓝海
			INSERT INTO #CQ_CP(CQ_ID,CP_ID)
			SELECT DISTINCT AOPHPM_PCT_ID,AOPHPM_PCP_ID FROM (
			SELECT DISTINCT B.AOPHPM_PCT_ID,B.AOPHPM_PCP_ID  FROM AOPHospitalProductMapping B WHERE B.AOPHPM_ContractId=@ContractId
			UNION
			SELECT DISTINCT A.AOPHPM_PCT_ID,A.AOPHPM_PCP_ID  
			FROM AOPHospitalProductMapping A 
			INNER JOIN V_AllHospitalMarketProperty D ON A.AOPHPM_Hos_Id=D.Hos_Id AND D.ProductLineID=@ProductLineId AND CONVERT(NVARCHAR(10),D.MarketProperty)=@IsEmerging
			WHERE A.AOPHPM_Dma_id=@DealerId and a.AOPHPM_ActiveFlag=1 
			and a.AOPHPM_PCT_ID NOT IN 
				(SELECT DISTINCT C.AOPHPM_PCT_ID  FROM AOPHospitalProductMapping C WHERE C.AOPHPM_ContractId=@ContractId)) TAB
		
		END
	END
	
	-- A.删除取消授权的医院(全量更新)
	DELETE AOPHospitalProductMapping WHERE AOPHPM_ContractId =@ContractId
	
	--B.维护新增医院与指标产品分类关系
	INSERT INTO AOPHospitalProductMapping (AOPHPM_Id,	AOPHPM_ContractId,	AOPHPM_Dma_id,	AOPHPM_Hos_Id,	AOPHPM_PCT_ID,	AOPHPM_PCP_ID)
	SELECT NEWID(),@ContractId,@DealerId ,A.Hos_ID,A.CQ_ID,B.CP_ID
	FROM #HPMappingTemp A 
	LEFT JOIN #CQ_CP B ON A.CQ_ID=B.CQ_ID
	 
	 
	INSERT INTO #HPMappingYearTemp(Hos_ID,CQ_ID,AOPYear) SELECT Hos_ID,CQ_ID,VAL FROM #HPMappingTemp,GC_Fn_SplitStringToTable(@YearString,',');
	DELETE A FROM AOPICDealerHospitalTemp A WHERE NOT EXISTS (SELECT 1 FROM #HPMappingYearTemp B WHERE A.AOPICH_Hospital_ID=B.Hos_ID AND A.AOPICH_PCT_ID=B.CQ_ID AND A.AOPICH_Year=B.AOPYear)
	AND A.AOPICH_Contract_ID=@ContractId
	
	
	--C.维护医院产品分类指标
	DECLARE @PRODUCT_CUR cursor;
	SET @PRODUCT_CUR=cursor for 
	SELECT CQ_ID,Hos_ID,AOPYear FROM #HPMappingYearTemp
	OPEN @PRODUCT_CUR
    FETCH NEXT FROM @PRODUCT_CUR INTO @PctId,@HosID,@AopYear
    WHILE @@FETCH_STATUS = 0        
        BEGIN
		SET @MinTypeAop=''
        SELECT @CheckNumber=COUNT(*) FROM AOPICDealerHospitalTemp A WHERE A.AOPICH_Contract_ID=@ContractId AND A.AOPICH_PCT_ID=@PctId AND A.AOPICH_Hospital_ID=@HosID AND A.AOPICH_Year=@AopYear
        IF @CheckNumber=0
        BEGIN
			IF (SELECT  COUNT (*) FROM AOPMIN A WHERE A.AOPM_ProductLine_ID=@ProductLineId AND A.AOPM_CC_ID=@CC_Id AND A.AOPM_Year=@AopYear AND A.AOPM_CQ_ID IS NULL) >0
			BEGIN
				SET @AvgAop=0; 
				SET @MinTypeAop='CCAmont'  --同一医院同一合同分类，只有汇总最小指标
				SELECT @AvgAop=AOPM_Amount FROM AOPMIN A WHERE A.AOPM_ProductLine_ID=@ProductLineId AND A.AOPM_CC_ID=@CC_Id AND A.AOPM_Year=@AopYear AND A.AOPM_CQ_ID IS NULL ;
				--SET @AvgAop= @AvgAop/(SELECT COUNT( DISTINCT CQ_ID) FROM #HPMappingTemp);
				SET @AvgAop= @AvgAop/(SELECT COUNT( DISTINCT A.CQ_ID) FROM V_ProductClassificationStructure A WHERE A.CC_ID=@CC_Id);
			END
			ELSE IF (SELECT  COUNT (*) FROM AOPMIN A WHERE A.AOPM_ProductLine_ID=@ProductLineId AND A.AOPM_CC_ID=@CC_Id AND A.AOPM_CQ_ID IN (SELECT CQ_ID FROM #HPMappingTemp) AND A.AOPM_Year=@AopYear) >0
			BEGIN
				SET @MinTypeAop='CQAmont'
			END
			ELSE 
			BEGIN
				SET @MinTypeAop=''
			END
        
        
        
			IF @ContractType='Appointment'
			BEGIN
				SELECT @CheckHasInitial= COUNT(*) FROM AOPICDealerHospitalReference RE  
				WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND RE.AOPICHR_Hospital_ID=@HosID; 
				IF @CheckHasInitial =0
				BEGIN
					--如果没有标准值，使用最小指标
					IF @MinTypeAop='CQAmont' OR @MinTypeAop='CCAmont'
					BEGIN
						IF @MinTypeAop='CQAmont'
						BEGIN
							SET @AvgAop=0;
							SELECT @AvgAop=AOPM_Amount FROM AOPMIN A WHERE A.AOPM_ProductLine_ID=@ProductLineId AND A.AOPM_CC_ID=@CC_Id AND A.AOPM_CQ_ID= @PctId;
						END
						
						SET @i=1
						WHILE @i<=12
							BEGIN
								IF((@BeginYearMinMonth>@i AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
								BEGIN
									INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
									SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,(CASE WHEN LEN(CONVERT(NVARCHAR(10),@i))=1 THEN   '0'+CONVERT(NVARCHAR(10),@i) ELSE CONVERT(NVARCHAR(10),@i) END),0 ;
								END
								ELSE
								BEGIN
									INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
									SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,
									(CASE WHEN LEN(CONVERT(NVARCHAR(10),@i))=1 THEN   '0'+CONVERT(NVARCHAR(10),@i) ELSE CONVERT(NVARCHAR(10),@i) END) AS AopMonth,
									@AvgAop AS Value 
								END
							SET @i +=1;
							END
					END
					ELSE
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'12',0 ;
					END
				END
				ELSE 
				BEGIN
					IF((@BeginYearMinMonth>1 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
					END
					ELSE
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,AOPICHR_January AS Value 	FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					IF((@BeginYearMinMonth>2 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'02',AOPICHR_February FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					IF((@BeginYearMinMonth>3 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
					END
					ELSE  BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'03',AOPICHR_March FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					IF((@BeginYearMinMonth>4 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'04',AOPICHR_April FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					IF((@BeginYearMinMonth>5 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'05',AOPICHR_May FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					IF((@BeginYearMinMonth>6 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'06',AOPICHR_June FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					IF((@BeginYearMinMonth>7 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'07',AOPICHR_July FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					IF((@BeginYearMinMonth>8 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'08',AOPICHR_August FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					IF((@BeginYearMinMonth>9 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
					SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'09',AOPICHR_September FROM AOPICDealerHospitalReference RE  
					WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					
					IF((@BeginYearMinMonth>10 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'10',AOPICHR_October FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					IF((@BeginYearMinMonth>11 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'11',AOPICHR_November FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
					IF((@BeginYearMinMonth>12 AND @AopYear=@MinYear) OR (@AopYear <>@MinYear))
					BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId,@PctId  ,@HosID   ,@AopYear ,'12',0 ;
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'12',AOPICHR_December FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
					END
				END
			END
			ELSE IF @ContractType='Amendment'
			BEGIN
				SELECT @CheckHasInitial= COUNT(*)  FROM AOPICDealerHospital FRMAL
				WHERE  FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND FRMAL.AOPICH_Hospital_ID=@HosID
				IF(@CheckHasInitial=0)
				BEGIN
					SELECT @CheckHasInitial= COUNT(*) FROM AOPICDealerHospitalReference RE  
					WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID; 
					IF(@CheckHasInitial=0)
					BEGIN
						IF @MinTypeAop='CQAmont' OR @MinTypeAop='CCAmont'
						BEGIN
							IF @MinTypeAop='CQAmont'
							BEGIN
								SET @AvgAop=0; 
								SELECT @AvgAop=AOPM_Amount FROM AOPMIN A WHERE A.AOPM_ProductLine_ID=@ProductLineId AND A.AOPM_CC_ID=@CC_Id AND A.AOPM_CQ_ID= @PctId;
							END
							
							SET @i=1
							WHILE @i<=12
								BEGIN
									IF(@BeginYearMinMonth>@i OR @AopYear<>@MinYear)
									BEGIN
										INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
										SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,(CASE WHEN LEN(CONVERT(NVARCHAR(10),@i))=1 THEN   '0'+CONVERT(NVARCHAR(10),@i) ELSE CONVERT(NVARCHAR(10),@i) END),0 ;
								
									END
									ELSE
									BEGIN
										INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
										SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,
										(CASE WHEN LEN(CONVERT(NVARCHAR(10),@i))=1 THEN   '0'+CONVERT(NVARCHAR(10),@i) ELSE CONVERT(NVARCHAR(10),@i) END)  AS AopMonth,
										@AvgAop AS Value 	
									END
								SET @i +=1;
								END
						END
						ELSE
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'12',0 ;
						END
					END
					ELSE
					BEGIN
						IF(@BeginYearMinMonth>1 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
						END
						ELSE
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,AOPICHR_January AS Value 	FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@BeginYearMinMonth>2 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'02',AOPICHR_February FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@BeginYearMinMonth>3 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
						END
						ELSE  BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'03',AOPICHR_March FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@BeginYearMinMonth>4 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'04',AOPICHR_April FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@BeginYearMinMonth>5 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'05',AOPICHR_May FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@BeginYearMinMonth>6 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'06',AOPICHR_June FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@BeginYearMinMonth>7 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'07',AOPICHR_July FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@BeginYearMinMonth>8 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'08',AOPICHR_August FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@BeginYearMinMonth>9 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'09',AOPICHR_September FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						
						IF(@BeginYearMinMonth>10 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'10',AOPICHR_October FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@BeginYearMinMonth>11 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'11',AOPICHR_November FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
						IF(@BeginYearMinMonth>12 OR @AopYear<>@MinYear)
						BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId,@PctId  ,@HosID   ,@AopYear ,'12',0 ;
						END
						ELSE BEGIN
							INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId ,@ProductLineId,@PctId,@HosID ,@AopYear,'12',AOPICHR_December FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
						END
					END
				END
				ELSE
				BEGIN
					INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
					SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,FRMAL.AOPICH_Month,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
					WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID ;
				END
			END
			ELSE  IF @ContractType='Renewal'
			BEGIN
				SELECT @CheckHasInitial= COUNT(*)  FROM AOPICDealerHospital FRMAL
				WHERE  FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND FRMAL.AOPICH_Hospital_ID=@HosID
				IF(@CheckHasInitial=0)
					BEGIN
						SELECT @CheckHasInitial= COUNT(*) FROM AOPICDealerHospitalReference RE  
						WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID; 
						IF(@CheckHasInitial=0)
						BEGIN
							IF @MinTypeAop='CQAmont' OR @MinTypeAop='CCAmont'
							BEGIN
								IF @MinTypeAop='CQAmont'
								BEGIN
									SET @AvgAop=0; 
									SELECT @AvgAop=AOPM_Amount FROM AOPMIN A WHERE A.AOPM_ProductLine_ID=@ProductLineId AND A.AOPM_CC_ID=@CC_Id AND A.AOPM_CQ_ID= @PctId;
								END
								
								SET @i=1
								WHILE @i<=12
									BEGIN
										IF(@BeginYearMinMonth>@i AND @AopYear=@MinYear)
										BEGIN
											INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
											SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,(CASE WHEN LEN(CONVERT(NVARCHAR(10),@i))=1 THEN   '0'+CONVERT(NVARCHAR(10),@i) ELSE CONVERT(NVARCHAR(10),@i) END),0 ;
										END
										ELSE
										BEGIN
											INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
											SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,
											(CASE WHEN LEN(CONVERT(NVARCHAR(10),@i))=1 THEN   '0'+CONVERT(NVARCHAR(10),@i) ELSE CONVERT(NVARCHAR(10),@i) END)  AS AopMonth,
											@AvgAop AS Value 	
										END
									SET @i +=1;
									END
							END
							ELSE
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'12',0 ;
							END
						END
						ELSE 
						BEGIN
							IF(@BeginYearMinMonth>1 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'01',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,AOPICHR_January AS Value 	FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@BeginYearMinMonth>2 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'02',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'02',AOPICHR_February FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@BeginYearMinMonth>3 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'03',0 ;
							END
							ELSE  BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'03',AOPICHR_March FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@BeginYearMinMonth>4 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'04',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'04',AOPICHR_April FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@BeginYearMinMonth>5 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'05',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'05',AOPICHR_May FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@BeginYearMinMonth>6 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'06',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'06',AOPICHR_June FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@BeginYearMinMonth>7 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'07',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'07',AOPICHR_July FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@BeginYearMinMonth>8 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'08',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'08',AOPICHR_August FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@BeginYearMinMonth>9 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'09',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
							SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'09',AOPICHR_September FROM AOPICDealerHospitalReference RE  
							WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							
							IF(@BeginYearMinMonth>10 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'10',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'10',AOPICHR_October FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@BeginYearMinMonth>11 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'11',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'11',AOPICHR_November FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							IF(@BeginYearMinMonth>12 AND @AopYear=@MinYear)
							BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID()  ,@ContractId ,@DealerId ,@ProductLineId ,@PctId  ,@HosID   ,@AopYear ,'12',0 ;
							END
							ELSE BEGIN
								INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
								SELECT NEWID(),@ContractId,@DealerId,@ProductLineId,@PctId,@HosID ,@AopYear,'12',AOPICHR_December FROM AOPICDealerHospitalReference RE  
								WHERE RE.AOPICHR_ProductLine_ID=@ProductLineId AND RE.AOPICHR_PCT_ID=@PctId AND RE.AOPICHR_Year=@AopYear AND	RE.AOPICHR_Hospital_ID=@HosID;
							END
							
						END
					END
					ELSE BEGIN
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'01' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='01';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'02' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='02';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'03' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='03';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'04' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='04';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'05' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='05';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'06' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='06';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'07' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='07';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'08' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='08';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'09' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='09';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'10' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='10';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'11' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='11';
						
						INSERT INTO AOPICDealerHospitalTemp(AOPICH_ID,AOPICH_Contract_ID,AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,AOPICH_Month,AOPICH_Unit) 
						SELECT NEWID() AS ID ,@ContractId AS ContractId,@DealerId AS DmaId,@ProductLineId AS ProductLineId,@PctId AS ProductClass ,@HosID AS HosID  ,@AopYear AS AopYear,'12' AS AopMonth,FRMAL.AOPICH_Unit AS Value 	FROM AOPICDealerHospital FRMAL  
						WHERE FRMAL.AOPICH_DMA_ID=@DealerId AND FRMAL.AOPICH_ProductLine_ID=@ProductLineId AND FRMAL.AOPICH_PCT_ID=@PctId AND FRMAL.AOPICH_Year=@AopYear AND	FRMAL.AOPICH_Hospital_ID=@HosID AND FRMAL.AOPICH_Month='12';
					END
				
			END
			
        END
        
        
        FETCH NEXT FROM @PRODUCT_CUR INTO @PctId,@HosID,@AopYear
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


