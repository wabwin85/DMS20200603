DROP FUNCTION [dbo].[GC_Fn_CFN_CheckBSCDealerCanOrder]
GO

CREATE FUNCTION [dbo].[GC_Fn_CFN_CheckBSCDealerCanOrder] (
   @DealerId    UNIQUEIDENTIFIER,
   @CfnId       UNIQUEIDENTIFIER,   
   @PriceType   NVARCHAR (100)
   )
   RETURNS TINYINT
AS
   BEGIN
      DECLARE @RtnVal   TINYINT
      IF EXISTS(select 1 from dealermaster where DMA_DealerType in ('LP','T1') and DMA_ID=@DealerId)
        BEGIN
          SELECT  @RtnVal = CASE WHEN dbo.fn_GetPriceByDealerForBSCPO (@DealerId, C.CFN_ID, @PriceType) IS NULL
                              THEN 0 ELSE case when CFN_Property2 = 1 then 1 else Convert(TINYINT,CFN_Property4) end 
                              END
                      FROM CFN AS C
                     WHERE C.CFN_Property4 != '-1'
                       AND C.CFN_ID = @CfnId
        END
      ELSE
        BEGIN
          SELECT  @RtnVal = CASE WHEN dbo.fn_GetPriceByDealerForBSCPO (@DealerId, C.CFN_ID, @PriceType) IS NULL
                              THEN 0 ELSE 1 END
                      FROM CFN AS C
                     WHERE C.CFN_Property4 != '-1'
                       AND C.CFN_ID = @CfnId
        
        END
                   
      IF @RtnVal IS NULL
         SET @RtnVal = 0

      RETURN @RtnVal
   END
GO


