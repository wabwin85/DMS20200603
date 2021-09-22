DROP PROCEDURE [Promotion].[Proc_Interface_Imm_PolicyFit] 
GO


/**********************************************
	功能：将政策进行奖励
	作者：GrapeCity
	最后更新时间：	2015-11-01
	更新记录说明：
	1.创建 2015-11-01
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_Imm_PolicyFit] 
	@POH_ID UNIQUEIDENTIFIER,
	@PolicyId INT,
	@Result NVARCHAR(MAX)  OUTPUT,
	@RtnMsg NVARCHAR(4000)  OUTPUT
AS
BEGIN TRY
	DECLARE @RuleId INT
	DECLARE @RuleIdFound INT
	DECLARE @RuleFactorId INT
	DECLARE @isFit NVARCHAR(10) 
	DECLARE @isFitFinal NVARCHAR(10) 
	SET @Result = 'Success'
	SET @RtnMsg = ''

	--定位符合条件的RULEID************************************************************************************
	IF NOT EXISTS (SELECT * FROM PROMOTION.PRO_POLICY_RULE A,PROMOTION.PRO_POLICY_RULE_FACTOR B
		WHERE A.RULEID = B.RULEID AND A.POLICYID = @PolicyId)
	BEGIN
		--如果该政策没有规则条件因素，那么认为只有1个规则
		SELECT @RuleIdFound = RULEID FROM PROMOTION.PRO_POLICY_RULE WHERE POLICYID = @PolicyId
	END
	ELSE
	BEGIN
		--找到符合的那个RULEID
		DECLARE @iCURSOR_Rule CURSOR; 
		SET @iCURSOR_Rule = CURSOR FOR SELECT RuleId FROM PROMOTION.PRO_POLICY_RULE WHERE PolicyId = @PolicyId 
		OPEN @iCURSOR_Rule 	
		FETCH NEXT FROM @iCURSOR_Rule INTO @RuleId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @isFitFinal = 'Fit'
			--规则中的每个判断因素做循环
			IF exists(SELECT RuleFactorId FROM PROMOTION.PRO_POLICY_RULE_FACTOR WHERE RuleId = @RuleId)
			BEGIN
				DECLARE @iCURSOR_Rule_Factor CURSOR; 
				SET @iCURSOR_Rule_Factor = CURSOR FOR SELECT RuleFactorId FROM PROMOTION.PRO_POLICY_RULE_FACTOR WHERE RuleId = @RuleId
				OPEN @iCURSOR_Rule_Factor 	
				FETCH NEXT FROM @iCURSOR_Rule_Factor INTO @RuleFactorId
				WHILE @@FETCH_STATUS = 0
				BEGIN
					EXEC PROMOTION.Proc_Interface_Imm_PolicyFit_RuleFactorCheck @POH_ID,@RuleFactorId,@isFit OUTPUT
					IF @isFit = 'NotFit' 
					BEGIN
						SET @isFitFinal = 'NotFit'
					END
					FETCH NEXT FROM @iCURSOR_Rule_Factor INTO @RuleFactorId
				END	
				CLOSE @iCURSOR_Rule_Factor
				DEALLOCATE @iCURSOR_Rule_Factor

				IF @isFitFinal = 'Fit' 
				BEGIN
					SET @RuleIdFound = @RuleId
				END

				FETCH NEXT FROM @iCURSOR_Rule INTO @RuleId
			END	
			ELSE
			BEGIN
				SET @RuleIdFound = @RuleId
			END
		END
		CLOSE @iCURSOR_Rule
		DEALLOCATE @iCURSOR_Rule
	END
	
	--取得即时买赠的参数************************************************************************************
	DECLARE @JudgePolicyFactorId INT
	DECLARE @JudgeValue DECIMAL(18,4)
	DECLARE @GiftValue DECIMAL(18,4)
	DECLARE @GiftPolicyFactorId INT
	DECLARE @PolicySubStyle NVARCHAR(50)
	DECLARE @ConditionPolicyFactorId INT
	DECLARE @BaseNum DECIMAL(18,4) --订单中的基数值，采购量（支持套装）或采购金额
	DECLARE @LargessNum DECIMAL(18,4) --计算可送出的产品数量
	DECLARE @LargessSelectedNum DECIMAL(18,4) --订单中选择的赠品数量
	 
	SELECT @JudgePolicyFactorId = A.JudgePolicyFactorId,
		@JudgeValue = A.JudgeValue,
		@GiftValue = A.GiftValue,
		@GiftPolicyFactorId = B.GiftPolicyFactorId,
		@PolicySubStyle = PolicySubStyle
	FROM PROMOTION.PRO_POLICY_RULE A,Promotion.PRO_POLICY_LARGESS B,PROMOTION.PRO_POLICY C
	WHERE A.POLICYID = B.POLICYID AND A.POLICYID = C.POLICYID AND A.RULEID = @RuleIdFound
	AND PolicySubStyle <> '满额打折'
	
		SELECT @JudgePolicyFactorId = A.JudgePolicyFactorId,
		@JudgeValue = A.JudgeValue,
		@GiftValue = A.GiftValue,
		@PolicySubStyle = PolicySubStyle
	FROM PROMOTION.PRO_POLICY_RULE A,PROMOTION.PRO_POLICY C
	WHERE  A.POLICYID = C.POLICYID AND A.RULEID = @RuleIdFound
	AND PolicySubStyle = '满额打折'
	
	--取得奖励产品的范围
	CREATE TABLE #TMP_UPN_LARGESS
	(
		UPN NVARCHAR(100)
	)
	INSERT INTO #TMP_UPN_LARGESS(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
	
	--对于满额送赠品，进行赠品判断（判断用户选择的赠品数与政策可奖励的赠品数是否一致）***************************************
	IF @PolicySubStyle = '满额送赠品'
	BEGIN
		EXEC PROMOTION.Proc_Interface_Imm_PolicyFit_getBaseNum @POH_ID,@JudgePolicyFactorId,@BaseNum OUTPUT
 
		--计算可送出的产品数量
		SELECT @LargessNum = ISNULL(FLOOR(@BaseNum/@JudgeValue)*@GiftValue,0)
 
		--订单中实际选择的赠品数
		SELECT @LargessSelectedNum = SUM(A.POD_RequiredQty)
		FROM PurchaseOrderDetail A,CFN B
		WHERE A.POD_POH_ID = @POH_ID AND A.POD_CFN_ID = B.CFN_ID
		AND POD_CFN_Price = 0 --赠品
		AND B.CFN_CustomerFaceNbr IN (SELECT UPN FROM #TMP_UPN_LARGESS)
		
		IF @LargessNum <> @LargessSelectedNum
		BEGIN
			SET @Result = '您选择的赠品数：'+CONVERT(NVARCHAR,@LargessSelectedNum)+',按政策可赠送数：'+CONVERT(NVARCHAR,@LargessNum)+',请重新选择。'
			RETURN
		END
	END
	
	--修改订单进行奖励************************************************************************************
	IF @PolicySubStyle = '满额送赠品' AND @LargessNum > 0 
	BEGIN
		--将赠品单价和金额改为0
		UPDATE A SET POD_CFN_Price = 0,POD_Amount = 0
		FROM PurchaseOrderDetail A,CFN B
		WHERE A.POD_POH_ID = @POH_ID AND A.POD_CFN_ID = B.CFN_ID
		AND POD_CFN_Price = 0 --赠品
		AND B.CFN_CustomerFaceNbr IN (SELECT UPN FROM #TMP_UPN_LARGESS) 
		
		IF @@ROWCOUNT = 0
		BEGIN
			SET @Result = '没有符合条件的奖励可匹配，请重新选择。'
			RETURN 
		END
	END
	
	IF @PolicySubStyle = '满额打折'
	BEGIN
		--通过打折因素确认打折产品
		DELETE #TMP_UPN_LARGESS;
		DECLARE @ProductPolicyFactorId INT
		
		SELECT 
	 	@ProductPolicyFactorId = 
	 		(select TOP 1 re.ConditionPolicyFactorId 
	 		FROM Promotion.PRO_POLICY_FACTOR_RELATION re 
	 		inner join Promotion.PRO_POLICY_FACTOR FA ON RE.ConditionPolicyFactorId=FA.PolicyFactorId AND A.PolicyId=FA.PolicyId
	 		 AND FA.FactId=1
	 		where re.PolicyFactorId =A.JudgePolicyFactorId)
		FROM PROMOTION.PRO_POLICY_RULE A,PROMOTION.PRO_POLICY_FACTOR B 
		WHERE A.JudgePolicyFactorId = B.POLICYFACTORID AND a.RuleId = @RuleIdFound 
		
		IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2)
		BEGIN
			INSERT INTO #TMP_UPN_LARGESS(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
		END
		IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2)
		BEGIN
			DECLARE @BundleId INT --认为只有1个套装
			SELECT TOP 1 @BundleId = CONVERT(INT,REPLACE(ConditionValue,'|','')) FROM Promotion.PRO_POLICY_FACTOR_CONDITION 
			WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2
			
			DECLARE @HierType NVARCHAR(50)
			DECLARE @HierId NVARCHAR(MAX)
			DECLARE @Qty INT
			DECLARE @FIRSTTIME NVARCHAR(10)
			
			DECLARE @iCURSOR_Bundle CURSOR;
			SET @iCURSOR_Bundle = CURSOR FOR SELECT a.HierType,a.HierId,a.Qty FROM Promotion.Pro_Bundle_Setting_Detail a WHERE BundleId = @BundleId 
			OPEN @iCURSOR_Bundle 	
			FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
			WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO #TMP_UPN_LARGESS(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_ConditionValue2UPN(@HierType,@HierId)
				FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
			END
			CLOSE @iCURSOR_Bundle
			DEALLOCATE @iCURSOR_Bundle
		END
		
		
		
		--将赠品单价和金额打折
		DECLARE @CheckUPN NVARCHAR(10) 
		--SET @CheckUPN = 'Fit'
		EXEC [Promotion].[Proc_Interface_Imm_PolicyFit_RuleUPNCheck]  @POH_ID,@RuleIdFound,@CheckUPN OUTPUT
			
		IF @CheckUPN = 'Fit'
		BEGIN
			UPDATE A SET POD_CFN_Price = POD_CFN_Price * @GiftValue,
				POD_Amount = POD_Amount * @GiftValue
			FROM PurchaseOrderDetail A,CFN B
			WHERE A.POD_POH_ID = @POH_ID AND A.POD_CFN_ID = B.CFN_ID
			AND B.CFN_CustomerFaceNbr IN (SELECT UPN FROM #TMP_UPN_LARGESS) 
			
			IF @@ROWCOUNT = 0
			BEGIN
				SET @Result = '没有符合条件的奖励可匹配，请重新选择。'
				 
			END
		END
		ELSE
		BEGIN
			SET @Result = '产品不满足促销政策，不能使用促销。'
		END
	END	
	IF ISNULL(@Result,'')<>''  and ISNULL(@Result,'')<>'Success'
	BEGIN
		SET @RtnMsg=@Result;
		SET @Result=''
	END
END TRY
BEGIN CATCH
    DECLARE @error_number INT
    DECLARE @error_serverity INT
    DECLARE @error_state INT
    DECLARE @error_message NVARCHAR(256)
    DECLARE @error_line INT
    DECLARE @error_procedure NVARCHAR(256)
    DECLARE @vError NVARCHAR(1000)
    SET @error_number = ERROR_NUMBER()
    SET @error_serverity = ERROR_SEVERITY()
    SET @error_state = ERROR_STATE()
    SET @error_message = ERROR_MESSAGE()
    SET @error_line = ERROR_LINE()
    SET @error_procedure = ERROR_PROCEDURE()
    SET @vError = ISNULL(@error_procedure, '') + '第'
        + CONVERT(NVARCHAR(10), ISNULL(@error_line, '')) + '行出错[错误号：'
        + CONVERT(NVARCHAR(10), ISNULL(@error_number, '')) + ']，'
        + ISNULL(@error_message, '')
    SET @Result = 'Failure'
    SET @RtnMsg = @vError
    
    
END CATCH

GO


