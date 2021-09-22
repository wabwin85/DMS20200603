
DROP FUNCTION [Contract].[Func_GetRenewalHtml]
GO

CREATE FUNCTION [Contract].[Func_GetRenewalHtml]
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
  FROM   [Contract].RenewalMain A
  WHERE  A.ContractId = @ContractId;
  
  IF @DealerType = 'T2'
  BEGIN
      SET @Rtn = [Contract].Func_GetRenewalT2Html(@ContractId);
  END
  ELSE 
  IF @DealerType = 'T1'
     OR @DealerType = 'LP'
     OR @DealerType = 'RLD'
  BEGIN
      SET @Rtn = [Contract].Func_GetRenewalLpHtml(@ContractId);
  END
  ELSE
  BEGIN
      SET @Rtn = '';
  END
  
  RETURN ISNULL(@Rtn, '')
END

GO


