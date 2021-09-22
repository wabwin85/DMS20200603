DROP PROCEDURE [Promotion].[Proc_Interface_ProDealersInit] 
GO


/**********************************************
	���ܣ�У�龭����
	���ߣ�GrapeCity
	������ʱ�䣺	2016-02-02
	���¼�¼˵����
	1.���� 2016-02-02
**********************************************/
CREATE PROCEDURE [Promotion].[Proc_Interface_ProDealersInit] 
	@UserId NVARCHAR(36),
	@ProductLinId NVARCHAR(50),
	@SubBU NVARCHAR(50),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN 
	SET @IsValid='Success';
	
	--�ж�Code�Ƿ���ȷ
	UPDATE A SET ErrMsg='������SAP ACCOUNT��д����'
	FROM Promotion.PRO_DEALER_Input_UI A
	WHERE NOT EXISTS (SELECT 1 FROM DealerMaster B WHERE A.SAPCode=B.DMA_SAP_Code) 
	AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
	
	--�жϾ������Ƿ���Ȩ
	IF ISNULL(@SubBU,'')=''
	BEGIN
		UPDATE A SET ErrMsg='������δ����Ȩ�������'
		FROM Promotion.PRO_DEALER_Input_UI A,DealerMaster C
		WHERE  C.DMA_SAP_Code=A.SAPCode
		AND NOT EXISTS (SELECT 1 FROM V_DealerContractMaster B WHERE B.ActiveFlag=1 AND B.DMA_ID=C.DMA_ID AND CONVERT(NVARCHAR(10),B.Division) IN (SELECT D.DivisionCode FROM V_DivisionProductLineRelation D WHERE D.ProductLineID=@ProductLinId) ) 
		AND ISNULL(A.ErrMsg,'')='' AND CurrUser=@UserId
	
	END
	ELSE
	BEGIN
		UPDATE A SET ErrMsg='������δ����Ȩ�������'
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


