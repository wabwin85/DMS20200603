DROP PROCEDURE [dbo].[GC_UpdateProcessIndex_New]
GO



/*
调整流程指标
*/
CREATE PROCEDURE [dbo].[GC_UpdateProcessIndex_New]
@ContractId nvarchar(36), @ContractType nvarchar(50), @BeginDate DATETIME
AS Begin
	DECLARE @BEGINMONTH INT
	DECLARE @BEGINYEAR INT
	DECLARE @BEGINQ INT
	
	--DECLARE @AMENDMENTDATE INT
	--DECLARE @AMENDMENTBEGINDATE INT

	CREATE TABLE #HOSPA
	(
		HospitalId uniqueidentifier,
		Pct_Id uniqueidentifier,
		AOPYear NVARCHAR(10) 
	)
	
	CREATE TABLE #YearMonth
	(
		AddYear NVARCHAR(10),
		AddMonth NVARCHAR(10)
	)
	
	CREATE TABLE #HosAopSum
	(
		HospitalId uniqueidentifier,
		Pct_Id uniqueidentifier, 
		SumAmont Float
	)
		
	SET @BEGINMONTH=MONTH(@BeginDate)
	SET @BEGINYEAR=YEAR(@BeginDate)
	SET @BEGINQ=datepart(quarter,@BeginDate)
	
	--SET @AMENDMENTDATE=DAY(@BeginDate)
	
	/*当季度指标跨月累加，跨季度直接删除*/
	DECLARE @OLDDate DATETIME
	DECLARE @OLDMONTH INT
	DECLARE @OLDYEAR INT
	DECLARE @OLDQ INT
	
	DECLARE @SumAmont Float 
	
	IF EXISTS(SELECT 1 FROM contract.BeginDateLog WHERE ContractId=@ContractId)
	BEGIN
		SELECT TOP 1 @OLDDate= BeginDateOld FROM contract.BeginDateLog WHERE  ContractId=@ContractId
		SELECT  @OLDMONTH= MONTH(@OLDDate) 
		SELECT  @OLDYEAR= YEAR(@OLDDate) 
		SELECT  @OLDQ= datepart(quarter,@OLDDate)
			
		IF @OLDDate<@BeginDate AND (@OLDYEAR<@BEGINYEAR OR @OLDMONTH <@BEGINMONTH) 
		BEGIN
			INSERT INTO #YearMonth (AddYear,AddMonth)
			SELECT a.AOPD_Year,a.AOPD_Month FROM AOPDealerTemp A WHERE A.AOPD_Contract_ID=@ContractId  AND A.AOPD_Year=@BEGINYEAR
			AND A.AOPD_Month IN (
				select right('0'+cast(3 * (datepart(qq,@BeginDate)-1) + 1 as varchar),2)
				union 
				select right('0'+cast(3 * (datepart(qq,@BeginDate)-1) + 2 as varchar),2)
				union
				select right('0'+cast(3 * (datepart(qq,@BeginDate)-1) + 3 as varchar),2))
		
		
			--当季度过去月份经销商指标变动合并
			SELECT @SumAmont=SUM(A.AOPD_Amount-ISNULL(C.AOPD_Amount,0))
			FROM AOPDealerTemp  A
			INNER JOIN #YearMonth  B ON A.AOPD_Year=B.AddYear  and a.AOPD_Month=b.AddMonth
			LEFT JOIN AOPDealer C ON ISNULL(A.AOPD_Dealer_DMA_ID_Actual,a.AOPD_Dealer_DMA_ID)=C.AOPD_Dealer_DMA_ID 
				AND A.AOPD_ProductLine_BUM_ID=C.AOPD_ProductLine_BUM_ID 
				AND A.AOPD_CC_ID=C.AOPD_CC_ID
				AND A.AOPD_Year=C.AOPD_Year
				AND A.AOPD_Month=C.AOPD_Month
			WHERE AOPD_Contract_ID=@ContractId
			AND CONVERT(INT,A.AOPD_Month)>=@OLDMONTH 
			AND CONVERT(INT,A.AOPD_Month)< @BEGINMONTH
			 
			IF ISNULL(@SumAmont,0)<>0
			BEGIN
				UPDATE AOPDealerTemp SET AOPD_Amount=AOPD_Amount+ISNULL(@SumAmont,0) 
				WHERE AOPD_Contract_ID=@ContractId 
				AND AOPD_Year=@BEGINYEAR
				AND CONVERT(INT,AOPD_Month) =@BEGINMONTH
			END
			
			
			--当季度过去月份医院指标变动合并
			INSERT INTO #HosAopSum(HospitalId,Pct_Id,SumAmont)
			SELECT  A.AOPDH_Hospital_ID,A.AOPDH_PCT_ID,SUM(A.AOPDH_Amount-ISNULL(C.AOPDH_Amount,0))
			FROM AOPDealerHospitalTemp  A
			INNER JOIN #YearMonth  B ON A.AOPDH_Year=B.AddYear  and a.AOPDH_Month=b.AddMonth
			LEFT JOIN AOPDealerHospital C ON ISNULL(A.AOPDH_Dealer_DMA_ID_Actual,A.AOPDH_Dealer_DMA_ID)=C.AOPDH_Dealer_DMA_ID 
				AND A.AOPDH_ProductLine_BUM_ID=C.AOPDH_ProductLine_BUM_ID 
				AND A.AOPDH_Hospital_ID =C.AOPDH_Hospital_ID
				AND A.AOPDH_PCT_ID=C.AOPDH_PCT_ID
				AND A.AOPDH_Year=C.AOPDH_Year
				AND A.AOPDH_Month=C.AOPDH_Month
			WHERE A.AOPDH_Contract_ID=@ContractId
			AND CONVERT(INT,A.AOPDH_Month)>=@OLDMONTH 
			AND CONVERT(INT,A.AOPDH_Month)< @BEGINMONTH
			GROUP BY A.AOPDH_Hospital_ID,A.AOPDH_PCT_ID 
			 
			IF exists (select 1 from #HosAopSum)
			BEGIN
				UPDATE A SET AOPDH_Amount=AOPDH_Amount+ISNULL(b.SumAmont,0) 
				FROM AOPDealerHospitalTemp A
				INNER JOIN #HosAopSum B ON A.AOPDH_Hospital_ID=B.HospitalId AND A.AOPDH_PCT_ID=B.Pct_Id
				WHERE A.AOPDH_Contract_ID=@ContractId 
				AND A.AOPDH_Year=@BEGINYEAR
				AND CONVERT(INT,A.AOPDH_Month) =@BEGINMONTH
			END
			
		END
	END
	
	
	--修改起经销商指标
	IF EXISTS(SELECT 1 FROM AOPDealer A INNER JOIN AOPDealerTemp B ON A.AOPD_Dealer_DMA_ID=isnull(B.AOPD_Dealer_DMA_ID_Actual,b.AOPD_Dealer_DMA_ID) AND A.AOPD_CC_ID=B.AOPD_CC_ID AND A.AOPD_ProductLine_BUM_ID=B.AOPD_ProductLine_BUM_ID AND A.AOPD_Year=B.AOPD_Year AND A.AOPD_Year=@BEGINYEAR AND B.AOPD_Contract_ID=@ContractId)
	BEGIN
		UPDATE A SET AOPD_Amount=b.AOPD_Amount
		FROM AOPDealerTemp A 
		INNER JOIN  AOPDealer B ON isnull(A.AOPD_Dealer_DMA_ID_Actual,a.AOPD_Dealer_DMA_ID)=B.AOPD_Dealer_DMA_ID 
		and a.AOPD_ProductLine_BUM_ID=b.AOPD_ProductLine_BUM_ID 
		and a.AOPD_CC_ID=b.AOPD_CC_ID 
		and a.AOPD_Year=b.AOPD_Year
		AND A.AOPD_Month=B.AOPD_Month
		AND A.AOPD_Contract_ID=@ContractId
		AND A.AOPD_Year=@BEGINYEAR
		AND CONVERT(INT,a.AOPD_Month) < @BEGINMONTH
	END
	ELSE
	BEGIN
		UPDATE AOPDealerTemp SET AOPD_Amount=0 WHERE AOPD_Contract_ID=@ContractId AND AOPD_Year=@BEGINYEAR AND CONVERT(INT,AOPD_Month) < @BEGINMONTH
	END
	
	--修改医院指标
	INSERT INTO #HOSPA(HospitalId,Pct_Id,AOPYear)
	SELECT DISTINCT B.AOPDH_Hospital_ID,B.AOPDH_PCT_ID,b.AOPDH_Year FROM AOPDealerHospital A 
			INNER JOIN AOPDealerHospitalTemp B 
			ON A.AOPDH_Dealer_DMA_ID=isnull(B.AOPDH_Dealer_DMA_ID_Actual,b.AOPDH_Dealer_DMA_ID)
			AND A.AOPDH_Hospital_ID=B.AOPDH_Hospital_ID
			AND A.AOPDH_PCT_ID=B.AOPDH_PCT_ID 
			AND A.AOPDH_ProductLine_BUM_ID=B.AOPDH_ProductLine_BUM_ID 
			AND A.AOPDH_Year=B.AOPDH_Year 
			AND A.AOPDH_Year=@BEGINYEAR 
			AND B.AOPDH_Contract_ID=@ContractId
	
	UPDATE A SET A.AOPDH_Amount=b.AOPDH_Amount
	FROM AOPDealerHospitalTemp A 
	INNER JOIN  AOPDealerHospital B ON isnull(A.AOPDH_Dealer_DMA_ID_Actual,a.AOPDH_Dealer_DMA_ID)=B.AOPDH_Dealer_DMA_ID  
	and a.AOPDH_Hospital_ID=b.AOPDH_Hospital_ID
	and a.AOPDH_ProductLine_BUM_ID=b.AOPDH_ProductLine_BUM_ID 
	and a.AOPDH_PCT_ID=b.AOPDH_PCT_ID 
	and a.AOPDH_Year=b.AOPDH_Year
	AND A.AOPDH_Month=B.AOPDH_Month
	AND A.AOPDH_Contract_ID=@ContractId
	AND A.AOPDH_Year=@BEGINYEAR
	AND CONVERT(INT,a.AOPDH_Month) < @BEGINMONTH
	AND EXISTS(SELECT 1 FROM #HOSPA C WHERE C.HospitalId=A.AOPDH_Hospital_ID AND A.AOPDH_PCT_ID=C.Pct_Id and c.AOPYear=a.AOPDH_Year )

	UPDATE A SET AOPDH_Amount=0 FROM AOPDealerHospitalTemp A 
	WHERE A.AOPDH_Contract_ID=@ContractId 
	AND A.AOPDH_Year=@BEGINYEAR 
	AND CONVERT(INT,A.AOPDH_Month) < @BEGINMONTH
	AND NOT EXISTS(SELECT 1 FROM #HOSPA C WHERE C.HospitalId=A.AOPDH_Hospital_ID AND A.AOPDH_PCT_ID=C.Pct_Id and c.AOPYear=a.AOPDH_Year)
	
	
end



GO


