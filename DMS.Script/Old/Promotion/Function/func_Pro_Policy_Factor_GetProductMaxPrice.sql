DROP FUNCTION [Promotion].[func_Pro_Policy_Factor_GetProductMaxPrice]
GO

CREATE FUNCTION [Promotion].[func_Pro_Policy_Factor_GetProductMaxPrice](
	@PolicyFactorId INT,@DealerId UNIQUEIDENTIFIER
	)
RETURNS decimal(14, 2)
AS
BEGIN

	DECLARE @PRODUCTPRICE decimal(14,2);

	--******************更新实际值START(指定产品、非套装)*******************************************************************
	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @PolicyFactorId AND ConditionId = 2)
	BEGIN
		--创建可能的约束表(产品)
		IF @PolicyFactorId IS NOT NULL
			SELECT @PRODUCTPRICE=MAX(C.CFNP_Price)
			FROM Promotion.func_Pro_CalFactor_Product(@PolicyFactorId) A
			INNER JOIN CFN B ON A.UPN=B.CFN_CustomerFaceNbr
			INNER JOIN CFNPrice  C ON B.CFN_ID=C.CFNP_CFN_ID AND C.CFNP_Group_ID=@DealerId AND C.CFNP_PriceType='Dealer'
			
	END
	--******************更新实际值END(指定产品、非套装)*******************************************************************
	
	--******************更新实际值START(套装)*********************************************************
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @PolicyFactorId AND ConditionId = 2)
	BEGIN
		DECLARE @BundleId INT --认为只有1个套装
		SELECT TOP 1 @BundleId = CONVERT(INT,REPLACE(ConditionValue,'|','')) FROM Promotion.PRO_POLICY_FACTOR_CONDITION 
		WHERE PolicyFactorId = @PolicyFactorId AND ConditionId = 2
		
		DECLARE @HierType NVARCHAR(50)
		DECLARE @HierId NVARCHAR(MAX)
		DECLARE @Qty INT
		SET @PRODUCTPRICE=0;
		
		DECLARE @iCURSOR_Bundle CURSOR;
		SET @iCURSOR_Bundle = CURSOR FOR SELECT a.HierType,a.HierId,a.Qty FROM Promotion.Pro_Bundle_Setting_Detail a WHERE BundleId = @BundleId 
		OPEN @iCURSOR_Bundle 	
		FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @PRODUCTPRICE=(ISNULL(@PRODUCTPRICE,0)+(MAX(C.CFNP_Price) *ISNULL(@Qty,0)))
			FROM Promotion.func_Pro_CalFactor_ConditionValue2UPN(@HierType,@HierId) A
			INNER JOIN CFN B ON A.UPN=B.CFN_CustomerFaceNbr
			INNER JOIN CFNPrice  C ON B.CFN_ID=C.CFNP_CFN_ID AND C.CFNP_Group_ID=@DealerId AND C.CFNP_PriceType='Dealer'
			
			FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
		END	
		CLOSE @iCURSOR_Bundle
		DEALLOCATE @iCURSOR_Bundle
		
	END
	--******************更新实际值END(套装)*********************************************************
	RETURN @PRODUCTPRICE;
END


GO


