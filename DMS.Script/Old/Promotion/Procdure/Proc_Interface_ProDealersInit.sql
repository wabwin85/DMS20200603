DROP PROCEDURE [Promotion].[Proc_Interface_ProDealersInit] 
GO


/**********************************************
	功能：校验经销商
	作者：GrapeCity
	最后更新时间：	2016-02-02
	更新记录说明：
	1.创建 2016-02-02
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_ProDealersInit] 
	@UserId NVARCHAR(36),
	@ProductLinId NVARCHAR(50),
	@SubBU NVARCHAR(50),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
	SET @IsValid='Success';
	
	--判断Code是否正确
	UPDATE A SET ErrMsg='经销商SAP ACCOUNT填写错误'
	FROM Promotion.PRO_DEALER_Input_UI A
	WHERE NOT EXISTS (SELECT 1 FROM DealerMaster B WHERE A.SAPCode=B.DMA_SAP_Code) 
	AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
	
	--判断经销商是否授权
	IF ISNULL(@SubBU,'')=''
	BEGIN
		UPDATE A SET ErrMsg='经销商未被授权不能添加'
		FROM Promotion.PRO_DEALER_Input_UI A,DealerMaster C
		WHERE  C.DMA_SAP_Code=A.SAPCode
		AND NOT EXISTS (SELECT 1 FROM V_DealerContractMaster B WHERE B.ActiveFlag=1 AND B.DMA_ID=C.DMA_ID AND CONVERT(NVARCHAR(10),B.Division) IN (SELECT D.DivisionCode FROM V_DivisionProductLineRelation D WHERE D.ProductLineID=@ProductLinId) ) 
		AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
	
	END
	ELSE
	BEGIN
		UPDATE A SET ErrMsg='经销商未被授权不能添加'
		FROM Promotion.PRO_DEALER_Input_UI A,DealerMaster C
		WHERE  C.DMA_SAP_Code=A.SAPCode
		AND NOT EXISTS (SELECT 1 FROM V_DealerContractMaster B WHERE B.ActiveFlag=1 AND B.DMA_ID=C.DMA_ID AND CONVERT(NVARCHAR(36),B.CC_ID) IN (SELECT D.CC_ID FROM interface.ClassificationContract D WHERE D.CC_Code=@SubBU) ) 
		AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
	END
	
	
	IF EXISTS(SELECT 1 FROM Promotion.PRO_DEALER_Input_UI  WHERE ISNULL(ErrMsg,'')<>'' AND CurrUser=@UserId)
	BEGIN
	SET @IsValid='Error';
	END
	 
	  
END 

GO


