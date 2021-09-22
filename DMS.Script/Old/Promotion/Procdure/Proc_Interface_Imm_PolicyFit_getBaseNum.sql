DROP PROCEDURE [Promotion].[Proc_Interface_Imm_PolicyFit_getBaseNum] 
GO


/**********************************************
	���ܣ�ȡ�ü�ʱ������������ֵ
	���ߣ�GrapeCity
	������ʱ�䣺	2015-11-01
	���¼�¼˵����
	1.���� 2015-11-01
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_Imm_PolicyFit_getBaseNum] 
	@POH_ID UNIQUEIDENTIFIER,
	@JudgePolicyFactorId INT,
	@BaseNum DECIMAL(18,4) OUTPUT
AS
BEGIN 
	DECLARE @FactId INT
	
	DECLARE @OrderValue NVARCHAR(50)
	DECLARE @SQL NVARCHAR(MAX)
	 
	--ȡ�ù��������漰�Ĳ�Ʒ******************************************************************************	
	DECLARE @ProductPolicyFactorId INT
	 
	SELECT @FactId = C.FactId, --�������ص�����
		@ProductPolicyFactorId = A.ConditionPolicyFactorId 
	FROM Promotion.PRO_POLICY_FACTOR_RELATION a,Promotion.PRO_POLICY_FACTOR B,Promotion.PRO_POLICY_FACTOR C
	WHERE A.PolicyFactorId = C.PolicyFactorId AND A.PolicyFactorId = @JudgePolicyFactorId
	AND a.ConditionPolicyFactorId = B.PolicyFactorId AND B.FactId = 1
	
	CREATE TABLE #TMP_UPN
	(
		UPN NVARCHAR(100)
	)
	
	--�������װ
	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2)
	BEGIN 
		INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_Product(@ProductPolicyFactorId)
		
		--FACTID=9,ָ����Ʒ��ҵ�ɹ���;FACTID=13 ָ����Ʒ��ҵ�ɹ����
		SELECT @BaseNum = CASE @FactId WHEN 9 THEN SUM(A.POD_RequiredQty) WHEN 13 THEN SUM(A.POD_Amount) ELSE 0 END
		FROM PurchaseOrderDetail A,CFN B
		WHERE A.POD_POH_ID = @POH_ID AND A.POD_CFN_ID = B.CFN_ID
		AND POD_CFN_Price <> 0 --����Ʒ
		AND B.CFN_CustomerFaceNbr IN (SELECT UPN FROM #TMP_UPN)
		
	END
	
	--�����װ
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2)
	BEGIN
		DECLARE @BundleId INT --��Ϊֻ��1����װ
		SELECT TOP 1 @BundleId = CONVERT(INT,REPLACE(ConditionValue,'|','')) FROM Promotion.PRO_POLICY_FACTOR_CONDITION 
		WHERE PolicyFactorId = @ProductPolicyFactorId AND ConditionId = 2
		
		DECLARE @HierType NVARCHAR(50)
		DECLARE @HierId NVARCHAR(MAX)
		DECLARE @Qty INT
		DECLARE @FIRSTTIME NVARCHAR(10)
		
		CREATE TABLE #TMP_CNT(QTY DECIMAL(14,4))
		CREATE TABLE #TMP_CNT_TMP(QTY DECIMAL(14,4))
		
		SET @FIRSTTIME = 'Y'
		
		DECLARE @iCURSOR_Bundle CURSOR;
		SET @iCURSOR_Bundle = CURSOR FOR SELECT a.HierType,a.HierId,a.Qty FROM Promotion.Pro_Bundle_Setting_Detail a WHERE BundleId = @BundleId 
		OPEN @iCURSOR_Bundle 	
		FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM #TMP_UPN
			DELETE FROM #TMP_CNT_TMP
			
			INSERT INTO #TMP_UPN(UPN) SELECT UPN FROM Promotion.func_Pro_CalFactor_ConditionValue2UPN(@HierType,@HierId)
			
			INSERT INTO #TMP_CNT_TMP(QTY)
			SELECT FLOOR(SUM(A.POD_RequiredQty)/CONVERT(DECIMAL(14,4),@Qty))
			FROM PurchaseOrderDetail A,CFN B
			WHERE A.POD_POH_ID = @POH_ID AND A.POD_CFN_ID = B.CFN_ID
			AND POD_CFN_Price <> 0 --����Ʒ
			AND B.CFN_CustomerFaceNbr IN (SELECT UPN FROM #TMP_UPN) 
			
			IF @FIRSTTIME = 'Y'	--��һ��ʱ��ֻҪ������ͷ���
			BEGIN
				INSERT INTO #TMP_CNT(QTY) SELECT QTY FROM #TMP_CNT_TMP WHERE QTY > 0 
			END
			ELSE	--����С����ֵ��ɾ�������ڵ�
			BEGIN
				UPDATE A SET QTY = B.QTY
				FROM #TMP_CNT A,#TMP_CNT_TMP B WHERE A.QTY > B.QTY
				
				DELETE A
				FROM #TMP_CNT A WHERE NOT EXISTS (SELECT 1 FROM #TMP_CNT_TMP WHERE QTY >0)
			END
			
			SET @FIRSTTIME = 'N'
			
			FETCH NEXT FROM @iCURSOR_Bundle INTO @HierType,@HierId,@Qty
		END	
		CLOSE @iCURSOR_Bundle
		DEALLOCATE @iCURSOR_Bundle
		
		--�ö�������װ����
		SELECT @BaseNum = QTY FROM #TMP_CNT
	END 
		
END  


GO


