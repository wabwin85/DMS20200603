
DROP FUNCTION [dbo].[GC_Fn_CFN_CheckDealerCanOrder]
GO

CREATE FUNCTION [dbo].[GC_Fn_CFN_CheckDealerCanOrder]
(
	@DealerId UNIQUEIDENTIFIER,
	@CfnId UNIQUEIDENTIFIER
)
RETURNS TINYINT
AS

BEGIN
	DECLARE @RtnVal TINYINT
	
	IF EXISTS (SELECT 1 FROM CFN C INNER JOIN CFNPrice P ON C.CFN_ID = P.CFNP_CFN_ID
				WHERE C.CFN_ID = @CfnId AND C.CFN_DeletedFlag = 0
				AND (P.CFNP_PriceType = 'Base' OR (P.CFNP_PriceType = 'Dealer' AND P.CFNP_Group_ID = @DealerId)) 
				AND P.CFNP_DeletedFlag = 0
				AND P.CFNP_CanOrder = 1 AND P.CFNP_Price > 0)
		SET @RtnVal = 1
	ELSE
		SET @RtnVal = 0
	
	RETURN @RtnVal
END
GO


