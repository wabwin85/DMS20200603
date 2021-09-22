DROP PROCEDURE [Promotion].[Proc_Interface_ProductIndexInit] 
GO


/**********************************************
	���ܣ�У��ָ����Ʒָ��
	���ߣ�GrapeCity
	������ʱ�䣺	2015-12-23
	���¼�¼˵����
	1.���� 2015-12-23
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_ProductIndexInit] 
	@UserId NVARCHAR(36),
	@FactType NVARCHAR(20),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
	SET @IsValid='Success';
	IF @FactType='6'
	BEGIN
		UPDATE A SET ErrMsg='������SAP ACCOUNT ��д����'
		FROM Promotion.Pro_Dealer_PrdPurchase_Taget_UI A
		WHERE NOT EXISTS (SELECT 1 FROM DealerMaster B WHERE A.SAPCode=B.DMA_SAP_Code)
		AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId

		UPDATE A SET DealerId=B.DMA_ID
		FROM Promotion.Pro_Dealer_PrdPurchase_Taget_UI A
		INNER JOIN DealerMaster B ON A.SAPCode=B.DMA_SAP_Code AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='�ڼ��ʽ��д����ȷ'
		FROM Promotion.Pro_Dealer_PrdPurchase_Taget_UI A
		WHERE  ISNULL(A.ErrMsg,'')='' AND LEN(A.Period)<>6 and  LEN(A.Period)<>4 AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='Ŀ���ʽ��д����ȷ'
		FROM Promotion.Pro_Dealer_PrdPurchase_Taget_UI A
		WHERE  ISNULL(A.ErrMsg,'')='' AND LEN(A.TargetLevel)<>3 AND CurrUser=@UserId
		
		
	END
	IF @FactType='7'
	BEGIN
		UPDATE A SET ErrMsg='������SAP ACCOUNT ��д����'
		FROM Promotion.Pro_Hospital_PrdSalesTaget_UI A
		WHERE NOT EXISTS (SELECT 1 FROM DealerMaster B WHERE A.SAPCode=B.DMA_SAP_Code)
		AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId

		UPDATE A SET DealerId=B.DMA_ID
		FROM Promotion.Pro_Hospital_PrdSalesTaget_UI A
		INNER JOIN DealerMaster B ON A.SAPCode=B.DMA_SAP_Code
		
		UPDATE A SET ErrMsg='ҽԺCode��д����'
		FROM Promotion.Pro_Hospital_PrdSalesTaget_UI A
		WHERE NOT EXISTS (SELECT 1 FROM Hospital B WHERE A.HospitalId=B.HOS_Key_Account) 
		AND ISNULL(A.ErrMsg,'')='' AND ISNULL(A.HospitalId,'')<>'' AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='�ڼ��ʽ��д����ȷ'
		FROM Promotion.Pro_Hospital_PrdSalesTaget_UI A
		WHERE  ISNULL(A.ErrMsg,'')='' AND LEN(A.Period)<>6 AND LEN(A.Period)<>4 AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='Ŀ���ʽ��д����ȷ'
		FROM Promotion.Pro_Hospital_PrdSalesTaget_UI A
		WHERE  ISNULL(A.ErrMsg,'')='' AND LEN(A.TargetLevel)<>3 AND CurrUser=@UserId
	END


	IF EXISTS(SELECT 1 FROM Promotion.PRO_POLICY_TOPVALUE_UI  WHERE ISNULL(ErrMsg,'')<>'' AND CurrUser=@UserId)
	BEGIN
		SET @IsValid='Error';
	END
	 
	  
END 

GO


