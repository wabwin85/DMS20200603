DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor]
GO

CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor](
	@PolicyFactId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @FactId INT;
	
	SELECT @FactId = FactId from Promotion.PRO_POLICY_FACTOR WHERE PolicyFactorId = @PolicyFactId
	
	--没有描述内容:产品线商业采购达标率\产品线医院植入达标率\产品线商业采购总金额\产品线医院植入总金额 
	IF @FactId IN (4,5,10,11) 
		SET @SQL = ''
		
	IF @FactId = 1	--产品
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_Product(@PolicyFactId, null)
		
	IF @FactId = 2	--医院
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_Hospital(@PolicyFactId, null)
	
	IF @FactId = 3	--经销商
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_Dealer(@PolicyFactId)
		
	IF @FactId in (6,14)	--指定产品商业采购达标率
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdPurchaseRate(@PolicyFactId)
		
	IF @FactId in (7,15)	--指定产品医院植入达标率
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdSalesRate(@PolicyFactId)
			
	IF @FactId = 8	--指定产品医院植入量
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdSalesQuantity(@PolicyFactId)
		
	IF @FactId = 9	--指定产品商业采购量
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdPurchaseQuantity(@PolicyFactId)
			
	IF @FactId = 12	--指定产品医院植入金额
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdSalesAmount(@PolicyFactId)	
		
	IF @FactId = 13	--指定产品医院植入金额
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdPurchaseAmount(@PolicyFactId)	
				
	
	RETURN @SQL
END


GO


