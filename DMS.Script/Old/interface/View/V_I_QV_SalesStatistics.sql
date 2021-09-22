DROP VIEW [interface].[V_I_QV_SalesStatistics]
GO










CREATE VIEW [interface].[V_I_QV_SalesStatistics]
AS
SELECT DealerID = b.DMA_Id
	,StartTime = [StartTime]
	,EndTime = [EndTime]
	--,InDueTime2 = [InDueTime]
	,InDueTime=CASE WHEN EXISTS (SELECT 1 FROM ShipmentHeader SH WHERE SH.SPH_Dealer_DMA_ID=D.DMA_ID AND R.ProductLineID=SH.SPH_ProductLine_BUM_ID AND SH.SPH_SubmitDate BETWEEN a.StartTime AND A.EndTime)
	THEN '是'
	WHEN InDueTime='无销量' THEN '无销量'
	ELSE '否' END
	
	,(r.DivisionName) Division 						
	,r.DivisionCode 
	,CAST(isnull((select distinct 1 from PurchaseOrderHeader
         where POH_OrderStatus not in ('Draft','Revoked','Revoking')
         and POH_DMA_ID=b.DMA_ID and  POH_SubmitDate<=DATEADD(DD,-1, DATEADD(MM,-1,DATEADD(dd,-day(DATEADD(DAY,2,StartTime))+1,DATEADD(DAY,2,StartTime)))) 
         and POH_SubmitDate>=BeginDate),0) AS INT) IsPurchased
	,MinDate
	,b.DMA_SAP_Code AS SAPID
	,[MONTH]=MONTH(DATEADD(DAY,2,StartTime))
FROM [interface].[T_I_CR_SalesStatistics](NOLOCK) a
INNER JOIN DealerMaster(NOLOCK) b ON a.DMA_SAP_Code = b.DMA_SAP_Code
INNER JOIN (
	SELECT DISTINCT DMA_ID
		,Division
		,MAX(MinDate) MinDate
		,MIN(EffectiveDate) BeginDate
	FROM V_DealerContractMaster
	GROUP BY DMA_ID
		,Division
	) AS d ON d.DMA_ID = b.DMA_ID
INNER JOIN V_DivisionProductLineRelation r ON r.IsEmerging = '0' AND CONVERT(NVARCHAR(10), r.DivisionCode) = CONVERT(NVARCHAR(10), d.Division)
 











GO


