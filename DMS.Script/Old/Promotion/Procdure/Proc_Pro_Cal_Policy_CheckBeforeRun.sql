DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_CheckBeforeRun]  
GO


/**********************************************
	功能：促销计算前校验
	作者：GrapeCity
	最后更新时间：	2015-08-31
	更新记录说明：
	1.创建 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_CheckBeforeRun]  
	@PolicyId Int ,--政策ID
	@isError  NVARCHAR(10)  OUTPUT 
AS
BEGIN
	DECLARE @ErrorValue NVARCHAR(MAX);
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @ICOUNT INT; 
	
	SET @isError='Y'
	SET @ErrorValue=''
	
	DECLARE @Period NVARCHAR(5);
	DECLARE @CalType NVARCHAR(20);
	DECLARE @StartPeriod NVARCHAR(6);
	DECLARE @EndPeriod NVARCHAR(6);
	DECLARE @StartDate NVARCHAR(20);
	DECLARE @EndDate NVARCHAR(20);
	DECLARE @CurrentPeriod NVARCHAR(20);
	DECLARE @runPeriod NVARCHAR(20);
	DECLARE @ReportTableName NVARCHAR(50);
	DECLARE @ifIncrement NVARCHAR(50);
	DECLARE @YTDOption NVARCHAR(50);
	
	--通过PolicyId从政策表获得相关参数
	SELECT @Period = A.Period,
		@CalType = A.CalType,
		@StartDate = A.StartDate,
		@EndDate = A.EndDate,
		@CurrentPeriod = A.CurrentPeriod,
		@ReportTableName = A.ReportTableName,
		@ifIncrement = ISNULL(A.ifIncrement,''),
		@YTDOption = ISNULL(A.YTDOption,'N')
	FROM PROMOTION.PRO_POLICY A WHERE PolicyId = @PolicyId
	
	--得到当前计算的期间
	IF ISNULL(@CurrentPeriod,'') = ''
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@StartDate) 
	END
	ELSE
	BEGIN
		SET @runPeriod = PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod)
	END
	
	IF @@ROWCOUNT = 0 
	BEGIN
		SET @ErrorValue +='政策编号不存在，'
	END
	
	IF NOT EXISTS (SELECT * FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId AND Status = '有效' 
		 AND CalModule IN ('预算','正式') AND CalStatus = '待计算')
	BEGIN
		SET @ErrorValue +='只有[有效]\[预算,正式]\[待计算]的政策才可被执行，'
	END
	
	IF PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod) > PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@EndDate)
	BEGIN
		SET @ErrorValue +='此政策已到期无法再计算下个期间，'
	END
	
	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId = @PolicyId AND FactId = 1
		AND NOT EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = A.PolicyFactorId))
	BEGIN
		SET @ErrorValue +='[产品]因素需要约束条件，'
	END
	
	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId = @PolicyId AND FactId = 2
		AND NOT EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = A.PolicyFactorId))
	BEGIN
		SET @ErrorValue +='[医院]因素需要约束条件，'
	END
	
	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId = @PolicyId AND FactId = 3
		AND NOT EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = A.PolicyFactorId))
	BEGIN
		SET @ErrorValue +='[经销商]因素需要约束条件，'
	END
	/*
	IF @CalType = 'ByDealer' and NOT EXISTS (SELECT 1 FROM Promotion.PRO_DEALER WHERE PolicyId=@PolicyId)
	BEGIN
		SET @ErrorValue +='此政策未指定经销商，'
	END
	*/
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=7
		AND NOT EXISTS (SELECT 1 FROM Promotion.Pro_Hospital_PrdSalesTaget WHERE PolicyFactorId = A.PolicyFactorId))
	BEGIN
		SET @ErrorValue +='[指定产品医院植入达标率]需要导入指标，'
	END
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=7
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 1 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[指定产品医院植入达标率]需要指定[产品]因素，'
	END
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=6
		AND NOT EXISTS(SELECT 1 FROM Promotion.Pro_Dealer_PrdPurchase_Taget WHERE PolicyFactorId=A.PolicyFactorId))
	BEGIN
		SET @ErrorValue +='[指定产品商业采购达标率]需要导入指标，'
	END
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=6
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 1 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[指定产品商业采购达标率]需要指定[产品]因素，'
	END
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=8
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 1 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[指定产品医院植入量]需要指定[产品]因素，'
	END
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=9
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 1 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[指定产品商业采购量]需要指定[产品]因素，'
	END
	
	IF @ifIncrement = 'Y' AND EXISTS (SELECT * FROM Promotion.PRO_POLICY_RULE A,Promotion.PRO_POLICY_FACTOR B
				WHERE A.JudgePolicyFactorId = B.PolicyFactorId AND A.PolicyId = @PolicyId AND B.FactId = 8)
			AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId=@PolicyId AND FactId=7)
	BEGIN
		SET @ErrorValue +='[指定产品医院植入量][增量计算]需要同时具有[指定产品医院植入达标率]因素，'
	END
	
	IF @ifIncrement = 'Y' AND EXISTS (SELECT * FROM Promotion.PRO_POLICY_RULE A,Promotion.PRO_POLICY_FACTOR B
				WHERE A.JudgePolicyFactorId = B.PolicyFactorId AND A.PolicyId = @PolicyId AND B.FactId = 9)
			AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId=@PolicyId AND FactId=6)
	BEGIN
		SET @ErrorValue +='[指定产品商业采购量][增量计算]需要同时具有[指定产品商业采购达标率]因素，'
	END
	
	IF @YTDOption <> 'N' AND NOT EXISTS (SELECT COUNT(*) FROM Promotion.PRO_POLICY_FACTOR 
		WHERE POLICYID = @PolicyId AND FACTID IN (6,7,14,15) HAVING COUNT(*) = 1)
	BEGIN
		SET @ErrorValue +='使用YTD补历史奖励参数时有且只能有一个指定产品达标类因素，'
	END	
	
	IF @YTDOption <> 'N' AND ((EXISTS (SELECT count(DISTINCT a.TargetLevel) 
				FROM Promotion.Pro_Hospital_PrdSalesTaget a,Promotion.PRO_POLICY_FACTOR b
				WHERE a.PolicyFactorId = b.PolicyFactorId AND b.FactId IN (7,15)
				AND b.PolicyId = @PolicyId HAVING count(DISTINCT a.TargetLevel) <> 1) 
					AND EXISTS (SELECT 1
				FROM Promotion.Pro_Hospital_PrdSalesTaget a,Promotion.PRO_POLICY_FACTOR b
				WHERE a.PolicyFactorId = b.PolicyFactorId AND b.FactId IN (7,15)
				AND b.PolicyId = @PolicyId))
			OR (EXISTS (SELECT count(DISTINCT a.TargetLevel) 
				FROM Promotion.Pro_Dealer_PrdPurchase_Taget a,Promotion.PRO_POLICY_FACTOR b
				WHERE a.PolicyFactorId = b.PolicyFactorId AND b.FactId IN (6,14)
				AND b.PolicyId = @PolicyId HAVING count(DISTINCT a.TargetLevel) <> 1) 
					AND EXISTS (SELECT 1 
				FROM Promotion.Pro_Dealer_PrdPurchase_Taget a,Promotion.PRO_POLICY_FACTOR b
				WHERE a.PolicyFactorId = b.PolicyFactorId AND b.FactId IN (6,14)
				AND b.PolicyId = @PolicyId)))
	BEGIN
		SET @ErrorValue +='使用YTD补历史奖励参数时必须且只能设置“目标1”，'
	END
	
	/* 
	IF @CalType = 'ByDealer' AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=7
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 2 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[指定产品医院植入达标率]需要指定[医院]因素，'
	END
	*/
	
	/*
	IF @CalType = 'ByDealer' AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=8
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 2 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[指定产品医院植入量]需要指定[医院]因素，'
	END
	*/
	
	/* 前置价格 已经在RV给出的INTERFACE中计算过了，PROMOTION中就不需要计算了
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId AND IsPrePrice = 'Y')
	BEGIN
		
		SET @SQL = N'SELECT @ICOUNT = COUNT(*) FROM '+@ReportTableName+' WHERE PrePrice'+@runPeriod + ' IS NULL'
 		EXEC SP_EXECUTESQL @SQL,N'@ICOUNT INT output',@ICOUNT output
 		IF @ICOUNT > 0 
			SET @ErrorValue +='需要设置本期间的“是否前置价格”字段，'
	END
	*/
	
	IF LEN(@ErrorValue) >0
	BEGIN
		SET @isError='N'
		PRINT 'Policyid = '+CONVERT(NVARCHAR,@PolicyId) +' Check Error!' 
		SET @ErrorValue = LEFT(@ErrorValue,LEN(@ErrorValue)-1)
		EXEC PROMOTION.Proc_Pro_Cal_Log @PolicyId,'',@ErrorValue
	END 
	
END


GO


