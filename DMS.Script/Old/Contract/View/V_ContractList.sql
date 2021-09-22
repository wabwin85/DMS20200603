DROP VIEW [Contract].[V_ContractList]
GO


CREATE VIEW [Contract].[V_ContractList]
AS

SELECT A.ContractId ContractId,
       'Appointment' ContractType,
       A.ContractNo ContractNo,
       A.DepId DepId,
       C.DepFullName DepName,
       A.SUBDEPID,
       D.CC_NameCN SubDepName,
       A.DealerType,
       F.VALUE1 DealerTypeName,
       B.CompanyName,
       A.CreateUser,
       E.IDENTITY_NAME ApplyUser,
       CONVERT(NVARCHAR(19), A.CreateDate, 121) ApplyDate,
       A.ContractStatus,
       A.CurrentApprove,
       A.NextApprove
FROM   [Contract].AppointmentMain A
       INNER JOIN [Contract].AppointmentCandidate B
            ON  A.ContractId = B.ContractId
       LEFT JOIN interface.MDM_Department C
            ON  A.DepId = C.DepID
       LEFT JOIN interface.ClassificationContract D
            ON  A.SUBDEPID = D.CC_Code
       LEFT JOIN Lafite_IDENTITY E
            ON  A.CreateUser = E.Id
       LEFT JOIN Lafite_DICT F
            ON  A.DealerType = F.DICT_KEY
            AND F.DICT_TYPE = 'CONST_CONTRACT_DealerType'
UNION
SELECT A.ContractId ContractId,
       'Amendment' ContractType,
       A.ContractNo ContractNo,
       A.DepId DepId,
       C.DepFullName DepName,
       A.SUBDEPID,
       D.CC_NameCN SubDepName,
       A.DealerType,
       F.VALUE1 DealerTypeName,
       B.DMA_ChineseName CompanyName,
       A.CreateUser,
       E.IDENTITY_NAME ApplyUser,
       CONVERT(NVARCHAR(19), A.CreateDate, 121) ApplyDate,
       A.ContractStatus,
       A.CurrentApprove,
       A.NextApprove
FROM   [Contract].AmendmentMain A
       LEFT JOIN DealerMaster B
            ON  A.DealerName = B.DMA_SAP_Code
       LEFT JOIN interface.MDM_Department C
            ON  A.DepId = C.DepID
       LEFT JOIN interface.ClassificationContract D
            ON  A.SUBDEPID = D.CC_Code
       LEFT JOIN Lafite_IDENTITY E
            ON  A.CreateUser = E.Id
       LEFT JOIN Lafite_DICT F
            ON  A.DealerType = F.DICT_KEY
            AND F.DICT_TYPE = 'CONST_CONTRACT_DealerType'
UNION
SELECT A.ContractId ContractId,
       'Renewal' ContractType,
       A.ContractNo ContractNo,
       A.DepId DepId,
       C.DepFullName DepName,
       A.SUBDEPID,
       D.CC_NameCN SubDepName,
       A.DealerType,
       F.VALUE1 DealerTypeName,
       B.DMA_ChineseName CompanyName,
       A.CreateUser,
       E.IDENTITY_NAME ApplyUser,
       CONVERT(NVARCHAR(19), A.CreateDate, 121) ApplyDate,
       A.ContractStatus,
       A.CurrentApprove,
       A.NextApprove
FROM   [Contract].RenewalMain A
       LEFT JOIN DealerMaster B
            ON  A.DealerName = B.DMA_SAP_Code
       LEFT JOIN interface.MDM_Department C
            ON  A.DepId = C.DepID
       LEFT JOIN interface.ClassificationContract D
            ON  A.SUBDEPID = D.CC_Code
       LEFT JOIN Lafite_IDENTITY E
            ON  A.CreateUser = E.Id
       LEFT JOIN Lafite_DICT F
            ON  A.DealerType = F.DICT_KEY
            AND F.DICT_TYPE = 'CONST_CONTRACT_DealerType'
UNION
SELECT A.ContractId ContractId,
       'Termination' ContractType,
       A.ContractNo ContractNo,
       A.DepId DepId,
       C.DepFullName DepName,
       A.SUBDEPID,
       D.CC_NameCN SubDepName,
       A.DealerType,
       F.VALUE1 DealerTypeName,
       B.DMA_ChineseName CompanyName,
       A.CreateUser,
       E.IDENTITY_NAME ApplyUser,
       CONVERT(NVARCHAR(19), A.CreateDate, 121) ApplyDate,
       A.ContractStatus,
       A.CurrentApprove,
       A.NextApprove
FROM   [Contract].TerminationMain A
       LEFT JOIN DealerMaster B
            ON  A.DealerName = B.DMA_SAP_Code
       LEFT JOIN interface.MDM_Department C
            ON  A.DepId = C.DepID
       LEFT JOIN interface.ClassificationContract D
            ON  A.SUBDEPID = D.CC_Code
       LEFT JOIN Lafite_IDENTITY E
            ON  A.CreateUser = E.Id
       LEFT JOIN Lafite_DICT F
            ON  A.DealerType = F.DICT_KEY
            AND F.DICT_TYPE = 'CONST_CONTRACT_DealerType'

GO


