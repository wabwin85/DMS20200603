USE [GenesisDMS_PRD]
GO
/****** Object:  StoredProcedure [dbo].[GC_Interface_ERPProduct]    Script Date: 2019/12/24 14:19:42 ******/
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
		[PMA_ID][uniqueidentifier] NULL
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
	FROM InterfaceERPProduct
	WHERE [IsProcess]=1

	UPDATE #tmpproductcfn SET CFN_ID = PMA_CFN_ID,PMA_ID=p.PMA_ID
	FROM Product p
	WHERE PMA_UPN=Fspecification
    

	--已存在进行数据更新
	UPDATE c
	SET c.CFN_ChineseName=FName,
	c.CFN_EnglishName=F_SRT_EnglishName,
	--c.CFN_ProductLine_ID = F_SRT_ProductLine
	c.CFN_ERPCode = FNumber,
    c.REGName=F_SRT_RegName,
	c.CFN_LastModifiedBy_USR_UserID='00000000-0000-0000-0000-000000000000',
	c.CFN_LastModifiedDate = GETDATE(),
	c.CFN_Property3 = [FBASEUNITID.FNumber]
	FROM CFN c
	INNER JOIN #tmpproductcfn tmp on c.CFN_ID=tmp.CFN_ID

	UPDATE pdt
	SET pdt.PMA_UnitOfMeasure=[FBASEUNITID.FNumber],
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
		CFN_DeletedFlag
	)
	SELECT NEWID(),
	       F_SRT_EnglishName,
		   FName,
		   0,
		   '',
		   Fspecification,
		   Fspecification,
		   0,
		   [FBASEUNITID.FNumber],
		   1,
		   '正常可售',
		   F_SRT_RegName,
		   FNumber,
		   GETDATE(),
		   0
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
				PMA_CFN_ID
				)
	SELECT NEWID(),
		   Fspecification,
		   [FBASEUNITID.FNumber],
		   1,
		   GETDATE(),
		   '00000000-0000-0000-0000-000000000000',
		   0,
		   cfn.CFN_ID
	FROM  #tmpproductcfn tmp
	INNER JOIN CFN cfn ON tmp.Fspecification=cfn.CFN_CustomerFaceNbr
	WHERE tmp.CFN_ID IS NULL
	--停产产品处理保留
	--UPDATE c
	--SET 
	--c.CFN_Property4 = 0,
	--c.CFN_Property8 = '停售'
	--FROM CFN c
	--INNER JOIN #tmpproductcfn tmp on c.CFN_ID=tmp.CFN_ID
	--WHERE tmp.FIsSale<>'True'

	select top 10 * from cfn
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
	RETURN -1
   END CATCH


