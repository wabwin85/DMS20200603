DROP PROCEDURE [Promotion].[Proc_Interface_StandardPriceInit] 
GO


/**********************************************
	功能：校验政策产品价差上传是否正确
	作者：GrapeCity
	最后更新时间：	2016-05-29
	更新记录说明：
	1.创建 2016-05-29
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_StandardPriceInit] 
	@UserId NVARCHAR(36),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
	SET @IsValid='Success';

	UPDATE A SET ErrMsg='经销商SAP ACCOUNT不能为空'
	FROM Promotion.Pro_Dealer_Std_Point_UI A WHERE ISNULL(A.SAPCode,'')=''  AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId ;
	
	UPDATE A SET  A.DealerId= b.DMA_ID  
	FROM Promotion.Pro_Dealer_Std_Point_UI A ,DEALERMASTER B WHERE A.SAPCode=B.DMA_SAP_CODE AND CurrUser=@UserId  
	
	UPDATE A SET ErrMsg='经销商SAP ACCOUNT填写不正确'
	FROM Promotion.Pro_Dealer_Std_Point_UI A WHERE A.DealerId IS NULL AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId ;
	
	  
	  IF EXISTS(SELECT 1 FROM Promotion.Pro_Dealer_Std_Point_UI  WHERE ISNULL(ErrMsg,'')<>'' AND CurrUser=@UserId)
	  BEGIN
		SET @IsValid='Error';
	  END
	 
	 
	  
END 

GO


