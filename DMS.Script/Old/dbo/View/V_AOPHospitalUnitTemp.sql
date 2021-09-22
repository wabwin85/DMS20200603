DROP VIEW [dbo].[V_AOPHospitalUnitTemp]
GO








CREATE VIEW [dbo].[V_AOPHospitalUnitTemp]
AS
 SELECT AOP.AOPICH_Contract_ID as ContractId,
      AOP.AOPICH_DMA_ID as DmaId,
      AOP.AOPICH_ProductLine_ID as ProductLineId,
      AOP.AOPICH_PCT_ID as ProductId,
      pcf.CQ_NameCN as ProductName,
      AOP.AOPICH_Hospital_ID as HospitalId,
      TreeHos.Territory_Type as OperType,
      Hospital.HOS_HospitalName as HospitalName,
      AOP.AOPICH_Year as Year,
      --<!--当前合同指标-->
      AOP.AOPICH_Unit_1 as Unit1,
      AOP.AOPICH_Unit_2 as Unit2,
      AOP.AOPICH_Unit_3 as Unit3,
      AOP.AOPICH_Unit_4 as Unit4,
      AOP.AOPICH_Unit_5 as Unit5,
      AOP.AOPICH_Unit_6 as Unit6,
      AOP.AOPICH_Unit_7 as Unit7,
      AOP.AOPICH_Unit_8 as Unit8,
      AOP.AOPICH_Unit_9 as Unit9,
      AOP.AOPICH_Unit_10 as Unit10,
      AOP.AOPICH_Unit_11 as Unit11,
      AOP.AOPICH_Unit_12 as Unit12,
      AOP.AOPICH_Unit_Y as UnitY,
      (AOP.AOPICH_Unit_1 +AOP.AOPICH_Unit_2+AOP.AOPICH_Unit_3) Q1,
      (AOP.AOPICH_Unit_4 +AOP.AOPICH_Unit_5+AOP.AOPICH_Unit_6) Q2,
      (AOP.AOPICH_Unit_7 +AOP.AOPICH_Unit_8+AOP.AOPICH_Unit_9) Q3,
      (AOP.AOPICH_Unit_10 +AOP.AOPICH_Unit_11+AOP.AOPICH_Unit_12) Q4,
      --<!--标准指标-->
      ISNULL(rec.AOPICHR_January,0) as RefUnit1 ,
      ISNULL(rec.AOPICHR_February,0) as RefUnit2,
      ISNULL(rec.AOPICHR_March,0) as RefUnit3,
      ISNULL(rec.AOPICHR_April,0) as RefUnit4 ,
      ISNULL(rec.AOPICHR_May,0) as RefUnit5,
      ISNULL(rec.AOPICHR_June,0) as RefUnit6,
      ISNULL(rec.AOPICHR_July,0) as RefUnit7 ,
      ISNULL(rec.AOPICHR_August,0) as RefUnit8,
      ISNULL(rec.AOPICHR_September,0) as RefUnit9,
      ISNULL(rec.AOPICHR_October,0) as RefUnit10 ,
      ISNULL(rec.AOPICHR_November,0) as RefUnit11,
      ISNULL(rec.AOPICHR_December,0) as RefUnit12,
      (ISNULL(rec.AOPICHR_January,0)+ISNULL(rec.AOPICHR_February,0) + ISNULL(rec.AOPICHR_March,0)) RefQ1,
      (ISNULL(rec.AOPICHR_April,0) +ISNULL(rec.AOPICHR_May,0) +ISNULL(rec.AOPICHR_June,0)) RefQ2,
      (ISNULL(rec.AOPICHR_July,0)+ISNULL(rec.AOPICHR_August,0)+ISNULL(rec.AOPICHR_September,0)) RefQ3,
      (ISNULL(rec.AOPICHR_October,0)+ISNULL(rec.AOPICHR_November,0) +ISNULL(rec.AOPICHR_December,0)) RefQ4,
      (ISNULL(rec.AOPICHR_January,0)+ISNULL(rec.AOPICHR_February,0) + ISNULL(rec.AOPICHR_March,0)
      +ISNULL(rec.AOPICHR_April,0) +ISNULL(rec.AOPICHR_May,0) +ISNULL(rec.AOPICHR_June,0)
      +ISNULL(rec.AOPICHR_July,0)+ISNULL(rec.AOPICHR_August,0)+ISNULL(rec.AOPICHR_September,0)
      +ISNULL(rec.AOPICHR_October,0)+ISNULL(rec.AOPICHR_November,0) +ISNULL(rec.AOPICHR_December,0)) RefYear
      --<!--实际指标-->
      ,ISNULL(Formal.AOPICH_Unit_1,0) FromalUnit1
      ,ISNULL(Formal.AOPICH_Unit_2,0) FromalUnit2
      ,ISNULL(Formal.AOPICH_Unit_3,0) FromalUnit3
      ,ISNULL(Formal.AOPICH_Unit_4,0) FromalUnit4
      ,ISNULL(Formal.AOPICH_Unit_5,0) FromalUnit5
      ,ISNULL(Formal.AOPICH_Unit_6,0) FromalUnit6
      ,ISNULL(Formal.AOPICH_Unit_7,0) FromalUnit7
      ,ISNULL(Formal.AOPICH_Unit_8,0) FromalUnit8
      ,ISNULL(Formal.AOPICH_Unit_9,0) FromalUnit9
      ,ISNULL(Formal.AOPICH_Unit_10,0) FromalUnit10
      ,ISNULL(Formal.AOPICH_Unit_11,0) FromalUnit11
      ,ISNULL(Formal.AOPICH_Unit_12,0) FromalUnit12
      ,(ISNULL(Formal.AOPICH_Unit_1,0)+ISNULL(Formal.AOPICH_Unit_2,0) +ISNULL(Formal.AOPICH_Unit_3,0)) FromalQ1
      ,(ISNULL(Formal.AOPICH_Unit_4,0)+ISNULL(Formal.AOPICH_Unit_5,0) +ISNULL(Formal.AOPICH_Unit_6,0)) FromalQ2
      ,(ISNULL(Formal.AOPICH_Unit_7,0)+ISNULL(Formal.AOPICH_Unit_8,0) +ISNULL(Formal.AOPICH_Unit_9,0)) FromalQ3
      ,(ISNULL(Formal.AOPICH_Unit_10,0)+ISNULL(Formal.AOPICH_Unit_11,0) +ISNULL(Formal.AOPICH_Unit_12,0)) FromalQ4
      ,ISNULL(Formal.AOPICH_Unit_Y,0) FromalYear
      ,REK.Rmk_Body RmkBody
      FROM V_AOPICDealerHospital_Temp AOP(nolock)
      left join AOPICDealerHospitalReference rec(nolock) on AOP.AOPICH_ProductLine_ID=rec.AOPICHR_ProductLine_ID
      and AOP.AOPICH_Hospital_ID=rec.AOPICHR_Hospital_ID and AOP.AOPICH_Year=rec.AOPICHR_Year and AOP.AOPICH_PCT_ID=rec.AOPICHR_PCT_ID
      left join V_AOPICDealerHospital Formal(nolock) on Formal.AOPICH_DMA_ID=AOP.AOPICH_DMA_ID
      and Formal.AOPICH_Hospital_ID=AOP.AOPICH_Hospital_ID
      and Formal.AOPICH_ProductLine_ID=AOP.AOPICH_ProductLine_ID
      and Formal.AOPICH_PCT_ID=AOP.AOPICH_PCT_ID
      and Formal.AOPICH_Year=AOP.AOPICH_Year
      inner join Hospital(nolock) on Hospital.HOS_ID=AOP.AOPICH_Hospital_ID
      inner join interface.ClassificationQuota(nolock)  pcf on pcf.CQ_ID=aop.AOPICH_PCT_ID
      LEFT JOIN (SELECT DISTINCT A.DAT_DCL_ID,A.DAT_DMA_ID,A.DAT_DMA_ID_Actual,A.DAT_ProductLine_BUM_ID,B.HOS_ID,B.HOS_Depart,B.HOS_DepartType,B.HOS_DepartRemark,B.Territory_Type 
      FROM DealerAuthorizationTableTemp A(nolock)
      INNER JOIN ContractTerritory B(nolock) ON A.DAT_ID=B.Contract_ID) TreeHos on TreeHos.DAT_DCL_ID=AOP.AOPICH_Contract_ID and TreeHos.HOS_ID=aop.AOPICH_Hospital_ID
      LEFT JOIN AOPRemark REK(nolock) ON REK.Rmk_ContractID=AOP.AOPICH_Contract_ID AND REK.Rmk_Hos_ID=AOP.AOPICH_Hospital_ID AND REK.Rmk_Rv1=CONVERT(NVARCHAR(100),AOP.AOPICH_PCT_ID)
      








GO


