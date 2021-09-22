DROP PROCEDURE [Promotion].[Proc_Pro_Cal_Fact] 
GO

CREATE PROCEDURE [Promotion].[Proc_Pro_Cal_Fact] 
	@PolicyFactorId Int	--�������ر��
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
	
	
	--��Ʒ����ҵ�ɹ������
	IF @FactId = '4'	EXEC Promotion.Proc_Pro_Cal_SubBuPurchaseRate @PolicyFactorId
		
	--��Ʒ��ҽԺֲ������
	IF @FactId = '5'	EXEC Promotion.Proc_Pro_Cal_SubBuSalesRate @PolicyFactorId
	
	--ָ����Ʒ��ҵ�ɹ������
	IF @FactId = '6'	EXEC Promotion.Proc_Pro_Cal_PrdPurchaseRate @PolicyFactorId	
	
	--ָ����ƷҽԺֲ������
	IF @FactId = '7'	EXEC Promotion.Proc_Pro_Cal_PrdSalesRate @PolicyFactorId	
		
	--ָ����ƷҽԺֲ����
	IF @FactId = '8'	EXEC Promotion.Proc_Pro_Cal_PrdSalesQuantity @PolicyFactorId	
	
	--ָ����Ʒ��ҵ�ɹ���
	IF @FactId = '9'	EXEC Promotion.Proc_Pro_Cal_PrdPurchaseQuantity @PolicyFactorId	
	
	--��Ʒ����ҵ�ɹ��ܽ��
	IF @FactId = '10'	EXEC Promotion.Proc_Pro_Cal_SubBuPurchaseAmount @PolicyFactorId	
	
	--��Ʒ��ҽԺֲ���ܽ��
	IF @FactId = '11'	EXEC Promotion.Proc_Pro_Cal_SubBuSalesAmount @PolicyFactorId	
	
	--ָ����ƷҽԺֲ����
	IF @FactId = '12'	EXEC Promotion.Proc_Pro_Cal_PrdSalesAmount @PolicyFactorId	
	
	--ָ����Ʒ��ҵ�ɹ����
	IF @FactId = '13'	EXEC Promotion.Proc_Pro_Cal_PrdPurchaseAmount @PolicyFactorId	
	
	--ָ����Ʒ��ҵ�ɹ��������
	IF @FactId = '14'	EXEC Promotion.Proc_Pro_Cal_PrdPurchaseAmountRate @PolicyFactorId	
	
	--ָ����ƷҽԺֲ��������
	IF @FactId = '15'	EXEC Promotion.Proc_Pro_Cal_PrdSalesAmountRate @PolicyFactorId	
	
END  

GO


