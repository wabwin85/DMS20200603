DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_CheckBeforeRun]  
GO


/**********************************************
	���ܣ���������ǰУ��
	���ߣ�GrapeCity
	������ʱ�䣺	2015-08-31
	���¼�¼˵����
	1.���� 2015-08-31
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Policy_CheckBeforeRun]  
	@PolicyId Int ,--����ID
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
	
	--ͨ��PolicyId�����߱�����ز���
	SELECT @Period = A.Period,
		@CalType = A.CalType,
		@StartDate = A.StartDate,
		@EndDate = A.EndDate,
		@CurrentPeriod = A.CurrentPeriod,
		@ReportTableName = A.ReportTableName,
		@ifIncrement = ISNULL(A.ifIncrement,''),
		@YTDOption = ISNULL(A.YTDOption,'N')
	FROM PROMOTION.PRO_POLICY A WHERE PolicyId = @PolicyId
	
	--�õ���ǰ������ڼ�
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
		SET @ErrorValue +='���߱�Ų����ڣ�'
	END
	
	IF NOT EXISTS (SELECT * FROM Promotion.PRO_POLICY WHERE PolicyId = @PolicyId AND Status = '��Ч' 
		 AND CalModule IN ('Ԥ��','��ʽ') AND CalStatus = '������')
	BEGIN
		SET @ErrorValue +='ֻ��[��Ч]\[Ԥ��,��ʽ]\[������]�����߲ſɱ�ִ�У�'
	END
	
	IF PROMOTION.func_Pro_Utility_getPeriod(@Period,'NEXT',@CurrentPeriod) > PROMOTION.func_Pro_Utility_getPeriod(@Period,'CURRENT',@EndDate)
	BEGIN
		SET @ErrorValue +='�������ѵ����޷��ټ����¸��ڼ䣬'
	END
	
	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId = @PolicyId AND FactId = 1
		AND NOT EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = A.PolicyFactorId))
	BEGIN
		SET @ErrorValue +='[��Ʒ]������ҪԼ��������'
	END
	
	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId = @PolicyId AND FactId = 2
		AND NOT EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = A.PolicyFactorId))
	BEGIN
		SET @ErrorValue +='[ҽԺ]������ҪԼ��������'
	END
	
	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId = @PolicyId AND FactId = 3
		AND NOT EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_CONDITION WHERE PolicyFactorId = A.PolicyFactorId))
	BEGIN
		SET @ErrorValue +='[������]������ҪԼ��������'
	END
	/*
	IF @CalType = 'ByDealer' and NOT EXISTS (SELECT 1 FROM Promotion.PRO_DEALER WHERE PolicyId=@PolicyId)
	BEGIN
		SET @ErrorValue +='������δָ�������̣�'
	END
	*/
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=7
		AND NOT EXISTS (SELECT 1 FROM Promotion.Pro_Hospital_PrdSalesTaget WHERE PolicyFactorId = A.PolicyFactorId))
	BEGIN
		SET @ErrorValue +='[ָ����ƷҽԺֲ������]��Ҫ����ָ�꣬'
	END
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=7
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 1 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[ָ����ƷҽԺֲ������]��Ҫָ��[��Ʒ]���أ�'
	END
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=6
		AND NOT EXISTS(SELECT 1 FROM Promotion.Pro_Dealer_PrdPurchase_Taget WHERE PolicyFactorId=A.PolicyFactorId))
	BEGIN
		SET @ErrorValue +='[ָ����Ʒ��ҵ�ɹ������]��Ҫ����ָ�꣬'
	END
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=6
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 1 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[ָ����Ʒ��ҵ�ɹ������]��Ҫָ��[��Ʒ]���أ�'
	END
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=8
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 1 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[ָ����ƷҽԺֲ����]��Ҫָ��[��Ʒ]���أ�'
	END
	
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=9
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 1 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[ָ����Ʒ��ҵ�ɹ���]��Ҫָ��[��Ʒ]���أ�'
	END
	
	IF @ifIncrement = 'Y' AND EXISTS (SELECT * FROM Promotion.PRO_POLICY_RULE A,Promotion.PRO_POLICY_FACTOR B
				WHERE A.JudgePolicyFactorId = B.PolicyFactorId AND A.PolicyId = @PolicyId AND B.FactId = 8)
			AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId=@PolicyId AND FactId=7)
	BEGIN
		SET @ErrorValue +='[ָ����ƷҽԺֲ����][��������]��Ҫͬʱ����[ָ����ƷҽԺֲ������]���أ�'
	END
	
	IF @ifIncrement = 'Y' AND EXISTS (SELECT * FROM Promotion.PRO_POLICY_RULE A,Promotion.PRO_POLICY_FACTOR B
				WHERE A.JudgePolicyFactorId = B.PolicyFactorId AND A.PolicyId = @PolicyId AND B.FactId = 9)
			AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR WHERE PolicyId=@PolicyId AND FactId=6)
	BEGIN
		SET @ErrorValue +='[ָ����Ʒ��ҵ�ɹ���][��������]��Ҫͬʱ����[ָ����Ʒ��ҵ�ɹ������]���أ�'
	END
	
	IF @YTDOption <> 'N' AND NOT EXISTS (SELECT COUNT(*) FROM Promotion.PRO_POLICY_FACTOR 
		WHERE POLICYID = @PolicyId AND FACTID IN (6,7,14,15) HAVING COUNT(*) = 1)
	BEGIN
		SET @ErrorValue +='ʹ��YTD����ʷ��������ʱ����ֻ����һ��ָ����Ʒ��������أ�'
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
		SET @ErrorValue +='ʹ��YTD����ʷ��������ʱ������ֻ�����á�Ŀ��1����'
	END
	
	/* 
	IF @CalType = 'ByDealer' AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=7
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 2 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[ָ����ƷҽԺֲ������]��Ҫָ��[ҽԺ]���أ�'
	END
	*/
	
	/*
	IF @CalType = 'ByDealer' AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR A WHERE PolicyId=@PolicyId AND FactId=8
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION B WHERE B.PolicyFactorId = A.PolicyFactorId 
			AND EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR 
				WHERE PolicyId=@PolicyId AND FactId = 2 AND PolicyFactorId = B.ConditionPolicyFactorId)))
	BEGIN
		SET @ErrorValue +='[ָ����ƷҽԺֲ����]��Ҫָ��[ҽԺ]���أ�'
	END
	*/
	
	/* ǰ�ü۸� �Ѿ���RV������INTERFACE�м�����ˣ�PROMOTION�оͲ���Ҫ������
	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY WHERE PolicyId=@PolicyId AND IsPrePrice = 'Y')
	BEGIN
		
		SET @SQL = N'SELECT @ICOUNT = COUNT(*) FROM '+@ReportTableName+' WHERE PrePrice'+@runPeriod + ' IS NULL'
 		EXEC SP_EXECUTESQL @SQL,N'@ICOUNT INT output',@ICOUNT output
 		IF @ICOUNT > 0 
			SET @ErrorValue +='��Ҫ���ñ��ڼ�ġ��Ƿ�ǰ�ü۸��ֶΣ�'
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


