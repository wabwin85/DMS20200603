DROP PROCEDURE [Promotion].[Proc_Interface_Imm_PolicyFit] 
GO


/**********************************************
	���ܣ������߽��н���
	���ߣ�GrapeCity
	������ʱ�䣺	2015-11-01
	���¼�¼˵����
	1.���� 2015-11-01
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

	--��λ����������RULEID************************************************************************************
	IF NOT EXISTS (SELECT * FROM PROMOTION.PRO_POLICY_RULE A,PROMOTION.PRO_POLICY_RULE_FACTOR B
		WHERE A.RULEID = B.RULEID AND A.POLICYID = @PolicyId)
	BEGIN
		--���������û�й����������أ���ô��Ϊֻ��1������
		SELECT @RuleIdFound = RULEID FROM PROMOTION.PRO_POLICY_RULE WHERE POLICYID = @PolicyId
	END
	ELSE
	BEGIN
		--�ҵ����ϵ��Ǹ�RULEID
		DECLARE @iCURSOR_Rule CURSOR; 
		SET @iCURSOR_Rule = CURSOR FOR SELECT RuleId FROM PROMOTION.PRO_POLICY_RULE WHERE PolicyId = @PolicyId 
		OPEN @iCURSOR_Rule 	
		FETCH NEXT FROM @iCURSOR_Rule INTO @RuleId
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @isFitFinal = 'Fit'
			--�����е�ÿ���ж�������ѭ��
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
	
	--ȡ�ü�ʱ�����Ĳ���************************************************************************************
	DECLARE @JudgePolicyFactorId INT
	DECLARE @JudgeValue DECIMAL(18,4)
	DECLARE @GiftValue DECIMAL(18,4)
	DECLARE @GiftPolicyFactorId INT
	DECLARE @PolicySubStyle NVARCHAR(50)
	DECLARE @ConditionPolicyFactorId INT
	DECLARE @BaseNum DECIMAL(18,4) --�����еĻ���ֵ���ɹ�����֧����װ����ɹ����
	DECLARE @LargessNum DECIMAL(18,4) --������ͳ��Ĳ�Ʒ����
	DECLARE @LargessSelectedNum DECIMAL(18,4) --������ѡ�����Ʒ����
	 
	SELECT @JudgePolicyFactorId = A.JudgePolicyFactorId,
		@JudgeValue = A.JudgeValue,
		@GiftValue = A.GiftValue,
		@GiftPolicyFactorId = B.GiftPolicyFactorId,
		@PolicySubStyle = PolicySubStyle
	FROM PROMOTION.PRO_POLICY_RULE A,Promotion.PRO_POLICY_LARGESS B,PROMOTION.PRO_POLICY C
	WHERE A.POLICYID = B.POLICYID AND A.POLICYID = C.POLICYID AND A.RULEID = @RuleIdFound
	AND PolicySubStyle <> '�������'
	
		SELECT @JudgePolicyFactorId = A.JudgePolicyFactorId,
		@JudgeValue = A.JudgeValue,
		@GiftValue = A.GiftValue,
		@PolicySubStyle = PolicySubStyle
	FROM PROMOTION.PRO_POLICY_RULE A,PROMOTION.PRO_POLICY C
	WHERE  A.POLICYID = C.POLICYID AND A.RULEID = @RuleIdFound
	AND PolicySubStyle = '�������'
	
	--ȡ�ý�����Ʒ�ķ�Χ
	CREATE TABLE #TMP_UPN_LARGESS
	(
		UPN NVARCHAR(100)
	)
	INSERT INTO #TMP_UPN_LARGESS(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@GiftPolicyFactorId)
	
	--������������Ʒ��������Ʒ�жϣ��ж��û�ѡ�����Ʒ�������߿ɽ�������Ʒ���Ƿ�һ�£�***************************************
	IF @PolicySubStyle = '��������Ʒ'
	BEGIN
		EXEC PROMOTION.Proc_Interface_Imm_PolicyFit_getBaseNum @POH_ID,@JudgePolicyFactorId,@BaseNum OUTPUT
 
		--������ͳ��Ĳ�Ʒ����
		SELECT @LargessNum = ISNULL(FLOOR(@BaseNum/@JudgeValue)*@GiftValue,0)
 
		--������ʵ��ѡ�����Ʒ��
		SELECT @LargessSelectedNum = SUM(A.POD_RequiredQty)
		FROM PurchaseOrderDetail A,CFN B
		WHERE A.POD_POH_ID = @POH_ID AND A.POD_CFN_ID = B.CFN_ID
		AND POD_CFN_Price = 0 --��Ʒ
		AND B.CFN_CustomerFaceNbr IN (SELECT UPN FROM #TMP_UPN_LARGESS)
		
		IF @LargessNum <> @LargessSelectedNum
		BEGIN
			SET @Result = '��ѡ�����Ʒ����'+CONVERT(NVARCHAR,@LargessSelectedNum)+',�����߿���������'+CONVERT(NVARCHAR,@LargessNum)+',������ѡ��'
			RETURN
		END
	END
	
	--�޸Ķ������н���************************************************************************************
	IF @PolicySubStyle = '��������Ʒ' AND @LargessNum > 0 
	BEGIN
		--����Ʒ���ۺͽ���Ϊ0
		UPDATE A SET POD_CFN_Price = 0,POD_Amount = 0
		FROM PurchaseOrderDetail A,CFN B
		WHERE A.POD_POH_ID = @POH_ID AND A.POD_CFN_ID = B.CFN_ID
		AND POD_CFN_Price = 0 --��Ʒ
		AND B.CFN_CustomerFaceNbr IN (SELECT UPN FROM #TMP_UPN_LARGESS) 
		
		IF @@ROWCOUNT = 0
		BEGIN
			SET @Result = 'û�з��������Ľ�����ƥ�䣬������ѡ��'
			RETURN 
		END
	END
	
	IF @PolicySubStyle = '�������'
	BEGIN
		--ͨ����������ȷ�ϴ��۲�Ʒ
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
			DECLARE @BundleId INT --��Ϊֻ��1����װ
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
		
		
		
		--����Ʒ���ۺͽ�����
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
				SET @Result = 'û�з��������Ľ�����ƥ�䣬������ѡ��'
				 
			END
		END
		ELSE
		BEGIN
			SET @Result = '��Ʒ������������ߣ�����ʹ�ô�����'
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
    SET @vError = ISNULL(@error_procedure, '') + '��'
        + CONVERT(NVARCHAR(10), ISNULL(@error_line, '')) + '�г���[����ţ�'
        + CONVERT(NVARCHAR(10), ISNULL(@error_number, '')) + ']��'
        + ISNULL(@error_message, '')
    SET @Result = 'Failure'
    SET @RtnMsg = @vError
    
    
END CATCH

GO


