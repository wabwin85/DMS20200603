DROP VIEW [interface].[V_I_QV_AOPHospitalProductReference]
GO






CREATE VIEW [interface].[V_I_QV_AOPHospitalProductReference]
AS
SELECT [AOPICHR_ID] AS Id
      ,[AOPICHR_ProductLine_ID] AS ProductLineId
      ,DPR.ProductLineName AS ProductLineName
      ,DPR.DivisionCode AS DivisionCode
      ,DPR.DivisionName AS DivisionName
      ,[AOPICHR_PCT_ID] AS PCTId
      ,PC.CQ_Code		AS PCTCode
      ,PC.CQ_NameCN AS PCTName
      ,[AOPICHR_Year] AS [Year]
      ,[AOPICHR_Hospital_ID] AS HospitalId
      ,HOS.HOS_Key_Account AS HospitalCode
      ,HOS.HOS_HospitalName
      ,'Unit' AOPType
      ,[AOPICHR_January] AS Month1
      ,[AOPICHR_February] AS Month2
      ,[AOPICHR_March] AS Month3
      ,[AOPICHR_April] AS Month4
      ,[AOPICHR_May] AS Month5
      ,[AOPICHR_June] AS Month6
      ,[AOPICHR_July] AS Month7
      ,[AOPICHR_August] AS Month8
      ,[AOPICHR_September] AS Month9
      ,[AOPICHR_October] AS Month10
      ,[AOPICHR_November] AS Month11
      ,[AOPICHR_December] AS Month12
  FROM [dbo].[AOPICDealerHospitalReference] RE
  LEFT JOIN (select distinct CQ_Code,CQ_NameCN,CQ_ID from interface.ClassificationQuotaMain) PC ON RE.AOPICHR_PCT_ID=PC.CQ_ID
  LEFT JOIN V_DivisionProductLineRelation DPR ON DPR.ProductLineID=RE.AOPICHR_ProductLine_ID AND DPR.IsEmerging='0'
  LEFT JOIN Hospital HOS ON HOS.HOS_ID=RE.AOPICHR_Hospital_ID AND HOS.HOS_ActiveFlag='1'
  UNION
  SELECT [AOPHR_ID]
      ,[AOPHR_ProductLine_BUM_ID]
      ,DPR.ProductLineName AS ProductLineName
      ,DPR.DivisionCode AS DivisionCode
      ,DPR.DivisionName AS DivisionName
      ,AOPHR_PCT_ID AS PCTId
      ,CQ.CQ_Code 
      ,CQ.CQ_NameCN AS PCTName
      ,[AOPHR_Year]
      ,[AOPHR_Hospital_ID]
      ,HOS.HOS_Key_Account AS HospitalCode
      ,HOS.HOS_HospitalName
      ,'Amount' AOPType
      ,[AOPHR_January]
      ,[AOPHR_February]
      ,[AOPHR_March]
      ,[AOPHR_April]
      ,[AOPHR_May]
      ,[AOPHR_June]
      ,[AOPHR_July]
      ,[AOPHR_August]
      ,[AOPHR_September]
      ,[AOPHR_October]
      ,[AOPHR_November]
      ,[AOPHR_December]
  FROM [dbo].[AOPHospitalReference] RE
  LEFT JOIN (select distinct CQ_Code,CQ_NameCN,CQ_ID from interface.ClassificationQuotaMain)  CQ on CQ.CQ_ID=RE.AOPHR_PCT_ID
  LEFT JOIN V_DivisionProductLineRelation DPR ON DPR.ProductLineID=RE.AOPHR_ProductLine_BUM_ID AND DPR.IsEmerging='0'
  LEFT JOIN Hospital HOS ON HOS.HOS_ID=RE.AOPHR_Hospital_ID AND HOS.HOS_ActiveFlag='1'






GO


