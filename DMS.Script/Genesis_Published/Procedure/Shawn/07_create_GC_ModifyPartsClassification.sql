
/****** Object:  StoredProcedure [dbo].[GC_ModifyPartsAuthorization]    Script Date: 2019/12/10 12:59:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
	因为调整授权分类而调整授权
*/
CREATE PROCEDURE [dbo].[GC_ModifyPartsClassification]
	@Name NVARCHAR(200),
	@EnglishName NVARCHAR(200),
	@Id UNIQUEIDENTIFIER,
	@ProductLineId UNIQUEIDENTIFIER,
	@ParentId UNIQUEIDENTIFIER,
	@Description NVARCHAR(200),
	@ParentCode VARCHAR(100),
	@Code VARCHAR(100),
	@ClsNode VARCHAR(100),
	@OpName VARCHAR(100),
	@IsValid NVARCHAR(20) = 'Success' OUTPUT

AS

BEGIN TRY

BEGIN TRAN

IF @OpName = 'Insert'
	BEGIN
		/*根据节点所属分类进行新增*/	
		SET @IsValid = 'Success'
		--分类主结构
		INSERT INTO PartsClassification
        (PCT_Name,PCT_EnglishName,PCT_ID,PCT_ProductLine_BUM_ID,PCT_ParentClassification_PCT_ID,PCT_Description)
        VALUES(@Name,@EnglishName,@Id,@ProductLineId,@ParentId,@Description)
		--合同分类
		IF @ClsNode = 'Contract'
			BEGIN 
				INSERT INTO interface.ClassificationAuthorization
				(CA_ID,CA_ParentCode,CA_Code,CA_NameCN,CA_NameEN,CA_Year,CA_RV1,CA_RV2,CA_RV3,CA_RV4,CA_StartDate,CA_EndDate)
				VALUES
				(@Id,@ParentCode,@Code,@Name,@EnglishName,YEAR(GETDATE()),NULL,NULL,NULL,NULL,CAST(YEAR(GETDATE()) AS VARCHAR)+'-01-01','2099-01-01')
			END
		--授权分类
		ELSE IF @ClsNode = 'Authorization'
			BEGIN 
				INSERT INTO interface.ClassificationQuota
				(CQ_ID,CQ_ParentCode,CQ_Code,CQ_NameCN,CQ_NameEN,CQ_Year,CQ_RV1,CQ_RV2,CQ_RV3,CQ_RV4,CQ_StartDate,CQ_EndDate)
				VALUES
				(@Id,@ParentCode,@Code,@Name,@EnglishName,YEAR(GETDATE()),NULL,NULL,NULL,NULL,CAST(YEAR(GETDATE()) AS VARCHAR)+'-01-01','2099-01-01')
			END

	END
ELSE IF @OpName = 'Update'
	BEGIN
		/*根据节点所属分类进行更新*/		
		SET @IsValid = 'Success'
		--分类主结构
		UPDATE PartsClassification
        SET PCT_Name=@Name, PCT_EnglishName=@EnglishName,PCT_ID=@Id,PCT_ProductLine_BUM_ID=@ProductLineId,PCT_ParentClassification_PCT_ID=@ParentId,PCT_Description=@Description
        WHERE PCT_ID = @Id
		--合同分类
		IF @ClsNode = 'Contract'
			BEGIN 
				UPDATE interface.ClassificationContract SET CC_Code=@Code,CC_NameCN=@Name,CC_NameEN=@EnglishName,CC_RV1=@Name WHERE CC_ID = @Id
			END
		--授权分类
		ELSE IF @ClsNode = 'Authorization'
			BEGIN 
				UPDATE interface.ClassificationAuthorization SET CA_ParentCode=@ParentCode,CA_Code=@Code,CA_NameCN=@Name,CA_NameEN=@EnglishName WHERE CA_ID=@Id
			END
		--指标分类
		ELSE IF @ClsNode = 'Quota'
			BEGIN
				UPDATE interface.ClassificationQuota SET CQ_ParentCode=@ParentCode,CQ_Code=@Code,CQ_NameCN=@Name,CQ_NameEN=@EnglishName WHERE CQ_ID=@Id
			END
		
	END 
ELSE IF @OpName = 'Delete'
	BEGIN 
		/*根据节点所属分类进行删除*/		
		SET @IsValid = 'Success'
		--分类主结构
			DELETE FROM PartsClassification
			WHERE PCT_ID = @Id
		--合同分类
		IF @ClsNode = 'Contract'
			BEGIN 
				DELETE FROM interface.ClassificationContract
				WHERE CC_ID=@Id
			END
		--授权分类
		ELSE IF @ClsNode = 'Authorization'
			BEGIN 
				DELETE FROM interface.ClassificationAuthorization
				WHERE CA_ID=@Id
			END
		--指标分类
		ELSE IF @ClsNode = 'Quota'
			BEGIN
				DELETE FROM interface.ClassificationQuota
				WHERE CQ_ID=@Id
			END

	END 
COMMIT TRAN

SET NOCOUNT OFF
return 1

END TRY

BEGIN CATCH 
    SET NOCOUNT OFF
    ROLLBACK TRAN
    SET @IsValid = 'Failure'
    return -1
    
END CATCH


GO


