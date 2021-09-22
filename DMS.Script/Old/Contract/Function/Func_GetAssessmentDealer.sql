DROP FUNCTION [Contract].[Func_GetAssessmentDealer]
GO

CREATE FUNCTION [Contract].[Func_GetAssessmentDealer]
(
	@SubBuCode   NVARCHAR(50),
	@DealerType  NVARCHAR(10)
)
RETURNS @temp TABLE 
        (SapCode NVARCHAR(36) NULL, DealerName NVARCHAR(200) NULL)
WITH 

	EXECUTE AS CALLER
AS
BEGIN
	INSERT INTO @temp
	  (SapCode, DealerName)
	SELECT B.DMA_SAP_Code,
	       B.DMA_SAP_Code + ' - ' + B.DMA_ChineseName
	FROM   V_DealerContractMaster A
	       INNER JOIN DealerMaster B
	            ON  A.DMA_ID = B.DMA_ID
	       INNER JOIN INTERFACE.ClassificationContract C
	            ON  A.CC_ID = C.CC_ID
	WHERE  B.DMA_DealerType = @DealerType
	       AND C.CC_Code = @SubBuCode;
	
	RETURN
END

GO


