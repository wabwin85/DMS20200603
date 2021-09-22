DROP VIEW [interface].[V_I_EW_GetContractPending]
GO

CREATE VIEW [interface].[V_I_EW_GetContractPending]
AS
   SELECT TAB.*, b.DMA_SAP_Code AS SAP_Code
     FROM (SELECT A.ContractId,
                  A.ContractType,
                  A.BeginDate,
                  CASE
                     WHEN A.ContractType = 'Appointment'
                     THEN
                        (SELECT CAP_DMA_ID
                           FROM ContractAppointment CA
                          WHERE CA.CAP_ID = A.ContractId)
                     WHEN A.ContractType = 'Amendment'
                     THEN
                        (SELECT CAM_DMA_ID
                           FROM ContractAmendment CM
                          WHERE CM.CAM_ID = A.ContractId)
                     WHEN A.ContractType = 'Renewal'
                     THEN
                        (SELECT CRE_DMA_ID
                           FROM ContractRenewal CR
                          WHERE CR.CRE_ID = A.ContractId)
                     WHEN A.ContractType = 'Termination'
                     THEN
                        (SELECT CTE_DMA_ID
                           FROM ContractTermination CT
                          WHERE CT.CTE_ID = A.ContractId)
                  END
                     AS DMA_ID,
                  CASE
                     WHEN A.ContractType = 'Appointment'
                     THEN
                        (SELECT CAP_SubDepID
                           FROM ContractAppointment CA
                          WHERE CA.CAP_ID = A.ContractId)
                     WHEN A.ContractType = 'Amendment'
                     THEN
                        (SELECT CAM_SubDepID
                           FROM ContractAmendment CM
                          WHERE CM.CAM_ID = A.ContractId)
                     WHEN A.ContractType = 'Renewal'
                     THEN
                        (SELECT CRE_SubDepID
                           FROM ContractRenewal CR
                          WHERE CR.CRE_ID = A.ContractId)
                     WHEN A.ContractType = 'Termination'
                     THEN
                        (SELECT CTE_SubDepID
                           FROM ContractTermination CT
                          WHERE CT.CTE_ID = A.ContractId)
                  END
                     AS SubDepID,
                  CASE
                     WHEN A.ContractType = 'Appointment'
                     THEN
                        (SELECT ISNULL (CA.CAP_MarketType, 0)
                           FROM ContractAppointment CA
                          WHERE CA.CAP_ID = A.ContractId)
                     WHEN A.ContractType = 'Amendment'
                     THEN
                        (SELECT ISNULL (CAM_MarketType, 0)
                           FROM ContractAmendment CM
                          WHERE CM.CAM_ID = A.ContractId)
                     WHEN A.ContractType = 'Renewal'
                     THEN
                        (SELECT ISNULL (CRE_MarketType, 0)
                           FROM ContractRenewal CR
                          WHERE CR.CRE_ID = A.ContractId)
                     WHEN A.ContractType = 'Termination'
                     THEN
                        (SELECT ISNULL (CTE_MarketType, 0)
                           FROM ContractTermination CT
                          WHERE CT.CTE_ID = A.ContractId)
                  END
                     AS MarketType
             FROM interface.T_I_EW_ContractState A(nolock)
            WHERE A.SynState IN (0, 1) AND A.ContractType = 'Renewal') TAB
          INNER JOIN DealerMaster b ON TAB.DMA_ID = b.DMA_ID
GO


