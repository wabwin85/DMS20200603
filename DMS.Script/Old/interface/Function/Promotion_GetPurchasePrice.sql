DROP FUNCTION [interface].[Promotion_GetPurchasePrice] 
GO











CREATE FUNCTION [interface].[Promotion_GetPurchasePrice] (
   @DealerId     UNIQUEIDENTIFIER,
   @UPN       nvarchar(100)
   ,@PriceType nvarchar(50))

    RETURNS DECIMAL (18, 6)
AS
   BEGIN
      DECLARE @rtn   DECIMAL (18, 6)
      Declare @DealerType nvarchar(50),@CFN_ID uniqueidentifier

	    select  @CFN_ID=CFN_ID from CFN where CFN_CustomerFaceNbr=@UPN
	    IF @PriceType='Hospital' 
	    set @PriceType='Dealer' 
	    else set @PriceType='DealerConsignment'
	    
		select top 1 @rtn=CFNP_Price from CFNPrice
		where CFNP_CFN_ID=@CFN_ID and CFNP_PriceType=@PriceType
		and CFNP_DeletedFlag = 0  and CFNP_Group_ID = @DealerId
	
             
      RETURN @rtn;
   END








GO


