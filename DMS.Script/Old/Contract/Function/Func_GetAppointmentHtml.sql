DROP FUNCTION [Contract].[Func_GetAppointmentHtml]
GO

CREATE FUNCTION [Contract].[Func_GetAppointmentHtml]
(
  @ContractId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @Rtn NVARCHAR(MAX);
  
  --Main
  DECLARE @DealerType NVARCHAR(200) ;
  
  SELECT @DealerType = A.DealerType
  FROM   [Contract].AppointmentMain A
  WHERE  A.ContractId = @ContractId;
  
  IF @DealerType = 'Trade'
  BEGIN
      SET @Rtn = [Contract].Func_GetAppointmentTradeHtml(@ContractId);
  END
  ELSE 
  IF @DealerType = 'T2'
  BEGIN
      SET @Rtn = [Contract].Func_GetAppointmentT2Html(@ContractId);
  END
  ELSE 
  IF @DealerType = 'T1'
     OR @DealerType = 'LP'
     OR @DealerType = 'RLD'
  BEGIN
      SET @Rtn = [Contract].Func_GetAppointmentLpHtml(@ContractId);
  END
  ELSE
  BEGIN
      SET @Rtn = '';
  END
  
  RETURN ISNULL(@Rtn, '')
END

GO


