DROP Procedure [dbo].[GC_Report_AOPSales]
GO


CREATE Procedure [dbo].[GC_Report_AOPSales]
AS
    declare @SqlString nvarchar(2000)
    --declare @SubjectId uniqueidentifier
    --declare @SubjectType nvarchar(50)
    --declare @Province uniqueidentifier
    --declare @Hospital uniqueidentifier
    --declare @ProductLine uniqueidentifier
    --declare @Class uniqueidentifier
    --declare @Year nvarchar(30)
    --declare @Quarter nvarchar(50)
    
    --DECLARE aop_cur CURSOR FOR 
    	--select RPT_Subject_ID,RPT_Subject_Type,AOPS_Province,AOPS_Hospital,
    		--RPT_ProductLine_BUM_ID,RPT_ProductClassification_ID,RPT_Year,RPT_Quarter from Report_AOPSales
    
    
SET NOCOUNT ON

BEGIN TRY
	
BEGIN TRAN

/*季达成临时表*/
create table #tmp_reach(
Dealer uniqueidentifier,
Hospital uniqueidentifier,
Province uniqueidentifier,
ProductLine uniqueidentifier,
Class uniqueidentifier,
ReachAmount money,
ReachQuantity money, 
[Year] nvarchar(50),
Period nvarchar(50)
)
create index idx_tmp_reach on #tmp_reach(Dealer,ProductLine,[Year],Period)

create table #Tmp_Report_AOPSales (
	 Tmp_id 							uniqueidentifier not null,
   RPT_Subject_ID       uniqueidentifier     not null,
   RPT_Subject_Type     nvarchar(50)         not null,
   AOPS_Province        uniqueidentifier     null,
   AOPS_Hospital        uniqueidentifier     null,
   RPT_ProductLine_BUM_ID uniqueidentifier     not null,
   RPT_ProductClassification_ID uniqueidentifier     not null,
   RPT_Period_Type      nvarchar(50)         not null,
   RPT_Year             nvarchar(30)         not null,
   RPT_Quarter          nvarchar(50)         null,
   RPT_Month            nvarchar(50)         null,
   RPT_MAOP_Amount      money                null,
   RPT_QAOP_Amount      money                null,
   RPT_YAOP_Amount      money                null,
   RPT_MReach_Amount    money                null,
   RPT_QReach_Amount    money                null,
   RPT_YReach_Amount    money                null,
   RPT_MAOP_Quantity    float                null,
   RPT_QAOP_Quantity    float                null,
   RPT_YAOP_Quantity    float                null,
   RPT_MReach_Quantity  float                null,
   RPT_QReach_Quantity  float                null,
   RPT_YReach_Quantity  float                null,
   Tmp_Type nvarchar(50) null,
   primary key (Tmp_id)
)
/*清空表*/
set @SqlString = 'truncate table Report_AOPSales'
exec sp_executesql @SqlString
/*取季AOP指标*/
insert into #Tmp_Report_AOPSales(Tmp_id,RPT_ProductLine_BUM_ID,RPT_ProductClassification_ID,RPT_Subject_ID,RPT_Subject_Type,
AOPS_Province,AOPS_Hospital,RPT_Period_Type,RPT_Year,RPT_Quarter,RPT_MAOP_Amount,RPT_QAOP_Amount,
RPT_YAOP_Amount,RPT_MReach_Amount,RPT_QReach_Amount,RPT_YReach_Amount,RPT_MAOP_Quantity,RPT_QAOP_Quantity,
RPT_YAOP_Quantity,RPT_MReach_Quantity,RPT_QReach_Quantity,RPT_YReach_Quantity,Tmp_Type)
SELECT newid(),t.ProductLine,t.Class,t.SubjectId,t.SubjectType,t.Province,t.Hospital,'Q',t.[Year],t.Period,0,SUM(Amount),0,
0,0,0,0,SUM(Quantity),0,0,0,0,
case 
	when SubjectType = 'SaleMGR' then 'Manager'
	when SubjectType = 'Sale' and Province is null and Hospital is null then 'Sales'
	when SubjectType = 'Sale' and Province is not null and Hospital is null then 'Province'
	when SubjectType = 'Sale' and Province is not null and Hospital is not null then 'Hospital'
	when SubjectType not in ('SaleMGR','Sale') and ProductLine = '00000000-0000-0000-0000-000000000000' and Class = '00000000-0000-0000-0000-000000000000' then 'All'
	when SubjectType not in ('SaleMGR','Sale') and ProductLine != '00000000-0000-0000-0000-000000000000' and Class = '00000000-0000-0000-0000-000000000000' then 'ProductLine'
	when SubjectType not in ('SaleMGR','Sale') and ProductLine != '00000000-0000-0000-0000-000000000000' and Class != '00000000-0000-0000-0000-000000000000' then 'Class'
	else 'Error'
end
 FROM
(SELECT 
AOPS_ProductLine_BUM_ID AS ProductLine,
AOPS_ProductClassification_ID AS Class,
AOPS_Subject_ID AS SubjectId,
AOPS_Subject_Type AS SubjectType,
AOPS_Province AS Province,
AOPS_Hospital AS Hospital,
AOPS_Year AS [Year],
(CASE WHEN aops_month IN ('01M','02M','03M') THEN 'Q1'
WHEN aops_month IN ('04M','05M','06M') THEN 'Q2'
WHEN aops_month IN ('07M','08M','09M') THEN 'Q3'
WHEN aops_month IN ('10M','11M','12M') THEN 'Q4'
END) AS Period,
ISNULL(AOPS_Amount,0) AS Amount,
ISNULL(AOPS_Qunatity,0) AS Quantity
FROM dbo.AOPSales) AS t
GROUP BY t.ProductLine,t.Class,t.SubjectId,t.SubjectType,t.Province,t.Hospital,t.[Year],t.Period

/*更新年AOP指标*/
UPDATE #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_YAOP_Amount = 
(SELECT SUM(a.RPT_QAOP_Amount)
FROM #Tmp_Report_AOPSales a 
WHERE a.RPT_Subject_ID = #Tmp_Report_AOPSales.RPT_Subject_ID
AND a.RPT_Subject_Type = #Tmp_Report_AOPSales.RPT_Subject_Type
AND ISNULL(a.AOPS_Province,'00000000-0000-0000-0000-000000000000') = ISNULL(#Tmp_Report_AOPSales.AOPS_Province,'00000000-0000-0000-0000-000000000000')
AND ISNULL(a.AOPS_Hospital,'00000000-0000-0000-0000-000000000000') = ISNULL(#Tmp_Report_AOPSales.AOPS_Hospital,'00000000-0000-0000-0000-000000000000')
AND a.RPT_ProductLine_BUM_ID = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
AND a.RPT_ProductClassification_ID = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
AND a.RPT_Period_Type = #Tmp_Report_AOPSales.RPT_Period_Type
AND a.RPT_Year = #Tmp_Report_AOPSales.RPT_Year)

UPDATE #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_YAOP_Quantity = 
(SELECT SUM(a.RPT_QAOP_Quantity)
FROM #Tmp_Report_AOPSales a 
WHERE a.RPT_Subject_ID = #Tmp_Report_AOPSales.RPT_Subject_ID
AND a.RPT_Subject_Type = #Tmp_Report_AOPSales.RPT_Subject_Type
AND ISNULL(a.AOPS_Province,'00000000-0000-0000-0000-000000000000') = ISNULL(#Tmp_Report_AOPSales.AOPS_Province,'00000000-0000-0000-0000-000000000000')
AND ISNULL(a.AOPS_Hospital,'00000000-0000-0000-0000-000000000000') = ISNULL(#Tmp_Report_AOPSales.AOPS_Hospital,'00000000-0000-0000-0000-000000000000')
AND a.RPT_ProductLine_BUM_ID = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
AND a.RPT_ProductClassification_ID = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
AND a.RPT_Period_Type = #Tmp_Report_AOPSales.RPT_Period_Type
AND a.RPT_Year = #Tmp_Report_AOPSales.RPT_Year)

/*取销售数据*/
insert into #tmp_reach
SELECT 
sh.SPH_Dealer_DMA_ID AS Dealer,
sh.SPH_Hospital_HOS_ID AS Hospital,
t.TER_ID AS Province,
ISNULL(sh.SPH_ProductLine_BUM_ID,'00000000-0000-0000-0000-000000000000') AS ProductLine,
--ISNULL(cfn.CFN_ProductCatagory_PCT_ID,'00000000-0000-0000-0000-000000000000') AS Class,
ISNULL((select top (1) ClassificationId from CfnClassification where CfnCustomerFaceNbr=CFN.CFN_CustomerFaceNbr and
exists(select 1 from GC_FN_GetDealerAuthProductSub(sh.SPH_Dealer_DMA_ID) where ClassificationId=ProducPctId)),'00000000-0000-0000-0000-000000000000') AS Class,

sl.SPL_ShipmentQty * ISNULL(dbo.fn_GetPriceByDealerID(sh.SPH_Dealer_DMA_ID,p.PMA_CFN_ID),0) AS Amount,
sl.SPL_ShipmentQty AS Quantity,
cop.COP_Year AS [Year],
cop.COP_Period AS Period 
FROM dbo.ShipmentHeader sh
INNER JOIN dbo.ShipmentLine sl ON sl.SPL_SPH_ID = sh.SPH_ID
INNER JOIN dbo.Product p ON p.PMA_ID = sl.SPL_Shipment_PMA_ID
INNER JOIN dbo.CFN cfn ON cfn.CFN_ID = p.PMA_CFN_ID
INNER JOIN dbo.Hospital h ON HOS_ID = sh.SPH_Hospital_HOS_ID
INNER JOIN dbo.Territory t ON t.TER_Description = h.HOS_Province
INNER JOIN dbo.COP cop ON CONVERT(varchar(100), sh.SPH_ShipmentDate, 112) BETWEEN CONVERT(varchar(100), cop.COP_StartDate, 112) AND CONVERT(varchar(100), cop.COP_EndDate, 112) AND cop.COP_Type = 'Q'
WHERE sh.SPH_Status = 'Complete'

/*更新All数据*/
update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Amount = 
(select sum(a.ReachAmount)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID IN (
SELECT IDENTITY_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization'
AND MAP_ID IN (
SELECT AttributeID FROM dbo.Cache_OrganizationUnits
WHERE rootid = #Tmp_Report_AOPSales.RPT_Subject_ID
AND AttributeType = 'TSR'))) and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
)
where #Tmp_Report_AOPSales.Tmp_Type = 'All'

update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Quantity = 
(select sum(a.ReachQuantity)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID IN (
SELECT IDENTITY_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization'
AND MAP_ID IN (
SELECT AttributeID FROM dbo.Cache_OrganizationUnits
WHERE rootid = #Tmp_Report_AOPSales.RPT_Subject_ID
AND AttributeType = 'TSR'))) and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
)
where #Tmp_Report_AOPSales.Tmp_Type = 'All'
/*更新ProductLine数据*/
update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Amount = 
(select sum(a.ReachAmount)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID IN (
SELECT IDENTITY_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization'
AND MAP_ID IN (
SELECT AttributeID FROM dbo.Cache_OrganizationUnits
WHERE rootid = #Tmp_Report_AOPSales.RPT_Subject_ID
AND AttributeType = 'TSR'))) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
)
where #Tmp_Report_AOPSales.Tmp_Type = 'ProductLine'

update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Quantity = 
(select sum(a.ReachQuantity)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID IN (
SELECT IDENTITY_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization'
AND MAP_ID IN (
SELECT AttributeID FROM dbo.Cache_OrganizationUnits
WHERE rootid = #Tmp_Report_AOPSales.RPT_Subject_ID
AND AttributeType = 'TSR'))) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
)
where #Tmp_Report_AOPSales.Tmp_Type = 'ProductLine'

/*更新ProductLine数据*/
update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Amount = 
(select sum(a.ReachAmount)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID IN (
SELECT IDENTITY_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization'
AND MAP_ID IN (
SELECT AttributeID FROM dbo.Cache_OrganizationUnits
WHERE rootid = #Tmp_Report_AOPSales.RPT_Subject_ID
AND AttributeType = 'TSR'))) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.Class = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
)
where #Tmp_Report_AOPSales.Tmp_Type = 'Class'

update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Quantity = 
(select sum(a.ReachQuantity)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID IN (
SELECT IDENTITY_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization'
AND MAP_ID IN (
SELECT AttributeID FROM dbo.Cache_OrganizationUnits
WHERE rootid = #Tmp_Report_AOPSales.RPT_Subject_ID
AND AttributeType = 'TSR'))) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.Class = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
)
where #Tmp_Report_AOPSales.Tmp_Type = 'Class'

/*更新Manager数据*/
update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Amount = 
(select sum(a.ReachAmount)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID IN (
SELECT IDENTITY_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization'
AND MAP_ID IN (
SELECT AttributeID FROM dbo.Cache_OrganizationUnits
WHERE rootid = (SELECT MAP_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization' AND IDENTITY_ID = CONVERT(VARCHAR(36),#Tmp_Report_AOPSales.RPT_Subject_ID))
AND AttributeType = 'TSR'))) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.Class = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
)
where #Tmp_Report_AOPSales.Tmp_Type = 'Manager'

update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Quantity = 
(select sum(a.ReachQuantity)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID IN (
SELECT IDENTITY_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization'
AND MAP_ID IN (
SELECT AttributeID FROM dbo.Cache_OrganizationUnits
WHERE rootid = (SELECT MAP_ID FROM dbo.Lafite_IDENTITY_MAP WHERE MAP_TYPE = 'Organization' AND IDENTITY_ID = CONVERT(VARCHAR(36),#Tmp_Report_AOPSales.RPT_Subject_ID))
AND AttributeType = 'TSR'))) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.Class = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
)
where #Tmp_Report_AOPSales.Tmp_Type = 'Manager'

/*更新Sales数据*/
update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Amount = 
(select sum(a.ReachAmount)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID = #Tmp_Report_AOPSales.RPT_Subject_ID) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.Class = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
)
where #Tmp_Report_AOPSales.Tmp_Type = 'Sales'

update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Quantity = 
(select sum(a.ReachQuantity)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID = #Tmp_Report_AOPSales.RPT_Subject_ID) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.Class = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
)
where #Tmp_Report_AOPSales.Tmp_Type = 'Sales'

/*更新Province数据*/
update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Amount = 
(select sum(a.ReachAmount)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID = #Tmp_Report_AOPSales.RPT_Subject_ID) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.Class = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
and a.Province = #Tmp_Report_AOPSales.AOPS_Province
)
where #Tmp_Report_AOPSales.Tmp_Type = 'Province'

update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Quantity = 
(select sum(a.ReachQuantity)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID = #Tmp_Report_AOPSales.RPT_Subject_ID) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.Class = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
and a.Province = #Tmp_Report_AOPSales.AOPS_Province
)
where #Tmp_Report_AOPSales.Tmp_Type = 'Province'

/*更新Hospital数据*/
update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Amount = 
(select sum(a.ReachAmount)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID = #Tmp_Report_AOPSales.RPT_Subject_ID) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.Class = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
and a.Province = #Tmp_Report_AOPSales.AOPS_Province
and a.Hospital = #Tmp_Report_AOPSales.AOPS_Hospital
)
where #Tmp_Report_AOPSales.Tmp_Type = 'Hospital'

update #Tmp_Report_AOPSales SET #Tmp_Report_AOPSales.RPT_QReach_Quantity = 
(select sum(a.ReachQuantity)
from #tmp_reach a where a.Hospital in (
SELECT DISTINCT SRN_HOS_ID FROM dbo.SalesRepHospital WHERE SRH_USR_UserID = #Tmp_Report_AOPSales.RPT_Subject_ID) 
and a.[Year] = #Tmp_Report_AOPSales.RPT_Year
and a.Period = #Tmp_Report_AOPSales.RPT_Quarter
and a.ProductLine = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.Class = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
and a.Province = #Tmp_Report_AOPSales.AOPS_Province
and a.Hospital = #Tmp_Report_AOPSales.AOPS_Hospital
)
where #Tmp_Report_AOPSales.Tmp_Type = 'Hospital'

/*更新年达成*/
update #Tmp_Report_AOPSales set #Tmp_Report_AOPSales.RPT_YReach_Amount = 
(select sum(isnull(a.RPT_QReach_Amount,0))
from #Tmp_Report_AOPSales a
where a.RPT_Subject_ID = #Tmp_Report_AOPSales.RPT_Subject_ID
and a.RPT_Subject_Type = #Tmp_Report_AOPSales.RPT_Subject_Type
and isnull(a.AOPS_Province,'00000000-0000-0000-0000-000000000000') = isnull(#Tmp_Report_AOPSales.AOPS_Province,'00000000-0000-0000-0000-000000000000')
and isnull(a.AOPS_Hospital,'00000000-0000-0000-0000-000000000000') = isnull(#Tmp_Report_AOPSales.AOPS_Hospital,'00000000-0000-0000-0000-000000000000')
and a.RPT_ProductLine_BUM_ID = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.RPT_ProductClassification_ID = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
and a.RPT_Year = #Tmp_Report_AOPSales.RPT_Year
and a.RPT_Quarter <= #Tmp_Report_AOPSales.RPT_Quarter)

update #Tmp_Report_AOPSales set #Tmp_Report_AOPSales.RPT_YReach_Quantity = 
(select sum(isnull(a.RPT_QReach_Quantity,0))
from #Tmp_Report_AOPSales a
where a.RPT_Subject_ID = #Tmp_Report_AOPSales.RPT_Subject_ID
and a.RPT_Subject_Type = #Tmp_Report_AOPSales.RPT_Subject_Type
and isnull(a.AOPS_Province,'00000000-0000-0000-0000-000000000000') = isnull(#Tmp_Report_AOPSales.AOPS_Province,'00000000-0000-0000-0000-000000000000')
and isnull(a.AOPS_Hospital,'00000000-0000-0000-0000-000000000000') = isnull(#Tmp_Report_AOPSales.AOPS_Hospital,'00000000-0000-0000-0000-000000000000')
and a.RPT_ProductLine_BUM_ID = #Tmp_Report_AOPSales.RPT_ProductLine_BUM_ID
and a.RPT_ProductClassification_ID = #Tmp_Report_AOPSales.RPT_ProductClassification_ID
and a.RPT_Year = #Tmp_Report_AOPSales.RPT_Year
and a.RPT_Quarter <= #Tmp_Report_AOPSales.RPT_Quarter)

/*插入数据*/
insert into Report_AOPSales 
select RPT_Subject_ID,RPT_Subject_Type,AOPS_Province,AOPS_Hospital,RPT_ProductLine_BUM_ID,RPT_ProductClassification_ID,
RPT_Period_Type,RPT_Year,RPT_Quarter,RPT_Month,RPT_MAOP_Amount,RPT_QAOP_Amount,RPT_YAOP_Amount,RPT_MReach_Amount,
RPT_QReach_Amount,RPT_YReach_Amount,RPT_MAOP_Quantity,RPT_QAOP_Quantity,RPT_YAOP_Quantity,RPT_MReach_Quantity,
RPT_QReach_Quantity,RPT_YReach_Quantity from #Tmp_Report_AOPSales

COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    return -1
    
END CATCH


GO


