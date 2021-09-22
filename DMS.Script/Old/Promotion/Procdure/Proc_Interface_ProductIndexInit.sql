DROP PROCEDURE [Promotion].[Proc_Interface_ProductIndexInit] 
GO


/**********************************************
	功能：校验指定产品指标
	作者：GrapeCity
	最后更新时间：	2015-12-23
	更新记录说明：
	1.创建 2015-12-23
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
		UPDATE A SET ErrMsg='经销商SAP ACCOUNT 填写错误'
		FROM Promotion.Pro_Dealer_PrdPurchase_Taget_UI A
		WHERE NOT EXISTS (SELECT 1 FROM DealerMaster B WHERE A.SAPCode=B.DMA_SAP_Code)
		AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId

		UPDATE A SET DealerId=B.DMA_ID
		FROM Promotion.Pro_Dealer_PrdPurchase_Taget_UI A
		INNER JOIN DealerMaster B ON A.SAPCode=B.DMA_SAP_Code AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='期间格式填写不正确'
		FROM Promotion.Pro_Dealer_PrdPurchase_Taget_UI A
		WHERE  ISNULL(A.ErrMsg,'')='' AND LEN(A.Period)<>6 and  LEN(A.Period)<>4 AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='目标格式填写不正确'
		FROM Promotion.Pro_Dealer_PrdPurchase_Taget_UI A
		WHERE  ISNULL(A.ErrMsg,'')='' AND LEN(A.TargetLevel)<>3 AND CurrUser=@UserId
		
		
	END
	IF @FactType='7'
	BEGIN
		UPDATE A SET ErrMsg='经销商SAP ACCOUNT 填写错误'
		FROM Promotion.Pro_Hospital_PrdSalesTaget_UI A
		WHERE NOT EXISTS (SELECT 1 FROM DealerMaster B WHERE A.SAPCode=B.DMA_SAP_Code)
		AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId

		UPDATE A SET DealerId=B.DMA_ID
		FROM Promotion.Pro_Hospital_PrdSalesTaget_UI A
		INNER JOIN DealerMaster B ON A.SAPCode=B.DMA_SAP_Code
		
		UPDATE A SET ErrMsg='医院Code填写错误'
		FROM Promotion.Pro_Hospital_PrdSalesTaget_UI A
		WHERE NOT EXISTS (SELECT 1 FROM Hospital B WHERE A.HospitalId=B.HOS_Key_Account) 
		AND ISNULL(A.ErrMsg,'')='' AND ISNULL(A.HospitalId,'')<>'' AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='期间格式填写不正确'
		FROM Promotion.Pro_Hospital_PrdSalesTaget_UI A
		WHERE  ISNULL(A.ErrMsg,'')='' AND LEN(A.Period)<>6 AND LEN(A.Period)<>4 AND CurrUser=@UserId
		
		UPDATE A SET ErrMsg='目标格式填写不正确'
		FROM Promotion.Pro_Hospital_PrdSalesTaget_UI A
		WHERE  ISNULL(A.ErrMsg,'')='' AND LEN(A.TargetLevel)<>3 AND CurrUser=@UserId
	END


	IF EXISTS(SELECT 1 FROM Promotion.PRO_POLICY_TOPVALUE_UI  WHERE ISNULL(ErrMsg,'')<>'' AND CurrUser=@UserId)
	BEGIN
		SET @IsValid='Error';
	END
	 
	  
END 

GO


