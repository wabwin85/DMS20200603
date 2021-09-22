USE [GenesisDMS_PRD]
GO

/****** Object:  StoredProcedure [dbo].[GC_AOPHospitalReferenceImportInit]    Script Date: 2020/2/25 9:02:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/**********************************************
	功能：医院标准指标导入
	作者：Wq
	最后更新时间：	2020-02-24
	更新记录说明：
	1.创建 2019-10-18
**********************************************/
CREATE PROCEDURE [dbo].[GC_AOPHospitalReferenceImportInit] 
	@UserId NVARCHAR(36),
	@ImportType NVARCHAR(10),
	@IsValid NVARCHAR(100) OUTPUT
AS
BEGIN
	 
	SET @IsValid='Success';
	DECLARE @isLPDealerUser BIT=0;
	DECLARE @isUser BIT=0;
	DECLARE @DealerId UNIQUEIDENTIFIER;
	
	--匹配分子公司
	UPDATE aophri
	SET aophri.AOPHRI_SubCompanyId=vp.SubCompanyId
	FROM AOPHospitalReferenceImport aophri
	INNER JOIN View_ProductLine vp ON aophri.AOPHRI_SubCompanyName=vp.SubCompanyName
	WHERE aophri.AOPHRI_Update_User_ID=@UserId

	UPDATE AOPHospitalReferenceImport SET AOPHRI_ErrMassage='分子公司不正确；' 
	WHERE AOPHRI_SubCompanyId IS NULL AND AOPHRI_Update_User_ID=@UserId
	--匹配品牌
	UPDATE aophri
	SET aophri.AOPHRI_BrandId=vp.BrandId
	FROM AOPHospitalReferenceImport aophri
	INNER JOIN View_ProductLine vp ON aophri.AOPHRI_BrandName=vp.BrandName AND aophri.AOPHRI_SubCompanyId=vp.SubCompanyId
	WHERE aophri.AOPHRI_Update_User_ID=@UserId AND ISNULL(AOPHRI_ErrMassage,'')=''

	UPDATE AOPHospitalReferenceImport SET AOPHRI_ErrMassage='品牌不正确或品牌与分子公司不匹配；' 
	WHERE AOPHRI_BrandId IS NULL AND AOPHRI_Update_User_ID=@UserId AND ISNULL(AOPHRI_ErrMassage,'')=''
	--匹配产品线
	UPDATE aophri
	SET aophri.AOPHRI_ProductLine_BUM_ID=vp.Id
	FROM AOPHospitalReferenceImport aophri
	INNER JOIN View_ProductLine vp ON aophri.AOPHRI_BrandId=vp.BrandId AND aophri.AOPHRI_SubCompanyId=vp.SubCompanyId
	AND aophri.AOPHRI_ProductLineName = vp.Attribute_Name
	WHERE aophri.AOPHRI_Update_User_ID=@UserId AND ISNULL(AOPHRI_ErrMassage,'')=''

	UPDATE AOPHospitalReferenceImport SET AOPHRI_ErrMassage='产品线不正确或产品线与品牌或分子公司不匹配；' 
	WHERE AOPHRI_ProductLine_BUM_ID IS NULL AND AOPHRI_Update_User_ID=@UserId AND ISNULL(AOPHRI_ErrMassage,'')=''
	--匹配产品分类
	UPDATE aophri
	SET aophri.AOPHRI_PCT_ID=cpcs.CQ_ID,aophri.AOPHRI_DivisionID=cpcs.CC_Division
	FROM AOPHospitalReferenceImport aophri
	INNER JOIN V_ProductClassificationStructure cpcs ON aophri.AOPHRI_PCTName=cpcs.CQ_NameCN AND aophri.AOPHRI_ProductLine_BUM_ID=cpcs.CC_ProductLineID
	WHERE aophri.AOPHRI_Update_User_ID=@UserId AND ISNULL(AOPHRI_ErrMassage,'')=''

	UPDATE AOPHospitalReferenceImport SET AOPHRI_ErrMassage='产品分类不正确或产品分类与产品线不匹配；' 
	WHERE AOPHRI_PCT_ID IS NULL AND AOPHRI_Update_User_ID=@UserId AND ISNULL(AOPHRI_ErrMassage,'')=''
	--匹配医院
	UPDATE aophri
	SET aophri.AOPHRI_Hospital_ID=hos.HOS_ID,aophri.AOPHRI_HospitalNbr=hos.HOS_Key_Account
	FROM AOPHospitalReferenceImport aophri
	INNER JOIN Hospital hos ON aophri.AOPHRI_HospitalName=hos.HOS_HospitalName
	WHERE aophri.AOPHRI_Update_User_ID=@UserId AND ISNULL(AOPHRI_ErrMassage,'')=''

	UPDATE AOPHospitalReferenceImport SET AOPHRI_ErrMassage='医院名称不正确；' 
	WHERE AOPHRI_Hospital_ID IS NULL AND AOPHRI_Update_User_ID=@UserId AND ISNULL(AOPHRI_ErrMassage,'')=''

	
	IF EXISTS(SELECT 1 FROM AOPHospitalReferenceImport  WHERE ISNULL(AOPHRI_ErrMassage,'')<>'' AND AOPHRI_Update_User_ID=@UserId)
	BEGIN
		SET @IsValid='Error';
		RETURN;
	END
	
	IF @ImportType='Import'
	BEGIN
		INSERT INTO [dbo].[AOPHospitalReference]
           ([AOPHR_ID]
           ,[AOPHR_ProductLine_BUM_ID]
           ,[AOPHR_Year]
           ,[AOPHR_Hospital_ID]
           ,[AOPHR_January]
           ,[AOPHR_February]
           ,[AOPHR_March]
           ,[AOPHR_April]
           ,[AOPHR_May]
           ,[AOPHR_June]
           ,[AOPHR_July]
           ,[AOPHR_August]
           ,[AOPHR_September]
           ,[AOPHR_October]
           ,[AOPHR_November]
           ,[AOPHR_December]
           ,[AOPHR_Update_User_ID]
           ,[AOPHR_Update_Date]
           ,[AOPHR_PCT_ID])
		SELECT newid()
           ,[AOPHRI_ProductLine_BUM_ID]
           ,[AOPHRI_Year]
           ,[AOPHRI_Hospital_ID]
           ,[AOPHRI_January]
           ,[AOPHRI_February]
           ,[AOPHRI_March]
           ,[AOPHRI_April]
           ,[AOPHRI_May]
           ,[AOPHRI_June]
           ,[AOPHRI_July]
           ,[AOPHRI_August]
           ,[AOPHRI_September]
           ,[AOPHRI_October]
           ,[AOPHRI_November]
           ,[AOPHRI_December]
           ,[AOPHRI_Update_User_ID]
           ,[AOPHRI_Update_Date]
           ,[AOPHRI_PCT_ID]
		FROM AOPHospitalReferenceImport
		WHERE AOPHRI_Update_User_ID=@UserId
		AND NOT EXISTS(
			SELECT 1 FROM AOPHospitalReference WHERE AOPHRI_ProductLine_BUM_ID=AOPHR_ProductLine_BUM_ID
			AND AOPHRI_Year = AOPHR_Year AND AOPHRI_Hospital_ID = AOPHR_Hospital_ID AND AOPHRI_PCT_ID=AOPHR_PCT_ID
		)

		UPDATE aphr
		SET [AOPHR_January]=AOPHRI_January
           ,[AOPHR_February]=[AOPHRI_February]
           ,[AOPHR_March]=[AOPHRI_March]
           ,[AOPHR_April]=[AOPHRI_April]
           ,[AOPHR_May]=[AOPHRI_May]
           ,[AOPHR_June]=[AOPHRI_June]
           ,[AOPHR_July]=[AOPHRI_July]
           ,[AOPHR_August]=[AOPHRI_August]
           ,[AOPHR_September]=[AOPHRI_September]
           ,[AOPHR_October]=[AOPHRI_October]
           ,[AOPHR_November]=[AOPHRI_November]
           ,[AOPHR_December]=[AOPHRI_December]
           ,[AOPHR_Update_User_ID]=[AOPHRI_Update_User_ID]
           ,[AOPHR_Update_Date]=[AOPHRI_Update_Date]
		FROM AOPHospitalReference aphr
		INNER JOIN AOPHospitalReferenceImport aophri 
		ON aophri.AOPHRI_ProductLine_BUM_ID=aphr.AOPHR_ProductLine_BUM_ID
			AND aophri.AOPHRI_Year = aphr.AOPHR_Year AND aophri.AOPHRI_Hospital_ID = aphr.AOPHR_Hospital_ID 
			AND aophri.AOPHRI_PCT_ID=aphr.AOPHR_PCT_ID
		WHERE AOPHRI_Update_User_ID=@UserId
        --插入关联表
		INSERT INTO [interface].[HospitalMarketProperty]
           ([DMSCode]
           ,[MarketProperty]
           ,[Marketlevel]
           ,[DivisionID])
        SELECT AOPHRI_HospitalNbr
			  ,'1'
			  ,'-1'
			  ,AOPHRI_DivisionID
		FROM AOPHospitalReferenceImport
		WHERE AOPHRI_Update_User_ID=@UserId
		AND NOT EXISTS(
			SELECT 1 FROM [interface].[HospitalMarketProperty]
			WHERE DMSCode=AOPHRI_HospitalNbr AND DivisionID=AOPHRI_DivisionID
		)
	END
	
END 



GO


