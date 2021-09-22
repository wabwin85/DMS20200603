DROP PROCEDURE [Promotion].[Proc_Interface_PolicySubmitCheck]
GO


/**********************************************
	���ܣ������߱���ǰУ��
	���ߣ�GrapeCity
	������ʱ�䣺	2015-11-01
	���¼�¼˵����
	1.���� 2015-11-01
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
 	
 	--ֻ�С��ݸ塱�����ߡ������˻ز��Ҵ���û�м�����������ߣ�����Ҫ����У�顣
 	--����������������������ֱ������������Ϊ���������ֻ�����޸ľ����̻���ҽԺ�����ݣ���������߲����淶�Խ����޸ģ�
 	IF NOT (@STATUS = '�ݸ�' OR (@STATUS ='�����˻�' AND ISNULL(@CurrentPeriod,'') = ''))
 	BEGIN
 		SET @Result = 'Success' 
 		RETURN
 	END
 	
 	--ȡ��UI���е����߲���
 	SELECT 
 		@TopType = TopType,
 		@PolicyStyle = PolicyStyle,
 		@PointUseRange = PointUseRange,
 		@SubBu = SubBu,
		@PolicyStyle = PolicyStyle,
		@PolicySubStyle = PolicySubStyle,
		@CalType=CalType
 	FROM Promotion.PRO_POLICY_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId
 	
 	
 	--�����зⶥ��û�����÷ⶥ��
 	IF @TopType IN ('Dealer','Hospital','DealerPeriod','HospitalPeriod') 
 		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_TOPVALUE_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = '��������Ҫ���÷ⶥ���뵼�����ݣ�' 
 		RETURN
 	END
 	
 	--���߾����̱�û������
 	IF @CalType<>'ByHospital'
 	BEGIN
 	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_DEALER_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId )
 	BEGIN
 		SET @Result = '�����ñ������漰�ľ����̣�' 
 		RETURN
 	END
 	END
 	
 	--û�������κ�����
 	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = '�����ñ������漰�����أ�' 
 		RETURN
 	END
 	
 	--����ǲ�Ʒ���أ�Ҫ����Լ������
 	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_UI A WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND FactId = 1
 		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION_UI WHERE CurrUser = @UserId AND PolicyFactorId = A.PolicyFactorId))
 	BEGIN
 		SET @Result = '��Ϊ����Ʒ���ء�����Լ��������' 
 		RETURN
 	END
 		
 	--�����ҽԺ���أ�Ҫ����Լ������
 	IF EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_UI A WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND FactId = 2
 		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_CONDITION_UI WHERE CurrUser = @UserId AND PolicyFactorId = A.PolicyFactorId))
 	BEGIN
 		SET @Result = '��Ϊ��ҽԺ���ء�����Լ��������' 
 		RETURN
 	END
 	
 	--ָ����Ʒ��ҵ�ɹ�����ʣ�û�����ù����Ĳ�Ʒ����
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (6) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 1 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '��ָ����Ʒ��ҵ�ɹ�����ʡ���Ҫ��������Ʒ���ء���' 
 		RETURN
 	END
 	
 	--ָ����Ʒ��ҵ�ɹ�����ʣ�û�����þ����ָ���
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (6) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.Pro_Dealer_PrdPurchase_Taget_UI WHERE CurrUser = @UserId AND PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '��ָ����Ʒ��ҵ�ɹ�����ʡ���Ҫ����ָ�꣡' 
 		RETURN
 	END
 	
 	--ָ����ƷҽԺֲ�����ʣ�û�����ù����Ĳ�Ʒ����
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (7) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 1 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '��ָ����ƷҽԺֲ�����ʡ���Ҫ��������Ʒ���ء���' 
 		RETURN
 	END
 	
 	--ָ����ƷҽԺֲ�����ʣ�û�����ù�����ҽԺ����
 	/*
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (7) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 2 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '��ָ����ƷҽԺֲ�����ʡ���Ҫ������ҽԺ���ء���' 
 		RETURN
 	END
 	*/
 	
 	--ָ����ƷҽԺֲ�����ʣ�û�����þ����ָ���
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (7) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.Pro_Hospital_PrdSalesTaget_UI WHERE CurrUser = @UserId AND PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '��ָ����ƷҽԺֲ�����ʡ���Ҫ����ָ�꣡' 
 		RETURN
 	END
	
 	--ָ����ƷҽԺֲ������û�����ù����Ĳ�Ʒ����
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (8) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 1 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '��ָ����ƷҽԺֲ��������Ҫ��������Ʒ���ء���' 
 		RETURN
 	END
 	
 	--ָ����ƷҽԺֲ������û�����ù�����ҽԺ����
 	/*
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (8) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 2 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '��ָ����ƷҽԺֲ��������Ҫ������ҽԺ���ء���' 
 		RETURN
 	END
 	*/
 	
 	--ָ����Ʒ��ҵ�ɹ�����û�����ù����Ĳ�Ʒ����
 	IF EXISTS (SELECT * FROM Promotion.PRO_POLICY_FACTOR_UI a WHERE PolicyId = @POLICYID AND CurrUser = @UserId AND a.FactId IN (9) 
		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_FACTOR_RELATION_UI b,Promotion.PRO_POLICY_FACTOR_UI c 
			WHERE b.CurrUser = @UserId AND C.CurrUser = @UserId AND B.ConditionPolicyFactorId = C.PolicyFactorId AND C.FactId = 1 AND b.PolicyFactorId = a.PolicyFactorId))
 	BEGIN
 		SET @Result = '��ָ����Ʒ��ҵ�ɹ�������Ҫ��������Ʒ���ء���' 
 		RETURN
 	END
 	
 	--���û�ж�Ӧ�Ĺ������ã���ʾ�û��Ƿ������ǲ��ּ��������.���ǿ����ύ������
 	IF NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_RULE_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = 'Half' 
 		RETURN 
 	END
 	
 	--û��ָ����Ʒ
 	IF (@PolicyStyle = '��Ʒ' OR @PolicySubStyle = '������Ʒת����') 
 		AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_LARGESS_UI WHERE GiftPolicyFactorId IS NOT NULL AND PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = '��ѡ��ĳ����Ʒ������Ϊ��Ʒ��' 
 		RETURN
 	END
 	
 	--û��ָ������ʹ�÷�Χ
 	IF @PolicyStyle = '����' 
 	AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_POLICY_LARGESS_UI WHERE UseRangePolicyFactorId IS NOT NULL AND PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = '��ѡ��ĳ����Ʒ������Ϊ����ʹ�÷�Χ��' 
 		RETURN
 	END
 	 	
 	IF @PolicyStyle = '��ʱ����' AND NOT EXISTS (SELECT 1 FROM Promotion.PRO_DEALER_UI WHERE PolicyId = @POLICYID AND CurrUser = @UserId)
 	BEGIN
 		SET @Result = '��ʱ�������߱���ָ�������̣�' 
 		RETURN
 	END
 	 	
	SET @Result = 'Success' 
END  

GO


