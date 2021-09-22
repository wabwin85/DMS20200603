DROP view [dbo].[V_AOPSales]
GO



/*==============================================================*/
/* View: V_AOPSales                                             */
/*==============================================================*/
create view [dbo].[V_AOPSales] as
select AOPS_ProductLine_BUM_ID,
       AOPS_ProductClassification_ID,
       AOPS_Subject_ID,
       AOPS_Subject_Type,
       AOPS_Province,
       AOPS_Hospital,
       AOPS_Organization_ID,
       AOPS_Parent_ID,
       AOPS_Year,
       sum(case
             when AOPS_Month = '01M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_1,
       sum(case
             when AOPS_Month = '01M' then AOPS_Amount else 0
           end) as AOPS_Amount_1,
       sum(case
             when AOPS_Month = '02M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_2,
       sum(case
             when AOPS_Month = '02M' then AOPS_Amount else 0
           end) as AOPS_Amount_2,
       sum(case
             when AOPS_Month = '03M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_3,
       sum(case
             when AOPS_Month = '03M' then AOPS_Amount else 0
           end) as AOPS_Amount_3,
       sum(case
             when AOPS_Month = '04M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_4,
       sum(case
             when AOPS_Month = '04M' then AOPS_Amount else 0
           end) as AOPS_Amount_4,
       sum(case
             when AOPS_Month = '05M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_5,
       sum(case
             when AOPS_Month = '05M' then AOPS_Amount else 0
           end) as AOPS_Amount_5,
       sum(case
             when AOPS_Month = '06M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_6,
       sum(case
             when AOPS_Month = '06M' then AOPS_Amount else 0
           end) as AOPS_Amount_6,
       sum(case
             when AOPS_Month = '07M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_7,
       sum(case
             when AOPS_Month = '07M' then AOPS_Amount else 0
           end) as AOPS_Amount_7,
       sum(case
             when AOPS_Month = '08M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_8,
       sum(case
             when AOPS_Month = '08M' then AOPS_Amount else 0
           end) as AOPS_Amount_8,
       sum(case
             when AOPS_Month = '09M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_9,
       sum(case
             when AOPS_Month = '09M' then AOPS_Amount else 0
           end) as AOPS_Amount_9,
       sum(case
             when AOPS_Month = '10M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_10,
       sum(case
             when AOPS_Month = '10M' then AOPS_Amount else 0
           end) as AOPS_Amount_10,
       sum(case
             when AOPS_Month = '11M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_11,
       sum(case
             when AOPS_Month = '11M' then AOPS_Amount else 0
           end) as AOPS_Amount_11,
       sum(case
             when AOPS_Month = '12M' then AOPS_Qunatity else null
           end) as AOPS_Qunatity_12,
       sum(case
             when AOPS_Month = '12M' then AOPS_Amount else 0
           end) as AOPS_Amount_12,
       sum(AOPS_Qunatity) as AOPS_Qunatity_Y,
       sum(AOPS_Amount) as AOPS_Amount_Y
from AOPSales
group by AOPS_ProductLine_BUM_ID,
         AOPS_ProductClassification_ID,
         AOPS_Subject_ID,
         AOPS_Subject_Type,
         AOPS_Province,
         AOPS_Hospital,
         AOPS_Organization_ID,
         AOPS_Parent_ID,
         AOPS_Year

GO


