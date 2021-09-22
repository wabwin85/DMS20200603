DROP VIEW [dbo].[V_AOPDealerHospital]
GO




CREATE VIEW [dbo].[V_AOPDealerHospital]
AS
select AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_PCT_ID,AOPDH_Hospital_ID,AOPDH_Year,
			 sum(case
             when AOPDH_Month = '01' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_1,
       sum(case
             when AOPDH_Month = '02' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_2,
       sum(case
             when AOPDH_Month = '03' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_3,
       sum(case
             when AOPDH_Month = '04' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_4,
       sum(case
             when AOPDH_Month = '05' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_5,
       sum(case
             when AOPDH_Month = '06' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_6,
       sum(case
             when AOPDH_Month = '07' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_7,
       sum(case
             when AOPDH_Month = '08' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_8,
       sum(case
             when AOPDH_Month = '09' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_9,
       sum(case
             when AOPDH_Month = '10' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_10,
       sum(case
             when AOPDH_Month = '11' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_11,
       sum(case
             when AOPDH_Month = '12' then ISNULL(AOPDH_Amount,0) else 0
           end) as AOPDH_Amount_12,
       SUM(AOPDH_Amount) as AOPDH_Amount_Y
       from AOPDealerHospital(nolock)
       group by AOPDH_Dealer_DMA_ID,AOPDH_ProductLine_BUM_ID,AOPDH_PCT_ID,AOPDH_Hospital_ID,AOPDH_Year











GO


