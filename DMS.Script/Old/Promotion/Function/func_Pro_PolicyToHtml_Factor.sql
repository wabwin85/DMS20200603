DROP FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor]
GO

CREATE FUNCTION [Promotion].[func_Pro_PolicyToHtml_Factor](
	@PolicyFactId INT
	)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
	DECLARE @FactId INT;
	
	SELECT @FactId = FactId from Promotion.PRO_POLICY_FACTOR WHERE PolicyFactorId = @PolicyFactId
	
	--û����������:��Ʒ����ҵ�ɹ������\��Ʒ��ҽԺֲ������\��Ʒ����ҵ�ɹ��ܽ��\��Ʒ��ҽԺֲ���ܽ�� 
	IF @FactId IN (4,5,10,11) 
		SET @SQL = ''
		
	IF @FactId = 1	--��Ʒ
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_Product(@PolicyFactId, null)
		
	IF @FactId = 2	--ҽԺ
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_Hospital(@PolicyFactId, null)
	
	IF @FactId = 3	--������
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_Dealer(@PolicyFactId)
		
	IF @FactId in (6,14)	--ָ����Ʒ��ҵ�ɹ������
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdPurchaseRate(@PolicyFactId)
		
	IF @FactId in (7,15)	--ָ����ƷҽԺֲ������
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdSalesRate(@PolicyFactId)
			
	IF @FactId = 8	--ָ����ƷҽԺֲ����
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdSalesQuantity(@PolicyFactId)
		
	IF @FactId = 9	--ָ����Ʒ��ҵ�ɹ���
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdPurchaseQuantity(@PolicyFactId)
			
	IF @FactId = 12	--ָ����ƷҽԺֲ����
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdSalesAmount(@PolicyFactId)	
		
	IF @FactId = 13	--ָ����ƷҽԺֲ����
		SET @SQL = Promotion.func_Pro_PolicyToHtml_Factor_PrdPurchaseAmount(@PolicyFactId)	
				
	
	RETURN @SQL
END


GO


