DROP VIEW [interface].[V_I_EW_QABSCDealerComplain]
GO

CREATE VIEW [interface].[V_I_EW_QABSCDealerComplain]
AS
   SELECT DC_ComplainNbr AS DMSBSCCode,         
          DC_Status,         
          EID,
          REQUESTDATE,
          INITIALNAME,
          INITIALPHONE,
          INITIALJOB,
          INITIALEMAIL,
          PHYSICIAN,
          PHYSICIANPHONE,
          FIRSTBSCNAME,
          Convert(datetime,NULLIF(BSCAWAREDATE,N'')) AS BSCAWAREDATE,
          Convert(datetime,NULLIF(NOTIFYDATE,N'')) AS NOTIFYDATE,
          CONTACTMETHOD,
          COMPLAINTSOURCE,
          FEEDBACKREQUESTED,
          FEEDBACKSENDTO,
          COMPLAINTID,
          REFERBOX,
          PRODUCTTYPE,
          RETURNTYPE,
          case when DM.DMA_DealerType='T1' then '2' else '1' end AS ISPLATFORM,
          BSCSOLDTOACCOUNT,
          Case when DM.DMA_DealerType='T2' then Parent_SAP_Code else DMA_SAP_Code end AS BSCSOLDTONAME, --如果是二级经销商，则提供上级经销商SAPCode，如果是平台及一级则提供当前SAPCode
          BSCSOLDTOCITY,
          Case when DM.DMA_DealerType='T2' then DMA_SAP_Code else '' end AS SUBSOLDTONAME, --如果是二级经销商，则提供当前SAPCode，其他则为空
          SUBSOLDTOCITY,  
          DISTRIBUTORCUSTOMER,
          DISTRIBUTORCITY,
          UPN,
          [DESCRIPTION],
          LOT,
          (select REV1 from Lafite_ATTRIBUTE where ATTRIBUTE_TYPE='BU' AND ATTRIBUTE_NAME = BU) AS BU,
          SINGLEUSE,
          RESTERILIZED,
          PREPROCESSOR,
          USEDEXPIRY,
          UPNEXPECTED,
          UPNQUANTITY,
          NORETURN,
          NORETURNREASON,
          Convert(datetime,NULLIF(INITIALPDATE,N'')) AS INITIALPDATE,
          PNAME,
          INDICATION,
          Convert(datetime,NULLIF(IMPLANTEDDATE,N'')) AS IMPLANTEDDATE,
          Convert(datetime,NULLIF(EXPLANTEDDATE,N'')) AS EXPLANTEDDATE,
          POUTCOME,
          IVUS,
          GENERATOR,
          GENERATORTYPE,
          GENERATORSET,
          PCONDITION,
          PCONDITIONOTHER,
          Convert(datetime,NULLIF(EDATE,N'')) AS EDATE,
          WHEREOCCUR,
          WHENNOTICED,
          EDESCRIPTION,
          WITHLABELEDUSE,
          NOLABELEDUSE,
          EVENTRESOLVED,
          BSCSALESNAME,
          BSCSALESPHONE,
          RETURNNUM,
WHM_ID,
DM.DMA_ID
     FROM 
     DealerComplain(nolock) inner join
      (select t1.DMA_ID,t1.DMA_SAP_Code,t1.DMA_DealerType,t2.DMA_SAP_Code As Parent_SAP_Code from dealermaster t1(nolock),dealermaster t2(nolock) where t1.DMA_Parent_DMA_ID = t2.DMA_ID) AS DM on (DealerComplain.DC_CorpId = DM.DMA_ID)
      
    WHERE DC_Status = 'Submit'
GO


