DROP PROCEDURE [Contract].[Proc_GetCurrentInfo]
GO


CREATE PROCEDURE [Contract].[Proc_GetCurrentInfo]
(@ContractId UNIQUEIDENTIFIER, @ContractType NVARCHAR(100))
AS
BEGIN
  IF @ContractType = 'Appointment'
  BEGIN
      SELECT B.CompanyName,
             C.Payment
      FROM   [Contract].AppointmentMain A,
             [Contract].AppointmentCandidate B,
             [Contract].AppointmentProposals C
      WHERE  A.ContractId = B.ContractId
             AND A.ContractId = C.ContractId
             AND A.ContractId = @ContractId;
  END
  ELSE 
  IF @ContractType = 'Amendment'
  BEGIN
      SELECT C.DMA_ChineseName CompanyName,
             B.Payment
      FROM   [Contract].AmendmentMain A,
             [Contract].AmendmentProposals B,
             DealerMaster C
      WHERE  A.ContractId = B.ContractId
             AND A.CompanyID = C.DMA_ID
             AND A.ContractId = @ContractId;
  END
  ELSE 
  IF @ContractType = 'Renewal'
  BEGIN
      SELECT C.DMA_ChineseName CompanyName,
             B.Payment
      FROM   [Contract].RenewalMain A,
             [Contract].RenewalProposals B,
             DealerMaster C
      WHERE  A.ContractId = B.ContractId
             AND A.CompanyID = C.DMA_ID
             AND A.ContractId = @ContractId;
  END
  ELSE 
  IF @ContractType = 'Termination'
  BEGIN
      SELECT '' CompanyName,
             '' Payment
  END
END

GO


