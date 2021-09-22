USE [GenesisDMS_PRD]
GO
/****** Object:  StoredProcedure [dbo].[GC_Interface_ERPProduct]    Script Date: 2020/4/16 10:01:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*
从ERP导入物料
*/
ALTER PROCEDURE [dbo].[GC_Interface_ERPProduct]
AS

	SET  NOCOUNT ON

	BEGIN TRY
	BEGIN TRAN

	create table #tmpproductcfn
	(
		[ID] [uniqueidentifier] NOT NULL,
		[IsProcess] int NOT NULL,
		[ImportDate] [datetime] NULL,
		[ProcessDate] [datetime] NULL,
		[FNumber] [nvarchar](50) NOT NULL,
		[FName] [nvarchar](200) NULL,
		[F_SRT_EnglishName] [nvarchar](200) NULL,
		[FMnemonicCode] [nvarchar](50) NULL,
		[Fspecification] [nvarchar](500) NULL,
		[FBASEUNITID.FNumber] [nvarchar](500) NULL,
		[F_SRT_ProductLine] [nvarchar](50) NULL,
		[F_SRT_RegName] [nvarchar](200) NULL,
		[FModifyDate] [nvarchar](50) NULL,
		[FIsSale] [nvarchar](50) NULL,
		[F_SRT_SourceArea][nvarchar](200) NULL,
		[CFN_ID][uniqueidentifier] NULL,
		[PMA_ID][uniqueidentifier] NULL,
		[FDESCRIPTION] [nvarchar](200) NULL,
		[F_BGP_APPROVALNO] [nvarchar](200) NULL,
		[F_BGP_COMMONNAME] [nvarchar](200) NULL,
		[F_BGP_ORIGIN] [nvarchar](200) NULL,
		[F_BGP_PRODUCTENT] [nvarchar](200) NULL,
		[F_SRT_RegAddress] [nvarchar](200) NULL,
		[F_BGP_GRANTDATE] [nvarchar](200) NULL,
		[F_BGP_PERIODVALIDITY] [nvarchar](200) NULL,
		[F_BGP_BIGCLASS.FNumber] [nvarchar](200) NULL,
		[F_BGP_NUMPACKAGE] [nvarchar](50) NULL,
		[FORDERQTY] [nvarchar](50) NULL,
		[F_BGP_StopPin] [nvarchar](10) NULL,
		[F_SRT_ProductLine1] [nvarchar](200) NULL,
		[F_SRT_ProductLine2] [nvarchar](200) NULL,
		[F_SRT_ProductLine3] [nvarchar](200) NULL,
		[F_SRT_ProductLine4] [nvarchar](200) NULL,
		[F_SRT_ProductLine5] [nvarchar](200) NULL,
		[F_SRT_ProductLineNO1] [nvarchar](200) NULL,
		[F_SRT_ProductLineNO2] [nvarchar](200) NULL,
		[F_SRT_ProductLineNO3] [nvarchar](200) NULL,
		[F_SRT_ProductLineNO4] [nvarchar](200) NULL,
		[F_SRT_ProductLineNO5] [nvarchar](200) NULL
	)
	--先把待处理数据放到临时表中
	update InterfaceERPProduct SET [IsProcess]=1 WHERE [IsProcess]=0

	INSERT INTO #tmpproductcfn(
		[ID],
		[IsProcess],
		[ImportDate],
		[ProcessDate],
		[FNumber],
		[FName],
		[F_SRT_EnglishName],
		[FMnemonicCode],
		[Fspecification],
		[FBASEUNITID.FNumber],
		[F_SRT_ProductLine],
		[F_SRT_RegName],
		[FModifyDate],
		[FIsSale],
		[F_SRT_SourceArea]
		,[FDESCRIPTION]
		,[F_BGP_APPROVALNO]
		  ,[F_BGP_COMMONNAME]
		  ,[F_BGP_ORIGIN]
		  ,[F_BGP_PRODUCTENT]
		  ,F_SRT_RegAddress
		  ,[F_BGP_GRANTDATE]
		  ,[F_BGP_PERIODVALIDITY]
		  ,[F_BGP_BIGCLASS.FNumber]
		  ,[F_BGP_NUMPACKAGE]
		  ,[FORDERQTY]
		  ,[F_BGP_StopPin]
		  ,[F_SRT_ProductLine1]
		  ,[F_SRT_ProductLine2]
		  ,[F_SRT_ProductLine3]
		  ,[F_SRT_ProductLine4]
		  ,[F_SRT_ProductLine5]
		  ,[F_SRT_ProductLineNO1]
		  ,[F_SRT_ProductLineNO2]
		  ,[F_SRT_ProductLineNO3]
		  ,[F_SRT_ProductLineNO4]
		  ,[F_SRT_ProductLineNO5]
	)
	SELECT [ID],
		[IsProcess],
		[ImportDate],
		[ProcessDate],
		[FNumber],
		[FName],
		[F_SRT_EnglishName],
		[FMnemonicCode],
		[Fspecification],
		[FBASEUNITID.FNumber],
		[F_SRT_ProductLine],
		[F_SRT_RegName],
		[FModifyDate],
		[FIsSale],
		[F_SRT_SourceArea]
		,[FDESCRIPTION]
		,[F_BGP_APPROVALNO]
      ,[F_BGP_COMMONNAME]
      ,[F_BGP_ORIGIN]
      ,[F_BGP_PRODUCTENT]
	  ,F_SRT_RegAddress
      ,[F_BGP_GRANTDATE]
      ,[F_BGP_PERIODVALIDITY]
      ,[F_BGP_BIGCLASS.FNumber]
      ,[F_BGP_NUMPACKAGE]
      ,[FORDERQTY]
      ,[F_BGP_StopPin]
      ,[F_SRT_ProductLine1]
      ,[F_SRT_ProductLine2]
      ,[F_SRT_ProductLine3]
      ,[F_SRT_ProductLine4]
      ,[F_SRT_ProductLine5]
	  ,[F_SRT_ProductLineNO1]
	,[F_SRT_ProductLineNO2]
	,[F_SRT_ProductLineNO3]
	,[F_SRT_ProductLineNO4]
	,[F_SRT_ProductLineNO5]
	FROM InterfaceERPProduct
	WHERE [IsProcess]=1

	UPDATE #tmpproductcfn SET CFN_ID = PMA_CFN_ID,PMA_ID=p.PMA_ID
	FROM Product p
	WHERE PMA_UPN=FMnemonicCode
    
	UPDATE #tmpproductcfn SET CFN_ID = c.CFN_ID
	FROM CFN c
	WHERE c.CFN_CustomerFaceNbr=FMnemonicCode

	--已存在进行数据更新
	UPDATE c
	SET c.CFN_ChineseName=FName,
	--c.CFN_EnglishName=F_SRT_EnglishName,
	--c.CFN_ProductLine_ID = F_SRT_ProductLine,
    c.CFN_Description = FDESCRIPTION,	
    c.REGName=F_BGP_APPROVALNO,
	c.CFN_Property2 = CASE F_BGP_StopPin WHEN 'True' THEN 1 ELSE 0 END,
    c.CFN_Property5 = F_SRT_RegNumber,
	c.CFN_Level1Desc = [F_SRT_ProductLine1],
	c.CFN_Level1Code = [F_SRT_ProductLineNO1],
	c.CFN_Level2Desc = [F_SRT_ProductLine2],
	c.CFN_Level2Code = [F_SRT_ProductLineNO2],
	c.CFN_Level3Desc = [F_SRT_ProductLine3],
	c.CFN_Level3Code = [F_SRT_ProductLineNO3],
	c.CFN_Level4Desc = [F_SRT_ProductLine4],
	c.CFN_Level4Code = [F_SRT_ProductLineNO4],
	c.CFN_Level5Desc = [F_SRT_ProductLine5],
	c.CFN_Level5Code = [F_SRT_ProductLineNO5],
	c.CFN_ERPCode = FNumber,
	c.CFN_LastModifiedBy_USR_UserID='00000000-0000-0000-0000-000000000000',
	c.CFN_LastModifiedDate = GETDATE(),
	c.CFN_Property3 = [FBASEUNITID.FNumber]
	FROM CFN c
	INNER JOIN #tmpproductcfn tmp on c.CFN_ID=tmp.CFN_ID

	UPDATE pdt
	SET pdt.PMA_UnitOfMeasure=[FBASEUNITID.FNumber],
	pdt.PMA_PackageFactor = CASE CAST(FORDERQTY AS FLOAT) WHEN 0 THEN NULL ELSE CAST(FORDERQTY AS FLOAT) END,
	pdt.PMA_ConvertFactor = F_BGP_NUMPACKAGE,
	pdt.PMA_LastModifiedBy_USR_UserID='00000000-0000-0000-0000-000000000000',
	pdt.PMA_LastModifiedDate = GETDATE()
	
	FROM Product pdt
	INNER JOIN #tmpproductcfn tmp on pdt.PMA_ID=tmp.PMA_ID

	--不存在插入数据
	INSERT INTO CFN(
		CFN_ID,
		CFN_EnglishName,
		CFN_ChineseName,
		CFN_Implant,
		CFN_Description,
		CFN_CustomerFaceNbr,
		CFN_Property1,
		CFN_Property2,
		CFN_Property3,
		CFN_Property4,
		CFN_Property8,
		REGName,
		CFN_ERPCode,
		CFN_LastModifiedDate,
		CFN_DeletedFlag,
		CFN_Description,
		CFN_Property5,
		CFN_Level1Desc,
		CFN_Level1Code,
		CFN_Level2Desc,
		CFN_Level2Code,
		CFN_Level3Desc,
		CFN_Level3Code,
		CFN_Level4Desc,
		CFN_Level4Code,
		CFN_Level5Desc,
		CFN_Level5Code
	)
	SELECT NEWID(),
	       F_SRT_EnglishName,
		   FName,
		   0,
		   Fspecification,
		   FMnemonicCode,
		   FMnemonicCode,
		   CASE F_BGP_StopPin WHEN 'False' THEN 1 ELSE 0 END,
		   [FBASEUNITID.FNumber],
		   1,
		   '正常可售',
		   F_BGP_APPROVALNO,
		   FNumber,
		   GETDATE(),
		   0,
		   FDESCRIPTION,
		   F_BGP_APPROVALNO,
		   [F_SRT_ProductLine1],
		   F_SRT_ProductLineNO1,
		   [F_SRT_ProductLine2],
		   F_SRT_ProductLineNO2,
		   [F_SRT_ProductLine3],
		   F_SRT_ProductLineNO3,
		   [F_SRT_ProductLine4],
		   F_SRT_ProductLineNO4,
		   [F_SRT_ProductLine5],
		   F_SRT_ProductLineNO5
	FROM #tmpproductcfn 
	WHERE CFN_ID IS NULL

	--插入产品
	INSERT INTO Product(
				PMA_ID,
				PMA_UPN,
				PMA_UnitOfmeasure,
				PMA_ConvertFactor,
				PMA_LastModifiedDate,
				PMA_LastModifiedBy_USR_UserID,
				PMA_DeletedFlag,
				PMA_CFN_ID,
				PMA_PackageFactor
				)
	SELECT NEWID(),
		   Fspecification,
		   [FBASEUNITID.FNumber],
		   F_BGP_NUMPACKAGE,
		   GETDATE(),
		   '00000000-0000-0000-0000-000000000000',
		   0,
		   cfn.CFN_ID,
		   CASE CAST(FORDERQTY AS FLOAT) WHEN 0 THEN NULL ELSE CAST(FORDERQTY AS FLOAT) END
	FROM  #tmpproductcfn tmp
	INNER JOIN CFN cfn ON tmp.Fspecification=cfn.CFN_CustomerFaceNbr
	WHERE tmp.PMA_ID IS NULL
	--停产产品处理保留
	--UPDATE c
	--SET 
	--c.CFN_Property4 = 0,
	--c.CFN_Property8 = '停售'
	--FROM CFN c
	--INNER JOIN #tmpproductcfn tmp on c.CFN_ID=tmp.CFN_ID
	--WHERE tmp.FIsSale<>'True'

	
	

	
	--插入产品注册证
	INSERT INTO MD.INF_REG(BU_ID,
	REG_NO,
	SERIAL_NO,
	GM_KIND,
	GM_CATALOG,
	PRODUCT_NAME,
	MANU_ID,
	MANU_NAME,
	VALID_DATE_FROM,
	VALID_DATE_TO,
	CREATOR,
	CREATED_DATE,
	LAST_MODIFIER,
	LAST_MODIFIED_DATE)
	SELECT 200,
	F_BGP_APPROVALNO,
	F_BGP_APPROVALNO,
	(SELECT TOP 1 VAL FROM dbo.GC_Fn_SplitStringToTable([F_BGP_BIGCLASS.FNumber],'-') WHERE len(VAL)=1),
	(SELECT TOP 1 VAL FROM dbo.GC_Fn_SplitStringToTable([F_BGP_BIGCLASS.FNumber],'-') WHERE len(VAL)>1),
	F_BGP_COMMONNAME,
	1,
	'Boston Scientific Corporation 波士顿科学公司',
	F_BGP_GRANTDATE,
	F_BGP_PERIODVALIDITY,
	'admin',
	GETDATE(),
	'admin',
	GETDATE()
	FROM #tmpproductcfn
	WHERE NOT EXISTS(
		SELECT 1 FROM MD.INF_REG WHERE REG_NO=F_BGP_APPROVALNO
	)

	--插入注册证关联表
	INSERT INTO MD.INF_UPN(SAP_Code,
	REG_NO,
	PRODUCT_NAME,
	MANUFACTORY_ADDRESS,
	MANU_ID,
	MANU_NAME,
	STATE,
	CREATOR,
	CREATED_DATE,
	LAST_MODIFIER,
	LAST_MODIFIED_DATE)
	SELECT FMnemonicCode,
	F_BGP_APPROVALNO,
	F_BGP_COMMONNAME,
	F_SRT_REGADDRESS,
	2,
	'300 Boston Scientific Way, Marlborough, MA 01752, USA',
	10,
	'admin',
	GETDATE(),
	'admin',
	GETDATE()
	FROM #tmpproductcfn
	WHERE NOT EXISTS(
		SELECT 1 FROM MD.INF_UPN WHERE REG_NO=F_BGP_APPROVALNO AND SAP_Code = FMnemonicCode
	)
	
	--最后更新处理时间及状态未已处理
	update InterfaceERPProduct SET [IsProcess]=2,[ProcessDate]=GETDATE() WHERE ID IN(
		SELECT ID FROM #tmpproductcfn
	) 
    COMMIT TRAN

    SET  NOCOUNT OFF
    RETURN 1
   END TRY
   BEGIN CATCH
	SET  NOCOUNT OFF
	ROLLBACK TRAN
	--SET @RtnVal = 'Failure'

	--记录错误日志开始
	DECLARE @error_line   INT
	DECLARE @error_number   INT
	DECLARE @error_message   NVARCHAR (256)
	DECLARE @vError   NVARCHAR (1000)
	SET @error_line = ERROR_LINE ()
	SET @error_number = ERROR_NUMBER ()
	SET @error_message = ERROR_MESSAGE ()
	SET @vError =
			'行'
		+ CONVERT (NVARCHAR (10), @error_line)
		+ '出错[错误号'
		+ CONVERT (NVARCHAR (10), @error_number)
		+ '],'
		+ @error_message
	--SET @RtnMsg = @vError
	SELECT @vError
	RETURN -1
   END CATCH


