USE [GenesisDMS_Test]
GO

/****** Object:  StoredProcedure [dbo].[GC_DealerPriceImportInit]    Script Date: 2019/10/21 14:06:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/**********************************************
	功能：产品价格导入
	作者：Wq
	最后更新时间：	2019-10-18
	更新记录说明：
	1.创建 2019-10-18
**********************************************/
CREATE PROCEDURE [dbo].[GC_DealerPriceImportInit] 
	@UserId NVARCHAR(36),
	@ImportType NVARCHAR(10),
	@SubCompanyId NVARCHAR(50),
	@BrandId NVARCHAR(50),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN
	 
	SET @IsValid='Success';
	
	UPDATE CFNPriceImportInit SET CFNPI_SubCompanyId=@SubCompanyId,CFNPI_BrandId=@BrandId WHERE CreateUser=@UserId
	--判断经销商账号是否可以匹配
	UPDATE cfni
	SET cfni.CFNPI_Group_ID=dm.DMA_ID,cfni.CFNPI_ChineseName=dm.DMA_ChineseName
	FROM CFNPriceImportInit cfni
	INNER JOIN DealerMaster dm ON cfni.CFNPI_SAP_Code=dm.DMA_SAP_Code
	WHERE cfni.CreateUser=@UserId
	AND ISNULL(cfni.CFNPI_SAP_Code,'') <> ''

	UPDATE CFNPriceImportInit
	SET ErrMassage = ErrMassage +';'+'经销商SAPCode无法匹配'
	WHERE CreateUser=@UserId
	AND ISNULL(CFNPI_SAP_Code,'') <> ''
	AND CFNPI_Group_ID IS NULL

	--判断UPN是否可以匹配
	UPDATE cfni
	SET cfni.CFNPI_CFN_ID=cfn.CFN_ID
	FROM CFNPriceImportInit cfni
	INNER JOIN CFN cfn ON cfni.CFNPI_CustomerFaceNbr=cfn.CFN_CustomerFaceNbr
	WHERE cfni.CreateUser=@UserId

	UPDATE CFNPriceImportInit
	SET ErrMassage = ErrMassage +';'+'产品型号无法匹配'
	WHERE CreateUser=@UserId
	AND CFNPI_CFN_ID IS NULL

	--判断优先级是否匹配
	UPDATE cfni
	SET cfni.CFNPI_LevelKey=lfd.DICT_KEY
	FROM CFNPriceImportInit cfni
	INNER JOIN Lafite_DICT lfd ON cfni.CFNPI_LevelValue=lfd.VALUE1
	WHERE cfni.CreateUser=@UserId
	AND lfd.DICT_TYPE='CONST_CFN_PriceType'

	UPDATE CFNPriceImportInit
	SET ErrMassage = ErrMassage +';'+'价格类型无法匹配'
	WHERE CreateUser=@UserId
	AND CFNPI_LevelKey IS NULL

	--判断省份是否可以匹配
	UPDATE cfni
	SET cfni.CFNPI_Province_ID=tt.TER_ID
	FROM CFNPriceImportInit cfni
	INNER JOIN Territory tt ON cfni.CFNPI_Province=tt.TER_Description AND tt.TER_Type='Province'
	WHERE cfni.CreateUser=@UserId
	AND ISNULL(cfni.CFNPI_Province,'')<>''

	UPDATE CFNPriceImportInit
	SET ErrMassage = ErrMassage +';'+'省份无法匹配'
	WHERE CreateUser=@UserId
	AND ISNULL(CFNPI_Province,'')<>''
	AND CFNPI_Province_ID IS NULL

	--判断地区是否可以匹配
	UPDATE cfni
	SET cfni.CFNPI_City_ID=tt.TER_ID
	FROM CFNPriceImportInit cfni
	INNER JOIN Territory tt ON cfni.CFNPI_City=tt.TER_Description AND tt.TER_Type='City'
	WHERE cfni.CreateUser=@UserId
	AND ISNULL(cfni.CFNPI_City,'') <> ''
	AND cfni.CFNPI_Province_ID = tt.TER_ParentID

	UPDATE CFNPriceImportInit
	SET ErrMassage = ErrMassage +';'+'地区无法匹配或省份地区关联错误'
	WHERE CreateUser=@UserId
	AND ISNULL(CFNPI_City,'') <> ''
	AND CFNPI_City_ID IS NULL

	UPDATE CFNPriceImportInit
	SET ErrMassage = ErrMassage +';'+'经销商省份不用同时填写'
	WHERE CreateUser=@UserId
	AND CFNPI_Group_ID IS NOT NULL
	AND CFNPI_Province_ID IS NOT NULL
	
	IF EXISTS(SELECT 1 FROM CFNPriceImportInit  WHERE ISNULL(ErrMassage,'')<>'' AND CreateUser=@UserId)
	BEGIN
		SET @IsValid='Error';
		RETURN;
	END
	
	IF @ImportType='Import'
	BEGIN
		INSERT INTO dbo.CFNPrice(CFNP_ID,CFNP_CFN_ID,CFNP_Group_ID,CFNP_CanOrder,CFNP_Price,
		CFNP_Market_Price,CFNP_Currency,CFNP_UOM,CFNP_ValidDateFrom,CFNP_ValidDateTo,CFNP_CreateUser,CFNP_CreateDate
		,CFNP_DeletedFlag,CFNP_SubCompanyId,CFNP_BrandId,CFNP_Province,CFNP_City,CFNP_PriceType)
		SELECT newid(),CFNPI_CFN_ID,CFNPI_Group_ID,1,CONVERT(decimal(18,6),CFNPI_Price),
		CONVERT(decimal(18,6),CFNPI_Price),'CNY','盒',
		CASE WHEN ISNULL(CFNPI_ValidDateFrom,'')='' THEN NULL ELSE CONVERT(datetime,CFNPI_ValidDateFrom) END,
		CASE WHEN ISNULL(CFNPI_ValidDateTo,'')='' THEN NULL ELSE CONVERT(datetime,CFNPI_ValidDateTo) END,
		@UserId,GETDATE(),0,@SubCompanyId,@BrandId,CFNPI_Province_ID,CFNPI_City_ID,CFNPI_LevelKey
		FROM CFNPriceImportInit
		WHERE CreateUser=@UserId;
	END
	
END 


GO


