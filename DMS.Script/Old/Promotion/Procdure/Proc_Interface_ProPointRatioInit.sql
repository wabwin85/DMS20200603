DROP PROCEDURE [Promotion].[Proc_Interface_ProPointRatioInit]
GO


/**********************************************
	���ܣ�У�����߼Ӽ���
	���ߣ�GrapeCity
	������ʱ�䣺	2015-12-23
	���¼�¼˵����
	1.���� 2015-12-23
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_ProPointRatioInit] 
	@UserId NVARCHAR(36),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
	SET @IsValid='Success';

	UPDATE A SET ErrMsg='������SAP ACCOUNT����Ϊ��'
	FROM Promotion.PRO_POLICY_POINTRATIO_UI A WHERE ISNULL(A.SAPCode,'')=''  AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId ;
	
	UPDATE A SET ErrMsg='�Ӽ��ʲ���Ϊ��'
	FROM Promotion.PRO_POLICY_POINTRATIO_UI A WHERE ISNULL(A.Ratio,-100)=-100  AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId ;
	
	UPDATE A SET  A.DealerId= b.DMA_ID  
	FROM Promotion.PRO_POLICY_POINTRATIO_UI A ,DEALERMASTER B WHERE A.SAPCode=B.DMA_SAP_CODE AND CurrUser=@UserId  
	
	UPDATE A SET ErrMsg='������SAP ACCOUNT��д����ȷ'
	FROM Promotion.PRO_POLICY_POINTRATIO_UI A WHERE A.DealerId IS NULL AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId ;
	
	  
	  
	  
	  IF EXISTS(SELECT 1 FROM Promotion.PRO_POLICY_POINTRATIO_UI  WHERE ISNULL(ErrMsg,'')<>'' AND CurrUser=@UserId)
	  BEGIN
		SET @IsValid='Error';
	  END
	 
	 
	  
END 

GO


