DROP VIEW [dbo].[V_AOPICDealerHospital]
GO




CREATE VIEW [dbo].[V_AOPICDealerHospital]
AS
select AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year,
			 sum(case
             when AOPICH_Month = '01' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_1,
       sum(case
             when AOPICH_Month = '02' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_2,
       sum(case
             when AOPICH_Month = '03' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_3,
       sum(case
             when AOPICH_Month = '04' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_4,
       sum(case
             when AOPICH_Month = '05' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_5,
       sum(case
             when AOPICH_Month = '06' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_6,
       sum(case
             when AOPICH_Month = '07' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_7,
       sum(case
             when AOPICH_Month = '08' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_8,
       sum(case
             when AOPICH_Month = '09' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_9,
       sum(case
             when AOPICH_Month = '10' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_10,
       sum(case
             when AOPICH_Month = '11' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_11,
       sum(case
             when AOPICH_Month = '12' then ISNULL(AOPICH_Unit,0) else 0
           end) as AOPICH_Unit_12,
       SUM(AOPICH_Unit) as AOPICH_Unit_Y
       from AOPICDealerHospital
       group by AOPICH_DMA_ID,AOPICH_ProductLine_ID,AOPICH_PCT_ID,AOPICH_Hospital_ID,AOPICH_Year





GO


