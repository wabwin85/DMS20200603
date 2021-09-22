DROP FUNCTION [dbo].[fn_GetPriceByDealerForBSCPO]
GO

CREATE FUNCTION [dbo].[fn_GetPriceByDealerForBSCPO] (
   @DealerId     UNIQUEIDENTIFIER,
   @CfnId        UNIQUEIDENTIFIER,
   @PriceType    NVARCHAR (50))
   RETURNS DECIMAL (18, 6)
AS
   BEGIN
      DECLARE @RtnVal   DECIMAL (18, 6)

      SELECT @RtnVal = CFNP_Price
        FROM dbo.CFNPrice
       WHERE     CFNP_CFN_ID = @CfnId
             AND CFNP_PriceType = @PriceType
             AND CFNP_Group_ID = @DealerId
             AND CFNP_DeletedFlag = 0
             --AND CFNP_CanOrder = 1
             AND CFNP_Price > 0
      RETURN @RtnVal;
   END
GO


