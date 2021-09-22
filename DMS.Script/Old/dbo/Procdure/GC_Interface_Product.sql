DROP  Procedure [dbo].[GC_Interface_Product]
GO

/*
产品及价格接口处理
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
	
	--从接口临时表中插入的本地临时表
	INSERT INTO #TMP_CFN (ArticleNumber,CfnId,ChineseName,EnglishName,Price,LineNbr)
	SELECT IPR_ArticleNumber,NULL,IPR_ChineseName,IPR_EnglishName,IPR_Price,IPR_LineNbr
	FROM InterfaceProduct WHERE IPR_ArticleNumber IS NOT NULL
	
	--删除ArticleNumber重复的数据
	DELETE FROM #TMP_CFN WHERE #TMP_CFN.LineNbr > (SELECT MIN(TMP.LineNbr) FROM #TMP_CFN AS TMP 
	WHERE TMP.ArticleNumber = #TMP_CFN.ArticleNumber)
	
	--接口存在，CFN不存在的数据，新增到产品表
	INSERT INTO CFN (CFN_ID,CFN_CustomerFaceNbr,CFN_ChineseName,CFN_EnglishName,CFN_DeletedFlag)
	SELECT NEWID(),ArticleNumber,ChineseName,EnglishName,0 
	FROM #TMP_CFN AS TMP
	WHERE NOT EXISTS (SELECT 1 FROM CFN AS A WHERE A.CFN_CustomerFaceNbr = TMP.ArticleNumber)

	--更新CFNID
	UPDATE #TMP_CFN SET CfnId = CFN_ID
	FROM CFN WHERE ArticleNumber = CFN_CustomerFaceNbr
	
	--更新已存在的产品信息
	UPDATE CFN 
	SET CFN_ChineseName = ISNULL(ChineseName,CFN_ChineseName),
		CFN_EnglishName = ISNULL(EnglishName,CFN_EnglishName)
	FROM #TMP_CFN AS TMP
	WHERE TMP.CfnId = CFN.CFN_ID
	AND EXISTS (SELECT 1 FROM CFN AS A WHERE A.CFN_ID = TMP.CfnId)
	
	--更新已存在产品的价格
	UPDATE CFNPRICE
	SET CFNP_Price = Price,
		CFNP_CanOrder = 1,
		CFNP_UpdateDate = GETDATE()
	FROM #TMP_CFN AS TMP
	WHERE TMP.CfnId = CFNPRICE.CFNP_CFN_ID
	AND CFNPRICE.CFNP_PriceType = 'Base'
	AND EXISTS (SELECT 1 FROM CFNPRICE AS A WHERE A.CFNP_CFN_ID = TMP.CfnId AND A.CFNP_PriceType = 'Base')
	
	--更新已存在产品未曾有价格部分
	INSERT INTO CFNPRICE (CFNP_ID,CFNP_CFN_ID,CFNP_PriceType,CFNP_CanOrder,CFNP_Price,CFNP_CreateDate,CFNP_DeletedFlag)
	SELECT NEWID(),TMP.CfnId,'Base',1,Price,GETDATE(),0
	FROM #TMP_CFN AS TMP
	WHERE NOT EXISTS (SELECT 1 FROM CFNPRICE AS A WHERE A.CFNP_CFN_ID = TMP.CfnId AND A.CFNP_PriceType = 'Base')
	
	--CFN不存在与接口中的，更新产品不可订购
	UPDATE CFNPRICE 
	SET CFNP_CanOrder = 0,
		CFNP_UpdateDate = GETDATE()
	WHERE CFNPRICE.CFNP_PriceType = 'Base'
	AND NOT EXISTS (SELECT 1 FROM #TMP_CFN AS TMP WHERE TMP.CfnId = CFNPRICE.CFNP_CFN_ID)
		
	--注册信息中的产品名较为准确，使用注册信息更新产品名称
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
	WHEN '是' THEN 1
	WHEN '否' THEN 0
	ELSE NULL
	END,
	CFN_LastModifiedDate = getdate(),
	CFN_LastModifiedBy_USR_UserID = 'b3c064c1-902e-44c1-8a5a-b0bc569cd80f'
	FROM cfn a,RegistrationDetail x
	WHERE a.CFN_CustomerFaceNbr = x.RD_ArticleNumber



COMMIT TRAN

	--记录成功日志
	exec dbo.GC_Interface_Log 'Product','Success',''	

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @RtnVal = 'Failure'
	
	--记录错误日志开始
	declare @error_line int
	declare @error_number int
	declare @error_message nvarchar(256)
	declare @vError nvarchar(1000)
	set @error_line = ERROR_LINE()
	set @error_number = ERROR_NUMBER()
	set @error_message = ERROR_MESSAGE()
	set @vError = '行'+convert(nvarchar(10),@error_line)+'出错[错误号'+convert(nvarchar(10),@error_number)+'],'+@error_message	
	exec dbo.GC_Interface_Log 'Product','Failure',@vError
	
    return -1
    
END CATCH
GO


