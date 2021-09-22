DROP VIEW [dbo].[V_AOPHospitalAmountTemp]
GO










CREATE VIEW [dbo].[V_AOPHospitalAmountTemp]
AS
SELECT ContractId,DmaId,ProductLineId,
       ProductId,
       ProductName,
       OperType,
       HospitalId,
       HospitalName,
       Year,
       RmkId,
       RmkBody,
       Amount1,
     Amount2,
       Amount3,
     Amount4,
       Amount5,
       Amount6,
       Amount7,
       Amount8,
       Amount9,
       Amount10,
       Amount11,
       Amount12,
       AmountY,
       Q1,
       Q2,
       Q3,
       Q4,
       RefAmount1,
       RefAmount2,
       RefAmount3,
       RefAmount4,
       RefAmount5,
       RefAmount6,
       RefAmount7,
       RefAmount8,
       RefAmount9,
       RefAmount10,
       RefAmount11,
       RefAmount12,
       RefQ1, 
       RefQ2, 
       RefQ3, 
       RefQ4,
       RefYear, 
       FromalAmount1, 
       FromalAmount2, 
       FromalAmount3,
       FromalAmount4,
       FromalAmount5, 
       FromalAmount6, 
       FromalAmount7, 
       FromalAmount8, 
       FromalAmount9, 
       FromalAmount10, 
       FromalAmount11, 
       FromalAmount12, 
       FromalQ1, 
       FromalQ2, 
       FromalQ3, 
       FromalQ4, 
       FromalYear,
       Amount1 - RefAmount1 DiffAmount1,
       Amount2 - RefAmount2 DiffAmount2,
       Amount3 - RefAmount3 DiffAmount3,
       Amount4 - RefAmount4 DiffAmount4,
       Amount5 - RefAmount5 DiffAmount5,
       Amount6 - RefAmount6 DiffAmount6,
       Amount7 - RefAmount7 DiffAmount7,
       Amount8 - RefAmount8 DiffAmount8,
       Amount9 - RefAmount9 DiffAmount9,
       Amount10 - RefAmount10 DiffAmount10,
       Amount11 - RefAmount11 DiffAmount11,
       Amount12 - RefAmount12 DiffAmount12,
       Q1 - RefQ1 DiffAmountQ1,
       Q2 - RefQ2 DiffAmountQ2,
       Q3 - RefQ3 DiffAmountQ3,
       Q4 - RefQ4 DiffAmountQ4,
       AmountY - RefYear DiffAmountY,
       Amount1 - FromalAmount1 FormalDiffAmount1,
       Amount2 - FromalAmount2 FormalDiffAmount2,
       Amount3 - FromalAmount3 FormalDiffAmount3,
       Amount4 - FromalAmount4 FormalDiffAmount4,
       Amount5 - FromalAmount5 FormalDiffAmount5,
       Amount6 - FromalAmount6 FormalDiffAmount6,
       Amount7 - FromalAmount7 FormalDiffAmount7,
       Amount8 - FromalAmount8 FormalDiffAmount8,
       Amount9 - FromalAmount9 FormalDiffAmount9,
       Amount10 - FromalAmount10 FormalDiffAmount10,
       Amount11 - FromalAmount11 FormalDiffAmount11,
       Amount12 - FromalAmount12 FormalDiffAmount12,
       Q1 - FromalQ1 FormalDiffAmountQ1,
       Q2 - FromalQ2 FormalDiffAmountQ2,
       Q3 - FromalQ3 FormalDiffAmountQ3,
       Q4 - FromalQ4 FormalDiffAmountQ4,
       AmountY - FromalYear FormalDiffAmountY,
       StartDate,EndDate
       --,row_number ()    OVER (ORDER BY  OperType, HospitalName, Year,ProductName ASC) AS [row_number]
  FROM ( SELECT AOP.AOPDH_Contract_ID AS ContractId,
               AOP.AOPDH_Dealer_DMA_ID AS DmaId,
               AOP.AOPDH_ProductLine_BUM_ID AS ProductLineId,
               AOP.AOPDH_PCT_ID AS ProductId,
               pcf.CQ_NameCN AS ProductName,
               AOP.AOPDH_Hospital_ID AS HospitalId,
               TreeHos.Territory_Type AS OperType,
               Hospital.HOS_HospitalName AS HospitalName,
               AOP.AOPDH_Year AS Year,
               AOP.AOPDH_Amount_1 AS Amount1,
               AOP.AOPDH_Amount_2 AS Amount2,
               AOP.AOPDH_Amount_3 AS Amount3,
               AOP.AOPDH_Amount_4 AS Amount4,
               AOP.AOPDH_Amount_5 AS Amount5,
               AOP.AOPDH_Amount_6 AS Amount6,
               AOP.AOPDH_Amount_7 AS Amount7,
               AOP.AOPDH_Amount_8 AS Amount8,
               AOP.AOPDH_Amount_9 AS Amount9,
               AOP.AOPDH_Amount_10 AS Amount10,
               AOP.AOPDH_Amount_11 AS Amount11,
               AOP.AOPDH_Amount_12 AS Amount12,
               AOP.AOPDH_Amount_Y AS AmountY,
               (AOP.AOPDH_Amount_1 + AOP.AOPDH_Amount_2 + AOP.AOPDH_Amount_3)
                  Q1,
               (AOP.AOPDH_Amount_4 + AOP.AOPDH_Amount_5 + AOP.AOPDH_Amount_6)
                  Q2,
               (AOP.AOPDH_Amount_7 + AOP.AOPDH_Amount_8 + AOP.AOPDH_Amount_9)
                  Q3,
               (  AOP.AOPDH_Amount_10
                + AOP.AOPDH_Amount_11
                + AOP.AOPDH_Amount_12)
                  Q4,
               ISNULL (rec.AOPHR_January, 0) AS RefAmount1,
               ISNULL (rec.AOPHR_February, 0) AS RefAmount2,
               ISNULL (rec.AOPHR_March, 0) AS RefAmount3,
               ISNULL (rec.AOPHR_April, 0) AS RefAmount4,
               ISNULL (rec.AOPHR_May, 0) AS RefAmount5,
               ISNULL (rec.AOPHR_June, 0) AS RefAmount6,
               ISNULL (rec.AOPHR_July, 0) AS RefAmount7,
               ISNULL (rec.AOPHR_August, 0) AS RefAmount8,
               ISNULL (rec.AOPHR_September, 0) AS RefAmount9,
               ISNULL (rec.AOPHR_October, 0) AS RefAmount10,
               ISNULL (rec.AOPHR_November, 0) AS RefAmount11,
               ISNULL (rec.AOPHR_December, 0) AS RefAmount12,
               (  ISNULL (rec.AOPHR_January, 0)
                + ISNULL (rec.AOPHR_February, 0)
                + ISNULL (rec.AOPHR_March, 0))
                  RefQ1,
               (  ISNULL (rec.AOPHR_April, 0)
                + ISNULL (rec.AOPHR_May, 0)
                + ISNULL (rec.AOPHR_June, 0))
                  RefQ2,
               (  ISNULL (rec.AOPHR_July, 0)
                + ISNULL (rec.AOPHR_August, 0)
                + ISNULL (rec.AOPHR_September, 0))
                  RefQ3,
               (  ISNULL (rec.AOPHR_October, 0)
                + ISNULL (rec.AOPHR_November, 0)
                + ISNULL (rec.AOPHR_December, 0))
                  RefQ4,
               (  ISNULL (rec.AOPHR_January, 0)
                + ISNULL (rec.AOPHR_February, 0)
                + ISNULL (rec.AOPHR_March, 0)
                + ISNULL (rec.AOPHR_April, 0)
                + ISNULL (rec.AOPHR_May, 0)
                + ISNULL (rec.AOPHR_June, 0)
                + ISNULL (rec.AOPHR_July, 0)
                + ISNULL (rec.AOPHR_August, 0)
                + ISNULL (rec.AOPHR_September, 0)
                + ISNULL (rec.AOPHR_October, 0)
                + ISNULL (rec.AOPHR_November, 0)
                + ISNULL (rec.AOPHR_December, 0))
                  RefYear,
               ISNULL (Formal.AOPDH_Amount_1, 0) FromalAmount1,
               ISNULL (Formal.AOPDH_Amount_2, 0) FromalAmount2,
               ISNULL (Formal.AOPDH_Amount_3, 0) FromalAmount3,
               ISNULL (Formal.AOPDH_Amount_4, 0) FromalAmount4,
               ISNULL (Formal.AOPDH_Amount_5, 0) FromalAmount5,
               ISNULL (Formal.AOPDH_Amount_6, 0) FromalAmount6,
               ISNULL (Formal.AOPDH_Amount_7, 0) FromalAmount7,
               ISNULL (Formal.AOPDH_Amount_8, 0) FromalAmount8,
               ISNULL (Formal.AOPDH_Amount_9, 0) FromalAmount9,
               ISNULL (Formal.AOPDH_Amount_10, 0) FromalAmount10,
               ISNULL (Formal.AOPDH_Amount_11, 0) FromalAmount11,
               ISNULL (Formal.AOPDH_Amount_12, 0) FromalAmount12,
               (  ISNULL (Formal.AOPDH_Amount_1, 0)
                + ISNULL (Formal.AOPDH_Amount_2, 0)
                + ISNULL (Formal.AOPDH_Amount_3, 0))
                  FromalQ1,
               (  ISNULL (Formal.AOPDH_Amount_4, 0)
                + ISNULL (Formal.AOPDH_Amount_5, 0)
                + ISNULL (Formal.AOPDH_Amount_6, 0))
                  FromalQ2,
               (  ISNULL (Formal.AOPDH_Amount_7, 0)
                + ISNULL (Formal.AOPDH_Amount_8, 0)
                + ISNULL (Formal.AOPDH_Amount_9, 0))
                  FromalQ3,
               (  ISNULL (Formal.AOPDH_Amount_10, 0)
                + ISNULL (Formal.AOPDH_Amount_11, 0)
                + ISNULL (Formal.AOPDH_Amount_12, 0))
                  FromalQ4,
               ISNULL (Formal.AOPDH_Amount_Y, 0) FromalYear,
               REK.Rmk_ID RmkId,
               REK.Rmk_Body RmkBody,
               StartDate,EndDate
          FROM V_AOPDealerHospital_Temp AOP(nolock)
               LEFT JOIN AOPHospitalReference rec(nolock)
                  ON     AOP.AOPDH_ProductLine_BUM_ID =
                            rec.AOPHR_ProductLine_BUM_ID
                     AND AOP.AOPDH_Hospital_ID = rec.AOPHR_Hospital_ID
                     AND AOP.AOPDH_Year = rec.AOPHR_Year
                     AND AOP.AOPDH_PCT_ID = rec.AOPHR_PCT_ID
               LEFT JOIN V_AOPDealerHospital Formal(nolock)
                  ON     Formal.AOPDH_Dealer_DMA_ID = AOP.AOPDH_Dealer_DMA_ID
                     AND Formal.AOPDH_Hospital_ID = AOP.AOPDH_Hospital_ID
                     AND Formal.AOPDH_ProductLine_BUM_ID =
                            AOP.AOPDH_ProductLine_BUM_ID
                     AND Formal.AOPDH_PCT_ID = AOP.AOPDH_PCT_ID
                     AND Formal.AOPDH_Year = AOP.AOPDH_Year
               INNER JOIN Hospital(nolock)
                  ON Hospital.HOS_ID = AOP.AOPDH_Hospital_ID
                INNER JOIN (select distinct CQ_ID,CQ_NameCN from interface.ClassificationQuota (nolock)) pcf
                  ON pcf.CQ_ID = aop.AOPDH_PCT_ID
               LEFT JOIN (SELECT DISTINCT A.DAT_DCL_ID,E.CQ_ID,B.HOS_ID,B.Territory_Type,StartDate,EndDate
                            FROM DealerAuthorizationTableTemp A (nolock)
                                 INNER JOIN ContractTerritory B ON A.DAT_ID = B.Contract_ID
                                 INNER JOIN (SELECT distinct CA_ID,CQ_ID,StartDate,EndDate FROM V_ProductClassificationStructure) E ON E.CA_ID=A.DAT_PMA_ID
                                 ) TreeHos 
						ON TreeHos.DAT_DCL_ID = AOP.AOPDH_Contract_ID
						AND TreeHos.HOS_ID = aop.AOPDH_Hospital_ID  AND TreeHos.CQ_ID=AOP.AOPDH_PCT_ID
               LEFT JOIN AOPRemark REK(nolock)
                  ON     REK.Rmk_ContractID = AOP.AOPDH_Contract_ID
                     AND REK.Rmk_Hos_ID = AOP.AOPDH_Hospital_ID
                     AND REK.Rmk_Rv1 =
                            CONVERT (NVARCHAR (100), AOP.AOPDH_PCT_ID)) tab










GO


