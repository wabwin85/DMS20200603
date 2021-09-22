DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Fact] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Fact] 
	@PolicyFactorId Int	--政策因素编号
AS
BEGIN  
	DECLARE @FactId INT
	DECLARE @CalModule NVARCHAR(20)
	
	SELECT @FactId = FactId, 
		@CalModule = B.CalModule
	FROM Promotion.PRO_POLICY_FACTOR A,Promotion.PRO_POLICY B 
	WHERE A.PolicyFactorId = @PolicyFactorId
	AND A.PolicyId = B.PolicyId
	
	PRINT 'PROMOTION.Proc_Pro_Cal_Fact PolicyFactorId='+CONVERT(NVARCHAR,@PolicyFactorId)+',FactId='+CONVERT(NVARCHAR,@FactId)
	
	
	--产品线商业采购达标率
	IF @FactId = '4'	EXEC Promotion.Proc_Pro_Cal_SubBuPurchaseRate @PolicyFactorId
		
	--产品线医院植入达标率
	IF @FactId = '5'	EXEC Promotion.Proc_Pro_Cal_SubBuSalesRate @PolicyFactorId
	
	--指定产品商业采购达标率
	IF @FactId = '6'	EXEC Promotion.Proc_Pro_Cal_PrdPurchaseRate @PolicyFactorId	
	
	--指定产品医院植入达标率
	IF @FactId = '7'	EXEC Promotion.Proc_Pro_Cal_PrdSalesRate @PolicyFactorId	
		
	--指定产品医院植入量
	IF @FactId = '8'	EXEC Promotion.Proc_Pro_Cal_PrdSalesQuantity @PolicyFactorId	
	
	--指定产品商业采购量
	IF @FactId = '9'	EXEC Promotion.Proc_Pro_Cal_PrdPurchaseQuantity @PolicyFactorId	
	
	--产品线商业采购总金额
	IF @FactId = '10'	EXEC Promotion.Proc_Pro_Cal_SubBuPurchaseAmount @PolicyFactorId	
	
	--产品线医院植入总金额
	IF @FactId = '11'	EXEC Promotion.Proc_Pro_Cal_SubBuSalesAmount @PolicyFactorId	
	
	--指定产品医院植入金额
	IF @FactId = '12'	EXEC Promotion.Proc_Pro_Cal_PrdSalesAmount @PolicyFactorId	
	
	--指定产品商业采购金额
	IF @FactId = '13'	EXEC Promotion.Proc_Pro_Cal_PrdPurchaseAmount @PolicyFactorId	
	
	--指定产品商业采购金额达标率
	IF @FactId = '14'	EXEC Promotion.Proc_Pro_Cal_PrdPurchaseAmountRate @PolicyFactorId	
	
	--指定产品医院植入金额达标率
	IF @FactId = '15'	EXEC Promotion.Proc_Pro_Cal_PrdSalesAmountRate @PolicyFactorId	
	
END  

GO


