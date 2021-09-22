DROP VIEW [dbo].[V_AOPDealer_Temp]
GO





CREATE VIEW [dbo].[V_AOPDealer_Temp]
AS
select AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_ProductLine_BUM_ID,AOPD_CC_ID,AOPD_Year,AOPD_Market_Type,
			 sum(case
             when AOPD_Month = '01' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_1,
       sum(case
             when AOPD_Month = '02' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_2,
       sum(case
             when AOPD_Month = '03' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_3,
       sum(case
             when AOPD_Month = '04' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_4,
       sum(case
             when AOPD_Month = '05' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_5,
       sum(case
             when AOPD_Month = '06' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_6,
       sum(case
             when AOPD_Month = '07' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_7,
       sum(case
             when AOPD_Month = '08' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_8,
       sum(case
             when AOPD_Month = '09' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_9,
       sum(case
             when AOPD_Month = '10' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_10,
       sum(case
             when AOPD_Month = '11' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_11,
       sum(case
             when AOPD_Month = '12' then ISNULL(AOPD_Amount,0) else 0
           end) as AOPD_Amount_12,
       SUM(AOPD_Amount) as AOPD_Amount_Y
       from AOPDealerTemp(nolock)
       group by AOPD_Contract_ID,AOPD_Dealer_DMA_ID,AOPD_ProductLine_BUM_ID,AOPD_CC_ID,AOPD_Year,AOPD_Market_Type







GO


