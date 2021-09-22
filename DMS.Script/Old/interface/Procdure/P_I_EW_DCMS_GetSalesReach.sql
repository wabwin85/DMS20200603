
DROP Procedure [interface].[P_I_EW_DCMS_GetSalesReach]
GO


/*
完成合同填写后获取授权指标返回值
*/
CREATE Procedure [interface].[P_I_EW_DCMS_GetSalesReach]
	@DealerId uniqueidentifier,@SubBuCode NVARCHAR(50),@BeginDate DateTime ,@EndDate DateTime
AS
	
	CREATE TABLE #AOPReturn
	(
		DealerId uniqueidentifier NULL,
		CC_ID uniqueidentifier NULL,
		Year NVARCHAR(10) NULL,
		Q1 DECIMAL(18,4) NULL,
		Q2 DECIMAL(18,4) NULL,
		Q3 DECIMAL(18,4) NULL,
		Q4 DECIMAL(18,4) NULL,
		SumYear DECIMAL(18,4) NULL,
		LastSales  DECIMAL(18,4) NULL,
		AOPRatio DECIMAL(18,4) NULL
	)
	
	CREATE TABLE #Purchase
	(
		Year NVARCHAR(10) NULL,
		SumPurchase DECIMAL(18,4) NULL
	)
	 
SET NOCOUNT ON
	BEGIN
	
	
	
	
	--查询指标与占比
	INSERT INTO #AOPReturn(DealerId,CC_ID,Year,Q1,Q2,Q3,Q4,SumYear)
	SELECT a.AOPD_Dealer_DMA_ID,a.AOPD_CC_ID,A.AOPD_Year as N'Year',SUM(a.AOPD_Amount_1+a.AOPD_Amount_2+a.AOPD_Amount_3)Q1 ,
		SUM(a.AOPD_Amount_4+a.AOPD_Amount_5+a.AOPD_Amount_6)Q2,
		SUM(a.AOPD_Amount_7+a.AOPD_Amount_8+a.AOPD_Amount_9)Q3 ,
		SUM(a.AOPD_Amount_10+a.AOPD_Amount_11+a.AOPD_Amount_12)Q4,
		SUM(A.AOPD_Amount_Y) SumYear
	FROM V_AOPDealer A 
	inner join interface.ClassificationContract b on a.AOPD_CC_ID=b.CC_ID
	WHERE A.AOPD_Dealer_DMA_ID=@DealerId
	and b.CC_Code=@SubBuCode
	and CONVERT(INT,a.AOPD_Year)>=YEAR(@BeginDate) 
	and CONVERT(INT,a.AOPD_Year)<=YEAR(@EndDate)
	GROUP BY a.AOPD_Dealer_DMA_ID,a.AOPD_CC_ID,A.AOPD_Year
	
	--一级/LP采购
	INSERT INTO #Purchase(Year,SumPurchase)
	SELECT TAB.[Year],SUM(TAB.PurchaseAmount) 
	FROM (select distinct C.*
	FROM #AOPReturn A 
	INNER JOIN DealerMaster B ON B.DMA_ID=A.DealerId 
	INNER JOIN INTERFACE.T_I_QV_BSCPurchase C ON C.SAPID=B.DMA_SAP_Code  
			AND CONVERT(nvarchar(10),C.transactionDate,120) >=CONVERT(nvarchar(10),DATEADD(YYYY,-1,@BeginDate),120) 
		AND CONVERT(nvarchar(10),C.transactionDate,120) <=CONVERT(nvarchar(10),DATEADD(YYYY,-1,@EndDate),120)
	INNER JOIN CFN ON C.UPN=CFN_CustomerFaceNbr
	INNER JOIN CfnClassification CCF ON CCF.CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr
	WHERE EXISTS(SELECT 1 FROM V_ProductClassificationStructure PS WHERE PS.CC_ID=A.CC_ID AND CCF.ClassificationId=PS.CA_ID 
			AND CCF.ClassificationId IN (SELECT ProducPctId FROM GC_FN_GetDealerAuthProductSub(B.DMA_ID) WHERE ActiveFlag=1))
	OR EXISTS(SELECT 1 FROM V_ProductClassificationStructure PS WHERE PS.CC_ID=A.CC_ID AND CFN_ProductLine_BUM_ID=PS.CA_ID)) TAB
	GROUP BY TAB.[Year]
	
	
	IF EXISTS (SELECT 1 FROM #Purchase)
	BEGIN
		UPDATE A SET A.LastSales=B.SumPurchase,A.AOPRatio=(B.SumPurchase/SumYear)
		FROM #AOPReturn A,#Purchase B WHERE A.Year=B.Year AND ISNULL(B.SumPurchase,0)>0 AND ISNULL(SumYear,0)>0
	END
	SELECT Year,Q1,Q2,Q3,Q4,SumYear,LastSales,AOPRatio FROM #AOPReturn
	END
	




GO


