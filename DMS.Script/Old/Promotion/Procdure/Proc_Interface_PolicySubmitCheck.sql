DROP PROCEDURE [Promotion].[Proc_Interface_PolicySubmitCheck]
GO


/**********************************************
	功能：在政策保存前校验
	作者：GrapeCity
	最后更新时间：	2015-11-01
	更新记录说明：
	1.创建 2015-11-01
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_PolicySubmitCheck] 
	@UserId NVARCHAR(50),
	@Result  nvarchar(100) = 'Failed' output 
AS
BEGIN 
	DECLARE @POLICYID INT
	DECLARE @STATUS NVARCHAR(20)
	DECLARE @CurrentPeriod NVARCHAR(20)
	DECLARE @CalType NVARCHAR(20)
	
	DECLARE @TopType NVARCHAR(20)
	DECLARE @PointUseRange NVARCHAR(50)
	DECLARE @SubBu NVARCHAR(50)	
	DECLARE @PolicyStyle NVARCHAR(50)	
	DECLARE @PolicySubStyle NVARCHAR(50)
	
	SELECT 
		@POLICYID = A.POLICYID,
		@STATUS = A.STATUS,
		@CurrentPeriod = A.CurrentPeriod
	FROM Promotion.PRO_POLICY A,Promotion.PRO_POLICY_UI B WHERE A.POLICYID = B.POLICYID AND B.CurrUser = @UserId
 	
 	--只有“草稿”、或者“审批退回并且从来没有计算过”的政策，才需要进行校验。
 	--如果不是上述两种情况，就直接跳出。（因为其他情况，只允许修改经销商或者医院的内容，不会对政策参数规范性进行修改）
 	IF NOT (@STATUS = '草稿' OR (@STATUS ='审批退回' AND ISNULL(@CurrentPeriod,'') = ''))
 	BEGIN
 		SET @Result = 'Success' 
 		RETURN
 	END
 	
 	--取得UI表中的政策参数
 	SELECT 
 		@TopType = TopType,
 		@PolicyStyle = PolicyStyle,
 		@PointUseRange = PointUseRange,
 		@SubBu = SubBu,
		@PolicyStyle = PolicyStyle,
		@PolicySubStyle = PolicySubStyle,
		@CalType=CalType
 	FROM Promotion.PRO_POLICY_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId
 	
 	
 	--政策有封顶但没有设置封顶表
 	IF @TopType IN ('Dealer','Hospital','DealerPeriod','HospitalPeriod') 
 		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_TOPVALUE_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = '本政策需要设置封顶，请导入数据！' 
 		RETURN
 	END
 	
 	--政策经销商表没有设置
 	IF @CalType<>'ByHospital'
 	BEGIN
 	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_DEALER_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId )
 	BEGIN
 		SET @Result = '请设置本政策涉及的经销商！' 
 		RETURN
 	END
 	END
 	
 	--没有设置任何因素
 	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = '请设置本政策涉及的因素！' 
 		RETURN
 	END
 	
 	--如果是产品因素，要设置约束条件
 	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_UI A WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND FactId = 1
 		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION_UI WHERE CurrUser = @UserId AND PolicyFactorId = A.PolicyFactorId))
 	BEGIN
 		SET @Result = '请为【产品因素】设置约束条件！' 
 		RETURN
 	END
 		
 	--如果是医院因素，要设置约束条件
 	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_UI A WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND FactId = 2
 		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION_UI WHERE CurrUser = @UserId AND PolicyFactorId = A.PolicyFactorId))
 	BEGIN
 		SET @Result = '请为【医院因素】设置约束条件！' 
 		RETURN
 	END
 	
 	--指定产品商业采购达标率，没有设置关联的产品因素
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (6) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 1 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '【指定产品商业采购达标率】需要关联【产品因素】！' 
 		RETURN
 	END
 	
 	--指定产品商业采购达标率，没有设置具体的指标表
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (6) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.Pro_Dealer_PrdPurchase_Taget_UI WHERE CurrUser = @UserId AND PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '【指定产品商业采购达标率】需要导入指标！' 
 		RETURN
 	END
 	
 	--指定产品医院植入达标率，没有设置关联的产品因素
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (7) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 1 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '【指定产品医院植入达标率】需要关联【产品因素】！' 
 		RETURN
 	END
 	
 	--指定产品医院植入达标率，没有设置关联的医院因素
 	/*
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (7) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 2 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '【指定产品医院植入达标率】需要关联【医院因素】！' 
 		RETURN
 	END
 	*/
 	
 	--指定产品医院植入达标率，没有设置具体的指标表
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (7) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.Pro_Hospital_PrdSalesTaget_UI WHERE CurrUser = @UserId AND PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '【指定产品医院植入达标率】需要导入指标！' 
 		RETURN
 	END
	
 	--指定产品医院植入量，没有设置关联的产品因素
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (8) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 1 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '【指定产品医院植入量】需要关联【产品因素】！' 
 		RETURN
 	END
 	
 	--指定产品医院植入量，没有设置关联的医院因素
 	/*
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (8) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 2 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '【指定产品医院植入量】需要关联【医院因素】！' 
 		RETURN
 	END
 	*/
 	
 	--指定产品商业采购量，没有设置关联的产品因素
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (9) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 1 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '【指定产品商业采购量】需要关联【产品因素】！' 
 		RETURN
 	END
 	
 	--如果没有对应的规则设置，提示用户是否本政策是部分计算的政策.但是可以提交审批。
 	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_RULE_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = 'Half' 
 		RETURN 
 	END
 	
 	--没有指定赠品
 	IF (@PolicyStyle = '赠品' OR @PolicySubStyle = '促销赠品转积分') 
 		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_LARGESS_UI WHERE GiftPolicyFactorId IS NOT NULL AND PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = '请选择某个产品因素作为赠品！' 
 		RETURN
 	END
 	
 	--没有指定积分使用范围
 	IF @PolicyStyle = '积分' 
 	AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_LARGESS_UI WHERE UseRangePolicyFactorId IS NOT NULL AND PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = '请选择某个产品因素作为积分使用范围！' 
 		RETURN
 	END
 	 	
 	IF @PolicyStyle = '即时买赠' AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_DEALER_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = '即时买赠政策必须指定经销商！' 
 		RETURN
 	END
 	 	
	SET @Result = 'Success' 
END  

GO


