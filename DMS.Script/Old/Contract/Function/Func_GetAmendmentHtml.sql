DROP FUNCTION [Contract].[Func_GetAmendmentHtml]
GO



CREATE FUNCTION [Contract].[Func_GetAmendmentHtml]
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
  FROM   [Contract].AmendmentMain A
  WHERE  A.ContractId = @ContractId;
  
  IF @DealerType = 'T2'
  BEGIN
      SET @Rtn = [Contract].Func_GetAmendmentT2Html(@ContractId);
  END
  ELSE 
  IF @DealerType = 'T1'
     OR @DealerType = 'LP'
     OR @DealerType = 'RLD'
  BEGIN
      SET @Rtn = [Contract].Func_GetAmendmentLpHtml(@ContractId);
  END
  ELSE
  BEGIN
      SET @Rtn = '';
  END
  
  RETURN ISNULL(@Rtn, '')
END

GO


