DROP FUNCTION [Promotion].[func_Pro_Cal_getRuleFactorReal]
GO

CREATE FUNCTION [Promotion].[func_Pro_Cal_getRuleFactorReal](
	@RuleFactorId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @iReturn NVARCHAR(MAX)
	 
	DECLARE @YTDOption NVARCHAR(50);
	DECLARE @FactId INT;
	  
	SET @iReturn = ''
	
	SELECT  
		@FactId = B.FactId,
		@YTDOption = ISNULL(C.YTDOption,'N')
	FROM PROMOTION.PRO_POLICY_RULE_FACTOR A,PROMOTION.PRO_POLICY_FACTOR B,PROMOTION.PRO_POLICY C
	WHERE A.RuleFactorId = @RuleFactorId AND A.PolicyFactorId = B.PolicyFactorId AND B.PolicyId = C.PolicyId
	
	--1.1如果有YTDOPTION且是指定产品达标类因素，就直接返回''
	IF @YTDOption <>'N' AND @FactId IN (6,7,14,15)
	BEGIN
		SET @iReturn = ''
	END
	ELSE
	BEGIN
		SET @iReturn = Promotion.func_Pro_Cal_getRuleFactor(@RuleFactorId)
	END
	
	RETURN @iReturn
	
	
END


GO


