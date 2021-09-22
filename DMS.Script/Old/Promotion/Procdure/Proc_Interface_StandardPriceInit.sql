DROP PROCEDURE [Promotion].[Proc_Interface_StandardPriceInit] 
GO


/**********************************************
	���ܣ�У�����߲�Ʒ�۲��ϴ��Ƿ���ȷ
	���ߣ�GrapeCity
	������ʱ�䣺	2016-05-29
	���¼�¼˵����
	1.���� 2016-05-29
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_StandardPriceInit] 
	@UserId NVARCHAR(36),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
	SET @IsValid='Success';

	UPDATE A SET ErrMsg='������SAP ACCOUNT����Ϊ��'
	FROM Promotion.Pro_Dealer_Std_Point_UI A WHERE ISNULL(A.SAPCode,'')=''  AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId ;
	
	UPDATE A SET  A.DealerId= b.DMA_ID  
	FROM Promotion.Pro_Dealer_Std_Point_UI A ,DEALERMASTER B WHERE A.SAPCode=B.DMA_SAP_CODE AND CurrUser=@UserId  
	
	UPDATE A SET ErrMsg='������SAP ACCOUNT��д����ȷ'
	FROM Promotion.Pro_Dealer_Std_Point_UI A WHERE A.DealerId IS NULL AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId ;
	
	  
	  IF EXISTS(SELECT 1 FROM Promotion.Pro_Dealer_Std_Point_UI  WHERE ISNULL(ErrMsg,'')<>'' AND CurrUser=@UserId)
	  BEGIN
		SET @IsValid='Error';
	  END
	 
	 
	  
END 

GO


