DROP  Procedure [dbo].[GC_Interface_Product]
GO

/*
��Ʒ���۸�ӿڴ���
*/
CREATE Procedure [dbo].[GC_Interface_Product]
    @RtnVal NVARCHAR(20) OUTPUT
AS

SET NOCOUNT ON

BEGIN TRY

BEGIN TRAN
	SET @RtnVal = 'Success'
	
	CREATE TABLE #TMP_CFN(
		ArticleNumber nvarchar(200) collate Chinese_PRC_CI_AS null,
		CfnId uniqueidentifier,
		ChineseName nvarchar(200),
		EnglishName nvarchar(200),
		Price decimal(18,6),
		LineNbr int
	)
	
	--�ӽӿ���ʱ���в���ı�����ʱ��
	INSERT INTO #TMP_CFN (ArticleNumber,CfnId,ChineseName,EnglishName,Price,LineNbr)
	SELECT IPR_ArticleNumber,NULL,IPR_ChineseName,IPR_EnglishName,IPR_Price,IPR_LineNbr
	FROM InterfaceProduct WHERE IPR_ArticleNumber IS NOT NULL
	
	--ɾ��ArticleNumber�ظ�������
	DELETE FROM #TMP_CFN WHERE #TMP_CFN.LineNbr > (SELECT MIN(TMP.LineNbr) FROM #TMP_CFN AS TMP 
	WHERE TMP.ArticleNumber = #TMP_CFN.ArticleNumber)
	
	--�ӿڴ��ڣ�CFN�����ڵ����ݣ���������Ʒ��
	INSERT INTO CFN (CFN_ID,CFN_CustomerFaceNbr,CFN_ChineseName,CFN_EnglishName,CFN_DeletedFlag)
	SELECT NEWID(),ArticleNumber,ChineseName,EnglishName,0 
	FROM #TMP_CFN AS TMP
	WHERE NOT EXISTS (SELECT 1 FROM CFN AS A WHERE A.CFN_CustomerFaceNbr = TMP.ArticleNumber)

	--����CFNID
	UPDATE #TMP_CFN SET CfnId = CFN_ID
	FROM CFN WHERE ArticleNumber = CFN_CustomerFaceNbr
	
	--�����Ѵ��ڵĲ�Ʒ��Ϣ
	UPDATE CFN 
	SET CFN_ChineseName = ISNULL(ChineseName,CFN_ChineseName),
		CFN_EnglishName = ISNULL(EnglishName,CFN_EnglishName)
	FROM #TMP_CFN AS TMP
	WHERE TMP.CfnId = CFN.CFN_ID
	AND EXISTS (SELECT 1 FROM CFN AS A WHERE A.CFN_ID = TMP.CfnId)
	
	--�����Ѵ��ڲ�Ʒ�ļ۸�
	UPDATE CFNPRICE
	SET CFNP_Price = Price,
		CFNP_CanOrder = 1,
		CFNP_UpdateDate = GETDATE()
	FROM #TMP_CFN AS TMP
	WHERE TMP.CfnId = CFNPRICE.CFNP_CFN_ID
	AND CFNPRICE.CFNP_PriceType = 'Base'
	AND EXISTS (SELECT 1 FROM CFNPRICE AS A WHERE A.CFNP_CFN_ID = TMP.CfnId AND A.CFNP_PriceType = 'Base')
	
	--�����Ѵ��ڲ�Ʒδ���м۸񲿷�
	INSERT INTO CFNPRICE (CFNP_ID,CFNP_CFN_ID,CFNP_PriceType,CFNP_CanOrder,CFNP_Price,CFNP_CreateDate,CFNP_DeletedFlag)
	SELECT NEWID(),TMP.CfnId,'Base',1,Price,GETDATE(),0
	FROM #TMP_CFN AS TMP
	WHERE NOT EXISTS (SELECT 1 FROM CFNPRICE AS A WHERE A.CFNP_CFN_ID = TMP.CfnId AND A.CFNP_PriceType = 'Base')
	
	--CFN��������ӿ��еģ����²�Ʒ���ɶ���
	UPDATE CFNPRICE 
	SET CFNP_CanOrder = 0,
		CFNP_UpdateDate = GETDATE()
	WHERE CFNPRICE.CFNP_PriceType = 'Base'
	AND NOT EXISTS (SELECT 1 FROM #TMP_CFN AS TMP WHERE TMP.CfnId = CFNPRICE.CFNP_CFN_ID)
		
	--ע����Ϣ�еĲ�Ʒ����Ϊ׼ȷ��ʹ��ע����Ϣ���²�Ʒ����
	--Updated By Yangshaowei 2011-6-27
	UPDATE RegistrationDetail
	SET RD_ArticleNumber = LTRIM(RD_ArticleNumber)
	UPDATE RegistrationDetail
	SET RD_ArticleNumber = RTRIM(RD_ArticleNumber)
	
	UPDATE dbo.CFN
	SET CFN_ChineseName = x.rd_chineseName,
	CFN_Property1 = x.RD_Specification,
	CFN_Implant = 
	CASE x.RD_Implant
	WHEN '��' THEN 1
	WHEN '��' THEN 0
	ELSE NULL
	END,
	CFN_LastModifiedDate = getdate(),
	CFN_LastModifiedBy_USR_UserID = 'b3c064c1-902e-44c1-8a5a-b0bc569cd80f'
	FROM cfn a,RegistrationDetail x
	WHERE a.CFN_CustomerFaceNbr = x.RD_ArticleNumber



COMMIT TRAN

	--��¼�ɹ���־
	exec dbo.GC_Interface_Log 'Product','Success',''	

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
	
	--��¼������־��ʼ
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '��'+convert(nvarchar(10),@error_line)+'����[�����'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	exec dbo.GC_Interface_Log 'Product','Failure',@vError
	
    return -1
    
END CATCH
GO


