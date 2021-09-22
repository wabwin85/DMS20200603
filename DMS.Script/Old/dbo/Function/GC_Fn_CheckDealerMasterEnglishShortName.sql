DROP FUNCTION [dbo].[GC_Fn_CheckDealerMasterEnglishShortName]
GO

CREATE FUNCTION [dbo].[GC_Fn_CheckDealerMasterEnglishShortName]()
RETURNS BIT
AS 
BEGIN
    IF (EXISTS(select DMA_EnglishShortName from DealerMaster where DMA_EnglishShortName is not null and DMA_EnglishShortName <>'' group by  DMA_EnglishShortName having count(*)>1))
        RETURN 0    
    RETURN 1
END
GO


