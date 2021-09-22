DROP  PROCEDURE [dbo].[Pro_DCMS_QueryHospitalUnitAopTemp]
GO


/**********************************************
	功能：医院数量指标查询 （1：医院汇总指标，2产品汇总指标）
	作者：Huakaichun
	最后更新时间：	2016-07-26
	更新记录说明：
	1.创建 2016-07-26
**********************************************/
CREATE PROCEDURE [dbo].[Pro_DCMS_QueryHospitalUnitAopTemp]
	@ContractId NVARCHAR(36),
	@HospitalName NVARCHAR(200),
	@ProductName NVARCHAR(200),
	@QueryType NVARCHAR(2),
	
	@PageNum INT,
	@PageSize INT
AS
BEGIN
CREATE TABLE #HospitalAmountAOP
(
	ContractId uniqueidentifier,
	HospitalName NVARCHAR(200),
	HospitalId uniqueidentifier,
	ProductName NVARCHAR(200),
	ProductId uniqueidentifier,
	ProductCode NVARCHAR(200),
	
	Year NVARCHAR(4),
	Amount1 Float,
	Amount2 Float,
	Amount3 Float,
	Amount4 Float,
	Amount5 Float,
	Amount6 Float,
	Amount7 Float,
	Amount8 Float,
	Amount9 Float,
	Amount10 Float,
	Amount11 Float,
	Amount12 Float,
	ReAmount1 Float,
	ReAmount2 Float,
	ReAmount3 Float,
	ReAmount4 Float,
	ReAmount5 Float,
	ReAmount6 Float,
	ReAmount7 Float,
	ReAmount8 Float,
	ReAmount9 Float,
	ReAmount10 Float,
	ReAmount11 Float,
	ReAmount12 Float
)

CREATE TABLE #ReturnHospitalAmountAOP
(
	ContractId uniqueidentifier,
	HospitalName NVARCHAR(200),
	HospitalId uniqueidentifier,
	ProductName NVARCHAR(200),
	ProductId uniqueidentifier,
	ProductCode NVARCHAR(200),
	
	Year NVARCHAR(4),
	Amount1 Float,
	Amount2 Float,
	Amount3 Float,
	Amount4 Float,
	Amount5 Float,
	Amount6 Float,
	Amount7 Float,
	Amount8 Float,
	Amount9 Float,
	Amount10 Float,
	Amount11 Float,
	Amount12 Float,
	ReAmount1 Float,
	ReAmount2 Float,
	ReAmount3 Float,
	ReAmount4 Float,
	ReAmount5 Float,
	ReAmount6 Float,
	ReAmount7 Float,
	ReAmount8 Float,
	ReAmount9 Float,
	ReAmount10 Float,
	ReAmount11 Float,
	ReAmount12 Float,
	ROWNUMBER   INT,
	PRIMARY KEY(ROWNUMBER)
)
DECLARE @YearCount INT;

DECLARE @DealerId uniqueidentifier;
DECLARE @ContractIdOld uniqueidentifier;
DECLARE @CCCode NVARCHAR(10);
DECLARE @Year NVARCHAR(10);

SELECT TOP 1 @DealerId=A.AOPD_Dealer_DMA_ID,@CCCode=b.CC_Code,@Year=A.AOPD_Year 
FROM AOPDealerTemp A 
INNER JOIN INTERFACE.ClassificationContract B ON A.AOPD_CC_ID=B.CC_ID 
WHERE A.AOPD_Contract_ID=@ContractId ORDER BY A.AOPD_Year ASC

SELECT TOP 1 @ContractIdOld=CAP_ID FROM (
SELECT a.CAP_ID,a.CAP_Update_Date from ContractAppointment a where a.CAP_Status='Completed' and a.CAP_DMA_ID=@DealerId and a.CAP_SubDepID=@CCCode AND YEAR(CAP_EffectiveDate)=@Year
UNION
SELECT a.CAM_ID,a.CAM_Update_Date from ContractAmendment a where a.CAM_Status='Completed' and CAM_Quota_IsChange=1 and a.CAM_DMA_ID=@DealerId and a.CAM_SubDepID=@CCCode  AND YEAR(CAM_Amendment_EffectiveDate)=@Year
UNION
SELECT  a.CRE_ID,a.CRE_Update_Date  from ContractRenewal a where a.CRE_Status='Completed' and a.CRE_DMA_ID=@DealerId and a.CRE_SubDepID=@CCCode AND YEAR(CRE_Agrmt_EffectiveDate_Renewal)=@Year
) TAB ORDER BY CAP_Update_Date DESC


IF @ContractIdOld IS NOT NULL
BEGIN
	INSERT INTO #HospitalAmountAOP(
	ContractId,HospitalName,HospitalId,ProductName,ProductId,ProductCode,Year,
	Amount1,Amount2,Amount3,Amount4,Amount5,Amount6,Amount7,Amount8,Amount9,Amount10,Amount11,Amount12,
	ReAmount1,ReAmount2,ReAmount3,ReAmount4,ReAmount5,ReAmount6,ReAmount7,ReAmount8,ReAmount9,ReAmount10,ReAmount11,ReAmount12 )
	SELECT A.AOPDH_Contract_ID,B.HOS_HospitalName,B.HOS_ID,d.CQ_NameCN,d.CQ_ID,d.CQ_Code,A.AOPDH_Year Year,
	A.AOPDH_Amount_1 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'01') AS Amount1,
	A.AOPDH_Amount_2 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'02') AS Amount2,
	A.AOPDH_Amount_3 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'03') AS Amount3,
	A.AOPDH_Amount_4 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'04') AS Amount4,
	A.AOPDH_Amount_5 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'05') AS Amount5,
	A.AOPDH_Amount_6 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'06') AS Amount6,
	A.AOPDH_Amount_7 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'07') AS Amount7,
	A.AOPDH_Amount_8 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'08') AS Amount8,
	A.AOPDH_Amount_9 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'09') AS Amount9,
	A.AOPDH_Amount_10 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'10') AS Amount10,
	A.AOPDH_Amount_11 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'11') AS Amount11,
	A.AOPDH_Amount_12 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'12') AS Amount12,

	ISNULL(ISNULL(e.AOPDH_Amount_1,AOPHR_January),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'01') ReAmount1,
	ISNULL(ISNULL(e.AOPDH_Amount_2,AOPHR_February),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'02') ReAmount2,
	ISNULL(ISNULL(e.AOPDH_Amount_3,AOPHR_March),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'03') ReAmount3,
	ISNULL(ISNULL(e.AOPDH_Amount_4,AOPHR_April),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'04') ReAmount4,
	ISNULL(ISNULL(e.AOPDH_Amount_5,AOPHR_May),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'05') ReAmount5,
	ISNULL(ISNULL(e.AOPDH_Amount_6,AOPHR_June),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'06') ReAmount6,
	ISNULL(ISNULL(e.AOPDH_Amount_7,AOPHR_July),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'07') ReAmount7,
	ISNULL(ISNULL(e.AOPDH_Amount_8,AOPHR_August),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'08') ReAmount8,
	ISNULL(ISNULL(e.AOPDH_Amount_9,AOPHR_September),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'09') ReAmount9,
	ISNULL(ISNULL(e.AOPDH_Amount_10,AOPHR_October),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'10') ReAmount10,
	ISNULL(ISNULL(e.AOPDH_Amount_11,AOPHR_November),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'11') ReAmount11,
	ISNULL(ISNULL(e.AOPDH_Amount_12,AOPHR_December),0)* DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'12') ReAmount12
	FROM V_AOPDealerHospital_Temp A
	INNER JOIN Hospital B ON A.AOPDH_Hospital_ID=B.HOS_ID
	LEFT JOIN V_AOPDealerHospital_Temp E ON E.AOPDH_Hospital_ID=A.AOPDH_Hospital_ID AND E.AOPDH_PCT_ID=A.AOPDH_PCT_ID
	AND E.AOPDH_Year=A.AOPDH_Year AND E.AOPDH_Contract_ID=@ContractIdOld
	
	LEFT JOIN (SELECT DISTINCT CQ_ID,CQ_Code,CQ_NameCN FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
	LEFT JOIN AOPHospitalReference C ON C.AOPHR_PCT_ID=A.AOPDH_PCT_ID
		  AND C.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID
		  AND C.AOPHR_Year=A.AOPDH_Year
		  AND C.AOPHR_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
	WHERE A.AOPDH_Contract_ID=@ContractId
END 
ELSE
BEGIN

	INSERT INTO #HospitalAmountAOP(
	ContractId,HospitalName,HospitalId,ProductName,ProductId,ProductCode,Year,
	Amount1,Amount2,Amount3,Amount4,Amount5,Amount6,Amount7,Amount8,Amount9,Amount10,Amount11,Amount12,
	ReAmount1,ReAmount2,ReAmount3,ReAmount4,ReAmount5,ReAmount6,ReAmount7,ReAmount8,ReAmount9,ReAmount10,ReAmount11,ReAmount12 )
	SELECT A.AOPDH_Contract_ID,B.HOS_HospitalName,B.HOS_ID,d.CQ_NameCN,d.CQ_ID,d.CQ_Code,A.AOPDH_Year Year,
	A.AOPDH_Amount_1 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'01') AS Amount1,
	AOPDH_Amount_2 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'02') AS Amount2,
	AOPDH_Amount_3 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'03') AS Amount3,
	AOPDH_Amount_4 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'04') AS Amount4,
	AOPDH_Amount_5 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'05') AS Amount5,
	AOPDH_Amount_6 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'06') AS Amount6,
	AOPDH_Amount_7 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'07') AS Amount7,
	AOPDH_Amount_8 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'08') AS Amount8,
	AOPDH_Amount_9 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'09') AS Amount9,
	AOPDH_Amount_10 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'10') AS Amount10,
	AOPDH_Amount_11 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'11') AS Amount11,
	AOPDH_Amount_12 * DBO.GC_Fn_GetProductHospitalPrice(a.AOPDH_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'12') AS Amount12,

	ISNULL(AOPHR_January,0)* DBO.GC_Fn_GetProductHospitalPrice(c.AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'01') ReAmount1,
	ISNULL(AOPHR_February,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'02') ReAmount2,
	ISNULL(AOPHR_March,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'03') ReAmount3,
	ISNULL(AOPHR_April,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'04') ReAmount4,
	ISNULL(AOPHR_May,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'05') ReAmount5,
	ISNULL(AOPHR_June,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'06') ReAmount6,
	ISNULL(AOPHR_July,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'07') ReAmount7,
	ISNULL(AOPHR_August,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'08') ReAmount8,
	ISNULL(AOPHR_September,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'09') ReAmount9,
	ISNULL(AOPHR_October,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'10') ReAmount10,
	ISNULL(AOPHR_November,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'11') ReAmount11,
	ISNULL(AOPHR_December,0)* DBO.GC_Fn_GetProductHospitalPrice(AOPHR_Hospital_ID,a.AOPDH_PCT_ID,a.AOPDH_Year,'12') ReAmount12
	FROM V_AOPDealerHospital_Temp A
	INNER JOIN Hospital B ON A.AOPDH_Hospital_ID=B.HOS_ID
	LEFT JOIN (SELECT DISTINCT CQ_ID,CQ_Code,CQ_NameCN FROM INTERFACE.ClassificationQuota) D ON D.CQ_ID=A.AOPDH_PCT_ID
	LEFT JOIN AOPHospitalReference C ON C.AOPHR_PCT_ID=A.AOPDH_PCT_ID
		  AND C.AOPHR_Hospital_ID=A.AOPDH_Hospital_ID
		  AND C.AOPHR_Year=A.AOPDH_Year
		  AND C.AOPHR_ProductLine_BUM_ID=A.AOPDH_ProductLine_BUM_ID
	WHERE A.AOPDH_Contract_ID=@ContractId
END
IF @QueryType='1'
BEGIN
	INSERT INTO #ReturnHospitalAmountAOP(
	ContractId,HospitalName,HospitalId,Year,
	Amount1,Amount2,Amount3,Amount4,Amount5,Amount6,Amount7,Amount8,Amount9,Amount10,Amount11,Amount12,
	ReAmount1,ReAmount2,ReAmount3,ReAmount4,ReAmount5,ReAmount6,ReAmount7,ReAmount8,ReAmount9,ReAmount10,ReAmount11,ReAmount12,ROWNUMBER )
	
	SELECT ContractId,HospitalName,HospitalId,Year,
	SUM(Amount1),SUM(Amount2),SUM(Amount3),SUM(Amount4),SUM(Amount5),SUM(Amount6),SUM(Amount7),SUM(Amount8),SUM(Amount9),SUM(Amount10),SUM(Amount11),SUM(Amount12),
	SUM(ReAmount1),SUM(ReAmount2),SUM(ReAmount3),SUM(ReAmount4),SUM(ReAmount5),SUM(ReAmount6),SUM(ReAmount7),SUM(ReAmount8),SUM(ReAmount9),SUM(ReAmount10),SUM(ReAmount11),SUM(ReAmount12)
	,row_number ()    OVER (ORDER BY HospitalName , Year ASC) AS [row_number]
	FROM #HospitalAmountAOP
	WHERE  ISNULL(@HospitalName,'')='' OR HospitalName LIKE '%'+@HospitalName+'%'
	GROUP BY ContractId,HospitalName,HospitalId,Year
END

IF @QueryType='2'
BEGIN
	INSERT INTO #ReturnHospitalAmountAOP(
	ProductName,ProductId,ProductCode,Year,
	Amount1,Amount2,Amount3,Amount4,Amount5,Amount6,Amount7,Amount8,Amount9,Amount10,Amount11,Amount12,
	ReAmount1,ReAmount2,ReAmount3,ReAmount4,ReAmount5,ReAmount6,ReAmount7,ReAmount8,ReAmount9,ReAmount10,ReAmount11,ReAmount12,ROWNUMBER )
	
	SELECT ProductName,ProductId,ProductCode,Year,
	SUM(Amount1),SUM(Amount2),SUM(Amount3),SUM(Amount4),SUM(Amount5),SUM(Amount6),SUM(Amount7),SUM(Amount8),SUM(Amount9),SUM(Amount10),SUM(Amount11),SUM(Amount12),
	SUM(ReAmount1),SUM(ReAmount2),SUM(ReAmount3),SUM(ReAmount4),SUM(ReAmount5),SUM(ReAmount6),SUM(ReAmount7),SUM(ReAmount8),SUM(ReAmount9),SUM(ReAmount10),SUM(ReAmount11),SUM(ReAmount12)
	,row_number ()    OVER (ORDER BY ProductName , Year ASC) AS [row_number]
	FROM #HospitalAmountAOP
	WHERE  ISNULL(@ProductName,'')='' OR ProductName LIKE '%'+@ProductName+'%'
	GROUP BY ProductName,ProductId,ProductCode,Year
END
SELECT  @YearCount=COUNT(DISTINCT A.Year) FROM #HospitalAmountAOP A

UPDATE #ReturnHospitalAmountAOP SET ROWNUMBER=ROWNUMBER+@YearCount;

INSERT INTO #ReturnHospitalAmountAOP(ProductName,HospitalName,
Year,
Amount1,Amount2,Amount3,Amount4,Amount5,Amount6,Amount7,Amount8,Amount9,Amount10,Amount11,Amount12,
ReAmount1,ReAmount2,ReAmount3,ReAmount4,ReAmount5,ReAmount6,ReAmount7,ReAmount8,ReAmount9,ReAmount10,ReAmount11,ReAmount12,ROWNUMBER )
SELECT '合计','合计',Year,
SUM(Amount1),SUM(Amount2),SUM(Amount3),SUM(Amount4),SUM(Amount5),SUM(Amount6),SUM(Amount7),SUM(Amount8),SUM(Amount9),SUM(Amount10),SUM(Amount11),SUM(Amount12),
SUM(ReAmount1),SUM(ReAmount2),SUM(ReAmount3),SUM(ReAmount4),SUM(ReAmount5),SUM(ReAmount6),SUM(ReAmount7),SUM(ReAmount8),SUM(ReAmount9),SUM(ReAmount10),SUM(ReAmount11),SUM(ReAmount12)
,row_number ()    OVER (ORDER BY Year ASC) AS [row_number]
FROM #HospitalAmountAOP
GROUP BY Year

SELECT COUNT(*)+(CASE  WHEN ISNULL(@HospitalName,'')<>''OR ISNULL(@ProductName,'')<>'' THEN 1 ELSE 0 END  ) CNT FROM #ReturnHospitalAmountAOP A WHERE (ISNULL(@HospitalName,'')='' OR A.HospitalName LIKE '%'+@HospitalName+'%')
and (ISNULL(@ProductName,'')='' OR A.ProductName LIKE '%'+@ProductName+'%');

SELECT A.*,Amount1+Amount2+Amount3 Q1,Amount4+Amount5+Amount6 Q2,Amount7+Amount8+Amount9 Q3,Amount10+Amount11+Amount12 Q4,
Amount1+Amount2+Amount3+Amount4+Amount5+Amount6+Amount7+Amount8+Amount9+Amount10+Amount11+Amount12 AmountY,
ReAmount1+ReAmount2+ReAmount3 ReQ1,ReAmount4+ReAmount5+ReAmount6 ReQ2,ReAmount7+ReAmount8+ReAmount9 ReQ3,ReAmount10+ReAmount11+ReAmount12 ReQ4,
ReAmount1+ReAmount2+ReAmount3+ReAmount4+ReAmount5+ReAmount6+ReAmount7+ReAmount8+ReAmount9+ReAmount10+ReAmount11+ReAmount12 ReAmountY
FROM   #ReturnHospitalAmountAOP A
WHERE  ROWNUMBER  BETWEEN @PageSize * @PageNum + 1 AND @PageSize * (@PageNum+1)
ORDER BY ROWNUMBER;

END

GO


