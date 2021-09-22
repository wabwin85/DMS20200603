
DROP VIEW [interface].[V_I_EW_ScoreCardApplication]
GO


CREATE VIEW [interface].[V_I_EW_ScoreCardApplication]
AS
select DMA_SAP_Code as SCA_DealerCode,
		DMA_ChineseName as SCA_DealerName,
		ESCH_Year as SCA_Year,
		ESCH_Quarter as SCA_Quarter,
		DivisionName as SCA_BUCode,
		DivisionCode as SCA_BU,
		ESCH_No as SCA_FormNo,
		ESCH_ID as DMSFormId
       from EndoScoreCardHeader,DealerMaster,V_DivisionProductLineRelation
       where ESCH_DMA_ID = DMA_ID
       and ESCH_BUM_ID = ProductLineID
       AND ESCH_Status in ('Submit','Cancel')
       
       

GO


