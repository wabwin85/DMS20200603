DROP PROCEDURE [dbo].[GC_UpdateProcessIndex]
GO


/*
调整流程指标
*/
CREATE PROCEDURE [dbo].[GC_UpdateProcessIndex]
@ContractId nvarchar(36), @ContractType nvarchar(50), @BeginDate DATETIME,@RtnVal nvarchar(20) OUTPUT, @RtnMsg nvarchar(4000) OUTPUT
WITH EXEC AS CALLER
AS
DECLARE @BEGINMONTH INT
DECLARE @BEGINYEAR INT
DECLARE @AMENDMENTDATE INT
DECLARE @AMENDMENTBEGINDATE INT

CREATE TABLE #HOSPA
(
	HospitalId uniqueidentifier,
	Pct_Id uniqueidentifier,
	AOPYear NVARCHAR(10) 
)
	
SET NOCOUNT ON
BEGIN TRY
BEGIN TRAN
	SET @RtnVal = 'Success'
	SET @RtnMsg = ''
	SET @BEGINMONTH=MONTH(@BeginDate)
	SET @BEGINYEAR=YEAR(@BeginDate)
	
	SET @AMENDMENTDATE=DAY(@BeginDate)
	
	--确认起始月份
	--IF @ContractType='Amendment'
	--BEGIN
	--	SELECT @AMENDMENTBEGINDATE=CONVERT(INT,ValueDate) FROM ContractConfig A
	--	WHERE CONVERT(NVARCHAR(10), A.DateEnd, 112) >= CONVERT(NVARCHAR(10), @BeginDate, 112)
	--	AND CONVERT(NVARCHAR(10), A.DateBegin, 112) <= CONVERT(NVARCHAR(10), @BeginDate, 112)
	--	SET @AMENDMENTBEGINDATE=ISNULL(@AMENDMENTBEGINDATE,15);
	--	IF @AMENDMENTDATE >@AMENDMENTBEGINDATE
	--	BEGIN
	--		SET @BEGINMONTH +=1;
	--	END
	--END
	
	--修改起经销商指标
	IF EXISTS(SELECT 1 FROM AOPDealer A INNER JOIN AOPDealerTemp B ON A.AOPD_Dealer_DMA_ID=B.AOPD_Dealer_DMA_ID_Actual AND A.AOPD_CC_ID=B.AOPD_CC_ID AND A.AOPD_ProductLine_BUM_ID=B.AOPD_ProductLine_BUM_ID AND A.AOPD_Year=B.AOPD_Year AND A.AOPD_Year=@BEGINYEAR AND B.AOPD_Contract_ID=@ContractId)
	BEGIN
		UPDATE A SET AOPD_Amount=b.AOPD_Amount
		FROM AOPDealerTemp A 
		INNER JOIN  AOPDealer B ON A.AOPD_Dealer_DMA_ID_Actual=B.AOPD_Dealer_DMA_ID 
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
			ON A.AOPDH_Dealer_DMA_ID=B.AOPDH_Dealer_DMA_ID_Actual 
			AND A.AOPDH_Hospital_ID=B.AOPDH_Hospital_ID
			AND A.AOPDH_PCT_ID=B.AOPDH_PCT_ID 
			AND A.AOPDH_ProductLine_BUM_ID=B.AOPDH_ProductLine_BUM_ID 
			AND A.AOPDH_Year=B.AOPDH_Year 
			AND A.AOPDH_Year=@BEGINYEAR 
			AND B.AOPDH_Contract_ID=@ContractId
	
	UPDATE A SET A.AOPDH_Amount=b.AOPDH_Amount
	FROM AOPDealerHospitalTemp A 
	INNER JOIN  AOPDealerHospital B ON A.AOPDH_Dealer_DMA_ID_Actual=B.AOPDH_Dealer_DMA_ID  
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


